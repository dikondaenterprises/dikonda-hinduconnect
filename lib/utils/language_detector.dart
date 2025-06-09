// Auto Language Detection using device locale
import 'dart:ui';

class LanguageDetector {
  static String detectPreferredStotraLang() {
    final locale = PlatformDispatcher.instance.locale;
    final langCode = locale.languageCode;

    switch (langCode) {
      case 'te':
        return 'telugu';
      case 'hi':
        return 'hindi';
      case 'en':
      default:
        return 'english';
    }
  }
}
