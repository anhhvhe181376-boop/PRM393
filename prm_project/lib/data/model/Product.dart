class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.description = "",
    this.image = "",
  });
}