import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
            icon: Icon(Icons.person),
          )
        ],
      ),
      body: Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () async {
            if (controller.isLoading.isFalse) {
              controller.isLoading.value = true;
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(Routes.LOGIN);
              controller.isLoading.value = false;
            }
          },
          child: controller.isLoading.isFalse
              ? Icon(Icons.logout_rounded)
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
