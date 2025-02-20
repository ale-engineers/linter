import 'package:flutter_test/flutter_test.dart';
import 'package:linter/riverpod_test/unit_service.dart';
import 'package:mocktail/mocktail.dart';

class MockUserService extends Mock implements UserService {}

void main() {
  test('fetchUserName returns mocked value', () async {
    final mockUserService = MockUserService();
    when(() => mockUserService.fetchUserName()).thenAnswer((_) async => "Mocked User");

    final result = await mockUserService.fetchUserName();

    expect(result, equals("Mocked User"));
  });
}
