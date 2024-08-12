import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/screens/Add_visit_notes.dart';
import 'package:shishughar/style/styles.dart';

class CrecheProfileViewListScreen extends StatefulWidget {
  const CrecheProfileViewListScreen({super.key});

  @override
  State<CrecheProfileViewListScreen> createState() =>
      _CrecheProfileViewListScreenState();
}

class _CrecheProfileViewListScreenState
    extends State<CrecheProfileViewListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddVisitNotesScreeb()));
        },
        child: Image.asset(
          "assets/add_btn.png",
          scale: 2.7,
          color: Color(0xff5979AA),
        ),
      ),
      appBar: CustomAppbar(
        text: CustomText.CrecheProfileView,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            ListView.builder(
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
                      height: 80.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 8.h),
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
                                        text: CustomText.CrecheName,
                                        style: Styles.black104,
                                        children: [
                                          TextSpan(
                                              text: "Anjali Sharna",
                                              style: Styles.black125),
                                        ])),
                                RichText(
                                    strutStyle: StrutStyle(height: 1.h),
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: CustomText.ChildNo,
                                        style: Styles.black104,
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
                                        style: Styles.black104,
                                        children: [
                                          TextSpan(
                                              text: " Dec 1, 2023",
                                              style: Styles.black125),
                                        ])),
                                RichText(
                                    strutStyle: StrutStyle(height: 1.h),
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: '${CustomText.GramPanchayat} : ',
                                        style: Styles.black104,
                                        children: [
                                          TextSpan(
                                              text: "Supervisor",
                                              style: Styles.black125),
                                        ])),
                              ],
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Image.asset(
                                "assets/verify.png",
                                scale: 2.2,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
