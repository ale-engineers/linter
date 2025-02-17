import 'package:freezed_annotation/freezed_annotation.dart';

part 'log.freezed.dart';
part 'log.g.dart';

@freezed
abstract class Log with _$Log {
  const factory Log({
    String? id,
  }) = _Log;

  const Log._();

  factory Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);
}
