import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;
  RxBool isLoadingAddsPegawai = false.obs;

  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddsPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passAdminC.text);

        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "12345678");

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String()
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          // Login Ulang

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          print(userCredentialAdmin);

          // Close Dialog
          Get.back();

          // Back Home
          Get.back();
          Get.snackbar('Berhasil', 'Success Menambahkan Pegawai');
        }

        print(pegawaiCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang digunakan terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan",
              "Pegawai sudah ada, kamu tidak dapat menambahkan akun ini ");
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang anda masukkan salah");
        } else {
          Get.snackbar("Terjadi Kesalahan", e.code);
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan Pegawai");
      }
    } else {
      isLoading.value = false;
      Get.snackbar('Terjadi error', 'password wajib diisi untuk validasi');
    }
  }

  Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nipC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
          title: 'Validasi Admin',
          content: Column(
            children: [
              Text('Masukkan Password untuk validasi admin'),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: passAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  isLoading.value = false;
                  Get.back();
                },
                child: Text("Cancel")),
            Obx(
              () => ElevatedButton(
                  onPressed: () async {
                    if (isLoadingAddsPegawai.isFalse) {
                      await prosesAddPegawai();
                    }
                    isLoading.value = false;
                  },
                  child: Text(isLoadingAddsPegawai.isFalse
                      ? "Add Pegawai"
                      : "Loading")),
            )
          ]);
    } else {
      Get.snackbar("Terjadi Kesalahan", "NIP,Nama, dan email harus diisi");
    }
  }
}
