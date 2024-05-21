class FarmerModel {
  String id;
  String name;
  String email;
  String shopName;
  double latitude;
  double longitude;

  FarmerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.shopName,
    required this.latitude,
    required this.longitude,
  });

  factory FarmerModel.fromJson(Map<String, dynamic> json) {
    return FarmerModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      shopName: json['shopName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'shopName': shopName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
