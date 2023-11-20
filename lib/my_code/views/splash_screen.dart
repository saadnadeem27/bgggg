import 'package:custom_pkg_obj_remove/my_code/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SvgPicture? svgIcon;

  @override
  void initState() {
    super.initState();

    // Load SVG icon during initialization
    svgIcon = SvgPicture.asset(
      'assets/icons/splash_icon.svg',
      width: 102.6,
      height: 89.78,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffE5716E),
            Color(0xffD85A5B),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 259.h,
              ),
              // SvgPicture.asset(
              //   'assets/icons/splash_icon.svg',
              //   width: 102.6,
              //   height: 89.78,
              // ),
              svgIcon != null ? svgIcon! : const SizedBox.shrink(),
              SizedBox(
                height: 29.h,
              ),
              Text(
                'Object Remover',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(
                height: 281.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const WelcomeScreen())));
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(47, 13, 47, 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: const Text(
                    'GET STARTED',
                    style: TextStyle(
                        color: Color(0xFFE5716E),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600),
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
