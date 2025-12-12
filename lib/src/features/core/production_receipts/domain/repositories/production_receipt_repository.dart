import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_list_params.dart';

abstract class ProductionReceiptRepository {
  Future<Either<Failure, ProductionReceiptListResultEntity>>
      listProductionReceiptsFromSAP(ProductionReceiptListParams params);

  Future<Either<Failure, ProductionReceiptItemResultEntity>>
      listProductionReceiptItemsFromSAP(ProductionReceiptItemQueryParams params);
}

