import 'package:devhelper/uuid.dart';
import 'package:test/test.dart';

void main() {
  test("generate uuid", () {
    var res = genUUID();

    expect(res, '');
  });
}
