enum AuthExceptionType {
  /// セキュアストレージのエラーはデバイス側のエラーで
  /// こちら側として出来る事はないので再起動を促す
  secureStorageError('デバイスのエラーが発生しました。再起動してください。'),

  /// WebView でのログインをやり直す必要がある
  requiredAuthCode('ログインが必要です'),
  ;

  final String errorMessage;

  const AuthExceptionType(this.errorMessage);
}
