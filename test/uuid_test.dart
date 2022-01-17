import 'package:devhelper/uuid.dart';
import 'package:test/test.dart';

void main() {
  test("generate uuid", () {
    var res = genUUID();

    expect(res, '');
  });


  test("generate uuid", () {
    var res = genUUIDFromName('postgres://postgres@127.0.0.1/postgres');

    expect(res, '');
  });
}
