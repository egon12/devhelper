import 'package:sqflite/sqflite.dart';

import 'db_conn.dart';

class DBConnInfoRepo {
  // db is to the db to store the connection info
  // not db that will be connect
  final Database db;

  final _table = 'db_conn_info';

  final _whereOne = 'uuid = ?';

  final _upsertQuery = "INSERT INTO db_conn_info (uuid, url) VALUES(?, ?) " +
      "ON CONFLICT(uuid) DO UPDATE SET url=excluded.url";

  DBConnInfoRepo({required this.db});

  Future<Iterable<DBConnInfo>> all() =>
      db.query(_table).then((rows) => rows.map(DBConnInfo.fromMap));

  Future<DBConnInfo> get(String uuid) => db
      .query(_table, where: _whereOne, whereArgs: [uuid], limit: 1)
      .then((rows) => rows.first)
      .then(DBConnInfo.fromMap);

  Future<void> save(DBConnInfo c) =>
      db.execute(_upsertQuery, [c.uuid, c.url.toString()]);

  Future<void> delete(String uuid) =>
      db.delete(_table, where: _whereOne, whereArgs: [uuid]);

  // Create query
  static String createQuery =
      'CREATE TABLE db_conn_info (uuid TEXT PRIMARY KEY, url TEXT)';

  // Downgrade drop
  static String downgrade = 'DROP TABLE db_conn_info';
}
