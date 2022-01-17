import 'package:flutter/material.dart' hide Align;
import 'package:get/get.dart';

import 'database/column_info.dart';
import 'database/real_db_conn.dart';

class DBTableController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _fillData();
  }

  void _fillData() {
    DBConnItf conn = Get.arguments[0];
    String query = Get.arguments[1];

    data.append(() => () => conn.query(query));
  }

  Value<TableData?> data = Value(null);
}

class DBTable extends StatelessWidget {
  DBTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DBTableController controller = Get.put(DBTableController());

    return Scaffold(
        appBar: AppBar(title: const Text('Table tr_transactions_1')),
        //body: _table(widget.data, widget.cols),
        body: controller.data.obx((data) => TableInListView(
              data: data?.data ?? List.empty(),
              colsInfo: data?.columns ?? List.empty(),
            )));
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
            child: Column(children: [
              header(),
              Expanded(
                child: ListView.builder(
                  itemBuilder: itemBuilder,
                  itemCount: widget.data.length,
                ),
              ),
            ])));
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
            style: const TextStyle(fontWeight: FontWeight.bold),
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

  double? getColsWidth(ColumnInfo c) => colsWidth[c.id];

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
    switch (align) {
      case Align.left:
        return TextAlign.left;
      case Align.center:
        return TextAlign.center;
      case Align.right:
        return TextAlign.right;
    }
  }
}
