import 'package:flutter/foundation.dart';

/// Central API configuration for the whole app.
///
/// When the PHP API server changes, edit this file only.
/// You can also override the base URL at build/run time:
///
/// flutter run --dart-define=API_BASE_URL=http://YOUR_IP/it_asset_api/api
/// flutter build apk --dart-define=API_BASE_URL=http://YOUR_IP/it_asset_api/api
class ApiConfig {
  const ApiConfig._();

  // ---------------------------------------------------------------------------
  // Base URLs
  // ---------------------------------------------------------------------------

  /// Local XAMPP API for Flutter Web on this computer.
  static const String webBaseUrl = 'http://localhost/it_asset_api/api';

  /// Local XAMPP API for real Android phones on the same Wi-Fi/LAN.
  /// Change this IP if this computer gets a new IPv4 address.
  static const String mobileBaseUrl = 'http://172.24.13.204/it_asset_api/api';

  /// Optional build-time override.
  /// If API_BASE_URL is provided, it has the highest priority.
  static const String _definedBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Final base URL used by all services.
  static String get baseUrl {
    if (_definedBaseUrl.isNotEmpty) {
      return _definedBaseUrl;
    }
    return kIsWeb ? webBaseUrl : mobileBaseUrl;
  }

  // ---------------------------------------------------------------------------
  // Auth endpoints
  // ---------------------------------------------------------------------------

  static String get login => '$baseUrl/login.php';
  static String get register => '$baseUrl/register.php';

  // ---------------------------------------------------------------------------
  // Asset endpoints
  // ---------------------------------------------------------------------------

  static String get assetsIndex => '$baseUrl/assets/index.php';
  static String get assetDepartments => '$baseUrl/assets/departments.php';
  static Uri get assetsIndexUri => Uri.parse(assetsIndex);
  static String assetShow(int id) => '$baseUrl/assets/show.php?id=$id';
  static String get assetCreate => '$baseUrl/assets/create.php';
  static String get assetUpdate => '$baseUrl/assets/update.php';
  static String get assetDelete => '$baseUrl/assets/delete.php';

  // ---------------------------------------------------------------------------
  // Maintenance endpoints
  // ---------------------------------------------------------------------------

  static String maintenanceIndex(int assetId) =>
      '$baseUrl/maintenance/index.php?asset_id=$assetId';
  static String get maintenanceCreate => '$baseUrl/maintenance/create.php';
  static String get maintenanceUpdate => '$baseUrl/maintenance/update.php';
  static String get maintenanceDelete => '$baseUrl/maintenance/delete.php';
}
