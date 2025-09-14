class Product {
  final String image;
  final String brand;
  final String name;
  final double price;
  final double? oldPrice;
  final int? discount;
  final String? description;

  Product({
    required this.image,
    required this.brand,
    required this.name,
    required this.price,
    this.oldPrice,
    this.discount,
    this.description,
  });
}
