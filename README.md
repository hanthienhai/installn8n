# Script Cài Đặt n8n Docker

Script tự động cài đặt n8n với Docker và Caddy reverse proxy có SSL.

## Yêu Cầu
- Server Ubuntu
- Domain/subdomain đã trỏ về server
- Quyền root

## Tính Năng
- SSL tự động với Caddy
- Kiểm tra sức khỏe container
- Xoay vòng log
- Backup tự động
- Xác thực domain

## Cách Sử Dụng
```bash
wget https://raw.githubusercontent.com/yourusername/repo/main/install_n8n.sh
chmod +x install_n8n.sh
sudo ./install_n8n.sh
