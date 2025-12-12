import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/repositories/outbound_delivery_sto_repository.dart';

class GetOutboundDeliveryStoListUseCase
    extends UseCase<List<OutboundDeliveryStoEntity>, OutboundDeliveryStoListParams> {
  final OutboundDeliveryStoRepository repository;

  GetOutboundDeliveryStoListUseCase(this.repository);

  @override
  Future<Either<Failure, List<OutboundDeliveryStoEntity>>> call(
    OutboundDeliveryStoListParams params,
  ) {
    return repository.listAllStockDocFromSAP(params: params);
  }
}


