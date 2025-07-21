import 'package:flutter/material.dart';

typedef LocaleChangeCallback = void Function(Locale locale);

class LocaleUtil {
  final List<Locale> supportedLanguages = [Locale('zh'), Locale('en')];

  Locale defaultLocale() => supportedLanguages[0];

  // Callback for manual locale changed
  LocaleChangeCallback? onLocaleChanged;

  static final LocaleUtil _localeUtil = LocaleUtil._internal();

  factory LocaleUtil() {
    return _localeUtil;
  }

  LocaleUtil._internal();
}

LocaleUtil localeUtil = LocaleUtil();