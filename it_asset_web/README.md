# IT Asset Web

PHP web UI สำหรับใช้งานกับฐานข้อมูลเดียวกับ `it_asset_api`

## Local XAMPP

วางโฟลเดอร์นี้ไว้ที่:

```text
C:\xampp\htdocs\it_asset_web
```

เปิด:

```text
http://localhost/it_asset_web
```

## InfinityFree

อัปโหลดโฟลเดอร์นี้ไปไว้ใน `htdocs/it_asset_web`

แก้ไฟล์:

```text
it_asset_web/config/app.php
```

ใส่ค่า MySQL ของ InfinityFree:

```php
$dbHost = 'sqlXXX.infinityfree.com';
$dbName = 'if0_xxxxx_it_asset_management';
$dbUser = 'if0_xxxxx';
$dbPass = 'your_mysql_password';
```

เปิดเว็บ:

```text
https://your-domain.infinityfree.me/it_asset_web
```

บัญชีเริ่มต้น:

```text
admin@example.com / password
staff@example.com / password
```
