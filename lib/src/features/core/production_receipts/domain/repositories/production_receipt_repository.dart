import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/data/models/create_production_receipt_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_list_params.dart';

abstract class ProductionReceiptRepository {
  Future<Either<Failure, ProductionReceiptListResultEntity>>
      listProductionReceiptsFromSAP(ProductionReceiptListParams params);

  Future<Either<Failure, ProductionReceiptItemResultEntity>>
      listProductionReceiptItemsFromSAP(ProductionReceiptItemQueryParams params);

  Future<Either<Failure, ProductionReceiptItemResultEntity>>
      listCompletedProductionReceiptItems(
    ProductionReceiptItemQueryParams params,
  );

  Future<Either<Failure, ApiResponse<bool>>> createProductionReceipt(
    CreateProductionReceiptRequestModel request,
  );

  Future<Either<Failure, ApiResponse<bool>>> deletePutawayAgainstProductionReceipt({
    required int docNum,
  });
}

