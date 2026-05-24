import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:it_asset_management_app/src/config/api_config.dart';
import 'package:it_asset_management_app/src/models/api_response.dart';
import 'package:it_asset_management_app/src/models/asset.dart';
import 'package:it_asset_management_app/src/models/maintenance_log.dart';
import 'package:it_asset_management_app/src/models/user.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  Future<ApiResponse<dynamic>> _decode(http.Response response) async {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<dynamic>(
      success: body['success'] == true,
      message: body['message'] ?? '',
      data: body['data'],
    );
  }

  Future<ApiResponse<AppUser>> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse(ApiConfig.login),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final decoded = await _decode(response);
    if (!decoded.success) {
      return ApiResponse(success: false, message: decoded.message);
    }

    final user = AppUser.fromJson(Map<String, dynamic>.from(decoded.data));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setInt('user_id', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('role', user.role);

    return ApiResponse(success: true, message: decoded.message, data: user);
  }

  Future<ApiResponse<AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse(ApiConfig.register),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': 'staff',
      }),
    );
    final decoded = await _decode(response);
    if (!decoded.success) {
      return ApiResponse(success: false, message: decoded.message);
    }
    return ApiResponse(
      success: true,
      message: decoded.message,
      data: AppUser.fromJson(Map<String, dynamic>.from(decoded.data)),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<ApiResponse<List<Asset>>> getAssets({
    String search = '',
    String department = '',
    String assetType = '',
    String status = '',
  }) async {
    final query = <String, String>{};
    if (search.isNotEmpty) {
      query['search'] = search;
    }
    if (department.isNotEmpty) {
      query['department'] = department;
    }
    if (assetType.isNotEmpty) {
      query['asset_type'] = assetType;
    }
    if (status.isNotEmpty) {
      query['status'] = status;
    }
    final uri = ApiConfig.assetsIndexUri.replace(
      queryParameters: query.isEmpty ? null : query,
    );
    final decoded = await _decode(await _client.get(uri));
    if (!decoded.success) {
      return ApiResponse(success: false, message: decoded.message);
    }
    final assets = (decoded.data as List)
        .map((item) => Asset.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    return ApiResponse(success: true, message: decoded.message, data: assets);
  }

  Future<ApiResponse<List<String>>> getDepartments() async {
    final decoded = await _decode(
      await _client.get(Uri.parse(ApiConfig.assetDepartments)),
    );
    if (!decoded.success) {
      return ApiResponse(success: false, message: decoded.message);
    }
    final departments = (decoded.data as List)
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList();
    return ApiResponse(
      success: true,
      message: decoded.message,
      data: departments,
    );
  }

  Future<ApiResponse<Asset>> getAsset(int id) async {
    final decoded = await _decode(
      await _client.get(Uri.parse(ApiConfig.assetShow(id))),
    );
    if (!decoded.success) {
      return ApiResponse(success: false, message: decoded.message);
    }
    return ApiResponse(
      success: true,
      message: decoded.message,
      data: Asset.fromJson(Map<String, dynamic>.from(decoded.data)),
    );
  }

  Future<ApiResponse<dynamic>> createAsset(Asset asset) async {
    final response = await _client.post(
      Uri.parse(ApiConfig.assetCreate),
      headers: _headers,
      body: jsonEncode(asset.toJson()),
    );
    return _decode(response);
  }

  Future<ApiResponse<dynamic>> updateAsset(Asset asset) async {
    final response = await _client.post(
      Uri.parse(ApiConfig.assetUpdate),
      headers: _headers,
      body: jsonEncode(asset.toJson()),
    );
    return _decode(response);
  }

  Future<ApiResponse<dynamic>> deleteAsset(int id) async {
    final response = await _client.post(
      Uri.parse(ApiConfig.assetDelete),
      headers: _headers,
      body: jsonEncode({'id': id}),
    );
    return _decode(response);
  }

  Future<ApiResponse<List<MaintenanceLog>>> getMaintenanceLogs(
    int assetId,
  ) async {
    final decoded = await _decode(
      await _client.get(Uri.parse(ApiConfig.maintenanceIndex(assetId))),
    );
    if (!decoded.success) {
      return ApiResponse(success: false, message: decoded.message);
    }
    final logs = (decoded.data as List)
        .map((item) => MaintenanceLog.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    return ApiResponse(success: true, message: decoded.message, data: logs);
  }

  Future<ApiResponse<dynamic>> createMaintenance(MaintenanceLog log) async {
    final response = await _client.post(
      Uri.parse(ApiConfig.maintenanceCreate),
      headers: _headers,
      body: jsonEncode(log.toJson()),
    );
    return _decode(response);
  }

  Future<ApiResponse<dynamic>> updateMaintenance(MaintenanceLog log) async {
    final response = await _client.post(
      Uri.parse(ApiConfig.maintenanceUpdate),
      headers: _headers,
      body: jsonEncode(log.toJson()),
    );
    return _decode(response);
  }

  Future<ApiResponse<dynamic>> deleteMaintenance(int id) async {
    final response = await _client.post(
      Uri.parse(ApiConfig.maintenanceDelete),
      headers: _headers,
      body: jsonEncode({'id': id}),
    );
    return _decode(response);
  }
}
