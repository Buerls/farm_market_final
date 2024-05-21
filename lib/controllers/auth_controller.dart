// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  var isSignedIn = false.obs;
  var userId = ''.obs;
  var userName = ''.obs; // Kullanıcı adını saklamak için değişken
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isSignedIn.value = false;
        userId.value = '';
        userName.value =
            ''; // Kullanıcı çıkış yaptığında kullanıcı adını temizle
      } else {
        isSignedIn.value = true;
        userId.value = user.uid;
        fetchUserName(); // Kullanıcı adını getir
      }
    });
  }

  void fetchUserName() async {
    if (userId.value.isNotEmpty) {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId.value).get();
      userName.value = userDoc['name'];
    }
  }

  void register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        userId.value = user.uid;
        userName.value = name; // Kullanıcı adını ayarla
        // User kaydı
        await firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': name,
          'email': email,
        });
        Get.offAllNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An unknown error occurred.");
    }
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An unknown error occurred.");
    }
  }

  void signOut() async {
    await auth.signOut();
    Get.offAllNamed('/login');
  }
}
