import 'package:eth_wallet/pages/account/account_change_password_page.dart';
import 'package:eth_wallet/provider/theme_provider.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/utils/my_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../provider/account_provider.dart';
import '../../provider/language_provider.dart';
import '../../utils/account/account_manager.dart';
import '../../utils/my_loading.dart';
import '../../utils/my_route.dart';
import '../../utils/my_shared_preferences.dart';
import '../../widget/my_app_bar.dart';
import '../../widget/my_button.dart';
import '../../widget/my_text_field.dart';
import '../../widget/scan_qr_code/qr_view.dart';

class ImportAccountPage extends StatefulWidget {

  const ImportAccountPage({super.key});

  @override
  State<ImportAccountPage> createState() => _ImportAccountPageState();
}

class _ImportAccountPageState extends State<ImportAccountPage> with WidgetsBindingObserver {

  PageController _pageController = PageController(initialPage: 0);
  ImportAccountType _type = ImportAccountType.keystore;

  final TextEditingController _privateKeyController = TextEditingController();
  final TextEditingController _mnemonicController = TextEditingController();
  final TextEditingController _keystoreController = TextEditingController();
  String _name = "";
  String _password = "";

  bool _isEncryption = true;
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


  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      appBar: MyAppBar(
        title: myListenS(context).importAccount,
        rightWidget: IconButton(
          padding: const EdgeInsets.all(16),
          icon: const Icon(Icons.fit_screen, size: 24,),
          onPressed: () {
            _scanAction();
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: theme.white,
            child: Row(
              children: [
                const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6,),
                    Text("keystore",
                      style: TextStyle(fontSize: 16, fontWeight: _type == ImportAccountType.keystore ? FontWeight.w400 : FontWeight.w400, color: _type == ImportAccountType.keystore ? theme.textColor : theme.textGrey),
                    ).addPadding(EdgeInsets.symmetric(vertical: 6, horizontal: 8)),
                    const SizedBox(height: 4,),
                    Container(height: 2, width: 40, color: _type == ImportAccountType.keystore ? theme.textColor : Colors.transparent,)
                  ],
                ).onTap((){
                  _pageController.jumpToPage(0);
                  setState(() {
                    _isEncryption = true;
                    _type = ImportAccountType.keystore;
                  });
                }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6,),
                    Text(myListenS(context).privateKey,
                      style: TextStyle(fontSize: 16, fontWeight: _type == ImportAccountType.privateKey ? FontWeight.w400 : FontWeight.w400, color: _type == ImportAccountType.privateKey ? theme.textColor : theme.textGrey),
                    ).addPadding(EdgeInsets.symmetric(vertical: 6, horizontal: 8)),
                    const SizedBox(height: 4,),
                    Container(height: 2, width: 40, color: _type == ImportAccountType.privateKey ? theme.textColor : Colors.transparent,)
                  ],
                ).onTap((){
                  _pageController.jumpToPage(1);
                  setState(() {
                    _type = ImportAccountType.privateKey;
                  });
                }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6,),
                    Text(myListenS(context).mnemonic,
                      style: TextStyle(fontSize: 16, fontWeight: _type == ImportAccountType.mnemonic ? FontWeight.w400 : FontWeight.w400, color: _type == ImportAccountType.mnemonic ? theme.textColor : theme.textGrey),
                    ).addPadding(EdgeInsets.symmetric(vertical: 6, horizontal: 8)),
                    const SizedBox(height: 4,),
                    Container(height: 2, width: 40, color: _type == ImportAccountType.mnemonic ? theme.textColor : Colors.transparent,)
                  ],
                ).onTap((){
                  _pageController.jumpToPage(2);
                  setState(() {
                    _type = ImportAccountType.mnemonic;
                  });
                }),
              ],
            ),
          ),
          Container(color: theme.backgroundColor, height: 1,),
          ListView(
            children: [
              PageView(
                controller: _pageController,
                children: [
                  _contentTextField(_keystoreController, keyboardType: TextInputType.multiline, hintText: myListenS(context).inputKeystore).keepAlive,
                  _contentTextField(_privateKeyController, hintText: myListenS(context).inputPrivateKey).keepAlive,
                  _contentTextField(_mnemonicController, hintText: myListenS(context).inputMnemonic).keepAlive,
                ],
              ).height(160),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  color: theme.backgroundColor,
                  height: 1,
                ),
              ),
              _buildTextField(myListenS(context).name, _name, hintText: myListenS(context).inputName, onChanged: (value) {
                setState(() {
                  _name = value;
                });
              }),
              _buildSwitch(myListenS(context).isEncryption, _isEncryption, (value) {
                if (value == false && _type == ImportAccountType.keystore) {
                  MyToast.show(myS().keystorePasswordTypeTip);
                  setState(() {
                    _isEncryption = true;
                  });
                  return;
                }
                setState(() {
                  _isEncryption = value;
                });
              }),
              if (_isEncryption) _buildTextField("${myListenS(context).password}${_type == ImportAccountType.keystore ? "(${myListenS(context).keystorePassword})" : ''}", _password, isPassword: true, hintText: myListenS(context).inputPassword, onChanged: (value) {
                setState(() {
                  _password = value;
                });
              }),
            ],
          ).expanded(),
          MyButton.colorButton(
              color: theme.primaryColor,
              text: myListenS(context).importAccount,
              onPressed: () async {
                _importAction();
              }).margin(const EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: _bottomHeight),

        ],
      ),
    );
  }

  Widget _contentTextField(TextEditingController controller, {TextInputType keyboardType = TextInputType.text, String? hintText}) {
    final theme = myListenTheme(context);
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: theme.white,
        borderRadius: BorderRadius.circular(6),
        // boxShadow: [
        //   BoxShadow(
        //     color: theme.grey.withOpacity(0.6),
        //     blurRadius: 4,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: MyTextField(
        controller: controller,
        textColor: theme.textColor,
        hintText: hintText,
        maxLines: 1000,
        hintColor: theme.textGrey,
        textSize: 14,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildTextField(String title, String text, {bool isPassword = false, TextInputType keyboardType = TextInputType.text, String? tipText, String? hintText, Function(String)? onChanged}) {
    final theme = myListenTheme(context);
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
              onChanged: onChanged,
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

  _importAction() {
    switch (_type) {
      case ImportAccountType.privateKey:
        _importPrivateKey();
        break;
      case ImportAccountType.mnemonic:
        _importMnemonic();
        break;
      case ImportAccountType.keystore:
        _importKeystore();
        break;
    }
  }

  _importPrivateKey() async {
    if (_privateKeyController.text.isEmpty) {
      MyToast.show(myS().inputPrivateKey);
      return;
    }
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
    final account = await AccountManager.createAccountFromPrivateKey(
        privateKey: _privateKeyController.text,
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
  }

  _importMnemonic() async {
    if (_mnemonicController.text.isEmpty) {
      MyToast.show(myS().inputMnemonic);
      return;
    }
    if (_name.isEmpty) {
      MyToast.show(myS().inputName);
      return;
    }
    if (_isEncryption && _password.isEmpty) {
      MyToast.show(myS().inputPassword);
      return;
    }
    MyLoading.show();
    FocusScope.of(context).requestFocus(FocusNode());
    String pwd = _password;
    if (!_isEncryption) {
      pwd = await MySharedPreferences.getWalletPassword() ?? '';
    }
    final account = await AccountManager.createAccountFromMnemonic(
        mnemonic: _mnemonicController.text,
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
  }

  _importKeystore() async {
    if (_keystoreController.text.isEmpty) {
      MyToast.show(myS().inputKeystore);
      return;
    }
    if (_name.isEmpty) {
      MyToast.show(myS().inputName);
      return;
    }
    if (_isEncryption && _password.isEmpty) {
      MyToast.show(myS().inputPassword);
      return;
    }
    MyLoading.show();
    FocusScope.of(context).requestFocus(FocusNode());
    String pwd = _password;
    if (!_isEncryption) {
      pwd = await MySharedPreferences.getWalletPassword() ?? '';
    }
    final account = await AccountManager.createAccountFromJson(
        json: _keystoreController.text,
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
  }


  /// 扫一扫点击
  void _scanAction() async {
    print("扫一扫");
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const QrcodeView())) as String?;
    if (result != null) {
      print("扫描结果：${result}");
      switch (_type) {
        case ImportAccountType.privateKey:
          _privateKeyController.text = result;
          break;
        case ImportAccountType.mnemonic:
          _mnemonicController.text = result;
          break;
        case ImportAccountType.keystore:
          _keystoreController.text = result;
          break;
      }
    }
  }

}


enum ImportAccountType {
  // 私钥导入
  privateKey,
  // 助记词导入
  mnemonic,
  // keystone导入
  keystore,
}