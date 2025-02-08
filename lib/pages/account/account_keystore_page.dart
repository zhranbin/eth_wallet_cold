import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/my_toast.dart';
import '../../widget/my_app_bar.dart';

class AccountKeystorePage extends StatefulWidget {
  final String keystore;
  const AccountKeystorePage({super.key, required this.keystore});

  @override
  State<AccountKeystorePage> createState() => _AccountKeystorePageState();
}

class _AccountKeystorePageState extends State<AccountKeystorePage> {
  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      appBar: const MyAppBar(title: "Keystore",),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20,),
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
                data: widget.keystore,
                // data: ABShare.getAppShareUrl(inviteCode: '111'),
                size: 180.0,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // 助记词
          Text(widget.keystore, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.grey),).addPadding(const EdgeInsets.symmetric(horizontal: 40)),
          const SizedBox(height: 20),
          // 复制
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              // 边框
              border: Border.all(color: theme.primaryColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Text(myListenS(context).copy, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: theme.primaryColor),),
            ),
          ).onTap(() {
            Clipboard.setData(ClipboardData(text: widget.keystore));
            MyToast.show(myS().copyToClipboardSuccess);
          }),
          const SizedBox(height: 40),
          // tip
          Text("* ${myListenS(context).keystorePasswordTip}", textAlign: TextAlign.left, style: const TextStyle(fontSize: 14, color: Colors.red),).addPadding(const EdgeInsets.symmetric(horizontal: 40)),
        ],
      ),
    );
  }
}

