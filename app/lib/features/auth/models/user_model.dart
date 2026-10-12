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
  final String? pixKey;
  final String? pixKeyType;
  final String? referencePoint;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.phone,
    this.tradeName,
    this.bio,
    this.pixKey,
    this.pixKeyType,
    this.referencePoint,
    this.latitude,
    this.longitude,
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
      'pixKey': pixKey,
      'pixKeyType': pixKeyType,
      'referencePoint': referencePoint,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      userType: UserType.values.firstWhere(
        (e) => e.name == json['userType'] || e.name == json['user_type'],
        orElse: () => UserType.client,
      ),
      phone: json['phone'] as String?,
      tradeName: (json['tradeName'] ?? json['trade_name']) as String?,
      bio: json['bio'] as String?,
      pixKey: (json['pixKey'] ?? json['pix_key']) as String?,
      pixKeyType: (json['pixKeyType'] ?? json['pix_key_type']) as String?,
      referencePoint: (json['referencePoint'] ?? json['reference_point']) as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ?? DateTime.now(),
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
    String? pixKey,
    String? pixKeyType,
    String? referencePoint,
    double? latitude,
    double? longitude,
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
      pixKey: pixKey ?? this.pixKey,
      pixKeyType: pixKeyType ?? this.pixKeyType,
      referencePoint: referencePoint ?? this.referencePoint,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
