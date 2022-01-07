import 'package:devhelper/database/column_info.dart';
import 'package:flutter/material.dart';
import 'string_extensions.dart';

class DBTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DBTableState();
  }

  var columns = ['id', 'name', 'age', 'last_seen'];

  var cols = [
    ColumnInfo('id', 'ID', isPrimaryKey: true, sort: Sort.asc),
    ColumnInfo.withId('name'),
    ColumnInfo.withId('age'),
    ColumnInfo.withId('another'),
    ColumnInfo('last_seen', 'Last Seen'),
  ];

  var data = [
    {
      'id': 1,
      'name': 'Richolas',
      'age': 300,
      'another': 'another',
      'last_seen': DateTime.parse('2021-12-01T00:00:00Z')
    },
    {
      'id': 2,
      'name': 'Alfredo',
      'age': 177,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 3,
      'name': 'Alfredo 2',
      'age': 98,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 14,
      'name': 'The name fom someone',
      'age': 98,
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 1,
      'name': 'Richolas',
      'age': 300,
      'another': 'another',
      'last_seen': DateTime.parse('2021-12-01T00:00:00Z')
    },
    {
      'id': 2,
      'name': 'Alfredo',
      'age': 177,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 3,
      'name': 'Alfredo 2',
      'age': 98,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 14,
      'name': 'The name fom someone',
      'age': 98,
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 1,
      'name': 'Richolas',
      'age': 300,
      'another': 'another',
      'last_seen': DateTime.parse('2021-12-01T00:00:00Z')
    },
    {
      'id': 2,
      'name': 'Alfredo',
      'age': 177,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 3,
      'name': 'Alfredo 2',
      'age': 98,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 14,
      'name': 'The name fom someone',
      'age': 98,
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 1,
      'name': 'Richolas',
      'age': 300,
      'another': 'another',
      'last_seen': DateTime.parse('2021-12-01T00:00:00Z')
    },
    {
      'id': 2,
      'name': 'Alfredo',
      'age': 177,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 3,
      'name': 'Alfredo 2',
      'age': 98,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 14,
      'name': 'The name fom someone',
      'age': 98,
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 1,
      'name': 'Richolas',
      'age': 300,
      'another': 'another',
      'last_seen': DateTime.parse('2021-12-01T00:00:00Z')
    },
    {
      'id': 2,
      'name': 'Alfredo',
      'age': 177,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 3,
      'name': 'Alfredo 2',
      'age': 98,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 14,
      'name': 'The name fom someone',
      'age': 98,
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 1,
      'name': 'Richolas',
      'age': 300,
      'another': 'another',
      'last_seen': DateTime.parse('2021-12-01T00:00:00Z')
    },
    {
      'id': 2,
      'name': 'Alfredo',
      'age': 177,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 3,
      'name': 'Alfredo 2',
      'age': 98,
      'another': 'another',
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
    {
      'id': 14,
      'name': 'The name fom someone',
      'age': 98,
      'last_seen': DateTime.parse('2020-12-01T00:00:00Z')
    },
  ];
}

class DBTableState extends State<DBTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Table tr_transactions_1')),
        //body: _table(widget.data, widget.cols),
        body: TableInListView(
          data: widget.data,
          colsInfo: widget.cols,
        ));
  }
}

class TableInListView extends StatefulWidget {
  final ColumnsInfo colsInfo;

  final List<Map<String, Object?>> data;

  const TableInListView({Key? key, required this.colsInfo, required this.data})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TableInListViewState();
  }
}

class TableInListViewState extends State<TableInListView> {

  Map<String, double> colsWidth = {};

  Widget itemBuilder(BuildContext, int index) {
    var item = widget.data[index];
    if (item == null) return Container();

    var key = widget.colsInfo.getKey(item);
    if (key == null) return Container();

    var children = widget.colsInfo.map((c) {
      var v = item[c.id];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          width: colsWidth[c.id],
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white)),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(v.toString()),
          ),
        ),
      );
    }).toList();

    return Row(
      key: key,
      children: children,
    );
  }

  var tp = TextPainter(
    textDirection: TextDirection.ltr,
  );

  double calculateWidth() {
    var tp = TextPainter();
    Map<String, num> colWidth = {};

    double w = 0;

    for (var ci in widget.colsInfo) {
      w += calculateColumnWidth(ci);
    }

    return w + widget.colsInfo.length * 4;
  }

  double calculateColumnWidth(ColumnInfo ci) {
    if (colsWidth[ci.id] != null) {
      return colsWidth[ci.id]!;
    }

    double w = 0;

    for (var item in widget.data) {
      var val = item[ci.id].toString();
      tp.text = TextSpan(text: val);
      tp.layout();
      if (w < tp.size.width) {
        w = tp.size.width;
      }
    }

    colsWidth[ci.id] = w + 20;

    return colsWidth[ci.id]!;
  }

  @override
  Widget build(BuildContext context) {
    var width = calculateWidth();

    return Column(

      children: [

      Expanded(child: SingleChildScrollView(
      
      scrollDirection: Axis.horizontal,
      child: Container(
          //size: const Size(800, 800),
          width: width,
          //height: 900,
          child: ListView.builder(
              itemBuilder: itemBuilder,
              itemCount: widget.data.length,
          ),
      ))),
        ]
    );
  }
}

extension ColumnsInfoKey on ColumnsInfo {
  getKey(RowData row) => ValueKey('row-' + getId(row));
}
