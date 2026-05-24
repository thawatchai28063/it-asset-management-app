import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/models/asset.dart';
import 'package:it_asset_management_app/src/models/maintenance_log.dart';
import 'package:it_asset_management_app/src/services/api_service.dart';
import 'package:it_asset_management_app/src/shared/widgets/animated_app_icon.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_alerts.dart';
import 'package:it_asset_management_app/src/shared/widgets/status_chip.dart';
import 'package:it_asset_management_app/src/features/maintenance/screens/add_maintenance_screen.dart';

class MaintenanceHistoryScreen extends StatefulWidget {
  const MaintenanceHistoryScreen({super.key, required this.asset});

  final Asset asset;

  @override
  State<MaintenanceHistoryScreen> createState() =>
      _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends State<MaintenanceHistoryScreen> {
  final _api = ApiService();
  bool _loading = true;
  List<MaintenanceLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.asset.id == null) return;
    setState(() => _loading = true);
    final response = await _api.getMaintenanceLogs(widget.asset.id!);
    setState(() {
      _loading = false;
      _logs = response.data ?? [];
    });
  }

  Future<void> _delete(MaintenanceLog log) async {
    if (log.id == null) return;
    final confirm = await showConfirmAlert(
      context,
      title: 'ยืนยันการลบประวัติซ่อม',
      message: 'ต้องการลบประวัติซ่อมรายการนี้ใช่ไหม?',
      confirmText: 'ลบ',
    );
    if (!confirm) return;
    final response = await _api.deleteMaintenance(log.id!);
    if (!mounted) return;
    await showAppAlert(
      context,
      title:
          response.success ? 'ลบประวัติซ่อมสำเร็จ' : 'ลบประวัติซ่อมไม่สำเร็จ',
      message: response.message,
      success: response.success,
    );
    if (!mounted) return;
    _load();
  }

  Future<void> _add() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddMaintenanceScreen(asset: widget.asset),
      ),
    );
    _load();
  }

  Future<void> _edit(MaintenanceLog log) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddMaintenanceScreen(asset: widget.asset, log: log),
      ),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.asset.assetName)),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _logs.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(
                        height: 260,
                        child: AnimatedEmptyState(
                          icon: Icons.history_toggle_off,
                          title: 'No maintenance logs',
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      log.problem,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  StatusChip(status: log.status),
                                  IconButton(
                                    onPressed: () => _edit(log),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () => _delete(log),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Solution: ${log.solution?.isEmpty ?? true ? '-' : log.solution}',
                              ),
                              Text('Repair by: ${log.repairBy}'),
                              Text('Repair date: ${log.repairDate}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
