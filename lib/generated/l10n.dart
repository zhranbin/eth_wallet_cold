// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ethereum Wallet`
  String get appName {
    return Intl.message(
      'Ethereum Wallet',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Current wallet: `
  String get currentWallet {
    return Intl.message(
      'Current wallet: ',
      name: 'currentWallet',
      desc: '',
      args: [],
    );
  }

  /// `No account`
  String get noAccount {
    return Intl.message(
      'No account',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get createAccount {
    return Intl.message(
      'Create account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Import account`
  String get importAccount {
    return Intl.message(
      'Import account',
      name: 'importAccount',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Private key`
  String get privateKey {
    return Intl.message(
      'Private key',
      name: 'privateKey',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic`
  String get mnemonic {
    return Intl.message(
      'Mnemonic',
      name: 'mnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Account name`
  String get nameTip {
    return Intl.message(
      'Account name',
      name: 'nameTip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name`
  String get inputName {
    return Intl.message(
      'Please enter a name',
      name: 'inputName',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `After encryption, the account will be encrypted separately using a password. Unencrypted accounts will be encrypted using wallet passwords`
  String get encryptionTip {
    return Intl.message(
      'After encryption, the account will be encrypted separately using a password. Unencrypted accounts will be encrypted using wallet passwords',
      name: 'encryptionTip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the password`
  String get inputPassword {
    return Intl.message(
      'Please enter the password',
      name: 'inputPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get inputPassword1 {
    return Intl.message(
      'Enter password',
      name: 'inputPassword1',
      desc: '',
      args: [],
    );
  }

  /// `Set password`
  String get setPassword {
    return Intl.message(
      'Set password',
      name: 'setPassword',
      desc: '',
      args: [],
    );
  }

  /// `Encrypt`
  String get isEncryption {
    return Intl.message(
      'Encrypt',
      name: 'isEncryption',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create account`
  String get createAccountFail {
    return Intl.message(
      'Failed to create account',
      name: 'createAccountFail',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Encryption`
  String get encryption {
    return Intl.message(
      'Encryption',
      name: 'encryption',
      desc: '',
      args: [],
    );
  }

  /// `Unencrypted`
  String get noEncryption {
    return Intl.message(
      'Unencrypted',
      name: 'noEncryption',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get deleteAccount {
    return Intl.message(
      'Delete account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this account?`
  String get deleteAccountTip {
    return Intl.message(
      'Are you sure you want to delete this account?',
      name: 'deleteAccountTip',
      desc: '',
      args: [],
    );
  }

  /// `Copy to clipboard`
  String get copyToClipboardSuccess {
    return Intl.message(
      'Copy to clipboard',
      name: 'copyToClipboardSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Copy address`
  String get copyAddress {
    return Intl.message(
      'Copy address',
      name: 'copyAddress',
      desc: '',
      args: [],
    );
  }

  /// `QR code`
  String get qrcode {
    return Intl.message(
      'QR code',
      name: 'qrcode',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get accountInfo {
    return Intl.message(
      'Information',
      name: 'accountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Long press copy`
  String get longTapCopy {
    return Intl.message(
      'Long press copy',
      name: 'longTapCopy',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the password for this account`
  String get inputAccountPassword {
    return Intl.message(
      'Please enter the password for this account',
      name: 'inputAccountPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your wallet password`
  String get inputWalletPassword {
    return Intl.message(
      'Please enter your wallet password',
      name: 'inputWalletPassword',
      desc: '',
      args: [],
    );
  }

  /// `Validation failed`
  String get verificationFail {
    return Intl.message(
      'Validation failed',
      name: 'verificationFail',
      desc: '',
      args: [],
    );
  }

  /// `Add account`
  String get addAccount {
    return Intl.message(
      'Add account',
      name: 'addAccount',
      desc: '',
      args: [],
    );
  }

  /// `Private key`
  String get privateKeyTip {
    return Intl.message(
      'Private key',
      name: 'privateKeyTip',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic`
  String get mnemonicTip {
    return Intl.message(
      'Mnemonic',
      name: 'mnemonicTip',
      desc: '',
      args: [],
    );
  }

  /// `Import private key`
  String get importPrivateKey {
    return Intl.message(
      'Import private key',
      name: 'importPrivateKey',
      desc: '',
      args: [],
    );
  }

  /// `Import mnemonic`
  String get importMnemonic {
    return Intl.message(
      'Import mnemonic',
      name: 'importMnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Import Keystore`
  String get importKeystore {
    return Intl.message(
      'Import Keystore',
      name: 'importKeystore',
      desc: '',
      args: [],
    );
  }

  /// `The encrypted account password is the encrypted password for the account, and the unencrypted account password is the wallet account.`
  String get keystorePasswordTip {
    return Intl.message(
      'The encrypted account password is the encrypted password for the account, and the unencrypted account password is the wallet account.',
      name: 'keystorePasswordTip',
      desc: '',
      args: [],
    );
  }

  /// `Change the password`
  String get changePassword {
    return Intl.message(
      'Change the password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter original password`
  String get changePasswordTip {
    return Intl.message(
      'Please enter original password',
      name: 'changePasswordTip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new password`
  String get changePasswordTip1 {
    return Intl.message(
      'Please enter a new password',
      name: 'changePasswordTip1',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm the new password`
  String get changePasswordTip2 {
    return Intl.message(
      'Please confirm the new password',
      name: 'changePasswordTip2',
      desc: '',
      args: [],
    );
  }

  /// `The passwords entered twice are inconsistent`
  String get changePasswordTip3 {
    return Intl.message(
      'The passwords entered twice are inconsistent',
      name: 'changePasswordTip3',
      desc: '',
      args: [],
    );
  }

  /// `Password modified successfully`
  String get changePasswordSuccess {
    return Intl.message(
      'Password modified successfully',
      name: 'changePasswordSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to modify password`
  String get changePasswordFail {
    return Intl.message(
      'Failed to modify password',
      name: 'changePasswordFail',
      desc: '',
      args: [],
    );
  }

  /// `cancels the encrypted`
  String get cancelEncrypted {
    return Intl.message(
      'cancels the encrypted',
      name: 'cancelEncrypted',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get oldPassword {
    return Intl.message(
      'Old password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPassword {
    return Intl.message(
      'New password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter keystore`
  String get inputKeystore {
    return Intl.message(
      'Please enter keystore',
      name: 'inputKeystore',
      desc: '',
      args: [],
    );
  }

  /// `Please enter mnemonic`
  String get inputMnemonic {
    return Intl.message(
      'Please enter mnemonic',
      name: 'inputMnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Please enter private key`
  String get inputPrivateKey {
    return Intl.message(
      'Please enter private key',
      name: 'inputPrivateKey',
      desc: '',
      args: [],
    );
  }

  /// `keystore password`
  String get keystorePassword {
    return Intl.message(
      'keystore password',
      name: 'keystorePassword',
      desc: '',
      args: [],
    );
  }

  /// `Keystore import, default to encryption`
  String get keystorePasswordTypeTip {
    return Intl.message(
      'Keystore import, default to encryption',
      name: 'keystorePasswordTypeTip',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Beautiful account`
  String get beautifulAccount {
    return Intl.message(
      'Beautiful account',
      name: 'beautifulAccount',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get stop {
    return Intl.message(
      'Stop',
      name: 'stop',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Password error`
  String get oldPasswordError {
    return Intl.message(
      'Password error',
      name: 'oldPasswordError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
