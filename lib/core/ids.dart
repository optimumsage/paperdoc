import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Stable cross-device identity for a catalog row. Random v4 — collision risk
/// is negligible and it needs no coordination between offline devices.
String newUid() => _uuid.v4();
