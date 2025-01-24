class User {
  final String? id;
  final String name;
  final String email;
  final String gender;
  final String status;
  final String? avatarUrl;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    gender: json["gender"],
    status: json["status"],
    avatarUrl: json["avatarUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "gender": gender,
    "status": status,
    "avatarUrl": avatarUrl,
  };

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? gender,
    String? status,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
