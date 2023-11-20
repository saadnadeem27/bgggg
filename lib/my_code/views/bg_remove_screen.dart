
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


class BgRemoveScreen extends StatefulWidget {
  const BgRemoveScreen({super.key});

  @override
  State<BgRemoveScreen> createState() => _BgRemoveScreenState();
}

class _BgRemoveScreenState extends State<BgRemoveScreen> {
  double strokeWidth = 0.5;
  //final imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 12.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remove the background of your image',
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
        //     child: const SizedBox.shrink(),

        //     //child: SizedBox.shrink(),
        //   )
        // ,
        // SizedBox(
        //   height: 20.h,
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 29.sp),
        //   child: Text(
        //     'Remove the background of your images with one touch',
        //     style: TextStyle(fontSize: 12.sp),
        //   ),
        // )
      ],
    );
  }
}
