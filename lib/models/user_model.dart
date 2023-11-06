class User {
  final String email;
  final String name;
  final String lastName;

  User({
    required this.email,
    required this.name,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['name'],
      lastName: json['last_name'],
    );
  }
}
