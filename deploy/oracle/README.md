# Oracle Cloud Deploy - IT Asset Management API

คู่มือนี้สำหรับย้าย PHP REST API + MySQL ไปใช้งานบน Oracle Cloud Always Free VPS

## 1. สร้าง VM บน Oracle Cloud

เลือกค่าประมาณนี้:

- Image: Ubuntu 24.04 หรือ Ubuntu 22.04
- Shape: VM.Standard.A1.Flex
- OCPU/RAM: 1 OCPU, 6 GB RAM ก็พอสำหรับเริ่มใช้งาน
- Public IP: เปิดใช้งาน
- SSH key: ดาวน์โหลด private key เก็บไว้

Oracle Always Free ระบุว่า Ampere A1 ใช้ได้ภายใต้โควตา Always Free รวมสูงสุด 4 OCPU และ 24 GB RAM ต่อ tenancy

## 2. เปิด Port ใน Oracle Security List

เพิ่ม Ingress Rules:

- TCP 22 จาก IP ของเรา หรือ 0.0.0.0/0 สำหรับ SSH
- TCP 80 จาก 0.0.0.0/0 สำหรับ HTTP API
- TCP 443 จาก 0.0.0.0/0 สำหรับ HTTPS ในอนาคต

## 3. เข้า SSH

```bash
ssh -i your_private_key.key ubuntu@YOUR_ORACLE_PUBLIC_IP
```

## 4. ติดตั้ง Apache, PHP, MySQL

รันคำสั่งใน VM:

```bash
sudo apt update
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql unzip
sudo systemctl enable apache2
sudo systemctl enable mysql
sudo systemctl restart apache2
```

เปิด port ใน firewall ของเครื่อง VM:

```bash
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
sudo apt install -y iptables-persistent
sudo netfilter-persistent save
```

## 5. สร้าง Database และ User

```bash
sudo mysql
```

ใน MySQL:

```sql
CREATE DATABASE it_asset_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'itasset_user'@'localhost' IDENTIFIED BY 'CHANGE_THIS_STRONG_PASSWORD';
GRANT ALL PRIVILEGES ON it_asset_management.* TO 'itasset_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## 6. อัปโหลดไฟล์ API และ SQL

จากเครื่อง Windows ให้ส่งไฟล์ขึ้น VM:

```powershell
scp -i your_private_key.key it_asset_api_oracle.zip ubuntu@YOUR_ORACLE_PUBLIC_IP:/tmp/
scp -i your_private_key.key it_asset_management_import_phpmyadmin.sql ubuntu@YOUR_ORACLE_PUBLIC_IP:/tmp/
```

บน VM:

```bash
sudo unzip /tmp/it_asset_api_oracle.zip -d /var/www/html/
sudo chown -R www-data:www-data /var/www/html/it_asset_api
sudo mysql it_asset_management < /tmp/it_asset_management_import_phpmyadmin.sql
```

## 7. แก้ config/database.php บน VM

```bash
sudo nano /var/www/html/it_asset_api/config/database.php
```

แก้ส่วนนี้:

```php
$host = 'localhost';
$dbName = 'it_asset_management';
$username = 'itasset_user';
$password = 'CHANGE_THIS_STRONG_PASSWORD';
```

## 8. ทดสอบ API

เปิดใน browser:

```text
http://YOUR_ORACLE_PUBLIC_IP/it_asset_api/api/assets/index.php
```

ถ้าเห็น JSON แปลว่า API พร้อมใช้

## 9. แก้ Flutter API URL

ไฟล์:

```text
it_asset_management_app/lib/src/config/api_config.dart
```

เปลี่ยนเป็น:

```dart
static const String webBaseUrl =
    'http://YOUR_ORACLE_PUBLIC_IP/it_asset_api/api';

static const String mobileBaseUrl =
    'http://YOUR_ORACLE_PUBLIC_IP/it_asset_api/api';
```

จากนั้น build และติดตั้งใหม่:

```bash
flutter build apk --release
flutter install -d UWY9BMVWPZDMHEMR --release
```

## หมายเหตุความปลอดภัย

- อย่าเปิด MySQL port 3306 ออก internet
- ใช้ Public IP เฉพาะ Apache port 80/443
- ตั้งรหัสผ่าน MySQL ให้แข็งแรง
- ควรทำ backup SQL เป็นประจำ
- ถ้ามี domain ภายหลัง ให้ติดตั้ง SSL ด้วย Let's Encrypt แล้วเปลี่ยน API เป็น HTTPS
