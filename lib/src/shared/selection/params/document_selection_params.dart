import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/params/grn_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/params/reservation_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/presentation/params/stock_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';

class DocumentSelectionParams<T extends Object> {
  final String title;
  final bool requiresMovementType;
  final SelectionDestination<T> destination;

  const DocumentSelectionParams({
    required this.title,
    required this.destination,
    this.requiresMovementType = false,
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
  static DocumentSelectionParams<GrnListingPageParams> grn() {
    return DocumentSelectionParams(
      title: AppTexts.putAwayAgainstGrn,
      destination: SelectionDestination(
        routeName: AppRoutes.grnListing,
        buildArgs:
            ({
              required PlantEntity plant,
              required WarehouseEntity warehouse,
              MovementTypeEntity? movementType,
            }) => GrnListingPageParams(plant: plant, warehouse: warehouse),
      ),
    );
  }

  static DocumentSelectionParams<ReservationListingPageParams> reservation() {
    return DocumentSelectionParams(
      title: AppTexts.pickingAgainstReservation,
      requiresMovementType: true,
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
          );
        },
      ),
    );
  }

  static DocumentSelectionParams<StockListingPageParams> stockCheck() {
    return DocumentSelectionParams(
      title: AppTexts.stockCheck,
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
}
