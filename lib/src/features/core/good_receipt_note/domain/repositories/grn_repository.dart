import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';

abstract class GrnRepository {
  Future<Either<Failure, GrnListResultEntity>> listAllGrDocFromSAP(
    GrnListParams params,
  );

  Future<Either<Failure, GrnItemResultEntity>> listAllGrItemsFromSAP(
    GrnItemParams params,
  );
}

