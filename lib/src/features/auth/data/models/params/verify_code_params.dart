import 'package:neuconnectz_dynea/src/core/enums/verification_type.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/user_model.dart';

class VerifyCodeParams {
  final VerificationType type;
  final UserModel? user;
  final String? email;

  VerifyCodeParams({required this.type, this.user, this.email});
}


