// lib/models/order_model.dart
enum OrderStatus {
  pending,
  shipped,
  delivered,
}

class OrderModel {
  String id;
  String productId;
  String farmerId;
  String customerId;
  int quantity;
  double totalPrice;
  String shippingAddress;
  int customerPoint;
  OrderStatus orderStatus;

  OrderModel({
    required this.id,
    required this.productId,
    required this.farmerId,
    required this.customerId,
    required this.quantity,
    required this.totalPrice,
    required this.shippingAddress,
    this.customerPoint = -1,
    required this.orderStatus,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      productId: json['productId'],
      farmerId: json['farmerId'],
      customerId: json['customerId'],
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
      shippingAddress: json['shippingAddress'],
      customerPoint: json['customerPoint'],
      orderStatus: OrderStatus.values[json['orderStatus']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'farmerId': farmerId,
      'customerId': customerId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'shippingAddress': shippingAddress,
      'customerPoint': customerPoint,
      'orderStatus': orderStatus.index,
    };
  }
}
