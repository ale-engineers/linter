import 'package:flutter_test/flutter_test.dart';
import 'package:linter/utils/result.dart';
import 'package:linter/version_check/adapter.dart';
import 'package:mocktail/mocktail.dart';

import '../testing/utils/result.dart';

// モッククラスの定義
class MockDeviceInfo extends Mock implements DeviceInfo {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockDeviceInfo mockDeviceInfo;
  late MockApiClient mockApiClient;
  late AuthService authService;

  setUp(() {
    mockDeviceInfo = MockDeviceInfo();
    mockApiClient = MockApiClient();
    authService = AuthService(
      deviceInfo: mockDeviceInfo,
      apiClient: mockApiClient,
    );
  });

  group('checkVersion のテスト', () {
    test('アプリのバージョンが最新の場合、false を返す', () async {
      when(() => mockDeviceInfo.getDeviceVersion())
          .thenAnswer((_) async => Result.ok('1.0.0'));

      when(() => mockApiClient.getVersions()).thenAnswer(
        (_) async => Result.ok(VersionApiResponse(
          iosAppVersion: '1.0.0',
          iosReleaseVersion: '1',
          androidAppVersion: '1.0.0',
          androidReleaseVersion: '1',
        )),
      );

      final result = await authService.checkVersion();

      expect(result.asOk.value, false);
    });

    test('アプリのバージョンが古い場合、true を返す', () async {
      when(() => mockDeviceInfo.getDeviceVersion())
          .thenAnswer((_) async => Result.ok('0.9.0'));

      when(() => mockApiClient.getVersions()).thenAnswer(
        (_) async => Result.ok(VersionApiResponse(
          iosAppVersion: '1.0.0',
          iosReleaseVersion: '1',
          androidAppVersion: '1.0.0',
          androidReleaseVersion: '1',
        )),
      );

      final result = await authService.checkVersion();

      expect(result.asOk.value, true);
    });

    test('アプリのバージョンが新しい場合、false を返す', () async {
      when(() => mockDeviceInfo.getDeviceVersion())
          .thenAnswer((_) async => Result.ok('1.1.0'));

      when(() => mockApiClient.getVersions()).thenAnswer(
        (_) async => Result.ok(VersionApiResponse(
          iosAppVersion: '1.0.0',
          iosReleaseVersion: '1',
          androidAppVersion: '1.0.0',
          androidReleaseVersion: '1',
        )),
      );

      final result = await authService.checkVersion();

      expect(result.asOk.value, false);
    });
  });
}
