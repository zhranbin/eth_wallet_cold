import 'package:eth_wallet/provider/language_provider.dart';
import 'package:eth_wallet/provider/theme_provider.dart';
import 'package:eth_wallet/utils/account/byte.dart';
import 'package:eth_wallet/utils/extensions/string_extensions.dart';
import 'package:eth_wallet/utils/extensions/widget_extensions.dart';
import 'package:eth_wallet/utils/my_loading.dart';
import 'package:eth_wallet/widget/my_app_bar.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter/cupertino.dart';
import 'package:web3dart/credentials.dart';


import '../../main.dart';
import '../../provider/account_provider.dart';
import '../../utils/Isolate_utils.dart';
import '../../utils/account/account_model.dart';
import '../../utils/my_shared_preferences.dart';
import '../../widget/my_button.dart';

class BeautifulAccountPage extends StatefulWidget {
  const BeautifulAccountPage({super.key});

  @override
  State<BeautifulAccountPage> createState() => _BeautifulAccountPageState();
}

class _BeautifulAccountPageState extends State<BeautifulAccountPage> with WidgetsBindingObserver {

  /// 底部高度(用于控制“创建按钮”到底部的距离，避免键盘弹出时，底部按钮距离键盘太远)
  double _bottomHeight = 10;

  bool _isLoading = false;
  bool _isNeedCreate = false;
  List<String> _addresses = [];

