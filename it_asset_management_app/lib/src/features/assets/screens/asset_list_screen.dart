import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/models/asset.dart';
import 'package:it_asset_management_app/src/services/api_service.dart';
import 'package:it_asset_management_app/src/shared/widgets/animated_app_icon.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_dropdown.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_alerts.dart';
import 'package:it_asset_management_app/src/shared/widgets/asset_card.dart';
import 'package:it_asset_management_app/src/features/assets/screens/add_asset_screen.dart';
import 'package:it_asset_management_app/src/features/assets/screens/asset_detail_screen.dart';
import 'package:it_asset_management_app/src/features/assets/screens/barcode_scanner_screen.dart';
import 'package:it_asset_management_app/src/features/assets/screens/edit_asset_screen.dart';
import 'package:it_asset_management_app/src/features/maintenance/screens/maintenance_history_screen.dart';

class AssetListScreen extends StatefulWidget {
  const AssetListScreen({
    super.key,
    this.initialDepartment = '',
    this.initialAssetType = '',
    this.initialStatus = '',
    this.title = 'Assets',
  });

  final String initialDepartment;
  final String initialAssetType;
  final String initialStatus;
  final String title;

  @override
  State<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  final _api = ApiService();
  final _search = TextEditingController();
  bool _loading = true;
  List<Asset> _assets = [];
  List<String> _departments = [];
  late String _selectedDepartment;
  late String _selectedAssetType;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedDepartment = widget.initialDepartment;
    _selectedAssetType = widget.initialAssetType;
    _selectedStatus = widget.initialStatus;
    _loadDepartments();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final response = await _api.getAssets(
      search: _search.text.trim(),
      department: _selectedDepartment,
      assetType: _selectedAssetType,
      status: _selectedStatus,
    );
    setState(() {
      _loading = false;
      _assets = response.data ?? [];
    });
  }

  Future<void> _loadDepartments() async {
    final response = await _api.getDepartments();
    if (!mounted || !response.success) return;
    final departments = [...?response.data];
    if (_selectedDepartment.isNotEmpty &&
        !departments.contains(_selectedDepartment)) {
      departments.add(_selectedDepartment);
    }
    setState(() => _departments = departments);
  }

  Future<void> _delete(Asset asset) async {
    final confirm = await showConfirmAlert(
      context,
      title: 'ยืนยันการลบอุปกรณ์',
      message: 'ต้องการลบ ${asset.assetName} ใช่ไหม?',
      confirmText: 'ลบ',
    );
    if (!confirm || asset.id == null) return;
    final response = await _api.deleteAsset(asset.id!);
    if (!mounted) return;
    await showAppAlert(
      context,
      title: response.success ? 'ลบอุปกรณ์สำเร็จ' : 'ลบอุปกรณ์ไม่สำเร็จ',
      message: response.message,
      success: response.success,
    );
    if (!mounted) return;
    _load();
  }

  Future<void> _openAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddAssetScreen()),
    );
    _load();
  }

  Future<void> _openEdit(Asset asset) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditAssetScreen(asset: asset)),
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

  Future<void> _openMaintenance(Asset asset) async {
    if (asset.id == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MaintenanceHistoryScreen(asset: asset)),
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
    _search.text = itTag;
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
      _assets = assets;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    labelText: 'Search assets',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Scan IT Tag',
                          onPressed: _scanItTag,
                          icon: const Icon(Icons.qr_code_scanner),
                        ),
                        IconButton(
                          tooltip: 'Search',
                          onPressed: _load,
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ),
                  onSubmitted: (_) => _load(),
                ),
                const SizedBox(height: 12),
                AppDropdown<String>(
                  value: _selectedDepartment,
                  label: 'Department',
                  icon: Icons.apartment,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('All departments'),
                    ),
                    if (_selectedDepartment.isNotEmpty &&
                        !_departments.contains(_selectedDepartment))
                      DropdownMenuItem(
                        value: _selectedDepartment,
                        child: Text(_selectedDepartment),
                      ),
                    ..._departments.map(
                      (department) => DropdownMenuItem(
                        value: department,
                        child: Text(department),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedDepartment = value ?? '');
                    _load();
                  },
                ),
                if (_selectedAssetType.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Asset type filter',
                      prefixIcon: const Icon(Icons.category),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.primary.withAlpha(16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(45),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(_selectedAssetType)),
                        IconButton(
                          tooltip: 'Clear type filter',
                          onPressed: () {
                            setState(() => _selectedAssetType = '');
                            _load();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_selectedStatus.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Status filter',
                      prefixIcon: const Icon(Icons.flag),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.primary.withAlpha(16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(45),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(_selectedStatus)),
                        IconButton(
                          tooltip: 'Clear status filter',
                          onPressed: () {
                            setState(() => _selectedStatus = '');
                            _load();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _assets.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(
                              height: 260,
                              child: AnimatedEmptyState(
                                icon: Icons.search_off,
                                title: 'No assets found',
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          cacheExtent: 900,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: true,
                          addSemanticIndexes: false,
                          itemCount: _assets.length,
                          itemBuilder: (context, index) {
                            final asset = _assets[index];
                            return AssetCard(
                              asset: asset,
                              onTap: () => _openDetail(asset),
                              onEdit: () => _openEdit(asset),
                              onDelete: () => _delete(asset),
                              onMaintenance: () => _openMaintenance(asset),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
