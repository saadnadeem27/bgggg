import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class AppbarIconContainer extends StatelessWidget {
  final String iconName;
  final String text;
  final Function()? onPressed;
  double iconHeight;
  double iconWidth;
   AppbarIconContainer(
      {super.key,
      required this.iconName,
      required this.text,
      required this.onPressed,
      this.iconHeight = 23,
      this.iconWidth = 23,

      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:8.w),
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          width: 50.w,
          child: Column(
            mainAxisSize: 
            MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/$iconName.svg',
                width: iconWidth.w,
                height: iconHeight.h,
              ),
              SizedBox(
                height: 11.h,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
