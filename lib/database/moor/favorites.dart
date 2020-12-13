import 'package:flutter/material.dart' as m;
import 'package:moor_flutter/moor_flutter.dart';

part 'favorites.g.dart';

class Favorites extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get image => text()();
  TextColumn get category => text()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [Favorites])
class MyDatabase extends _$MyDatabase with m.ChangeNotifier {
  MyDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db1.sqlite'));

  @override
  int get schemaVersion => 1;

  Future<List<Favorite>> get allFavorites => select(favorites).get();

  void addFavorite(Favorite favorite) {
    into(favorites).insert(favorite);
    notifyListeners();
  }

  void removeFavorite(String id) {
    (delete(favorites)..where((t) => t.id.equals(id))).go();
    notifyListeners();
  }

  Stream<bool> isFavorite(String id) => select(favorites).watch().map(
      (favoritesList) => favoritesList.any((favorite) => favorite.id == id));
}
