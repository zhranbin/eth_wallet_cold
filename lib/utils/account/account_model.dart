

import 'package:flutter/material.dart';

class AccountModel {
  String name = '';
  String address = '';
  String keystore = '';
  String privateKey = '';
  String mnemonic = '';
  bool isDefault = false;
  bool isEncryption = false;

  AccountModel({
    this.name = '',
    this.address = '',
    this.keystore = '',
    this.privateKey = '',
    this.mnemonic = '',
    this.isDefault = false,
    this.isEncryption = false,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      name: json['name'],
      address: json['address'],
      keystore: json['keystore'],
      privateKey: json['privateKey'],
      mnemonic: json['mnemonic'],
      isDefault: json['isDefault'] == 1 ? true : false,
      isEncryption: json['isEncryption'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'keystore': keystore,
      'privateKey': privateKey,
      'mnemonic': mnemonic,
      'isDefault': isDefault ? 1 : 0,
      'isEncryption': isEncryption ? 1 : 0,
    };
  }
}

extension AccountModelExtension on AccountModel {

  String get addressString {
    // 截取地址的前6位和后6位中间用...,不足12位，获取全部
    return address.length > 14
        ? "${address.substring(0, 8)}...${address.substring(address.length - 6)}"
        : address;
  }

  String get avatar {
    try {
      final num = int.parse(_getAvatarNumStr(address), radix: 16)%40 + 1;
      return "assets/images/avatar/avatar${num}.png";
    } catch (e) {
      print(e);
    }
    return "assets/images/common/logo.png";
  }


  Widget getAvatarImage({double size = 40, double radius = 6}) {
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: getAvatarColor(),
        // 圆角
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Image.asset(
        avatar,
        fit: BoxFit.cover,
      ),
    );
  }

  Color getAvatarColor() {
    String numStr = "";
    if (address.isEmpty) numStr = "000000";
    var value = address.replaceFirst(RegExp(r'^0x'), '');
    if (value.length < 6) {
      // 如果长度小于6，则用0补足
      while (value.length < 6) {
        value = '0' + value;
      }
    }
    // 获取前6位
    numStr = value.substring(0, 6);
    return Color(int.parse("0xFF$numStr")).withOpacity(0.2);
  }


  String _getAvatarNumStr(String input) {
    // 确保字符串不为空
    if (input.isEmpty) return '00';
    // 获取字符串长度
    int length = input.length;
    // 计算需要截取的起始位置
    int start = length > 7 ? length - 7 : 0;
    int end = length > 8 ? length - 6 : 1;
    // 截取字符串
    String result = input.substring(start, end);
    // 如果结果不足两位，则用0补足
    while (result.length < 2) {
      result = '0' + result;
    }
    return result;
  }
}
