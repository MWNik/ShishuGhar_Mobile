import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/style/styles.dart';

class HHProfileListingScreen extends StatefulWidget {
  const HHProfileListingScreen({super.key});

  @override
  State<HHProfileListingScreen> createState() => _HHProfileListingScreenState();
}

class _HHProfileListingScreenState extends State<HHProfileListingScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xffE7F0FF)),
                  borderRadius: BorderRadius.circular(10.r)),
              height: 103.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: CustomText.Districts,
                                style: Styles.Grey104,
                                children: [
                                  TextSpan(
                                      text: "Anjali Sharna",
                                      style: Styles.black125),
                                ])),
                        RichText(
                            strutStyle: StrutStyle(height: 1.h),
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: CustomText.Blocks,
                                style: Styles.Grey104,
                                children: [
                                  TextSpan(
                                      text: "Supervisor",
                                      style: Styles.black125),
                                ])),
                        RichText(
                            strutStyle: StrutStyle(height: 1.h),
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: CustomText.Villages,
                                style: Styles.Grey104,
                                children: [
                                  TextSpan(
                                      text: "Supervisor",
                                      style: Styles.black125),
                                ])),
                        RichText(
                            strutStyle: StrutStyle(height: 1.h),
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: CustomText.NameRespondent,
                                style: Styles.Grey104,
                                children: [
                                  TextSpan(
                                      text: "Supervisor",
                                      style: Styles.black125),
                                ])),
                        RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: CustomText.LastMeasurement,
                                style: Styles.black64,
                                children: [
                                  TextSpan(
                                      text: " Dec 1, 2023",
                                      style: Styles.black66),
                                ]))
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        index % 2 == 0
                            ? Image.asset(
                                "assets/verify.png",
                                scale: 2.2,
                              )
                            : Image.asset(
                                "assets/greyverify.png",
                                scale: 3.7,
                              ),

                        //     Column(
                        //       children: [
                        //         index % 2 == 0
                        //             ? Image.asset(
                        //                 "assets/time.png",
                        //                 scale: 2.2,
                        //               )
                        //             : Image.asset(
                        //                 "assets/sync.png",
                        //                 scale: 2.2,
                        //               ),
                        //         // SizedBox(
                        //         //   height: 2.h,
                        //         // ),
                        //         // Text(
                        //         //   index % 2 == 0
                        //         //       ? CustomText.PendingSync
                        //         //       : CustomText.Sync,
                        //         //   style: Styles.black54,
                        //         //   textAlign: TextAlign.center,
                        //         // )
                        //       ],
                        //     ),
                        //     // Spacer(),
                        //     SizedBox(
                        //       height: 5.h,
                        //     ),
                        //     Column(
                        //       children: [
                        //         index % 2 == 0
                        //             ? Image.asset(
                        //                 "assets/person.png",
                        //                 scale: 2.2,
                        //               )
                        //             : Image.asset(
                        //                 "assets/verify.png",
                        //                 scale: 2.2,
                        //               ),
                        //         // SizedBox(
                        //         //   height: 2.h,
                        //         // ),
                        //         // Text(
                        //         //   index % 2 == 0
                        //         //       ? CustomText.PendingVerification
                        //         //       : CustomText.Verify,
                        //         //   textAlign: TextAlign.center,
                        //         //   style: Styles.black54,
                        //         // )
                        //       ],
                        //     ),
                        //     // Spacer(),
                        //     // Image.asset(
                        //     //   "assets/dot.png",
                        //     //   scale: 2,
                        //     // ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
