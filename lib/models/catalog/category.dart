import 'package:hive_ce/hive.dart';

ResponseCategoriesModel responseCategoriesModelFromJson(
    Map<String, dynamic> json) {
  return ResponseCategoriesModel.fromJson(json);
}

class CatalogCategoryModel extends HiveObject {
  final int id;
  final String name;
  final String image;
  final List<CatalogCategoryModel> childrens;
  final String titleH1;
  final int parent;
  final String description;

  CatalogCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.childrens,
    required this.titleH1,
    required this.parent,
    required this.description,
  });

  factory CatalogCategoryModel.fromJson(Map<String, dynamic> json) =>
      CatalogCategoryModel(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        image: json['image'].toString(),
        childrens: List<CatalogCategoryModel>.from((json['childrens'] ?? [])
            .map((x) => CatalogCategoryModel.fromJson(x))),
        titleH1: json['title_h1'] ?? '',
        parent: int.parse(json['parent'].toString()),
        description: json['description'] ?? '',
      );
}

class ResponseCategoriesModel {
  final List<CatalogCategoryModel> items;
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;

  ResponseCategoriesModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
  });

  factory ResponseCategoriesModel.fromJson(Map<String, dynamic> json) =>
      ResponseCategoriesModel(
        items: List<CatalogCategoryModel>.from(
          (json['items'] ?? []).map(
            (x) => CatalogCategoryModel.fromJson(x),
          ),
        ),
        page: json['paging']['page'] ?? 0,
        limit: json['paging']['limit'] ?? 0,
        totalItems: json['paging']['totalItems'] ?? 0,
        totalPages: json['paging']['totalPages'] ?? 0,
      );
}
