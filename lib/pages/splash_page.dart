import 'package:eth_wallet/main.dart';
import 'package:eth_wallet/pages/account/no_account_page.dart';
import 'package:eth_wallet/provider/theme_provider.dart';
import 'package:eth_wallet/utils/account/account_manager.dart';
import 'package:eth_wallet/utils/extensions/string_extensions.dart';
import 'package:eth_wallet/utils/my_assets.dart';
import 'package:eth_wallet/utils/my_route.dart';
import 'package:eth_wallet/widget/custom_password/password_input_widget.dart';
import 'package:flutter/material.dart';

import '../provider/account_provider.dart';
import '../provider/language_provider.dart';
import '../utils/my_shared_preferences.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {

    _checkData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      backgroundColor: theme.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 40 + 80,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  MyAssets.logo(context),
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(myListenS(context).appName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textColor),),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  // 检查数据
  _checkData() async {
    final password = await MySharedPreferences.getWalletPassword();
    if (password == null) {
      if (mounted) {
        final pwd = await PasswordInputWidget.show(context, title: myS().setPassword,);
        if (pwd != null) {
          await MySharedPreferences.setWalletPassword(pwd.MD5);
          _loadAccount();
        } else {
          _checkData();
        }
      }
      return;
    }
    _loadAccount();
  }

  // 加载账号数据
  _loadAccount() async {
    await AccountProvider.initData();
    final accounts = await AccountManager.getAccounts();
    if (accounts.isEmpty) {
      if (mounted) {
        MyRoute.pushReplacement(const NoAccountPage(), context: context);
      }
    } else {
      if (mounted) {
        MyRoute.pushReplacement(const MainPage(), context: context);
      }
    }
  }

  /// 初始化app相关的东西
  Future<void> initAPP() async {
    Locale systemLocale = Localizations.localeOf(MyApp.context);
    print("系统语言环境 - ${systemLocale.languageCode}");
    // 获取存储的语言
    String languageCode = await MySharedPreferences.getLanguageCode() ?? (systemLocale.languageCode.contains("zh") ? "zh" : "en");
    print("设置语言环境 - ${languageCode}");
    // 设置语言
    LanguageProvider.changeLanguage(
        Locale.fromSubtags(languageCode: languageCode));
    // 主题相关
    if (mounted) {
      myThemeProvider(context, listen: false).changeTheme(MySharedPreferences.getThemeTypeSync());
    }
  }



}
