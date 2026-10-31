import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/book.dart';
import '../services/books_service.dart';
import '../services/local_storage.dart';
import 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final BooksService _service;
  final LocalStorage _storage;

  BooksCubit(this._service, this._storage) : super(BooksInitial());

  List<Book> _allBooks = [];
  String _query = '';
  String? _category;
  bool _isOffline = false;
  bool _serverBusy = false;

  String? get category => _category;

  Future<void> loadBooks() async {
    emit(BooksLoading());
    try {
      final body = await _service.fetchBooksJson();
      _allBooks = await _service.parseBooks(body);
      await _storage.saveCatalog(body);
      _isOffline = false;
      _serverBusy = false;
      _emitBooks();
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        emit(BooksError('Invalid search filter. Please adjust it and try again.'));
      } else if (e.statusCode == 404) {
        emit(BooksEmpty());
      } else {
        await _loadFromCache(serverBusy: e.statusCode >= 500);
      }
    } catch (_) {
      // Timeout / no connection
      await _loadFromCache(serverBusy: false);
    }
  }

  Future<void> _loadFromCache({required bool serverBusy}) async {
    final cached = await _storage.loadCatalog();
    if (cached == null) {
      emit(BooksError('Failed to connect to Kitabi servers. Please try again.'));
      return;
    }
    try {
      _allBooks = await _service.parseBooks(cached);
      _isOffline = true;
      _serverBusy = serverBusy;
      _emitBooks();
    } catch (_) {
      emit(BooksError('Failed to connect to Kitabi servers. Please try again.'));
    }
  }

  void search(String query) {
    _query = query.trim().toLowerCase();
    if (state is BooksLoaded) _emitBooks();
  }

  void filterByCategory(String? category) {
    _category = category;
    if (state is BooksLoaded) _emitBooks();
  }

  void _emitBooks() {
    if (_allBooks.isEmpty) {
      emit(BooksEmpty());
      return;
    }
    final visible = _allBooks.where((book) {
      final matchesCategory = _category == null || book.category == _category;
      final matchesQuery = _query.isEmpty ||
          book.title.toLowerCase().contains(_query) ||
          book.author.toLowerCase().contains(_query);
      return matchesCategory && matchesQuery;
    }).toList();
    emit(BooksLoaded(
      visibleBooks: visible,
      isOffline: _isOffline,
      serverBusy: _serverBusy,
    ));
  }
}
