# Kitabi Marketplace V2.0 (Flutter)

Used-books marketplace app rebuilt with the **BLoC/Cubit pattern**, safe JSON parsing, offline caching and persistent favorites. Colors: baby blue + pink.

## Features
- **Home:** fetches the catalog on start, search by title/author, category filter chips, book cards with a favorite toggle
- **Book Details:** read-only, uses the book already in app state (no new API call)
- **Favorites:** saved on the device (survive restart), empty state, swipe to delete
- **Offline:** last successful catalog is cached; if the request fails it is shown with an "Offline" banner
- **Snackbars (BlocListener):** favorite added/removed, server busy, connection failure

## Run steps
1. Install Flutter, then in this folder run:
   ```
   flutter create .
   flutter pub get
   ```
   (`flutter create .` only adds the android/ios folders; it keeps `lib/` and `pubspec.yaml`.)
2. Put `books_api_response.json` in your GitHub repo (branch `main`) and make sure `booksUrl` in `lib/services/books_service.dart` matches your repo URL.
   - Or serve it locally: `python -m http.server 8080` in this folder, then set `booksUrl` to `http://10.0.2.2:8080/books_api_response.json` (Android emulator).
3. `flutter run`

To test offline: run once with internet, then turn on airplane mode and restart the app.

## Folder structure
```
lib/
  main.dart                 app setup, providers, BlocListeners (snackbars)
  app_colors.dart           baby blue + pink
  models/book.dart          Book + safe fromJson
  services/books_service.dart   HTTP call (http) + background JSON parsing
  services/local_storage.dart   cache + favorites (shared_preferences)
  cubits/                   BooksCubit, BooksState, FavoritesCubit
  screens/                  home, details, favorites
  widgets/                  book card, book cover
```

## Packages (pub.dev metrics)
| Package | Why | pub.dev |
|---|---|---|
| flutter_bloc ^9.1.1 | BLoC/Cubit state management | 160/160 pub points, ~8k likes, Flutter Favorite, verified publisher (bloclibrary.dev) |
| http ^1.2.2 | Simple HTTP GET with status codes and timeout | 140 pub points, ~7.5k likes, 100% popularity, published by dart.dev |
| shared_preferences ^2.2.3 | Stores favorites and the cached catalog on the device | 140 pub points, ~9k likes, 100% popularity, Flutter Favorite |

All three support null safety. Check the current numbers on pub.dev before you submit.

## Screenshots
Add your screenshots to a `screenshots/` folder and link them here: loading, catalog, offline banner, details, favorites (empty and filled).
