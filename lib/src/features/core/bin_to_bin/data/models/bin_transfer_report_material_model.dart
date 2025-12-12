import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/entities/bin_transfer_report_entity.dart';

class BinTransferReportMaterialModel extends BinTransferReportMaterialEntity {
  const BinTransferReportMaterialModel({
    required super.material,
    required super.batch,
    required super.quantity,
  });

  factory BinTransferReportMaterialModel.fromJson(Map<String, dynamic> json) {
    return BinTransferReportMaterialModel(
      material: json['material'] as String? ?? '',
      batch: json['batch'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }
}


