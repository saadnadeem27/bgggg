import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

class ImageActionsController extends GetxController {
  //Get Compressed Image
  Future<String?> compressImageResult(File image) async {
    return resizeImage(image).then((value) {
      return compressImage(image, value);
    });
  }

  Future<String> compressImage(File file, Map<String, int> size) async {
    List<int> bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(Uint8List.fromList(bytes));
    img.Image resizedImage =
        img.copyResize(image!, width: size['width'], height: size['height']);
    Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resizedImage));
    return base64Encode(resizedBytes);
  }

  Future<Map<String, int>> resizeImage(File file) async {
    Map<String, int> size = {};
    final ui.Image image = await getImage(file);
    if (image.width > image.height) {
      size['height'] = ((1 / (image.width / image.height)) * 768).toInt();
      size['width'] = 768;
    } else if (image.width == image.height) {
      size['height'] = 768;
      size['width'] = 768;
    } else if (image.width < image.height) {
      size['height'] = 768;
      size['width'] = ((1 / (image.height / image.width)) * 768).toInt();
    }
    print('new image height : ${size['height']}');
    print('new image width : ${size['width']}');
    update();
    return size;
  }

  Future<ui.Image> getImage(File file) async {
    final Uint8List bytes = await file.readAsBytes();
    final Completer<ui.Image> completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  ////////////////// when user pass the uint8list bytes //////////////////
  Future<ui.Image> getImageBytes(Uint8List bytes) async {
    // final Uint8List bytes = await file.readAsBytes();
    final Completer<ui.Image> completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  Future<Map<String, int>> resizeImageBytes(Uint8List bytes) async {
    Map<String, int> size = {};
    final ui.Image image = await getImageBytes(bytes);
    if (image.width > image.height) {
      size['height'] = ((1 / (image.width / image.height)) * 768).toInt();
      size['width'] = 768;
    } else if (image.width == image.height) {
      size['height'] = 768;
      size['width'] = 768;
    } else if (image.width < image.height) {
      size['height'] = 768;
      size['width'] = ((1 / (image.height / image.width)) * 768).toInt();
    }
    print('new image height : ${size['height']}');
    print('new image width : ${size['width']}');
    update();
    return size;
  }

  Future<String> compressImageBytes(
      List<int> bytes, Map<String, int> size) async {
    // List<int> bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(Uint8List.fromList(bytes));
    img.Image resizedImage =
        img.copyResize(image!, width: size['width'], height: size['height']);
    Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resizedImage));
    return base64Encode(resizedBytes);
  }

  Future<String?> compressImageBytesResult(Uint8List bytes) async {
    return resizeImageBytes(bytes).then((value) {
      return compressImageBytes(bytes, value);
    });
  }
}
