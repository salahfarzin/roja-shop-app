import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale;
  LocaleProvider(this._locale);

  Locale get locale => _locale;

  set locale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  bool get isRtl => ['ar', 'fa'].contains(_locale.languageCode);
}
