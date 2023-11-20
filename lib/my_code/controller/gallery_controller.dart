// // ignore_for_file: deprecated_member_use

// import 'dart:typed_data';

// import 'package:custom_pkg_obj_remove/my_code/utils/utilities.dart';
// import 'package:get/state_manager.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'dart:io';

// // import 'package:photoeditor/helper/utility.dart';

// class GalleryController extends GetxController {
//   RxList<AssetPathEntity> albums = <AssetPathEntity>[].obs;
//   RxBool isDataLoading = true.obs;
//   RxMap<String, List<AssetEntity>> albumAssets =
//       <String, List<AssetEntity>>{}.obs;

//   final Map<String, List<AssetEntity>> selectedAlbums = {};
//   final RxList<File> imageFiles = <File>[].obs;
//   final RxList<Uint8List> imageBytesList = <Uint8List>[].obs;

//   final albumThumbnailMap = <String, File>{};

//   Future<void> setSelectedAssetsForAlbum(
//       AssetPathEntity album, List<AssetEntity> assets) async {
//     isDataLoading.value = true;
//     selectedAlbums[album.id] = assets;
//     List<File> newImageFiles = [];

//     for (final asset in assets) {
//       final file = await asset.file;
//       if (file != null) {
//         newImageFiles.add(file);
//       }
//     }
//     imageFiles.assignAll(newImageFiles);
//     isDataLoading.value = false;
//   }

//   List<AssetEntity> getSelectedAssetsForAlbum(AssetPathEntity album) {
//     return selectedAlbums[album.id] ?? [];
//   }

//   void setIsDataLoading(bool val) {
//     isDataLoading.value = val;
//   }

//   Future<void> fetchAssetsForAlbum(AssetPathEntity album) async {
//     final List<AssetEntity> assets =
//         // ignore: deprecated_member_use
//         await album.getAssetListRange(start: 0, end: album.assetCount);
//     albumAssets[album.id] = assets;
//   }

// Future<void> fetchAlbums() async {
//     isDataLoading.value = true;
//     final List<AssetPathEntity> allAlbums =
//         await PhotoManager.getAssetPathList(/*onlyAll: true*/);
//     final List<AssetPathEntity> imageAlbums = [];
//     for (final album in allAlbums) {
//       final List<AssetEntity> images =
//           // ignore: deprecated_member_use
//           await album.getAssetListRange(start: 0, end: album.assetCount);
//       bool hasImages = false;

//       for (final asset in images) {
//         if (asset.type == AssetType.image) {
//           hasImages = true;
//           break;
//         }
//       }

//       if (hasImages) {
//         imageAlbums.add(album);
//         final List<AssetEntity> albumAssets = await album.getAssetListRange(
//             start: 0, end: 1); // Load one asset from the album

//         if (albumAssets.isNotEmpty) {
//           final File? thumbnailFile = await albumAssets[0].file;
//           if (thumbnailFile != null) {
//             // Store the thumbnail file for the album
//             albumThumbnailMap[album.id] = thumbnailFile;
//             //  imageThumbnailFiles.ada
//           }
//         }
//       }
//     }

//     if (imageAlbums.isNotEmpty) {
//       final AssetPathEntity allImagesAlbum =
//           imageAlbums.first; // Use the first album for all images
//       final List<AssetEntity> images = await allImagesAlbum.getAssetListRange(
//           start: 0, end: allImagesAlbum.assetCount);

//       for (final asset in images) {
//         final file = await asset.file;
//         if (file != null) {
//           // newImageFiles.add(file);
//           final format = await Utilites.getFileFormat(file);
//           if (format == 'jpeg' || format == 'png') {
//             try {
//               /*  final bytes = await file.readAsBytes();
//             final uint8ListBytes = Uint8List.fromList(bytes);
//            imageBytesList.add(uint8ListBytes);*/
//               imageFiles.add(file);
//             } catch (e) {
//               print('Error reading image file: $e');
//               // Handle the error if needed
//             }
//           }
//         }
//       }
//     }
//     print('Gallery Images List: ${imageFiles.length}');
//     isDataLoading.value = false;
//     albums.value = imageAlbums;
//   }
// }
