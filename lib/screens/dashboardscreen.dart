// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/screens/Adddaily_attendance.dart';
// import 'package:shishughar/screens/childProfileScreen.dart';
// import 'package:shishughar/screens/child_Attendance.dart';
// import 'package:shishughar/screens/child_Enrolled.dart';
// import 'package:shishughar/screens/children_enrollment_profile.dart';
// import 'package:shishughar/screens/home_screen.dart';
// import 'package:shishughar/screens/synchronization_screen.dart';
// import 'package:shishughar/screens/tabed_screens/creshe/cereche_listed_screen.dart';
// import 'package:shishughar/screens/visit_notes.dart';
//
// import '../database/helper/translation_language_helper.dart';
// import '../model/apimodel/translation_language_api_model.dart';
// import '../style/styles.dart';
// import '../utils/globle_method.dart';
// import '../utils/validate.dart';
// import 'linelistedhouseholld.dart';
// import 'location_screen.dart';
//
// // ignore: must_be_immutable
// class DashboardScreen extends StatefulWidget {
//   int? index;
//
//   DashboardScreen({super.key, this.index});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
//
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   int _currentIndex = 0;
//   List pages = [
//     HomeScreen(),
//     LineholdlistedScreen(),
//     ChildEnrolledScreen(),
//     VisitNotesScreen(),
//     ChildAttendanceScreen(),
//     ChildrenEnrollmentProfileScreen(),
//     ChildAttendanceScreen(),
//     AddDailyAttendanceScreen(),
//     ChildProfileScreen(),
//     SynchronizationScreen(),
//     CrecheListedScreen()
//   ];
//   String? lng ;
//   List<Translation> dashboardControlls = [];
//   String? role;
//   // List<BottomNavigationBarItem> bottomItem = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return (dashboardControlls.length>0)?Scaffold(
//       body: pages[widget.index!],
//       bottomNavigationBar: BottomNavigationBar(
//         useLegacyColorScheme: true,
//         showUnselectedLabels: true,
//         showSelectedLabels: true,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Color(0xffAAAAAA),
//         selectedLabelStyle: Styles.Selectedbottambar,
//         unselectedLabelStyle: Styles.unSelectedbottambar,
//         unselectedIconTheme: IconThemeData(color: Colors.red),
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//           setOnClick(_currentIndex);
//
//         },
//         items: initBottomBar(),
//       ),
//     ):SizedBox();
//   }
//
//   Future<void> initializeData() async {
//     lng = await Validate().readString(Validate.sLanguage);
//     role = await Validate().readString(Validate.role);
//     List<String> valueNames = ['Home', 'Check In', 'More','Report','Enrolled Child','Dashboard','Synchronization'];
//
//     await TranslationDataHelper()
//         .callTranslateString(valueNames)
//         .then((value) => dashboardControlls = value);
//
//     setState(() {});
//   }
//
//    setOnClick(int index)  {
//      // if (_currentIndex == 1) {
//      //   if (role == CustomText.crecheSupervisor) {
//      //     Navigator.pushReplacement(
//      //         context,
//      //         MaterialPageRoute(
//      //           builder: (context) => LocationScreen(),
//      //         ));
//      //   } else {
//      //     Navigator.push(
//      //         context,
//      //         MaterialPageRoute(
//      //           builder: (context) => SynchronizationScreen(),
//      //         ));
//      //   }
//      // }
//      // else if (_currentIndex == 2) {
//      //   Navigator.push(
//      //       context,
//      //       MaterialPageRoute(
//      //         builder: (context) => SynchronizationScreen(),
//      //       ));
//      // }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initializeData();
//   }
//
//   List<BottomNavigationBarItem>  initBottomBar(){
//     List<BottomNavigationBarItem> bottomItem = [];
//     bottomItem.add(BottomNavigationBarItem(
//       icon: Padding(
//         padding: EdgeInsets.only(bottom: 5.h),
//         child: Image.asset(
//           "assets/home.png",
//           scale: 2.7,
//           color: _currentIndex == 0 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//         ),
//       ),
//       label: Global.returnTrLable(dashboardControlls, 'Home', lng!),
//     ));
//     bottomItem.add(BottomNavigationBarItem(
//       icon: Padding(
//         padding: EdgeInsets.only(bottom: 5.h),
//         child: Image.asset(
//           "assets/childenrolled.png",
//           scale: 2.7,
//           color: _currentIndex == 1 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//         ),
//       ),
//       label: Global.returnTrLable(dashboardControlls, 'Enrolled Child', lng!),
//     ));
//     bottomItem.add(BottomNavigationBarItem(
//       icon: Padding(
//         padding: EdgeInsets.only(bottom: 5.h),
//         child: Image.asset(
//           "assets/dashboard.png",
//           scale:4,
//           color: _currentIndex == 2 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//         ),
//       ),
//       label: Global.returnTrLable(dashboardControlls, 'Dashboard', lng!),
//     ));
//     bottomItem.add(BottomNavigationBarItem(
//       icon: Padding(
//         padding: EdgeInsets.only(bottom: 5.h),
//         child: Image.asset(
//           "assets/report_ic.png",
//           scale: 4,
//           color: _currentIndex == 3 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//         ),
//       ),
//       label: Global.returnTrLable(dashboardControlls, 'Report', lng!),
//     ));
//     bottomItem.add(BottomNavigationBarItem(
//       icon: Padding(
//         padding: EdgeInsets.only(bottom: 10.h),
//         child: Image.asset(
//           "assets/more.png",
//           scale: 2.3,
//           color: _currentIndex == 4 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//         ),
//       ),
//       label: Global.returnTrLable(dashboardControlls, 'More', lng!),
//     ));
//     // if (role == CustomText.crecheSupervisor) {
//     //   bottomItem.add(BottomNavigationBarItem(
//     //     icon: Padding(
//     //       padding: EdgeInsets.only(bottom: 5.h),
//     //       child: Icon(
//     //         Icons.location_on,
//     //         color: _currentIndex == 1 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//     //       ),
//     //     ),
//     //     label: Global.returnTrLable(dashboardControlls, 'Check In', lng!),
//     //   ));
//     // }
//     // bottomItem.add(BottomNavigationBarItem(
//     //   icon: Padding(
//     //     padding: EdgeInsets.only(bottom: 5.h),
//     //     child: Icon(
//     //       Icons.sync,
//     //       color: _currentIndex == 1 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//     //     ),
//     //   ),
//     //   label: Global.returnTrLable(dashboardControlls, 'Synchronization', lng!),
//     // ));
// return bottomItem;
//   }
// }
