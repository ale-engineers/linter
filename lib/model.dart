import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
class Model with _$Model {
  const factory Model({
    required String id,
  }) = _Model;

  const Model._();

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);
}

@freezed
class User with _$User implements BaseModel {
  const factory User({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

abstract class BaseModel {
  DateTime get createdAt;
  DateTime get updatedAt;
}

main() {
  final user = User(
    id: '1',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  print(user.createdAt);
  print(user.updatedAt);
  print(user.id);
  print(user.toJson());
  print(user.toString());

  test(user);
}

void test(BaseModel model) {
  print(model.createdAt);
  print(model.updatedAt);
}
