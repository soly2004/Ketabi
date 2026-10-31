import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/book.dart';
import '../services/local_storage.dart';

class FavoritesState {
  final List<Book> books;

  /// Snackbar text for the last add/remove (null when just loaded).
  final String? message;

  const FavoritesState(this.books, [this.message]);
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final LocalStorage _storage;

  FavoritesCubit(this._storage) : super(const FavoritesState([])) {
    _load();
  }

  Future<void> _load() async {
    emit(FavoritesState(await _storage.loadFavorites()));
  }

  Future<void> toggle(Book book) async {
    final books = List<Book>.from(state.books);
    final String message;
    if (books.any((b) => b.id == book.id)) {
      books.removeWhere((b) => b.id == book.id);
      message = "Removed '${book.title}' from favorites";
    } else {
      books.add(book);
      message = "Added '${book.title}' to favorites";
    }
    emit(FavoritesState(books, message));
    await _storage.saveFavorites(books);
  }
}
