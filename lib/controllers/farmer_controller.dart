// lib/controllers/farmer_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/farmer_model.dart';

class FarmerController extends GetxController {
  var farmers = <FarmerModel>[].obs;
  var searchResults = <FarmerModel>[].obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchFarmers();
  }

  void fetchFarmers() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('farmers').get();
      farmers.value = snapshot.docs
          .map(
              (doc) => FarmerModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch farmers: $e");
    }
  }

  void searchFarmers(String query) {
    searchResults.value = farmers
        .where((farmer) =>
            farmer.name.toLowerCase().contains(query.toLowerCase()) ||
            farmer.shopName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
