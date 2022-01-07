typedef RowData = Map<String, Object?>;

extension RowDataExtension on RowData {
  Object? getValue(ColumnInfo colInfo) {
    return this[colInfo.id];
  }

  String getStringValue(ColumnInfo colInfo) {
    return getValue(colInfo)?.toString() ?? '';
  }
}

typedef RowsData = List<RowData>;

class ColumnInfo {
  ColumnInfo(this.id, this.label,
      {this.isPrimaryKey = false, this.sort = Sort.none, this.align = Align.left });

  ColumnInfo.withId(String id, {sort = Sort.none, align = Align.left} ) : this(id, id.capitalize(), sort: sort, align: align);

  final String id;
  final String label;
  final bool isPrimaryKey;
  final Sort sort;
  final Align align;
}

enum Sort { none, asc, desc }

enum Align { left, center, right }

typedef ColumnsInfo = List<ColumnInfo>;

extension ColumnsInfoExtension on ColumnsInfo {
  String getId(Map<String, Object?> row) => firstWhere(
        (i) => i.isPrimaryKey,
        orElse: () => first,
      ).id;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
