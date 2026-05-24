import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/models/asset.dart';
import 'package:it_asset_management_app/src/services/api_service.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_alerts.dart';
import 'package:it_asset_management_app/src/features/assets/screens/asset_form_screen.dart';

class AddAssetScreen extends StatelessWidget {
  const AddAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiService();
    return Scaffold(
      appBar: AppBar(title: const Text('Add Asset')),
      body: AssetForm(
        submitLabel: 'Create asset',
        onSubmit: (Asset asset) async {
          final response = await api.createAsset(asset);
          if (!context.mounted) return;
          await showAppAlert(
            context,
            title: response.success
                ? 'เพิ่มอุปกรณ์สำเร็จ'
                : 'เพิ่มอุปกรณ์ไม่สำเร็จ',
            message: response.message,
            success: response.success,
          );
          if (!context.mounted) return;
          if (response.success) Navigator.pop(context);
        },
      ),
    );
  }
}
