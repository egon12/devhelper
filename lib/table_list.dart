import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'database/real_db_conn.dart';

class TableListController extends GetxController {
  DBConnItf conn = Get.arguments as DBConnItf;

  var tables = List<String>.empty().reactive;

  var search = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _getTables();
  }

  late List<String> _all;

  void _getTables() {
    tables.append(() => () async {
          _all = await conn.tables;
          return _all;
        });
  }

  void onSearchChanged(String text) {
    if (text.isEmpty) {
      tables.value = _all;
      return;
    }
    tables.value = _all.where((name) => name.contains(text)).toList();
  }

  void done() {
    var val = tables.value?[0] ?? '';
    if (val.isEmpty) {
      Get.snackbar('Error', 'None tables to select!');
      return;
    }
    Get.back(result: val);
  }
}

class TableList extends StatelessWidget {
  const TableList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TableListController());

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Tables')),
      body: Column(children: [
        Expanded(
          child: controller.tables.obx(
            (state) => ListView.builder(
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(state?[index] ?? ''),
                onTap: () => Get.back(result: state?[index]),
              ),
              itemCount: state?.length ?? 0,
            ),
          ),
        ),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.search),
          ),
          controller: controller.search,
          textInputAction: TextInputAction.done,
          onChanged: controller.onSearchChanged,
          onSubmitted: (val) => controller.done(),
          autofocus: true,
        )
      ]),
    );
  }
}
