import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:custom_pkg_obj_remove/pkg/src/controllers/drawables/background/image_background_drawable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:isolate_image_compress/isolate_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

Future<String> convertImgDrawableToBase64(ImageBackgroundDrawable val) async {
  final img = val.image; // Assuming rImage contains an ui.Image
  var a = await img
      .toByteData(format: ui.ImageByteFormat.png)
      .then((byteData) => byteData!.buffer.asUint8List())
      .then((bufer) => base64Encode(bufer));
  // final bufer = byteData!.buffer.asUint8List();
  // final base64String = base64Encode(bufer);
  return a;
}

Future<File> convertUint8ListToFile(Uint8List uint8list) async {
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/image.png');
  await file.writeAsBytes(uint8list);
  return file;
}

// Save the image to the gallery
void saveImageToGallery(Uint8List imageBytes) async {
  File imageFile = await convertUint8ListToFile(imageBytes);
  final result = await ImageGallerySaver.saveFile(imageFile.path);
  print('Image saved to gallery: $result');
}

//for object remover
Uint8List createMergedImage(Uint8List paintedImage) {
  final paintedImg = img.decodeImage(Uint8List.fromList(paintedImage))!;
  // objectRemoveControler.getPaintedImg(paintedImg);
  for (var y = 0; y < paintedImg.height; y++) {
    for (var x = 0; x < paintedImg.width; x++) {
      if (paintedImg.getPixel(x, y).r == 255 &&
          paintedImg.getPixel(x, y).g == 31 &&
          paintedImg.getPixel(x, y).b == 31) {
        paintedImg.setPixel(x, y, paintedImg.getColor(255, 255, 255));
      } else {
        paintedImg.setPixel(x, y, paintedImg.getColor(0, 0, 0));
      }
    }
  }
  return Uint8List.fromList(img.encodePng(paintedImg));
}

Future<ui.Image> convertListOfIntIntoImg(List<int> bytes) async {
  // final ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(
  //   Uint8List.fromList(bytes),
  // );
  // final codec =
  //     await PaintingBinding.instance.instantiateImageCodecWithSize(buffer);
  // final frame = await codec.getNextFrame();
  // final ui.Image image = frame.image;
  // return image;

  final ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(
    Uint8List.fromList(bytes),
  );
  final codec =
      await PaintingBinding.instance.instantiateImageCodecWithSize(buffer);
  final frame = await codec.getNextFrame();
  final ui.Image image = frame.image;
  return image;
}

Future<ui.Image> convertUint8ListIntoImg(Uint8List bytes) async {
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ui.Image image = frameInfo.image;
  return image;
}

//Get Compressed Image
// Future<Uint8List> compressImage(File imageFile) async {
//   Uint8List? compressedImage;
//   int? newHeight;
//   int? newWidth;
//   Image imageWidget = Image.file(imageFile);
//   imageWidget.image.resolve(const ImageConfiguration()).addListener(
//     ImageStreamListener((info, call) async {
//       if (info.image.width > info.image.height) {
//         newWidth = 768;
//         newHeight =
//             ((1 / (info.image.width / info.image.height)) * 768).toInt();
//       } else {
//         newWidth = ((1 / (info.image.width / info.image.height)) * 768).toInt();
//         newHeight = 768;
//       }
//       await IsolateImage.path(imageFile.absolute.path)
//           .compress(
//               maxResolution: ImageResolution(newWidth!, newHeight!),
//               maxSize: 1 * newWidth! * newHeight!)
//           .then((value) async {
//         compressedImage = value;
//         // update();
//       });
//     }),
//   );
//   return compressedImage!;
// }

Future<Uint8List> compressImage(File imageFile) async {
  Completer<Uint8List> completer = Completer();
  int? newHeight;
  int? newWidth;
  Image imageWidget = Image.file(imageFile);
  imageWidget.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener((info, call) async {
      if (info.image.width > info.image.height) {
        newWidth = 768;
        newHeight =
            ((1 / (info.image.width / info.image.height)) * 768).toInt();
      } else {
        newWidth = ((1 / (info.image.width / info.image.height)) * 768).toInt();
        newHeight = 768;
      }
      final value = await IsolateImage.path(imageFile.absolute.path).compress(
        maxResolution: ImageResolution(newWidth!, newHeight!),
        maxSize: 1 * newWidth! * newHeight!,
      );
      completer.complete(value);
    }),
  );
  return completer.future;
}

//compress maskimage

Future<Uint8List> compressMaskImage(String base64String) async {
  Completer<Uint8List> completer = Completer();
  int? newHeight;
  int? newWidth;

  // Decode the base64 string to bytes
  List<int> bytes = base64.decode(base64String);

  // Create an Image object from the bytes
  Image imageWidget = Image.memory(Uint8List.fromList(bytes));

  imageWidget.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener((info, call) async {
      if (info.image.width > info.image.height) {
        newWidth = 768;
        newHeight =
            ((1 / (info.image.width / info.image.height)) * 768).toInt();
      } else {
        newWidth = ((1 / (info.image.width / info.image.height)) * 768).toInt();
        newHeight = 768;
      }

      // Compress the image using IsolateImage
      final value = await IsolateImage.data(Uint8List.fromList(bytes)).compress(
        maxResolution: ImageResolution(newWidth!, newHeight!),
        maxSize: 1 * newWidth! * newHeight!,
      );
      completer.complete(value);
    }),
  );

  return completer.future;
}

Map<String, dynamic> getNewHeightAndWidth(
    {var actualImgHeight, actualImgWidth}) {
  double standardHeight = 386.0.h;
  double standardWidth = 360.0.w;
  if (actualImgHeight > actualImgWidth) {
    var newHeight = standardHeight.h;
    var newWidth = (1 / (actualImgHeight / actualImgWidth)) * standardWidth.w;
    return {
      'newWidth': newWidth,
      'newHeight': newHeight,
    };
  } else if (actualImgHeight < actualImgWidth) {
    var newWidth = standardWidth.w;
    var newHeight = (1 / (actualImgWidth / actualImgHeight)) * standardHeight.h;
    return {
      'newWidth': newWidth,
      'newHeight': newHeight,
    };
  } else if (actualImgHeight == actualImgWidth) {
    var newWidth = (1 / (actualImgHeight / actualImgWidth)) * standardWidth.w;
    var newHeight = (1 / (actualImgWidth / actualImgHeight)) * standardHeight.h;
    return {
      'newWidth': newWidth,
      'newHeight': newHeight,
    };
  } else {
    return {};
  }
}
