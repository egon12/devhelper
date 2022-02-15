import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_controller.dart';
import 'mfizz_icon.dart';

class MainList extends GetView<MainController> {
  const MainList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Image(image: AssetImage('images/app_logo_512.webp')),
        backgroundColor: const Color(0xff275379),
        title: const Text('DH SQL Client'),
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
        child: const Icon(Icons.add),
        onPressed: () => controller.edit(),
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
    MainController controller = Get.find();

    List<Widget> buttons = List.empty();
    if (conn?.selected ?? false) {
      buttons = [
        IconButton(
          onPressed: () => controller.edit(conn),
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: delete,
          icon: const Icon(Icons.delete),
        ),
      ];
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey.shade900,
        child: Center(child: Icon(conn.icon)),
      ),
      title: Text(
        conn.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(conn.subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: buttons,
      ),
      onTap: () => Get.toNamed('/query', arguments: conn), 
      onLongPress: select,
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
