import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'mvvm/view/view.dart';

class QrApp extends StatelessWidget {
  const QrApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      useInheritedMediaQuery: true,
      builder:  (BuildContext context, Widget? child) {

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QR Code App',
          theme: ThemeData.dark(),
          home: QrScreen(),
        );
      },

    );
  }
}
