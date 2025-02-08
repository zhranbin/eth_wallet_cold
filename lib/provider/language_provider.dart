
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../main.dart';
import '../utils/my_shared_preferences.dart';

S myListenS(BuildContext context, {bool listen = true}) {
  return Provider.of<LanguageProvider>(context, listen: listen).getS(context);
}
S myS() {
  return Provider.of<LanguageProvider>(MyApp.context, listen: false).getS(MyApp.context);
}

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Localizations.localeOf(MyApp.context);
  Locale get locale => _locale;

  S getS(BuildContext context) {
    S.load(_locale);
    return S.of(context);
  }

  static void changeLanguage(Locale newLocale) {
    // 存储语言设置
    saveLanguage(newLocale.languageCode);
    // 设置语言环境
    LanguageProvider provider = Provider.of<LanguageProvider>(
        MyApp.context,
        listen: false);
    provider._locale = newLocale;
    S.load(newLocale);
    provider.notifyListeners();
  }

  // 存储语言设置
  static void saveLanguage(String language) async {
    await MySharedPreferences.setLanguageCode(language);
  }

}

extension LocaleExtension on Locale {
  String get acceptLanguage {
    if (languageCode == 'zh') {
      return "zh-CN";
    }
    if (languageCode == 'en') {
      return "en-US";
    }
    return languageCode;
  }
}