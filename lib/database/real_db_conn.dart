import 'package:devhelper/database/column_info.dart';
import 'package:devhelper/string_extensions.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:postgres/postgres.dart';

abstract class DBConnItf {
  Future<void> connect(Uri uri);
  Future<bool> test(Uri uri);
  Future<TableData> query(String query);
  Future<List<String>> get tables;

  static Future<bool> testURL(Uri url) async {
    switch (url.scheme) {
      case 'postgres':
        return PostgresDBConn().test(url);
      case 'mysql':
        return MysqlDBConn().test(url);
      default:
        throw Exception("unkonwn db type " + url.scheme);
    }
  }
}

class PostgresDBConn extends GetxService implements DBConnItf {
  PostgreSQLConnection? conn;

  Uri? _lastUrl;

  @override
  Future<void> connect(Uri url) async {
    _lastUrl = url;
    conn = PostgreSQLConnection(url.host, url.port, url.pathOnly,
        username: url.username, password: url.password);
    await conn?.open();
  }

  Future<void> reconnect() async {
    var url = _lastUrl;
    if (url == null) {
      throw StateError("need to connect at least once before reconnect");
    }
    conn = PostgreSQLConnection(url.host, url.port, url.pathOnly,
        username: url.username, password: url.password);
    await conn?.open();
  }

  @override
  Future<bool> test(Uri url) async {
    conn = PostgreSQLConnection(url.host, url.port, url.pathOnly,
        username: url.username, password: url.password);
    await conn?.open();
    return true;
  }

  @override
  Future<TableData> query(String query) async {
    var result = await conn?.query(query);
    var columns = result?.columnDescriptions
        .map((cd) => ColumnInfo.withId(cd.columnName));

    RowsData? rows =
        result?.map((row) => row.toColumnMap() as RowData).toList();
    return TableData(
      rows ?? List.empty(),
      columns ?? List.empty(),
    );
  }

  @override
  Future<List<String>> get tables async {
    if (!isConnected) await reconnect();
    var result = await conn?.query(
        "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public'");
    var rows = result?.map((row) => row.toColumnMap()['tablename'] as String);
    return rows?.toList() ?? List.empty();
  }

  bool get isConnected => conn?.isClosed ?? false;
}

class MysqlDBConn extends GetxService implements DBConnItf {
  MySqlConnection? conn;

  @override
  Future<void> connect(Uri url) async {
    var c = ConnectionSettings(
      host: url.host,
      port: url.port,
      user: url.username,
      password: url.password,
      db: url.pathOnly,
    );
    conn = await MySqlConnection.connect(c);
  }

  @override
  Future<bool> test(Uri url) async {
    var c = ConnectionSettings(
      host: url.host,
      port: url.port,
      user: url.username,
      password: url.password,
      db: url.pathOnly,
    );
    conn = await MySqlConnection.connect(c);
    return true;
  }

  @override
  Future<TableData> query(String query) {
    throw UnimplementedError();
  }

  @override
  // TODO: implement tables
  Future<List<String>> get tables => throw UnimplementedError();
}
