import 'package:canknow_aggregate_app/local/localeUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeStore = StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());

class LocaleNotifier extends StateNotifier<Locale> {
  static const _key = 'locale';

  LocaleNotifier() : super(LocaleUtil().supportedLanguages[0]) {
    _loadLocale();
  }

  void setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      state = Locale(code);
    }
  }
} 