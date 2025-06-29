import 'package:hive_ce/hive.dart';

class ProfileUserModel extends HiveObject {
  final int id;
  final String name;
  final String phone;

  ProfileUserModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) =>
      ProfileUserModel(
        id: (json['id'] ?? 0) as int,
        name: (json['name'] ?? '') as String,
        phone: (json['image'] ?? '') as String,
      );
}
