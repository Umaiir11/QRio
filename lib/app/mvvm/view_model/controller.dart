import 'dart:ui';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:get/get.dart'; // Import GetX package

class HomeController extends GetxController {
  var data = ''.obs;
  GlobalKey qrImageKey = GlobalKey();

  void setData(String newData) {
    data.value = newData;
  }

  void saveQrToGallery() async {
    RenderRepaintBoundary boundary =
    qrImageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(buffer);
    if (result['isSuccess']) {
      Fluttertoast.showToast(
        msg: "QR code downloaded successfully. Please check your gallery.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
        webShowClose: true,
        webBgColor: "#333333",
      );
      print("QR code saved to gallery");
    } else {
      print("Failed to save QR code to gallery");
      Fluttertoast.showToast(
        msg: "Failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
        webShowClose: true,
        webBgColor: "#333333",
      );
    }
  }

  Future<void> shareQrCodeImage() async {
    if (data.value.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill the text before sharing.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
        webShowClose: true,
        webBgColor: "#333333",
      );
      return;
    }

    RenderRepaintBoundary boundary =
    qrImageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    try {
      await Share.file(
        'QR Code Image',
        'QR_Code.png',
        buffer,
        'image/png',
        text:
        'Check out this QR code!, Developed By Umair Hashmi @iam.umairimran@gmail.com',
      );
    } catch (e) {
      print("Error sharing: $e");
    }
  }
}