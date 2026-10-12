class PostModel {
  final String id;
  final String vendorId;
  final String vendorName;
  final String vendorTradeName;
  final String? vendorPhone;
  final String? vendorReferencePoint;
  final String? vendorPixKey;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final String? category;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByMe;

  PostModel({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.vendorTradeName,
    this.vendorPhone,
    this.vendorReferencePoint,
    this.vendorPixKey,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    this.category,
    DateTime? createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByMe = false,
  }) : createdAt = createdAt ?? DateTime.now();

  PostModel copyWith({
    String? id,
    String? vendorId,
    String? vendorName,
    String? vendorTradeName,
    String? vendorPhone,
    String? vendorReferencePoint,
    String? vendorPixKey,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    bool? isLikedByMe,
  }) {
    return PostModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      vendorTradeName: vendorTradeName ?? this.vendorTradeName,
      vendorPhone: vendorPhone ?? this.vendorPhone,
      vendorReferencePoint: vendorReferencePoint ?? this.vendorReferencePoint,
      vendorPixKey: vendorPixKey ?? this.vendorPixKey,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
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
      'vendorReferencePoint': vendorReferencePoint,
      'vendorPixKey': vendorPixKey,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLikedByMe': isLikedByMe,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      vendorId: (json['vendorId'] ?? json['vendor_id']) as String,
      vendorName: (json['vendorName'] ?? json['vendor_name']) as String? ?? 'Vendedor(a)',
      vendorTradeName: (json['vendorTradeName'] ?? json['vendor_trade_name']) as String? ?? 'Ponto Comercial',
      vendorPhone: (json['vendorPhone'] ?? json['vendor_phone']) as String?,
      vendorReferencePoint: (json['vendorReferencePoint'] ?? json['vendor_reference_point']) as String?,
      vendorPixKey: (json['vendorPixKey'] ?? json['vendor_pix_key']) as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: (json['imageUrl'] ?? json['image_url']) as String?,
      category: json['category'] as String?,
      createdAt: DateTime.tryParse((json['createdAt'] ?? json['created_at']) ?? '') ?? DateTime.now(),
      likesCount: (json['likesCount'] ?? json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] ?? json['comments_count'] as num?)?.toInt() ?? 0,
      isLikedByMe: json['isLikedByMe'] as bool? ?? false,
    );
  }
}
