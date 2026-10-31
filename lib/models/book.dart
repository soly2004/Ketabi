/// A book listing from the Kitabi API.
/// [Book.fromJson] never throws on missing or null fields.
class Book {
  final String id;
  final String title;
  final String author;
  final String? isbn;
  final double? price;
  final String condition;
  final String category;
  final String? seller;
  final String sellerLocation;
  final String? imageUrl;
  final String? edition;
  final String? publisher;
  final String? description;
  final bool isAvailable;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    required this.category,
    required this.sellerLocation,
    required this.isAvailable,
    this.isbn,
    this.price,
    this.seller,
    this.imageUrl,
    this.edition,
    this.publisher,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final title = _text(json['title']) ?? 'Untitled';
    return Book(
      id: _text(json['id']) ?? title,
      title: title,
      author: _text(json['author']) ?? 'Unknown author',
      isbn: _text(json['isbn']),
      price: num.tryParse(json['price_egp']?.toString() ?? '')?.toDouble(),
      condition: _text(json['condition']) ?? 'Not specified',
      category: _text(json['category']) ?? 'Uncategorized',
      seller: _text(json['seller']),
      sellerLocation: _text(json['seller_location']) ?? 'Location not listed',
      imageUrl: _text(json['image_url']),
      edition: _text(json['edition']),
      publisher: _text(json['publisher']),
      description: _text(json['description']),
      isAvailable: json['is_available'] != false,
    );
  }

  /// Uses the same keys as the API so [Book.fromJson] can read it back.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'isbn': isbn,
        'price_egp': price,
        'condition': condition,
        'category': category,
        'seller': seller,
        'seller_location': sellerLocation,
        'image_url': imageUrl,
        'edition': edition,
        'publisher': publisher,
        'description': description,
        'is_available': isAvailable,
      };

  String get priceText {
    final p = price;
    if (p == null) return 'Price N/A';
    return '${p.toStringAsFixed(p % 1 == 0 ? 0 : 2)} EGP';
  }

  static String? _text(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }
}
