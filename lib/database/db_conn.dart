import 'package:json_annotation/json_annotation.dart';

import '../uuid.dart';

part 'db_conn.g.dart';

@JsonSerializable()
class DBConnInfo {
  final String uuid;
  Uri url;

  DBConnInfo({required this.uuid, required this.url});

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

extension DBConnInfoDisplay on DBConnInfo? {
  String get title {
    var username = this?.url.userInfo.split(":")[0] ?? '';
    var host = this?.url.host ?? 'NULL HOST';
    return username + '@' + host;
  }

  String get subtitle {
    return this?.url.path ?? '';
  }
}