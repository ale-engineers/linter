import 'package:freezed_annotation/freezed_annotation.dart';

part 'secure_token_model.freezed.dart';
part 'secure_token_model.g.dart';

@freezed
abstract class SecureTokenModel with _$SecureTokenModel {
  const factory SecureTokenModel({
    required String accessToken,
    required String idToken,
    required String refreshToken,
  }) = _SecureTokenModel;

  const SecureTokenModel._();

  factory SecureTokenModel.fromJson(Map<String, dynamic> json) =>
      _$SecureTokenModelFromJson(json);
}
