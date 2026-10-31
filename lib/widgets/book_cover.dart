import 'package:flutter/material.dart';

import '../app_colors.dart';

/// Book cover with a placeholder when the URL is null or fails to load.
class BookCover extends StatelessWidget {
  final String? url;
  final double width;
  final double height;

  const BookCover({
    super.key,
    required this.url,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: AppColors.pink,
      child: const Icon(Icons.menu_book, color: Colors.white),
    );
    final imageUrl = url;
    if (imageUrl == null) return placeholder;

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }
}
