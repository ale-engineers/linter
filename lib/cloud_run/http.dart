import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final now1 = DateTime.now();
  final response = await http.get(
    Uri.parse('https://helloworld-31148102753.asia-northeast1.run.app'),
  );
  final now2 = DateTime.now();
  print(now2.difference(now1).inMilliseconds);
  print(response.body);
}
