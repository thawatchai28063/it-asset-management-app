import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:it_asset_management_app/src/models/asset.dart';
import 'package:it_asset_management_app/src/services/api_service.dart';
import 'package:it_asset_management_app/src/shared/widgets/animated_app_icon.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_alerts.dart';
import 'package:it_asset_management_app/src/features/assets/screens/asset_detail_screen.dart';
import 'package:it_asset_management_app/src/features/assets/screens/asset_list_screen.dart';
import 'package:it_asset_management_app/src/features/assets/screens/asset_summary_screen.dart';
import 'package:it_asset_management_app/src/features/assets/screens/barcode_scanner_screen.dart';
import 'package:it_asset_management_app/src/features/auth/screens/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _api = ApiService();
  bool _loading = true;
  List<Asset> _assets = [];

  @override
  void initState() {
    super.initState();
    _checkLoginAndLoad();
  }

  Future<void> _checkLoginAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    if (!mounted) return;
    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }
    await _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final response = await _api.getAssets();
    setState(() {
      _loading = false;
      _assets = response.data ?? [];
    });
  }

  Future<void> _logout() async {
    final confirm = await showConfirmAlert(
      context,
      title: 'ยืนยันการออกจากระบบ',
      message: 'ต้องการล็อกเอ้าออกจากระบบใช่ไหม?',
      confirmText: 'ล็อกเอ้า',
    );
    if (!confirm) return;
    await _api.logout();
    if (!mounted) return;
    await showAppAlert(
      context,
      title: 'ล็อกเอ้าสำเร็จ',
      message: 'ออกจากระบบเรียบร้อยแล้ว',
    );
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  int _count(String status) =>
      _assets.where((asset) => asset.status == status).length;

  Future<void> _openAssets({
    String status = '',
    String title = 'Assets',
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssetListScreen(
          initialStatus: status,
          title: title,
        ),
      ),
    );
    _load();
  }

  Future<void> _openDetail(Asset asset) async {
    if (asset.id == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AssetDetailScreen(assetId: asset.id!)),
    );
    _load();
  }

  Future<void> _scanItTag() async {
    final scannedValue = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );
    if (!mounted || scannedValue == null || scannedValue.trim().isEmpty) {
      return;
    }

    final itTag = scannedValue.trim();
    setState(() => _loading = true);

    final response = await _api.getAssets(search: itTag);
    if (!mounted) return;

    final assets = response.data ?? [];
    final exactMatches = assets.where((asset) {
      final tag = asset.itTag?.trim().toLowerCase();
      return tag != null && tag == itTag.toLowerCase();
    }).toList();

    setState(() {
      _loading = false;
      if (response.success) {
        _assets = assets;
      }
    });

    final assetToOpen = exactMatches.isNotEmpty
        ? exactMatches.first
        : (assets.length == 1 ? assets.first : null);
    if (assetToOpen != null) {
      await _openDetail(assetToOpen);
      return;
    }

    await showAppAlert(
      context,
      title: 'ไม่พบ IT Tag',
      message: 'ไม่พบอุปกรณ์จากบาร์โค้ด: $itTag',
      success: false,
    );
  }

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              AnimatedAppIcon(icon: icon, color: color, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboardSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade800,
            ),
      ),
    );
  }

  Widget _menuButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              PrettyIconBadge(icon: icon, color: color, size: 46),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: _logout,
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade700,
            ),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _dashboardSection('Overview'),
                  _summaryCard(
                    'Total assets',
                    _assets.length.toString(),
                    Icons.inventory_2,
                    Colors.indigo,
                    onTap: () => _openAssets(title: 'Total assets'),
                  ),
                  _summaryCard(
                    'Available',
                    _count('available').toString(),
                    Icons.check_circle,
                    Colors.teal,
                    onTap: () => _openAssets(
                      status: 'available',
                      title: 'Available assets',
                    ),
                  ),
                  _summaryCard(
                    'In use',
                    _count('in_use').toString(),
                    Icons.person_pin_circle,
                    Colors.blue,
                    onTap: () => _openAssets(
                      status: 'in_use',
                      title: 'In use assets',
                    ),
                  ),
                  _summaryCard(
                    'Repair',
                    _count('repair').toString(),
                    Icons.build,
                    Colors.orange,
                    onTap: () => _openAssets(
                      status: 'repair',
                      title: 'Repair assets',
                    ),
                  ),
                  _summaryCard(
                    'Retired',
                    _count('retired').toString(),
                    Icons.archive,
                    Colors.grey,
                    onTap: () => _openAssets(
                      status: 'retired',
                      title: 'Retired assets',
                    ),
                  ),
                  _dashboardSection('Explore'),
                  _menuButton(
                    label: 'Scan IT tag',
                    icon: Icons.qr_code_scanner,
                    color: Colors.teal,
                    onPressed: _scanItTag,
                  ),
                  const SizedBox(height: 10),
                  _menuButton(
                    label: 'View by asset type',
                    icon: Icons.category,
                    color: Colors.deepPurple,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AssetSummaryScreen(
                            assets: _assets,
                            mode: AssetSummaryMode.type,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _menuButton(
                    label: 'View by department',
                    icon: Icons.apartment,
                    color: Colors.indigo,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AssetSummaryScreen(
                            assets: _assets,
                            mode: AssetSummaryMode.department,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AssetListScreen(),
                        ),
                      );
                      _load();
                    },
                    icon: const Icon(Icons.list),
                    label: const Text('View all assets'),
                  ),
                ],
              ),
      ),
    );
  }
}
