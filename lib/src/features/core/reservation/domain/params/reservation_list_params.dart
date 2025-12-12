import 'package:equatable/equatable.dart';

class ReservationListParams extends Equatable {
  final String plant;
  final String storageLocation;
  final String movementType;
  final String? fromDate;
  final String? toDate;
  final int lastCount;
  final int skipRecords;
  final String? keyword;

  const ReservationListParams({
    required this.plant,
    required this.storageLocation,
    required this.movementType,
    this.fromDate,
    this.toDate,
    this.lastCount = 10,
    this.skipRecords = 0,
    this.keyword,
  });

  ReservationListParams copyWith({
    String? plant,
    String? storageLocation,
    String? movementType,
    String? fromDate,
    String? toDate,
    int? lastCount,
    int? skipRecords,
    String? keyword,
  }) {
    return ReservationListParams(
      plant: plant ?? this.plant,
      storageLocation: storageLocation ?? this.storageLocation,
      movementType: movementType ?? this.movementType,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      lastCount: lastCount ?? this.lastCount,
      skipRecords: skipRecords ?? this.skipRecords,
      keyword: keyword ?? this.keyword,
    );
  }

  @override
  List<Object?> get props => [
        plant,
        storageLocation,
        movementType,
        fromDate,
        toDate,
        lastCount,
        skipRecords,
        keyword,
      ];
}



