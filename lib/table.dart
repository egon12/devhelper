import 'package:flutter/material.dart';

class DBTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DBTableState();
  }

  var columns = ['id', 'name', 'age', 'last_seen'];

  var data = [
    {
      'id': 1,
      'name': 'Richolas',
      'age': 300,
      'last_seen': DateTime.parse('2021-12-01T00:00:00Z')
    },
    {
      'id': 2,
      'name': 'Alfredo',
      'age': 177,
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 3,
      'name': 'Alfredo 2',
      'age': 98,
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
  ];

  getId(Map<String, Object?> datum) => datum['id'].toString();
}

class DBTableState extends State<DBTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Table tr_transactions_1')),
      body: _table(widget.data, widget.columns),
    );
  }

  _table(List<Map<String, Object?>> data, List<String> cols) => Table(
        children: _header(cols) + _rows(data, cols),
        border: const TableBorder(
          horizontalInside: BorderSide(color: Colors.grey),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      );

  _rows(List<Map<String, Object?>> data, List<String> cols) => data
      .map((datum) => TableRow(
            key: ValueKey('row-' + widget.getId(datum)),
            children: _row(datum, cols),
          ))
      .toList();

  _row(Map<String, Object?> datum, List<String> cols) =>
      cols.map((col) => TableCell(child: _cell(datum[col]))).toList();

  _cell(Object? v) => TableCell(child: Text(v.toString()));

  _header(List<String> cols) => [
        TableRow(
          children: cols
              .map(
                (col) => TableCell(
                    child: Text(
                  col,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
              )
              .toList(),
        )
      ];
}
