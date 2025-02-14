import 'package:flutter/material.dart';

void main() {
  print('test');
  runApp(MyApp());
}

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
