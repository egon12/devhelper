import 'dart:io';

import 'package:devhelper/database/db_conn_repo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> getDB() {
  DatabaseFactory databaseFactory;
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    databaseFactory.getDatabasesPath().then((i) => print(i));
    return databaseFactory.openDatabase(
      'projects.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: onCreate,
      ),
    );
  }

  return openDatabase(
    'projects.db',
    version: 1,
    onCreate: onCreate,
  );
}

void onCreate(Database db, int version) {
  var batch = db.batch();
  batch.execute(DBConnInfoRepo.createQuery);
  batch.execute(DBConnInfoRepo.initialDataQuery);
  batch.commit();
}
