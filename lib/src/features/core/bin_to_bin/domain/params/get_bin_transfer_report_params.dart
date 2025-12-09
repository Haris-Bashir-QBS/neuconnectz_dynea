import 'package:equatable/equatable.dart';

class GetBinTransferReportParams extends Equatable {
  final String? fromDate; // Format: yyyy-MM-dd
  final String? toDate; // Format: yyyy-MM-dd

  const GetBinTransferReportParams({
    this.fromDate,
    this.toDate,
  });

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};
    if (fromDate != null && fromDate!.isNotEmpty) {
      params['fromDate'] = fromDate;
    }
    if (toDate != null && toDate!.isNotEmpty) {
      params['toDate'] = toDate;
    }
    return params;
  }

  @override
  List<Object?> get props => [fromDate, toDate];
}
