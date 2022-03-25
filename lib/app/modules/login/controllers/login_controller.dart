import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);
        print(userCredential);

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passC.text == "12345678") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
                title: " Belum Verifikasi",
                middleText:
                    "Kamu belum verifikasi akun ini. Lakukan verifikasi email kamu",
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      isLoading.value = false;
                      Get.back();
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await userCredential.user!.sendEmailVerification();
                        Get.back();
                        Get.snackbar(
                            "Berhasil", "Email verifikasi telah dikirim");
                        isLoading.value = false;
                      } catch (e) {
                        isLoading.value = false;
                        Get.snackbar("Terjadi Kesalahan",
                            "Tidak dapat mengirim email verifikasi");
                      }
                    },
                    child: Text("Kirim Ulang"),
                  )
                ]);
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "Email tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "Password Salah");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Email dan password wajib diisi");
    }
  }
}
