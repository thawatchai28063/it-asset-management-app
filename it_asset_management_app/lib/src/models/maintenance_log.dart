class MaintenanceLog {
  MaintenanceLog({
    this.id,
    required this.assetId,
    required this.problem,
    this.solution,
    required this.repairBy,
    required this.repairDate,
    required this.status,
    this.createdAt,
  });

  final int? id;
  final int assetId;
  final String problem;
  final String? solution;
  final String repairBy;
  final String repairDate;
  final String status;
  final String? createdAt;

  factory MaintenanceLog.fromJson(Map<String, dynamic> json) {
    return MaintenanceLog(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      assetId: int.parse(json['asset_id'].toString()),
      problem: json['problem'] ?? '',
      solution: json['solution'],
      repairBy: json['repair_by'] ?? '',
      repairDate: json['repair_date'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'asset_id': assetId,
      'problem': problem,
      'solution': solution,
      'repair_by': repairBy,
      'repair_date': repairDate,
      'status': status,
    };
  }
}
