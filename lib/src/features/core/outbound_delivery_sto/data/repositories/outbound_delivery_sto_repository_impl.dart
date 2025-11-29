import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/datasources/remote/outbound_delivery_sto_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/repositories/outbound_delivery_sto_repository.dart';

class OutboundDeliveryStoRepositoryImpl
    implements OutboundDeliveryStoRepository {
  final OutboundDeliveryStoRemoteDataSource remoteDataSource;

  OutboundDeliveryStoRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<OutboundDeliveryStoEntity>>>
  listAllStockDocFromSAP({
    required OutboundDeliveryStoListParams params,
  }) async {
    try {
      final response = await remoteDataSource.listAllStockDocFromSAP(
        params: params,
      );
      if (response.success) {
        return Right(response.data ?? []);
      } else {
        return Left(Failure(message: response.message));
      }
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
