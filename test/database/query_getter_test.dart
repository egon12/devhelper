import 'package:devhelper/query.dart';
import 'package:flutter/services.dart';
import 'package:test/test.dart';

void main() {
  test('test get simple query', () {
    expect(
      getQuery(col('SELECT * FROM mytable;', 0)),
      'SELECT * FROM mytable;',
    );
  });

  test('test multiple query', () {
    expect(
      getQuery(col(
          'SELECT * FROM mytable;\nInsert into mytable(name) values(a);', 23)),
      'Insert into mytable(name) values(a);',
    );
  });
}

TextEditingValue col(String text, int pos) => TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: pos),
    );
