import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// test for test
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('SnackBar Example'),
          ),
        );
      }),
    );
  }
}
