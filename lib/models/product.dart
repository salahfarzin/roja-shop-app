class Product {
  final String id;
  final String image;
  final String brand;
  final String title;
  final double price;
  final double? oldPrice;
  final double? discount;
  final String? description;
  final int inventory;
  final int soldCount;
  final Map<String, dynamic>? details;
  final Map<String, dynamic>? styleNotes;

  Product({
    required this.id,
    required this.image,
    required this.brand,
    required this.title,
    required this.price,
    this.oldPrice,
    this.discount,
    this.description,
    required this.inventory,
    this.soldCount = 0,
    this.details,
    this.styleNotes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      oldPrice: json['old_price'] != null
          ? (json['old_price'] as num).toDouble()
          : null,
      discount: json['discount'] != null
          ? (json['discount'] as num).toDouble()
          : null,
      brand: json['brand'] as String,
      description: json['description'] as String?,
      image: json['file'] is String
          ? json['file'] as String
          : (json['file'] is Map<String, dynamic> &&
                    json['file']['path'] != null
                ? json['file']['path'] as String
                : ''),
      inventory: json['inventory'] is int
          ? json['inventory'] as int
          : int.tryParse(json['inventory'].toString()) ?? 0,
      soldCount: json['sold_count'] is int
          ? json['sold_count'] as int
          : int.tryParse(json['sold_count'].toString()) ?? 0,
      details: json['details'] as Map<String, dynamic>?,
      styleNotes: json['style_notes'] as Map<String, dynamic>?,
    );
  }
}
