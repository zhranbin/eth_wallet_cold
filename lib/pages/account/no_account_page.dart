import 'package:eth_wallet/pages/main_page.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/utils/my_assets.dart';
import 'package:eth_wallet/utils/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/my_route.dart';
import '../../widget/my_button.dart';
import 'create_account_page.dart';
import 'import_account_page.dart';

class NoAccountPage extends StatefulWidget {
  const NoAccountPage({super.key});

  @override
  State<NoAccountPage> createState() => _NoAccountPageState();
}

class _NoAccountPageState extends State<NoAccountPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 40 + 80,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                MyAssets.logo(context),
                width: 100,
                height: 100,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(myListenS(context).noAccount, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, color: theme.textColor),),
          const Spacer(),
          // 创建账号
          MyButton.colorButton(color: theme.primaryColor, text: myListenS(context).createAccount, onPressed: () async {
            final account = await MyRoute.push(const CreateAccountPage());
            if (account != null) {
              MyRoute.pushReplacement(const MainPage());
            }
          }).height(48).addPadding(const EdgeInsets.symmetric(horizontal: 16)),
          const SizedBox(height: 20,),
          // 导入账号
          MyButton.colorButton(color: theme.primaryColor, text: myListenS(context).importAccount, onPressed: () {
            MyRoute.push(const ImportAccountPage());
          }).height(48).addPadding(const EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 10,)
        ],
      ),
    );
  }
}
