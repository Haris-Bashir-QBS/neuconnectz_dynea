import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/repositories/reservation_bin_repository.dart';

class GetWarehouseBinsByMaterialUseCase
    implements UseCase<ReservationBinResult, GetWarehouseBinsByMaterialParams> {
  final ReservationBinRepository repository;

  GetWarehouseBinsByMaterialUseCase(this.repository);

  @override
  Future<Either<Failure, ReservationBinResult>> call(
    GetWarehouseBinsByMaterialParams params,
  ) {
    return repository.getWarehouseBinsByMaterial(
      warehouseCode: params.warehouseCode,
      material: params.material,
    );
  }
}

class GetWarehouseBinsByMaterialParams {
  final String warehouseCode;
  final String material;

  GetWarehouseBinsByMaterialParams({
    required this.warehouseCode,
    required this.material,
  });
}


