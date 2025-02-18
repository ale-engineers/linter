import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

@riverpod
ApiClient apiClient(Ref ref) => ApiClient();

class ApiClient {
  Future<int> fetch({int limit = 10}) async {
    await Future.delayed(Duration(seconds: 1));
    return 42;
  }
}

@riverpod
Future<int> fetchNumber(Ref ref) async {
  await Future.delayed(Duration(seconds: 1));
  return Random().nextInt(100);
}
