// ignore_for_file: prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        isLoading.value = true;
        Map<String, dynamic> data = await _determinePosition();
        if (data['error'] != true) {
          Position position = data['position'];

          List<Placemark> placemark = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String address = "${placemark[0].street}, "
              "${placemark[0].subLocality}, "
              "${placemark[0].locality}, ";

          // Presensi
          await updatePosition(position, address);
          await presensi(position, address);
        } else {
          Get.snackbar("Tejadi Kesalahan", data['message']);
        }

        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(Position position, String address) async {
    String uid = auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    // Get tgl waktu sekarang
    // year-month-day
    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    if (snapPresence.docs.length == 0) {
      // Belum pernah absen & set absen masuk
      await colPresence.doc(todayDocID).set({
        "date": now.toIso8601String(),
        "masuk": {
          "date": now.toIso8601String(),
          "lat": position.latitude,
          "long": position.longitude,
          "address": address,
          "status": "Di dalam area"
        }
      });
      Get.snackbar("Success", "Berhasil mengisi daftar hadir",
          backgroundColor: Colors.green[200], colorText: Colors.black87);
    } else {
      // sudah pernah absen -> cek hari ini apakah sudah absen masuk/keluar atau belum
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocID).get();

      if (todayDoc.exists == true) {
        // tinggal absen keluar atau sudah absen masuk & keluar
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?["keluar"] != null) {
          // sudah absen masuk && keluar
          Get.snackbar("Sukses", "Anda sudah absen masuk dan keluar");
        } else {
          // absen keluar
          await colPresence.doc(todayDocID).update({
            "keluar": {
              "date": now.toIso8601String(),
              "lat": position.latitude,
              "long": position.longitude,
              "address": address,
              "status": "Di dalam area"
            }
          });
          Get.snackbar("Sukses", "Anda sudah absen keluar",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;

    await firestore.collection("pegawai").doc(uid).update({
      "position": {"lat": position.latitude, "long": position.longitude},
      'address': address
    });
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLoading.value = false;
      return {
        'error': true,
        'message': 'Aktifkan izin lokasi untuk aplikasi ini.',
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isLoading.value = false;
        return {
          'error': true,
          'message': 'Aktifkan izin lokasi untuk aplikasi ini.',
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      isLoading.value = false;

      return {
        'error': true,
        'message': 'Aktifkan izin lokasi untuk aplikasi ini.',
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();

    Future.delayed(const Duration(seconds: 4), () {
      isLoading.value = false;
    });

    return {
      'error': false,
      'position': position,
      'message': 'Location is available'
    };
  }
}
