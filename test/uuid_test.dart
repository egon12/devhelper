import 'package:devhelper/main_list.dart';
import 'package:test/test.dart';

void main() {
  test("generate uuid", () {
    var res = uuid.v4();

    expect(res, '');
  });
}
