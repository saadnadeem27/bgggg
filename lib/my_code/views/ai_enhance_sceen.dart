
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AiEnhanceScreen extends StatefulWidget {
  const AiEnhanceScreen({super.key});

  @override
  State<AiEnhanceScreen> createState() => _AiEnhanceScreenState();
}

class _AiEnhanceScreenState extends State<AiEnhanceScreen> {
  // final imageController = Get.put(ImageController());

  double strokeWidth = 0.5;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 25.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enhance the clarity of your image',
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SvgPicture.asset(
                'assets/icons/info_icon.svg',
                width: 21.w,
                height: 21.h,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        // Container(
        //     height: 386.h,
        //     width: 327.w,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(12.r),
        //     ),
        //   child: SizedBox.shrink(),
        //     // child: SizedBox.shrink(),
        //   ),

        // SizedBox(
        //   height: 20.h,
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 29.sp),
        //   child: Text(
        //     'Enhance your art with noise and blurriness removal, saving it in high resolution',
        //     style: TextStyle(fontSize: 12.sp),
        //   ),
        // ),
      ],
    );
  }
}
