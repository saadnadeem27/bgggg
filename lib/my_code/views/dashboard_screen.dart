import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:before_after/before_after.dart';
import 'package:custom_pkg_obj_remove/my_code/constants/colors.dart';
import 'package:custom_pkg_obj_remove/my_code/constants/constants.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/ai_enhancer_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/bg_remove_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/image_actions_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/image_undo_redo_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/main_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/object_remove_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/payloads/payloads.dart';
import 'package:custom_pkg_obj_remove/my_code/utils/conversions.dart';
import 'package:custom_pkg_obj_remove/my_code/views/ai_enhance_sceen.dart';
import 'package:custom_pkg_obj_remove/my_code/views/bg_remove_screen.dart';
import 'package:custom_pkg_obj_remove/my_code/views/eraser_screen.dart';
import 'package:custom_pkg_obj_remove/my_code/widgets/appbar_icon_container.dart';
import 'package:custom_pkg_obj_remove/my_code/widgets/processing_screen.dart';
import 'package:custom_pkg_obj_remove/pkg/flutter_painter.dart';
// import 'package:custom_pkg_obj_remove/my_code/widgets/blurred_dialgue_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class DashboardScreen extends StatefulWidget {
  File? passImage;
  DashboardScreen({super.key, this.passImage});
  @override
  State<DashboardScreen> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<DashboardScreen> {
  //int currentIndex = 0;
  final List<Widget> _screens = [
    const EraserScreen(), // Your first screen/page
    const AiEnhanceScreen(), // Your second screen/page
    const BgRemoveScreen(), // Your third screen/page
  ];
  // final imageController = Get.put(ImageController());
  File? imageFile;
  //double strokeWidth = 0.5;
  //File? galleryImageFile;
  double baValue = 0.5;
  late PainterController controller;
  File? actualImage;
  File? maskImage;
  File? pImage;
  List<int>? actualImageBytes;
  List<int>? maskImageBytes;
  // String? maskBase64image;
  String? responsedImage;
  ImageBackgroundDrawable? realImage;
  ImageBackgroundDrawable? respImage;
  final objectRemoveControler = Get.put(ObjectRemoveController());
  final bgRemoveControler = Get.put(BgRemoveController());
  final aiEnhanceControler = Get.put(AiEnhancerController());
  final mainController = Get.put(MainController());
  final imageUndoRedoController = Get.put(ImageUndoRedoController());
  final imageActionController = Get.put(ImageActionsController());

  var actualImgHeight;
  var actualImgWidth;

  bool isShowReal = true;

  String? selectedModel; // Initialize as null to represent "Select Model"

  void removeObject() async {
    print('a');
    processDialog();
    try {
      Size backgroundImageSize = Size(
        backgroundImage!.width.toDouble(),
        backgroundImage!.height.toDouble(),
      );
      print('b');
      //first it render image and then

      var base64String = await controller
          .renderImage(backgroundImageSize)
          .then<Uint8List?>((ui.Image image) => image.pngBytes)
          .then((value) {
        return createMergedImage(value!);
      }).then((value) {
        return imageActionController.compressImageBytesResult(value);
      });

      if (base64String != null) {
        maskCompressImgBase64.value = base64String;
      }

      ///
      print('c');
      print('d');

      if (maskCompressImgBase64.value.isNotEmpty) {
        await objRemPostDataAndGetResponse().then((value) async {
          var getData = await jsonDecode(value);
          if (getData['status_code'] == 200) {
            var responseBytes = base64.decode(getData['image']);
            final ui.Image image = await ImmutableBuffer.fromUint8List(
                    Uint8List.fromList(responseBytes))
                .then((buffer) {
              return PaintingBinding.instance
                  .instantiateImageCodecWithSize(buffer)
                  .then((codec) {
                return codec.getNextFrame().then((frame) {
                  return frame.image;
                });
              });
            });

            print('e');
            // Adding the actual image to the list
            List<int> actualresponseBytes =
                base64.decode(actualBase64image.value);
            final ui.Image actualimage = await ImmutableBuffer.fromUint8List(
                    Uint8List.fromList(actualresponseBytes))
                .then((actualbuffer) => PaintingBinding.instance
                    .instantiateImageCodecWithSize(actualbuffer))
                .then((actualcodec) => actualcodec.getNextFrame())
                .then((actualframe) => actualframe.image);

            final actualImageBg = actualimage.backgroundDrawable;
            print('f');
            controller.clearDrawables();
            controller.performedActions.clear();
            print('g');

            // Close the dialog
            Navigator.pop(dialogContext.value!);
            respImage = image.backgroundDrawable;
            controller.background = respImage;
            resultantBase64.value = getData['image'];

            if (imageUndoRedoController.images.isEmpty) {
              imageUndoRedoController.getRealImg(actualImageBg);
            }
            imageUndoRedoController.getRespImg(respImage!);
            imageUndoRedoController.addImage(respImage!);
          }
        });
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error (e.g., show an error message)
    }
  }

  ui.Image? _image;

  Future<ui.Image> loadImage(File file) async {
    final Completer<ui.Image> completer = Completer();

    final Uint8List data = await file.readAsBytes();

    ui.decodeImageFromList(data, (ui.Image img) {
      setState(() {
        _image = img;
        actualImgHeight = _image?.height;
        actualImgWidth = _image?.width;
      });
      completer.complete(img);
    });

    return completer.future;
  }

  ui.Image? backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 15
    ..color = const Color(0xffFF1F1F)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  @override
  void initState() {
    super.initState();
    controller = PainterController(
      settings: PainterSettings(
        freeStyle: const FreeStyleSettings(
          color: Color(0xffFF1F1F),
          strokeWidth: 17,
        ),
        shape: ShapeSettings(
          paint: shapePaint,
        ),
        scale: const ScaleSettings(
          enabled: true,
          minScale: 1,
          maxScale: 5,
        ),
      ),
    );
    controller.freeStyleMode = FreeStyleMode.draw;
    pImage = widget.passImage;
    if (pImage != null) {
      print('background inited');
      initBackground();
    }
  }

  void initBackground() async {
    pImage = widget.passImage;
    objectRemoveControler.getImageFile(pImage);
    await loadImage(pImage!).then((value) {
      actualImgHeight = value.height;
      actualImgWidth = value.width;
      print('actual image height : $actualImgHeight');
      print('actual image width : $actualImgWidth');
    });
    Map<String, dynamic> newSizeMap = getNewHeightAndWidth(
        actualImgHeight: actualImgHeight, actualImgWidth: actualImgWidth);
    newHeight.value = newSizeMap['newHeight'];
    newWidth.value = newSizeMap['newWidth'];
    print('new height : $newHeight');
    print('new width : $newWidth');
    final bytes = pImage!.readAsBytesSync();
    actualBase64image.value = base64Encode(bytes);
    print('actualbase64Image : ${actualBase64image.value}');

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;
    setState(() {
      backgroundImage = image;
      controller.background = image.backgroundDrawable;
      // actualImgDrawable = image;
      realImage = image.backgroundDrawable;
      // controller.performedActions.add(image);
    });
  }

  Future<void> getImage(ImageSource source) async {
    if (actualBase64image.value.isNotEmpty) {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        print('abc');
        actualBase64image.value = '';
        setState(() {
          imageUndoRedoController.realImg.value = null;
          imageUndoRedoController.images.clear();
          imageUndoRedoController.imageStates.clear();
          imageUndoRedoController.imageManager.redoQueue.clear();
          imageUndoRedoController.imageManager.undoQueue.clear();
          imageUndoRedoController.currentIndex = -1;
          controller.performedActions.clear();
          controller.unperformedActions.clear();
          widget.passImage = null;
          resultantBase64.value = '';
        });

        objectRemoveControler.imageFile.value = null;
        actualImage = File(pickedFile.path);
        objectRemoveControler.getImageFile(actualImage);
        //for resize
        await loadImage(actualImage!).then((value) {
          actualImgHeight = value.height;
          actualImgWidth = value.width;
          print('actual image height : $actualImgHeight');
          print('actual image width : $actualImgWidth');
        });
        Map<String, dynamic> newSizeMap = getNewHeightAndWidth(
            actualImgHeight: actualImgHeight, actualImgWidth: actualImgWidth);
        newHeight.value = newSizeMap['newHeight'];
        newWidth.value = newSizeMap['newWidth'];
        print('new height : $newHeight');
        print('new width : $newWidth');

        ///
        // final imagee = img.decodeImage( actualImage!.readAsBytesSync());
        final bytes = actualImage!.readAsBytesSync();
        actualBase64image.value = base64Encode(bytes);
        print('actualbase64Image : $actualBase64image');
// ..convert uint8list into image
        final ui.Codec codec = await ui.instantiateImageCodec(bytes);
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        final ui.Image image = frameInfo.image;
        // imageUndoRedoController.currentIndex = -1;
        resultantBase64.value = '';
        respImage = null;
        controller.clearDrawables();
        imageUndoRedoController.imageManager.undoQueue.clear();
        imageUndoRedoController.imageManager.redoQueue.clear();
        imageUndoRedoController.imageStates.clear();
        imageUndoRedoController.images.clear();
        controller.performedActions.clear();
        controller.unperformedActions.clear();
        setState(() {
          backgroundImage = image;
          controller.background = image.backgroundDrawable;
          realImage = image.backgroundDrawable;
          imageUndoRedoController.getRealImg(image.backgroundDrawable);
        });
      }

      ///////
    } else {
      print('abc is empty');
      widget.passImage = null;
      resultantBase64.value = '';
      actualBase64image.value = '';
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        actualImage = File(pickedFile.path);
        objectRemoveControler.getImageFile(actualImage);
        //for resize
        await loadImage(actualImage!).then((value) {
          actualImgHeight = value.height;
          actualImgWidth = value.width;
          print('actual image height : $actualImgHeight');
          print('actual image width : $actualImgWidth');
        });
        Map<String, dynamic> newSizeMap = getNewHeightAndWidth(
            actualImgHeight: actualImgHeight, actualImgWidth: actualImgWidth);
        newHeight.value = newSizeMap['newHeight'];
        newWidth.value = newSizeMap['newWidth'];
        print('new height : $newHeight');
        print('new width : $newWidth');

        ///
        // final imagee = img.decodeImage( actualImage!.readAsBytesSync());
        final bytes = actualImage!.readAsBytesSync();
        actualBase64image.value = base64Encode(bytes);
        print('actualbase64Image : $actualBase64image');
// ..convert uint8list into image
        final ui.Codec codec = await ui.instantiateImageCodec(bytes);
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        final ui.Image image = frameInfo.image;
        // imageUndoRedoController.currentIndex = -1;
        resultantBase64.value = '';
        respImage = null;
        controller.clearDrawables();
        imageUndoRedoController.imageManager.undoQueue.clear();
        imageUndoRedoController.imageManager.redoQueue.clear();
        imageUndoRedoController.imageStates.clear();
        imageUndoRedoController.images.clear();
        controller.performedActions.clear();
        controller.unperformedActions.clear();
        setState(() {
          backgroundImage = image;
          controller.background = image.backgroundDrawable;
          realImage = image.backgroundDrawable;
        });

        // actualCompressImgBase64.value =
        //     (await imageActionController.compressImageResult(actualImage!))!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    dialogContext.value = context;
    return Obx(
      () {
        if (mainController.index.value == 0) {
          afterImageData.value = null;
        }
        if (mainController.index.value == 1) {
          controller.freeStyleMode = FreeStyleMode.none;
          controller.clearDrawables();
          controller.performedActions.clear();
          controller.unperformedActions.clear();
        } else if (mainController.index.value == 2) {
          controller.freeStyleMode = FreeStyleMode.none;
          controller.clearDrawables();
          controller.performedActions.clear();
          controller.unperformedActions.clear();
          afterImageData.value = null;
        } else {
          controller.freeStyleMode = FreeStyleMode.draw;
        }
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            print('init state called on select photos');
            newHeight.value = 0.0;
            newWidth.value = 0.0;
            resultantBase64.value = '';
            actualBase64image.value = '';
            maskBase64image.value = '';
            maskImageFile.value = Rx<File?>(null).value;
            actualCompressImgBase64.value = '';
            maskCompressImgBase64.value = '';
            objectRemoveControler.imageFile.value = null;
            imageUndoRedoController.realImg.value = null;
            imageUndoRedoController.images.clear();
            imageUndoRedoController.imageStates.clear();
            imageUndoRedoController.imageManager.redoQueue.clear();
            imageUndoRedoController.imageManager.undoQueue.clear();
            imageUndoRedoController.currentIndex = -1;
            controller.performedActions.clear();
            controller.unperformedActions.clear();
            widget.passImage = null;
          },
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  height: 115.h,
                  padding: EdgeInsets.only(top: 50.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                  ),
                  child: ValueListenableBuilder<PainterControllerValue>(
                    valueListenable: controller,
                    builder: (context, _, child) {
                      return AppBar(
                        toolbarHeight: 65.h,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.r),
                            bottomRight: Radius.circular(16.r),
                          ),
                        ),
                        systemOverlayStyle: const SystemUiOverlayStyle(
                            statusBarColor: Colors.transparent),
                        elevation: 0,
                        primary: false,
                        automaticallyImplyLeading: false,
                        backgroundColor: AppColors.primaryColor,
                        actions: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: 12.h, right: 12.h),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/back_icon.svg',
                                  width: 23.w,
                                  height: 23.h,
                                ),
                              ),
                            ),
                          ),
                          AppbarIconContainer(
                            iconName: 'camera_icon',
                            text: 'Camera',
                            onPressed: () {
                              getImage(ImageSource.camera);
                            },
                          ),
                          AppbarIconContainer(
                            iconName: 'gallery_icon',
                            text: 'Gallery',
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                          ),
                          AppbarIconContainer(
                            iconName: 'undo_icon',
                            text: 'Undo',
                            onPressed: () async {
                              print('/////');
                              print('Tapping Undo button');
                              print(
                                  'unperformedActions ${controller.unperformedActions}');
                              print(
                                  'performedActions ${controller.performedActions}');
                              if (controller.performedActions.isEmpty ||
                                  resultantBase64.value.isNotEmpty &&
                                      imageUndoRedoController
                                          .images.isNotEmpty) {
                                imageUndoRedoController.undo();
                                if (imageUndoRedoController.images.isNotEmpty) {
                                  resultantBase64.value =
                                      await convertImgDrawableToBase64(
                                          imageUndoRedoController.images.last);
                                  controller.background =
                                      imageUndoRedoController.images.last;
                                }
                              } else {
                                // undo();
                              }
                            },
                          ),
                          AppbarIconContainer(
                              iconName: 'redo_icon',
                              text: 'Redo',
                              onPressed: () async {
                                print('/////');
                                print('Tapping Redo button');
                                print(
                                    'unperformedActions ${controller.unperformedActions}');
                                print(
                                    'performedActions ${controller.performedActions}');
                                if (controller.unperformedActions.isEmpty &&
                                    respImage != null) {
                                  imageUndoRedoController.redo();
                                  print('1st');

                                  resultantBase64.value =
                                      await convertImgDrawableToBase64(
                                          imageUndoRedoController.images.last);
                                  print('2nd');
                                  controller.background =
                                      imageUndoRedoController.images.last;
                                } else {
                                  // redo();
                                  // controller.performedActions;
                                }
                              }),
                          AppbarIconContainer(
                            iconName: 'save_icon',
                            text: 'Save',
                            onPressed: () {
                              if (backgroundImage != null) {
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: [
                                        // Blurred Background
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 15, sigmaY: 15),
                                          child: Container(
                                            color: Colors.black.withOpacity(
                                                0.5), // Adjust opacity and color
                                            constraints:
                                                const BoxConstraints.expand(),
                                          ),
                                        ),
                                        // Dialog Box
                                        AlertDialog(
                                          titlePadding: EdgeInsets.only(
                                              top: 50.h, bottom: 5.h),
                                          title: Text(
                                            'Save Changes?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(0xff292929),
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  'Do you want to save your current image?',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 27.h,
                                              ),
                                              MaterialButton(
                                                onPressed: () async {
                                                  if (resultantBase64
                                                      .value.isNotEmpty) {
                                                    Uint8List uint8List =
                                                        Uint8List.fromList(
                                                      base64.decode(
                                                          resultantBase64
                                                              .value),
                                                    );
                                                    saveImageToGallery(
                                                        uint8List);
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                height: 45.h,
                                                minWidth: 155.w,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 208, 208, 208),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.r),
                                                ),
                                                color: AppColors.primaryColor,
                                                child: const Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 9.h,
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                height: 45.h,
                                                minWidth: 155.w,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 208, 208, 208),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.r),
                                                ),
                                                color: const Color(0xffDEDEDE),
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showtoast('Image Is Empty');
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Obx(() {
                  print('-index- ${mainController.index.value}');
                  // mainController.index.value = widget.screenIndex;
                  return _screens[mainController.index.value];
                }),
                backgroundImage != null
                    ? Obx(() {
                        final showReal =
                            objectRemoveControler.isShowActualImage.value;
                        final resImage = objectRemoveControler.imageFile.value;
                        if (resImage == null) {
                          print('its null');
                        } else {
                          print('not null');
                        }
                        return afterImageData.value != null
                            ? SizedBox(
                                height: newHeight.value,
                                width: newWidth.value,
                                child: BeforeAfter(
                                  value: baValue,
                                  before: Stack(
                                    children: [
                                      Image.memory(
                                        beforeImageData.value!,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                          right: 20.sp,
                                          left: 20.sp,
                                          child: const Text('Before'))
                                    ],
                                  ),
                                  after: Stack(
                                    children: [
                                      Image.memory(afterImageData.value!,
                                          fit: BoxFit.cover),
                                      Positioned(
                                          right: 20.sp,
                                          child: const Text('After'))
                                    ],
                                  ),
                                  onValueChanged: (value) {
                                    setState(() {
                                      baValue = value;
                                      print('value : $value');
                                    });
                                  },
                                ),
                              )
                            : Stack(
                                children: [
                                  SizedBox(
                                    height: newHeight.value.toDouble(),
                                    width: newWidth.value.toDouble(),
                                    child: Center(
                                      child: showReal
                                          ? Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: FlutterPainter(
                                                controller: controller,
                                              ),
                                            )
                                          : backgroundImage != null
                                              ? RawImage(
                                                  fit: BoxFit.fill,
                                                  image: backgroundImage!,
                                                  height: newHeight.value
                                                      .toDouble(),
                                                  width:
                                                      newWidth.value.toDouble(),
                                                  scale: 1,
                                                )
                                              : Container(),

                                      // : resImage != null
                                      //     ? Image.file(
                                      //         fit: BoxFit.fill,
                                      //         resImage,
                                      //         height: newHeight,
                                      //         width: newWidth,
                                      //       )
                                      //     : const SizedBox.shrink(),
                                    ),
                                  ),
                                  Positioned(
                                    right: 20,
                                    bottom: 20,
                                    child: GestureDetector(
                                      onTapDown: (details) {
                                        objectRemoveControler.setPressed(false);
                                      },
                                      onTapUp: (details) {
                                        objectRemoveControler.setPressed(true);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: const Color(0xff2F3338)
                                                .withOpacity(0.8),
                                            border: Border.all(
                                              color: const Color(0xff2A2D30)
                                                  .withOpacity(0.9),
                                            ),
                                            shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                            'assets/icons/on_off_icon.svg'),
                                      ),
                                    ),
                                  ),
                                  if (isMagnifierShow.value == true &&
                                      mainController.index.value == 0)
                                    Positioned(
                                      left: 2,
                                      top: 0,
                                      child: RawMagnifier(
                                        //focalPointOffset: dragGesturePosition,
                                        focalPointOffset: Offset(
                                          dragGesturePosition.value.dx -
                                              50, // Adjust for the RawMagnifier's left position
                                          dragGesturePosition.value.dy -
                                              50, // No need to adjust the top position
                                        ),
                                        decoration: MagnifierDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            side: const BorderSide(
                                                color: Colors.white, width: 3),
                                          ),
                                        ),
                                        size: const Size(100, 100),
                                        magnificationScale: 2,
                                      ),
                                    ),

                                  ///button on off
                                ],
                              );
                      })
                    : InkWell(
                        onTap: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Container(
                          height: 386.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            // borderRadius: BorderRadius.circular(12.r),
                            color: Color(0xffEAE9F1),

                            // border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/pick_img_icon.svg',
                                  // width: 23.w,
                                  // height: 23.h,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  'Add Image',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff9CA6AC),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 20.h,
                ),
                if (mainController.index.value == 0)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 29.sp),
                    child: ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (context, _, __) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 310.w,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              // color: Colors.white54,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (controller.freeStyleMode !=
                                    FreeStyleMode.none) ...[
                                  Row(
                                    children: [
                                      // SvgPicture.asset(
                                      //   'assets/icons/stroke_icon.svg',
                                      //   width: 23.w,
                                      //   height: 23.h,
                                      // ),
                                      GestureDetector(
                                        onTap: toggleFreeStyleDraw,
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              controller.freeStyleMode ==
                                                      FreeStyleMode.draw
                                                  ? AppColors.primaryColor
                                                  : Colors.black,
                                              BlendMode.srcIn),
                                          child: SvgPicture.asset(
                                            'assets/icons/select_paint.svg',
                                            width: 34.w,
                                            height: 34.h,
                                            // color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      GestureDetector(
                                        onTap: toggleFreeStyleErase,
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            controller.freeStyleMode ==
                                                    FreeStyleMode.erase
                                                ? AppColors.primaryColor
                                                : controller.drawables
                                                            .isNotEmpty ||
                                                        objectRemoveControler
                                                            .isPathEmpty.value
                                                    ? Colors.black
                                                    : Colors.grey,
                                            BlendMode.srcIn,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/select_eraser.svg',
                                            width: 34.w,
                                            height: 34.h,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            activeTrackColor:
                                                const Color(0xffE5716E),
                                            thumbColor: const Color(
                                                0xffE5716E), // Color of the thumb
                                            overlayColor: Colors.blue.withOpacity(
                                                0.3), // Color of the thumb overlay
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                    enabledThumbRadius: 10.0),
                                            overlayShape:
                                                const RoundSliderOverlayShape(
                                                    overlayRadius: 20.0),
                                          ),
                                          child: Slider.adaptive(
                                              min: 5,
                                              max: 50,
                                              value: controller
                                                  .freeStyleStrokeWidth,
                                              onChanged:
                                                  setFreeStyleStrokeWidth),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (mainController.index.value == 0)
                  Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () async {
                            //function call
                            // if (maskImage != null) {
                            // final i = objectRemoveControler.paintedImg.value;
                            // if (i != null) {
                            if (backgroundImage != null) {
                              removeObject();
                            } else {
                              showtoast('Pick Image First');
                            }
                            // } else {
                            //   showtoast('Paint image first');
                            // }
                            // }
                            // else{
                            //   showtoast('Not Complete Process');
                            // }
                          },
                          height: 48.h,
                          minWidth: 200.w,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r)),
                          color: AppColors.primaryColor,
                          child: const Text(
                            'Remove',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (mainController.index.value == 1)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 57.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              height: 48.h,
                              minWidth: 200.w,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r)),
                              color: AppColors.primaryColor,
                              onPressed: () async {
                                if (actualBase64image.value.isNotEmpty) {
                                  controller.performedActions.clear();
                                  print(controller.performedActions);
                                  await aiEnhancePostDataAndGetResponse()
                                      .then((value) async {
                                    var getData = jsonDecode(value);
                                    if (getData['status_code'] == 200) {
                                      List<int> responseBytes =
                                          base64.decode(getData['image']);
                                      aiEnhanceControler
                                          .getapiResponseBytes(responseBytes);
                                      final ImmutableBuffer buffer =
                                          await ImmutableBuffer.fromUint8List(
                                        Uint8List.fromList(responseBytes),
                                      );
                                      final codec = await PaintingBinding
                                          .instance
                                          .instantiateImageCodecWithSize(
                                              buffer);
                                      final frame = await codec.getNextFrame();
                                      final ui.Image image = frame.image;
                                      setState(() {
                                        Navigator.of(context).pop();
                                        // backgroundImage = image;
                                        respImage = image.backgroundDrawable;
                                        controller.background =
                                            image.backgroundDrawable;
                                        resultantBase64.value =
                                            getData['image'];
                                      });
                                    }
                                  });
                                } else {
                                  showtoast('Select Image First');
                                }
                              },
                              child: const Text(
                                'Enhance Image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (mainController.index.value == 2)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 57.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                // controller.unperformedActions.clear();
                                controller.performedActions.clear();
                                print(controller.performedActions);
                                processDialog();
                                await bgRemPostDataAndGetResponse()
                                    .then((value) async {
                                  var getData = jsonDecode(value);
                                  if (getData['status_code'] == 200) {
                                    List<int> responseBytes =
                                        base64.decode(getData['image']);
                                    bgRemoveControler
                                        .getapiResponseBytes(responseBytes);
                                    final ImmutableBuffer buffer =
                                        await ImmutableBuffer.fromUint8List(
                                      Uint8List.fromList(responseBytes),
                                    );
                                    final codec = await PaintingBinding.instance
                                        .instantiateImageCodecWithSize(buffer);
                                    final frame = await codec.getNextFrame();
                                    final ui.Image image = frame.image;
                                    // setState(() {
                                    Navigator.of(dialogContext.value!).pop();
                                    // backgroundImage = image;
                                    respImage = image.backgroundDrawable;
                                    controller.background =
                                        image.backgroundDrawable;
                                    resultantBase64.value = getData['image'];
                                    // });
                                    List<int> actualresponseBytes =
                                        base64.decode(actualBase64image.value);
                                    // objectRemoveControler.getapiResponseBytes(responseBytes);
                                    final ImmutableBuffer actualbuffer =
                                        await ImmutableBuffer.fromUint8List(
                                      Uint8List.fromList(actualresponseBytes),
                                    );
                                    final actualcodec = await PaintingBinding
                                        .instance
                                        .instantiateImageCodecWithSize(
                                            actualbuffer);
                                    final actualframe =
                                        await actualcodec.getNextFrame();
                                    final ui.Image actualimage =
                                        actualframe.image;
                                    final actualImageBg =
                                        actualimage.backgroundDrawable;
                                    if (imageUndoRedoController
                                        .images.isEmpty) {
                                      imageUndoRedoController
                                          .getRealImg(actualImageBg);
                                    }
                                    imageUndoRedoController
                                        .getRespImg(respImage!);
                                    imageUndoRedoController
                                        .addImage(respImage!);
                                  }
                                });
                              },
                              height: 48.h,
                              minWidth: 200.w,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r)),
                              color: AppColors.primaryColor,
                              child: const Text(
                                'Remove',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ), // Display the current selected screen
            bottomNavigationBar: Obx(
              () => BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: mainController.index.value,
                onTap: (int index) {
                  mainController.getIndex(index);
                },
                selectedItemColor: const Color(0xffE5716E),
                unselectedItemColor: Colors.grey,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/obj_rem.svg',
                      width: 30,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                          mainController.index.value == 0
                              ? const Color(0xffE5716E)
                              : Colors.grey,
                          BlendMode.srcIn),
                    ),
                    label: 'Eraser',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icons/ai_in.svg',
                        width: 30,
                        height: 30,
                        colorFilter: ColorFilter.mode(
                            mainController.index.value == 1
                                ? const Color(0xffE5716E)
                                : Colors.grey,
                            BlendMode.srcIn)),
                    label: 'AI Enhance',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/rem_bg.svg',
                      width: 30,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                          mainController.index.value == 2
                              ? const Color(0xffE5716E)
                              : Colors.grey,
                          BlendMode.srcIn),
                    ),
                    label: 'BG Remover',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  // void undo() {
  //   controller.undo();
  //   // if (isShowReal == false) {
  //   //   controller.background = realImage;
  //   //   isShowReal = true;
  //   // }
  // }

  // void redo() {
  //   controller.redo();
  //   // if (isShowReal == true) {
  //   //   controller.background = respImage;
  //   //   isShowReal = false;
  //   // }
  // }

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = FreeStyleMode.draw;
    // ? FreeStyleMode.draw
    // : FreeStyleMode.none;
  }

  void toggleFreeStyleErase() {
    if (controller.drawables.isNotEmpty) {
      controller.freeStyleMode = FreeStyleMode.erase;
      print('not cleard : ${controller.drawables}');
      print('Path is empty : ${objectRemoveControler.isPathEmpty.value}');
      print('Values unperform action: ${controller.unperformedActions}');
      print('Values perform action: ${controller.performedActions}');
      // controller.drawables.removeWhere((element) => element is GroupedDrawable);
      // controller.drawables.removeWhere((element) => element is EraseDrawable);
    }
  }
  // void toggleFreeStyleErase() {
  //   if (controller.drawables.isNotEmpty) {
  //     controller.freeStyleMode = FreeStyleMode.erase;
  //     print('not cleared: ${controller.drawables}');
  //     print('Path is empty: ${objectRemoveControler.isPathEmpty.value}');
  //     print('Values unperformed action: ${controller.unperformedActions}');
  //     print('Values perform action: ${controller.performedActions}');

  //     // Check if all drawable lines are erased
  //     if (controller.drawables.every((drawable) => drawable is EraseDrawable)) {
  //       print('All drawable lines erased!');

  //       // Perform additional actions or notify the user as needed
  //     }
  //     // You may also remove grouped drawables if needed
  //     // controller.drawables.removeWhere((element) => element is GroupedDrawable);
  //     // controller.drawables.removeWhere((element) => element is EraseDrawable);
  //   } else {
  //     controller.unperformedActions.clear();
  //     controller.clearDrawables();
  //     controller.performedActions.clear();
  //     controller.drawables.clear();
  //     print('All clear now');
  //   }
  // }
}
