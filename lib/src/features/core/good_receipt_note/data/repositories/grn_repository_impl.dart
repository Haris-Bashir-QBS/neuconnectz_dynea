import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/datasources/remote/grn_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_result_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/repositories/grn_repository.dart';

class GrnRepositoryImpl implements GrnRepository {
  final GrnRemoteDataSource remoteDataSource;

  GrnRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, GrnListResultEntity>> listAllGrDocFromSAP(
    GrnListParams params,
  ) async {
    try {
      final model = await remoteDataSource.listAllGrDocFromSAP(params: params);
      if (model.data == null) {
        return right(const GrnListResultEntity(items: [], totalRows: 0));
      }
      return right(
        GrnListResultEntity(
          items: model.data!.data.map((item) => item.toEntity()).toList(),
          totalRows: model.data!.totalRows,
        ),
      );
    } on Failure catch (failure) {
      return left(failure);
    }
  }

  @override
  Future<Either<Failure, GrnItemResultEntity>> listAllGrItemsFromSAP(
    GrnItemParams params,
  ) async {
    try {
      final model = await remoteDataSource.listAllGrItemsFromSAP(params: params);
      if (model.data == null) {
        return right(const GrnItemResultEntity(items: [], totalRows: 0));
      }
      final items =
          model.data!.data.isEmpty
              ? <GrnItemEntity>[]
              : model.data!.data.map((item) => item.toEntity()).toList();

      return right(
        GrnItemResultEntity(
          items: items,
          totalRows: model.data!.totalRows,
        ),
      );
    } on Failure catch (failure) {
      return left(failure);
    } catch (e) {
      return left(UnknownException(message: 'Error parsing GRN items: $e'));
    }
  }
}

