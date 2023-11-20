import 'dart:io';
import 'dart:typed_data';
// import 'dart:ui';
import 'package:get/get.dart';
// import 'package:image/image.dart' as img;

class ObjectRemoveController extends GetxController {
  RxString objRemApiResponse = ''.obs;

  RxBool isPathEmpty=false.obs;

  RxList<int> objRemApiResponseBytes = <int>[].obs;

  RxBool isShowActualImage = true.obs;

  Rx<File?> imageFile = Rx<File?>(null);
  // Rx<img.Image?> paintedImg = Rx<img.Image?>(null);

  Rx<Uint8List?> actualImageMemorybytes = Rx<Uint8List?>(null);

  Rx<Uint8List?> mergedImageMemorybytes = Rx<Uint8List?>(null);

  RxBool isProcessing = false.obs;

  void getImageFile(File? file) {
    imageFile.value = file;
  }

  void getImageMemoryBytes(Uint8List bytes) {
    actualImageMemorybytes.value = bytes;
  }

  void getMergedImageMemoryBytes(Uint8List bytes) {
    mergedImageMemorybytes.value = bytes;
  }

  void getResposeBase64Code(String val) {
    objRemApiResponse.value = val;
  }

  void getapiResponseBytes(List<int> val) {
    objRemApiResponseBytes.value = val;
  }

  void setPressed(bool val) {
    isShowActualImage.value = val;
    print('setpress ${isShowActualImage.value}');
  }

  void setIsProcessing(bool val) {
    isProcessing.value = val;
  }
  void setIsPathClear(bool val){
    isPathEmpty.value =val;
  }

  // void getPaintedImg(img.Image getPImg){
  //   paintedImg.value = getPImg;
  // }
}
