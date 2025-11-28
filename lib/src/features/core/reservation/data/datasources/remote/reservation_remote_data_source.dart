import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/create_picking_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/reservation_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/reservation_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_list_params.dart';

abstract class ReservationRemoteDataSource {
  Future<ReservationListResponseModel> listAllReservations({
    required ReservationListParams params,
  });

  Future<ReservationItemsResponseModel> listReservationItems({
    required ReservationItemParams params,
  });

  Future<ReservationItemsResponseModel> listCompletedReservationItems({
    required ReservationItemParams params,
  });

  Future<ApiResponse<bool>> createPickingAgainstReservation({
    required CreatePickingRequestModel request,
  });
}

