import 'package:test/test.dart';
//import 'package:devhelper/table.dart';

void main() {
  test('test something', () {
    const cols = ['satu', 'dua', 'tiga'];
    var dumies = cols.map((it) => Dummy(it)).toList();

    var all = dumies + [Dummy('one'), Dummy('two')];
    expect(all.length, 5);
  });
}

class Dummy {
  final String? name;

  Dummy(this.name);
}
