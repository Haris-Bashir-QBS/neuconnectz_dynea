import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/data/models/create_production_receipt_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/data/models/production_receipt_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/data/models/production_receipt_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_list_params.dart';

abstract class ProductionReceiptRemoteDataSource {
  Future<ProductionReceiptListResponseModel> listProductionReceiptsFromSAP({
    required ProductionReceiptListParams params,
  });

  Future<ProductionReceiptItemResponseModel> listProductionReceiptItemsFromSAP({
    required ProductionReceiptItemQueryParams params,
  });

  Future<ProductionReceiptItemResponseModel> listCompletedProductionReceiptItems({
    required ProductionReceiptItemQueryParams params,
  });

  Future<ApiResponse<bool>> createProductionReceipt(
    CreateProductionReceiptRequestModel request,
  );

  Future<ApiResponse<bool>> deletePutawayAgainstProductionReceipt({
    required int docNum,
  });
}

