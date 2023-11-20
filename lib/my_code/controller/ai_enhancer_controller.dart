import 'package:get/get.dart';

class AiEnhancerController extends GetxController{
  RxString aiEnhanceApiResponse = ''.obs;

  RxList<int> aiEnhanceResponseBytes = <int>[].obs;

  void getResposeBase64Code(String val) {
    aiEnhanceApiResponse.value = val;
  }

  void getapiResponseBytes(List<int> val) {
    aiEnhanceResponseBytes.value = val;
  }
}