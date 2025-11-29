import 'package:equatable/equatable.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_entity.dart';

class OutboundDeliveryStoState extends Equatable {
  final bool loading;
  final bool loadingMore;
  final List<OutboundDeliveryStoEntity> items;
  final int totalRows;
  final int skipRecords;
  final String? error;

  const OutboundDeliveryStoState({
    this.loading = false,
    this.loadingMore = false,
    this.items = const [],
    this.totalRows = 0,
    this.skipRecords = 0,
    this.error,
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
  }) {
    return OutboundDeliveryStoState(
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      items: items ?? this.items,
      totalRows: totalRows ?? this.totalRows,
      skipRecords: skipRecords ?? this.skipRecords,
      error: clearError ? null : (error ?? this.error),
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
      ];
}
