import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:linter/sbt/login/auth_api_model.dart';
import 'package:linter/sbt/login/auth_exception.dart';
import 'package:linter/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

@riverpod
FlutterSecureStorage flutterSecureStorage(Ref ref) => FlutterSecureStorage();

@riverpod
SecureStorageAdapter secureStorageAdapter(Ref ref) {
  return SecureStorageAdapter(storage: ref.read(flutterSecureStorageProvider));
}

class SecureStorageAdapter {
  SecureStorageAdapter({required FlutterSecureStorage storage})
      : _storage = storage;

  final FlutterSecureStorage _storage;

  Future<Result<void>> saveToken(TokenModel tokenModel) async {
    try {
      await _storage.write(
        key: 'access_token',
        value: tokenModel.accessToken,
      );
      await _storage.write(
        key: 'id_token',
        value: tokenModel.idToken,
      );
      await _storage.write(
        key: 'refresh_token',
        value: tokenModel.refreshToken,
      );
      await _storage.write(
        key: 'sub',
        value: tokenModel.sub,
      );
      return Result.ok(null);
    } on Exception catch (_) {
      throw AuthExceptionType.secureStorageError;
    }
  }

  Future<Result<TokenModel?>> getTokens() async {
    try {
      final accessToken = await _storage.read(key: 'access_token');
      final idToken = await _storage.read(key: 'id_token');
      final refreshToken = await _storage.read(key: 'refresh_token');
      final sub = await _storage.read(key: 'sub');
      if (accessToken == null ||
          idToken == null ||
          refreshToken == null ||
          sub == null) {
        return Result.ok(null);
      }
      return Result.ok(
        TokenModel(
          accessToken: accessToken,
          idToken: idToken,
          refreshToken: refreshToken,
          sub: sub,
        ),
      );
    } on Exception catch (_) {
      throw AuthExceptionType.secureStorageError;
    }
  }
}
