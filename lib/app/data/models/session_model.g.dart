// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
      id: json['id'] as String,
      name: json['name'] as String,
      isPrivate: json['isPrivate'] as bool,
      mode: json['mode'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isPrivate': instance.isPrivate,
      'mode': instance.mode,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
