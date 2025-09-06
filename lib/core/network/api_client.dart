import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  /// GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle successful response
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw ServerException(
        'Server returned ${response.statusCode}',
        response.statusCode.toString(),
      );
    }
  }

  /// Handle Dio errors
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout');

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['error-type'] ?? 'Server error occurred';

        switch (statusCode) {
          case 401:
            return InvalidApiKeyException(message, statusCode.toString());
          case 403:
            return RateLimitException(message, statusCode.toString());
          case 404:
            return UnsupportedCurrencyException(message, statusCode.toString());
          default:
            return ServerException(message, statusCode.toString());
        }

      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled');

      case DioExceptionType.unknown:
      default:
        return NetworkException(error.message ?? 'Unknown network error');
    }
  }
}
