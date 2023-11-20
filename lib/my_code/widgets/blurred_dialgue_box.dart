import 'dart:ui';
import 'package:custom_pkg_obj_remove/my_code/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showBlurredDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Stack(
        children: [
          // Blurred Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity and color
              constraints: const BoxConstraints.expand(),
            ),
          ),
          // Dialog Box
          AlertDialog(
            titlePadding: EdgeInsets.only(top: 50.h, bottom: 5.h),
            title: Text(
              'Save Changes?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff292929),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Do you want to save your current image?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 27.h,
                ),
                MaterialButton(
                  onPressed: () async {
                    //function call
                    // removeObject();
                  },
                  height: 45.h,
                  minWidth: 155.w,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Color.fromARGB(255, 208, 208, 208),
                      ),
                      borderRadius: BorderRadius.circular(24.r)),
                  color: AppColors.primaryColor,
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 9.h,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  height: 45.h,
                  minWidth: 155.w,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromARGB(255, 208, 208, 208),
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  color: const Color(0xffDEDEDE),
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
