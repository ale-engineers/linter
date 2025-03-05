import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linter/sbt/login/auth_api_model.dart';
import 'package:linter/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_api.g.dart';

@riverpod
AuthApi authApi(Ref ref) => AuthApi();

class AuthApi {
  Future<Result<TokenModel>> getTokensByAuthCode(String authCode) async {
    final tokens = TokenModel(
      accessToken: 'access_token',
      idToken: 'id_token',
      refreshToken: 'refresh_token',
      sub: 'sub_user_12345',
    );
    return Result.ok(tokens);
  }

  Future<Result<bool>> verifyAccessToken(String accessToken) async {
    return const Result.ok(true);
  }

  Future<Result<bool>> verifyRefreshToken(String token) async {
    return const Result.ok(true);
  }

  Future<Result<void>> completedLogin(String accessToken) async {
    return const Result.ok(null);
  }

  Future<Result<TokenModel>> getTokensByRefreshToken(
    String refreshToken,
  ) async {
    final tokens = TokenModel(
      accessToken: 'access_token_01',
      idToken: 'id_token_01',
      refreshToken: 'refresh_token_01',
      sub: 'sub_user_12345_01',
    );
    return Result.ok(tokens);
  }
}
