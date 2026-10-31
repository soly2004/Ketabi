import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_colors.dart';
import 'cubits/books_cubit.dart';
import 'cubits/books_state.dart';
import 'cubits/favorites_cubit.dart';
import 'screens/home_screen.dart';
import 'services/books_service.dart';
import 'services/local_storage.dart';

final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnack(String message) {
  messengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

void main() {
  runApp(const KitabiApp());
}

class KitabiApp extends StatelessWidget {
  const KitabiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          // Fetch the catalog as soon as the app starts
          create: (_) => BooksCubit(BooksService(), LocalStorage())..loadBooks(),
        ),
        BlocProvider(create: (_) => FavoritesCubit(LocalStorage())),
      ],
      // BlocListeners trigger snackbars (side effects) without rebuilding the UI
      child: MultiBlocListener(
        listeners: [
          BlocListener<BooksCubit, BooksState>(
            listenWhen: (previous, current) =>
                current is BooksError ||
                (current is BooksLoaded &&
                    current.serverBusy &&
                    (previous is! BooksLoaded || !previous.serverBusy)),
            listener: (context, state) {
              if (state is BooksError) {
                showSnack(state.message);
              } else {
                showSnack('Kitabi servers are currently busy. Showing cached books.');
              }
            },
          ),
          BlocListener<FavoritesCubit, FavoritesState>(
            listenWhen: (previous, current) => current.message != null,
            listener: (context, state) => showSnack(state.message!),
          ),
        ],
        child: MaterialApp(
          title: 'Kitabi',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: messengerKey,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.babyBlue),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
