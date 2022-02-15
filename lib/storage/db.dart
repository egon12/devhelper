import 'dart:io';

import 'package:devhelper/database/db_conn_repo.dart';
import 'package:devhelper/database/query_repo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> getDB() {
  DatabaseFactory databaseFactory;
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    return databaseFactory.openDatabase(
      'projects.db',
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: onCreate,
        onUpgrade: onUpgrade,
        onDowngrade: onDowngrade,
      ),
    );
  }

  return openDatabase(
    'projects.db',
    version: 2,
    onCreate: onCreate,
    onUpgrade: onUpgrade,
    onDowngrade: onDowngrade,
  );
}

void onCreate(Database db, int version) async {
  var batch = db.batch();

  batch.execute(DBConnInfoRepo.createQuery);
  batch.execute(DBConnInfoRepo.initialDataQuery);

  batch.execute(QueryRepo.createQuery);
  batch.execute(QueryRepo.initialDataQuery);

  batch.commit();
}

void onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    var batch = db.batch();
    batch.execute(QueryRepo.createQuery);
    batch.execute(QueryRepo.initialDataQuery);
    await batch.commit();
  }
}

void onDowngrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion >= 2) {
    var batch = db.batch();
    batch.execute(QueryRepo.dropQuery);
    await batch.commit();
  }
}
