import 'package:glowbebe/core/network/api_client.dart';
import 'package:glowbebe/core/network/api_endpoints.dart';
import 'package:glowbebe/features/auth/model/user_model.dart';

class AuthService {
  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response);
  }

  Future<UserModel> register({
    required String email,
    required String password,
    String? name,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      body: {'email': email, 'password': password, 'name': name},
    );
    return UserModel.fromJson(response);
  }

  Future<void> forgotPassword({required String email}) async {
    await _apiClient.post(
      ApiEndpoints.login,
      body: {'email': email},
    );
  }
}
