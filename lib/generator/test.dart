import 'package:freezed_annotation/freezed_annotation.dart';

part 'test.freezed.dart';
part 'test.g.dart';

@freezed
abstract class Test with _$Test {
  const factory Test({
    required String userId,
  }) = _Test;

  const Test._();

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);
}
