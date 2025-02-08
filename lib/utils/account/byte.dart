import 'dart:typed_data';

Uint8List hexStringToBytes(String hexString) {
  int len = hexString.length;
  var bytes = Uint8List(len ~/ 2);
  for (int i = 0; i < len; i += 2) {
    bytes[i ~/ 2] = int.parse(hexString.substring(i, i + 2), radix: 16);
  }
  return bytes;
}

String bytesToHexString(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
}

extension StringByteExtension on String {
  Uint8List toBytes() {
    return hexStringToBytes(this);
  }
}

extension Uint8ListExtension on Uint8List {
  String toHexString() {
    return bytesToHexString(this);
  }
}