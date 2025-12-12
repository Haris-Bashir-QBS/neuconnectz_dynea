import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/datasources/remote/outbound_delivery_sto_item_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/get_and_update_stocks_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/repositories/outbound_delivery_sto_item_repository.dart';

class OutboundDeliveryStoItemRepositoryImpl
    implements OutboundDeliveryStoItemRepository {
  final OutboundDeliveryStoItemRemoteDataSource remoteDataSource;

  OutboundDeliveryStoItemRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<OutboundDeliveryStoItemEntity>>>
      getStockDocItemFromSAP({
    required OutboundDeliveryStoItemParams params,
  }) async {
    try {
      final response = await remoteDataSource.getStockDocItemFromSAP(
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

  @override
  Future<Either<Failure, List<OutboundDeliveryStoItemEntity>>>
      getCompletedStoItems({
    required OutboundDeliveryStoItemParams params,
  }) async {
    try {
      final response = await remoteDataSource.getCompletedStoItems(
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

  @override
  Future<Either<Failure, ApiResponse<bool>>> getAndUpdateStocksFromSap(
    GetAndUpdateStocksRequestModel request,
  ) async {
    try {
      final response = await remoteDataSource.getAndUpdateStocksFromSap(
        request: request,
      );
      return Right(response);
    } on Failure catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<Failure, ApiResponse<bool>>> deletePickingAgainstOutboundDeliverySto({
    required int docNum,
  }) async {
    try {
      final response = await remoteDataSource.deletePickingAgainstOutboundDeliverySto(docNum: docNum);
      return Right(response);
    } on Failure catch (error) {
      return Left(error);
    }
  }
}


