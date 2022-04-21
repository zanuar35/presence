import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DetailPresensiView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DetailPresensiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
