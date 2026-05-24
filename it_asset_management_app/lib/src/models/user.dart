class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final int id;
  final String name;
  final String email;
  final String role;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'staff',
    );
  }
}
