import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_list_params.dart';

abstract class OutboundDeliveryStoRepository {
  Future<Either<Failure, List<OutboundDeliveryStoEntity>>>
  listAllStockDocFromSAP({required OutboundDeliveryStoListParams params});
}
