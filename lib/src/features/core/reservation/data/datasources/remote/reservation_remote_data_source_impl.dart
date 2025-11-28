import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/datasources/remote/reservation_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/create_picking_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/reservation_item_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/reservation_list_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_list_params.dart';

class ReservationRemoteDataSourceImpl implements ReservationRemoteDataSource {
  final DioClient dio;

  ReservationRemoteDataSourceImpl({required this.dio});

  @override
  Future<ReservationListResponseModel> listAllReservations({
    required ReservationListParams params,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'plant': params.plant,
        'storageLocation': params.storageLocation,
        'movementType': params.movementType,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
        if (params.fromDate != null && params.fromDate!.isNotEmpty)
          'fromDate': params.fromDate,
        if (params.toDate != null && params.toDate!.isNotEmpty)
          'toDate': params.toDate,
        if (params.keyword != null && params.keyword!.isNotEmpty)
          'keyword': params.keyword,
      };

      final response = await dio.get(
        endpoint: ApiEndpoints.listAllReservationsFromSAP.value,
        queryParams: queryParams,
      );
      return ReservationListResponseModel.fromJson(response.data ?? {});
    });
  }

  @override
  Future<ReservationItemsResponseModel> listReservationItems({
    required ReservationItemParams params,
  }) async {
    return _fetchReservationItems(
      endpoint: ApiEndpoints.listAllReservationItemsFromSAP.value,
      params: params,
    );
  }

  @override
  Future<ReservationItemsResponseModel> listCompletedReservationItems({
    required ReservationItemParams params,
  }) async {
    return _fetchReservationItems(
      endpoint: ApiEndpoints.listCompletedReservationItemsFromSAP.value,
      params: params,
    );
  }

  Future<ReservationItemsResponseModel> _fetchReservationItems({
    required String endpoint,
    required ReservationItemParams params,
  }) {
    return ApiErrorHandler.executeGuarded(() async {
      final queryParams = {
        'reservationNo': params.reservationNo,
        'lastCount': params.lastCount,
        'skipRecords': params.skipRecords,
      };

      final response = await dio.get(
        endpoint: endpoint,
        queryParams: queryParams,
      );
      return ReservationItemsResponseModel.fromJson(response.data ?? {});
    });
  }

  @override
  Future<ApiResponse<bool>> createPickingAgainstReservation({
    required CreatePickingRequestModel request,
  }) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await dio.post(
        endpoint: ApiEndpoints.createPickingAgainstReservation.value,
        data: request.toJson(),
      );

      final code = response.statusCode;

      if (code == 200 || code == 201) {
        return ApiResponse<bool>.fromJson(response.data);
      }

      throw ServerException(
        statusCode: code,
        message:
            response.data?['message'] ??
            'Failed to create picking against reservation.',
      );
    });
  }
}

