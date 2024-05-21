// lib/models/product_model.dart
class ProductModel {
  String id;
  String farmerId;
  String name;
  String description;
  double price;
  String imageUrl;
  double? averageRating; // Ortalama puan alanı

  ProductModel({
    required this.id,
    required this.farmerId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.averageRating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      farmerId: json['farmerId'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      averageRating: json['averageRating'] != null
          ? (json['averageRating'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'averageRating': averageRating,
    };
  }
}
