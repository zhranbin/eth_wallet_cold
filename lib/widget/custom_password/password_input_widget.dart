import 'package:eth_wallet/pages/account/create_account_page.dart';
import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../provider/theme_provider.dart';

class PasswordInputWidget extends StatefulWidget {
  final String? title;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final int maxLength;

  const PasswordInputWidget({super.key, this.title, this.selectedColor, this.unSelectedColor, this.maxLength = 6});


  static Future<String?> show(BuildContext context, {String? title, Color? selectedColor, Color? unSelectedColor, int maxLength = 6}) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PasswordInputWidget(
          title: title,
          selectedColor: selectedColor,
          unSelectedColor: unSelectedColor,
          maxLength: maxLength,
        );
      }
    );
  }


  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {

  String _pwd = "";

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
            child: Text(widget.title ?? myListenS(context).inputPassword1, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: theme.textColor),).center(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < widget.maxLength; i++)
                _itemWidget(i).addPadding(const EdgeInsets.symmetric(horizontal: 6)),
            ],
          ),
          const SizedBox(height: 40,),
          _keyboardWidget(),
          Container(
            height: MediaQuery.of(context).padding.bottom,
            color: theme.white,
          ),
        ]
      )
    );
  }


  Widget _itemWidget(int index) {
    final theme = myListenTheme(context);
    const double W = 36;
    if (index < _pwd.length) {
      return Container(
        width: W,
        height: W,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: widget.selectedColor ?? theme.black, width: 1),
        ),

        child: _getDotsWidget(color: widget.selectedColor).center(),
      );
    }

    if (index == _pwd.length) {
      return Container(
        width: W,
        height: W,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: widget.selectedColor ?? theme.black, width: 1),
        ),
      );
    }

    return Container(
      width: W,
      height: W,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: widget.unSelectedColor ?? theme.grey, width: 1),
      ),
    );

  }

  // 圆点
  Widget _getDotsWidget({Color? color}) {
    final theme = myListenTheme(context);
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color ?? theme.black,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }



  Widget _keyboardWidget() {
    return Column(
        children: [
          Row(
            children: [
              for (int i = 1; i <= 3; i++)
                _keyboardItemWidget(text: "$i").expanded(),
            ],
          ),
          // “4” “5” “6”
          Row(
            children: [
              for (int i = 4; i <= 6; i++)
                _keyboardItemWidget(text: "$i").expanded(),
            ],
          ),
          // “7” “8” “9”
          Row(
            children: [
              for (int i = 7; i <= 9; i++)
                _keyboardItemWidget(text: "$i").expanded(),
            ],
          ),
          // “.” “0” “删除”
          Row(
            children: [
              _keyboardItemWidget(text: "0").expanded(flex: 2),
              _keyboardItemWidget(isDelete: true).expanded(),
            ],
          )
        ]
    );
  }

  Widget _keyboardItemWidget({String text = "", bool isDelete = false}) {
    final theme = myListenTheme(context);
    const double H = 60;

    if (isDelete) {
      return Container(
        height: H,
        decoration: BoxDecoration(
          color: theme.white,
          boxShadow: [
            BoxShadow(
              color: theme.black.withOpacity(theme.id == "dark" ? 1 : 0.6),
              offset: Offset(3, 3),
              blurRadius: 5,
              spreadRadius: -1, // 负值实现内部阴影
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: IOSClickEffectCell(
            onTap: () {
              if (_pwd.isNotEmpty) {
                setState(() {
                  _pwd = _pwd.substring(0, _pwd.length - 1);
                });
              }
            },
            child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Icon(CupertinoIcons.delete_left_fill, color: theme.textColor, size: 24)),
          ),
        ),
      );
    }

    return Container(
      height: H,
      decoration: BoxDecoration(
        color: text.isNotEmpty ? theme.white : theme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.black.withOpacity(theme.id == "dark" ? 1 : 0.6),
            offset: Offset(3, 3),
            blurRadius: 5,
            spreadRadius: -1, // 负值实现内部阴影
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // 可以设置为透明，以免覆盖背景
        child: IOSClickEffectCell(
          onTap: (){
            setState(() {
              _pwd += text;
            });
            if (_pwd.length == widget.maxLength) {
              Navigator.pop(context, _pwd);
            }
          },
          child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Text(text, style: TextStyle(color: theme.textColor, fontSize: 24, fontWeight: FontWeight.w600)).center()),
        ),
      ),
    );
  }


}

class IOSClickEffectCell extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration duration; // 动画时长
  final Color? splashColor; // 波纹颜色
  final double scaleFactor; // 缩放因子

  IOSClickEffectCell({
    required this.child,
    required this.onTap,
    this.duration = const Duration(milliseconds: 50),
    this.splashColor,
    this.scaleFactor = 0.96, // 默认缩小为 96%
  });

  @override
  _IOSClickEffectCellState createState() => _IOSClickEffectCellState();
}

class _IOSClickEffectCellState extends State<IOSClickEffectCell> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleFactor).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent, // 使 Material 背景透明
          child: InkWell(
            onTap: widget.onTap,
            splashColor: widget.splashColor ?? Colors.grey.withOpacity(0.3), // 波纹的颜色和透明度
            highlightColor: widget.splashColor ?? Colors.grey.withOpacity(0.2), // 高亮颜色
            child: Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withOpacity(0.1),
              //       blurRadius: 6,
              //       offset: Offset(0, 2), // 轻微的阴影
              //     ),
              //   ],
              // ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}