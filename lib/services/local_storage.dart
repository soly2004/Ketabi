import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/book.dart';

/// Local device storage: cached catalog + saved favorites.
class LocalStorage {
  static const _catalogKey = 'cached_catalog';
  static const _favoritesKey = 'favorite_books';

  Future<void> saveCatalog(String body) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_catalogKey, body);
  }

  Future<String?> loadCatalog() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_catalogKey);
  }

  Future<void> saveFavorites(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final items = books.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList(_favoritesKey, items);
  }

  Future<List<Book>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(_favoritesKey) ?? [];
    return items
        .map((s) => Book.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }
}
