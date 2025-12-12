import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/entities/bin_transfer_report_entity.dart';

abstract class BinTransferReportState extends Equatable {
  const BinTransferReportState();

  @override
  List<Object?> get props => [];
}

class BinTransferReportInitial extends BinTransferReportState {}

class BinTransferReportLoading extends BinTransferReportState {}

class BinTransferReportSuccess extends BinTransferReportState {
  final List<BinTransferReportEntity> reports;

  const BinTransferReportSuccess({required this.reports});

  @override
  List<Object?> get props => [reports];
}

class BinTransferReportFailure extends BinTransferReportState {
  final String message;

  const BinTransferReportFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteBinRecordLoading extends BinTransferReportState {}

class DeleteBinRecordSuccess extends BinTransferReportState {
  final ApiResponse<bool>? apiResponse;

  const DeleteBinRecordSuccess({this.apiResponse});

  @override
  List<Object?> get props => [apiResponse];
}

class DeleteBinRecordFailure extends BinTransferReportState {
  final String message;

  const DeleteBinRecordFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

