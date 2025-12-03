import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_entity.dart';

class OutboundDeliveryStoState extends Equatable {
  final bool loading;
  final bool loadingMore;
  final List<OutboundDeliveryStoEntity> items;
  final int totalRows;
  final int skipRecords;
  final String? error;
  final bool creatingStockTransferOrder;
  final ApiResponse<bool>? createStockTransferOrderResponse;
  final String? createStockTransferOrderError;

  const OutboundDeliveryStoState({
    this.loading = false,
    this.loadingMore = false,
    this.items = const [],
    this.totalRows = 0,
    this.skipRecords = 0,
    this.error,
    this.creatingStockTransferOrder = false,
    this.createStockTransferOrderResponse,
    this.createStockTransferOrderError,
  });

  bool get hasMore => items.length < totalRows;

  OutboundDeliveryStoState copyWith({
    bool? loading,
    bool? loadingMore,
    List<OutboundDeliveryStoEntity>? items,
    int? totalRows,
    int? skipRecords,
    String? error,
    bool clearError = false,
    bool? creatingStockTransferOrder,
    ApiResponse<bool>? createStockTransferOrderResponse,
    String? createStockTransferOrderError,
    bool clearCreateError = false,
    bool clearCreateResponse = false,
  }) {
    return OutboundDeliveryStoState(
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      items: items ?? this.items,
      totalRows: totalRows ?? this.totalRows,
      skipRecords: skipRecords ?? this.skipRecords,
      error: clearError ? null : (error ?? this.error),
      creatingStockTransferOrder:
          creatingStockTransferOrder ?? this.creatingStockTransferOrder,
      createStockTransferOrderResponse: clearCreateResponse
          ? null
          : (createStockTransferOrderResponse ??
              this.createStockTransferOrderResponse),
      createStockTransferOrderError: clearCreateError
          ? null
          : (createStockTransferOrderError ??
              this.createStockTransferOrderError),
    );
  }

  @override
  List<Object?> get props => [
        loading,
        loadingMore,
        items,
        totalRows,
        skipRecords,
        error,
        creatingStockTransferOrder,
        createStockTransferOrderResponse,
        createStockTransferOrderError,
      ];
}
