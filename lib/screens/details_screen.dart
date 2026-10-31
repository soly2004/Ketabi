import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_colors.dart';
import '../cubits/favorites_cubit.dart';
import '../models/book.dart';
import '../widgets/book_cover.dart';

/// Read-only screen. The [Book] comes from the existing app state - no API call.
class DetailsScreen extends StatelessWidget {
  final Book book;

  const DetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: AppColors.babyBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: BookCover(url: book.imageUrl, width: 180, height: 240),
            ),
            const SizedBox(height: 16),
            Text(
              book.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(book.author, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text(
              book.priceText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepPink,
              ),
            ),
            const SizedBox(height: 12),
            Text('Publisher: ${book.publisher ?? 'Not listed'}'),
            Text('Condition: ${book.condition}'),
            Text('Seller location: ${book.sellerLocation}'),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(book.description ?? 'No description available.'),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          final isFavorite = state.books.any((b) => b.id == book.id);
          return FloatingActionButton(
            backgroundColor: AppColors.pink,
            onPressed: () => context.read<FavoritesCubit>().toggle(book),
            child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          );
        },
      ),
    );
  }
}
