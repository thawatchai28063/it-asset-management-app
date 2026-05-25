# IT Asset Management App

Mobile app สำหรับจัดการทรัพย์สิน IT พร้อม PHP REST API และ MySQL database

## Project Structure

```text
it_asset_api/
  database.sql
  config/
    database.php
  api/
    login.php
    register.php
    assets/
    maintenance/

it_asset_management_app/
  pubspec.yaml
  lib/
    main.dart
    src/
      config/
      models/
      services/
      features/
      shared/

it_asset_web/
  config/
  partials/
  assets/
  index.php
  assets.php
  asset_form.php
  asset_detail.php
  maintenance.php
```

## Features

- Register, Login, Logout
- Dashboard summary
- Asset CRUD
- Asset search
- Barcode / IT tag scan
- Department and asset type filters
- Maintenance history CRUD
- Shared API config in one file
- PHP web UI using the same MySQL database

## Backend Setup With XAMPP

1. Start `Apache` and `MySQL` in XAMPP.
2. Copy `it_asset_api` to:

```text
C:\xampp\htdocs\it_asset_api
```

3. Open phpMyAdmin:

```text
http://localhost/phpmyadmin
```

4. Import:

```text
it_asset_api/database.sql
```

5. Check API:

```text
http://localhost/it_asset_api/api/assets/index.php
```

## Test Accounts

```text
admin@example.com / password
staff@example.com / password
```

## Flutter Setup

```powershell
cd it_asset_management_app
flutter pub get
flutter run
```

API URL is configured in:

```text
it_asset_management_app/lib/src/config/api_config.dart
```

For a real Android phone on the same LAN, update:

```dart
static const String mobileBaseUrl = 'http://YOUR_COMPUTER_IP/it_asset_api/api';
```

## Build APK

```powershell
cd it_asset_management_app
flutter build apk --release
```

APK output:

```text
it_asset_management_app/build/app/outputs/flutter-apk/app-release.apk
```

## API Examples

Login:

```http
POST http://localhost/it_asset_api/api/login.php
Content-Type: application/json
```

```json
{
  "email": "admin@example.com",
  "password": "password"
}
```

List assets:

```http
GET http://localhost/it_asset_api/api/assets/index.php
```

Search assets:

```http
GET http://localhost/it_asset_api/api/assets/index.php?search=IT250001
```

Show asset:

```http
GET http://localhost/it_asset_api/api/assets/show.php?id=1
```

Maintenance logs:

```http
GET http://localhost/it_asset_api/api/maintenance/index.php?asset_id=1
```

## Notes

- Do not commit real Excel exports or production SQL dumps.
- Keep MySQL access private. Mobile apps should call PHP API only.
- For local XAMPP usage, keep both Apache and MySQL running.

## PHP Web UI

Copy the web folder to XAMPP:

```text
C:\xampp\htdocs\it_asset_web
```

Open:

```text
http://localhost/it_asset_web
```

For InfinityFree, upload `it_asset_web` to:

```text
htdocs/it_asset_web
```

Then edit:

```text
it_asset_web/config/app.php
```

Use the MySQL host, database, username, and password from InfinityFree. The PHP web UI, PHP REST API, and Flutter app can all use the same `users`, `assets`, and `maintenance_logs` tables.
