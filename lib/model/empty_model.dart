import 'package:eth_wallet/generated/json/base/json_field.dart';
import 'package:eth_wallet/generated/json/empty_model.g.dart';
import 'dart:convert';
export 'package:eth_wallet/generated/json/empty_model.g.dart';

@JsonSerializable()
class EmptyModel {


	EmptyModel();

	factory EmptyModel.fromJson(Map<String, dynamic> json) => $EmptyModelFromJson(json);

	Map<String, dynamic> toJson() => $EmptyModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}