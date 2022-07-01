import 'package:apotek/app/modules/login/controllers/login_controller.dart';
import 'package:apotek/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  LoginController loginC = Get.put(LoginController());
  HomeController homeC = Get.put(HomeController());
  // final loginC = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Display Obat'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              loginC.logout();
            },
            icon: Icon(Icons.logout_sharp),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Scan Barcode',
                  style: TextStyle(fontSize: 36),
                ),
                SizedBox(
                  height: 40,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     loginC.urlUpdate.value = 'UpdateAmbilObat';
                //     Get.toNamed(Routes.AMBILOBAT);
                //   },
                //   child: Text("Pengambilan Obat"),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                ElevatedButton(
                  onPressed: () {
                    loginC.urlUpdate.value = 'UpdateVerifObat';
                    Get.toNamed(Routes.AMBILOBAT);
                  },
                  child: Text("Verifikasi Obat"),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 60),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    loginC.urlUpdate.value = 'UpdateSerahObat';
                    Get.toNamed(Routes.AMBILOBAT);
                  },
                  child: Text("Penyerahan Obat"),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 60),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
