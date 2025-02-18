import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'skia.g.dart';

@riverpod
class Type extends _$Type {
  @override
  int build() => 1;

  updateType() {
    state = Random().nextInt(100);
    print('updateType: $state');
  }
}

@riverpod
class Skia extends _$Skia {
  @override
  FutureOr<String> build() async {
    await Future.delayed(Duration(seconds: 1));
    return ref.watch(typeProvider).toString();
  }
}

class SkiaView extends ConsumerWidget {
  const SkiaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(typeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Skia'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // ref.read(typeProvider.notifier).updateType();
              ref.invalidate(typeProvider);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              ref.read(typeProvider.notifier).updateType();
              // ref.invalidate(typeProvider);
            },
          ),
        ],
      ),
      body: Center(
        child: ref.watch(skiaProvider).when(
              data: (data) => Text(data),
              loading: () => CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
      ),
    );
  }
}
