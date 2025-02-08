import 'package:eth_wallet/pages/account/account_change_password_page.dart';
import 'package:eth_wallet/pages/account/widget/account_add_choose_widget.dart';
import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/provider/theme_provider.dart';
import 'package:eth_wallet/utils/account/account_manager.dart';
import 'package:eth_wallet/utils/account/account_model.dart';
import 'package:eth_wallet/utils/extensions/string_extensions.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/utils/my_loading.dart';
import 'package:eth_wallet/widget/my_app_bar.dart';
import 'package:eth_wallet/widget/my_bottom_select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/account_provider.dart';
import '../utils/my_shared_preferences.dart';
import '../utils/my_toast.dart';
import '../widget/custom_password/password_input_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final locale = languageProvider.locale;
    String language = locale.languageCode == "zh" ? "中文" : "English";

    final themeProvider = Provider.of<ThemeProvider>(context);
    String theme = themeProvider.isDark ? myListenS(context).dark : myListenS(context).light;

    return Scaffold(
      appBar: MyAppBar(title: myListenS(context).setting,),
      body: ListView(
        children: [
          _itemWidget(myListenS(context).language, value: language, onTap: (){
            MyBottomSelectDialog.show(
                context,
                title: myS().language,
                actions: [
              MyBottomSelectDialogAction(title: "中文", onTap: (){
                // 设置语言
                LanguageProvider.changeLanguage(
                    Locale.fromSubtags(languageCode: "zh"));
              }),
              MyBottomSelectDialogAction(title: "English", onTap: (){
                // 设置语言
                LanguageProvider.changeLanguage(
                    Locale.fromSubtags(languageCode: "en"));
              }),
            ]);
          }),
          _itemWidget(myListenS(context).theme, value: theme, onTap: (){
            MyBottomSelectDialog.show(
                context,
                title: myS().theme,
                actions: [
                  MyBottomSelectDialogAction(title: myS().light, onTap: (){
                    getMyThemeProvide().changeTheme(MyThemeType.light);
                  }),
                  MyBottomSelectDialogAction(title: myS().dark, onTap: (){
                    getMyThemeProvide().changeTheme(MyThemeType.dark);
                  }),
                ]);
          }),
          _itemWidget(myListenS(context).changePassword, onTap: () async {
            if (!mounted) return;
            final password = await MySharedPreferences.getWalletPassword();
            final oldPassword = await PasswordInputWidget.show(context, title: myS().oldPassword);
            if (oldPassword == null) return;
            if (password != oldPassword.MD5) {
              MyToast.show(myS().oldPasswordError);
              return;
            }

            final newPassword = await PasswordInputWidget.show(context, title: myS().newPassword);
            if (newPassword == null) return;
            final confirmPassword = await PasswordInputWidget.show(context, title: myS().confirmPassword);
            if (confirmPassword == null) return;
            if (newPassword != confirmPassword) {
              MyToast.show(myS().changePasswordTip3);
              return;
            }

            MyLoading.show();
            final accountList = await AccountManager.getAccounts();
            List<AccountModel> newAccountList = [];
            for (var account in accountList) {
              if (!account.isEncryption) {
                final newKeystore = await AccountManager.changePassword(json: account.keystore, oldPassword: oldPassword.MD5, newPassword: newPassword.MD5);
                if (newKeystore.isEmpty) {
                  MyToast.show("${account.addressString} ${myS().verificationFail}");
                  await MyLoading.dismiss();
                  return;
                }
                final newAccount = account;
                newAccount.keystore = newKeystore;
                newAccountList.add(newAccount);
              }
            }
            final res = await MySharedPreferences.setWalletPassword(newPassword.MD5);
            if (res) {
              for (var account in newAccountList) {
                await AccountProvider.updateAccount(account);
              }
              MyToast.show(myS().changePasswordSuccess);
            } else {
              MyToast.show(myS().changePasswordFail);
            }
            MyLoading.dismiss();
          })
        ]
      ),
    );
  }

  Widget _itemWidget(String title, {String? value, Function()? onTap}) {
    final theme = myListenTheme(context);
    return Container(
      color: theme.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 54,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(title, style: TextStyle(color: theme.textColor),),
                ),
                const SizedBox(width: 8,),
                if (value != null) Text(value, style: TextStyle(color: theme.textColor),),
                if (value != null) const SizedBox(width: 8,),
                if (onTap != null) Icon(Icons.arrow_forward_ios, color: theme.textColor, size: 16,),
              ],
            ),
          ),
          Container(
            height: 2,
            color: theme.backgroundColor,
          ),
        ],
      ),
    ).onTap(onTap);
  }



  // ios 风格的底部弹窗
  Future<int?> _showBottomSheet(BuildContext context, {List<String> values = const [],}) {
    Widget itemWidget(String value) {
      return Container(
        // color: myListenTheme(context).white,
        height: 54,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(value, style: TextStyle(color: myListenTheme(context).textColor),),
                  ),
                  const SizedBox(width: 8,),
                  Icon(Icons.arrow_forward_ios, color: myListenTheme(context).textColor, size: 16,),
                ]
              ),
            ),
            Container(
              height: 2,
              color: myListenTheme(context).backgroundColor,
            ),
          ]
        )
      );
    }

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: myListenTheme(context).white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16,),
              ...values.map((e) => itemWidget(e)),
              Container(
                height: MediaQuery.of(context).padding.bottom + 10,
              ),
            ]
          )
        );
      }
    );
  }

}
