import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SettingListTile extends StatelessWidget {
  final String title;
  final String iconName;
  const SettingListTile({super.key,required this.iconName,required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      minVerticalPadding: 0,
      leading: SvgPicture.asset(
        'assets/icons/$iconName.svg',
      ),
      //contentPadding:  EdgeInsets.symmetric(horizontal: 30.w),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'Poppins',
          color: const Color(0xff070707),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: SvgPicture.asset('assets/icons/arrow_frwd.svg'),
    );
  }
}
