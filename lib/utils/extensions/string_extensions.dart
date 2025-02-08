import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

extension StringToMD5String on String {
  String get generateMD5 {
    final Uint8List content = const Utf8Encoder().convert(this);
    final digest = md5.convert(content);
    return digest.toString();
  }

  String get MD5 {
    final Uint8List content = const Utf8Encoder().convert(this);
    final digest = md5.convert(content);
    return digest.toString();
  }

}

extension UrlParametersString on String? {
  String queryParametersOf(String key) {
    if (this?.isNotEmpty == true) {
      try {
        final uri = Uri.parse(this!);
        final queryParameters = uri.queryParameters;
        String value = queryParameters[key] ?? '';
        if (value.isEmpty) {
          // 解决 url 包含 # 号的特殊情况
          final fragment = uri.fragment;
          if (fragment.isNotEmpty) {
            value = fragment.queryParametersOf(key);
          }
        }
        return value;
      } catch (e) {
        print('queryParametersOf key = $key error: $e');
        return '';
      }
    }
    return '';
  }

  Map<String, String>? queryParameters() {
    if (this?.isNotEmpty == true) {
      try {
        final uri = Uri.parse(this!);
        return uri.queryParameters;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String queryUriPath() {
    if (this?.isNotEmpty == true) {
      try {
        if (!this!.startsWith('kangxun://')) return '';
        final uri = Uri.parse(this!);
        return uri.path;
      } catch (e) {
        return '';
      }
    }
    return '';
  }
}


extension JsonString on String? {
  Map<String, dynamic>? get toJson {
    if (this == null) {
      return null;
    }
    try {
      return json.decode(this!);
    } catch (e) {
      return null;
    }
  }
}
