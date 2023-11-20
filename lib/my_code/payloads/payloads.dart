import 'dart:convert';
import 'dart:io';

import 'package:custom_pkg_obj_remove/my_code/constants/constants.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/ai_enhancer_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/bg_remove_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/image_actions_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/object_remove_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/widgets/processing_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final objectRemoveControler = Get.put(ObjectRemoveController());
final aiEnhanceControler = Get.put(AiEnhancerController());
final bgRemoveControler = Get.put(BgRemoveController());
final imageActionController = Get.put(ImageActionsController());

Future<String> bgRemPostDataAndGetResponse() async {
  //https: //931a-2407-aa80-314-a6ed-3d35-e6a-7c68-3b27.ngrok-free.app/inpaint
  // processDialog();
  File? actuaImg = objectRemoveControler.imageFile.value;
  if (actuaImg != null) {
    // var aBytes = await compressImage(actuaImg);
    // var actualFileBase64 = base64Encode(aBytes);
   
    const String apiUrl =
        "http://110.93.223.194/rembg"; // Replace with your API endpoint
    // const String apiUrl =
    //     "https://c473-2407-aa80-314-b585-f90a-b794-54-3e99.ngrok-free.app/inpaint";
    // Create an instance of Dio
    final dio = Dio();
    // Define the JSON data you want to send
    Map<String, dynamic> bodyData = {
      "input_image": resultantBase64.value.isNotEmpty
          ? resultantBase64.value
          : actualCompressImgBase64.value,
      "model": "u2net",
      "return_mask": false,
      "alpha_matting": false,
      "alpha_matting_foreground_threshold": 240,
      "alpha_matting_background_threshold": 10,
      "alpha_matting_erode_size": 10
    };

    try {
      final response = await dio.post(
        apiUrl,
        data: bodyData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        print("POST Request successful!");
        print("Response data: ${response.data}");
        final json = response.data as Map<String, dynamic>;
        //responsedImage = json["response"];
        print('This is my response image :  ${json["image"]}');
        bgRemoveControler.getResposeBase64Code(json["image"]);
        //var decodedImage = jsonDecode(json["image"]);
        var jsonData = {
          'status_code': 200,
          'image': json["image"],
        };
        var e = jsonEncode(jsonData);
        return e;
        // Handle the response data as needed
      } else {
        print("POST Request failed with status: ${response.statusCode}");
        print("Response data: ${response.data}");
        var jsonData = {
          'status_code': 201,
          'image': '',
        };
        var e = jsonEncode(jsonData);

        return e;
      }
    } catch (error) {
      print("Error: $error");
      return error.toString();
    }
  }
  var jsonData = {
    'status_code': 1000,
    'image': '',
  };
  var e = jsonEncode(jsonData);
  return e;
}

//object remover api pay load
Future<String> objRemPostDataAndGetResponse() async {
  //https: //931a-2407-aa80-314-a6ed-3d35-e6a-7c68-3b27.ngrok-free.app/inpaint
  const String apiUrl =
      "http://110.93.223.194:5673/inpaint"; // Replace with your API endpoint

  // Create an instance of Dio
  final dio = Dio();
  File? actuaImg = objectRemoveControler.imageFile.value;
  if (actuaImg != null) {
    try {
      var actualCompressImgbytes =
          await imageActionController.compressImageResult(actuaImg);
      // var maskCompressBytes =
      //     await imageActionController.compressImageResult(maskImageFile.value!);
      // Define the JSON data you want to send
      Map<String, dynamic> bodyData = {
        "image_base64": resultantBase64.value.isNotEmpty
            ? resultantBase64.value
            : actualCompressImgbytes,
        "mask_base64": maskCompressImgBase64.value,
        "ldmSteps": 1,
        "ldmSampler": "ddim",
        "hdStrategy": "Original",
        "zitsWireframe": false,
        "hdStrategyCropMargin": 128,
        "hdStrategyCropTrigerSize": 512,
        "hdStrategyResizeLimit": 1280,
        "prompt": "",
        "negativePrompt": "",
        "useCroper": false,
        "croperX": 0,
        "croperY": 0,
        "croperHeight": 512,
        "croperWidth": 512,
        "sdScale": 1,
        "sdMaskBlur": 0,
        "sdStrength": 0.75,
        "sdSteps": 50,
        "sdGuidanceScale": 7.5,
        "sdSampler": "uni_pc",
        "sdSeed": 42,
        "sdMatchHistograms": false,
        "cv2Flag": "INPAINT_NS",
        "cv2Radius": 4,
        "paintByExampleSteps": 50,
        "paintByExampleGuidanceScale": 7.5,
        "paintByExampleMaskBlur": 0,
        "paintByExampleSeed": 42,
        "paintByExampleMatchHistograms": false,
        "paintByExampleExampleImage": "string",
        "p2pSteps": 50,
        "p2pImageGuidanceScale": 7.5,
        "p2pGuidanceScale": 7.5,
        "controlnet_conditioning_scale": 0.4,
        "controlnet_method": "control_v11p_sd15_canny",
        "paint_by_example_example_image": "string"
      };

      try {
        final response = await dio.post(
          apiUrl,
          data: bodyData,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "accept": "application/json",
            },
          ),
        );
        if (response.statusCode == 200) {
          final json = response.data as Map<String, dynamic>;
          print('This is my response image :  ${json["response"]}');
          objectRemoveControler.getResposeBase64Code(json["response"]);
          var jsonData = {
            'status_code': 200,
            'image': json["response"],
          };
          var e = jsonEncode(jsonData);
          return e;
          // Handle the response data as needed
        } else {
          print("POST Request failed with status: ${response.statusCode}");
          print("Response data: ${response.data}");
          var jsonData = {
            'status_code': 201,
            'image': '',
          };
          var e = jsonEncode(jsonData);
          return e;
        }
      } catch (error) {
        print("Error: $error");
        return error.toString();
      }
    } catch (e) {
      print("Error :: $e");
    }
  }
  var jsonData = {
    'status_code': 1000,
    'image': '',
  };
  var e = jsonEncode(jsonData);
  return e;
}

