import 'package:eth_wallet/pages/account/account_info_page.dart';
import 'package:eth_wallet/pages/account/create_account_page.dart';
import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../provider/theme_provider.dart';
import '../../../utils/account/account_model.dart';
import '../../../utils/my_route.dart';
import '../../../utils/my_toast.dart';
import '../account_qrcode_page.dart';

class AccountListItemWidget extends StatelessWidget {

  final AccountModel account;
  const AccountListItemWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: const EdgeInsets.only(top: 14, left: 10, bottom: 16),
      // 圆角阴影
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
      child: Row(
        children: [
          account.getAvatarImage(),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 200),
                    child: Text(account.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: theme.textColor),),
                  ),
                  if (account.isEncryption)
                    Icon(CupertinoIcons.lock_fill, size: 14, color: theme.primaryColor,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(account.addressString, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: theme.textGrey),),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(Icons.copy, color: theme.textGrey, size: 14),
                  ).onTap((){
                    Clipboard.setData(ClipboardData(text: account.address));
                    MyToast.show(myS().copyToClipboardSuccess, toastType: ToastType.success);
                  }),
                ],
              ),
            ],
          ).expanded(),
          Container(
            color: theme.white,
            height: 40,
            width: 40,
            alignment: Alignment.center,
            child: Icon(Icons.qr_code, color: theme.textGrey, size: 16),
          ).onTap((){
            MyRoute.push(AccountQrcodePage(account: account,));
          }),
        ],
      ),
    ).onTap((){
      MyRoute.push(AccountInfoPage(account: account,));
    });
  }
}
