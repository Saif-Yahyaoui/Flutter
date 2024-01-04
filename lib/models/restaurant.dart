class Restaurant {
  String id;
  String category;
  String image;
  String description;
  List<dynamic> orders;
  String username; // Ajoutez cette ligne pour définir la propriété username

  Restaurant({
    required this.id,
    required this.category,
    required this.image,
    required this.description,
    required this.orders,
    required this.username, // Ajoutez cette ligne pour initialiser la propriété username
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'],
      category: json['category'],
      image: json['image'],
      description: json['description'],
      orders: json['orders'],
      username: json['username'], // Assurez-vous de récupérer la valeur du champ username depuis le JSON
    );
  }
}
