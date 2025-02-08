import 'package:eth_wallet/main.dart';
import 'package:eth_wallet/provider/account_provider.dart';
import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/provider/theme_provider.dart';
import 'package:eth_wallet/utils/account/account_manager.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/utils/my_loading.dart';
import 'package:eth_wallet/utils/my_route.dart';
import 'package:eth_wallet/utils/my_shared_preferences.dart';
import 'package:eth_wallet/utils/my_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/my_app_bar.dart';
import '../../widget/my_button.dart';
import '../../widget/my_text_field.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage>
    with WidgetsBindingObserver {
  String _name = "";
  String _password = "";
  bool _isEncryption = false;

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
                  _buildTextField(myListenS(context).name, "",
                      myListenS(context).inputName, onChanged: (text) {
                    _name = text;
                  }),
                  _buildSwitch(myListenS(context).isEncryption, _isEncryption, (value) {
                    setState(() {
                      _isEncryption = value;
                    });
                  }),
                  if (_isEncryption) _buildTextField(myListenS(context).password, "",
                      myListenS(context).inputPassword,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (text) {
                    _password = text;
                  }),
                  Container(
                    color: theme.white,
                    padding: const EdgeInsets.only(top: 10, bottom: 16, left: 16, right: 16),
                    child: Text(
                      "* ${myListenS(context).encryptionTip}",
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )

                ],
              ),
            ),
          ),
          MyButton.colorButton(
              color: theme.primaryColor,
              text: myListenS(context).createAccount,
              onPressed: () async {
                if (_name.isEmpty) {
                  MyToast.show(myS().inputName);
                  return;
                }
                if (_isEncryption && _password.isEmpty) {
                  MyToast.show(myS().inputPassword);
                  return;
                }
                MyLoading.show();
                // 收起键盘
                FocusScope.of(context).requestFocus(FocusNode());
                String pwd = _password;
                if (!_isEncryption) {
                  pwd = await MySharedPreferences.getWalletPassword() ?? '';
                }
                final account = await AccountManager.createAccount(
                    name: _name, password: pwd);
                if (account == null) {
                  await MyLoading.dismiss();
                  MyToast.show(myS().createAccountFail);
                  return;
                }
                account.isEncryption = _isEncryption;
                await AccountProvider.addAccount(account);
                await AccountProvider.setCurrentAccount(account);
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

  // switch Widget
  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    final theme = myListenTheme(context);
    return ColoredBox(
      color: theme.white,
      child: Column(
        children: [
          Container(
            color: theme.white,
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    title,
                    style: TextStyle(color: theme.textColor, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CupertinoSwitch(
                    value: value,
                    onChanged: (bool value) { onChanged(value); },
                    activeColor: theme.primaryColor,
                  )
                )
              ]
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Divider(
              color: theme.backgroundColor,
            ),
          ),
        ],
      ),
    );
  }

}
