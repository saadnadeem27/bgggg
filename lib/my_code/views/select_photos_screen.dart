import 'dart:io';
import 'package:custom_pkg_obj_remove/my_code/constants/constants.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/gallery_controller.dart';
import 'package:custom_pkg_obj_remove/my_code/controller/object_remove_controller.dart';

import 'package:custom_pkg_obj_remove/my_code/constants/colors.dart';
import 'package:custom_pkg_obj_remove/my_code/views/dashboard_screen.dart';
import 'package:custom_pkg_obj_remove/show_gallery/photo_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparent_image/transparent_image.dart';

class SelectPhotosScreen extends StatefulWidget {
  const SelectPhotosScreen({super.key});

  @override
  State<SelectPhotosScreen> createState() => _SelectPhotosScreenState();
}

class _SelectPhotosScreenState extends State<SelectPhotosScreen> {
  //bool isSelected = false;
  // final selectPhotosController = Get.put(SelectphotosController());
  final objectRemoveControler = Get.put(ObjectRemoveController());
  // final galleryController = Get.put(GalleryController());
  int selectedPhotoIndex = -1;
  File? imageFile;
  bool hasValue = false;
  List<Medium>? _images;
  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _loading = true;
    initAsync();
    // galleryController.fetchAlbums();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      // Fetch all photos directly without specifying an album
      MediaPage mediaPage = await PhotoGallery.listMedia(
        album: Album.fromJson(const {
          'id': "__ALL__",
          'name': "All Photos",
          'count': 0,
        }, null, true),
        skip: 0,
        take: 500, // You can adjust the number of photos to display
        lightWeight: false,
      );

      // Filter out only images (exclude videos)
      _images = mediaPage.items
          .where((medium) => medium.mediumType == MediumType.image)
          .toList();

      setState(() {
        // _images = mediaPage.items;
        _loading = false;
      });
    }

    setState(() {
      _loading = false;
    });
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        return true;
      }
    }
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted &&
              await Permission.videos.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 132.h),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 24.sp, bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 53.h,
                ),
                Text(
                  'Select Photos',
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consetetur \nsadipscing elitr, sed diam nonumy eirmod',
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.sp,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.sp),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Photos',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final pickedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (pickedImage != null) {
                        imageFile = File(pickedImage.path);
                        // ignore: use_build_context_synchronously
                        if (imageFile != null) {
                          // objectRemoveControler.getImageFile(imageFile);
                          print('picked');

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         DashboardScreen(passImage: imageFile),
                          //   ),
                          // );
                          Get.to(DashboardScreen(passImage: imageFile));
                        }
                      }
                    },
                    child: Text(
                      'Open Gallery',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xff0789E7),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xff0789E7),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Builder(
                    builder: (context) => Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        shrinkWrap: true,
                        children: <Widget>[
                          ...?_images?.map(
                            (medium) => GestureDetector(
                              onTap: () async {
                                File imageFile = await PhotoGallery.getFile(
                                  mediumId: medium.id,
                                  mediumType: medium.mediumType,
                                );
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //       builder: (context) => ViewerPage(
                                //             medium,
                                //             imageFile: imageFile,
                                //           )),
                                // );
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DashboardScreen(passImage: imageFile),
                                  ),
                                );
                              },
                              child: Container(
                                color: Colors.grey[300],
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  placeholder: MemoryImage(kTransparentImage),
                                  image: ThumbnailProvider(
                                    mediumId: medium.id,
                                    mediumType: medium.mediumType,
                                    highQuality: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

            // Obx(() {
            //   // final isDataLoading = galleryController.isDataLoading.value;
            //   final List<File> allPhotosList = galleryController.imageFiles;
            //   return Expanded(
            //     child: GridView.builder(
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 3,
            //         mainAxisSpacing: 12.0, // Spacing between rows
            //         crossAxisSpacing: 12.0, // Spacing between columns
            //       ),
            //       itemCount: allPhotosList.length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return GestureDetector(
            //           onTap: () {
            //             // selectPhotosController.select(index);
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => DashboardScreen(
            //                     passImage: allPhotosList[index]),
            //               ),
            //             );
            //           },
            //           child: Container(
            //             height: 100.h,
            //             width: 100.w,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(16.r),
            //               image: DecorationImage(
            //                   image: FileImage(allPhotosList[index]),
            //                   fit: BoxFit.contain),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   );
            // }),
          ],
        ),
      ),
    );
  }
}
