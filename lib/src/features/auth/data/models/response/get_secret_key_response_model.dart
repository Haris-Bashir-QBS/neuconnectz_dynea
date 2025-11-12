class GetSecretKeyResponseModel {
  final bool? isApiHandled;
  final bool? isRequestSuccess;
  final int? statusCode;
  final String? message;
  final String? data;
  final List<dynamic>? exception;

  GetSecretKeyResponseModel({
    this.isApiHandled,
    this.isRequestSuccess,
    this.statusCode,
    this.message,
    this.data,
    this.exception,
  });

  GetSecretKeyResponseModel.fromJson(Map<String, dynamic> json)
    : isApiHandled = json['isApiHandled'] as bool?,
      isRequestSuccess = json['isRequestSuccess'] as bool?,
      statusCode = json['statusCode'] as int?,
      message = json['message'] as String?,
      data = json['data'] as String?,
      exception = json['exception'] as List?;

  Map<String, dynamic> toJson() => {
    'isApiHandled': isApiHandled,
    'isRequestSuccess': isRequestSuccess,
    'statusCode': statusCode,
    'message': message,
    'data': data,
    'exception': exception,
  };
}
