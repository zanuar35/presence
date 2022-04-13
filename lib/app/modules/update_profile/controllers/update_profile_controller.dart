import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  RxBool isLoading = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();
  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);

    update();
  }

  void deleteProfile(String uid) async {
    try {
      await firestore
          .collection("pegawai")
          .doc(uid)
          .update({"profile": FieldValue.delete()});
      Get.snackbar("Berhasil", "Foto profil berhasil dihapus");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat delete profile picture");
    } finally {
      update();
    }
  }

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "name": nameC.text,
        };
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split(".").last;

          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();

          data.addAll({"profile": urlImage});
        }
        await firestore.collection("pegawai").doc(uid).update(data);
        image = null;
        Get.snackbar("Success", "Berhasil Update profile");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", 'tidak dapat update profile');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
