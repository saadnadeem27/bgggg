import 'package:custom_pkg_obj_remove/my_code/constants/colors.dart';
import 'package:custom_pkg_obj_remove/my_code/widgets/settings_screen_widgets/setting_list_tile.dart';
import 'package:custom_pkg_obj_remove/my_code/widgets/settings_screen_widgets/setting_tile_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 132.h,
            padding: EdgeInsets.only(top: 60.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: AppBar(
              toolbarHeight: 65.h,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
              elevation: 0,
              primary: false,
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.primaryColor,
              leading: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(right: 12.h),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/icons/back_icon.svg',
                      width: 19.w,
                      height: 19.h,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          Container(
            height: 107.h,
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 27.w,
              right: 54.w,
              top: 25.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffECF1F4),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 212, 211, 211), // Shadow color

                  offset: Offset(
                      0, 2.sp), // Offset of the shadow (horizontal, vertical)
                  blurRadius: 4, // Blur radius of the shadow
                  // Spread radius of the shadow (positive values expand the shadow, negative values shrink it)
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlimited Editing',
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: const Color(0xff242A37),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut.',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Poppins',
                    color: const Color(0xff070707),
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 21.h,
          ),
          Container(
            height: 210.h,
            decoration: BoxDecoration(
              color: const Color(0xffECF1F4),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 212, 211, 211), // Shadow color
                  offset: Offset(
                      0, 2.sp), // Offset of the shadow (horizontal, vertical)
                  blurRadius: 4, // Blur radius of the shadow
                  // Spread radius of the shadow (positive values expand the shadow, negative values shrink it)
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const Column(
                children: [
                  SettingListTile(
                    title: 'Privacy Policy',
                    iconName: 's_privacy_icon',
                  ),
                  SettingTileDivider(),
                  SettingListTile(
                    title: 'Terms & Conditions',
                    iconName: 's_terms_icon',
                  ),
                  SettingTileDivider(),
                  SettingListTile(
                    title: 'About Object Remover',
                    iconName: 's_about_icon',
                  ),
                  SettingTileDivider(),
                  SettingListTile(
                    title: 'Subscription Policy',
                    iconName: 's_policy_icon',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
