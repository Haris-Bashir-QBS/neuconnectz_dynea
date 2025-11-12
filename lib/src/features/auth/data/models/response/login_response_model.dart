import 'package:neuconnectz_dynea/src/features/auth/data/models/response/user_model.dart';

class LoginResponseModel {
  final bool? isApiHandled;
  final bool? isRequestSuccess;
  final int? statusCode;
  final String? message;
  final UserModel? user;
  final List<dynamic>? exception;

  LoginResponseModel({
    this.isApiHandled,
    this.isRequestSuccess,
    this.statusCode,
    this.message,
    this.user,
    this.exception,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json)
    : isApiHandled = json['isApiHandled'] as bool?,
      isRequestSuccess = json['isRequestSuccess'] as bool?,
      statusCode = json['statusCode'] as int?,
      message = json['message'] as String?,
      user =
          (json['data'] as Map<String, dynamic>?) != null
              ? UserModel.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      exception = json['exception'] as List?;

  Map<String, dynamic> toJson() => {
    'isApiHandled': isApiHandled,
    'isRequestSuccess': isRequestSuccess,
    'statusCode': statusCode,
    'message': message,
    'data': user?.toJson(),
    'exception': exception,
  };
}
