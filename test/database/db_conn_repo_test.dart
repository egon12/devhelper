import 'package:test/test.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:devhelper/database/db_conn.dart';
import 'package:devhelper/database/db_conn_repo.dart';

void main() {
  test('test save one and get', () async {
    var db = await getDB();
    var repo = DBConnInfoRepo(db: db);
    var c = DBConnInfo.url('somehost');
    await repo.save(c);

    var all = await repo.all();
    expect(1, all.length);

    var first = all.first;
    var anotherFirst = await repo.get(first.uuid);
    expect("somehost", anotherFirst.urlString);
  });

  test('test save more than one and delete', () async {
    var db = await getDB();
    var repo = DBConnInfoRepo(db: db);

    Future.wait(['satu', 'dua', 'tiga', 'satu', 'dua']
        .map(DBConnInfo.url)
        .map(repo.save));

    var all = await repo.all();
    expect(3, all.length);

    var dua = DBConnInfo.url('dua');
    await repo.delete(dua.uuid);

    all = await repo.all();
    expect(2, all.length);
  });

  test('test save to update', () async {
    var db = await getDB();
    var repo = DBConnInfoRepo(db: db);

    var c = DBConnInfo.url('satu');
    await repo.save(c);

    var beforeUpdate = await repo.get(c.uuid);

    c.urlString = 'dua';
    await repo.save(c);

    var afterUpdate = await repo.get(c.uuid);

    expect(beforeUpdate.uuid, afterUpdate.uuid);
    expect('satu', beforeUpdate.urlString);
    expect('dua', afterUpdate.urlString);
  });
}

Database? db;
Future<Database> getDB() async {
  if (db != null) {
    await db!.execute(DBConnInfoRepo.downgrade);
    await db!.execute(DBConnInfoRepo.createQuery);
    return db!;
  }
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

  db = await databaseFactory.openDatabase(inMemoryDatabasePath);
  await db!.execute(DBConnInfoRepo.createQuery);

  return db!;
}
