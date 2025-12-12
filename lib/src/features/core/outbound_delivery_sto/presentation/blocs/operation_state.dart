import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';

enum OperationStatus { idle, loading, success, error }

class OperationState<T> extends Equatable {
  final OperationStatus status;
  final T? data;
  final String? error;

  const OperationState({
    this.status = OperationStatus.idle,
    this.data,
    this.error,
  });

  bool get isLoading => status == OperationStatus.loading;
  bool get isSuccess => status == OperationStatus.success;
  bool get isError => status == OperationStatus.error;
  bool get isIdle => status == OperationStatus.idle;

  OperationState<T> copyWith({
    OperationStatus? status,
    T? data,
    String? error,
    bool clearData = false,
    bool clearError = false,
  }) {
    return OperationState<T>(
      status: status ?? this.status,
      data: clearData ? null : (data ?? this.data),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, data, error];
}



