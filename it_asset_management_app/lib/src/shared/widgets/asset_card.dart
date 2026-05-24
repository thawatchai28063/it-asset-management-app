import 'package:flutter/material.dart';

import 'package:it_asset_management_app/src/models/asset.dart';
import 'animated_app_icon.dart';
import 'status_chip.dart';

class AssetCard extends StatelessWidget {
  const AssetCard({
    super.key,
    required this.asset,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onMaintenance,
  });

  final Asset asset;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMaintenance;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaticIconBadge(
                icon: assetTypeIcon(asset.assetType),
                color: assetTypeColor(asset.assetType),
                size: 42,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.assetName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${asset.assetType} - ${asset.brand ?? '-'} ${asset.model ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Serial: ${asset.serialNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: 14,
                          color: Colors.indigo.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            asset.itTag == null || asset.itTag!.isEmpty
                                ? 'IT Tag: -'
                                : 'IT Tag: ${asset.itTag}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.indigo.shade700,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.apartment,
                          size: 14,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Department: ${asset.department}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    if (asset.employeeNo != null ||
                        asset.position != null ||
                        asset.pointImage != null)
                      const SizedBox(height: 2),
                    if (asset.employeeNo != null ||
                        asset.position != null ||
                        asset.pointImage != null)
                      Row(
                        children: [
                          Icon(
                            Icons.badge,
                            size: 14,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              [
                                if (asset.employeeNo?.isNotEmpty ?? false)
                                  'Emp: ${asset.employeeNo}',
                                if (asset.position?.isNotEmpty ?? false)
                                  'Location: ${asset.position}',
                              ].join(' | '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusChip(status: asset.status),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints.tightFor(
                          width: 36,
                          height: 36,
                        ),
                        color: Colors.orange.shade700,
                        icon: const Icon(Icons.home_repair_service, size: 20),
                        tooltip: 'Maintenance log',
                        onPressed: onMaintenance,
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints.tightFor(
                          width: 36,
                          height: 36,
                        ),
                        icon: const Icon(Icons.edit, size: 20),
                        tooltip: 'Edit',
                        onPressed: onEdit,
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints.tightFor(
                          width: 36,
                          height: 36,
                        ),
                        icon: const Icon(Icons.delete, size: 20),
                        tooltip: 'Delete',
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
