import 'package:hive_ce/hive.dart';

ResponseArticlesModel responseArticlesModelFromJson(Map<String, dynamic> json) {
  return ResponseArticlesModel.fromJson(json);
}

class ArticleModel extends HiveObject {
  final int id;
  final String name;
  final int ctype;
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
        id: json['id'] as int,
        name: json['name'] as String,
        ctype: json['ctype'] as int,
        content: json['content'] as String,
        date: json['date'] as String,
        isSpecial: json['is_special'] as bool,
        description: (json['description'] ?? '') as String,
      );
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
          (json['items'] ?? []).map(
            (x) => ArticleModel.fromJson(x),
          ),
        ),
        page: json['paging']['page'] ?? 0,
        limit: json['paging']['limit'] ?? 0,
        totalItems: json['paging']['totalItems'] ?? 0,
        totalPages: json['paging']['totalPages'] ?? 0,
      );
}
