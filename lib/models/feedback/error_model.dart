import 'dart:convert';

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

ResponseErrorModel responseErrorModelFromJson(String str) {
  return ResponseErrorModel.fromJson(json.decode(str));
}

class ErrorModel {
  final String block;
  final String errorNumber;
  final String generation;
  final String name;
  final String phone;
  final String message;

  ErrorModel({
    required this.block,
    required this.errorNumber,
    required this.generation,
    required this.phone,
    required this.message,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        "block": block,
        "errorNumber": errorNumber,
        "generation": generation,
        "userName": name,
        "userPhone": phone,
        "message": message,
        "isjson": "1",
      };

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        block: json['block'] ?? '',
        errorNumber: json['errorNumber'] ?? '',
        generation: json['generation'] ?? '',
        name: json['userName'] ?? '',
        phone: json['userPhone'] ?? '',
        message: json['message'] ?? '',
      );
}

class ResponseErrorModel {
  final bool success;
  final List errors;
  final String html;

  ResponseErrorModel({
    required this.success,
    required this.errors,
    required this.html,
  });

  factory ResponseErrorModel.fromJson(Map<String, dynamic> json) =>
      ResponseErrorModel(
        success: json['success'] ?? false,
        errors: json['errors'] ?? [],
        html: json['html'] ?? '',
      );
}
