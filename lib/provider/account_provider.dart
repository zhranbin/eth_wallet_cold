import 'package:eth_wallet/utils/account/account_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../utils/account/account_model.dart';

class AccountProvider extends ChangeNotifier {

  AccountModel _currentAccount  = AccountModel();
  AccountModel get currentAccount => _currentAccount;

  List<AccountModel> _accountList = [];
  List<AccountModel> get accountList => _accountList;



  // 初始化数据
  static Future<void> initData() async {
    final provider = Provider.of<AccountProvider>(MyApp.context, listen: false);
    await provider.refresh();
  }

  Future<void> refresh() async {
    _accountList = await AccountManager.getAccounts();
    if (_accountList.isNotEmpty) {
      final defaultAccount = await AccountManager.getDefaultAccount();
      if (defaultAccount != null) {
        _currentAccount = defaultAccount;
      } else {
        _currentAccount = _accountList.first;
      }
    }
    notifyListeners();
  }

  // 设置当前账户
  static Future<void>setCurrentAccount(AccountModel account) async {
    final provider = Provider.of<AccountProvider>(MyApp.context, listen: false);
    provider._currentAccount = account;
    await AccountManager.setDefaultAccount(account.address);
    await provider.refresh();
  }

  // 添加账户
  static Future<void> addAccount(AccountModel account) async {
    final provider = Provider.of<AccountProvider>(MyApp.context, listen: false);
    await AccountManager.addAccount(account);
    await provider.refresh();
  }

  // 删除账户
  static Future<void> deleteAccount(String address) async {
    final provider = Provider.of<AccountProvider>(MyApp.context, listen: false);
    await AccountManager.deleteAccount(address);
    await provider.refresh();
  }

  // 更新账户
  static Future<void> updateAccount(AccountModel account) async {
    final provider = Provider.of<AccountProvider>(MyApp.context, listen: false);
    await AccountManager.updateAccount(account);
    await provider.refresh();
  }


}
