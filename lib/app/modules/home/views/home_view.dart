import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/controllers/page_index_controller.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              String defaultImage =
                  "https://ui-avatars.com/api/?name=${user['name']}?background=45b6ff&color=000";
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                            width: 75,
                            height: 75,
                            color: Colors.grey[200],
                            child: Image.network(
                              user["profile"] ?? defaultImage,
                              fit: BoxFit.cover,
                            )),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "welcome back",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 181, 182, 183)),
                          ),
                          SizedBox(height: 2),
                          SizedBox(
                            width: 200,
                            child: Text(
                                user['address'] != null
                                    ? "${user['name']}"
                                    : 'Belum ada Lokasi',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: .8),
                                overflow: TextOverflow.clip),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xff256EF1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['job'].toUpperCase(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Text(
                          user['nip'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          user['address'],
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff548DF4)),
                    child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller.streamTodayPresence(),
                        builder: (context, snapToday) {
                          if (snapToday.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          Map<String, dynamic>? dataToday =
                              snapToday.data?.data();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text("Masuk",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    dataToday?["masuk"] == null
                                        ? "-"
                                        : DateFormat.jms().format(
                                            DateTime.parse(
                                                dataToday!["masuk"]['date']),
                                          ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 40,
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  Text("Keluar",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    dataToday?["keluar"] == null
                                        ? "-"
                                        : DateFormat.jms().format(
                                            DateTime.parse(
                                                dataToday!["keluar"]['date']),
                                          ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(thickness: 2, color: Colors.grey[200]),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Last 5 Days",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.ALL_PRESENSI);
                          },
                          child: Text("See more")),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.streamLastPresence(),
                      builder: (context, snapPresence) {
                        if (snapPresence.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapPresence.data!.docs.isEmpty ||
                            snapPresence.data == null) {
                          return Center(
                            child: Text(
                              "Belum ada presensi",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapPresence.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data =
                                snapPresence.data!.docs[index].data();
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue[200],
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      Get.toNamed(Routes.DETAIL_PRESENSI,
                                          arguments: data);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Masuk",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                    DateFormat.yMMMEd().format(
                                                        DateTime.parse(
                                                            data['date'])),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            Text(data['masuk']?['date'] == null
                                                ? "-"
                                                : DateFormat.jms().format(
                                                    DateTime.parse(data['masuk']
                                                        ?['date']))),
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
                                                          data['keluar']
                                                              ?['date'])),
                                            ),
                                          ],
                                        )),
                                  ),
                                ));
                          },
                        );
                      })
                ],
              );
            } else {
              return Center(
                child: Text('Data tidak ditemukan'),
              );
            }
          }),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(
              icon: controller.isLoading.isTrue
                  ? Icons.accessible_forward
                  : Icons.fingerprint_rounded,
              title: 'Add'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
