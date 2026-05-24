# IT Asset Management App

โปรเจกต์นี้มี 2 ส่วน:

- `it_asset_api` คือ PHP RESTful API สำหรับวางใน `C:\xampp\htdocs\it_asset_api`
- `it_asset_management_app` คือ Flutter mobile app

## Folder Structure

```text
it_asset_api/
  database.sql
  config/
    database.php
  api/
    register.php
    login.php
    assets/
      index.php
      show.php
      create.php
      update.php
      delete.php
    maintenance/
      index.php
      create.php
      update.php
      delete.php

it_asset_management_app/
  pubspec.yaml
  lib/
    main.dart
    models/
    services/
    screens/
    widgets/
```

## Install Backend On XAMPP

1. เปิด XAMPP Control Panel
2. Start `Apache` และ `MySQL`
3. คัดลอกโฟลเดอร์ `it_asset_api` ไปไว้ที่:

```text
C:\xampp\htdocs\it_asset_api
```

4. เปิด phpMyAdmin:

```text
http://localhost/phpmyadmin
```

5. Import ไฟล์:

```text
it_asset_api/database.sql
```

ไฟล์นี้จะสร้างฐานข้อมูล `it_asset_management` พร้อมตาราง `users`, `assets`, `maintenance_logs` และ seed assets 10 รายการ

บัญชีทดสอบ:

```text
admin@example.com / password
staff@example.com / password
```

## Run Flutter

เข้าโฟลเดอร์แอพ:

```powershell
cd it_asset_management_app
flutter pub get
flutter run
```

โปรเจกต์นี้มีโฟลเดอร์ `android`, `ios`, และ `web` แล้ว สามารถรันต่อได้ทันทีหลัง `flutter pub get`

ค่า API อยู่ที่ `lib/services/api_service.dart`

```dart
static String get baseUrl {
  const definedUrl = String.fromEnvironment('API_BASE_URL');
  if (definedUrl.isNotEmpty) {
    return definedUrl;
  }
  return kIsWeb
      ? 'http://localhost/it_asset_api/api'
      : 'http://172.24.13.204/it_asset_api/api';
}
```

ระบบตั้งค่าให้ใช้ `localhost` เมื่อรัน Flutter Web และใช้ IP เครื่องคอมเมื่อรันบนมือถือจริง

ถ้าทดสอบบน Android Emulator ให้สั่งรันแบบนี้:

```powershell
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2/it_asset_api/api
```

## Postman Examples

### Register

POST `http://localhost/it_asset_api/api/register.php`

```json
{
  "name": "New User",
  "email": "newuser@example.com",
  "password": "password123",
  "role": "staff"
}
```

Response:

```json
{
  "success": true,
  "message": "Register successful",
  "data": {
    "id": 3,
    "name": "New User",
    "email": "newuser@example.com",
    "role": "staff"
  }
}
```

### Login

POST `http://localhost/it_asset_api/api/login.php`

```json
{
  "email": "admin@example.com",
  "password": "password"
}
```

### List Assets

GET `http://localhost/it_asset_api/api/assets/index.php`

Search:

GET `http://localhost/it_asset_api/api/assets/index.php?search=laptop`

### Show Asset

GET `http://localhost/it_asset_api/api/assets/show.php?id=1`

### Create Asset

POST `http://localhost/it_asset_api/api/assets/create.php`

```json
{
  "asset_name": "MacBook Pro 14",
  "asset_type": "Laptop",
  "serial_number": "MBP-014-011",
  "ip_address": "192.168.1.90",
  "department": "Design",
  "status": "in_use",
  "assigned_user": "Arisa",
  "position": "FE Line 4",
  "purchase_date": "2026-05-21",
  "note": "Design workstation"
}
```

### Update Asset

POST `http://localhost/it_asset_api/api/assets/update.php`

```json
{
  "id": 1,
  "asset_name": "Dell Latitude 5440",
  "asset_type": "Laptop",
  "serial_number": "DL-5440-001",
  "ip_address": "192.168.1.21",
  "department": "IT",
  "status": "repair",
  "assigned_user": "Somchai",
  "position": "IT Office",
  "purchase_date": "2024-01-15",
  "note": "Sent to repair"
}
```

### Delete Asset

POST `http://localhost/it_asset_api/api/assets/delete.php`

```json
{
  "id": 1
}
```

### List Maintenance Logs

GET `http://localhost/it_asset_api/api/maintenance/index.php?asset_id=1`

### Create Maintenance Log

POST `http://localhost/it_asset_api/api/maintenance/create.php`

```json
{
  "asset_id": 1,
  "problem": "Cannot connect Wi-Fi",
  "solution": "Reinstalled network driver",
  "repair_by": "Niran",
  "repair_date": "2026-05-21",
  "status": "completed"
}
```

### Update Maintenance Log

POST `http://localhost/it_asset_api/api/maintenance/update.php`

```json
{
  "id": 1,
  "asset_id": 1,
  "problem": "Battery drains quickly",
  "solution": "Replaced battery",
  "repair_by": "Niran",
  "repair_date": "2026-05-21",
  "status": "completed"
}
```

### Delete Maintenance Log

POST `http://localhost/it_asset_api/api/maintenance/delete.php`

```json
{
  "id": 1
}
```

## API Response Format

ทุก endpoint ส่ง JSON รูปแบบเดียวกัน:

```json
{
  "success": true,
  "message": "Assets loaded",
  "data": []
}
```
