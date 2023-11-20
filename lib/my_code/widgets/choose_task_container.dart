import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChooseTaskContainer extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String svgIcon;
  final List<Color> colors;

  const ChooseTaskContainer(
      {super.key,
      required this.firstText,
      required this.secondText,
      required this.svgIcon,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102.h,
      width: 100.w,
      padding: EdgeInsets.only(top: 16.sp, bottom: 10.sp, left: 12.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: colors,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            svgIcon,
            width: 30,
            height: 30,
            // colorFilter:  ColorFilter.mode(
            //   Colors.white
            // //  BlendMode.color,
            // ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            '$firstText\n$secondText',
            style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
