import 'package:dio/dio.dart';
import 'package:upyog/services/auth-service.dart';

class ApiService {
  final Dio dio = Dio();

  ApiService() {
    dio.options.baseUrl = 'https://niuatt.niua.in';
    dio.options.headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    // Add logging interceptor for debugging
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Only add authorization header for protected endpoints
        if (options.path != '/user/oauth/token') {
          String token = await AuthService().getAccessToken();
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('Request URL: ${options.baseUrl}${options.path}');
        print('Request Headers: ${options.headers}');
        print('Request Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response Status: ${response.statusCode}');
        print('Response Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  Future<Response> sendOtp(Map<String, dynamic> payload) async {
    try {
      print("Starting sendOtp request");
      print("Base URL: ${dio.options.baseUrl}");
      print("Headers: ${dio.options.headers}");
      print("Payload: $payload");
      // Convert payload to x-www-form-urlencoded format
      final formData = payload.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
      print("Encoded form data: $formData");

      final response = await dio.post(
        '/user/oauth/token',
        data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) =>
              true, // Accept all status codes for debugging
          followRedirects: true,
          maxRedirects: 5,
        ),
      );

      print("Response received:");
      print("Status code: ${response.statusCode}");
      print("Response data: ${response.data}");
      print("Response headers: ${response.headers}");
      return response;
    } catch (e) {
      print("Error in sendOtp:");
      if (e is DioException) {
        print("DioError type: ${e.type}");
        print("DioError message: ${e.message}");
        print("DioError response: ${e.response?.data}");
        print("DioError request: ${e.requestOptions.uri}");
        print("DioError headers: ${e.requestOptions.headers}");
      } else {
        print("Unexpected error: $e");
      }
      rethrow;
    }
  }
}
