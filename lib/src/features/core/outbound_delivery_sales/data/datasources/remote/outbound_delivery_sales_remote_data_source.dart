import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/data/models/create_sales_order_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/data/models/outbound_delivery_sales_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/data/models/outbound_delivery_sales_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_list_params.dart';

abstract class OutboundDeliverySalesRemoteDataSource {
  Future<OutboundDeliverySalesListResponseModel> listAllSalesOrderDocFromSAP({
    required OutboundDeliverySalesListParams params,
  });

  Future<OutboundDeliverySalesItemResponseModel> listAllSalesOrderItemFromSAP({
    required OutboundDeliverySalesItemParams params,
  });

  Future<OutboundDeliverySalesItemResponseModel> listCompletedSalesOrderItems({
    required OutboundDeliverySalesItemParams params,
  });

  Future<ApiResponse<bool>> createSalesOrder({
    required CreateSalesOrderRequestModel request,
  });
}

