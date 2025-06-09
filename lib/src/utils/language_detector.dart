import 'dart:ui';

class LanguageDetector {
  static String detectPreferredStotraLang() {
    final code = PlatformDispatcher.instance.locale.languageCode;
    switch (code) {
      case 'te':
        return 'telugu';
      case 'hi':
        return 'hindi';
      default:
        return 'english';
    }
  }
}
