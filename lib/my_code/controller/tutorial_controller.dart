
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:object_remover_app/widgets/tutorial/tutorial.dart';
// class TutorialController extends GetxController {
//   RxInt tutorialIndex = 0.obs;
//   final PageController pageController =
//       PageController(); // Add a PageController
//   final List<TutorialModel> history = [];
//   void nextTutorial() {
//     if (tutorialIndex < tabs.length - 1) {
//       tutorialIndex++;
//       pageController.animateToPage(tutorialIndex.value,
//           duration: const Duration(milliseconds: 300), curve: Curves.ease);
//     }
//   }
//   void previousTutorial() {
//     if (tutorialIndex > 0) {
//       tutorialIndex--;
//       pageController.animateToPage(tutorialIndex.value,
//           duration: const Duration(milliseconds: 300), curve: Curves.ease);
//     }
//   }
//   // Function to save the current state to the history
//   void saveState() {
//     history.add(tabs[tutorialIndex.value]);
//   }
// }