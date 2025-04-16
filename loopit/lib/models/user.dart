class User {
  final int id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? -1, // Provide a default value if null
      username: json['username'] ?? 'Unknown User', // Default username if null
      email: json['email'] ?? '', // Default empty email if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  // Optional: Add a method to check if this is a default/placeholder user
  bool get isDefaultUser => id == -1;
}