import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // výchozí jazyk je EN

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('locale');

    if (savedCode == 'cs' || savedCode == 'en') {
      _locale = Locale(savedCode!);
    } else {
      final systemLang =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      _locale = systemLang == 'cs' ? const Locale('cs') : const Locale('en');
      await prefs.setString('locale', _locale.languageCode);
    }

    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', code);
    _locale = Locale(code);
    notifyListeners();
  }
}
