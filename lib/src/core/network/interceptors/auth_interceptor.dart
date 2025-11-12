import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/services/app_preferences.dart';
import 'package:neuconnectz_dynea/src/core/services/session_service.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor({required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains(ApiEndpoints.refreshToken.value)) {
      return handler.next(options);
    }

    final accessToken = AppPreferences().getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.cancel) {
      handler.next(err);
      return;
    }
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains(ApiEndpoints.refreshToken.value)) {
      log("Received 401 error. Trying to refresh token...");
      final success = await _handleTokenRefresh();
      if (success) {
        try {
          final updatedRequest = await _retry(err.requestOptions);
          return handler.resolve(updatedRequest);
        } on DioException catch (e, st) {
          log("Retry after refresh failed: $e\n$st");
          return handler.reject(e);
        }
      } else {
        log("Token refresh failed. Clearing tokens and ending session.");
        await AppPreferences().clearTokens();
        SessionManager.showSessionExpiredDialog();
        return;
      }
    }

    handler.next(err);
  }

  Future<bool> _handleTokenRefresh() async {
    try {
      final refreshToken = AppPreferences().getRefreshToken();
      if (refreshToken == null) return false;

      final response = await dio.post(
        ApiEndpoints.refreshToken.value,
        data: {
          'refreshToken': refreshToken,
          "accessToken": AppPreferences().getAccessToken(),
        },
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['data']['accessToken'];
        final newRefreshToken = response.data['data']['refreshToken'];

        await AppPreferences().saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        return true;
      }
      return false;
    } catch (e, st) {
      log("Error during token refresh: $e\n$st");
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final accessToken = AppPreferences().getAccessToken();
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $accessToken',
      },
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
