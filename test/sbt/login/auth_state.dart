import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linter/sbt/login/auth_api_model.dart';
import 'package:linter/sbt/login/auth_exception.dart';
import 'package:linter/sbt/login/auth_service.dart';
import 'package:linter/sbt/login/auth_state.dart';
import 'package:linter/utils/result.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late ProviderContainer container;
  late MockAuthService mockAuthService;

  setUpAll(() {
    registerFallbackValue('test_token'); // デフォルト値の登録
  });

  setUp(() {
    mockAuthService = MockAuthService();
    container = ProviderContainer(overrides: [
      authServiceProvider.overrideWithValue(mockAuthService),
    ]);
  });

  tearDown(() => container.dispose());

  group('Auth', () {
    final tokens = TokenModel(
      accessToken: 'valid_access_token',
      idToken: 'valid_id_token',
      refreshToken: 'valid_refresh_token',
      sub: 'test_user',
    );

    test('セキュアストレージの有効なトークン', () async {
      when(() => mockAuthService.getSecureTokens())
          .thenAnswer((_) async => Result.ok(tokens));

      when(() => mockAuthService.verifyToken(
            tokens.accessToken,
            isAccessToken: true,
          )).thenAnswer((_) async => Result.ok(true));
      when(() => mockAuthService.saveTokens(tokens))
          .thenAnswer((_) async => Result.ok(null));
      when(() => mockAuthService.completedLogin(tokens.accessToken))
          .thenAnswer((_) async => Result.ok(null));

      final state = await container.read(authProvider.future);

      expect(state, isNotNull);
      expect(state.isAuthenticated, isTrue);
      expect(state.appUser?.id, 'test_user');
    });

    test('セキュアストレージの無効なトークン、リフレッシュトークンを使って取得', () async {
      final updatedTokens = tokens.copyWith(accessToken: 'new_access_token');
      final newTokens = tokens.copyWith(accessToken: 'new_access_token');
      when(() => mockAuthService.getSecureTokens())
          .thenAnswer((_) async => Result.ok(tokens));

      /// アクセストークンが無効
      when(() => mockAuthService.verifyToken(
            tokens.accessToken,
            isAccessToken: true,
          )).thenAnswer((_) async => Result.ok(false));

      /// リフレッシュトークンは有効
      when(() => mockAuthService.verifyToken(
            tokens.refreshToken,
            isAccessToken: false,
          )).thenAnswer((_) async => Result.ok(true));

      /// 新しいトークンを取得
      when(() => mockAuthService.getTokensByRefreshToken(tokens.refreshToken))
          .thenAnswer((_) async => Result.ok(newTokens));

      /// 新しいトークンを保存
      when(() => mockAuthService.saveTokens(newTokens))
          .thenAnswer((_) async => Result.ok(null));

      /// 新しいアクセストークンでログイン完了
      when(() => mockAuthService.completedLogin(newTokens.accessToken))
          .thenAnswer((_) async => Result.ok(null));

      final state = await container.read(authProvider.future);

      expect(state, isNotNull);
      expect(state.isAuthenticated, isTrue);
      expect(state.appUser?.accessToken, 'new_access_token');
    });

    test('アクセストークン、リフレッシュトークン共に無効', () async {
      when(() => mockAuthService.getSecureTokens())
          .thenAnswer((_) async => Result.ok(tokens));

      /// アクセストークンが無効
      when(() => mockAuthService.verifyToken(
            tokens.accessToken,
            isAccessToken: true,
          )).thenAnswer((_) async => Result.ok(false));

      /// リフレッシュトークンも無効
      when(() => mockAuthService.verifyToken(
            tokens.refreshToken,
            isAccessToken: false,
          )).thenAnswer((_) async => Result.ok(false));

      /// 認証コードが必要なエラーが発生する
      expect(
        () async => await container.read(authProvider.future),
        throwsA(AuthExceptionType.requiredAuthCode),
      );
    });
  });
}
