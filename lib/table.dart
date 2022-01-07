import 'package:flutter/material.dart' hide Align;
import 'package:devhelper/database/column_info.dart';

class DBTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DBTableState();
  }

  var columns = ['id', 'name', 'age', 'last_seen'];

  var cols = [
    ColumnInfo('id', 'ID', isPrimaryKey: true, sort: Sort.asc, align: Align.right),
    ColumnInfo.withId('name'),
    ColumnInfo.withId('age', align: Align.right),
    ColumnInfo.withId('another'),
    ColumnInfo('last_seen', 'Last Seen', align: Align.center),
  ];

  RowsData data = [
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

  final RowsData data;

  const TableInListView({Key? key, required this.colsInfo, required this.data})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TableInListViewState();
  }
}

class TableInListViewState extends State<TableInListView> {

  Map<String, double> colsWidth = {};

  Widget itemBuilder(BuildContext ctx, int index) {
    var item = widget.data[index];
    var key = widget.colsInfo.getKey(item);
    var children = widget.colsInfo.map((c) => cell(c, item)).toList();

    return Row(
      key: key,
      children: children,
    );
  }


  @override
  Widget build(BuildContext context) {
    var width = calculateWidth();

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            width: width, 
            child: Column(
                children: [
                  header(),
                  Expanded(
                      child: ListView.builder(
                          itemBuilder: itemBuilder,
                          itemCount: widget.data.length,
                      ),
                  ),
                ]
            )
        )
    );
  }

  Widget header() {
    return Row(children: widget.colsInfo.map((c) => cellHeader(c)).toList());
  }

  Widget cellHeader(ColumnInfo c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: getColsWidth(c),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 4, color: Colors.white)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
              c.label, 
              textAlign: c.getTextAlign(),
              maxLines: 1,
              style: const TextStyle( 
                  fontWeight: FontWeight.bold 
              ),
          ),
        ),
      ),
    );
  }

  Widget cell(ColumnInfo c, RowData row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: getColsWidth(c),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 0, color: Colors.white)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
            child: Text(
                row.getStringValue(c), 
                textAlign: c.getTextAlign(),
                maxLines: 1,
                ),
        ),
      ),
    );
  }

  double? getColsWidth(ColumnInfo c)  => colsWidth[c.id];

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
}

extension ColumnsInfoKey on ColumnsInfo {
  getKey(RowData row) => ValueKey('row-' + getId(row));
}

extension TextAlingExtension on ColumnInfo {
  TextAlign getTextAlign() {
    switch(align) {
      case Align.left:
        return TextAlign.left;
      case Align.center:
        return TextAlign.center;
      case Align.right:
        return TextAlign.right;
    }
  }
}
