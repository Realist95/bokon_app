import 'dart:convert';

List<ArticleModel> categoriesModelFromJson(String str) =>
    List<ArticleModel>.from(
        json.decode(str).map((x) => ArticleModel.fromJson(x)));
String categoriesModelToJson(List<ArticleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

ResponseArticlesModel responseArticlesModelFromJson(String str) {
  return ResponseArticlesModel.fromJson(json.decode(str));
}

class ArticleModel {
  final int id;
  final String name;
  // final String image;
  final String content;
  final String description;

  ArticleModel({
    required this.id,
    required this.name,
    // required this.image,
    required this.content,
    required this.description,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
        id: int.parse(json['id']),
        name: json['name'] as String,
        content: json['content'] as String,
        description: (json['description'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class ResponseArticlesModel {
  final List<ArticleModel> items;
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;

  ResponseArticlesModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
  });

  factory ResponseArticlesModel.fromJson(Map<String, dynamic> json) =>
      ResponseArticlesModel(
        items: List<ArticleModel>.from(
            (json['items'] ?? []).map((x) => ArticleModel.fromJson(x))),
        // items: categoriesModelFromJson(json['items'] ?? []),
        page: json['paging']['page'] ?? 0,
        limit: json['paging']['limit'] ?? 0,
        totalItems: json['paging']['totalItems'] ?? 0,
        totalPages: json['paging']['totalPages'] ?? 0,
      );
}
