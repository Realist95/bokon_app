import 'dart:convert';

import 'package:bokon_app/models/profile/user_model.dart';

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

ResponseLoginModel responseLoginModelFromJson(Map<String, dynamic> map) {
  return ResponseLoginModel.fromJson(map);
}

class LoginModel {
  final String phone;
  final String code;

  LoginModel({
    required this.phone,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
        "phone": phone.toString(),
        "code": code.toString(),
      };

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        phone: json['phone'] ?? '',
        code: json['code'] ?? '',
      );
}

class ResponseLoginModel {
  final bool success;
  final List errors;
  final String html;
  final ProfileUserModel? userData;

  ResponseLoginModel({
    required this.success,
    required this.errors,
    required this.html,
    required this.userData,
  });

  factory ResponseLoginModel.fromJson(Map<String, dynamic> json) =>
      ResponseLoginModel(
        success: json['success'] ?? false,
        errors: json['errors'] ?? [],
        html: json['html'] ?? '',
        userData: ProfileUserModel.fromJson(json['user_data'] ?? {}),
      );
}
