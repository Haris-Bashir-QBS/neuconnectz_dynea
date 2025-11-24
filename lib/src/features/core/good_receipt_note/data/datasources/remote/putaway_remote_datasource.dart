import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/models/create_putaway_request_model.dart';

abstract class PutAwayRemoteDataSource {
  Future<ApiResponse<bool>> createPutAwayAgainstGr({
    required CreatePutAwayRequestModel request,
  });
}
