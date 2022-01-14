import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mfizz_icon.dart';

class _Controller extends GetxController {
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

  submit() {
    _textControllerMap.forEach((name, tc) {
      _value[name] = tc.text;
    });

    print(_value);
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

class EditDB extends StatelessWidget {
  EditDB({Key? key}) : super(key: key);

  final focusNode = FocusNode(debugLabel: 'EditDB');

  @override
  Widget build(BuildContext context) {
    var ctrl = Get.put(_Controller());

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
                          onPressed: ctrl.selectDbType,
                          isSelected: ctrl.dbtypesToggle,
                        )),
                    const EditTextField("username"),
                    const EditTextField("password"),
                    const EditTextField("host"),
                    const EditTextField("port"),
                    const EditTextField("database"),
                    ButtonBar(children: [
                      TextButton(
                        child: const Text('Test'),
                        onPressed: () {
                          ctrl.submit();
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Save'),
                        onPressed: () {},
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

class EditTextField extends StatelessWidget {
  const EditTextField(
    this.label, {
    Key? key,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    final _Controller ctrl = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label.capitalizeFirst,
          border: const OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
        controller: ctrl.getTextController(label),
      ),
    );
  }
}
