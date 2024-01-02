class Product {
  String id;
  String title;
  double price;
  String imageUrl;
  String category;
  String restaurantId; // Utilisez le nom que vous obtenez du serveur

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.restaurantId, // Mettez à jour le nom de la clé
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image'] ?? '',
      category: json['category'] ?? '',
      restaurantId: json['restaurant'] ?? '', // Mettez à jour le nom de la clé
    );
  }
}
