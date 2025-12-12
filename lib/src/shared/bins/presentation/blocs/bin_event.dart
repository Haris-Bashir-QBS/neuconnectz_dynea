part of 'bin_bloc.dart';

abstract class BinEvent extends Equatable {
  const BinEvent();

  @override
  List<Object?> get props => [];
}

class LoadBinsEvent extends BinEvent {
  // final String? plant;
  final String? storageType;
  final String? keyword;
  final String? warehouseCode;
  final int? lastCount;
  final int? skipRecords;

  const LoadBinsEvent({
    // this.plant,
    this.storageType,
    this.warehouseCode,
    this.keyword,
    this.lastCount,
    this.skipRecords,
  });

  @override
  List<Object?> get props => [
    //plant,
    storageType,
    warehouseCode,
    keyword,
    lastCount,
    skipRecords,
  ];
}


