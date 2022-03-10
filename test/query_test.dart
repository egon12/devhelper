// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:devhelper/database/real_db_conn.dart';
import 'package:devhelper/database/db_conn.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devhelper/query.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('Query Page', (WidgetTester tester) async {
    var _ = prepareCtrl();

    await tester.pumpWidget(const MaterialApp(home: Query()));

    expect(find.text('SELECT'), findsOneWidget);
    expect(find.text('TABLES'), findsOneWidget);
    expect(find.text('INSERT'), findsOneWidget);
    expect(find.text('UPDATE'), findsOneWidget);
    expect(find.text('EXECUTE'), findsOneWidget);

    Get.deleteAll();
  });

  testWidgets('Query Page test press SELECT', (WidgetTester tester) async {
    var ctrl = prepareCtrl();

    await tester.pumpWidget(const MaterialApp(home: Query()));

    expect(ctrl.called['addSelect'], false);
    await tester.tap(find.text('SELECT'));
    expect(ctrl.called['addSelect'], true);

    Get.deleteAll();
  });

  testWidgets('Query Page test press TABLES', (WidgetTester tester) async {
    var ctrl = prepareCtrl();

    await tester.pumpWidget(const MaterialApp(home: Query()));

    expect(ctrl.called['selectTable'], false);
    await tester.tap(find.text('TABLES'));
    expect(ctrl.called['selectTable'], true);

    Get.deleteAll();
  });

  testWidgets('Query Page test press UPDATE', (WidgetTester tester) async {
    var ctrl = prepareCtrl();

    await tester.pumpWidget(const MaterialApp(home: Query()));

    expect(ctrl.called['addUpdate'], false);
    await tester.tap(find.text('UPDATE'));
    expect(ctrl.called['addUpdate'], true);

    Get.deleteAll();
  });

  testWidgets('Query Page test press INSERT', (WidgetTester tester) async {
    var ctrl = prepareCtrl();

    await tester.pumpWidget(const MaterialApp(home: Query()));

    expect(ctrl.called['addInsert'], false);
    await tester.tap(find.text('INSERT'));
    expect(ctrl.called['addInsert'], true);

    Get.deleteAll();
  });

  testWidgets('Query Page test press EXECUTE', (WidgetTester tester) async {
    var ctrl = prepareCtrl();

    await tester.pumpWidget(const MaterialApp(home: Query()));

    expect(ctrl.called['execute'], false);
    await tester.tap(find.text('EXECUTE'));
    expect(ctrl.called['execute'], true);

    Get.deleteAll();
  });

}

QueryControllerMock prepareCtrl() {
  var ctrl = QueryControllerMock();

  // ignore: unnecessary_cast
  Get.put(ctrl as QueryController);

  ctrl.connInfo = DBConnInfo.empty();
  ctrl.textCtrl = TextEditingController();
  ctrl.textFocus = FocusNode();

  return ctrl;
}

class QueryControllerMock extends GetxController implements QueryController {
  @override
  late DBConnItf conn;

  @override
  late DBConnInfo connInfo;

  @override
  late TextEditingController textCtrl;

  @override
  late FocusNode textFocus;

  Map<String, bool> called = {
    'addInsert': false,
    'addSelect': false,
    'addUpdate': false,
    'execute': false,
    'selectTable': false,
  };

  @override
  void addInsert() {
    called['addInsert'] = true;
  }

  @override
  void addSelect() {
    called['addSelect'] = true;
  }

  @override
  void addUpdate() {
    called['addUpdate'] = true;
  }

  @override
  void execute() {
    called['execute'] = true;
  }

  @override
  void selectTable() {
    called['selectTable'] = true;
  }
}
