import 'dart:collection';

import 'package:custom_pkg_obj_remove/pkg/src/controllers/drawables/background/image_background_drawable.dart';
import 'package:get/get.dart';

class UndoRedoManager<T> {
  Queue<T> undoQueue = Queue<T>();
  Queue<T> redoQueue = Queue<T>();

  void addToUndo(T action) {
    undoQueue.addLast(action);
    redoQueue.clear(); // Clear redo queue when a new action is added
  }

  T? undo() {
    if (undoQueue.isNotEmpty) {
      T action = undoQueue.removeLast();
      redoQueue.addLast(action); // Add to redo queue
      // return action;
      return undoQueue.isNotEmpty ? undoQueue.last : null;
    }
    return null; // Nothing to undo
  }

  T? redo() {
    if (redoQueue.isNotEmpty) {
      T action = redoQueue.removeLast();
      undoQueue.addLast(action); // Add to undo queue
      // return action;
      return redoQueue.isNotEmpty ? redoQueue.last : null;
    }
    return null; // Nothing to redo
  }
}

class ImageUndoRedoController extends GetxController {
  final List<ImageBackgroundDrawable> imageStates = [];
  final UndoRedoManager<List<ImageBackgroundDrawable>> imageManager =
      UndoRedoManager<List<ImageBackgroundDrawable>>();
  int currentIndex = -1;
  RxList<ImageBackgroundDrawable> images = <ImageBackgroundDrawable>[].obs;
  final Rx<ImageBackgroundDrawable?> realImg =
      Rx<ImageBackgroundDrawable?>(null);
  final Rx<ImageBackgroundDrawable?> respImg =
      Rx<ImageBackgroundDrawable?>(null);

  void addImage(ImageBackgroundDrawable imageVal) {
    imageStates.add(imageVal);
    currentIndex++;
    print('currentIndex : $currentIndex ');
  }

  void getRealImg(ImageBackgroundDrawable val) {
    print('currentIndexx : $currentIndex ');
    realImg.value = val;
    imageManager.addToUndo([realImg.value!, ...images]);
    images.assignAll([realImg.value!]);
  }

  void getRespImg(ImageBackgroundDrawable val) {
    respImg.value = val;
  }

  void undo() {
    print('currentIndex : $currentIndex ');
    if (currentIndex > 0) {
      currentIndex--;
      images.assignAll([imageStates[currentIndex]]);
    } else if (currentIndex == 0) {
      currentIndex = -1;
      // When the user reaches the first image state, show the real image.
      images.assignAll([realImg.value!]);
    }
  }

  void redo() {
    print('currentIndex : $currentIndex ');
    print('images States : ${imageStates.length}');
    if (currentIndex < imageStates.length - 1) {
      currentIndex++;
      images.assignAll([imageStates[currentIndex]]);
    } else if (currentIndex == imageStates.length - 1) {
      // When the user reaches the last image state, show the respImg.
      images.assignAll([respImg.value!]);
    }
  }
}
