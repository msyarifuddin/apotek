import 'package:apotek/app/modules/home/views/home_view.dart';
import 'package:apotek/app/modules/login/controllers/login_controller.dart';
import 'package:apotek/app/modules/login/views/login_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final loginC = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Display Obat Apotek Sentral",
        home: loginC.isAuth.isTrue ? HomeView() : LoginView(),
        // initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  }
}
