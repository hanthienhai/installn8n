# Script cài đặt n8n trên Ubuntu với Docker và Caddy

Script tự động cài đặt n8n với Docker và Caddy reverse proxy có SSL.

## Nguồn & Cải tiến

Script được tối ưu từ [script của MeCode](https://mecode.pro/cai-n8n-trong-2-phut-chi-1-cau-lenh/) với sự hỗ trợ của Claude.

### Cải tiến chính
- Tự động backup khi phát hiện cài đặt cũ
- Kiểm tra health container mỗi 30s  
- Giới hạn log 10MB/file, giữ 3 file

### Lý do cải tiến

#### 1. Backup Check
- Tránh mất dữ liệu khi cài đặt ghi đè
- Phục hồi nhanh nếu có lỗi

#### 2. Health Check
- Phát hiện sớm container bị lỗi/crash
- Tự động restart khi cần
- Giám sát tài nguyên sử dụng

#### 3. Logging
- Debug lỗi dễ dàng hơn
- Theo dõi performance
- Phát hiện các vấn đề bảo mật

### Thông số kỹ thuật

#### Health Check
- Interval 30s: Đủ thời gian phát hiện lỗi, không tạo quá nhiều request
- Timeout 10s: Thời gian xác định service không phản hồi
- Retries 3: Tránh false positive từ lỗi tạm thời
- Start period 40s: Thời gian cho container khởi động

#### Logging
- 10MB/file: Đủ lưu thông tin debug quan trọng
- 3 files: Cân bằng giữa lịch sử và disk space
- Tổng dung lượng tối đa: 30MB

> **Lưu ý**: Các thông số có thể điều chỉnh theo nhu cầu sử dụng và tài nguyên server.

### Lưu ý khi dùng Cloudflare

1. **Trước khi cài đặt**: Tắt proxy Cloudflare (chuyển biểu tượng đám mây từ màu cam sang xám) để script kiểm tra được IP VPS chính xác.

2. **Sau khi cài đặt xong**: Có thể bật lại proxy Cloudflare (biểu tượng đám mây màu cam).

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
