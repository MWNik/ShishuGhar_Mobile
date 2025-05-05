import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/screens/Adddaily_attendance.dart';
import 'package:shishughar/screens/childProfileScreen.dart';
import 'package:shishughar/screens/child_Attendance.dart';
import 'package:shishughar/screens/child_Enrolled.dart';
import 'package:shishughar/screens/children_enrollment_profile.dart';
import 'package:shishughar/screens/home_replica_screen.dart';
import 'package:shishughar/screens/synchronization_screen.dart';
import 'package:shishughar/screens/synchronization_screen_new.dart';
import 'package:shishughar/screens/tabed_screens/creshe/cereche_listed_screen.dart';
import 'package:shishughar/screens/tabed_screens/enrolled_children/children_enrolled_for_cc_listed.dart';
import 'package:shishughar/screens/visit_notes.dart';

import '../database/helper/translation_language_helper.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../style/styles.dart';
import '../utils/globle_method.dart';
import '../utils/validate.dart';
import 'dashboard_report_for_all_creche_by_api.dart';
import 'linelistedhouseholld.dart';

class DashboardScreen extends StatefulWidget {
  int? index;

  DashboardScreen({super.key, this.index});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  List pages = [
    HomeReplicaScreen(),
    ChildEnrolledScreen(),
    ChildEnrolledScreen(),
    VisitNotesScreen(),
    ChildAttendanceScreen(),
    ChildrenEnrollmentProfileScreen(),
    ChildAttendanceScreen(),
    AddDailyAttendanceScreen(),
    ChildProfileScreen(),
    SynchronizationScreenNew(),
    CrecheListedScreen()
  ];
  String lng="en";
  List<Translation> dashboardControlls = [];
  String? role;

  @override
  Widget build(BuildContext context) {
    // return (dashboardControlls.length > 0)
    //     ?
      return Scaffold(
            body: pages[widget.index!],
            bottomNavigationBar: BottomNavigationBar(
              useLegacyColorScheme: true,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              selectedItemColor: Colors.black,
              unselectedItemColor: Color(0xffAAAAAA),
              selectedLabelStyle: Styles.Selectedbottambar,
              unselectedLabelStyle: Styles.unSelectedbottambar,
              unselectedIconTheme: IconThemeData(color: Colors.red),
              currentIndex: _currentIndex,
              onTap: (index) async {
                setState(() {
                  _currentIndex = index;
                });
                await setOnClick(_currentIndex);
              },
              items: initBottomBar(),
            ),
          );
        // : Scaffold(
        // body:Center(
        // child: Text('please wait')));
  }

  Future<void> initializeData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    role = await Validate().readString(Validate.role);
    List<String> valueNames = [
      CustomText.Home,
      CustomText.checkIN,
      CustomText.More,
      CustomText.Report,
      CustomText.enrolled_children,
      CustomText.Dashboard,
      CustomText.sync,
      CustomText.pleaseWait
    ];
    showLoaderDialog(context);
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => dashboardControlls.addAll(value));
    Navigator.pop(context);
    setState(() {});
  }

  Future setOnClick(int index) async {
    String refreshStatus = '';
    // if (_currentIndex == 1) {
    //   if (role == 'Creche Supervisor') {
    //     Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => LocationScreen(),
    //         ));
    //   } else {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => SynchronizationScreen(),
    //         ));
    //   }
    // }
    // else if (_currentIndex == 2) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => SynchronizationScreen(),
    //       ));
    // }
    if (_currentIndex == 0) {
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => DashboardScreen(index: 0)));
    } else if (_currentIndex == 1) {
      refreshStatus = await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => EnrolledChildrenForCC()));
    } else if (_currentIndex == 2) {
      refreshStatus =  await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => DashboardReportSupeByApiScreen()));
    } else if (_currentIndex == 4) {
      if (HomeReplicaScreen.scaffoldKey != null) {
        HomeReplicaScreen.scaffoldKey!.currentState?.openDrawer();
        setState(() {
          _currentIndex = 0;
        });
      }
    }

    if (refreshStatus == 'itemRefresh') {
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  List<BottomNavigationBarItem> initBottomBar() {
    List<BottomNavigationBarItem> bottomItem = [];
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/home.png",
          scale: 2.7,
          color: _currentIndex == 0 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: Global.returnTrLable(dashboardControlls, CustomText.Home, lng!),
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          'assets/creche_profile/enrolled_child_new.png',
          scale: 2.7,
          color: _currentIndex == 1 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: Global.returnTrLable(
          dashboardControlls, CustomText.enrolled_children, lng!),
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/dashboard.png",
          scale: 4,
          color: _currentIndex == 2 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label:
          Global.returnTrLable(dashboardControlls, CustomText.Dashboard, lng!),
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/report_ic.png",
          scale: 4,
          color: _currentIndex == 3 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: Global.returnTrLable(dashboardControlls, CustomText.Report, lng!),
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Image.asset(
          "assets/more.png",
          scale: 2.3,
          color: _currentIndex == 4 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: Global.returnTrLable(dashboardControlls, CustomText.More, lng!),
    ));
    // if (role == 'Creche Supervisor') {
    //   bottomItem.add(BottomNavigationBarItem(
    //     icon: Padding(
    //       padding: EdgeInsets.only(bottom: 5.h),
    //       child: Icon(
    //         Icons.location_on,
    //         color: _currentIndex == 1 ? Color(0xff5979AA) : Color(0xffAAAAAA),
    //       ),
    //     ),
    //     label: Global.returnTrLable(dashboardControlls, 'Check In', lng!),
    //   ));
    // }
    // bottomItem.add(BottomNavigationBarItem(
    //   icon: Padding(
    //     padding: EdgeInsets.only(bottom: 5.h),Enrolled child Enrolled Child
    //     child: Icon(
    //       Icons.sync,
    //       color: _currentIndex == 1 ? Color(0xff5979AA) : Color(0xffAAAAAA),
    //     ),
    //   ),
    //   label: Global.returnTrLable(dashboardControlls, 'Synchronization', lng!),
    // ));
    return bottomItem;
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 10.h),
                Text(Global.returnTrLable(
                    dashboardControlls, CustomText.pleaseWait, lng!)),
              ],
            ),
          ),
        );
      },
    );
  }
}
