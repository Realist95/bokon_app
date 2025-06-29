import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';
import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/models/content/ctype.dart';
import 'package:bokon_app/models/profile/user_model.dart';
import 'package:bokon_app/services/hive_registrar.g.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveService {
  static const catalogCategoryKey = 'catalog_category';
  static const catalogItemKey = 'catalog_item';
  static const profileUserKey = 'profile_user';
  static const contentArticleKey = 'content_article';
  static const contentTypeKey = 'content_type';

  static initHive() async {
    final appDocDir = await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(appDocDir.path)
      ..registerAdapters();

    await Hive.openBox<CatalogCategoryModel>(catalogCategoryKey);

    await Hive.openBox<CatalogItemModel>(catalogItemKey);

    await Hive.openBox<ArticleModel>(contentArticleKey);

    await Hive.openBox<CtypeModel>(contentTypeKey);

    // информация о пользователе
    await Hive.openBox<ProfileUserModel>(profileUserKey);
  }

  /// Добаляем категории в хайв
  static void addCatalogCategories(
      List<CatalogCategoryModel> catalogCategories) {
    if (catalogCategories.isEmpty) return;
    // очищает старые категории
    deleteCatalogCategories().then((onValue) {
      // добалвяет новые категории
      Hive.box<CatalogCategoryModel>(catalogCategoryKey)
          .addAll(catalogCategories);
    });
  }

  /// получаем категории из хайв
  static List<CatalogCategoryModel> getCatalogCategories() {
    List<CatalogCategoryModel> result =
        Hive.box<CatalogCategoryModel>(catalogCategoryKey).values.toList();

    return result;
  }

  /// очищает список категорий
  static Future<void> deleteCatalogCategories() async {
    await Hive.box<CatalogCategoryModel>(catalogCategoryKey).clear();
  }

  /// Добаляем категории в хайв
  static void addCatalogItems(List<CatalogItemModel> catalogItems) {
    if (catalogItems.isEmpty) return;
    // очищает старые категории
    deleteCatalogItems().then((onValue) {
      // добалвяет новые позиции ошибок
      Hive.box<CatalogItemModel>(catalogItemKey).addAll(catalogItems);
    });
  }

  /// получаем категории из хайв
  static List<CatalogItemModel> getCatalogItems() {
    List<CatalogItemModel> result =
        Hive.box<CatalogItemModel>(catalogItemKey).values.toList();
    return result;
  }

  /// очищает список категорий
  static Future<void> deleteCatalogItems() async {
    await Hive.box<CatalogItemModel>(catalogItemKey).clear();
  }

  /// сохраняем данные пользователя в локальное хранилище
  static void putUserData(ProfileUserModel profileUser) {
    Hive.box<ProfileUserModel>(profileUserKey).add(profileUser);
  }

  /// возвраащет данные пользователя из локального хранилища
  static ProfileUserModel? getUserData() {
    // Hive.box<ProfileUserModel>(profileUserKey).clear();
    // return null;
    return Hive.box<ProfileUserModel>(profileUserKey).get(0);
  }

  /// Добаляем позиции контента в хайв
  static void addContentArticles(List<ArticleModel> contentArticles) {
    if (contentArticles.isEmpty) return;
    // очищает старые категории
    deleteContentArticles().then((onValue) {
      // добалвяет новые
      Hive.box<ArticleModel>(contentArticleKey).addAll(contentArticles);
    });
  }

  /// получаем позиции контента из хайв
  static List<ArticleModel> getContentArticles() {
    List<ArticleModel> result =
        Hive.box<ArticleModel>(contentArticleKey).values.toList();
    return result;
  }

  /// очищает список позиций контента
  static Future<void> deleteContentArticles() async {
    await Hive.box<ArticleModel>(contentArticleKey).clear();
  }

  /// Добаляем позиции контента в хайв
  static void addCtypes(List<CtypeModel> ctypes) {
    if (ctypes.isEmpty) return;
    // очищает старые категории
    deleteCtypes().then((onValue) {
      // добалвяет новые
      Hive.box<CtypeModel>(contentTypeKey).addAll(ctypes);
    });
  }

  /// получаем позиции контента из хайв
  static List<CtypeModel> getCtypes() {
    List<CtypeModel> result =
        Hive.box<CtypeModel>(contentTypeKey).values.toList();
    return result;
  }

  /// очищает список позиций контента
  static Future<void> deleteCtypes() async {
    await Hive.box<CtypeModel>(contentTypeKey).clear();
  }
}