Future<String> aiEnhancePostDataAndGetResponse() async {
  //https: //931a-2407-aa80-314-a6ed-3d35-e6a-7c68-3b27.ngrok-free.app/inpaint
  File? actuaImg = objectRemoveControler.imageFile.value;
  if (actuaImg != null) {
    // var bytes = await compressImage(actuaImg);
    // var actualBase64 = base64Encode(bytes);
    processDialog();

    var actualCompressImgbytes =
        await imageActionController.compressImageResult(actuaImg);

    // ignore: use_build_context_synchronously
    const String apiUrl =
        "http://110.93.223.194/sdapi/v1/extra-single-image"; // Replace with your API endpoint
    // Create an instance of Dio
    final dio = Dio();
    // Define the JSON data you want to send
    Map<String, dynamic> bodyData = {
      "resize_mode": 0,
      "show_extras_results": true,
      "gfpgan_visibility": 0,
      "codeformer_visibility": 0,
      "codeformer_weight": 0,
      "upscaling_resize": 2,
      "upscaling_crop": true,
      "upscaler_1": "4xUltrasharpV10",
      "upscaler_2": "R-ESRGAN 4x+",
      "extras_upscaler_2_visibility": 0,
      "upscale_first": false,
      "image": resultantBase64.value.isNotEmpty
          ? resultantBase64.value
          : actualCompressImgbytes,
    };

    try {
      final response = await dio.post(
        apiUrl,
        data: bodyData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "accept": "application/json",
            "Authorization": prefs!.getString('basic_auth'),
          },
        ),
      );
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously

        if (kDebugMode) {
          print("POST Request successful!");
        }
        if (kDebugMode) {
          print("Response data: ${response.data}");
        }
        final json = response.data as Map<String, dynamic>;
        //responsedImage = json["response"];
        if (kDebugMode) {
          print('This is my response image :  ${json["image"]}');
        }
        aiEnhanceControler.getResposeBase64Code(json["image"]);
        resultantBase64.value = json['image'];
        // if (actualBase64image != null) {
        //   beforeImageData = base64Decode(actualBase64image!);
        // }
        print(resultantBase64.value);
        print(actualBase64image.value);
        if (resultantBase64.value.isNotEmpty) {
          beforeImageData.value = base64Decode(resultantBase64.value);
        } else if (actualBase64image.value.isNotEmpty) {
          beforeImageData.value = base64Decode(actualBase64image.value);
        }
        afterImageData.value = base64Decode(json["image"]);
        var jsonData = {
          'status_code': response.statusCode,
          'image': json["image"],
        };
        var e = jsonEncode(jsonData);
        return e;
        // Handle the response data as needed
      } else {
        if (kDebugMode) {
          print("POST Request failed with status: ${response.statusCode}");
        }
        if (kDebugMode) {
          print("Response data: ${response.data}");
        }
        var jsonData = {
          'status_code': response.statusCode,
          'image': '',
        };
        var e = jsonEncode(jsonData);
        return e;
      }
    } catch (error) {
      print("Error: $error");
      return error.toString();
    }
  }
  var jsonData = {
    'status_code': 999,
    'image': '',
  };
  var e = jsonEncode(jsonData);
  return e;
}
