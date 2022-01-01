import 'package:flutter/cupertino.dart';

class EditDB extends StatefulWidget {
  EditDB({Key? key}) : super(key: key);

  final focusNode = FocusNode(debugLabel: 'EditDB');

  @override
  State<StatefulWidget> createState() {
    return EditDBState();
  }
}

class EditDBState extends State<EditDB> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Database')),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: CupertinoFormSection.insetGrouped(
                header: const Text('Insert DB'),
                children: [
                  CupertinoTextFormFieldRow(
                    prefix: const Label('DB Conn'),
                    placeholder: 'postgres://user:pass@host:5432/dbname',
                    maxLines: 4,
                    minLines: 2,
                    textInputAction: TextInputAction.next,
                  ),
                  CupertinoFormRow(
                    child: CupertinoButton.filled(
                      child: const Text('Extract'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: CupertinoFormSection.insetGrouped(
                header: const Text('Connection Detail'),
                children: [
                  CupertinoFormRow(
                    prefix: const Label('DB Type'),
                    child: CupertinoSlidingSegmentedControl(
                      onValueChanged: (value) {},
                      groupValue: 1,
                      children: {
                        1: Image.asset('images/postgre_logo.webp', height: 100),
                        2: Image.asset('images/mysql_logo.webp', height: 100),
                      },
                    ),
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: const Label('Username'),
                    placeholder: 'user',
                    textInputAction: TextInputAction.next,
                  ),
                  CupertinoTextFormFieldRow(
                    obscureText: true,
                    prefix: const Label('Password'),
                    placeholder: 'password',
                    textInputAction: TextInputAction.next,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: const Label('Host'),
                    placeholder: '127.0.0.1',
                    textInputAction: TextInputAction.next,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: const Label('Port'),
                    placeholder: '5432',
                    textInputAction: TextInputAction.next,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: const Label('Database'),
                    placeholder: 'my_database',
                    textInputAction: TextInputAction.next,
                  ),
                  CupertinoFormRow(
                    prefix: CupertinoButton(
                      child: const Text('Test'),
                      onPressed: () {},
                    ),
                    child: CupertinoButton.filled(
                      child: const Text('Save'),
                      onPressed: () {},
                    ),
                  ),
                ],
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
