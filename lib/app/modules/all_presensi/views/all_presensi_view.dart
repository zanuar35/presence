import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Semua Presensi'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 8,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Search..."),
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.streamAllPresence(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snap.data!.docs.isEmpty || snap.data == null) {
                      return SizedBox(
                        height: 150,
                        child: Center(
                          child: Text("Belum ada history presensi"),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      itemCount: snap.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            snap.data!.docs[index].data();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200],
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_PRESENSI,
                                    arguments: data);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Masuk",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              DateFormat.yMMMEd().format(
                                                  DateTime.parse(data['date'])),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Text(data['masuk']?['date'] == null
                                          ? "-"
                                          : DateFormat.jms().format(
                                              DateTime.parse(
                                                  data['masuk']?['date']))),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Keluar",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data['keluar']?['date'] == null
                                            ? '-'
                                            : DateFormat.jms().format(
                                                DateTime.parse(
                                                    data['keluar']?['date'])),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ));
  }
}
