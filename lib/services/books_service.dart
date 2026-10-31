import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/book.dart';

/// Change this one value to swap environments.
///  - Mock (default): raw GitHub URL of books_api_response.json
///  - Local server:   http://10.0.2.2:8080/books_api_response.json (Android emulator)
///                    http://localhost:8080/books_api_response.json (iOS / web)
///  - Real API:       https://api.kitabi.com.eg/v2/books
const String booksUrl =
    'https://raw.githubusercontent.com/soly2004/Ketabi/main/books_api_response.json';
/// Thrown when the server answers with a non-200 status code.
class ApiException implements Exception {
  final int statusCode;
  ApiException(this.statusCode);
}

class BooksService {
  /// Returns the raw JSON body (so it can be cached as-is).
  Future<String> fetchBooksJson() async {
    final response = await http.get(
      Uri.parse(booksUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': 'en',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) return response.body;
    throw ApiException(response.statusCode);
  }

  /// Parses on a background isolate so the UI never freezes.
  Future<List<Book>> parseBooks(String body) => compute(_parse, body);
}

List<Book> _parse(String body) {
  final decoded = jsonDecode(body);
  final data = decoded is Map ? decoded['data'] : null;
  final list = data is Map ? data['books'] : null;
  if (list is! List) return [];
  return list
      .whereType<Map<String, dynamic>>()
      .map(Book.fromJson)
      .toList();
}
