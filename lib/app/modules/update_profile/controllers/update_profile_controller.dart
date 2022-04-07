import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  RxBool isLoading = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        firestore.collection("pegawai").doc(uid).update({"name": nameC.text});
        Get.snackbar("Success", "Berhasil Update profile");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", 'tidak dapat update profile');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
