import 'package:devhelper/database/db_conn.dart';
import 'package:devhelper/database/db_conn_repo.dart';
import 'package:devhelper/database/real_db_conn.dart';
import 'package:devhelper/string_extensions.dart';
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

  List<bool> dbtypesToggle = [false, false].obs;

  final Map<String, TextEditingController> _textControllerMap = {
    "username": TextEditingController(),
    "password": TextEditingController(),
    "host": TextEditingController(),
    "port": TextEditingController(),
    "database": TextEditingController(),
  };

  var connStringController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _fillWithArguments();
  }

  getTextController(name) {
    return _textControllerMap[name];
  }

  void selectDbType(int index) {
    for (var i = 0; i < dbtypesToggle.length; i++) {
      dbtypesToggle[i] = i == index;
    }
    update();
  }

  void extract() {
    var url = extractDbUrl(emailtext: connStringController.text);
    _fillWithUrl(url);
  }

  Future<void> test() async {
    try {
      var url = _getUrl();
      var result = await DBConnItf.testURL(url);
      if (result) {
        Get.snackbar('Success', 'Can connected to db');
      } else {
        Get.snackbar('Failed', 'Can\'t connected to db');
      }
    } catch (e) {
      Get.snackbar('Failed', e.toString());
    }
  }

  Future<void> save() async {
    try {
      var url = _getUrl();
      var conn = arguments ?? DBConnInfo.url(url.toString())
        ..url = url;
      await _repo.save(conn);
      Get.back(result: conn);
    } catch (e) {
      Get.snackbar('Failed', e.toString());
    }
  }

  Uri _getUrl() {
    return Uri(
      scheme: _getDBType(),
      userInfo: _getUserInfo(),
      host: _getText('host'),
      port: _getPort(),
      path: _getText('database'),
    );
  }

  String _getText(name) {
    return getTextController(name).text;
  }

  int? _getPort() {
    var port = _getText('port');
    if (port.isEmpty) return null;
    return int.parse(port);
  }

  void _fillWithArguments() {
    var arg = arguments;
    if (arg == null) {
      return;
    }

    _fillWithUrl(arg.url);
  }

  void _fillWithUrl(Uri url) {
    _setDBType(url.scheme);
    _setText('username', url.username);
    _setText('password', url.password);
    _setText('host', url.host);
    _setText('port', url.port.toString());
    _setText('database', url.path);
  }

  void _setText(String name, String value) {
    getTextController(name).text = value;
  }

  void _setDBType(dbname) {
    switch (dbname) {
      case 'postgres':
        dbtypesToggle[0] = true;
        break;
      case 'mysql':
        dbtypesToggle[1] = true;
        break;
      default:
    }
  }

  String _getUserInfo() {
    var pwd = _getText(password);
    if (pwd.isEmpty) {
      return _getText('username');
    }

    return _getText('username') + ':' + pwd;
  }

  String _getDBType() {
    if (dbtypesToggle[0]) return 'postgres';
    if (dbtypesToggle[1]) return 'mysql';
    throw Exception('Please select DBType');
  }

  static const password = 'password';
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
                      controller: controller.connStringController,
                      maxLines: 4,
                      minLines: 2,
                      textInputAction: TextInputAction.next,
                    ),
                    ButtonBar(children: [
                      ElevatedButton(
                        child: const Text('Extract'),
                        onPressed: controller.extract,
                      ),
                    ]),
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
                    GetBuilder<EditDBController>(
                      builder: (ctrl) => ToggleButtons(
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
                        onPressed: (i) => ctrl.selectDbType(i),
                        isSelected: ctrl.dbtypesToggle,
                      ),
                    ),
                    const EditTextField("username"),
                    const EditTextField("password"),
                    const EditTextField("host"),
                    const EditTextField("port"),
                    const EditTextField("database"),
                    ButtonBar(children: [
                      TextButton(
                        child: const Text('Test'),
                        onPressed: controller.test,
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

Uri extractDbUrl({String emailtext = ''}) {
  var usernameRE =
      RegExp('username[\\W:]+([\\w-]+)', caseSensitive: false, multiLine: true);
  var passwordRE = RegExp('password:[\\W:]+([\\w-]+)',
      caseSensitive: false, multiLine: true);
  var hostRE =
      RegExp('ip[\\W:]+([\\w-\\.]+)', caseSensitive: false, multiLine: true);
  var databaseRE =
      RegExp('database[\\W:]+([\\w-]+)', caseSensitive: false, multiLine: true);

  var hostM = hostRE.firstMatch(emailtext);
  var databaseM = databaseRE.firstMatch(emailtext);
  var usernameM = usernameRE.firstMatch(emailtext);
  var passwordM = passwordRE.firstMatch(emailtext);

  var pwd = passwordM != null ? ':' + passwordM.group(1)! : '';

  return Uri(
    userInfo: (usernameM?.group(1) ?? '') + pwd,
    host: hostM?.group(1),
    path: databaseM?.group(1),
  );
}
