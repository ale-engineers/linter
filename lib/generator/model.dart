import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
abstract class Model with _$Model {
  const factory Model({
    required String userId,
  }) = _Model;

  const Model._();

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);
}
