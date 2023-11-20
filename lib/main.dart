import 'dart:convert';

import 'package:custom_pkg_obj_remove/my_code/constants/colors.dart';
import 'package:custom_pkg_obj_remove/my_code/constants/constants.dart';
import 'package:custom_pkg_obj_remove/my_code/firebase_options.dart';
import 'package:custom_pkg_obj_remove/my_code/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

Future<void> initremoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig
      .setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(seconds: 1),
  ))
      .whenComplete(() async {
    await remoteConfig.fetch().whenComplete(() async {
      await remoteConfig.activate().whenComplete(() async {
        prefs!.setString('basic_auth',
            'Basic ${base64Encode(utf8.encode('${remoteConfig.getString('username')}:${remoteConfig.getString('password')}'))}');
        if (kDebugMode) {
          print('auth : ${prefs!.getString('basic_auth')}');
        }
      });
    });
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initremoteConfig();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Object removal',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            hintColor: AppColors.textHintLight,
            shadowColor: Colors.grey.withOpacity(0.4),
            scaffoldBackgroundColor: AppColors.backgroundLight,
            // textTheme: TextTheme(
            //   displayLarge: TextStyle(
            //     fontSize: 24.sp,
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w700,
            //     color: AppColors.textDark,
            //   ),
            //   displayMedium: TextStyle(
            //     fontSize: 24.sp,
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w300,
            //     color: AppColors.textDark,
            //   ),
            //   titleLarge: TextStyle(
            //     fontSize: 24.sp,
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w500,
            //     color: AppColors.textDark,
            //   ),
            //   titleMedium: TextStyle(
            //     color: AppColors.textDark,
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w600,
            //     fontSize: 14.sp,
            //   ),
            //   titleSmall: TextStyle(
            //     color: AppColors.textDark,
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w500,
            //     fontSize: 14.sp,
            //   ),
            //   bodyLarge: TextStyle(
            //     color: AppColors.textDark,
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w600,
            //     fontSize: 18.sp,
            //   ),
            //   bodyMedium: TextStyle(
            //     color: AppColors.textDark,
            //     fontFamily: 'Poppins',
            //     height: 1.25,
            //     fontWeight: FontWeight.w400,
            //     fontSize: 12.sp,
            //   ),
            //   bodySmall: TextStyle(
            //     color: AppColors.textHintLight,
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w400,
            //     fontSize: 10.sp,
            //   ),
            //   labelMedium: TextStyle(
            //     color: AppColors.textHintLight,
            //     fontFamily: 'Poppins',
            //     fontWeight: FontWeight.w500,
            //     fontSize: 10.sp,
            //   ),
            // ),
            cardColor: AppColors.accentLight,
            bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: AppColors.bottomSheetLight),
            fontFamily: 'Poppins',
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
              primaryContainer: AppColors.primaryContainerLight,
              secondaryContainer: AppColors.secondaryContainerLight,
              surface: AppColors.surfaceLight,
              tertiaryContainer: AppColors.tertiaryContainerLight,
              tertiary: AppColors.tertiaryLight,
              inversePrimary: AppColors.disableLight,
            ),
            primaryColor: AppColors.primarySwatch,
            useMaterial3: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
