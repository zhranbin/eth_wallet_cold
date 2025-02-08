import 'package:eth_wallet/main.dart';
import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/provider/theme_provider.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/utils/my_route.dart';
import 'package:eth_wallet/widget/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';


class AlertPopWidget extends StatelessWidget {
  final String title;
  final String content;
  final String? cancelButtonText;
  final String? confirmedButtonText;
  final bool isShowCancelButton;
  final Function(bool)? onPressed;

  const AlertPopWidget({super.key, this.title = '', this.content = '', this.cancelButtonText, this.confirmedButtonText, this.isShowCancelButton = true, this.onPressed});

  static Future<bool?> show({ String title = '', String content = '', String? cancelButtonText, String? confirmedButtonText, bool isShowCancelButton = true, Function(bool)? onPressed}) {
    return SmartDialog.show(
      builder: (_) => AlertPopWidget(
        title: title,
        content: content,
        cancelButtonText: cancelButtonText,
        confirmedButtonText: confirmedButtonText,
        isShowCancelButton: isShowCancelButton,
        onPressed: onPressed,
      ),
        clickMaskDismiss: false,
        backDismiss: false,
    );
  }


  static Future<bool?> showIosAlert({String title = '', String content = '', String? cancelButtonText, String? confirmedButtonText, bool isShowCancelButton = true, BuildContext? context }) {
    return showCupertinoDialog(
        context: context ?? MyApp.context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text(confirmedButtonText ?? myListenS(context).confirm),
                onPressed: () {
                  MyRoute.pop(result: true);
                },
              ),
              if (isShowCancelButton) CupertinoDialogAction(
                child: Text(cancelButtonText ?? myListenS(context).cancel, style: const TextStyle(color: Colors.red),),
                onPressed: () {
                  MyRoute.pop(result: false);
                },
              ),
            ]
          );
        }
    );
  }

  static Future<dynamic> iosAlert({Widget? titleWidget, Widget? contentWidget, List<Widget> actions = const [], BuildContext? context }) {
    return showCupertinoDialog(
      context: context ?? MyApp.context,
      builder: (context) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        print("主题 - ${provider.isDark}");
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: provider.isDark ? Brightness.dark : Brightness.light,
          ),
          child: CupertinoAlertDialog(
            title: titleWidget,
            content: contentWidget,
            actions: actions,
          ),
        );
      }
    );
  }



  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 26, left: 16, right: 16),
      // 圆角
      decoration: BoxDecoration(
        color: theme.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 标题
          if (title.isNotEmpty) FittedBox(child: Text(title, style: TextStyle(color: theme.textColor, fontSize: 18, fontWeight: FontWeight.bold,),)),
          if (title.isNotEmpty) const SizedBox(height: 8,),
          // 内容
          if (content.isNotEmpty) Text(content, style: TextStyle(color: theme.textGrey, fontSize: 16), softWrap: true, maxLines: 8, textAlign: TextAlign.center,),
          if (content.isNotEmpty) const SizedBox(height: 20,),
          // 按钮
          Row(
            children: [
              if (isShowCancelButton) MyButton.gradientColorButton(
                text: cancelButtonText ?? myListenS(context).cancel,
                textColor: theme.white,
                fontWeight: FontWeight.w600,
                colors: [theme.textGrey, theme.textGrey],
                cornerRadius: 6,
                onPressed: (){
                  SmartDialog.dismiss(result: false);
                  onPressed?.call(false);
                },).height(48).expanded(),
              if (isShowCancelButton) SizedBox(width: 10,),
              MyButton.gradientColorButton(
                text: confirmedButtonText ?? myListenS(context).confirm,
                textColor: theme.white,
                fontWeight: FontWeight.w600,
                colors: [theme.primaryColor, theme.secondaryColor],
                cornerRadius: 6,
                onPressed: (){
                  SmartDialog.dismiss(result: true);
                  onPressed?.call(true);
                },).height(48).expanded(),
            ],
          ),
        ],
      ),
    ).addPadding(const EdgeInsets.symmetric(horizontal: 30));
  }
}
