import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/data/datasources/remote/outbound_delivery_sales_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/data/models/create_sales_order_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_items_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/repositories/outbound_delivery_sales_repository.dart';

class OutboundDeliverySalesRepositoryImpl
    implements OutboundDeliverySalesRepository {
  final OutboundDeliverySalesRemoteDataSource remoteDataSource;

  OutboundDeliverySalesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OutboundDeliverySalesResultEntity>>
      listAllSalesOrderDocFromSAP(
    OutboundDeliverySalesListParams params,
  ) async {
    try {
      final response = await remoteDataSource.listAllSalesOrderDocFromSAP(
        params: params,
      );
      return Right(response.toEntity());
    } on Failure catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<Failure, OutboundDeliverySalesItemsResultEntity>>
      listAllSalesOrderItemFromSAP(
    OutboundDeliverySalesItemParams params,
  ) async {
    try {
      final response = await remoteDataSource.listAllSalesOrderItemFromSAP(
        params: params,
      );
      return Right(response.toEntity());
    } on Failure catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<Failure, OutboundDeliverySalesItemsResultEntity>>
      listCompletedSalesOrderItems(
    OutboundDeliverySalesItemParams params,
  ) async {
    try {
      final response = await remoteDataSource.listCompletedSalesOrderItems(
        params: params,
      );
      return Right(response.toEntity());
    } on Failure catch (error) {
      return Left(error);
    }
  }

  @override
  Future<Either<Failure, ApiResponse<bool>>> createSalesOrder({
    required CreateSalesOrderRequestModel request,
  }) async {
    try {
      final response = await remoteDataSource.createSalesOrder(request: request);
      return Right(response);
    } on Failure catch (error) {
      return Left(error);
    }
  }
}



