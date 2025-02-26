import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("ローカルHTMLを外部ブラウザで開く")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: openHtmlWithDataUrl,
                child: const Text("data: URL で開く"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: openHtmlWithSystem,
                child: const Text("open_filex で開く"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// **方法①: `data:` URL（Base64エンコード）で開く**
Future<void> openHtmlWithDataUrl() async {
  String htmlContent = """
    <!DOCTYPE html>
    <html lang="ja">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>data: URL で開く</title>
    </head>
    <body>
        <h1>これは data: URL を使ったテストです</h1>
    </body>
    </html>
  """;

  String base64Html = base64Encode(utf8.encode(htmlContent));
  String dataUrl = "data:text/html;base64,$base64Html";

  if (!await launchUrl(Uri.parse(dataUrl),
      mode: LaunchMode.externalApplication)) {
    throw 'Could not launch data URL';
  }
}

/// **方法②: `open_filex` でシステムUIから開く**
Future<void> openHtmlWithSystem() async {
  final String htmlContent =
      await rootBundle.loadString('assets/html/index.html');
  final Directory tempDir = await getTemporaryDirectory();
  final File tempFile = File('${tempDir.path}/index.html');
  await tempFile.writeAsString(htmlContent);

  await OpenFilex.open(tempFile.path);
}
