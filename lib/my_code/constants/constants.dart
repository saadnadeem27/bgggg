import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

RxInt indexScreen = 0.obs;
SharedPreferences? prefs;
var dragGesturePosition = Offset.zero.obs;
var isMagnifierShow = false.obs;
var resultantBase64 = ''.obs;
var actualBase64image= ''.obs;
var maskBase64image = ''.obs;
var maskImageFile = Rx<File?>(null);
Rx<Uint8List?> beforeImageData = Rx<Uint8List?>(null);
Rx<Uint8List?> afterImageData = Rx<Uint8List?>(null);
var dialogContext = Rx<BuildContext?>(null);
var actualCompressImgBase64 = ''.obs;
var maskCompressImgBase64 = ''.obs;
var newHeight=0.0.obs;
var newWidth=0.0.obs;




// var resultantImages = [].obs;
// final RxList<ImageBackgroundDrawable> backgroundImages = <ImageBackgroundDrawable>[].obs;
// final RxList<ImageBackgroundDrawable> redoImages =
//     <ImageBackgroundDrawable>[].obs;


// Rx<File?> pickedImageFileGallery = Rx<File?>(null);
// var actualedBase64image = ''.obs;

// var backgrounddImage = Rx<Image?>(null);
// var controlller = Rx<PainterController?>(null);
// var reallImg = Rx<ImageBackgroundDrawable?>(null);

// var actualImgDrawable;
void updateStatusBarColor() {
  final Brightness brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  if (brightness == Brightness.dark) {
    // isDarkMode.value = true;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  } else {
    // isDarkMode.value = false;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
}

void showtoast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
