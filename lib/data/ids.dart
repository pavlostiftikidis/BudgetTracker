import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Client-generated UUID v4. Rows get globally unique ids so a future sync
/// backend can merge devices without remapping keys.
String newId() => _uuid.v4();
