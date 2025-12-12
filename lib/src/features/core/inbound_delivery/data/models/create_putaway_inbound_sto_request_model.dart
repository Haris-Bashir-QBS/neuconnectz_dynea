import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';

class CreatePutAwayInboundStoRequestModel {
  final String receivingPlant;
  final String receivingStorageLocation;
  final String receivingWarehouse;
  final String stoNo;
  final String outboundDeliveryNo;
  final String issuingPlant;
  final int stoItemNo;
  final int deliveryItemNo;
  final String batchNo;
  final String materialNo;
  final String? materialDescription;
  final String? uom;
  final List<BinQuantityModel> binQuantities;

  CreatePutAwayInboundStoRequestModel({
    required this.receivingPlant,
    required this.receivingStorageLocation,
    required this.receivingWarehouse,
    required this.stoNo,
    required this.outboundDeliveryNo,
    required this.issuingPlant,
    required this.stoItemNo,
    required this.deliveryItemNo,
    required this.batchNo,
    required this.materialNo,
    this.materialDescription,
    this.uom,
    required this.binQuantities,
  });

  factory CreatePutAwayInboundStoRequestModel.fromEntities({
    required InboundDeliveryEntity inboundDelivery,
    required InboundDeliveryItemEntity item,
    required List<BinEntity> bins,
    required String receivingPlant,
    required String receivingStorageLocation,
    required String receivingWarehouse,
  }) {
    final binModels = bins
        .map(
          (bin) => BinQuantityModel(
            id: bin.id,
            quantity: bin.selectedQuantity,
          ),
        )
        .toList();

    return CreatePutAwayInboundStoRequestModel(
      receivingPlant: receivingPlant,
      receivingStorageLocation: receivingStorageLocation,
      receivingWarehouse: receivingWarehouse,
      stoNo: inboundDelivery.stoNo,
      outboundDeliveryNo: inboundDelivery.outboundDeliveryNo,
      issuingPlant: inboundDelivery.issuingPlant,
      stoItemNo: item.stoItemNo,
      deliveryItemNo: item.deliveryItemNo,
      batchNo: item.batchNo,
      materialNo: item.materialNo ?? '',
      materialDescription: item.materialDescription,
      uom: item.uom,
      binQuantities: binModels,
    );
  }

  Map<String, dynamic> toJson() => {
        "receivingPlant": receivingPlant,
        "receivingStorageLocation": receivingStorageLocation,
        "receivingWarehouse": receivingWarehouse,
        "stoNo": stoNo,
        "outboundDeliveryNo": outboundDeliveryNo,
        "issuingPlant": issuingPlant,
        "stoItemNo": stoItemNo,
        "deliveryItemNo": deliveryItemNo,
        "batchNo": batchNo,
        "materialNo": materialNo,
        "materialDescription": materialDescription,
        "uom": uom,
        "binQuantities": binQuantities.map((bin) => bin.toJson()).toList(),
      };
}

class BinQuantityModel {
  final String id;
  final double quantity;

  BinQuantityModel({required this.id, required this.quantity});

  Map<String, dynamic> toJson() => {"id": id, "quantity": quantity};
}



