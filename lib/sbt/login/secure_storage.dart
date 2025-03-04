import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:linter/sbt/login/secure_token_model.dart';
import 'package:linter/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

@riverpod
FlutterSecureStorage flutterSecureStorage(Ref ref) => FlutterSecureStorage();

@riverpod
SecureStorageAdapter secureStorageAdapterProvider(Ref ref) {
  return SecureStorageAdapter(storage: ref.read(flutterSecureStorageProvider));
}

class SecureStorageAdapter {
  SecureStorageAdapter({required FlutterSecureStorage storage})
      : _storage = storage;

  final FlutterSecureStorage _storage;

  Future<Result<void>> saveToken(SecureTokenModel tokenModel) async {
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
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(Exception('エラーが発生しました: ${e.toString()}'));
    }
  }

  // Future<Result<SecureTokenModel>> getToken() async {
  //   try {
  //     final accessToken = await _storage.read(key: 'access_token');
  //   } catch (e) {
  //     print('test');
  //   }
  // }
}
