class User_all {
  String? username;
  String? email;
  String? password;
  String? address;
  String? phone;
  String? gender;
  DateTime? createdAt;
  List<String>? roles;

  User_all({
    this.username,
    this.email,
    this.password,
    this.address,
    this.phone,
    this.gender,
    this.createdAt,
    this.roles,
  });

  void clear() {
    username = null;
    email = null;
    password = null;
    address = null;
    phone = null;
    gender = null;
    createdAt = null;
    roles = null;
  }

  factory User_all.fromJson(Map<String, dynamic> json) {
    return User_all(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      roles: (json['roles'] as List<dynamic>?)
          ?.map((role) => role.toString().replaceFirst('ROLE_', ''))
          .toList(),
    );
  }
}
