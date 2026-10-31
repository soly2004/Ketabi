import '../models/book.dart';

abstract class BooksState {}

class BooksInitial extends BooksState {}

class BooksLoading extends BooksState {}

/// No books (404, or an empty catalog).
class BooksEmpty extends BooksState {}

class BooksError extends BooksState {
  final String message;
  BooksError(this.message);
}

class BooksLoaded extends BooksState {
  /// Books after the current search + category filter were applied.
  final List<Book> visibleBooks;

  /// True when the data comes from the local cache.
  final bool isOffline;

  /// True when the cache is shown because the server returned 500/503.
  final bool serverBusy;

  BooksLoaded({
    required this.visibleBooks,
    required this.isOffline,
    required this.serverBusy,
  });
}
