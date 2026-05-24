import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/models/asset.dart';
import 'package:it_asset_management_app/src/shared/widgets/animated_app_icon.dart';
import 'package:it_asset_management_app/src/features/assets/screens/asset_list_screen.dart';

enum AssetSummaryMode { type, department }

class AssetSummaryScreen extends StatelessWidget {
  const AssetSummaryScreen({
    super.key,
    required this.assets,
    required this.mode,
  });

  final List<Asset> assets;
  final AssetSummaryMode mode;

  String get _title =>
      mode == AssetSummaryMode.type ? 'Assets by type' : 'Assets by department';

  IconData get _icon =>
      mode == AssetSummaryMode.type ? Icons.category : Icons.apartment;

  Color get _color =>
      mode == AssetSummaryMode.type ? Colors.deepPurple : Colors.indigo;

  Map<String, int> get _summary {
    final data = <String, int>{};
    for (final asset in assets) {
      final key =
          mode == AssetSummaryMode.type ? asset.assetType : asset.department;
      data[key] = (data[key] ?? 0) + 1;
    }
    final entries = data.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        if (byCount != 0) return byCount;
        return a.key.compareTo(b.key);
      });
    return Map.fromEntries(entries);
  }

  void _openAssets(BuildContext context, String key) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssetListScreen(
          title: key,
          initialAssetType: mode == AssetSummaryMode.type ? key : '',
          initialDepartment: mode == AssetSummaryMode.department ? key : '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: summary.isEmpty
          ? AnimatedEmptyState(
              icon: _icon, title: 'No data found', color: _color)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      AnimatedAppIcon(icon: _icon, color: _color, size: 82),
                      const SizedBox(height: 12),
                      Text(
                        _title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                ...summary.entries.map(
                  (entry) => Card(
                    child: ListTile(
                      leading: PrettyIconBadge(
                        icon: mode == AssetSummaryMode.type
                            ? assetTypeIcon(entry.key)
                            : Icons.apartment,
                        color: mode == AssetSummaryMode.type
                            ? assetTypeColor(entry.key)
                            : Colors.indigo,
                      ),
                      title: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text('${entry.value} assets'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openAssets(context, entry.key),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
