import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linter/riverpod/skia.dart';

void main() {
  debugPrint('test');
  runApp(ProviderScope(child: MyApp()));
}

// test for test test
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return SkiaView();
        // return Scaffold(
        //   appBar: AppBar(
        //     title: Text('SnackBar Example'),
        //   ),
        // );
      }),
    );
  }
}

class TESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTEST
    extends StatefulWidget {
  const TESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTEST(
      {super.key});

  @override
  State<TESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTEST>
      createState() =>
          _TESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTESTState();
}

class _TESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTESTState
    extends State<
        TESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTESTTESTTESTTESTESTTEST> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
