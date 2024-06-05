import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRController extends GetxController {
  var result = Rx<Barcode?>(null);
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void onInit() {
    super.onInit();
    if (GetPlatform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result.value = scanData;
    });
  }

  Future<void> toggleFlash() async {
    await controller?.toggleFlash();
  }

  Future<void> flipCamera() async {
    await controller?.flipCamera();
  }

  Future<void> pauseCamera() async {
    await controller?.pauseCamera();
  }

  Future<void> resumeCamera() async {
    await controller?.resumeCamera();
  }

  Future<bool?> getFlashStatus() async {
    return await controller?.getFlashStatus();
  }

  Future<CameraFacing?> getCameraInfo() async {
    return await controller?.getCameraInfo();
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  Future<void> copyToClipboard() async {
    if (result.value != null) {
      await Clipboard.setData(ClipboardData(
          text:
          'Result: ${describeEnum(result.value!.format)}   Data: ${result.value?.code}'));
      Get.snackbar('Copied', 'Result copied to clipboard',
          duration: Duration(seconds: 1));
    }
  }
}
