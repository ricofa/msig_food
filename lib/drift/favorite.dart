import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'favorite.g.dart';
class Favorite extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get idFood => text().named('id_food')();
  TextColumn get image => text().named('image')();
  TextColumn get title => text().named('title')();
  TextColumn get category => text().named('category')();
  TextColumn get area => text().named('area')();
}

@DriftDatabase(tables: [Favorite])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<FavoriteData>> getFavorites() async {
    return await select(favorite).get();
  }

  Future<FavoriteData> getFavorite(String id) async {
    return await (select(favorite)..where((tbl) => tbl.idFood.equals(id)))
        .getSingle();
  }

  Future<int> insertFavorite(FavoriteCompanion entity) async {
    return await into(favorite).insert(entity);
  }

  Future deleteFavorite(String id) async {
    return await (delete(favorite)..where((tbl) => tbl.idFood.equals(id)))
        .go();
  }
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final fileDb = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(fileDb);
  });
}