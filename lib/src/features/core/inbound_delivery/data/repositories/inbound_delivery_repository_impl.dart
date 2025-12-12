import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/datasources/remote/inbound_delivery_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/data/models/create_putaway_inbound_sto_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/repositories/inbound_delivery_repository.dart';

class InboundDeliveryRepositoryImpl implements InboundDeliveryRepository {
  final InboundDeliveryRemoteDataSource remoteDataSource;

  InboundDeliveryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, InboundDeliveryListResultEntity>>
      listAllInboundDeliveryFromSAP(
    InboundDeliveryListParams params,
  ) async {
    try {
      final model = await remoteDataSource.listAllInboundDeliveryFromSAP(
        params: params,
      );
      if (model.data == null) {
        return right(
          const InboundDeliveryListResultEntity(items: [], totalRows: 0),
        );
      }
      return right(
        InboundDeliveryListResultEntity(
          items: model.data!.data.map((item) => item.toEntity()).toList(),
          totalRows: model.data!.totalRows,
        ),
      );
    } on Failure catch (failure) {
      return left(failure);
    }
  }

  @override
  Future<Either<Failure, InboundDeliveryItemResultEntity>>
      listAllInboundDeliveryItemsFromSAP(
    InboundDeliveryItemQueryParams params,
  ) async {
    try {
      final model = await remoteDataSource.listAllInboundDeliveryItemsFromSAP(
        params: params,
      );
      if (model.data == null) {
        return right(
          const InboundDeliveryItemResultEntity(items: [], totalRows: 0),
        );
      }
      final items = model.data!.data.isEmpty
          ? <InboundDeliveryItemEntity>[]
          : model.data!.data.map((item) => item.toEntity()).toList();

      return right(
        InboundDeliveryItemResultEntity(
          items: items,
          totalRows: model.data!.totalRows,
        ),
      );
    } on Failure catch (failure) {
      return left(failure);
    }
  }

  @override
  Future<Either<Failure, InboundDeliveryItemResultEntity>>
      listCompletedInboundDeliveryItems(
    InboundDeliveryItemQueryParams params,
  ) async {
    try {
      final model = await remoteDataSource.listCompletedInboundDeliveryItems(
        params: params,
      );
      if (model.data == null) {
        return right(
          const InboundDeliveryItemResultEntity(items: [], totalRows: 0),
        );
      }
      final items = model.data!.data.isEmpty
          ? <InboundDeliveryItemEntity>[]
          : model.data!.data.map((item) => item.toEntity()).toList();

      return right(
        InboundDeliveryItemResultEntity(
          items: items,
          totalRows: model.data!.totalRows,
        ),
      );
    } on Failure catch (failure) {
      return left(failure);
    }
  }

  @override
  Future<Either<Failure, ApiResponse<bool>>>
      createPutAwayAgainstInboundDelivery(
    CreatePutAwayInboundStoRequestModel request,
  ) async {
    try {
      final success = await remoteDataSource.createPutAwayAgainstInboundDelivery(
        request: request,
      );
      return right(success);
    } on Failure catch (failure) {
      return left(failure);
    }
  }
}


