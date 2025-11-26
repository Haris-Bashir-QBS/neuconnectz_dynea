import 'package:equatable/equatable.dart';

class MovementTypeQueryParams extends Equatable {
  final String? keyword;
  final int lastCount;
  final int skipRecords;

  const MovementTypeQueryParams({
    this.keyword,
    this.lastCount = 10,
    this.skipRecords = 0,
  });

  MovementTypeQueryParams copyWith({
    String? keyword,
    int? lastCount,
    int? skipRecords,
  }) {
    return MovementTypeQueryParams(
      keyword: keyword ?? this.keyword,
      lastCount: lastCount ?? this.lastCount,
      skipRecords: skipRecords ?? this.skipRecords,
    );
  }

  @override
  List<Object?> get props => [keyword, lastCount, skipRecords];
}

