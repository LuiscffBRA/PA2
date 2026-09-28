enum UserType {
  client,
  vendor,
}

extension UserTypeExtension on UserType {
  String get label {
    switch (this) {
      case UserType.client:
        return 'Cliente';
      case UserType.vendor:
        return 'Vendedor / Ambulante';
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserType userType;
  final String? phone;
  final String? tradeName;
  final String? bio;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.phone,
    this.tradeName,
    this.bio,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isVendor => userType == UserType.vendor;
  bool get isClient => userType == UserType.client;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType.name,
      'phone': phone,
      'tradeName': tradeName,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      userType: UserType.values.firstWhere(
        (e) => e.name == json['userType'],
        orElse: () => UserType.client,
      ),
      phone: json['phone'] as String?,
      tradeName: json['tradeName'] as String?,
      bio: json['bio'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserType? userType,
    String? phone,
    String? tradeName,
    String? bio,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      phone: phone ?? this.phone,
      tradeName: tradeName ?? this.tradeName,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
