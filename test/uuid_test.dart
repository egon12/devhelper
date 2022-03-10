import 'package:devhelper/uuid.dart';
import 'package:test/test.dart';

void main() {
  test("generate uuid", () {
    var res = genUUIDFromName('postgres://postgres@127.0.0.1/postgres');

    expect(res, 'bea961c3-0794-58c3-a6bb-148c6ea31060');
  });
}


