import 'package:devhelper/edit_db.dart';
import 'package:devhelper/query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'uuid.dart';
import 'mfizz_icon.dart';

class _Conn {
  final Uri url;
  final String uuid;

  _Conn({required this.url, required this.uuid});

  factory _Conn.name(String name) =>
      _Conn(url: Uri.parse(name), uuid: genUUIDFromName(name));
}

var connList = [
  _Conn.name(
      'postgres://unicorn_user:magical_password@172.18.31.1:5432/tokopedia-recharge?sslmode=disable'),
  _Conn.name(
      'mysql://unicorn_user:magical_password@172.18.31.1:3366/tokopedia-recharge?sslmode=disable'),
  _Conn.name('postgres://172.18.31.1:5432/tokopedia-recharge?sslmode=disable'),
  _Conn.name('//172.18.31.1:5432/tokopedia-recharge?sslmode=disable'),
];

extension _IconGenerator on _Conn {
  IconData get icon {
    switch (url.scheme) {
      case 'postgres':
        return Mfizz.postgres;
      case 'mysql':
        return Mfizz.mysqlAlt;
      default:
        return Icons.question_answer;
    }
  }

  String get title {
    var username = url.userInfo.split(":")[0];
    return username + '@' + url.host;
  }

  String get subtitle {
    return url.path;
  }
}

class _Controller extends GetxController {}

class MainList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var c = connList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              child: ListTile(
                //leading: Icon(c.icon, size: 48, color: Colors.blueGrey),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade900,
                  child: Center(child: Icon(c.icon)),
                ),
                title: Text(c.title),
                subtitle: Text(c.subtitle),
                onTap: () {
                  Get.to(Query());
                },
                onLongPress: () {
                  Get.to(EditDB());
                },
              ),
            ),
          );
        },
        itemCount: connList.length,
      ),
    );
  }
}
