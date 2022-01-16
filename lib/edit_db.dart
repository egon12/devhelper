import 'package:devhelper/database/db_conn.dart';
import 'package:devhelper/database/db_conn_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mfizz_icon.dart';

var EditDBGetPage = GetPage(
  name: "/db/edit",
  page: () => EditDB(),
  binding: EditDBBinding(),
);

class EditDBBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditDBController());
  }
}

class EditDBController extends GetxController {
  DBConnInfo? arguments = Get.arguments;

  final DBConnInfoRepo _repo = Get.find();

  @override
  void onInit() {
    super.onInit();
    _fillWithArguments();
  }

  void _fillWithArguments() {
    var arg = arguments;
    if (arg == null) {
      return;
    }
    switch (arg.url.scheme) {
      case 'postgres':
        dbtypesToggle[0] = true;
        break;
      case 'mysql':
        dbtypesToggle[1] = true;
        break;
      default:
    }
    var userInfos = arg.url.userInfo.split(':');
    var username = userInfos[0];
    var password = userInfos.length > 1 ? userInfos[1] : '';

    getTextController('username').text = username;
    getTextController('password').text = password;
    getTextController('host').text = arg.url.host;
    getTextController('port').text = arg.url.port.toString();
    getTextController('database').text = arg.url.path;
  }

  final Map<String, TextEditingController> _textControllerMap = {
    "username": TextEditingController(),
    "password": TextEditingController(),
    "host": TextEditingController(),
    "port": TextEditingController(),
    "database": TextEditingController(),
  };

  final Map<String, String> _value = {
    "dbtype": 'postgres',
    "username": '',
    "password": '',
    "host": '',
    "port": '',
    "database": '',
  };

  getTextController(name) {
    return _textControllerMap[name];
  }

  List<bool> dbtypesToggle = [false, false].obs;

  Uri getUri() {
    _textControllerMap.forEach((name, tc) {
      _value[name] = tc.text;
    });

    return Uri(
      scheme: _value['dbtype'],
      userInfo: _getUserInfo(),
      host: _value['host'],
      port: int.parse(_value['port'] ?? ''),
      path: _value['database'],
    );
  }

  Future<void> save() async {
    var url = getUri();
    var conn = arguments ?? DBConnInfo.url(url.toString())
      ..url = url;
    await _repo.save(conn);
  }

  String _getUserInfo() {
    if (_value['password']?.isEmpty ?? false) {
      return _value['username'] ?? '';
    }

    return (_value['username'] ?? '') + ':' + _value['password']!;
  }

  void selectDbType(int index) {
    for (var i = 0; i < dbtypesToggle.length; i++) {
      if (i == index) {
        dbtypesToggle[i] = true;
      } else {
        dbtypesToggle[i] = false;
      }
    }

    if (index == 0) {
      _value['dbtype'] = 'postgres';
    } else if (index == 1) {
      _value['dbtype'] = 'mysql';
    }
  }
}

class EditDB extends GetView<EditDBController> {
  EditDB({Key? key}) : super(key: key);

  final focusNode = FocusNode(debugLabel: 'EditDB');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Database')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'DB Conn',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      minLines: 2,
                      textInputAction: TextInputAction.next,
                    ),
                    TextButton(
                      child: const Text('Extract'),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    Obx(() => ToggleButtons(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: const [
                                  Icon(Mfizz.postgres),
                                  Text("PostgreSQL"),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: const [
                                  Icon(Mfizz.mysqlAlt),
                                  Text("MySQL"),
                                ],
                              ),
                            ),
                          ],
                          onPressed: controller.selectDbType,
                          isSelected: controller.dbtypesToggle,
                        )),
                    const EditTextField("username"),
                    const EditTextField("password"),
                    const EditTextField("host"),
                    const EditTextField("port"),
                    const EditTextField("database"),
                    ButtonBar(children: [
                      TextButton(
                        child: const Text('Test'),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                        child: const Text('Save'),
                        onPressed: controller.save,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class Label extends StatelessWidget {
  const Label(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12),
    );
  }
}

class EditTextField extends GetView<EditDBController> {
  const EditTextField(
    this.label, {
    Key? key,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label.capitalizeFirst,
          border: const OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
        controller: controller.getTextController(label),
      ),
    );
  }
}
