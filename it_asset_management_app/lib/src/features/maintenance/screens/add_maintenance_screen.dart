import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/models/asset.dart';
import 'package:it_asset_management_app/src/models/maintenance_log.dart';
import 'package:it_asset_management_app/src/services/api_service.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_dropdown.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_alerts.dart';

class AddMaintenanceScreen extends StatefulWidget {
  const AddMaintenanceScreen({super.key, required this.asset, this.log});

  final Asset asset;
  final MaintenanceLog? log;

  @override
  State<AddMaintenanceScreen> createState() => _AddMaintenanceScreenState();
}

class _AddMaintenanceScreenState extends State<AddMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _problem = TextEditingController();
  final _solution = TextEditingController();
  final _repairBy = TextEditingController();
  final _repairDate = TextEditingController();
  final _api = ApiService();
  String _status = 'pending';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final log = widget.log;
    if (log != null) {
      _problem.text = log.problem;
      _solution.text = log.solution ?? '';
      _repairBy.text = log.repairBy;
      _repairDate.text = log.repairDate;
      _status = log.status;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || widget.asset.id == null) return;
    setState(() => _loading = true);
    final log = MaintenanceLog(
      id: widget.log?.id,
      assetId: widget.asset.id!,
      problem: _problem.text.trim(),
      solution: _solution.text.trim().isEmpty ? null : _solution.text.trim(),
      repairBy: _repairBy.text.trim(),
      repairDate: _repairDate.text.trim(),
      status: _status,
    );
    final response = widget.log == null
        ? await _api.createMaintenance(log)
        : await _api.updateMaintenance(log);
    setState(() => _loading = false);
    if (!mounted) return;
    await showAppAlert(
      context,
      title: response.success
          ? widget.log == null
              ? 'เพิ่มประวัติซ่อมสำเร็จ'
              : 'แก้ไขประวัติซ่อมสำเร็จ'
          : widget.log == null
              ? 'เพิ่มประวัติซ่อมไม่สำเร็จ'
              : 'แก้ไขประวัติซ่อมไม่สำเร็จ',
      message: response.message,
      success: response.success,
    );
    if (!mounted) return;
    if (response.success) Navigator.pop(context);
  }

  DateTime _initialDate(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) return DateTime.now();
    return DateTime.tryParse(value) ?? DateTime.now();
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate(controller),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select repair date',
      cancelText: 'Cancel',
      confirmText: 'OK',
    );
    if (selectedDate == null) return;
    controller.text = _formatDate(selectedDate);
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: required
            ? (value) => value == null || value.isEmpty ? 'Required' : null
            : null,
      ),
    );
  }

  Widget _dateField(
    TextEditingController controller,
    String label, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_month),
          suffixIcon: IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: 'Select date',
            onPressed: () => _pickDate(controller),
          ),
        ),
        onTap: () => _pickDate(controller),
        validator: required
            ? (value) => value == null || value.isEmpty ? 'Required' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.log == null ? 'Add Maintenance' : 'Edit Maintenance',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_problem, 'Problem', Icons.report_problem, required: true),
            _field(_solution, 'Solution', Icons.task_alt),
            _field(_repairBy, 'Repair by', Icons.engineering, required: true),
            _dateField(
              _repairDate,
              'Repair date',
              required: true,
            ),
            AppDropdown<String>(
              value: _status,
              label: 'Status',
              icon: Icons.flag,
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('pending')),
                DropdownMenuItem(
                  value: 'in_progress',
                  child: Text('in_progress'),
                ),
                DropdownMenuItem(value: 'completed', child: Text('completed')),
              ],
              onChanged: (value) =>
                  setState(() => _status = value ?? 'pending'),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _loading ? null : _save,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Text('Save maintenance'),
            ),
          ],
        ),
      ),
    );
  }
}
