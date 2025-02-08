import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/utils/account/account_model.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/widget/my_app_bar.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../provider/account_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/account/account_manager.dart';
import '../../utils/my_loading.dart';
import '../../utils/my_route.dart';
import '../../utils/my_shared_preferences.dart';
import '../../utils/my_toast.dart';
import '../../widget/my_button.dart';
import '../../widget/my_text_field.dart';

class AccountChangePasswordPage extends StatefulWidget {
  final AccountModel account;
  const AccountChangePasswordPage({super.key, required this.account});

  @override
  State<AccountChangePasswordPage> createState() => _AccountChangePasswordPageState();
}

class _AccountChangePasswordPageState extends State<AccountChangePasswordPage> with WidgetsBindingObserver {
  String _oldPassword = "";
  String _password = "";
  String _confirmPassword = "";

  /// 底部高度(用于控制“创建按钮”到底部的距离，避免键盘弹出时，底部按钮距离键盘太远)
  double _bottomHeight = 10;

  @override
  void initState() {
    super.initState();
    _bottomHeight = MediaQuery.of(MyApp.context).padding.bottom + 10;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // 移除键盘状态监听器
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyTheme theme = myListenTheme(context);
    return Scaffold(
      appBar: MyAppBar(
        title: myListenS(context).createAccount,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // const SizedBox(height: 16),
                  _buildTextField(myListenS(context).oldPassword, "",
                      myListenS(context).inputPassword,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (text) {
                        _oldPassword = text;
                      }),
                  _buildTextField(myListenS(context).newPassword, "",
                      myListenS(context).inputPassword,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (text) {
                        _password = text;
                      }),
                  _buildTextField(myListenS(context).confirmPassword, "",
                      myListenS(context).inputPassword,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (text) {
                        _confirmPassword = text;
                      }),
                ],
              ),
            ),
          ),
          MyButton.colorButton(
              color: theme.primaryColor,
              text: myListenS(context).confirm,
              onPressed: () async {
                if (_oldPassword.isEmpty) {
                  MyToast.show(myS().changePasswordTip);
                  return;
                }
                if (_password.isEmpty) {
                  MyToast.show(myS().changePasswordTip1);
                  return;
                }
                if (_confirmPassword.isEmpty) {
                  MyToast.show(myS().changePasswordTip2);
                  return;
                }
                if (_confirmPassword != _password) {
                  MyToast.show(myS().changePasswordTip3);
                  return;
                }
                MyLoading.show();
                // 收起键盘
                FocusScope.of(context).requestFocus(FocusNode());
                final account = widget.account;
                final newKeystore = await AccountManager.changePassword(json: account.keystore, oldPassword: _oldPassword, newPassword: _password);
                if (newKeystore.isEmpty) {
                  MyToast.show(myS().verificationFail);
                  await MyLoading.dismiss();
                  return;
                }
                account.keystore = newKeystore;
                await AccountProvider.updateAccount(account);
                await MyLoading.dismiss();
                MyRoute.pop(result: account);
              }).margin(const EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: _bottomHeight),
        ],
      ),
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      setState(() {
        _bottomHeight = 10;
      });
    } else {
      setState(() {
        _bottomHeight = MediaQuery.of(context).padding.bottom + 10;
      });
    }
  }

  Widget _buildTextField(String title, String text, String hintText,
      {bool isPassword = false,
        TextInputType keyboardType = TextInputType.text,
        String? tipText,
        Function(String)? onChanged}) {
    final theme = myListenTheme(context);
    final controller = TextEditingController();
    controller.text = text;
    return Container(
      color: theme.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 0),
              child: Text(
                title,
                style: TextStyle(color: theme.textColor, fontSize: 14),
              )),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: MyTextField(
              text: text,
              textColor: theme.textColor,
              hintText: hintText,
              hintColor: theme.textGrey,
              textSize: 14,
              isPassword: isPassword,
              keyboardType: keyboardType,
              onChanged: (text) => onChanged?.call(text),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Divider(
              color: theme.backgroundColor,
            ),
          ),
          (tipText != null && tipText.isNotEmpty)
              ? Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, top: 0, bottom: 10),
            child: Text(
              "* $tipText",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          )
              : Container(),
        ],
      ),
    );
  }

}
