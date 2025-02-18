import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linter/riverpod_test/api_client.dart';
import 'package:linter/riverpod_test/notifier_test.dart';
import 'package:mocktail/mocktail.dart';

import '../widget_test.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockIncrementAsyncNotifier extends MockIncrementAsyncNotifierInterface {
  @override
  build() => 42;
}

void main() {
  late MockApiClient apiClient;
  late ProviderContainer container;

  setUp(() {
    apiClient = MockApiClient();
    container = createContainer(
      overrides: [
        apiClientProvider.overrideWith((ref) => apiClient),
        // fetchNumberProvider.overrideWith((ref) async => 24),
        /// todo override しても2回以上回ることはない
        /// when を使えるといけるのかもしれないけど
        // fetchNumberProvider.overrideWith((ref) async {
        //   final number = Random().nextInt(100);
        //   debugPrint('number: $number');
        //   return number;
        // }),
        // incrementAsyncNotifierProvider.overrideWith(MockIncrementAsyncNotifier.new),
      ],
    );

    test('Notifier test', () async {
      when(() => apiClient.fetch()).thenAnswer((_) async => 42);

      final notifier = container.read(notifierProvider.notifier);
      final num = await notifier.apiClient();
      expect(num, 42);
    });

    // test('fetchNumber() returns 42', () async {
    //   final notifier = container.read(notifierProvider.notifier);
    //   final sum = await notifier.fetchNumber();
    //   expect(sum, 24);
    // });

    // test('increment() returns 1', () {
    //   final notifier = container.read(incrementNotifierProvider.notifier);
    //   final num = notifier.increment();
    //   expect(num, 1);
    // });

    // test('incrementAsync() returns 123', () async {
    //   final result = container.read(incrementAsyncNotifierProvider.future);
    //   // final num = notifier.increment();
    //   expect(result, 42);
    // });
  });
}
