import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_api_model.freezed.dart';
part 'auth_api_model.g.dart';

@freezed
abstract class TokenModel with _$TokenModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TokenModel({
    required String accessToken,
    required String idToken,
    required String refreshToken,
    required String sub,
  }) = _TokenModel;

  const TokenModel._();

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);
}
