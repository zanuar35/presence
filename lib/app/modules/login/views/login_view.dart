import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 250,
            color: Colors.blue[600],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Presence Apps",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: .7,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  "PT. ABC",
                  style: TextStyle(
                      color: Color(0xffecf0f1),
                      fontSize: 15,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: [
              Text(
                "Log in",
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              inputTextField(
                hintText: "Email",
                label: "Email",
                isSecure: false,
                controller: controller.emailC,
              ),
              SizedBox(height: 20),
              inputTextField(
                hintText: "Password",
                label: "Password",
                isSecure: true,
                controller: controller.passC,
              ),
              SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff256EF1),
                      fixedSize: Size(double.infinity, 50)),
                  onPressed: () async {
                    if (controller.isLoading.isFalse) {
                      await controller.login();
                    }
                  },
                  child: Text(
                    controller.isLoading.isFalse ? "Login" : "Loading...",
                    style: TextStyle(
                        fontSize: 14,
                        letterSpacing: .5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                child: Text(
                  "Lupa Password ?",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Color(0xFF9D9D9D)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inputTextField(
      {required String hintText,
      required label,
      required bool isSecure,
      required TextEditingController controller}) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      // margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey, width: 1.3),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 14,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF9D9D9D)),
          label: Text(
            label,
            style: TextStyle(color: Color(0xFF9D9D9D), fontSize: 14),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
