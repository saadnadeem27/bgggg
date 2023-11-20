import 'package:get/get.dart';

class BgRemoveController extends GetxController{
  RxString bgApiResponse = ''.obs;

  RxList<int> bgApiResponseBytes = <int>[].obs;


  void getResposeBase64Code(String val) {
    bgApiResponse.value = val;
  }

  void getapiResponseBytes(List<int> val) {
    bgApiResponseBytes.value = val;
  }

  
}