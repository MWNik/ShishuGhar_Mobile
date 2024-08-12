import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/screens/Adddaily_attendance.dart';
import 'package:shishughar/style/styles.dart';

class ChildAttendanceScreen extends StatefulWidget {
  const ChildAttendanceScreen({super.key});

  @override
  State<ChildAttendanceScreen> createState() => _ChildAttendanceScreenState();
}

class _ChildAttendanceScreenState extends State<ChildAttendanceScreen> {
  TextEditingController SearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddDailyAttendanceScreen()));
        },
        child: Image.asset(
          "assets/add_btn.png",
          scale: 2.7,
          color: Color(0xff5979AA),
        ),
      ),
      appBar: CustomAppbar(
        text: CustomText.Childattendance,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextFieldRow(
                    controller: SearchController,
                    hintText: CustomText.Search,
                    prefixIcon: Image.asset(
                      "assets/search.png",
                      scale: 2.4,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Image.asset(
                  "assets/filter_icon.png",
                  scale: 2.4,
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 32.h,
              decoration: BoxDecoration(
                  color: Color(0xff5979AA),
                  borderRadius: BorderRadius.circular(5.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 12.sp,
                      color: Colors.white,
                    ),
                    Spacer(),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: CustomText.Daily,
                            style: Styles.white124P,
                            children: [
                              TextSpan(text: "88", style: Styles.white126P),
                            ])),
                    SizedBox(
                      width: 10.w,
                    ),
                    VerticalDivider(
                      color: Colors.white,
                      endIndent: 10,
                      indent: 10,
                      thickness: 1.5,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: CustomText.Monthly,
                            style: Styles.white124P,
                            children: [
                              TextSpan(text: "0", style: Styles.white126P),
                            ])),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 12.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 2,
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
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: CustomText.Date,
                                          style: Styles.black104,
                                          children: [
                                            TextSpan(
                                                text: "03 Nov 2023",
                                                style: Styles.black125),
                                          ])),
                                  RichText(
                                      strutStyle: StrutStyle(height: 1.2.h),
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: CustomText.Villages,
                                          style: Styles.black104,
                                          children: [
                                            TextSpan(
                                                text: "Mermahul",
                                                style: Styles.black125),
                                          ])),
                                  RichText(
                                      strutStyle: StrutStyle(height: 1.2.h),
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: CustomText.Children,
                                          style: Styles.black104,
                                          children: [
                                            TextSpan(
                                                text: "12",
                                                style: Styles.black125),
                                          ])),
                                  RichText(
                                      strutStyle: StrutStyle(height: 1.2.h),
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: CustomText.Caregiver,
                                          style: Styles.black104,
                                          children: [
                                            TextSpan(
                                                text: "2",
                                                style: Styles.black125),
                                          ])),
                                  RichText(
                                      strutStyle: StrutStyle(height: 1.2.h),
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: CustomText.Submitedon,
                                          style: Styles.black104,
                                          children: [
                                            TextSpan(
                                                text: "23 Nov 2023",
                                                style: Styles.black125),
                                          ]))
                                ],
                              ),
                              // Spacer(),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 10.h),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Image.asset(
                              //         "assets/dot.png",
                              //         scale: 2.5,
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
