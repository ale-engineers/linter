import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HtmlViewerScreen(),
    );
  }
}

class HtmlViewerScreen extends StatelessWidget {
  // アセットHTMLを取得し、一時ファイルとして保存
  Future<String> loadHtmlFromAssets() async {
    // アセットからHTMLファイルの内容を取得
    String htmlContent = await rootBundle.loadString('assets/html/index.html');

    // 一時ディレクトリを取得
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/index.html');

    // HTMLを書き込む
    await file.writeAsString(htmlContent);

    return file.uri.toString(); // ファイルのパスを返す
  }

  // 外部ブラウザでHTMLを開く
  Future<void> openHtmlInExternalBrowser(BuildContext context) async {
    String filePath = await loadHtmlFromAssets();

    if (await canLaunchUrl(Uri.parse(filePath))) {
      await launchUrl(
        Uri.parse(filePath),
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('外部ブラウザを開けませんでした')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HTML Viewer')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => openHtmlInExternalBrowser(context),
          child: Text('外部ブラウザでHTMLを開く'),
        ),
      ),
    );
  }
}
