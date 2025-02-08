import 'package:eth_wallet/pages/account/no_account_page.dart';
import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/utils/account/account_model.dart';
import 'package:eth_wallet/utils/extensions/string_extensions.dart';
import 'package:eth_wallet/utils/my_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/account_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/my_loading.dart';
import '../../../utils/my_shared_preferences.dart';
import '../../../widget/alert_pop_widget.dart';
import '../../../widget/custom_password/password_input_widget.dart';
import 'account_list_item_widget.dart';

class AccountListWidget extends StatefulWidget {
  final AccountListType type;

  const AccountListWidget({super.key, this.type = AccountListType.all});

  @override
  State<AccountListWidget> createState() => _AccountListWidgetState();
}

class _AccountListWidgetState extends State<AccountListWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = myListenTheme(context);
    final provider = Provider.of<AccountProvider>(context);
    List<AccountModel> data = [];
    switch (widget.type) {
      case AccountListType.all:
        data = provider.accountList;
        break;
      case AccountListType.encrypted:
        data = provider.accountList.where((element) => element.isEncryption).toList();
        break;
      case AccountListType.unencrypted:
        data = provider.accountList.where((element) => !element.isEncryption).toList();
        break;
    }
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(itemBuilder: (BuildContext context, int index) {
        AccountModel account = data[index];
        return Dismissible(
          key: Key(account.address),
          direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              // final isDelete = await AlertPopWidget.showIosAlert(title: myS().deleteAccount, content: myS().deleteAccountTip, cancelButtonText: myS().cancel, confirmedButtonText: myS().delete);
              // return isDelete == true;
              final pwd = await PasswordInputWidget.show(context);
              if (pwd == null || pwd.isEmpty) return false;
              final password = pwd.MD5;
              MyLoading.show();
              final localPwd = await MySharedPreferences.getWalletPassword();
              MyLoading.dismiss();
              return password == localPwd;
            },
          onDismissed: (direction) async {
            await AccountProvider.deleteAccount(account.address);
            final p = Provider.of<AccountProvider>(context, listen: false);
            if(p.accountList.isEmpty ) {
              await MyRoute.popToRoot();
              MyRoute.pushReplacement(const NoAccountPage());
            }
          },
          child: AccountListItemWidget(account: data[index],),
        );
      },
        itemCount: data.length,
      ),
    );
  }

}

enum AccountListType {
  // 全部
  all,
  // 加密
  encrypted,
  // 未加密
  unencrypted,
}
