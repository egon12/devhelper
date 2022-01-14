import 'package:uuid/uuid.dart';

var uuidNamespace = '676dba34-72f1-4c77-840d-6d4bdf170c51';

var _uuid = Uuid();

String genUUIDFromName(name) => _uuid.v5(uuidNamespace, name);

String genUUID() => _uuid.v4();
