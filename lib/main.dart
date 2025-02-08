import 'package:easy_refresh/easy_refresh.dart';
import 'package:eth_wallet/utils/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'pages/splash_page.dart';
import 'provider/account_provider.dart';
import 'provider/language_provider.dart';
import 'provider/theme_provider.dart';
import 'utils/account/account_manager.dart';
import 'utils/my_shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化绑定
  // 禁止横屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);
  await MySharedPreferences.init();
  EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader();
  EasyRefresh.defaultFooterBuilder = () => const ClassicFooter();

  runApp(MultiProvider(
    providers: [
      //可以多个provider进行分类处理
      ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => AccountProvider()),
    ],
    child: MyApp(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static BuildContext get context => navigatorKey.currentState!.context;
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    // 监听系统事件
    WidgetsBinding.instance.addObserver(this);
    // DBHelper.delete(accountDbTableName);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final MyThemeType themeType = MySharedPreferences.getThemeTypeSync();
      myThemeProvider(context, listen: false).changeTheme(themeType);
    });
  }

  @override
  void dispose() {
    // 取消监听系统事件
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    debugPrint("主题模式发生改变");
    // 亮度变化（主题模式发生改变也会）时的处理逻辑
    super.didChangePlatformBrightness();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) {
        return;
      }
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      if (provider.type == MyThemeType.system) {
        debugPrint("通知改变系统主题");
        provider.changeTheme(MyThemeType.system);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MyTheme theme = myThemeProvider(context).getTheme(context);
    // 隐藏状态栏背景
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: theme.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
          primarySwatch: MaterialColor(theme.primaryColor.value, {
            50: theme.primaryColor.withOpacity(0.05),
            100: theme.primaryColor.withOpacity(0.1),
            200: theme.primaryColor.withOpacity(0.2),
            300: theme.primaryColor.withOpacity(0.3),
            400: theme.primaryColor.withOpacity(0.4),
            500: theme.primaryColor.withOpacity(0.5),
            600: theme.primaryColor.withOpacity(0.6),
            700: theme.primaryColor.withOpacity(0.7),
            800: theme.primaryColor.withOpacity(0.8),
            900: theme.primaryColor.withOpacity(0.9),
          }),
          // scaffold背景颜色
          scaffoldBackgroundColor: theme.backgroundColor,
          // splashFactory: NoSplash.splashFactory, // 全局禁用波纹效果
          // 去除TabBar底部线条
          // tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
        ),
        darkTheme: ThemeData(
          primarySwatch: MaterialColor(theme.primaryColor.value, {
            50: theme.primaryColor.withOpacity(0.05),
            100: theme.primaryColor.withOpacity(0.1),
            200: theme.primaryColor.withOpacity(0.2),
            300: theme.primaryColor.withOpacity(0.3),
            400: theme.primaryColor.withOpacity(0.4),
            500: theme.primaryColor.withOpacity(0.5),
            600: theme.primaryColor.withOpacity(0.6),
            700: theme.primaryColor.withOpacity(0.7),
            800: theme.primaryColor.withOpacity(0.8),
            900: theme.primaryColor.withOpacity(0.9),
          }),
          // scaffold背景颜色
          scaffoldBackgroundColor: theme.backgroundColor,
        ),
        themeMode: ThemeMode.system,
        navigatorKey: navigatorKey,
        home: const SplashPage(),
        builder: (BuildContext context, Widget? child) {
          return FlutterSmartDialog.init().call(context, child);
        },
      ),
    );
  }
}
