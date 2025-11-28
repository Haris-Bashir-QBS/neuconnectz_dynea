import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/datasources/reservation_bin_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/repositories/reservation_bin_repository.dart';

class ReservationBinRepositoryImpl implements ReservationBinRepository {
  final ReservationBinRemoteDataSource remoteDataSource;

  ReservationBinRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ReservationBinResult>> getWarehouseBinsByMaterial({
    required String warehouseCode,
    required String material,
  }) async {
    try {
      final response = await remoteDataSource.getWarehouseBinsByMaterial(
        warehouseCode: warehouseCode,
        material: material,
      );

      if (!response.isRequestSuccess || response.data == null) {
        return Left(
          Failure(
            message:
                response.message.isNotEmpty
                    ? response.message
                    : 'Failed to load bins',
          ),
        );
      }

      final bins = response.data!.bins.map((bin) => bin.toBinEntity()).toList();
      final proposedQuantities = <String, double>{};

      for (final binModel in response.data!.bins) {
        proposedQuantities[binModel.id] = binModel.availableStock;
      }

      return Right(
        ReservationBinResult(
          bins: bins,
          proposedQuantities: proposedQuantities,
        ),
      );
    } on Failure catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
