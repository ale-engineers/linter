import 'dart:math';

import 'package:linter/riverpod_test/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier_test.g.dart';

@riverpod
class Notifier extends _$Notifier {
  @override
  int build() => 0;

  Future<int> apiClient() async {
    return await ref.read(apiClientProvider).fetch();
  }

  Future<int> fetchNumber() async {
    int result = 0;
    for (final _ in List.generate(10, (index) => index)) {
      final num = await ref.read(fetchNumberProvider.future);
      result += num;
    }
    return result;
  }

  int increment() {
    return ref.read(incrementNotifierProvider.notifier).increment();
  }
}

@riverpod
class IncrementNotifier extends _$IncrementNotifier {
  @override
  int build() => 0;

  int increment() {
    state++;
    return state;
  }
}

class MockIncrementAsyncNotifierInterface extends _$IncrementAsyncNotifier with Mock implements IncrementAsyncNotifier {}

@riverpod
class IncrementAsyncNotifier extends _$IncrementAsyncNotifier {
  @override
  FutureOr<int> build() async {
    await Future.delayed(Duration(seconds: 1));
    return Random().nextInt(100);
  }

  increment() {
    state = AsyncData(42);
  }
}
