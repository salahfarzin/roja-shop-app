class Product {
  final String id;
  final String image;
  final String brand;
  final String name;
  final double price;
  final double? oldPrice;
  final double? discount;
  final String? description;
  final int inventory;

  Product({
    required this.id,
    required this.image,
    required this.brand,
    required this.name,
    required this.price,
    this.oldPrice,
    this.discount,
    this.description,
    required this.inventory,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice'] as num).toDouble()
          : null,
      discount: json['discount'] != null
          ? (json['discount'] as num).toDouble()
          : null,
      brand: json['brand'] as String,
      description: json['description'] as String?,
      image: json['image'] as String,
      inventory: json['inventory'] is int
          ? json['inventory'] as int
          : int.tryParse(json['inventory'].toString()) ?? 0,
    );
  }
}
