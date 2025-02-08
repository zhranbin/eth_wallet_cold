import 'package:eth_wallet/pages/account/create_account_page.dart';
import 'package:eth_wallet/pages/account/widget/account_list_widget.dart';
import 'package:eth_wallet/pages/setting_page.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/utils/my_route.dart';
import 'package:flutter/material.dart';

import '../provider/language_provider.dart';
import '../provider/theme_provider.dart';
import 'account/beautiful_account_page.dart';
import 'account/import_account_page.dart';
import 'account/widget/account_add_choose_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  PageController _pageController = PageController();
  AccountListType _accountListType = AccountListType.all;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top + 60,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            color: theme.white,
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                   MyRoute.push(const SettingPage());
                  },
                  icon: Icon(Icons.settings_outlined, color: theme.black,),
                ),
                const Spacer(),
                _topBarItem(myListenS(context).all, isSelected: _accountListType == AccountListType.all, onTap: () {
                  _pageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.ease);
                  setState(() {
                    _accountListType = AccountListType.all;
                  });
                }),
                _topBarItem(myListenS(context).encryption, isSelected: _accountListType == AccountListType.encrypted, onTap: (){
                  _pageController.animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.ease);
                  setState(() {
                    _accountListType = AccountListType.encrypted;
                  });
                }),
                _topBarItem(myListenS(context).noEncryption, isSelected: _accountListType == AccountListType.unencrypted, onTap: (){
                  _pageController.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.ease);
                  setState(() {
                    _accountListType = AccountListType.unencrypted;
                  });
                }),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    final type = await AccountAddChooseWidget.show(context);
                    if (type == AccountAddChooseWidgetType.createAccount) {
                      MyRoute.push(const CreateAccountPage());
                    }
                    if (type == AccountAddChooseWidgetType.importAccount) {
                      MyRoute.push(const ImportAccountPage());
                    }
                    if (type == AccountAddChooseWidgetType.beautifulAccount) {
                      MyRoute.push(const BeautifulAccountPage());
                    }
                  },
                  icon: Icon(Icons.add_box_outlined, color: theme.black,),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                // 全部
                const AccountListWidget(type: AccountListType.all,).keepAlive,
                // 加密
                const AccountListWidget(type: AccountListType.encrypted,).keepAlive,
                // 未加密
                const AccountListWidget(type: AccountListType.unencrypted,).keepAlive,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBarItem(String title, {bool isSelected = false, Function? onTap}) {
    final theme = myListenTheme(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 74),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      color: theme.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? theme.textColor : theme.textGrey),),
          const SizedBox(height: 4),
          // 下划线
          Container(
            width: 24,
            height: 2,
            color: isSelected ? theme.textColor : Colors.transparent,
          ),
        ],
      ),
    ).onTap((){
      onTap?.call();
    });
  }

}
