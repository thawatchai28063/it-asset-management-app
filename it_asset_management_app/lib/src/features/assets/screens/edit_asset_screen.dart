import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/models/asset.dart';
import 'package:it_asset_management_app/src/services/api_service.dart';
import 'package:it_asset_management_app/src/shared/widgets/app_alerts.dart';
import 'package:it_asset_management_app/src/features/assets/screens/asset_form_screen.dart';

class EditAssetScreen extends StatelessWidget {
  const EditAssetScreen({super.key, required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    final api = ApiService();
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Asset')),
      body: AssetForm(
        asset: asset,
        submitLabel: 'Update asset',
        onSubmit: (Asset updatedAsset) async {
          final response = await api.updateAsset(updatedAsset);
          if (!context.mounted) return;
          await showAppAlert(
            context,
            title: response.success
                ? 'แก้ไขอุปกรณ์สำเร็จ'
                : 'แก้ไขอุปกรณ์ไม่สำเร็จ',
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
