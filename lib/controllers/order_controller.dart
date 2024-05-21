// lib/controllers/order_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../controllers/auth_controller.dart';

class OrderController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find<AuthController>();

  void placeOrder(OrderModel order) async {
    try {
      DocumentReference docRef =
          await firestore.collection('orders').add(order.toJson());
      await docRef.update({'id': docRef.id});
      Get.snackbar("Success", "Order placed successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to place order: $e");
    }
  }
}
