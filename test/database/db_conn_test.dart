import 'package:devhelper/database/db_conn.dart';
import 'package:test/test.dart';

void main() {
  test('test DBConnInfo', () {
    var c = DBConnInfo.empty();
    expect(c.url.toString(), '');
  });
}
