import 'package:devhelper/database/column_info.dart';
import 'package:devhelper/string_extensions.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:postgres/postgres.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBConnItf {
  Future<void> connect(Uri uri);
  Future<bool> test(Uri uri);
  Future<TableData> query(String query);
  Future<List<String>> get tables;

  static Future<DBConnItf> connectTo(Uri url) async {
    switch (url.scheme) {
      case 'postgres':
        var conn = PostgresDBConn();
        await conn.connect(url);
        return conn;
      case 'mysql':
        var conn = MysqlDBConn();
        await conn.connect(url);
        return conn;
      case 'sqlite':
        var conn = SqliteDBConn();
        await conn.connect(url);
        return conn;
      default:
        throw ArgumentError("Cannot handle ${url.scheme} database");
    }
  }

  static Future<bool> testURL(Uri url) =>
      _testURL(url).timeout(const Duration(seconds: 5));

  static Future<bool> _testURL(Uri url) async {
    switch (url.scheme) {
      case 'postgres':
        return PostgresDBConn().test(url);
      case 'mysql':
        return MysqlDBConn().test(url);
      case 'sqlite':
        return SqliteDBConn().test(url);
      default:
        throw Exception("unknown db type " + url.scheme);
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
        result?.map((row) => row.toColumnMap()).toList();
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
      password: url.password.isEmpty ? null : url.password,
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
  Future<TableData> query(String query) async {
    var result = await conn?.query(query);
    var columns = result?.fields.map((f) => ColumnInfo.withId(f.name ?? ''));

    RowsData? rows = result?.map((row) => row.fields).toList();

    return TableData(
      rows ?? List.empty(),
      columns ?? List.empty(),
    );
  }

  @override
  Future<List<String>> get tables async {
    var result = await conn?.query('SHOW TABLES');
    return result?.map((r) => r.values?[0] as String).toList() ?? List.empty();
  }
}

class SqliteDBConn extends GetxService implements DBConnItf {
  Database? conn;

  /// Expects a URI like: sqlite:///absolute/path/to/db.sqlite
  /// or sqlite://relative/path/to/db.sqlite
  String _resolvePath(Uri url) {
    // uri.path gives us the file path portion
    return url.toFilePath();
  }

  @override
  Future<void> connect(Uri url) async {
    conn = await openDatabase(_resolvePath(url));
  }

  @override
  Future<bool> test(Uri url) async {
    final db = await openDatabase(_resolvePath(url));
    await db.close();
    return true;
  }

  @override
  Future<TableData> query(String sql) async {
    final db = conn;
    if (db == null) throw StateError("Not connected");

    final result = await db.rawQuery(sql);

    if (result.isEmpty) {
      return TableData(List.empty(), List.empty());
    }

    final columns = result.first.keys.map((k) => ColumnInfo.withId(k));
    final RowsData rows = result.map((row) => Map<String, dynamic>.from(row)).toList();

    return TableData(rows, columns);
  }

  @override
  Future<List<String>> get tables async {
    final db = conn;
    if (db == null) throw StateError("Not connected");

    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name",
    );

    return result.map((row) => row['name'] as String).toList();
  }
}
