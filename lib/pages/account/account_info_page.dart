import 'package:eth_wallet/pages/account/account_keystore_page.dart';
import 'package:eth_wallet/pages/account/account_mnemonic_page.dart';
import 'package:eth_wallet/pages/account/account_qrcode_page.dart';
import 'package:eth_wallet/pages/splash_page.dart';
import 'package:eth_wallet/provider/account_provider.dart';
import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/utils/account/account_model.dart';
import 'package:eth_wallet/utils/extensions/string_extensions.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/utils/my_loading.dart';
import 'package:eth_wallet/utils/my_route.dart';
import 'package:eth_wallet/utils/my_shared_preferences.dart';
import 'package:eth_wallet/widget/my_app_bar.dart';
import 'package:eth_wallet/widget/my_button.dart';
import 'package:eth_wallet/widget/text_input_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';
import '../../utils/account/account_manager.dart';
import '../../utils/my_toast.dart';
import '../../widget/alert_pop_widget.dart';
import '../../widget/custom_password/password_input_widget.dart';
import 'account_change_password_page.dart';
import 'account_private_key_page.dart';
import 'no_account_page.dart';

class AccountInfoPage extends StatefulWidget {
  final AccountModel account;

  const AccountInfoPage({super.key, required this.account});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      appBar: MyAppBar(
        title: myListenS(context).accountInfo,
      ),
      body: Column(
        children: [
          ListView(
            children: [
              Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: theme.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        widget.account.getAvatarImage(size: 60, radius: 10),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.account.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: theme.black),
                        ),
                        const SizedBox(height: 30,),
                        addressItem(),
                        const SizedBox(height: 20,),
                        Divider(color: theme.grey.withOpacity(0.6),),
                        _getItem(title: myListenS(context).qrcode, onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AccountQrcodePage(account: widget.account,)));
                        }),
                        // 名称
                        _getItem(title: myListenS(context).name, value: widget.account.name, onTap: () async {
                          final name = await MyRoute.push(TextInputPage(title: myS().name, placeholder: myS().inputName, text: widget.account.name,));
                          if (name == null || name.isEmpty) return;
                          final newAccount = widget.account;
                          newAccount.name = name;
                          AccountProvider.updateAccount(newAccount);
                        }),
                        // 私钥
                        _getItem(title: myListenS(context).privateKey, onTap: () async {
                          _privateKeyAction();
                        }),
                        // 助记词
                        _getItem(title: myListenS(context).mnemonic, onTap: (){
                          _mnemonicAction();
                        }),
                        // keystore
                        _getItem(title: "Keystore", onTap: () async {
                          _keystoreAction();
                        }),
                        // 修改密码
                        if (widget.account.isEncryption) _getItem(title: myListenS(context).changePassword, onTap: () async {
                          MyRoute.push(AccountChangePasswordPage(account: widget.account,));
                        }),
                        // 解除加密
                        if (widget.account.isEncryption) _getItem(title: myListenS(context).cancelEncrypted, onTap: () async {
                          _cancelEncryptedAction();
                        }),
                      ]))
            ],
          ).expanded(),
          const SizedBox(height: 10,),
          MyButton.gradientColorButton(
            text: myListenS(context).delete,
            textColor: theme.white,
            fontWeight: FontWeight.w600,
            colors: [theme.textGrey, theme.textGrey],
            cornerRadius: 6,
            onPressed: () async {
              final pwd = await PasswordInputWidget.show(context);
              if (pwd == null || pwd.isEmpty) return;
              final password = pwd.MD5;
              MyLoading.show();
              final localPwd = await MySharedPreferences.getWalletPassword();
              if (password != localPwd) {
                MyLoading.dismiss();
                MyToast.show(myS().verificationFail);
                return;
              }
              await AccountProvider.deleteAccount(widget.account.address);
              MyLoading.dismiss();
              if (mounted) {
                final p = Provider.of<AccountProvider>(context, listen: false);
                if(p.accountList.isEmpty ) {
                  await MyRoute.popToRoot();
                  MyRoute.pushReplacement(const NoAccountPage());
                } else {
                  MyRoute.pop();
                }
              }
            },
          ).addPadding(EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 10,),
        ],
      ),
    );
  }

  Widget addressItem() {
    final theme = myListenTheme(context);
    return InkWell(
      onLongPress: (){
        Clipboard.setData(ClipboardData(text: widget.account.address));
        MyToast.show(myS().copyToClipboardSuccess);
      },
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "${myListenS(context).address}",
                style: TextStyle(fontSize: 16, color: theme.black),
              ),
              Text(
                "（${myListenS(context).longTapCopy}）",
                style: TextStyle(fontSize: 14, color: theme.textGrey),
              ).expanded(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(widget.account.address, style: TextStyle(fontSize: 14, color: theme.textGrey))
        ],
      ),
    );
  }


  Widget _getItem({required String title, String value = '', GestureTapCallback? onTap}) {
    final theme = myListenTheme(context);
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 48,
            // padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, color: theme.black),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 14, color: theme.textGrey),
                  textAlign: TextAlign.end,
                ).expanded(),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.textGrey,
                  )
                else
                  Container()
              ],
            ),
          ),
          Divider(color: theme.grey.withOpacity(0.6),),
        ],
      ),
    );
  }


  _privateKeyAction() async {
    final password = await _checkPassword();
    if (password == null) return;
    MyLoading.show();
    final privateKey = await AccountManager.getPrivateKey(json: widget.account.keystore, password: password);
    MyLoading.dismiss();
    if (privateKey.isEmpty) {
      MyToast.show(myS().verificationFail);
      return;
    }
    MyRoute.push(AccountPrivateKeyPage(privateKey: privateKey,));
  }

  _mnemonicAction() async {
    final password = await _checkPassword();
    if (password == null) return;
    MyLoading.show();
    final address = await AccountManager.getAddress(json: widget.account.keystore, password: password);
    MyLoading.dismiss();
    if (address == widget.account.address && widget.account.mnemonic.isNotEmpty) {
      MyRoute.push(AccountMnemonicPage(mnemonic: widget.account.mnemonic));
      return;
    }
    MyToast.show(myS().verificationFail);
  }

  _keystoreAction() async {
    if (widget.account.isEncryption) {
      MyRoute.push(AccountKeystorePage(keystore: widget.account.keystore));
      return;
    }
    final pwd = await PasswordInputWidget.show(context);
    if (pwd == null || pwd.isEmpty) return;
    MyLoading.show();
    final localPwd = await MySharedPreferences.getWalletPassword() ?? '';
    if (pwd.MD5 != localPwd) {
      MyLoading.dismiss();
      MyToast.show(myS().verificationFail);
      return;
    }
    final keystore = await AccountManager.changePassword(json: widget.account.keystore, oldPassword: localPwd, newPassword: pwd);
    if (keystore.isEmpty) {
      MyLoading.dismiss();
      MyToast.show(myS().verificationFail);
      return;
    }
    MyLoading.dismiss();
    MyRoute.push(AccountKeystorePage(keystore: keystore));

  }

  _cancelEncryptedAction() async {
    final pwd = await _accountPasswordInputAlert();
    if (pwd == null || pwd.isEmpty) return;
    MyLoading.show();
    final address = await AccountManager.getAddress(json: widget.account.keystore, password: pwd);
    if (address != widget.account.address) {
      MyLoading.dismiss();
      MyToast.show(myS().verificationFail);
      return;
    }
    final localPwd = await MySharedPreferences.getWalletPassword() ?? '';
    final newKeystore = await AccountManager.changePassword(json: widget.account.keystore, oldPassword: pwd, newPassword: localPwd);
    final newAccount = widget.account;
    newAccount.keystore = newKeystore;
    newAccount.isEncryption = false;
    await AccountProvider.updateAccount(newAccount);
    await MyLoading.dismiss();
  }


  Future<String?> _checkPassword() async {
    if (widget.account.isEncryption) {
      return await _accountPasswordInputAlert();
    } else {
      final pwd = await PasswordInputWidget.show(context);
      if (pwd == null || pwd.isEmpty) return null;
      return pwd.MD5;
    }
  }

  Future<String?> _accountPasswordInputAlert() async {
    final theme = myTheme();
    String tipStr = myS().inputAccountPassword;
    String password = '';
    final result = await AlertPopWidget.iosAlert(
        context: context,
        titleWidget: Text(tipStr, style: TextStyle(fontSize: 16, color: theme.textColor),),
        contentWidget: CupertinoTextField(
          placeholder: myS().inputPassword,
          style: const TextStyle(
            fontSize: 14.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
          ),
          obscureText: true,
          onChanged: (value) {
            password = value;
          },
        ).addPadding(EdgeInsets.only(top: 10)),
        actions: [
          CupertinoDialogAction(
            child: Text(myS().confirm),
            onPressed: () {
              if (password.isEmpty) {
                MyToast.show(tipStr);
                return;
              }
              MyRoute.pop(result: password);
            },
          ),
          CupertinoDialogAction(
            child: Text(myS().cancel, style: const TextStyle(color: Colors.red),),
            onPressed: () {
              MyRoute.pop(result: '');
            },
          ),
        ]) as String?;
    if (result == null || result.isNotEmpty != true) return null;
    return result;
  }

}
