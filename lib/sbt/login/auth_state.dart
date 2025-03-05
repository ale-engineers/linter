import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linter/sbt/login/app_user.dart';
import 'package:linter/sbt/login/auth_api_model.dart';
import 'package:linter/sbt/login/auth_exception.dart';
import 'package:linter/sbt/login/auth_service.dart';
import 'package:linter/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    AppUser? appUser,

    /// ログイン状態を示すフラグ
    @Default(false) bool isAuthenticated,
  }) = _AuthState;

  const AuthState._();

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}

@riverpod
AuthState? authState(Ref ref) => ref.watch(authProvider).valueOrNull;

@riverpod
AppUser? appUser(Ref ref) => ref.watch(authStateProvider)?.appUser;

/// ログインしているかどうか
@riverpod
bool isLogin(Ref ref) => ref.watch(authStateProvider)?.isAuthenticated ?? false;

@riverpod
class Auth extends _$Auth {
  AuthService get _authService => ref.read(authServiceProvider);

  @override
  FutureOr<AuthState> build() async {
    /// セキュアストレージに保存されているトークンを取得
    final savedTokens = await _getTokens();

    /// トークンが無い場合：
    /// WebView でログイン後 authCode を取得して loginByAuthCode を発火する
    if (savedTokens == null) {
      throw AuthExceptionType.requiredAuthCode;
    }

    /// アクセストークンが有効かを確認する
    final isAccessTokenValid =
        await _verifyToken(savedTokens.accessToken, isAccessToken: true);

    /// 有効の場合はログイン状態を返す
    if (isAccessTokenValid) {
      return await _completedLogin(savedTokens, isSavedToken: true);
    }

    /// アクセストークンが有効ではない場合：
    /// リフレッシュトークンの期限を確認して有効ならトークンを再取得する
    final isRefreshTokenValid =
        await _verifyToken(savedTokens.refreshToken, isAccessToken: false);

    if (!isRefreshTokenValid) {
      throw AuthExceptionType.requiredAuthCode;
    }

    final tokens = await _getTokenByRefreshToken(savedTokens.refreshToken);

    return await _completedLogin(tokens, isSavedToken: false);
  }

  /// セキュアストレージに保存されているトークンを取得
  Future<TokenModel?> _getTokens() async {
    final tokensResult = await _authService.getSecureTokens();
    switch (tokensResult) {
      case Ok<TokenModel?>():
        return tokensResult.value;
      case Error<TokenModel?>():
        throw tokensResult.error;
    }
  }

  /// アクセストークン or リフレッシュトークンの有効性を確認する
  Future<bool> _verifyToken(
    String token, {
    required bool isAccessToken,
  }) async {
    final result =
        await _authService.verifyToken(token, isAccessToken: isAccessToken);
    switch (result) {
      case Ok<bool>():
        return result.value;
      case Error<bool>():
        throw result.error;
    }
  }

  /// リフレッシュトークンを使ってトークンを再取得する
  Future<TokenModel> _getTokenByRefreshToken(String refreshToken) async {
    final tokensResult =
        await _authService.getTokensByRefreshToken(refreshToken);
    switch (tokensResult) {
      case Error<TokenModel>():
        throw tokensResult.error;
      case Ok<TokenModel>():
        return tokensResult.value;
    }
  }

  /// トークンがある状態でログイン完了を通知する
  Future<AuthState> _completedLogin(
    TokenModel tokens, {
    required bool isSavedToken,
  }) async {
    if (!isSavedToken) {
      final saveResult = await _authService.saveTokens(tokens);
      switch (saveResult) {
        case Error<void>():
          throw AuthExceptionType.secureStorageError;
        case Ok<void>():
      }
    }

    final result = await _authService.completedLogin(tokens.accessToken);
    switch (result) {
      case Ok<void>():
        return AuthState(
          appUser: AppUser(
            id: tokens.sub,
            accessToken: tokens.accessToken,
          ),
          isAuthenticated: true,
        );
      case Error<void>():
        throw result.error;
    }
  }

  /// AuthCode を使ってログインする
  Future<Result<void>> loginByAuthCode(String authCode) async {
    final tokenResult = await _authService.getTokensByAuthCode(authCode);
    switch (tokenResult) {
      case Ok<TokenModel>():
        final tokens = tokenResult.value;
        state = AsyncData(await _completedLogin(tokens, isSavedToken: false));
        return Result.ok(null);
      case Error<TokenModel>():
        throw AuthExceptionType.requiredAuthCode;
    }
  }
}
