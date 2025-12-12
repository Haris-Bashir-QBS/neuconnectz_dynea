import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/datasources/remote/purchase_order_grn_putaway_remote_datasource.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_create_putaway_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/repositories/purchase_order_putaway_repository.dart';

class PurchaseOrderGrnPutAwayRepositoryImpl
    implements PurchaseOrderGrnPutAwayRepository {
  final PurchaseOrderGrnPutAwayRemoteDataSource remoteDataSource;

  PurchaseOrderGrnPutAwayRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ApiResponse<bool>>> createPutAwayAgainstGr(
    CreatePurchaseOrderGrnPutAwayRequestModel request,
  ) async {
    try {
      final success = await remoteDataSource.createPutAwayAgainstGr(
        request: request,
      );
      return right(success);
    } on Failure catch (failure) {
      return left(failure);
    }
  }

  @override
  Future<Either<Failure, ApiResponse<bool>>> deletePutAwayOfPurchaseOrderGrn({
    required int docNum,
  }) async {
    try {
      final success = await remoteDataSource.deletePutAwayOfPurchaseOrderGrn(
        docNum: docNum,
      );
      return right(success);
    } on Failure catch (failure) {
      return left(failure);
    }
  }
}
