class ApiResponse<T> {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final T? data;
  final List<dynamic> exception;

  ApiResponse({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(Object? json)? fromJsonT,
  }) {
    return ApiResponse<T>(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T,
      exception: json['exception'] ?? [],
    );
  }
}
