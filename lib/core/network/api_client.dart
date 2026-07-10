import 'package:glowbebe/core/network/api_endpoints.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  Future<Map<String, dynamic>> get(String endpoint) async {
    // TODO: Implement HTTP GET request
    throw UnimplementedError('GET $endpoint');
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    // TODO: Implement HTTP POST request
    throw UnimplementedError('POST $endpoint');
  }

  String get baseUrl => ApiEndpoints.baseUrl;
}
