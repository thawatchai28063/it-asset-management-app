import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/models/asset.dart';
import 'package:it_asset_management_app/src/services/api_service.dart';
import 'package:it_asset_management_app/src/shared/widgets/animated_app_icon.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_dropdown.dart';

class AssetForm extends StatefulWidget {
  const AssetForm({
    super.key,
    this.asset,
    required this.submitLabel,
    required this.onSubmit,
  });

  final Asset? asset;
  final String submitLabel;
  final Future<void> Function(Asset asset) onSubmit;

  @override
  State<AssetForm> createState() => _AssetFormState();
}

class _AssetFormState extends State<AssetForm> {
  static const _customTypeValue = '__custom_asset_type__';

  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();
  late final TextEditingController _assetName;
  late final TextEditingController _customAssetType;
  late final TextEditingController _itTag;
  late final TextEditingController _employeeNo;
  late final TextEditingController _description;
  late final TextEditingController _osVersion;
  late final TextEditingController _brand;
  late final TextEditingController _model;
  late final TextEditingController _serialNumber;
  late final TextEditingController _ipAddress;
  late final TextEditingController _assignedUser;
  late final TextEditingController _position;
  late final TextEditingController _pointImage;
  late final TextEditingController _checkDate;
  late final TextEditingController _purchaseDate;
  late final TextEditingController _note;
  late String _status;
  String _assetType = '';
  String _department = '';
  List<String> _departments = [];
  final List<String> _defaultAssetTypes = const [
    'Laptop',
    'Desktop',
    'Printer',
    'Network',
    'Access Point',
    'Monitor',
    'Storage',
    'Tablet',
    'Scanner',
  ];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final asset = widget.asset;
    _assetName = TextEditingController(text: asset?.assetName ?? '');
    _customAssetType = TextEditingController();
    _itTag = TextEditingController(text: asset?.itTag ?? '');
    _employeeNo = TextEditingController(text: asset?.employeeNo ?? '');
    _description = TextEditingController(text: asset?.description ?? '');
    _osVersion = TextEditingController(text: asset?.osVersion ?? '');
    _brand = TextEditingController(text: asset?.brand ?? '');
    _model = TextEditingController(text: asset?.model ?? '');
    _serialNumber = TextEditingController(text: asset?.serialNumber ?? '');
    _ipAddress = TextEditingController(text: asset?.ipAddress ?? '');
    _assignedUser = TextEditingController(text: asset?.assignedUser ?? '');
    _position = TextEditingController(text: asset?.position ?? '');
    _pointImage = TextEditingController(text: asset?.pointImage ?? '');
    _checkDate = TextEditingController(text: asset?.checkDate ?? '');
    _purchaseDate = TextEditingController(text: asset?.purchaseDate ?? '');
    _note = TextEditingController(text: asset?.note ?? '');
    final existingAssetType = asset?.assetType ?? '';
    if (existingAssetType.isNotEmpty &&
        !_defaultAssetTypes.contains(existingAssetType)) {
      _assetType = _customTypeValue;
      _customAssetType.text = existingAssetType;
    } else {
      _assetType = existingAssetType;
    }
    _department = asset?.department ?? '';
    _status = asset?.status ?? 'available';
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    final response = await _api.getDepartments();
    if (!mounted || !response.success) return;
    final departments = [...?response.data];
    if (_department.isNotEmpty && !departments.contains(_department)) {
      departments.add(_department);
    }
    setState(() => _departments = departments);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final asset = Asset(
      id: widget.asset?.id,
      assetName: _assetName.text.trim(),
      assetType: _assetType == _customTypeValue
          ? _customAssetType.text.trim()
          : _assetType,
      itTag: _itTag.text.trim().isEmpty ? null : _itTag.text.trim(),
      employeeNo:
          _employeeNo.text.trim().isEmpty ? null : _employeeNo.text.trim(),
      description:
          _description.text.trim().isEmpty ? null : _description.text.trim(),
      osVersion: _osVersion.text.trim().isEmpty ? null : _osVersion.text.trim(),
      brand: _brand.text.trim().isEmpty ? null : _brand.text.trim(),
      model: _model.text.trim().isEmpty ? null : _model.text.trim(),
      serialNumber: _serialNumber.text.trim(),
      ipAddress: _ipAddress.text.trim().isEmpty ? null : _ipAddress.text.trim(),
      department: _department,
      status: _status,
      assignedUser:
          _assignedUser.text.trim().isEmpty ? null : _assignedUser.text.trim(),
      position: _position.text.trim().isEmpty ? null : _position.text.trim(),
      pointImage:
          _pointImage.text.trim().isEmpty ? null : _pointImage.text.trim(),
      checkDate: _checkDate.text.trim().isEmpty ? null : _checkDate.text.trim(),
      purchaseDate:
          _purchaseDate.text.trim().isEmpty ? null : _purchaseDate.text.trim(),
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
    await widget.onSubmit(asset);
    if (mounted) setState(() => _loading = false);
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
      helpText: 'Select date',
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
    int minLines = 1,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: maxLines > 1 ? TextInputType.multiline : null,
        textInputAction: maxLines > 1 ? TextInputAction.newline : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          alignLabelWithHint: maxLines > 1,
        ),
        validator: required
            ? (value) => value == null || value.isEmpty ? 'Required' : null
            : null,
      ),
    );
  }

  Widget _dateField(TextEditingController controller, String label) {
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
      ),
    );
  }

  Widget _noteField() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Note',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: colorScheme.outlineVariant),
            const SizedBox(height: 12),
            TextFormField(
              controller: _note,
              minLines: 4,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                labelText: 'Text',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _departmentDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppDropdown<String>(
        value: _department.isEmpty ? null : _department,
        label: 'Department',
        icon: Icons.apartment,
        items: _departments
            .map(
              (department) => DropdownMenuItem(
                value: department,
                child: Text(department),
              ),
            )
            .toList(),
        onChanged: (value) => setState(() => _department = value ?? ''),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _assetTypeDropdown() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppDropdown<String>(
            value: _assetType.isEmpty ? null : _assetType,
            label: 'Asset type',
            icon: Icons.category,
            items: [
              ..._defaultAssetTypes.map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ),
              ),
              const DropdownMenuItem(
                value: _customTypeValue,
                child: Text('Other / Add new type'),
              ),
            ],
            onChanged: (value) => setState(() => _assetType = value ?? ''),
            validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
          ),
        ),
        if (_assetType == _customTypeValue)
          _field(
            _customAssetType,
            'New asset type',
            Icons.add_box,
            required: true,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _assetName.dispose();
    _customAssetType.dispose();
    _itTag.dispose();
    _employeeNo.dispose();
    _description.dispose();
    _osVersion.dispose();
    _brand.dispose();
    _model.dispose();
    _serialNumber.dispose();
    _ipAddress.dispose();
    _assignedUser.dispose();
    _position.dispose();
    _pointImage.dispose();
    _checkDate.dispose();
    _purchaseDate.dispose();
    _note.dispose();
    super.dispose();
  }

  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const AnimatedAppIcon(
                  icon: Icons.inventory_2,
                  color: Colors.indigo,
                  size: 76,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.asset == null ? 'New IT asset' : 'Update IT asset',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _section(
            title: 'Asset info',
            icon: Icons.devices_other,
            children: [
              _field(_assetName, 'Asset name', Icons.devices, required: true),
              _assetTypeDropdown(),
              _field(_itTag, 'IT Tag e.g. IT250075', Icons.qr_code_2),
              _field(_description, 'Description', Icons.description),
              _field(_brand, 'Brand', Icons.business),
              _field(_model, 'Model', Icons.memory),
              _field(
                _serialNumber,
                'Serial number',
                Icons.confirmation_number,
                required: true,
              ),
              _field(_osVersion, 'OS / Version', Icons.desktop_windows),
              _field(_ipAddress, 'IP address', Icons.router),
            ],
          ),
          _section(
            title: 'Assignment',
            icon: Icons.assignment_ind,
            children: [
              _departmentDropdown(),
              AppDropdown<String>(
                value: _status,
                label: 'Status',
                icon: Icons.flag,
                items: const [
                  DropdownMenuItem(
                    value: 'available',
                    child: Text('available'),
                  ),
                  DropdownMenuItem(value: 'in_use', child: Text('in_use')),
                  DropdownMenuItem(value: 'repair', child: Text('repair')),
                  DropdownMenuItem(value: 'retired', child: Text('retired')),
                ],
                onChanged: (value) =>
                    setState(() => _status = value ?? 'available'),
              ),
              const SizedBox(height: 12),
              _field(_employeeNo, 'Emp No.', Icons.badge),
              _field(_assignedUser, 'Assigned user', Icons.person),
              _field(
                _position,
                'Location e.g. FE Line 4',
                Icons.location_on,
              ),
              _field(_pointImage, 'Point / Image', Icons.image_search),
            ],
          ),
          _section(
            title: 'Dates & notes',
            icon: Icons.event_note,
            children: [
              _dateField(_purchaseDate, 'Purchase date'),
              _dateField(_checkDate, 'Check date'),
              _noteField(),
            ],
          ),
          FilledButton.icon(
            onPressed: _loading ? null : _submit,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }
}
