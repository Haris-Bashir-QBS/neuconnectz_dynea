import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/datasources/remote/purchase_order_grn_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_ordr_grn_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/params/purchase_order_grn_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/repositories/purchase_order_grn_repository.dart';

class PurchaseOrderGrnRepositoryImpl implements PurchaseOrderGrnRepository {
  final PurchaseOrderGrnRemoteDataSource remoteDataSource;

  PurchaseOrderGrnRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PurchaseOrderGrnListResultEntity>> listAllGrDocFromSAP(
    PurchaseOrderGrnListParams params,
  ) async {
    try {
      final model = await remoteDataSource.listAllGrDocFromSAP(params: params);
      if (model.data == null) {
        return right(
          const PurchaseOrderGrnListResultEntity(items: [], totalRows: 0),
        );
      }
      return right(
        PurchaseOrderGrnListResultEntity(
          items: model.data!.data.map((item) => item.toEntity()).toList(),
          totalRows: model.data!.totalRows,
        ),
      );
    } on Failure catch (failure) {
      return left(failure);
    }
  }

  @override
  Future<Either<Failure, PurchaseOrderGrnItemResultEntity>>
  listAllGrItemsFromSAP(PurchaseOrderGrnItemQueryParams params) async {
    try {
      final model = await remoteDataSource.listAllGrItemsFromSAP(
        params: params,
      );
      if (model.data == null) {
        return right(
          const PurchaseOrderGrnItemResultEntity(items: [], totalRows: 0),
        );
      }
      final items =
          model.data!.data.isEmpty
              ? <PurchaseOrderGrnItemEntity>[]
              : model.data!.data.map((item) => item.toEntity()).toList();

      return right(
        PurchaseOrderGrnItemResultEntity(
          items: items,
          totalRows: model.data!.totalRows,
        ),
      );
    } on Failure catch (failure) {
      return left(failure);
    } catch (e) {
      return left(UnknownException(message: 'Error parsing GRN items: $e'));
    }
  }

  @override
  Future<Either<Failure, PurchaseOrderGrnItemResultEntity>>
  listCompletedGrnItems(PurchaseOrderGrnItemQueryParams params) async {
    try {
      final model = await remoteDataSource.listCompletedGrnItems(
        params: params,
      );
      if (model.data == null) {
        return right(
          const PurchaseOrderGrnItemResultEntity(items: [], totalRows: 0),
        );
      }
      final items =
          model.data!.data.isEmpty
              ? <PurchaseOrderGrnItemEntity>[]
              : model.data!.data.map((item) => item.toEntity()).toList();

      return right(
        PurchaseOrderGrnItemResultEntity(
          items: items,
          totalRows: model.data!.totalRows,
        ),
      );
    } on Failure catch (failure) {
      return left(failure);
    } catch (e) {
      return left(
        UnknownException(message: 'Error parsing completed GRN items: $e'),
      );
    }
  }
}
