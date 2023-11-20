
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


class EraserScreen extends StatefulWidget {
  const EraserScreen({super.key});

  @override
  State<EraserScreen> createState() => _EraserScreenState();
}

class _EraserScreenState extends State<EraserScreen> {
  double strokeWidth = 0.5;
  // final imageController = Get.put(ImageController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 25.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Erase the objects in your image',
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SvgPicture.asset(
                'assets/icons/info_icon.svg',
                width: 21.w,
                height: 21.h,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),

        ///////
        // Container(
        //   height: 386.h,
        //   width: 327.w,
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(12.r),
        //       border: Border.all(color: Colors.black)),
        //   child: const SizedBox.shrink(),
        //   //child: const SizedBox.shrink(),
        // ),
        // SizedBox(
        //   height: 20.h,
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 29.sp),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       SvgPicture.asset(
        //         'assets/icons/stroke_icon.svg',
        //         width: 23.w,
        //         height: 23.h,
        //       ),
        //       Expanded(
        //         child: SliderTheme(
        //           data: SliderTheme.of(context).copyWith(
        //             activeTrackColor: const Color(0xffE5716E),

        //             thumbColor: const Color(0xffE5716E), // Color of the thumb
        //             overlayColor: Colors.blue
        //                 .withOpacity(0.3), // Color of the thumb overlay
        //             thumbShape:
        //                 const RoundSliderThumbShape(enabledThumbRadius: 10.0),
        //             overlayShape:
        //                 const RoundSliderOverlayShape(overlayRadius: 20.0),
        //           ),
        //           child: Slider(
        //             value: strokeWidth,
        //             onChanged: (newValue) {
        //               setState(() {
        //                 strokeWidth = newValue;
        //               });
        //             },
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   height: 10.h,
        // ),
        // const Tutorial(),
      ],
    );
  }
}
