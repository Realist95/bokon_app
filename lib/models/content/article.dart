import 'dart:convert';
import 'dart:ffi';

List<ArticleModel> articlesModelFromJson(String str) => List<ArticleModel>.from(
    json.decode(str).map((x) => ArticleModel.fromJson(x)));
String articlesModelToJson(List<ArticleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

ResponseArticlesModel responseArticlesModelFromJson(String str) {
  return ResponseArticlesModel.fromJson(json.decode(str));
}

class ArticleModel {
  final int id;
  final String name;
  final String ctype;
  // final String image;
  final String content;
  final String date;
  final bool isSpecial;
  final String description;

  ArticleModel({
    required this.id,
    required this.name,
    required this.ctype,
    required this.date,
    // required this.image,
    required this.content,
    required this.isSpecial,
    required this.description,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
        id: int.parse(json['id'] as String),
        name: json['name'] as String,
        ctype: json['ctype'].toString(),
        content: json['content'] as String,
        date: json['date'] as String,
        isSpecial: json['is_special'] as bool,
        description: (json['description'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
        "ctype": ctype,
        "content": content,
        "date": date,
        "is_special": isSpecial,
        "description": description,
      };
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
