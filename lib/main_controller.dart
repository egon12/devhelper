import 'package:get/get.dart';
import 'package:collection/collection.dart';

import 'database/db_conn.dart';
import 'database/db_conn_repo.dart';

class MainController extends GetxController {
  final DBConnInfoRepo _repo = Get.find();

  DBConnInfo? edited = DBConnInfo.empty();

  var rx = List<DBConnInfoViewObject>.empty().reactive;

  var selectedIndex = -1.obs;

  @override
  void onInit() {
    super.onInit();
    rx.append(() => _loadAll);
  }

  Future<List<DBConnInfoViewObject>> _loadAll() async {
    var rows = await _repo.all();
    return rows
        .mapIndexed((index, c) => DBConnInfoViewObject.from(c, index: index))
        .toList();
  }

  void delete(DBConnInfo? conn) {
    if (conn == null) {
      return;
    }
    _repo.delete(conn.uuid);
  }

  select(DBConnInfoViewObject? conn) {
    if (conn == null) {
      return;
    }
    rx.value = rx.value?.map((c) {
      c.selected = c.uuid == conn.uuid;
      return c;
    }).toList();
  }
}

class DBConnInfoViewObject extends DBConnInfo {
  bool selected;
  int index;

  DBConnInfoViewObject.from(DBConnInfo c,
      {this.selected = false, this.index = -1})
      : super(uuid: c.uuid, url: c.url);

  get selectedIndex => selected ? -1 : index;
}

extension DBConnInfoDisplay on DBConnInfoViewObject? {
  String get title {
    var username = this?.url.userInfo.split(":")[0] ?? '';
    var host = this?.url.host ?? 'NULL HOST';
    return username + '@' + host;
  }

  String get subtitle {
    return this?.url.path ?? '';
  }
}
