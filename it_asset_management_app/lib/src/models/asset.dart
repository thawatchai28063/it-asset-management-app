class Asset {
  Asset({
    this.id,
    required this.assetName,
    required this.assetType,
    this.itTag,
    this.employeeNo,
    this.description,
    this.osVersion,
    this.brand,
    this.model,
    required this.serialNumber,
    this.ipAddress,
    required this.department,
    required this.status,
    this.assignedUser,
    this.position,
    this.pointImage,
    this.checkDate,
    this.receiptOfDevice,
    this.invoiceNo,
    this.date2,
    this.vendor,
    this.checker20250331,
    this.checkResult20250331,
    this.checker20250423,
    this.checker20250530,
    this.checkResult20250430,
    this.purchaseDate,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String assetName;
  final String assetType;
  final String? itTag;
  final String? employeeNo;
  final String? description;
  final String? osVersion;
  final String? brand;
  final String? model;
  final String serialNumber;
  final String? ipAddress;
  final String department;
  final String status;
  final String? assignedUser;
  final String? position;
  final String? pointImage;
  final String? checkDate;
  final String? receiptOfDevice;
  final String? invoiceNo;
  final String? date2;
  final String? vendor;
  final String? checker20250331;
  final String? checkResult20250331;
  final String? checker20250423;
  final String? checker20250530;
  final String? checkResult20250430;
  final String? purchaseDate;
  final String? note;
  final String? createdAt;
  final String? updatedAt;

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      assetName: json['asset_name'] ?? '',
      assetType: json['asset_type'] ?? '',
      itTag: json['it_tag'],
      employeeNo: json['employee_no'],
      description: json['description'],
      osVersion: json['os_version'],
      brand: json['brand'],
      model: json['model'],
      serialNumber: json['serial_number'] ?? '',
      ipAddress: json['ip_address'],
      department: json['department'] ?? '',
      status: json['status'] ?? 'available',
      assignedUser: json['assigned_user'],
      position: json['position'],
      pointImage: json['point_image'],
      checkDate: json['check_date'],
      receiptOfDevice: json['receipt_of_device'],
      invoiceNo: json['invoice_no'],
      date2: json['date2'],
      vendor: json['vendor'],
      checker20250331: json['checker_2025_03_31'],
      checkResult20250331: json['check_result_2025_03_31'],
      checker20250423: json['checker_2025_04_23'],
      checker20250530: json['checker_2025_05_30'],
      checkResult20250430: json['check_result_2025_04_30'],
      purchaseDate: json['purchase_date'],
      note: json['note'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'asset_name': assetName,
      'asset_type': assetType,
      'it_tag': itTag,
      'employee_no': employeeNo,
      'description': description,
      'os_version': osVersion,
      'brand': brand,
      'model': model,
      'serial_number': serialNumber,
      'ip_address': ipAddress,
      'department': department,
      'status': status,
      'assigned_user': assignedUser,
      'position': position,
      'point_image': pointImage,
      'check_date': checkDate,
      'receipt_of_device': receiptOfDevice,
      'invoice_no': invoiceNo,
      'date2': date2,
      'vendor': vendor,
      'checker_2025_03_31': checker20250331,
      'check_result_2025_03_31': checkResult20250331,
      'checker_2025_04_23': checker20250423,
      'checker_2025_05_30': checker20250530,
      'check_result_2025_04_30': checkResult20250430,
      'purchase_date': purchaseDate,
      'note': note,
    };
  }
}
