import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'database/db_conn.dart';
import 'edit_db.dart';
import 'main_controller.dart';
import 'query.dart';
import 'mfizz_icon.dart';

class MainList extends GetView<MainController> {
  const MainList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: controller.rx.obx(
        (state) => ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            var conn = state?[index];

            return DBConnInfoListTile(
              conn: conn,
              select: () => controller.select(conn),
              delete: () => controller.delete(conn),
            );
          },
          itemCount: state?.length ?? 0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('db/edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DBConnInfoListTile extends StatelessWidget {
  final DBConnInfoViewObject? conn;
  final Function() select;
  final Function() delete;

  const DBConnInfoListTile(
      {Key? key,
      required this.conn,
      required this.select,
      required this.delete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = List.empty();
    if (conn?.selected ?? false) {
      buttons = [
        IconButton(
          onPressed: () => Get.toNamed('/db/edit', arguments: conn),
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: delete,
          icon: const Icon(Icons.delete),
        ),
      ];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueGrey.shade900,
            child: Center(child: Icon(conn.icon)),
          ),
          title: Text(conn.title),
          subtitle: Text(conn.subtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: buttons,
          ),
          onTap: () => Get.to(Query(), arguments: conn),
          onLongPress: select,
        ),
      ),
    );
  }
}

extension _ListTile on DBConnInfoViewObject? {
  IconData get icon {
    if (this == null) {
      return Icons.question_answer;
    }
    switch (this?.url.scheme) {
      case 'postgres':
        return Mfizz.postgres;
      case 'mysql':
        return Mfizz.mysqlAlt;
      default:
        return Icons.question_answer;
    }
  }
}
