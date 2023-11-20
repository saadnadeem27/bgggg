import 'package:custom_pkg_obj_remove/my_code/constants/colors.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/main_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/views/dashboard_screen.dart';
import 'package:custom_pkg_obj_remove/my_code/views/select_photos_screen.dart';
import 'package:custom_pkg_obj_remove/my_code/views/settings_screen.dart';
import 'package:custom_pkg_obj_remove/my_code/widgets/choose_task_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final mainController = Get.put(MainController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 132.h),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 24.sp, bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 53.h,
                ),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lorem ipsum dolor sit amet, consetetur \nsadipscing elitr, sed diam nonumy eirmod',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.sp,
                          color: Colors.white),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const SettingsScreen()));
                            Get.to(const SettingsScreen());
                          },
                          child:
                              const Icon(Icons.settings, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose Task',
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      //indexScreen.value = 0;
                      // print(indexScreen.value);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => DashboardScreen(
                      //               screenIndex: 0,
                      //             )));
                      mainController.getIndex(0);
                      Get.to( DashboardScreen(
                          // screenIndex: 0,
                          ));
                    },
                    child: const ChooseTaskContainer(
                      firstText: 'Object',
                      secondText: 'Remover',
                      svgIcon: 'assets/icons/obj_rem.svg',
                      colors: [
                        Color(0xffEB6768),
                        Color(0xffE54648),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //indexScreen.value = 1;
                      //print(indexScreen.value);

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DashboardScreen(
                      //       screenIndex: 1,
                      //     ),
                      //   ),
                      // );
                      mainController.getIndex(1);

                      Get.to( DashboardScreen(
                          //  screenIndex: 1,
                          ));
                    },
                    child: const ChooseTaskContainer(
                      firstText: 'AI Photo',
                      secondText: 'Enhance',
                      svgIcon: 'assets/icons/ai_in.svg',
                      colors: [
                        Color(0xff92D1F6),
                        Color(0xff73BCE9),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // indexScreen.value = 2;
                      //print(indexScreen.value);

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => DashboardScreen(
                      //               screenIndex: 2,
                      //             )));
                      mainController.getIndex(2);

                      Get.to( DashboardScreen(
                          //  screenIndex: 2,
                          ));
                    },
                    child: const ChooseTaskContainer(
                      firstText: 'Background',
                      secondText: 'Remover',
                      svgIcon: 'assets/icons/rem_bg.svg',
                      colors: [
                        Color(0xff818DF7),
                        Color(0xff6472E6),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 116.h,
              ),
              Text(
                'Let’s Start',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              const Text(
                'Lorm ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod ',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 37.h,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const SelectPhotosScreen(),
                  //   ),
                  // );
                  Get.to(const SelectPhotosScreen());
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(42.sp, 13.sp, 47.sp, 13.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: RichText(
                    text: const TextSpan(children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(text: 'ADD PHOTO'),
                    ]),
                    // child: const Text(
                    //   ' ADD PHOTO',
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontFamily: 'Poppins',
                    //       fontWeight: FontWeight.w600),
                    // ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
