part of 'movement_type_bloc.dart';

class MovementTypeState extends Equatable {
  final List<MovementTypeEntity> items;
  final int totalCount;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? keyword;

  const MovementTypeState({
    required this.items,
    required this.totalCount,
    required this.isLoading,
    required this.isLoadingMore,
    required this.errorMessage,
    required this.keyword,
  });

  factory MovementTypeState.initial() => const MovementTypeState(
        items: [],
        totalCount: 0,
        isLoading: false,
        isLoadingMore: false,
        errorMessage: null,
        keyword: null,
      );

  bool get hasMore => items.length < totalCount;

  MovementTypeState copyWith({
    List<MovementTypeEntity>? items,
    int? totalCount,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    String? keyword,
  }) {
    return MovementTypeState(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      keyword: keyword ?? this.keyword,
    );
  }

  @override
  List<Object?> get props => [
        items,
        totalCount,
        isLoading,
        isLoadingMore,
        errorMessage,
        keyword,
      ];
}
