typedef RowData = Map<String, Object?>;

extension RowDataExtension on RowData {
  Object? getValue(ColumnInfo colInfo) {
    return this[colInfo.id];
  }

  String jetStringValue(ColumnInfo colInfo) {
    return getValue(colInfo)?.toString() ?? '';
  }
}

typedef RowsData = Iterable<RowData>;

class ColumnInfo {
  ColumnInfo(this.id, this.label,
      {this.isPrimaryKey = false, this.sort = Sort.none, this.textAlign = TextAlign.left });

  ColumnInfo.withId(String id, {sort = Sort.none, textAlign = TextAlign.left} ) : this(id, id.capitalize(), sort: sort, textAlign: textAlign);

  final String id;
  final String label;
  final bool isPrimaryKey;
  final Sort sort;
  final TextAlign textAlign;
}

enum Sort { none, asc, desc }

enum TextAlign { left, center, right }

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
