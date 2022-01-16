import 'package:devhelper/database/db_conn_repo.dart';
import 'package:devhelper/edit_db.dart';
import 'package:devhelper/main_controller.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class MainBinding extends Bindings {
  Database? db;

  @override
  void dependencies() {
    Get.put(db);
    Get.lazyPut(() => DBConnInfoRepo(db: db!));
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => EditDBController());
  }
}
