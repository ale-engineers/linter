import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text("ローカルHTMLを開く")),
          body: Center(
            child: ElevatedButton(
              onPressed: openLocalHtml,
              child: const Text("HTMLを外部ブラウザで開く"),
            ),
          ),
        );
      }),
    );
  }
}

Future<void> openLocalHtml() async {
  try {
    // `assets/html/index.html` の中身を取得
    final String htmlContent =
        await rootBundle.loadString('assets/html/index.html');

    // 一時ディレクトリを取得
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/index.html');

    // 一時ファイルに HTML を書き込む
    await tempFile.writeAsString(htmlContent);

    // `file://` URL を作成
    final Uri fileUri = Uri.file(tempFile.path);

    // 外部ブラウザで開く
    if (!await launchUrl(fileUri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $fileUri';
    }
  } catch (e) {
    debugPrint('Error opening local HTML: $e');
  }
}
