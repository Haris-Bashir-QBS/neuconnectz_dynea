import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/datasources/remote/sto_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/create_stock_transfer_order_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/repositories/sto_repository.dart';

class StoRepositoryImpl implements StoRepository {
  StoRepositoryImpl({required this.remoteDataSource});

  final StoRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, ApiResponse<bool>>> createStockTransferOrder({
    required CreateStockTransferOrderRequestModel request,
  }) async {
    try {
      final response = await remoteDataSource.createStockTransferOrder(
        request: request,
      );
      return Right(response);
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}

