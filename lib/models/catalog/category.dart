import 'dart:convert';

List<CategoryModel> categoriesModelFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));
String categoriesModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

ResponseCategoriesModel responseCategoriesModelFromJson(String str) {
  return ResponseCategoriesModel.fromJson(json.decode(str));
}

class CategoryModel {
  final int id;
  final String name;
  final String image;
  final List childrens;
  final String titleH1;
  final int parent;
  final String description;
  final String imageBase64;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.childrens,
    required this.titleH1,
    required this.parent,
    required this.description,
    required this.imageBase64,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        image: json['image'].toString(),
        childrens: List<CategoryModel>.from(
            (json['childrens'] ?? []).map((x) => CategoryModel.fromJson(x))),
        titleH1: json['title_h1'] ?? '',
        parent: int.parse(json['parent'].toString()),
        description: json['description'] ?? '',
        imageBase64: json['image_64'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "childrens": childrens,
        "title_h1": titleH1,
        "description": description,
        "image_64": imageBase64,
        "parent": parent,
      };
}

class ResponseCategoriesModel {
  final List<CategoryModel> items;
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
        items: List<CategoryModel>.from(
            (json['items'] ?? []).map((x) => CategoryModel.fromJson(x))),
        // items: categoriesModelFromJson(json['items'] ?? []),
        page: json['paging']['page'] ?? 0,
        limit: json['paging']['limit'] ?? 0,
        totalItems: json['paging']['totalItems'] ?? 0,
        totalPages: json['paging']['totalPages'] ?? 0,
      );
}
