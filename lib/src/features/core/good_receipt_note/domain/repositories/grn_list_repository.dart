import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';

abstract class GrnListRepository {
  Future<Either<Failure, List<GrnListItemEntity>>> listAllGrDocFromSAP(
    GrnListParams params,
  );
}

