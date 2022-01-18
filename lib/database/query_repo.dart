import 'package:get/state_manager.dart';
import 'package:sqflite/sqflite.dart';

class QueryRepo extends GetxService {
  // db is to the db to store the connection info
  // not db that will be connect
  final Database db;

  final _table = 'queries';

  final _whereOne = 'uuid = ?';

  final _upsertQuery = "INSERT INTO queries (uuid, query) VALUES(?, ?) " +
      "ON CONFLICT(uuid) DO UPDATE SET query=excluded.query";

  QueryRepo({required this.db});

  Future<String> get(String uuid) => db
      .query(_table, where: _whereOne, whereArgs: [uuid], limit: 1)
      .then((rows) => rows.first)
      .then((row) => row['query'] as String);

  Future<void> save(String uuid, String query) =>
      db.execute(_upsertQuery, [uuid, query]);

  Future<void> delete(String uuid) =>
      db.delete(_table, where: _whereOne, whereArgs: [uuid]);

  // Create query
  static String createQuery =
      'CREATE TABLE queries (uuid TEXT PRIMARY KEY, query TEXT)';

  // InitialData
  static String initialDataQuery = '''
    INSERT INTO queries (uuid, query) values
    (
      'bea961c3-0794-58c3-a6bb-148c6ea31060',
      '
CREATE TABLE expenses (id serial primary key, description varchar, amount decimal(10, 2));
n

INSERT INTO expenses (description, amount) values
(''gas'', 100),
(''entertainment'', 200),
(''food'', 50)
;

SELECT * FROM expenses;

DROP TABLE expenses;
'
    ),
    (
      'bea961c3-0794-58c3-a6bb-148c6ea31061',
      '
CREATE TABLE expenses (id serial primary key, description varchar, amount decimal(10, 2));

INSERT INTO expenses (description, amount) values
("gas", 100),
("entertainment", 200),
("food", 50)
;

SELECT * FROM expenses;

DROP TABLE expenses;
'
    )
      ''';

  // Downgrade drop
  static String dropQuery = 'DROP TABLE queries';
}
