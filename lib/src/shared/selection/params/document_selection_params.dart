import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/params/purchase_order_grn_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/params/reservation_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/presentation/params/stock_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/params/outbound_delivery_sales_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/bin_selection_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/params/inbound_delivery_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_listing_page_params.dart';

class DocumentSelectionParams<T extends Object> {
  final String title;
  final bool requiresMovementType;
  final bool isScaffold;
  final SelectionDestination<T> destination;

  const DocumentSelectionParams({
    required this.title,
    required this.destination,
    this.requiresMovementType = false,
    this.isScaffold = true,
  });
}

class SelectionDestination<T extends Object> {
  const SelectionDestination({
    required this.routeName,
    required this.buildArgs,
  });

  final String routeName;
  final T Function({
    required PlantEntity plant,
    required WarehouseEntity warehouse,
    MovementTypeEntity? movementType,
  })
  buildArgs;
}

class DocumentSelectionConfigs {
  static DocumentSelectionParams<PurchaseOrderGrnListingPageParams> grn({
    bool isScaffold = true,
  }) {
    return DocumentSelectionParams(
      title: AppTexts.putAwayAgainstGrn,
      isScaffold: isScaffold,
      destination: SelectionDestination(
        routeName: AppRoutes.grnListing,
        buildArgs:
            ({
              required PlantEntity plant,
              required WarehouseEntity warehouse,
              MovementTypeEntity? movementType,
            }) => PurchaseOrderGrnListingPageParams(
              plant: plant,
              warehouse: warehouse,
            ),
      ),
    );
  }

  static DocumentSelectionParams<ReservationListingPageParams> reservation({
    bool isScaffold = true,
  }) {
    return DocumentSelectionParams(
      title: AppTexts.pickingAgainstReservation,
      requiresMovementType: true,
      isScaffold: isScaffold,
      destination: SelectionDestination(
        routeName: AppRoutes.reservationListing,
        buildArgs: ({
          required PlantEntity plant,
          required WarehouseEntity warehouse,
          MovementTypeEntity? movementType,
        }) {
          return ReservationListingPageParams(
            plant: plant.code,
            storageLocation: warehouse.storageLocationCode ?? '',
            movementType: movementType?.movementType ?? "",
            warehouseCode: warehouse.code,
            warehouse: warehouse,
          );
        },
      ),
    );
  }

  static DocumentSelectionParams<StockListingPageParams> stockCheck({
    bool isScaffold = true,
  }) {
    return DocumentSelectionParams(
      title: AppTexts.stockCheck,
      isScaffold: isScaffold,
      destination: SelectionDestination(
        routeName: AppRoutes.stockCheck,
        buildArgs:
            ({
              required PlantEntity plant,
              required WarehouseEntity warehouse,
              MovementTypeEntity? movementType,
            }) => StockListingPageParams(plant: plant, warehouse: warehouse),
      ),
    );
  }

  static DocumentSelectionParams<OutboundDeliveryStoListParams>
  outboundDeliverySto({bool isScaffold = true}) {
    return DocumentSelectionParams(
      title: AppTexts.outboundDeliverySto,
      requiresMovementType: false,
      isScaffold: isScaffold,
      destination: SelectionDestination(
        routeName: AppRoutes.outboundDeliveryStoListing,
        buildArgs: ({
          required PlantEntity plant,
          required WarehouseEntity warehouse,
          MovementTypeEntity? movementType,
        }) {
          return OutboundDeliveryStoListParams(
            plant: plant.code,
            storageLocation: warehouse.storageLocationCode ?? '',
            warehouseCode: warehouse.code,
            //movementType: movementType?.movementType ?? "",
          );
        },
      ),
    );
  }

  static DocumentSelectionParams<OutboundDeliverySalesListingPageParams>
  outboundDeliverySales({bool isScaffold = true}) {
    return DocumentSelectionParams(
      title: AppTexts.outboundDeliverySales,
      requiresMovementType: false,
      isScaffold: isScaffold,
      destination: SelectionDestination(
        routeName: AppRoutes.outboundDeliverySalesListing,
        buildArgs: ({
          required PlantEntity plant,
          required WarehouseEntity warehouse,
          MovementTypeEntity? movementType,
        }) {
          return OutboundDeliverySalesListingPageParams(
            plant: plant.code,
            storageLocation: warehouse.storageLocationCode ?? '',
            warehouseCode: warehouse.code,
            warehouse: warehouse,
          );
        },
      ),
    );
  }

  static DocumentSelectionParams<BinSelectionPageParams> binToBin({
    bool isScaffold = true,
  }) {
    return DocumentSelectionParams(
      title: AppTexts.binToBinTransfer,
      requiresMovementType: false,
      isScaffold: isScaffold,
      destination: SelectionDestination(
        routeName: AppRoutes.binSelection,
        buildArgs: ({
          required PlantEntity plant,
          required WarehouseEntity warehouse,
          MovementTypeEntity? movementType,
        }) {
          return BinSelectionPageParams(plant: plant, warehouse: warehouse);
        },
      ),
    );
  }

  static DocumentSelectionParams<InboundDeliveryListingPageParams>
  inboundDelivery({bool isScaffold = true}) {
    return DocumentSelectionParams(
      title: AppTexts.stoInboundReceipts,
      requiresMovementType: false,
      isScaffold: isScaffold,
      destination: SelectionDestination(
        routeName: AppRoutes.inboundDeliveryListing,
        buildArgs: ({
          required PlantEntity plant,
          required WarehouseEntity warehouse,
          MovementTypeEntity? movementType,
        }) {
          return InboundDeliveryListingPageParams(
            plant: plant,
            warehouse: warehouse,
          );
        },
      ),
    );
  }

  static DocumentSelectionParams<ProductionReceiptListingPageParams>
  productionReceipts({bool isScaffold = true}) {
    return DocumentSelectionParams(
      title: "Putaway Against Production Receipts",
      requiresMovementType: false,
      isScaffold: isScaffold,
      destination: SelectionDestination(
        routeName: AppRoutes.productionReceiptListing,
        buildArgs: ({
          required PlantEntity plant,
          required WarehouseEntity warehouse,
          MovementTypeEntity? movementType,
        }) {
          return ProductionReceiptListingPageParams(
            plant: plant,
            warehouse: warehouse,
          );
        },
      ),
    );
  }
}
