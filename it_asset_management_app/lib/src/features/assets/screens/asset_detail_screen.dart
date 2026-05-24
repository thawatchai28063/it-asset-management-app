import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/models/asset.dart';
import 'package:it_asset_management_app/src/services/api_service.dart';
import 'package:it_asset_management_app/src/shared/widgets/animated_app_icon.dart';
import 'package:it_asset_management_app/src/shared/widgets/status_chip.dart';
import 'package:it_asset_management_app/src/features/assets/screens/edit_asset_screen.dart';
import 'package:it_asset_management_app/src/features/maintenance/screens/maintenance_history_screen.dart';

class AssetDetailScreen extends StatefulWidget {
  const AssetDetailScreen({super.key, required this.assetId});

  final int assetId;

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  final _api = ApiService();
  bool _loading = true;
  Asset? _asset;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final response = await _api.getAsset(widget.assetId);
    setState(() {
      _loading = false;
      _asset = response.data;
    });
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value == null || value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asset = _asset;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Detail'),
        actions: [
          if (asset != null)
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAssetScreen(asset: asset),
                  ),
                );
                _load();
              },
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : asset == null
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('Asset not found')),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AnimatedAppIcon(
                                    icon: Icons.devices_other,
                                    color: Colors.indigo,
                                    size: 58,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          asset.assetName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        const SizedBox(height: 6),
                                        StatusChip(status: asset.status),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              _row('Type', asset.assetType),
                              _row('IT Tag', asset.itTag),
                              _row('Emp No.', asset.employeeNo),
                              _row('Description', asset.description),
                              _row('Brand', asset.brand),
                              _row('Model', asset.model),
                              _row('Serial', asset.serialNumber),
                              _row('OS / Version', asset.osVersion),
                              _row('IP address', asset.ipAddress),
                              _row('Department', asset.department),
                              _row('Assigned user', asset.assignedUser),
                              _row('Location', asset.position),
                              _row('Point / Image', asset.pointImage),
                              _row('Purchase date', asset.purchaseDate),
                              _row('Created', asset.createdAt),
                              _row('Updated', asset.updatedAt),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MaintenanceHistoryScreen(asset: asset),
                            ),
                          );
                        },
                        icon: const Icon(Icons.home_repair_service),
                        label: const Text('Maintenance log'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
