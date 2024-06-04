import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../view_model/controller.dart';


class QrScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 42,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF000000),
                Color(0xFF000000),
                Color(0xFF000000),
                Color(0xFF000000),
              ],
            ),
          ),
        ),
        title: Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Colors.cyanAccent,
          child: Text(
            "Custom QR Generator",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              letterSpacing: .5,
            ),
          ),
        ),
        elevation: 7.0,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF000000),
                Color(0xFF000000),
                Color(0xFF000000),
                Color(0xFF000000),
              ],
              stops: [0.1, 0.5, 0.7, 0.9],
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => RepaintBoundary(
                  key: controller. qrImageKey,
                  child: QrImageView(
                    data: controller.data.value,
                    version: QrVersions.auto,
                    size: 230.0,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.Q,
                  ),
                )),
                const SizedBox(height: 15),
                SizedBox(
                  width: 200,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Type the Data",
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.black38,
                          fontWeight: FontWeight.normal,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      onChanged: controller.setData,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your data';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (controller.data.isNotEmpty) {
                          controller.saveQrToGallery();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: Colors.cyanAccent,
                    ),
                    child: Text(
                      "Gen QR Code",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.shareQrCodeImage();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: Colors.cyanAccent,
                    ),
                    child: Text(
                      "Share",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
