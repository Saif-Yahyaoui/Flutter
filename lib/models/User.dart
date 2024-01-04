class User {
  String id;
  String username;
  String password;
  String email;
  String phoneNumber;
  String adresse;
  String role;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.adresse,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      adresse: json['adresse'],
      role: json['role'],
    );
  }
}
