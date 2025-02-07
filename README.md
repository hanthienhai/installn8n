# Script cài đặt n8n trên Ubuntu với Docker và Caddy

Script tự động cài đặt n8n với Docker và Caddy reverse proxy có SSL.

## Yêu cầu
- Server Ubuntu
- Domain/subdomain đã trỏ về server
- Quyền root

## Tính năng
- SSL tự động với Caddy
- Kiểm tra sức khỏe container
- Xoay vòng log
- Backup tự động
- Xác thực domain

## Cách sử dụng
```bash
wget https://raw.githubusercontent.com/hanthienhai/installn8n/main/install-n8n.sh
chmod +x install-n8n.sh
sudo ./install-n8n.sh
