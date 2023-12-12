class User {
  final String username;
  final String password; // Note: It's recommended not to store passwords in plain text
  final String email;
  final String phoneNumber;
  final String adresse;
  final String role;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.adresse,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      adresse: json['adresse'],
      role: json['role'],
    );
  }
}