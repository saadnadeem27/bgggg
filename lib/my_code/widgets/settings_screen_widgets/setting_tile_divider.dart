import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingTileDivider extends StatelessWidget {
  const SettingTileDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.1,
      color: const Color.fromARGB(233, 139, 139, 139).withOpacity(0.25),
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
