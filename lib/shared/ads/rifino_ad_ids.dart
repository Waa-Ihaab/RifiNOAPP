import 'dart:io';

class RifinoAdIds {
  const RifinoAdIds._();

  static String get banner {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    if (Platform.isIOS) {
      return 'ca-app-pub-7550361372379233/6070266044';
    }
    throw UnsupportedError('Ads are only supported on Android and iOS.');
  }
}
