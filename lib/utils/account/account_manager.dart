import 'dart:math';
import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter/cupertino.dart';
import 'package:web3dart/credentials.dart';
import '../Isolate_utils.dart';
import '../db/db_helper.dart';
import 'account_model.dart';
import 'byte.dart';

class AccountManager {


  /// 创建账户
  static AccountModel newAccount({required String name, required String password, int strength = 128}) {
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
    final wallet = Wallet.createNew(privateKey, password, Random.secure());
    final walletJson = wallet.toJson();
    AccountModel account = AccountModel(
      name: name,
      address: privateKey.address.hex,
      mnemonic: mnemonic,
      keystore: walletJson,
      isDefault: false,
    );
    return account;
  }

  // 创建账户
  static Future<AccountModel?> createAccount({required String name, required String password, int strength = 128}) async {
    final result = await runInIsolate<AccountModel>((_){
      return newAccount(name: name, password: password, strength: strength);
    },);
    return result;
  }

  // 通过私钥创建账户
  static Future<AccountModel?> createAccountFromPrivateKey({required String name, required String privateKey, required String password}) async {
    String privateKeyHex = '0x${privateKey.replaceAll('0x', '')}';
    final result = await runInIsolate<AccountModel>((_){
      try {
        final wallet = Wallet.createNew(EthPrivateKey.fromHex(privateKeyHex), password, Random.secure());
        final walletJson = wallet.toJson();
        AccountModel account = AccountModel(
          name: name,
          address: wallet.privateKey.address.hex,
          mnemonic: '',
          keystore: walletJson,
          isDefault: false,
        );
        return account;
      } catch (e) {
        debugPrint('Error while decrypting wallet: $e');
        return null;
      }
     });
    return result;
  }

  // 通过助记词创建账户
  static Future<AccountModel?> createAccountFromMnemonic({required String name, required String mnemonic, required String password}) async {
    final result = await runInIsolate<AccountModel?>((_){
      try {
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
        final wallet = Wallet.createNew(privateKey, password, Random.secure());
        final walletJson = wallet.toJson();
        AccountModel account = AccountModel(
          name: name,
          address: privateKey.address.hex,
          mnemonic: mnemonic,
          keystore: walletJson,
          isDefault: false,
        );
        return account;
      } catch (e) {
        debugPrint('Error while decrypting wallet: $e');
        return null;
      }
    },);
    return result;
  }

  // 通过keystore创建账户
  static Future<AccountModel?> createAccountFromJson({required String name, required String json, required String password}) async {
    final result = await runInIsolate<AccountModel?>((_){
      try {
        final wallet = Wallet.fromJson(json, password);
        return AccountModel(
          name: name,
          address: wallet.privateKey.address.hex,
          mnemonic: '',
          keystore: json,
          isDefault: false,
        );
      }catch (e) {
        debugPrint('Error while decrypting wallet: $e');
        return null;
      }
    },);
    return result;
  }




  static Future<String> getPrivateKey({required String json, required String password}) async {
    final result = await runInIsolate<String>((_){
      try {
        final wallet = Wallet.fromJson(json, password);
        return wallet.privateKey.privateKey.toHexString();
      }catch (e) {
        debugPrint('Error while decrypting wallet: $e');
        return '';
      }
    },);
    return result ?? '';
  }


  static Future<String> changePassword({required String json, required String oldPassword, required String newPassword}) async {
    final result = await runInIsolate<String>((_){
      try {
        final wallet = Wallet.fromJson(json, oldPassword);
        final newWallet = Wallet.createNew(wallet.privateKey, newPassword, Random.secure());
        return newWallet.toJson();
      }catch (e) {
        debugPrint('Error while decrypting wallet: $e');
        return '';
      }
    },);
    return result ?? '';
  }


  static Future<String> getAddress({required String json, required String password}) async {
    final result = await runInIsolate<String>((_){
      try {
        final wallet = Wallet.fromJson(json, password);
        return wallet.privateKey.address.hex;
      }catch (e) {
        debugPrint('Error while decrypting wallet: $e');
        return '';
      }
    },);
    return result ?? '';
  }


  /// 获取账户列表
  static Future<List<AccountModel>> getAccounts() async {
    List<AccountModel> accounts = [];
    List<Map<String, dynamic>> result = await DBHelper.query(accountDbTableName);
    for (var item in result) {
      accounts.add(AccountModel.fromJson(item));
    }
    await DBHelper.close();
    return accounts.reversed.toList();
  }

  /// 添加账户
  static Future<void> addAccount(AccountModel account) async {
    // 判断是否已经存在
    List<Map<String, dynamic>> result = await DBHelper.query(accountDbTableName);
    for (var item in result) {
      if (item['address'] == account.address) {
        return;
      }
    }
    await DBHelper.insert(accountDbTableName, account.toJson());
    return DBHelper.close();
  }

  /// 删除账户
  static Future<void> deleteAccount(String address) async {
    await DBHelper.delete(accountDbTableName, where: 'address = "$address"');
    return DBHelper.close();
  }

  /// 获取默认账户
  static Future<AccountModel?> getDefaultAccount() async {
    List<AccountModel> accounts = await getAccounts();
    for (var account in accounts) {
      if (account.isDefault) {
        return account;
      }
    }
    return null;
  }

  /// 设置默认账户
  static Future<void> setDefaultAccount(String address) async {
    List<AccountModel> accounts = await getAccounts();
    for (var item in accounts) {
      if (item.isDefault && item.address != address) {
        item.isDefault = false;
        await updateAccount(item);
      }
      if (item.address == address) {
        item.isDefault = true;
        await updateAccount(item);
      }
    }
    return DBHelper.close();
  }

  static Future<void> updateAccount(AccountModel account) async {
    await DBHelper.update(accountDbTableName, account.toJson(), where: 'address = "${account.address}"',);
  }

}


class TimeFormatter {
  static String stringFromDate(DateTime date) {
    // 实现时间格式化逻辑
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}

class DateFormatter {
  static String stringFromDate(DateTime date) {
    // 实现日期格式化逻辑
    return "${date.hour}-${date.minute.toString().padLeft(2, '0')}-${date.second.toString().padLeft(2, '0')}";
  }
}