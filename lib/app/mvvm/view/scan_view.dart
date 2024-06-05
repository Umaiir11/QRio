import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../view_model/qr_scanner_controller.dart';

class ScanView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final QRController qrController = Get.put(QRController());
    return SafeArea(
      child: Scaffold(
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
              "Scan QR Generator",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                letterSpacing: .5,
              ),
            ),
          ),
          elevation: 7.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0), // Adjust radius as needed
                  topRight: Radius.circular(30.0), // Adjust radius as needed
                ),
                border: Border.all(
                  color: Colors.cyanAccent, // Set border color
                  width: 0.6, // Adjust border width
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Obx(
                        () => qrController.result.value != null
                        ? Padding(
                        padding: EdgeInsets.all(15.h),
                        child: GestureDetector(
                          onLongPress: qrController.copyToClipboard,
                          child: SelectableText(
                            'Result: ${qrController.result.value?.code}',
                            style: TextStyle(
                                fontSize: 16), // Adjust font size as needed
                          ),
                        ))
                        : Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: Colors.cyanAccent,
                          child: Text(
                            "Your result will appear  here",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              letterSpacing: .5,
                            ),
                          ),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: qrController.toggleFlash,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.cyanAccent,
                            ),
                            child: Text(
                                'Flash',
                                style:
                                TextStyle(color: Colors.black))),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: qrController.flipCamera,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.cyanAccent,
                            ),
                            child:Text(
                                'Camera Switch',
                                style:
                                TextStyle(color: Colors.black))),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: ElevatedButton(
                          onPressed: qrController.pauseCamera,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.cyanAccent,
                          ),
                          child: Text('pause',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(28.h),
                        child: ElevatedButton(
                          onPressed: qrController.resumeCamera,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.cyanAccent,
                          ),
                          child: Text('resume',
                              style: TextStyle(color: Colors.black)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    final QRController qrController = Get.find<QRController>();
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 340.h
        : 400.0;
    return QRView(
      key: qrController.qrKey,
      onQRViewCreated: qrController.onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.cyanAccent,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 7,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) =>
          qrController.onPermissionSet(context, ctrl, p),
    );
  }
}
