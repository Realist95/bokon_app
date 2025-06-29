ResponseArticlesModel responseCtypesModelFromJson(Map<String, dynamic> json) {
  return ResponseArticlesModel.fromJson(json);
}

class CtypeModel {
  final int id;
  final String name;
  final String content;
  final String description;

  CtypeModel({
    required this.id,
    required this.name,
    required this.content,
    required this.description,
  });

  factory CtypeModel.fromJson(Map<String, dynamic> json) => CtypeModel(
        id: json['id'] as int,
        name: json['name'] as String,
        content: (json['content'] ?? '') as String,
        description: (json['description'] ?? '') as String,
      );
}

class ResponseArticlesModel {
  final List<CtypeModel> items;
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
        items: List<CtypeModel>.from(
            (json['items'] ?? []).map((x) => CtypeModel.fromJson(x))),
        // items: categoriesModelFromJson(json['items'] ?? []),
        page: json['paging']['page'] ?? 0,
        limit: json['paging']['limit'] ?? 0,
        totalItems: json['paging']['totalItems'] ?? 0,
        totalPages: json['paging']['totalPages'] ?? 0,
      );
}
