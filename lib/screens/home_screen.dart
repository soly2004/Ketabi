import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_colors.dart';
import '../cubits/books_cubit.dart';
import '../cubits/books_state.dart';
import '../widgets/book_card.dart';
import 'favorites_screen.dart';

const List<String> bookCategories = [
  'Literature',
  'Computer Science',
  'Engineering',
  'Medicine',
  'Science',
  'Business',
  'High School',
  'History',
  'Fiction',
  'Pharmacy',
  'Self-Help',
  'Psychology',
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitabi'),
        backgroundColor: AppColors.babyBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: AppColors.deepPink),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar (outside the BlocBuilder so typing is never reset)
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) => context.read<BooksCubit>().search(value),
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.lightBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Offline banner + category chips
          BlocBuilder<BooksCubit, BooksState>(
            builder: (context, state) {
              final cubit = context.read<BooksCubit>();
              return Column(
                children: [
                  if (state is BooksLoaded && state.isOffline)
                    Container(
                      width: double.infinity,
                      color: Colors.amber.shade200,
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'No internet connection. Displaying cached catalog.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: bookCategories.length + 1,
                      itemBuilder: (context, index) {
                        final String? category =
                            index == 0 ? null : bookCategories[index - 1];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(category ?? 'All'),
                            selected: cubit.category == category,
                            selectedColor: AppColors.pink,
                            onSelected: (_) => cubit.filterByCategory(category),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          // Book list - reacts only to emitted states
          Expanded(
            child: BlocBuilder<BooksCubit, BooksState>(
              builder: (context, state) {
                if (state is BooksLoading || state is BooksInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is BooksError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.pink,
                            ),
                            onPressed: () => context.read<BooksCubit>().loadBooks(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is BooksLoaded) {
                  if (state.visibleBooks.isEmpty) {
                    return const Center(child: Text('No books match your search.'));
                  }
                  return ListView.builder(
                    itemCount: state.visibleBooks.length,
                    itemBuilder: (context, index) {
                      return BookCard(book: state.visibleBooks[index]);
                    },
                  );
                }
                // BooksEmpty
                return const Center(child: Text('No books found.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
