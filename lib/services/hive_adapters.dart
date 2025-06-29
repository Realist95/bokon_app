import 'package:bokon_app/models/content/article.dart';
import 'package:bokon_app/models/content/ctype.dart';
import 'package:bokon_app/models/profile/user_model.dart';
import 'package:hive_ce/hive.dart';
import 'package:bokon_app/models/catalog/category.dart';
import 'package:bokon_app/models/catalog/item.dart';

@GenerateAdapters([
  AdapterSpec<CatalogItemModel>(),
  AdapterSpec<CatalogCategoryModel>(),
  AdapterSpec<ProfileUserModel>(),
  AdapterSpec<ArticleModel>(),
  AdapterSpec<CtypeModel>(),
])
part 'hive_adapters.g.dart';
