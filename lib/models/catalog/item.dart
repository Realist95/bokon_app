import 'dart:convert';
import 'package:bokon_app/models/catalog/category.dart';

List<CatalogItemModel> catalogItemsModelFromJson(String str) =>
    List<CatalogItemModel>.from(
        json.decode(str).map((x) => CatalogItemModel.fromJson(x)));
String itemsModelToJson(List<CatalogItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

ResponseItemsModel responseItemsModelFromJson(String str) {
  return ResponseItemsModel.fromJson(json.decode(str));
}

class CatalogItemModel {
  final int id;
  final String name;
  final int maingroup;
  final String content;
  final String description;
  final String difficulty;
  final CategoryModel? parent;

  CatalogItemModel({
    required this.id,
    required this.name,
    required this.maingroup,
    required this.content,
    required this.description,
    required this.difficulty,
    required this.parent,
  });

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) =>
      CatalogItemModel(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        maingroup: int.parse(json['maingroup'].toString()),
        content: json['content'].toString(),
        description: json['description'].toString(),
        difficulty: json['difficulty'].toString(),
        parent: CategoryModel.fromJson(json['parent'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "maingroup": maingroup,
        "content": content,
        "description": description,
        "difficulty": difficulty,
        "parent": parent?.toJson(),
      };
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
