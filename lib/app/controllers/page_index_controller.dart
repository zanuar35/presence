import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

          await updatePosition(position, address);

          print(address);
          Get.snackbar("Success", "Berhasil Absen",
              backgroundColor: Colors.green[200], colorText: Colors.black87);
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
