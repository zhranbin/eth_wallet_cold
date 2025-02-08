import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/provider/theme_provider.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/widget/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/my_toast.dart';

class AccountPrivateKeyPage extends StatefulWidget {
  final String privateKey;
  const AccountPrivateKeyPage({super.key, required this.privateKey});

  @override
  State<AccountPrivateKeyPage> createState() => _AccountPrivateKeyPageState();
}

class _AccountPrivateKeyPageState extends State<AccountPrivateKeyPage> {
  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      appBar: MyAppBar(title: myListenS(context).privateKey,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
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
                data: widget.privateKey,
                // data: ABShare.getAppShareUrl(inviteCode: '111'),
                size: 180.0,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // 私钥
          Text(widget.privateKey, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.grey),).addPadding(const EdgeInsets.symmetric(horizontal: 40)),
          const SizedBox(height: 20),
          // 复制
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              // 边框
              border: Border.all(color: theme.primaryColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Text(myListenS(context).copy, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: theme.primaryColor),),
            ),
          ).onTap(() {
            Clipboard.setData(ClipboardData(text: widget.privateKey));
            MyToast.show(myS().copyToClipboardSuccess);
          }),
        ],
      ),
    );
  }
}
