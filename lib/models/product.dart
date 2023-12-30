class Product {
  String id;
  String title;
  double price;
  String imageUrl;
  String category;
  String restaurantName; // Ajoutez cette ligne pour stocker le nom du restaurant

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.restaurantName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image'] ?? '',
      category: json['category'] ?? '',
      restaurantName: json['restaurant'] ?? '', // Utilisez le nom que vous obtenez du serveur
    );
  }
}
