import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class PersonalDetailsController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveUserDetails(
      String userId, String name, String email, String address) async {
    UserModel user = UserModel(
      id: userId,
      name: name,
      email: email,
      address: address,
    );

    try {
      await firestore.collection('users').doc(userId).set(user.toJson());
      Get.snackbar("Success", "User details saved successfully");
      Get.offAllNamed(
          '/home'); // Kaydetme işlemi başarılı olursa ana sayfaya yönlendir
    } catch (e) {
      Get.snackbar("Error", "Failed to save user details");
    }
  }
}
