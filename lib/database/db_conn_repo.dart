import 'package:get/state_manager.dart';
import 'package:sqflite/sqflite.dart';

import 'db_conn.dart';

class DBConnInfoRepo extends GetxService {
  // db is to the db to store the connection info
  // not db that will be connect
  final Database db;

  final _table = 'db_conn_info';

  final _whereOne = 'uuid = ?';

  final _upsertQuery = "INSERT INTO db_conn_info (uuid, url) VALUES(?, ?) " 
      "ON CONFLICT(uuid) DO UPDATE SET url=excluded.url";

  DBConnInfoRepo({required this.db});

  Future<Iterable<DBConnInfo>> all() =>
      db.query(_table).then((rows) => rows.map(DBConnInfo.fromMap).toList());

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

  // InitialData
  static String initialDataQuery = '''
    INSERT INTO db_conn_info (uuid, url) values
    (
      'bea961c3-0794-58c3-a6bb-148c6ea31060',
      'postgres://root:admin@127.0.0.1:5432/root'
    ),
    (
      'bea961c3-0794-58c3-a6bb-148c6ea31061',
      'mysql://root:admin@127.0.0.1:3336/mydb'
    )
      ''';

  // Downgrade drop
  static String dropQuery = 'DROP TABLE db_conn_info';
}
