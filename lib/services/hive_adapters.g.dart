// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class CatalogItemModelAdapter extends TypeAdapter<CatalogItemModel> {
  @override
  final typeId = 1;

  @override
  CatalogItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CatalogItemModel(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      maingroup: (fields[2] as num).toInt(),
      content: fields[3] as String,
      description: fields[4] as String,
      difficulty: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CatalogItemModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.maingroup)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.difficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CatalogCategoryModelAdapter extends TypeAdapter<CatalogCategoryModel> {
  @override
  final typeId = 2;

  @override
  CatalogCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CatalogCategoryModel(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      image: fields[2] as String,
      childrens: (fields[3] as List).cast<CatalogCategoryModel>(),
      titleH1: fields[4] as String,
      parent: (fields[5] as num).toInt(),
      description: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CatalogCategoryModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.childrens)
      ..writeByte(4)
      ..write(obj.titleH1)
      ..writeByte(5)
      ..write(obj.parent)
      ..writeByte(6)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileUserModelAdapter extends TypeAdapter<ProfileUserModel> {
  @override
  final typeId = 3;

  @override
  ProfileUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileUserModel(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      phone: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileUserModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ArticleModelAdapter extends TypeAdapter<ArticleModel> {
  @override
  final typeId = 4;

  @override
  ArticleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticleModel(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      ctype: (fields[2] as num).toInt(),
      date: fields[4] as String,
      content: fields[3] as String,
      isSpecial: fields[5] as bool,
      description: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ArticleModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ctype)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.isSpecial)
      ..writeByte(6)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CtypeModelAdapter extends TypeAdapter<CtypeModel> {
  @override
  final typeId = 5;

  @override
  CtypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CtypeModel(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      content: fields[2] as String,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CtypeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CtypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
