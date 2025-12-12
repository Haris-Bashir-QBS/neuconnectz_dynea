import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';

class CreatePutAwayInboundStoRequestModel {
  final String stoNo;
  final String outboundDeliveryNo;
  final String materialNo;
  final String? materialDescription;
  final String issuingPlant;
  final int stoItemNo;
  final int deliveryItemNo;
  final String batchNo;
  final double quantity;
  final List<BinQuantityModel> binQuantities;

  CreatePutAwayInboundStoRequestModel({
    required this.stoNo,
    required this.outboundDeliveryNo,
    required this.materialNo,
    this.materialDescription,
    required this.issuingPlant,
    required this.stoItemNo,
    required this.deliveryItemNo,
    required this.batchNo,
    required this.quantity,
    required this.binQuantities,
  });

  factory CreatePutAwayInboundStoRequestModel.fromEntities({
    required InboundDeliveryEntity inboundDelivery,
    required InboundDeliveryItemEntity item,
    required List<BinEntity> bins,
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
      stoNo: inboundDelivery.stoNo,
      outboundDeliveryNo: inboundDelivery.outboundDeliveryNo,
      materialNo: item.materialNo ?? '',
      materialDescription: item.materialDescription,
      issuingPlant: inboundDelivery.issuingPlant,
      stoItemNo: item.stoItemNo,
      deliveryItemNo: item.deliveryItemNo,
      batchNo: item.batchNo,
      quantity: item.quantity,
      binQuantities: binModels,
    );
  }

  Map<String, dynamic> toJson() => {
        "stoNo": stoNo,
        "outboundDeliveryNo": outboundDeliveryNo,
        "materialNo": materialNo,
        "materialDescription": materialDescription,
        "issuingPlant": issuingPlant,
        "stoItemNo": stoItemNo,
        "deliveryItemNo": deliveryItemNo,
        "batchNo": batchNo,
        "quantity": quantity,
        "binQuantities": binQuantities.map((bin) => bin.toJson()).toList(),
      };
}

class BinQuantityModel {
  final String id;
  final double quantity;

  BinQuantityModel({required this.id, required this.quantity});

  Map<String, dynamic> toJson() => {"id": id, "quantity": quantity};
}



