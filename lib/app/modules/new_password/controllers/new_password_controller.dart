import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController newPasswordC = TextEditingController();

  void newPassword() async {
    if (newPasswordC.text.isNotEmpty) {
      if (newPasswordC.text != "12345678") {
        try {
          await auth.currentUser!.updatePassword(newPasswordC.text);
          String email = auth.currentUser!.email!;

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email, password: newPasswordC.text);

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi Kesalahan",
                "Password yang anda masukan terlalu lemah");
          }
        } catch (e) {
          Get.snackbar(
              "Terjadi Kesalahan", "Terjadi kesalahan, silahkan coba lagi");
        }
      } else {
        Get.snackbar(
            "Error", "Password baru tidak boleh sama dengan password lama");
      }
    } else {
      Get.snackbar("Terjadi Kesalah", "Password baru wajib diisi");
    }
  }
}
