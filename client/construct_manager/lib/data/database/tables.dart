import 'package:drift/drift.dart';

class ConstructionsTable extends Table {
  TextColumn get uid => text()();
  TextColumn get title => text()();
  TextColumn get address => text()();
  TextColumn get type => text()();
  TextColumn get stage => text()();
  TextColumn get responsiblesJson => text()();
  TextColumn get ownerUid => text()();
  TextColumn get mapAddress => text()();
  TextColumn get information => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  RealColumn get budget => real().nullable()();
  BoolColumn get syncedWithServer => boolean()();

  @override
  Set<Column> get primaryKey => {uid};
}
