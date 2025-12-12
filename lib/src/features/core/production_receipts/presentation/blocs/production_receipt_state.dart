part of 'production_receipt_bloc.dart';

class ProductionReceiptItemsSectionState extends Equatable {
  final List<ProductionReceiptItemEntity> items;
  final int totalRows;
  final int skipRecords;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const ProductionReceiptItemsSectionState({
    this.items = const [],
    this.totalRows = 0,
    this.skipRecords = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasMore => items.length < totalRows;

  ProductionReceiptItemsSectionState copyWith({
    List<ProductionReceiptItemEntity>? items,
    int? totalRows,
    int? skipRecords,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return ProductionReceiptItemsSectionState(
      items: items ?? this.items,
      totalRows: totalRows ?? this.totalRows,
      skipRecords: skipRecords ?? this.skipRecords,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        items,
        totalRows,
        skipRecords,
        isLoading,
        isLoadingMore,
        errorMessage,
      ];
}

abstract class ProductionReceiptState extends Equatable {
  final bool isHeadersLoading;
  final List<ProductionReceiptEntity> headers;
  final int headersTotalRows;
  final String? headersError;
  final ProductionReceiptItemsSectionState pendingSection;
  final ProductionReceiptItemsSectionState completedSection;
  final bool isCreating;
  final String? createError;
  final ApiResponse<bool>? createResponse;
  final bool isDeleting;
  final String? deleteError;
  final ApiResponse<bool>? deleteResponse;

  const ProductionReceiptState({
    required this.isHeadersLoading,
    required this.headers,
    required this.headersTotalRows,
    this.headersError,
    this.pendingSection = const ProductionReceiptItemsSectionState(),
    this.completedSection = const ProductionReceiptItemsSectionState(),
    this.isCreating = false,
    this.createError,
    this.createResponse,
    this.isDeleting = false,
    this.deleteError,
    this.deleteResponse,
  });

  List<Object?> get baseProps => [
        isHeadersLoading,
        headers,
        headersTotalRows,
        headersError,
        pendingSection,
        completedSection,
        isCreating,
        createError,
        createResponse,
        isDeleting,
        deleteError,
        deleteResponse,
      ];

  @override
  List<Object?> get props => baseProps;
}

class ProductionReceiptInitial extends ProductionReceiptState {
  const ProductionReceiptInitial({
    super.isHeadersLoading = false,
    super.headers = const [],
    super.headersTotalRows = 0,
    super.headersError,
    super.pendingSection,
    super.completedSection,
    super.isCreating = false,
    super.createError,
    super.createResponse,
    super.isDeleting = false,
    super.deleteError,
    super.deleteResponse,
  });
}

class ProductionReceiptHeaderListLoading extends ProductionReceiptState {
  const ProductionReceiptHeaderListLoading({
    super.pendingSection,
    super.completedSection,
    super.isCreating = false,
    super.createError,
    super.createResponse,
    super.isDeleting = false,
    super.deleteError,
    super.deleteResponse,
  }) : super(
          isHeadersLoading: true,
          headers: const [],
          headersTotalRows: 0,
        );
}

class ProductionReceiptHeaderListFetched extends ProductionReceiptState {
  final int skipRecords;
  final bool isLoadingMore;

  const ProductionReceiptHeaderListFetched({
    required super.headers,
    required super.headersTotalRows,
    required this.skipRecords,
    this.isLoadingMore = false,
    super.pendingSection,
    super.completedSection,
    super.isCreating = false,
    super.createError,
    super.createResponse,
    super.isDeleting = false,
    super.deleteError,
    super.deleteResponse,
  }) : super(isHeadersLoading: false);

  bool get hasMore => headers.length < headersTotalRows;

  @override
  List<Object?> get props => [
        ...baseProps,
        skipRecords,
        isLoadingMore,
      ];
}

class ProductionReceiptHeaderListFetchFailure extends ProductionReceiptState {
  final String message;

  const ProductionReceiptHeaderListFetchFailure({
    required this.message,
    super.pendingSection,
    super.completedSection,
    super.isCreating = false,
    super.createError,
    super.createResponse,
    super.isDeleting = false,
    super.deleteError,
    super.deleteResponse,
  }) : super(
          isHeadersLoading: false,
          headers: const [],
          headersTotalRows: 0,
          headersError: message,
        );

  @override
  List<Object?> get props => [...baseProps, message];
}

class ProductionReceiptItemsLoading extends ProductionReceiptState {
  const ProductionReceiptItemsLoading({
    required super.isHeadersLoading,
    required super.headers,
    required super.headersTotalRows,
    super.pendingSection,
    super.completedSection,
    super.isCreating = false,
    super.createError,
    super.createResponse,
    super.isDeleting = false,
    super.deleteError,
    super.deleteResponse,
  });
}

class ProductionReceiptItemsSuccess extends ProductionReceiptState {
  const ProductionReceiptItemsSuccess({
    required super.isHeadersLoading,
    required super.headers,
    required super.headersTotalRows,
    super.pendingSection,
    super.completedSection,
    super.isCreating = false,
    super.createError,
    super.createResponse,
    super.isDeleting = false,
    super.deleteError,
    super.deleteResponse,
  });
}

class ProductionReceiptItemsFailure extends ProductionReceiptState {
  final String message;

  const ProductionReceiptItemsFailure({
    required this.message,
    required super.isHeadersLoading,
    required super.headers,
    required super.headersTotalRows,
    super.pendingSection,
    super.completedSection,
    super.isCreating = false,
    super.createError,
    super.createResponse,
    super.isDeleting = false,
    super.deleteError,
    super.deleteResponse,
  });

  @override
  List<Object?> get props => [...baseProps, message];
}

