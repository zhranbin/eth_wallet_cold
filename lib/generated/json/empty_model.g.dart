import 'package:eth_wallet/generated/json/base/json_convert_content.dart';
import 'package:eth_wallet/model/empty_model.dart';

EmptyModel $EmptyModelFromJson(Map<String, dynamic> json) {
  final EmptyModel emptyModel = EmptyModel();
  return emptyModel;
}

Map<String, dynamic> $EmptyModelToJson(EmptyModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  return data;
}

extension EmptyModelExtension on EmptyModel {
}