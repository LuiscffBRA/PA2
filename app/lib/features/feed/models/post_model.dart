class PostModel {
  final String id;
  final String vendorId;
  final String vendorName;
  final String vendorTradeName;
  final String? vendorPhone;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final String? category;
  final DateTime createdAt;
  final int likesCount;
  final bool isLikedByMe;

  PostModel({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.vendorTradeName,
    this.vendorPhone,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    this.category,
    DateTime? createdAt,
    this.likesCount = 0,
    this.isLikedByMe = false,
  }) : createdAt = createdAt ?? DateTime.now();

  PostModel copyWith({
    String? id,
    String? vendorId,
    String? vendorName,
    String? vendorTradeName,
    String? vendorPhone,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    DateTime? createdAt,
    int? likesCount,
    bool? isLikedByMe,
  }) {
    return PostModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      vendorTradeName: vendorTradeName ?? this.vendorTradeName,
      vendorPhone: vendorPhone ?? this.vendorPhone,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'vendorTradeName': vendorTradeName,
      'vendorPhone': vendorPhone,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'isLikedByMe': isLikedByMe,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      vendorName: json['vendorName'] as String,
      vendorTradeName: json['vendorTradeName'] as String,
      vendorPhone: json['vendorPhone'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      isLikedByMe: json['isLikedByMe'] as bool? ?? false,
    );
  }
}
