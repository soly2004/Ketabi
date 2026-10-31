import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_colors.dart';
import '../cubits/favorites_cubit.dart';
import '../models/book.dart';
import '../screens/details_screen.dart';
import 'book_cover.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightBlue,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailsScreen(book: book)),
          );
        },
        leading: BookCover(url: book.imageUrl, width: 48, height: 64),
        title: Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${book.author}\n${book.priceText}'),
        isThreeLine: true,
        trailing: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            final isFavorite = state.books.any((b) => b.id == book.id);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: AppColors.deepPink,
              ),
              onPressed: () => context.read<FavoritesCubit>().toggle(book),
            );
          },
        ),
      ),
    );
  }
}
