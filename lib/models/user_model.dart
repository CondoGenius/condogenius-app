class User {
  final int? id;
  final String? email;
  final String name;
  final String lastName;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      lastName: json['last_name'],
    );
  }
}