  @override
  void initState() {
    super.initState();
    _bottomHeight = MediaQuery.of(MyApp.context).padding.bottom + 10;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // 移除键盘状态监听器
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      appBar: MyAppBar(title: myListenS(context).beautifulAccount,),
      body: Column(
        children: [
          ListView(
            children: [
              Text(_isLoading ? myListenS(context).loading : ""),
              ..._addresses.map((e) => Text(e)),
            ],
          ).expanded(),
          MyButton.colorButton(
              color: theme.primaryColor,
              text: _isLoading ? myListenS(context).stop : myListenS(context).start,
              onPressed: () async {
                setState(() {
                  _isLoading = !_isLoading;
                });
                _isNeedCreate = _isLoading;
                if (_isNeedCreate) {
                  _start();
                }
              }).margin(const EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: _bottomHeight),
        ],
      ),
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      setState(() {
        _bottomHeight = 10;
      });
    } else {
      setState(() {
        _bottomHeight = MediaQuery.of(context).padding.bottom + 10;
      });
    }
  }



  _start() async {
    if (!_isNeedCreate) {
      return;
    }
    final result = await runInIsolate<AccountModel?>((){
      // 生成随机的助记词
      String mnemonic = bip39.generateMnemonic(strength: 256);
      // 将助记词转换为种子
      Uint8List seed = bip39.mnemonicToSeed(mnemonic);
      // 从种子生成根私钥
      bip32.BIP32 root = bip32.BIP32.fromSeed(seed);
      // 这里的路径可以根据需要进行调整
      bip32.BIP32 child = root.derivePath("m/44'/60'/0'/0/0");
      // 获取子私钥的字节数组
      Uint8List privateKeyBytes = child.privateKey ?? Uint8List(0);
      // 将字节数组转换为十六进制字符串表示私钥
      String privateKeyHex = privateKeyBytes.toHexString();
      EthPrivateKey privateKey = EthPrivateKey.fromHex(privateKeyHex);
      final address = privateKey.address;
      // 如果address 以 0x 开头，则去掉
      String addressStr = address.hex.startsWith("0x") ? address.hex.substring(2) : address.hex;
      print("${addressStr}");
      // 如果addressStr 以‘111’，‘222’，‘333’开头或接结尾就保留
      if (addressStr.startsWith("11111") ||
          addressStr.startsWith("22222") ||
          addressStr.startsWith("33333") ||
          addressStr.startsWith("44444") ||
          addressStr.startsWith("55555") ||
          addressStr.startsWith("66666") ||
          addressStr.startsWith("77777") ||
          addressStr.startsWith("88888") ||
          addressStr.startsWith("99999") ||
          addressStr.startsWith("00000") ||
          addressStr.startsWith("12345") ||
          addressStr.startsWith("23456") ||
          addressStr.startsWith("34567") ||
          addressStr.startsWith("45678") ||
          addressStr.startsWith("56789") ||
          addressStr.startsWith("67890") ||
          addressStr.startsWith("aaaaa") ||
          addressStr.startsWith("bbbbb") ||
          addressStr.startsWith("ccccc") ||
          addressStr.startsWith("ddddd") ||
          addressStr.startsWith("eeeee") ||
          addressStr.startsWith("fffff") ||
          addressStr.endsWith("11111") ||
          addressStr.endsWith("22222") ||
          addressStr.endsWith("33333") ||
          addressStr.endsWith("44444") ||
          addressStr.endsWith("55555") ||
          addressStr.endsWith("66666") ||
          addressStr.endsWith("77777") ||
          addressStr.endsWith("88888") ||
          addressStr.endsWith("99999") ||
          addressStr.endsWith("00000") ||
          addressStr.endsWith("12345") ||
          addressStr.endsWith("23456") ||
          addressStr.endsWith("34567") ||
          addressStr.endsWith("45678") ||
          addressStr.endsWith("56789") ||
          addressStr.endsWith("67890") ||
          addressStr.endsWith("aaaaa") ||
          addressStr.endsWith("bbbbb") ||
          addressStr.endsWith("ccccc") ||
          addressStr.endsWith("ddddd") ||
          addressStr.endsWith("eeeee") ||
          addressStr.endsWith("fffff") ) {
        print("--------- ${addressStr} ------------");
        final wallet = Wallet.createNew(privateKey, '123456', Random.secure());
        final walletJson = wallet.toJson();
        AccountModel account = AccountModel(
          name: "靓号 123456",
          address: privateKey.address.hex,
          mnemonic: mnemonic,
          keystore: walletJson,
          isDefault: false,
        );
        return account;
      }
      return null;
    },);
    if (result != null) {
      await AccountProvider.addAccount(result);
      setState(() {
        _addresses.add(result.address);
      });
    }
    _start();
  }


  Future<AccountModel?> createAction() async {
    // 生成随机的助记词
    String mnemonic = bip39.generateMnemonic(strength: 256);
    // 将助记词转换为种子
    Uint8List seed = bip39.mnemonicToSeed(mnemonic);
    // 从种子生成根私钥
    bip32.BIP32 root = bip32.BIP32.fromSeed(seed);
    // 这里的路径可以根据需要进行调整
    bip32.BIP32 child = root.derivePath("m/44'/60'/0'/0/0");
    // 获取子私钥的字节数组
    Uint8List privateKeyBytes = child.privateKey ?? Uint8List(0);
    // 将字节数组转换为十六进制字符串表示私钥
    String privateKeyHex = privateKeyBytes.toHexString();
    EthPrivateKey privateKey = EthPrivateKey.fromHex(privateKeyHex);
    final address = privateKey.address;
    // 如果address 以 0x 开头，则去掉
    String addressStr = address.hex.startsWith("0x") ? address.hex.substring(2) : address.hex;
    // print("${addressStr}");
    // 如果addressStr 以‘111’，‘222’，‘333’开头或接结尾就保留
    if (addressStr.startsWith("11111") ||
        addressStr.startsWith("22222") ||
        addressStr.startsWith("33333") ||
        addressStr.startsWith("44444") ||
        addressStr.startsWith("55555") ||
        addressStr.startsWith("66666") ||
        addressStr.startsWith("77777") ||
        addressStr.startsWith("88888") ||
        addressStr.startsWith("99999") ||
        addressStr.startsWith("00000") ||
        addressStr.startsWith("12345") ||
        addressStr.startsWith("23456") ||
        addressStr.startsWith("34567") ||
        addressStr.startsWith("45678") ||
        addressStr.startsWith("56789") ||
        addressStr.startsWith("67890") ||
        addressStr.startsWith("aaaaa") ||
        addressStr.startsWith("bbbbb") ||
        addressStr.startsWith("ccccc") ||
        addressStr.startsWith("ddddd") ||
        addressStr.startsWith("eeeee") ||
        addressStr.startsWith("fffff") ||
        addressStr.endsWith("11111") ||
        addressStr.endsWith("22222") ||
        addressStr.endsWith("33333") ||
        addressStr.endsWith("44444") ||
        addressStr.endsWith("55555") ||
        addressStr.endsWith("66666") ||
        addressStr.endsWith("77777") ||
        addressStr.endsWith("88888") ||
        addressStr.endsWith("99999") ||
        addressStr.endsWith("00000") ||
        addressStr.endsWith("12345") ||
        addressStr.endsWith("23456") ||
        addressStr.endsWith("34567") ||
        addressStr.endsWith("45678") ||
        addressStr.endsWith("56789") ||
        addressStr.endsWith("67890") ||
        addressStr.endsWith("aaaaa") ||
        addressStr.endsWith("bbbbb") ||
        addressStr.endsWith("ccccc") ||
        addressStr.endsWith("ddddd") ||
        addressStr.endsWith("eeeee") ||
        addressStr.endsWith("fffff") ) {
      print("--------- ${addressStr} ------------");
      var pwd = await MySharedPreferences.getWalletPassword() ?? '';
      final wallet = Wallet.createNew(privateKey, pwd, Random.secure());
      final walletJson = wallet.toJson();
      AccountModel account = AccountModel(
        name: "靓号 $addressStr",
        address: privateKey.address.hex,
        mnemonic: mnemonic,
        keystore: walletJson,
        isEncryption: true,
      );
      return account;
    }
    return null;
  }


}
