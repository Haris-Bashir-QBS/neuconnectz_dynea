import 'dart:async';

import 'package:dio/dio.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/errors/dio_exception_mapper.dart';

class ApiErrorHandler {
  static Future<T> executeGuarded<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw DioExceptionMapper.mapDioExceptionToFailure(e);
    } on FormatException catch (e) {
      throw ParsingException(message: 'Invalid JSON: ${e.message}');
    } catch (e) {
      throw UnknownException(message: 'Unexpected error: $e');
    }
  }
}
