import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/datasources/remote/grn_list_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/repositories/grn_list_repository.dart';

class GrnListRepositoryImpl implements GrnListRepository {
  final GrnListRemoteDataSource remoteDataSource;

  GrnListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<GrnListItemEntity>>> listAllGrDocFromSAP(
    GrnListParams params,
  ) async {
    try {
      final model = await remoteDataSource.listAllGrDocFromSAP(params: params);
      return right(model.data.map((item) => item.toEntity()).toList());
    } on Failure catch (failure) {
      return left(failure);
    }
  }
}

