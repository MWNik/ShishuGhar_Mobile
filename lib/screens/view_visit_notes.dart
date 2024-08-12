import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/style/styles.dart';

class ViewVisitScreen extends StatefulWidget {
  const ViewVisitScreen({super.key});

  @override
  State<ViewVisitScreen> createState() => _ViewVisitScreenState();
}

class _ViewVisitScreenState extends State<ViewVisitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: CustomText.AddVisitnote,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xffE0E0E0)),
                  borderRadius: BorderRadius.circular(10.r)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: CustomText.Creche,
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
                            text: "${CustomText.GramPanchayat} : ",
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
                            text: CustomText.Villages,
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
                            text: "${CustomText.HamletPadanearest} : ",
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
                            text: "${CustomText.Landmark} : ",
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
                            text: CustomText.NameRespondent,
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
                            text: CustomText.AgeofRespondents,
                            style: Styles.Grey104,
                            children: [
                              TextSpan(
                                  text: "Anjali Sharna",
                                  style: Styles.black125),
                            ])),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
