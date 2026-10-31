import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_colors.dart';
import '../cubits/favorites_cubit.dart';
import '../widgets/book_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: AppColors.babyBlue,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.books.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book, size: 96, color: AppColors.pink),
                    SizedBox(height: 12),
                    Text(
                      'Your reading list is empty. Start exploring the Kitabi catalog!',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.books.length,
            itemBuilder: (context, index) {
              final book = state.books[index];
              // Swipe left or right to remove
              return Dismissible(
                key: ValueKey(book.id),
                background: Container(color: AppColors.pink),
                onDismissed: (_) => context.read<FavoritesCubit>().toggle(book),
                child: BookCard(book: book),
              );
            },
          );
        },
      ),
    );
  }
}
