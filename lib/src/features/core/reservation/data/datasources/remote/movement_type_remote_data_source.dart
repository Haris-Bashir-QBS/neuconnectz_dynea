import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/movement_type_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/movement_type_params.dart';

abstract class MovementTypeRemoteDataSource {
  Future<MovementTypeResponseModel> listMovementTypes({
    required MovementTypeQueryParams params,
  });
}



