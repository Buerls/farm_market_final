// lib/controllers/login_controller.dart
import 'package:get/get.dart';

class LoginController extends GetxController {
  var rememberMe = false.obs;
  var isPasswordVisible = false.obs;

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
