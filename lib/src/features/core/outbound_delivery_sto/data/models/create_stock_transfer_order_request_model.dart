import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_entity.dart';

class CreateStockTransferOrderRequestModel {
  final String selectedPlant;
  final String selectedWarehouse;
  final String deliveryNo;
  final String deliveryItemNo;
  final String uom;
  final String batchNumber;
  final String material;
  final String itemDescription;
  final String referenceDocument;
  final List<BatchQuantityModel> batchQuantities;

  CreateStockTransferOrderRequestModel({
    required this.selectedPlant,
    required this.selectedWarehouse,
    required this.deliveryNo,
    required this.deliveryItemNo,
    required this.uom,
    required this.batchNumber,
    required this.material,
    required this.itemDescription,
    required this.referenceDocument,
    required this.batchQuantities,
  });

  factory CreateStockTransferOrderRequestModel.fromEntities({
    required OutboundDeliveryStoItemEntity item,
    required String selectedPlant,
    required String selectedWarehouse,
    required List<StockEntity> stocks,
    required Map<String, double> batchQuantitiesMap,
  }) {
    final batchModels = batchQuantitiesMap.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => BatchQuantityModel(
            id: entry.key,
            quantity: entry.value,
          ),
        )
        .toList();

    // Use first batch number if available, otherwise use item.batch
    final firstBatch = stocks.isNotEmpty ? stocks.first.batch : item.batch;

    return CreateStockTransferOrderRequestModel(
      selectedPlant: selectedPlant,
      selectedWarehouse: selectedWarehouse,
      deliveryNo: item.delivery,
      deliveryItemNo: item.item.toString(),
      uom: item.baseUom,
      batchNumber: firstBatch,
      material: item.material,
      itemDescription: item.itemDescription,
      referenceDocument: item.referenceDocument,
      batchQuantities: batchModels,
    );
  }

  Map<String, dynamic> toJson() => {
        "selectedPlant": selectedPlant,
        "selectedWarehouse": selectedWarehouse,
        "deliveryNo": deliveryNo,
        "deliveryItemNo": deliveryItemNo,
        "uom": uom,
        "batchNumber": batchNumber,
        "material": material,
        "itemDescription": itemDescription,
        "referenceDocument": referenceDocument,
        "batchQuantities":
            batchQuantities.map((batch) => batch.toJson()).toList(),
      };
}

class BatchQuantityModel {
  final String id;
  final double quantity;

  BatchQuantityModel({required this.id, required this.quantity});

  Map<String, dynamic> toJson() => {"id": id, "quantity": quantity};
}

