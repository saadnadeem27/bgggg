// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:object_remover_app/constants/colors.dart';
// import 'package:object_remover_app/controller/tutorial_controller.dart';

// List<TutorialModel> tabs = [
//   TutorialModel(
//       'If your selected area is not correct, click undo and do it again for better results'),
//   TutorialModel(
//       'If you do undo, And then you realize that you actually did want to have that then you would redo function'),
//   TutorialModel(
//     'You can adjust the size of the brush by dragging the pointer.',
//   ),
// ];

// class Tutorial extends StatefulWidget {
//   const Tutorial({super.key});
//   @override
//   State<Tutorial> createState() => _TutorialState();
// }

// class _TutorialState extends State<Tutorial> {
//   //final PageController _pageController = PageController();
//   final TutorialController tutorialController = Get.put(TutorialController());
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         Obx(() {
//           return Container();
//         });
//         showDialog(
//             barrierDismissible: false,
//             context: context,
//             barrierColor: const Color(0xff0F0F0F).withOpacity(0.9),
//             builder: (context) {
//               return AlertDialog(
//                   elevation: 0,
//                   backgroundColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.r)),
//                   contentPadding: EdgeInsets.zero,
//                   actionsPadding: EdgeInsets.zero,
//                   //insetPadding: EdgeInsets.zero,
//                   content: Obx(() {
//                     return Scaffold(
//                       backgroundColor: Colors.transparent,
//                       resizeToAvoidBottomInset: false,
//                       appBar: AppBar(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                         leading: IconButton(
//                           icon: const Icon(
//                             Icons.close,
//                             color: Colors.white,
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                       body: Center(
//                         child: Stack(
//                           children: [
//                             Container(
//                               height: 385.h,
//                               width: 306.w,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(20.r)),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: 55.h,
//                                     decoration: BoxDecoration(
//                                       color: AppColors.primaryColor,
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(20.r),
//                                         topRight: Radius.circular(20.r),
//                                       ),
//                                     ),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             if (tutorialController
//                                                     .tutorialIndex.value ==
//                                                 0) {
//                                               tutorialController.nextTutorial();
//                                             }
//                                           },
//                                           child: Column(
//                                             children: [
//                                               SvgPicture.asset(
//                                                   'assets/icons/undo_icon.svg'),
//                                               const Text(
//                                                 'Undo',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Text(
//                                           'Pro Tips',
//                                           style: TextStyle(
//                                               fontSize: 14.sp,
//                                               color: Colors.white),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             if (tutorialController
//                                                     .tutorialIndex.value ==
//                                                 1) {
//                                               tutorialController.nextTutorial();
//                                             }
//                                           },
//                                           child: Column(
//                                             children: [
//                                               SvgPicture.asset(
//                                                   'assets/icons/redo_icon.svg'),
//                                               const Text(
//                                                 'Redo',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Flexible(
//                                     child: PageView.builder(
//                                       itemCount: tabs.length,
//                                       controller:
//                                           tutorialController.pageController,
//                                       physics:
//                                           const NeverScrollableScrollPhysics(),
//                                       itemBuilder: (context, index) {
//                                         return Column(
//                                           children: [
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                   top: 21.r,
//                                                   left: 21.r,
//                                                   right: 21.r),
//                                               child: Text(
//                                                 // tabs[index].title,
//                                                 tabs[index].title,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 12.sp),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 13.h,
//                                             ),
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(8.r),
//                                               child: Container(
//                                                 height: tutorialController
//                                                             .tutorialIndex
//                                                             .value ==
//                                                         2
//                                                     ? 170
//                                                     : 200,
//                                                 width: double.infinity,
//                                                 decoration:
//                                                     const BoxDecoration(),
//                                                 child: SvgPicture.asset(
//                                                   'assets/images/t2.svg',
//                                                   height: tutorialController
//                                                               .tutorialIndex
//                                                               .value ==
//                                                           2
//                                                       ? 170
//                                                       : 200,
//                                                   width: double.infinity,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ),
//                                             if (tutorialController
//                                                     .tutorialIndex.value ==
//                                                 2)
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 29.sp),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     SvgPicture.asset(
//                                                       'assets/icons/stroke_icon.svg',
//                                                       width: 23.w,
//                                                       height: 23.h,
//                                                     ),
//                                                     Expanded(
//                                                       child: SliderTheme(
//                                                         data: SliderTheme.of(
//                                                                 context)
//                                                             .copyWith(
//                                                           activeTrackColor:
//                                                               const Color(
//                                                                   0xffE5716E),

//                                                           thumbColor: const Color(
//                                                               0xffE5716E), // Color of the thumb
//                                                           overlayColor: Colors
//                                                               .blue
//                                                               .withOpacity(
//                                                                   0.3), // Color of the thumb overlay
//                                                           thumbShape:
//                                                               const RoundSliderThumbShape(
//                                                                   enabledThumbRadius:
//                                                                       10.0),
//                                                           overlayShape:
//                                                               const RoundSliderOverlayShape(
//                                                                   overlayRadius:
//                                                                       20.0),
//                                                         ),
//                                                         child: Slider(
//                                                           value: 0.5,
//                                                           onChanged:
//                                                               (newValue) {
//                                                             // setState(() {
//                                                             //   strokeWidth =
//                                                             //       newValue;
//                                                             // });
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                           ],
//                                         );
//                                       },
//                                       // onPageChanged: (value) {
//                                       //   tutorialController.tutorialIndex.value =
//                                       //       value; // Update tutorial index
//                                       //   if (value < 3) {
//                                       //     // tutorialController.getTutorialIndex(value);
//                                       //   } else {
//                                       //     Navigator.pop(context);
//                                       //     //tutorialController.getTutorialIndex(value);
//                                       //   }
//                                       // },
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 13.h,
//                                   ),
//                                   Obx(() {
//                                     return Padding(
//                                       padding:
//                                           const EdgeInsets.only(bottom: 8.0),
//                                       child: Row(
//                                         //mainAxisSize: MainAxisSize.min,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           for (int index = 0;
//                                               index < tabs.length;
//                                               index++)
//                                             _DotIndicator(
//                                                 isSelected: index ==
//                                                     tutorialController
//                                                         .tutorialIndex.value),
//                                         ],
//                                       ),
//                                     );
//                                   }),
//                                 ],
//                               ),
//                             ),
//                             if (tutorialController.tutorialIndex.value == 0)
//                               Positioned(
//                                 top: 30.h,
//                                 right: 225.w,
//                                 child:
//                                     SvgPicture.asset('assets/images/t_f1.svg'),
//                               ),
//                             if (tutorialController.tutorialIndex.value == 1)
//                               Positioned(
//                                 top: 30.h,
//                                 right: 40.w,
//                                 child:
//                                     SvgPicture.asset('assets/images/t_f1.svg'),
//                               ),
//                           ],
//                         ),
//                       ),
//                       bottomNavigationBar:
//                           tutorialController.tutorialIndex.value == 2
//                               ? GestureDetector(
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                     tutorialController.tutorialIndex.value = 0;
//                                   },
//                                   child: Container(
//                                     height: 48.h,
//                                     // width: 199.w,
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xffE5716E),
//                                       borderRadius: BorderRadius.circular(24.4),
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Color(0xffE5716E),
//                                           offset: Offset(0, 4),
//                                           blurRadius: 18.0,
//                                           spreadRadius: 0.0,
//                                         ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         'Continue',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16.sp),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : const SizedBox.shrink(),
//                     );
//                   }));
//             });
//       },
//       child: const Text('Start tutorial'),
//     );
//   }
// }

// class _DotIndicator extends StatelessWidget {
//   final bool isSelected;
//   const _DotIndicator({Key? key, required this.isSelected}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 6.0),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 30),
//         height: 6.0,
//         width: 6.0,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isSelected ? Colors.blue : const Color.fromARGB(255, 0, 0, 0),
//         ),
//       ),
//     );
//   }
// }

// class TutorialModel {
//   final String title;
//   TutorialModel(this.title);
// }
