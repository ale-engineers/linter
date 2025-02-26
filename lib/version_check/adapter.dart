// ignore_for_file: invalid_annotation_target

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linter/utils/result.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'adapter.freezed.dart';
part 'adapter.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('テストを開始');
  final t = await ApiClient().getVersions();
  print(t);
  print('アプリのバージョンチェックを開始');
  await AuthService(
    deviceInfo: DeviceInfo(),
    apiClient: ApiClient(),
  ).checkVersion();
  print('アプリのバージョンチェックが完了しました');
}

@riverpod
AuthService authService(Ref ref) => AuthService(
      deviceInfo: ref.read(deviceInfoProvider),
      apiClient: ref.read(apiClientProvider),
    );

class AuthService {
  final DeviceInfo _deviceInfo;
  final ApiClient _apiClient;

  AuthService({
    required DeviceInfo deviceInfo,
    required ApiClient apiClient,
  })  : _deviceInfo = deviceInfo,
        _apiClient = apiClient;

  Future<Result<bool>> checkVersion() async {
    /// デバイスのバージョンを取得
    final versionResult = await _deviceInfo.getDeviceVersion();
    switch (versionResult) {
      case Error<String>():
        return Result.error(Exception(versionResult.error));
      case Ok<String>():
    }

    /// APIから最新のバージョンを取得
    final versionByApiResult = await _apiClient.getVersions();
    switch (versionByApiResult) {
      case Error<VersionApiResponse>():
        return Result.error(Exception(versionByApiResult.error));
      case Ok<VersionApiResponse>():
    }

    final versionRes = versionByApiResult.value;

    final isUpdateRequired = _checkUpdateRequired(
      current: versionResult.value,
      latest: Platform.isIOS
          ? versionRes.iosAppVersion
          : versionRes.androidAppVersion,
    );

    return Result.ok(isUpdateRequired);
  }

  bool _checkUpdateRequired({
    required String current,
    required String latest,
  }) {
    final currentParts = current.split('.').map(int.parse).toList();
    final latestParts = latest.split('.').map(int.parse).toList();

    bool needsUpdate = false;

    latestParts.asMap().forEach((i, latestPart) {
      if (needsUpdate) return; // すでに更新が必要なら処理を続けない

      final currentPart = (i < currentParts.length) ? currentParts[i] : 0;

      if (currentPart < latestPart) {
        needsUpdate = true;
      } else if (currentPart > latestPart) {
        needsUpdate = false;
      }
    });

    return needsUpdate;
  }
}

@riverpod
DeviceInfo deviceInfo(Ref ref) => DeviceInfo();

class DeviceInfo {
  Future<Result<String>> getDeviceVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return Result.ok(packageInfo.version);
    } catch (e) {
      return Result.error(
        Exception('アプリのバージョンを取得できませんでした。アプリを再起動してください。'),
      );
    }
  }
}

@freezed
abstract class VersionApiResponse with _$VersionApiResponse {
  const factory VersionApiResponse({
    @JsonKey(name: 'ios_app_version') required String iosAppVersion,
    @JsonKey(name: 'ios_release_version') required String iosReleaseVersion,
    @JsonKey(name: 'Android_app_version')
    required String androidAppVersion, // 大文字始まり対応
    @JsonKey(name: 'Android_release_version')
    required String androidReleaseVersion, // 大文字始まり対応
  }) = _VersionApiResponse;

  const VersionApiResponse._();

  factory VersionApiResponse.fromJson(Map<String, dynamic> json) =>
      _$VersionApiResponseFromJson(json);
}

@riverpod
ApiClient apiClient(Ref ref) => ApiClient();

class ApiClient {
  Future<Result<VersionApiResponse>> getVersions() async {
    final response = {
      'ios_app_version': '1.0.0',
      'ios_release_version': '1',
      'Android_app_version': '1.0.0',
      'Android_release_version': '1',
    };

    return Result.ok(VersionApiResponse.fromJson(response));
  }
}
