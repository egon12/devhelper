import 'package:devhelper/database/db_conn.dart';
import 'package:devhelper/database/real_db_conn.dart';
import 'package:devhelper/table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlparser/sqlparser.dart' show Token, SqlEngine, TokenType;

import 'database/query_repo.dart';
import 'table_list.dart';

var queryGetPage = GetPage(
  name: '/query',
  page: () => const Query(),
  binding: QueryBinding(),
);

class QueryBinding extends Bindings {
  @override
  void dependencies() {
    Database db = Get.find();
    Get.lazyPut(() => QueryRepo(db: db));
    Get.lazyPut(() => QueryController());
  }
}

class QueryController extends GetxController {
  TextEditingController textCtrl = TextEditingController();

  FocusNode textFocus = FocusNode();

  late DBConnItf conn;

  DBConnInfo connInfo = Get.arguments;
  final QueryRepo _repo = Get.find();

  @override
  void onInit() {
    super.onInit();
    _connectDB();
    _fillText();
  }

  @override
  void onClose() async {
    textFocus.dispose();
    await _repo.save(connInfo.uuid, textCtrl.text);
    super.onClose();
  }

  void _connectDB() async {
    conn = await DBConnItf.connectTo(connInfo.url);
  }

  Future<void> _fillText() async {
    var query = await _repo.get(connInfo.uuid);
    textCtrl.text = query;
    textFocus.requestFocus();
  }

  void _insert(String word) {
    var text = textCtrl.text;
    var sel = textCtrl.selection;
    textCtrl.value = TextEditingValue(
      text: sel.textBefore(text) + word + sel.textAfter(text),
      selection: TextSelection.collapsed(offset: sel.start + word.length),
    );
    textFocus.requestFocus();
  }

  void addSelect() {
    _insert('SELECT * FROM ');
  }

  void addInsert() {
    _insert('INSERT INTO ');
  }

  void addUpdate() {
    _insert('UPDATE ');
  }

  void selectTable() async {
    var tableName = await Get.to(() => const TableList(), arguments: conn);
    _insert(tableName);
  }

  void execute() {
    var sel = textCtrl.selection;
    var text = textCtrl.text;
    if (!sel.isCollapsed) {
      Get.to(() => const DBTable(), arguments: [conn, sel.textInside(text)]);
      return;
    }

    //Get.toNamed('query/result', arguments: [conn, textCtrl.text]);
    var query = getQuery(textCtrl.value);
    Get.to(() => const DBTable(), arguments: [conn, query]);
  }
}

class Query extends GetView<QueryController> {
  const Query({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.connInfo.title)),
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
                  onPressed: controller.execute,
                ),
                TextButton(
                  child: const Text('UPDATE'),
                  onPressed: controller.addUpdate,
                ),
                TextButton(
                  child: const Text('INSERT'),
                  onPressed: controller.addInsert,
                ),
                TextButton(
                  child: const Text('TABLES'),
                  onPressed: controller.selectTable,
                ),
                TextButton(
                  child: const Text('SELECT'),
                  onPressed: controller.addSelect,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

typedef StatementTokens = List<Token>;

extension StatementTokensPosition on StatementTokens {
  int get start {
    if (isEmpty) return 0;
    return first.firstPosition;
  }

  int get end {
    if (isEmpty) return 0;
    return last.lastPosition;
  }

  bool inside(int offset) => start <= offset && offset <= end;
}

String getQuery(TextEditingValue val) {
  var text = val.text;
  var sel = val.selection;
  var engine = SqlEngine();
  var tokens = engine.tokenize(text);

  var statements = List<StatementTokens>.empty(growable: true);
  StatementTokens statement = List<Token>.empty(growable: true);
  for (var i = 0; i < tokens.length; i++) {
    var token = tokens[i];
    statement.add(token);
    if (token.type == TokenType.semicolon || token.type == TokenType.eof) {
      statements.add(statement);
      statement = List<Token>.empty(growable: true);
    }
  }

  for (var i = 0; i < statements.length; i++) {
    var stmt = statements[i];
    if (stmt.inside(sel.start)) {
      return text.substring(stmt.start, stmt.end);
    }
  }
  return '';
}
