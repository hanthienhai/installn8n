#!/bin/bash

# Kiểm tra xem script có được chạy với quyền root không
if [[ $EUID -ne 0 ]]; then
  echo "This script needs to be run with root privileges" 
  exit 1
fi

# Hàm kiểm tra domain
check_domain() {
   local domain=$1
   local server_ip=$(curl -s https://api.ipify.org)
   local domain_ip=$(dig +short $domain)

   if [ "$domain_ip" = "$server_ip" ]; then
       return 0  # Domain đã trỏ đúng
   else
       return 1  # Domain chưa trỏ đúng
   fi
}

# Nhận input domain từ người dùng
read -p "Enter your domain or subdomain: " DOMAIN

# Kiểm tra domain
if check_domain $DOMAIN; then
   echo "Domain $DOMAIN has been correctly pointed to this server. Continuing installation"
else
   echo "Domain $DOMAIN has not been pointed to this server."
   echo "Please update your DNS record to point $DOMAIN to IP $(curl -s https://api.ipify.org)"
   echo "After updating the DNS, run this script again"
   exit 1
fi

# Sử dụng thư mục /home trực tiếp
N8N_DIR="/home/n8n"

# Cài đặt Docker và Docker Compose
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

# Backup check
BACKUP_DIR="/home/n8n_backup"
if [ -d "$N8N_DIR" ]; then
   echo "Backing up existing n8n directory"
   mkdir -p $BACKUP_DIR
   cp -r $N8N_DIR $BACKUP_DIR/n8n_$(date +%Y%m%d_%H%M%S)
fi

# Tạo thư mục cho n8n
mkdir -p $N8N_DIR

# Tạo file docker-compose.yml
cat << EOF > $N8N_DIR/docker-compose.yml
version: "3"
services:
 n8n:
   image: n8nio/n8n
   restart: always
   ports:
     - "5678:5678"
   environment:
     - N8N_HOST=${DOMAIN}
     - N8N_PORT=5678
     - N8N_PROTOCOL=https
     - NODE_ENV=production
     - WEBHOOK_URL=https://${DOMAIN}
     - GENERIC_TIMEZONE=Asia/Ho_Chi_Minh
   volumes:
     - $N8N_DIR:/home/node/.n8n
   healthcheck:
     test: ["CMD", "curl", "-f", "http://localhost:5678"]
     interval: 30s
     timeout: 10s
     retries: 3
     start_period: 40s
   logging:
     driver: "json-file"
     options:
       max-size: "10m"
       max-file: "3"

 caddy:
   image: caddy:2
   restart: always
   ports:
     - "80:80"
     - "443:443"
   volumes:
     - $N8N_DIR/Caddyfile:/etc/caddy/Caddyfile
     - caddy_data:/data
     - caddy_config:/config
   depends_on:
     - n8n

volumes:
 caddy_data:
 caddy_config:
EOF

# Tạo file Caddyfile
cat << EOF > $N8N_DIR/Caddyfile
${DOMAIN} {
   reverse_proxy n8n:5678
}
EOF

# Đặt quyền cho thư mục n8n
chown -R 1000:1000 $N8N_DIR
chmod -R 755 $N8N_DIR

# Khởi động các container
cd $N8N_DIR
docker-compose up -d

echo "n8n đã được cài đặt và cấu hình với SSL sử dụng Caddy. Truy cập https://${DOMAIN} để sử dụng."
echo "Các file cấu hình và dữ liệu được lưu trong $N8N_DIR"
