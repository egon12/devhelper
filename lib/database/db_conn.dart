import 'package:json_annotation/json_annotation.dart';

import '../uuid.dart';

part 'db_conn.g.dart';

@JsonSerializable()
class DBConnInfo {
  Uri url;
  final String uuid;

  DBConnInfo({required this.url, required this.uuid});

  String get urlString => url.toString();

  set urlString(String value) {
    url = Uri.parse(value);
  }

  factory DBConnInfo.name(String name) =>
      DBConnInfo(url: Uri.parse(name), uuid: genUUIDFromName(name));

  factory DBConnInfo.url(String url) =>
      DBConnInfo(url: Uri.parse(url), uuid: genUUIDFromName(url));

  factory DBConnInfo.empty() => DBConnInfo(url: Uri.parse(''), uuid: '');

  factory DBConnInfo.fromJson(Map<String, dynamic> json) =>
      _$DBConnInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DBConnInfoToJson(this);

  factory DBConnInfo.fromMap(Map<String, dynamic> json) =>
      _$DBConnInfoFromJson(json);

  Map<String, dynamic> toMap() => _$DBConnInfoToJson(this);
}
