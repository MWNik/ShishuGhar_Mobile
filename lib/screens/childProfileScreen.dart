import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/style/styles.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({super.key});

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  List<String> image = [
    'assets/persons.png',
    'assets/childenroll.png',
    'assets/attendances.png',
    'assets/anthopometry.png',
    'assets/exits.png',
    'assets/vaccine.png',
    'assets/flags.png',
    'assets/growthChart.png',
    // 'assets/rollout.png',
    // 'assets/training.png',
    // 'assets/childrenexit.png',
    // 'assets/flagged.png',
    // 'assets/shishughar.png',
    // 'assets/receip.png',
    // 'assets/cashbook.png',
  ];

  List<String> text = [
    'Profile',
    'Enrollment',
    'Attendance',
    'Anthopometry',

    'Exits',
    'Vaccination',

    'Red Flag Follow-up',
    'Growth Chart',
    // 'Rollout',
    // 'Training & Meeting',
    // 'Children Exiting Shishu Ghar',
    // 'Flagged Children',
    // 'Shishu Ghar Details',
    // 'Requisition & Receipt',
    // 'Cashbook',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: CustomText.ChildProfile,
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
            ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffC5C5C5)),
                        borderRadius: BorderRadius.circular(10.r)),
                    height: 90.h,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
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
                                      text: CustomText.ChildNamedot,
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
                                      text: CustomText.ChildIddot,
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
                                      text: CustomText.MotherName,
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
                                      text: CustomText.Dob,
                                      style: Styles.Grey104,
                                      children: [
                                        TextSpan(
                                            text: " Dec 1, 2023",
                                            style: Styles.black125),
                                      ])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: text.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (ctx, i) {
                  return InkWell(
                    onTap: () async {
                      // if (i == 0) {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (BuildContext context) => DashboardScreen(
                      //             index: 1,
                      //           )));
                      // } else if (i == 1) {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (BuildContext context) => DashboardScreen(
                      //             index: 2,
                      //           )));
                      // } else if (i == 2) {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (BuildContext context) => DashboardScreen(
                      //             index: 3,
                      //           )));
                      // } else if (i == 5) {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (BuildContext context) => DashboardScreen(
                      //             index: 4,
                      //           )));
                      // }
                    },
                    child: Container(
                      height: 168.h,
                      width: 146.w,
                      decoration: BoxDecoration(
                          color: Color(0xffF2F7FF),
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: Color(0xffE7F0FF),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  image[i],
                                  filterQuality: FilterQuality.high,
                                  scale: 4,
                                  color: Color(0xff5979AA),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 7),
                                  child: Text(
                                    text[i],
                                    style: Styles.black86,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    mainAxisExtent: 90.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
