

import 'dart:ui';
import 'package:custom_pkg_obj_remove/my_code/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

void processDialog() {
  showDialog(
    context: dialogContext.value!,
    barrierDismissible: false, // Prevent the user from dismissing the dialog
    builder: (_) {
      return Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.5),
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: SizedBox(
            width: MediaQuery.of(dialogContext.value!).size.width,
            height: MediaQuery.of(dialogContext.value!).size.height,
            child: const Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                  // child: Lottie.asset(
                  //   'assets/json/loading.json',
                  //   // Replace with your animation file path
                  //   height: 200.h,
                  //   width: 200.w,
                  // ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

