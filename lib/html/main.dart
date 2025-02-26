import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayPay決済',
      theme: ThemeData(primarySwatch: Colors.red),
      home: PayPayPaymentScreen(),
    );
  }
}

class PayPayPaymentScreen extends StatelessWidget {
  // サンプルのPayPay決済HTML
  final String htmlContent = '''
  <!DOCTYPE html>
  <html lang="ja">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>PayPay決済</title>
      <style>
          body { text-align: center; font-family: Arial, sans-serif; }
          button { font-size: 20px; padding: 10px; background-color: #ff0033; color: white; border: none; cursor: pointer; }
      </style>
      <script>
          function pay() {
              window.location.href = "paypay://pay?link_key=EXAMPLE_LINK_KEY";
          }
      </script>
  </head>
  <body>
      <h1>PayPay決済ページ</h1>
      <p>以下のボタンを押して支払いを行ってください。</p>
      <button onclick="pay()">PayPayで支払う</button>
  </body>
  </html>
  ''';

  // HTMLファイルを保存し、外部ブラウザで開く関数
  Future<void> openHtmlInExternalBrowser(BuildContext context) async {
    try {
      // 一時ディレクトリを取得
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/paypay_payment.html');

      // HTMLファイルを書き込む
      await file.writeAsString(htmlContent);

      // 外部ブラウザで開く（iOSならSafari、AndroidならChrome）
      final fileUri = file.uri.toString();
      if (await canLaunchUrl(Uri.parse(fileUri))) {
        final url = Uri.parse(fileUri).toString();
        final u = 'https://qiita.com/mak_nm/items/42b122c6b607fc9e0cf0';
        // await canLaunchUrlString(u)
        final f = Uri.parse(fileUri);
        print(f);
        await launchUrl(
          f,
          // Uri.parse(u),
          mode: LaunchMode.externalApplication,
        ).then((value) {
          print('完了');
        }).catchError((e) {
          print('失敗');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('外部ブラウザを開けませんでした')),
        );
      }
    } catch (e) {
      print('Error opening HTML in browser: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PayPay決済')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => openHtmlInExternalBrowser(context),
          child: Text('PayPay決済ページを開く'),
        ),
      ),
    );
  }
}
