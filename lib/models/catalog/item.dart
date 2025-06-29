import 'package:hive_ce/hive.dart';

ResponseItemsModel responseItemsModelFromJson(Map<String, dynamic> json) {
  return ResponseItemsModel.fromJson(json);
}

class CatalogItemModel extends HiveObject {
  int id;
  String name;
  int maingroup;
  String content;
  String description;
  String difficulty;

  CatalogItemModel({
    required this.id,
    required this.name,
    required this.maingroup,
    required this.content,
    required this.description,
    required this.difficulty,
  });

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) =>
      CatalogItemModel(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        maingroup: int.parse(json['maingroup'].toString()),
        content: json['content'].toString(),
        description: json['description'].toString(),
        difficulty: json['difficulty'].toString(),
      );
}

class ResponseItemsModel {
  final List<CatalogItemModel> items;
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;

  ResponseItemsModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
  });

  factory ResponseItemsModel.fromJson(Map<String, dynamic> json) {
    return ResponseItemsModel(
      items: List<CatalogItemModel>.from(
          (json['items'] ?? []).map((x) => CatalogItemModel.fromJson(x))),
      page: json['paging']['page'] ?? 0,
      limit: json['paging']['limit'] ?? 0,
      totalItems: json['paging']['totalItems'] ?? 0,
      totalPages: json['paging']['totalPages'] ?? 0,
    );
  }
}
