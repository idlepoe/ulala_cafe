import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String id,
    required String name,
    required bool isPrivate,
    required String mode,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
