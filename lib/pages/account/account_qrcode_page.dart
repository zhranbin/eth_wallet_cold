import 'package:eth_wallet/pages/account/create_account_page.dart';
import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/provider/theme_provider.dart';
import 'package:eth_wallet/utils/account/account_model.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/widget/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/my_toast.dart';

class AccountQrcodePage extends StatelessWidget {
  final AccountModel account;
  const AccountQrcodePage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      appBar: MyAppBar(title: myListenS(context).qrcode),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // 头像
          account.getAvatarImage(size: 60, radius: 10),
          const SizedBox(height: 20),
          // 名称
          Text(account.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)).addPadding(EdgeInsets.symmetric(horizontal: 40)),
          const SizedBox(height: 40),
          // 二维码
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: QrImageView(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(6),
                data: account.address,
                // data: ABShare.getAppShareUrl(inviteCode: '111'),
                size: 180.0,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // 地址
          Text(account.address, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey),).addPadding(EdgeInsets.symmetric(horizontal: 40)),
          const SizedBox(height: 20),
          // 复制
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              // 边框
              border: Border.all(color: theme.primaryColor, width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Text(myListenS(context).copyAddress, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: theme.primaryColor),),
            ),
          ).onTap(() {
            Clipboard.setData(ClipboardData(text: account.address));
            MyToast.show(myS().copyToClipboardSuccess);
          }),
        ],
      ),
    );
  }
}
