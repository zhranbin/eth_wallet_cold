import 'package:eth_wallet/main.dart';
import 'package:eth_wallet/pages/account/account_info_page.dart';
import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/utils/my_route.dart';
import 'package:flutter/material.dart';

import '../../../provider/theme_provider.dart';
import '../../../widget/custom_password/password_input_widget.dart';

class AccountAddChooseWidget extends StatelessWidget {
  const AccountAddChooseWidget({super.key});

  static Future<AccountAddChooseWidgetType?> show(BuildContext context) async {
    return await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const AccountAddChooseWidget();
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Container(
      // height: MediaQuery.of(context).padding.bottom + 240 + 60 + 36 + 48,
        decoration: BoxDecoration(
          // 部分圆角(顶部圆角)
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.grey.withOpacity(0.9),
              offset: Offset(0, 8),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
          color: theme.white,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Container(
                height: 60,
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(myS().addAccount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: theme.textColor),).center(),
              ),
              const SizedBox(height: 10),
              _itemWidget(context, AccountAddChooseWidgetType.createAccount),
              _itemWidget(context, AccountAddChooseWidgetType.importAccount),
              _itemWidget(context, AccountAddChooseWidgetType.beautifulAccount),
              // _itemWidget(context, AccountAddChooseWidgetType.importPrivateKey),
              // _itemWidget(context, AccountAddChooseWidgetType.importMnemonic),
              // _itemWidget(context, AccountAddChooseWidgetType.importKeystore),
              Container(
                height: MediaQuery.of(context).padding.bottom,
                color: theme.white,
              ),
            ]
        )
    );
  }


  Widget _itemWidget(BuildContext context, AccountAddChooseWidgetType type) {
    final theme = myListenTheme(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: theme.grey.withOpacity(0.5),
            offset: const Offset(0, 0),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      height: 52,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: IOSClickEffectCell(
        onTap: () {
          MyRoute.pop(result: type);
        },
        child: Text(type.title, style: TextStyle(fontSize: 16, color: theme.textColor),).center(),
      )
    );
  }

}

enum AccountAddChooseWidgetType {
  createAccount,
  importAccount,
  // 靓号
  beautifulAccount
  // // 私钥导入
  // importPrivateKey,
  // // 助记词导入
  // importMnemonic,
  // // keystone导入
  // importKeystore,
}

extension AccountAddChooseWidgetTypeExtension on AccountAddChooseWidgetType {
  String get title {
    switch (this) {
      case AccountAddChooseWidgetType.createAccount:
        return myS().createAccount;
        case AccountAddChooseWidgetType.importAccount:
          return myS().importAccount;
          case AccountAddChooseWidgetType.beautifulAccount:
            return myS().beautifulAccount;
      // case AccountAddChooseWidgetType.importPrivateKey:
      //   return myS().importPrivateKey;
      // case AccountAddChooseWidgetType.importMnemonic:
      //   return myS().importMnemonic;
      // case AccountAddChooseWidgetType.importKeystore:
      //   return myS().importKeystore;
   }
  }
}