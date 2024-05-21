// lib/controllers/product_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/product_model.dart';
import '../controllers/auth_controller.dart';
import '../models/order_model.dart';

class ProductController extends GetxController {
  var products = <ProductModel>[].obs;
  var searchResults = <ProductModel>[].obs;
  var selectedImage = Rx<File?>(null);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      String farmerId = authController.userId.value;
      QuerySnapshot snapshot = await firestore
          .collection('products')
          .where('farmerId', isEqualTo: farmerId)
          .get();
      products.value = snapshot.docs
          .map((doc) =>
              ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      fetchProductRatings();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch products: $e");
    }
  }

  void fetchProductRatings() async {
    try {
      for (var product in products) {
        QuerySnapshot snapshot = await firestore
            .collection('orders')
            .where('productId', isEqualTo: product.id)
            .where('customerPoint', isGreaterThan: -1)
            .get();
        var ratings = snapshot.docs
            .map((doc) =>
                (doc.data() as Map<String, dynamic>)['customerPoint'] as int)
            .toList();
        if (ratings.isNotEmpty) {
          product.averageRating =
              ratings.reduce((a, b) => a + b) / ratings.length;
        } else {
          product.averageRating = null;
        }
      }
      products.refresh();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch product ratings: $e");
    }
  }

  void searchProducts(String query) {
    searchResults.value = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void addProduct(ProductModel product) async {
    try {
      DocumentReference docRef =
          await firestore.collection('products').add(product.toJson());
      await docRef.update(
          {'id': docRef.id}); // Firebase tarafından oluşturulan ID'yi güncelle
      fetchProducts(); // Fetch products again to update the list
    } catch (e) {
      Get.snackbar("Error", "Failed to add product: $e");
    }
  }

  void updateProduct(ProductModel product) async {
    try {
      await firestore
          .collection('products')
          .doc(product.id)
          .update(product.toJson());
      fetchProducts(); // Fetch products again to update the list
    } catch (e) {
      Get.snackbar("Error", "Failed to update product: $e");
    }
  }

  void deleteProduct(String productId) async {
    try {
      await firestore.collection('products').doc(productId).delete();
      fetchProducts(); // Fetch products again to update the list
    } catch (e) {
      Get.snackbar("Error", "Failed to delete product: $e");
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<String?> uploadImage() async {
    if (selectedImage.value == null) return null;

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child(fileName);
      await storageRef.putFile(selectedImage.value!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image: $e");
      return null;
    }
  }
}
