// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fyp_numl/screens/welcome_screen.dart';
// import 'package:lottie/lottie.dart';

// import '../model/arc_painter.dart';
// import '../widgets/rounded_button.dart';
// import 'login_screen.dart';

// List<OnboardingModel> tabs = [
//   OnboardingModel('assets/ob_1.json', 'Automatic Adjustments',
//       'By allowing for automatic adjustments in the scheduling process, our timetable generator saves time and resources for academic institution.'),
//   OnboardingModel('assets/ob_3.json', 'Clash Avoidance',
//       'It helps to ensure that classes or events do not overlap, which can create confusion and chaos.'),
//   OnboardingModel(
//     'assets/ob_2.json',
//     'Consistent Feedback',
//     'The timetable generator can provide real-time updates to users, so they can see changes as they are made to the schedule.',
//   ),
// ];

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({Key? key}) : super(key: key);

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   int _currentIndex = 0;
//   DateTime? _lastPressedAt;

//   final PageController _pageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       // backgroundColor: const Color(0xff1f005c),
//       body: WillPopScope(
//         onWillPop: _onWillPop,
//         child: Center(
//           child: Stack(
//             children: [
//               CustomPaint(
//                 painter: ArcPainter(),
//                 child: SizedBox(
//                   height: screenSize.height / 1.4,
//                   width: screenSize.width,
//                 ),
//               ),
//               Visibility(
//                 visible: _currentIndex != 2,
//                 child: Positioned(
//                   // bottom: 35,
//                   // left: 40,
//                   bottom: MediaQuery.of(context).size.height * .04,
//                   left: MediaQuery.of(context).size.height * .04,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => WelcomeScreen()),
//                       );
//                     },
//                     child: const Text(
//                       'Skip Now',
//                       style: TextStyle(
//                         // fontSize: 15.0,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 50,
//                 right: 30,
//                 left: 30,
//                 child: FutureBuilder<LottieComposition?>(
//                   future: _loadLottieFile(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return Lottie(
//                         composition: snapshot.data!,
//                         key: Key('${Random().nextInt(999999999)}'),
//                         width: 600,
//                         alignment: Alignment.topCenter,
//                       );
//                     } else if (snapshot.hasError) {
//                       return const Text('Error loading animation');
//                     } else {
//                       return const CircularProgressIndicator();
//                     }
//                   },
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: SizedBox(
//                   height: 290,
//                   child: Column(
//                     children: [
//                       Flexible(
//                         child: PageView.builder(
//                           controller: _pageController,
//                           itemCount: tabs.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             OnboardingModel tab = tabs[index];
//                             return Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   tab.title,
//                                   style: const TextStyle(
//                                     fontSize: 27.0,
//                                     color: Color(0xFF1B09BE),
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Container(
//                                   constraints:
//                                       const BoxConstraints(maxWidth: 330),
//                                   child: Text(
//                                     tab.subtitle,
//                                     style: const TextStyle(
//                                       fontSize: 15.0,
//                                       color: Colors.black87,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 )
//                               ],
//                             );
//                           },
//                           onPageChanged: (value) {
//                             _currentIndex = value;
//                             setState(() {});
//                           },
//                         ),
//                       ),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           for (int index = 0; index < tabs.length; index++)
//                             _DotIndicator(isSelected: index == _currentIndex),
//                         ],
//                       ),
//                       const SizedBox(height: 95)
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: _currentIndex == 2
//           ? SizedBox(
//               height: 50,
//               width: MediaQuery.of(context).size.width * .92,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const WelcomeScreen(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   primary: Color(0xff1f005c),
//                   onPrimary: Colors.white,
//                 ),
//                 child: Text(
//                   'Get Started',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             )
//           : FloatingActionButton(
//               onPressed: () {
//                 _pageController.nextPage(
//                   duration: const Duration(milliseconds: 150),
//                   curve: Curves.linear,
//                 );
//               },
//               backgroundColor: Color.fromARGB(255, 0, 0, 0),
//               child:
//                   const Icon(CupertinoIcons.chevron_right, color: Colors.white),
//             ),
//     );
//   }

//   Future<LottieComposition?> _loadLottieFile() async {
//     try {
//       final data = await rootBundle.load(tabs[_currentIndex].lottieFile);
//       return await LottieComposition.fromByteData(data);
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<bool> _onWillPop() async {
//     final now = DateTime.now();
//     if (_lastPressedAt == null ||
//         now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
//       _lastPressedAt = now;
//       Fluttertoast.showToast(
//         msg: 'Press again to exit',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 2,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return false;
//     }
//     return true;
//   }
// }

// // class ArcPainter extends CustomPainter {
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     Path orangeArc = Path()
// //       ..moveTo(0, 0)
// //       ..lineTo(0, size.height - 170)
// //       ..quadraticBezierTo(
// //           size.width / 2, size.height, size.width, size.height - 170)
// //       ..lineTo(size.width, size.height)
// //       ..lineTo(size.width, 0)
// //       ..close();

// //     canvas.drawPath(
// //         orangeArc, Paint()..color = const Color.fromRGBO(33, 150, 243, 1));

// //     Path whiteArc = Path()
// //       ..moveTo(0.0, 0.0)
// //       ..lineTo(0.0, size.height - 185)
// //       ..quadraticBezierTo(
// //           size.width / 2, size.height - 70, size.width, size.height - 185)
// //       ..lineTo(size.width, size.height)
// //       ..lineTo(size.width, 0)
// //       ..close();

// //     canvas.drawPath(
// //         whiteArc, Paint()..color = Color.fromARGB(228, 255, 255, 255));
// //   }

// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) {
// //     return false;
// //   }
// // }

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
//           color: isSelected ? Colors.blue : Color.fromARGB(255, 0, 0, 0),
//         ),
//       ),
//     );
//   }
// }

// class OnboardingModel {
//   final String lottieFile;
//   final String title;
//   final String subtitle;

//   OnboardingModel(this.lottieFile, this.title, this.subtitle);
// }
