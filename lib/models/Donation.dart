class Donation {
  String id; // Add this field for storing the unique identifier
  String title;
  String description;
  int quantity;
  String date;
  String status;

  Donation({
    required this.title,
    required this.description,
    required this.quantity,
    required this.date,
    required this.status,
    required this.id,
  });

  // Getter for the id
  String get iD => id;

  // Factory method to create a Donation instance from a JSON map
  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['iD'],
      title: json['title'],
      description: json['description'],
      quantity: json['quantity'],
      date: json['date'],
      status: json['status'],
    );
  }

  // Method to convert Donation instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'quantity': quantity,
      'date': date,
      'status': status,
    };
  }

  static List<Donation> allDonations = [];

  static void clearDonations() {
    allDonations.clear();
  }
}
