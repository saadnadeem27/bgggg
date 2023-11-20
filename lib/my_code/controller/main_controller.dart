import 'dart:ui';
import 'package:custom_pkg_obj_remove/pkg/flutter_painter.dart';
import 'package:get/state_manager.dart';

class MainController extends GetxController{
  RxInt index = 0.obs;

 Rx<Image?> bgImg = Rx<Image?>(null);
 Rx<ImageBackgroundDrawable?> controllerBgImg = Rx<ImageBackgroundDrawable?>(null);
 Rx<ImageBackgroundDrawable?> realImage = Rx<ImageBackgroundDrawable?>(null);

  void getIndex(int val){
    index.value = val;
  }

  void getBgImg(Image val){
    bgImg.value = val;
  }

  void getControllerBgImg(ImageBackgroundDrawable val){
    controllerBgImg.value = val;
  }

  void getRealImg(ImageBackgroundDrawable val){
    realImage.value = val;
  }

}

