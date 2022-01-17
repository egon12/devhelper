import 'package:devhelper/database/db_conn.dart';
import 'package:devhelper/database/real_db_conn.dart';
import 'package:devhelper/table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'table_list.dart';

class QueryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QueryController());
  }
}

class QueryController extends GetxController {
  TextEditingController textCtrl = TextEditingController();

  FocusNode textFocus = FocusNode();

  late DBConnItf conn;

  DBConnInfo connInfo = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    _connectDB();
  }

  void _connectDB() async {
    conn = PostgresDBConn();
    await conn.connect(connInfo.url);
  }

  @override
  void onClose() {
    textFocus.dispose();
    super.onClose();
  }

  void addSelect() {
    textCtrl.text += 'SELECT * FROM ';
    textFocus.requestFocus();
  }

  void addInsert() {
    textCtrl.text += 'INSERT INTO ';
    textFocus.requestFocus();
  }

  void addUpdate() {
    textCtrl.text += 'UPDATE';
    textFocus.requestFocus();
  }

  void selectTable() async {
    var tableName = await Get.to(() => TableList(), arguments: conn);
    textCtrl.text += tableName;
  }

  void execute() {
    //Get.toNamed('query/result', arguments: [conn, textCtrl.text]);
    Get.to(() => DBTable(), arguments: [conn, textCtrl.text]);
  }
}

class Query extends GetView<QueryController> {
  Query({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyDB local')),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  maxLines: 300, // some bad hardcode
                  style: const TextStyle(fontFamily: 'Monospace'),
                  controller: controller.textCtrl,
                  focusNode: controller.textFocus,
                ),
              ),
            ),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                TextButton(
                    child: const Text('EXECUTE'),
                    onPressed: controller.execute),
                TextButton(
                    child: const Text('UPDATE'),
                    onPressed: controller.addUpdate),
                TextButton(
                    child: const Text('INSERT'),
                    onPressed: controller.addInsert),
                TextButton(
                    child: const Text('TABLES'),
                    onPressed: controller.selectTable),
                TextButton(
                    child: const Text('SELECT'),
                    onPressed: controller.addSelect),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
