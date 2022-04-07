import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  TextEditingController currC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if (currC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confirmC.text.isNotEmpty) {
      if (newC.text == confirmC.text) {
        isLoading.value = true;
        try {
          // Update password
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: currC.text);

          await auth.currentUser!.updatePassword(newC.text);

          Get.back();
          Get.snackbar("Berhasil", "Password berhasil diubah",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Color.fromARGB(255, 88, 88, 88),
              colorText: Colors.white);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar('Error', 'Wrong Password',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Color.fromARGB(255, 137, 137, 137),
                colorText: Colors.white);
          } else {
            Get.snackbar("Kesalahan", e.code);
          }
        } catch (e) {
          Get.snackbar("Kesalahan", "Update password gagal",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Color.fromARGB(255, 137, 137, 137),
              colorText: Colors.white);
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Kesalahan", "Confirm password tidak cocok",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color.fromARGB(255, 137, 137, 137),
            colorText: Colors.white);
      }
    } else {
      Get.snackbar("Kesalahan", 'Input harus diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 137, 137, 137),
          colorText: Colors.white);
    }
  }
}
