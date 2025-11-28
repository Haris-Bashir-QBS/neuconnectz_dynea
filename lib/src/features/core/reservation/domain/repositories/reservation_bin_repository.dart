import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';

class ReservationBinResult {
  final List<BinEntity> bins;
  final Map<String, double> proposedQuantities; // binId -> proposedQuantity

  ReservationBinResult({required this.bins, required this.proposedQuantities});
}

abstract class ReservationBinRepository {
  Future<Either<Failure, ReservationBinResult>> getWarehouseBinsByMaterial({
    required String warehouseCode,
    required String material,
  });
}
