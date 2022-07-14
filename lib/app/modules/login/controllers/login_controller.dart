import 'dart:convert';

import 'package:apotek/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  HomeController homeC = Get.put(HomeController());
  final url = 'http://192.168.0.12/apotek_rest/';
  RxString urlUpdate = "".obs;

  // RxBool updateStatus = false.obs;
  final boxToken = GetStorage();
  // main() async {
  //   await GetStorage.init();
  // }

  TextEditingController usernameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  var isHidden = true.obs;

  var isLoading = false.obs;

  var isAuth = false.obs;

  var isFront = false.obs;

  FlutterTts flutterTts = FlutterTts();

  void dialogError(String msg) {
    Get.defaultDialog(
      title: "Terjadi Kesalahan",
      middleText: msg,
    );
  }

  void snackbarError(String msg) {
    Get.snackbar(
      "Error",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
    );
  }

  @override
  void onInit() async {
    super.onInit();
    await GetStorage.init();
    if (boxToken.read("access_token") != null) {
      print("1.ada getx storage");
      print("2.username=" + boxToken.read("username"));
      print("3.password=" + boxToken.read("password"));
      print("4.exp=" + boxToken.read("exp"));
      print("5.token=" + boxToken.read("access_token"));
      // print("exp=" + DateTime.parse(boxToken.read("exp")).toString());
      print("6.now=" + DateTime.now().millisecondsSinceEpoch.toString());
      //update token
      if (int.parse(boxToken.read("exp")) >
          DateTime.now().millisecondsSinceEpoch.toInt()) {
        print("7.perpanjang");
        //perpanjang token
        isAuth.value = true;
        login(boxToken.read("username"), boxToken.read("password"));
      } else {
        print("7.logout");
        isAuth.value = false;
      }
    } else {
      isAuth.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void login(String username, String password) async {
    isLoading.value = true;
    if (username != '' && password != '') {
      var response = await http.post(
        Uri.parse(url + 'otentikasi'),
        body: {
          "username": username,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        //berhasil
        print(response.body);
        Map<String, dynamic> dataToken =
            json.decode(response.body) as Map<String, dynamic>;
        print(dataToken['data']['exp'].toString());
        boxToken.write("username", username);
        boxToken.write("password", password);
        boxToken.write("access_token", dataToken['access_token'].toString());
        boxToken.write("exp", dataToken['data']['exp'].toString());
        isAuth.value = true;
        // Get.offAllNamed(Routes.HOME);
      } else {
        dialogError("Error Get Token");
      }
      // var response = await Get.http
    } else {
      dialogError("Semua data harus diisi");
    }
    isLoading.value = false;
  }

  void logout() {
    boxToken.remove("username");
    boxToken.remove("password");
    boxToken.remove("access_token");
    boxToken.remove("exp");
    isAuth.value = false;
    // Get.offAllNamed(Routes.LOGIN);
  }

  Future speakApotek(String teks) async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setPitch(1);
    await flutterTts.setVolume(1);
    print(await flutterTts.getLanguages);
    print(await flutterTts.getVoices);
    print(await flutterTts.getEngines);
    await flutterTts.speak(teks
        // "Panggilan Bapak Edwin Tri Hadnanto, Poli Bedah Urologi!",
        );
  }

  void updateDisplay(String urlUpdate, String no_out) async {
    if (urlUpdate != '' && no_out != '') {
      print(urlUpdate);
      print(no_out);
      print(boxToken.read('access_token'));
      isLoading.value = true;
      String urlfinal = url + 'obat/' + urlUpdate;
      print(urlfinal);
      try {
        var response = await http.put(Uri.parse(urlfinal), body: {
          "no_out": no_out,
        }, headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          // 'Accept': 'application/json',
          'Authorization': 'Bearer ${boxToken.read("access_token")}',
        });
        if (response.statusCode == 200) {
          //berhasil
          print(response.body);
          FlutterBeep.beep(false);
          // FlutterBeep.playSysSound(41);
          // homeC.barcode?.value = "";
          // String? nomor = homeC.barcode?.value;
          // homeC.barcode?.value = (nomor! + " berhasil dipindai");
          homeC.barcode?.value = " berhasil dipindai";
          // if (urlUpdate == "UpdateSerahObat") {
          Map<String, dynamic> dataPasien =
              json.decode(response.body) as Map<String, dynamic>;
          speakApotek("Panggilan " +
              dataPasien['datapasien']['cast'].toString() +
              " " +
              dataPasien['datapasien']['nmpasien'].toString() +
              " dari poli " +
              dataPasien['datapasien']['nama_unit'].toString());
          // }
        } else {
          snackbarError("Error Connection");
          print(response.statusCode);
          print(response.body);
          FlutterBeep.beep();
        }
        isLoading.value = false;
      } catch (e) {
        print(e);
        no_out = "";
        homeC.barcode?.value = "";
        // snackbarError(e.toString());
        Get.snackbar(
          "Error",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
        );
        FlutterBeep.beep();
      }
    } else {
      snackbarError("Semua data harus diisi");
    }
  }
}
