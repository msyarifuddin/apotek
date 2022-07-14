import 'package:apotek/app/modules/home/controllers/home_controller.dart';
import 'package:apotek/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AmbilobatView extends GetView {
  HomeController homeCtrl = Get.put(HomeController());
  LoginController loginCtrl = Get.put(LoginController());

  @override
  MobileScannerController controllerMSC = MobileScannerController(
    torchEnabled: false,
    // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              // RotatedBox(
              // quarterTurns: 1,
              // child:
              Center(
                child: MobileScanner(
                  controller: controllerMSC,
                  fit: BoxFit.fill,
                  // allowDuplicates: true,
                  // controller: MobileScannerController(
                  //   torchEnabled: true,
                  //   facing: CameraFacing.front,
                  // ),
                  onDetect: (xbarcode, args) {
                    // setState(() {
                    homeCtrl.barcode?.value = xbarcode.rawValue!;
                    // final splitx = homeCtrl.barcode?.value.split("#");
                    // print(splitx![0]);
                    loginCtrl.updateDisplay(
                        loginCtrl.urlUpdate.value, xbarcode.rawValue!);
                    // FlutterBeep.beep(false);
                    // });
                  },
                ),
                // ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 100,
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       color: Colors.white,
                      //       icon: ValueListenableBuilder(
                      //         valueListenable: controllerMSC.torchState,
                      //         builder: (context, state, child) {
                      //           if (state == null) {
                      //             return const Icon(
                      //               Icons.flash_off,
                      //               color: Colors.grey,
                      //             );
                      //           }
                      //           switch (state as TorchState) {
                      //             case TorchState.off:
                      //               return const Icon(
                      //                 Icons.flash_off,
                      //                 color: Colors.grey,
                      //               );
                      //             case TorchState.on:
                      //               return const Icon(
                      //                 Icons.flash_on,
                      //                 color: Colors.yellow,
                      //               );
                      //           }
                      //         },
                      //       ),
                      //       iconSize: 32.0,
                      //       onPressed: () => controllerMSC.toggleTorch(),
                      //     ),
                      //     Text("Flash")
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       color: Colors.white,
                      //       icon: homeCtrl.isStarted.value
                      //           ? const Icon(Icons.stop)
                      //           : const Icon(Icons.play_arrow),
                      //       iconSize: 32.0,
                      //       onPressed: () {
                      //         homeCtrl.isStarted.value
                      //             ? controllerMSC.stop()
                      //             : controllerMSC.start();
                      //         homeCtrl.isStarted.value =
                      //             !homeCtrl.isStarted.value;
                      //       },
                      //       // setState(() {
                      //       //   isStarted ? controller.stop() : controller.start();
                      //       //   isStarted = !isStarted;
                      //       // }),
                      //     ),
                      //     Text("Pause")
                      //   ],
                      // ),
                      Obx(() => Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 200,
                              height: 50,
                              child: FittedBox(
                                child: Text(
                                  homeCtrl.barcode?.value ?? 'Scan something!',
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            color: Colors.white,
                            icon: ValueListenableBuilder(
                              valueListenable: controllerMSC.cameraFacingState,
                              builder: (context, state, child) {
                                if (state == null) {
                                  return const Icon(Icons.camera_front);
                                }
                                switch (state as CameraFacing) {
                                  case CameraFacing.front:
                                    return const Icon(Icons.camera_front);
                                  case CameraFacing.back:
                                    return const Icon(Icons.camera_rear);
                                }
                              },
                            ),
                            iconSize: 32.0,
                            onPressed: () => controllerMSC.switchCamera(),
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       color: Colors.white,
                      //       icon: const Icon(Icons.image),
                      //       iconSize: 32.0,
                      //       onPressed: () async {
                      //         final ImagePicker _picker = ImagePicker();
                      //         // Pick an image
                      //         final XFile? image = await _picker.pickImage(
                      //           source: ImageSource.gallery,
                      //         );
                      //         if (image != null) {
                      //           if (await controllerMSC
                      //               .analyzeImage(image.path)) {
                      //             // if (!mounted) return;
                      //             ScaffoldMessenger.of(context).showSnackBar(
                      //               const SnackBar(
                      //                 content: Text('Barcode found!'),
                      //                 backgroundColor: Colors.green,
                      //               ),
                      //             );
                      //           } else {
                      //             // if (!mounted) return;
                      //             ScaffoldMessenger.of(context).showSnackBar(
                      //               const SnackBar(
                      //                 content: Text('No barcode found!'),
                      //                 backgroundColor: Colors.red,
                      //               ),
                      //             );
                      //           }
                      //         }
                      //       },
                      //     ),
                      //     Text("Image")
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
