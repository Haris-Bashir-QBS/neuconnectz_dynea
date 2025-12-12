part of 'source_bin_material_listing_bloc.dart';

abstract class SourceBinMaterialListingEvent extends Equatable {
  const SourceBinMaterialListingEvent();
}

class LoadSourceBinMaterialsEvent extends SourceBinMaterialListingEvent {
  final String plant;
  final String whsCode;
  final String storageLocation;
  final String storageBin;
  final String? storageType;
  final String? storageSection;
  final String? searchQuery;
  final bool loadAll; // If true, don't pass lastCount and skipRecords

  const LoadSourceBinMaterialsEvent({
    required this.plant,
    required this.whsCode,
    required this.storageLocation,
    required this.storageBin,
    this.storageType,
    this.storageSection,
    this.searchQuery,
    this.loadAll = false,
  });

  @override
  List<Object?> get props => [
        plant,
        whsCode,
        storageLocation,
        storageBin,
        storageType,
        storageSection,
        searchQuery,
        loadAll,
      ];
}

class LoadMoreSourceBinMaterialsEvent extends SourceBinMaterialListingEvent {
  final String plant;
  final String whsCode;
  final String storageLocation;
  final String storageBin;
  final String? storageType;
  final String? storageSection;
  final String? searchQuery;

  const LoadMoreSourceBinMaterialsEvent({
    required this.plant,
    required this.whsCode,
    required this.storageLocation,
    required this.storageBin,
    this.storageType,
    this.storageSection,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        plant,
        whsCode,
        storageLocation,
        storageBin,
        storageType,
        storageSection,
        searchQuery,
      ];
}

