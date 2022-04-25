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
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
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
                padding: EdgeInsets.all(20),
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
                            "Welcome",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 200,
                            child: Text(
                                user['address'] != null
                                    ? "${user['address']}"
                                    : 'Belum ada Lokasi',
                                style: TextStyle(height: 1.4),
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
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['job'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          user['nip'],
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          user['name'],
                          style: TextStyle(
                            fontSize: 18,
                          ),
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
                        color: Colors.grey[200]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("Masuk"),
                            Text("-"),
                          ],
                        ),
                        Container(
                          width: 2,
                          height: 40,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Text("Keluar"),
                            Text("-"),
                          ],
                        )
                      ],
                    ),
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
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200],
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Get.toNamed(Routes.DETAIL_PRESENSI);
                            },
                            child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            DateFormat.yMMMEd()
                                                .format(DateTime.now()),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Text(DateFormat.jms()
                                        .format(DateTime.now())),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Keluar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(DateFormat.jms()
                                        .format(DateTime.now())),
                                  ],
                                )),
                          ),
                        ),
                      );
                    },
                  )
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
