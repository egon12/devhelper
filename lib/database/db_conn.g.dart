// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_conn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBConnInfo _$DBConnInfoFromJson(Map<String, dynamic> json) => DBConnInfo(
      url: Uri.parse(json['url'] as String),
      uuid: json['uuid'] as String,
    );

Map<String, dynamic> _$DBConnInfoToJson(DBConnInfo instance) =>
    <String, dynamic>{
      'url': instance.url.toString(),
      'uuid': instance.uuid,
    };
