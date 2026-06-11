import 'package:flutter_test/flutter_test.dart';
import 'package:construct_manager/data/models/construction.dart';

void main() {
  group('Construction', () {
    test('fromJson creates model correctly', () {
      final json = {
        'uid': 'test-uid',
        'title': 'Test Project',
        'address': '123 Main St',
        'type': 'Residential',
        'stage': 'ПОДГОТОВКА',
        'owner_uid': 'owner-1',
        'map_address': '',
        'information': '',
        'created_at': '2024-01-01T00:00:00.000Z',
        'budget': 10000.0,
        'responsibles': [
          {'uid': 'u1', 'name': 'John', 'email': 'john@test.com', 'admin': false, 'is_email_verified': true, 'role': 'executor'},
        ],
      };

      final construction = Construction.fromJson(json);

      expect(construction.constructionUid, 'test-uid');
      expect(construction.title, 'Test Project');
      expect(construction.address, '123 Main St');
      expect(construction.type, 'Residential');
      expect(construction.stage, 'ПОДГОТОВКА');
      expect(construction.ownerUid, 'owner-1');
      expect(construction.budget, 10000.0);
      expect(construction.responsibles.length, 1);
      expect(construction.responsibles[0].name, 'John');
    });

    test('toJson produces serializable map', () {
      final construction = Construction(
        title: 'Project',
        address: 'Addr',
        type: 'Type',
        stage: 'В_ИСПОЛНЕНИИ',
        constructionUid: 'uid-1',
        ownerUid: 'owner-1',
        budget: 5000,
      );

      final json = construction.toJson();

      expect(json['title'], 'Project');
      expect(json['stage'], 'В_ИСПОЛНЕНИИ');
      expect(json['budget'], 5000);
      expect(json['uid'], 'uid-1');
    });
  });
}
