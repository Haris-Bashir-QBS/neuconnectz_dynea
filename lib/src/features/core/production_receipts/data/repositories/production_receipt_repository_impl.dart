import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/data/datasources/remote/production_receipt_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/repositories/production_receipt_repository.dart';

class ProductionReceiptRepositoryImpl implements ProductionReceiptRepository {
  final ProductionReceiptRemoteDataSource remoteDataSource;

  ProductionReceiptRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProductionReceiptListResultEntity>>
      listProductionReceiptsFromSAP(ProductionReceiptListParams params) async {
    try {
      final response =
          await remoteDataSource.listProductionReceiptsFromSAP(params: params);
      if (response.data == null) {
        return right(
          const ProductionReceiptListResultEntity(items: [], totalRows: 0),
        );
      }
      return right(
        ProductionReceiptListResultEntity(
          items: response.data!.data.map((e) => e.toEntity()).toList(),
          totalRows: response.data!.totalRows,
        ),
      );
    } on Failure catch (failure) {
      return left(failure);
    }
  }

  @override
  Future<Either<Failure, ProductionReceiptItemResultEntity>>
      listProductionReceiptItemsFromSAP(
    ProductionReceiptItemQueryParams params,
  ) async {
    try {
      final response = await remoteDataSource.listProductionReceiptItemsFromSAP(
        params: params,
      );
      if (response.data == null) {
        return right(
          const ProductionReceiptItemResultEntity(items: [], totalRows: 0),
        );
      }

      final items = response.data!.data.isEmpty
          ? <ProductionReceiptItemEntity>[]
          : response.data!.data.map((e) => e.toEntity()).toList();

      return right(
        ProductionReceiptItemResultEntity(
          items: items,
          totalRows: response.data!.totalRows,
        ),
      );
    } on Failure catch (failure) {
      return left(failure);
    }
  }
}

