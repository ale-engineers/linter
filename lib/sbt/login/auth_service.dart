import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linter/sbt/login/auth_api.dart';
import 'package:linter/sbt/login/auth_api_model.dart';
import 'package:linter/sbt/login/secure_storage.dart';
import 'package:linter/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(Ref ref) => AuthService(
      authApi: ref.read(authApiProvider),
      secureStorage: ref.read(secureStorageAdapterProvider),
    );

class AuthService {
  AuthService({
    required AuthApi authApi,
    required SecureStorageAdapter secureStorage,
  })  : _authApi = authApi,
        _secureStorage = secureStorage;

  final AuthApi _authApi;
  final SecureStorageAdapter _secureStorage;

  Future<Result<TokenModel?>> getSecureTokens() async {
    return await _secureStorage.getTokens();
  }

  Future<Result<bool>> verifyToken(
    String token, {
    required bool isAccessToken,
  }) async {
    return isAccessToken
        ? await _authApi.verifyAccessToken(token)
        : await _authApi.verifyRefreshToken(token);
  }

  Future<Result<TokenModel>> getTokensByRefreshToken(
    String refreshToken,
  ) async {
    return await _authApi.getTokensByRefreshToken(refreshToken);
  }

  Future<Result<void>> saveTokens(TokenModel tokens) async {
    return await _secureStorage.saveToken(tokens);
  }

  Future<Result<void>> completedLogin(String accessToken) async {
    return await _authApi.completedLogin(accessToken);
  }

  Future<Result<TokenModel>> getTokensByAuthCode(String authCode) async {
    return await _authApi.getTokensByAuthCode(authCode);
  }
}
