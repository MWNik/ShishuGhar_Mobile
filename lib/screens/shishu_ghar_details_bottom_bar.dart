// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/custom_widget/custom_appbar.dart';
// import 'package:shishughar/screens/shishu_ghar_details.dart';
// import 'package:shishughar/screens/tabed_screens/creshe/creshe_tab_screen.dart';
// import 'package:shishughar/screens/tabed_screens/enrolled_children/enrolled_children_listing_tab.dart';
//
// import '../custom_widget/custom_text.dart';
// import '../database/helper/creche_helper/creche_data_helper.dart';
// import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
// import '../database/helper/translation_language_helper.dart';
// import '../model/apimodel/translation_language_api_model.dart';
// import '../style/styles.dart';
// import '../utils/globle_method.dart';
// import '../utils/validate.dart';
// import 'check_in_screen.dart';
// import 'check_ins.dart';
//
// class ShishuGharDetailsBottomBar extends StatefulWidget {
//   final int nameId;
//   int index;
//   ShishuGharDetailsBottomBar(
//       {super.key, required this.nameId, required this.index});
//
//   @override
//   _ShishuGharDetailsBottomBarState createState() =>
//       _ShishuGharDetailsBottomBarState();
// }
//
// class _ShishuGharDetailsBottomBarState
//     extends State<ShishuGharDetailsBottomBar> {
//   String? lng = 'en';
//   List<Translation> locationControlls = [];
//
//   List pages = [
//     ShishuGharDetails(),
//     ShishuGharDetails(),
//     ShishuGharDetails(),
//     CheckIns(),
//     ShishuGharDetails(),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeLabel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return (locationControlls.length > 0)
//         ? Scaffold(
//             body: pages[widget.index],
//             bottomNavigationBar: BottomNavigationBar(
//               useLegacyColorScheme: true,
//               showUnselectedLabels: true,
//               showSelectedLabels: true,
//               selectedItemColor: Colors.black,
//               unselectedItemColor: Color(0xffAAAAAA),
//               selectedLabelStyle: Styles.Selectedbottambar,
//               unselectedLabelStyle: Styles.unSelectedbottambar,
//               unselectedIconTheme: IconThemeData(color: Colors.red),
//               currentIndex: widget.index,
//               onTap: (index) async {
//                 onclick(index);
//                 setState(() {
//                   widget.index = index;
//                 });
//               },
//               items: initBottomTab(),
//             ),
//           )
//         : SizedBox();
//   }
//
//   Future<void> initializeLabel() async {
//     lng = await Validate().readString(Validate.sLanguage);
//
//     List<String> valueNames = [
//       CustomText.checkIN,
//       CustomText.enrolled_children,
//       CustomText.Attendance,
//       CustomText.checkIN,
//       CustomText.Task,
//       CustomText.ShishuGharDetails,
//       CustomText.Home
//     ];
//
//     await TranslationDataHelper()
//         .callTranslateString(valueNames)
//         .then((value) => locationControlls = value);
//     setState(() {});
//   }
//
//   List<BottomNavigationBarItem> initBottomTab() {
//     List<BottomNavigationBarItem> bottomItem = [];
//     bottomItem.add(BottomNavigationBarItem(
//       icon: Padding(
//         padding: EdgeInsets.only(bottom: 5.h),
//         child: Image.asset(
//           "assets/home.png",
//           scale: 2,
//           color: widget.index == 0 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//         ),
//       ),
//       label: Global.returnTrLable(locationControlls, CustomText.Home, lng!),
//     ));
//     // bottomItem.add(BottomNavigationBarItem(
//     //   icon: Padding(
//     //     padding: EdgeInsets.only(bottom: 5.h),
//     //     child: Image.asset(
//     //       "assets/creche_profile/checkIn.png",
//     //       scale: 2,
//     //       color: widget.index == 1 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//     //     ),
//     //   ),
//     //   label: Global.returnTrLable(locationControlls, CustomText.checkIN, lng!),
//     // ));
//     bottomItem.add(BottomNavigationBarItem(
//       icon: Padding(
//         padding: EdgeInsets.only(bottom: 5.h),
//         child: Image.asset(
//           "assets/creche_profile/profileAdd.png",
//           scale: widget.index == 1 ? 1.5 : 2,
//           color: widget.index == 1 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//         ),
//       ),
//       label: Global.returnTrLable(
//           locationControlls, CustomText.enrolled_children, lng!),
//     ));
//     bottomItem.add(BottomNavigationBarItem(
//       icon: Padding(
//         padding: EdgeInsets.only(bottom: 5.h),
//         child: Image.asset(
//           "assets/creche_profile/attendance.png",
//           scale: widget.index == 2 ? 1.5 : 2.7,
//           color: widget.index == 2 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//         ),
//       ),
//       label:
//           Global.returnTrLable(locationControlls, CustomText.Attendance, lng!),
//     ));
//     bottomItem.add(BottomNavigationBarItem(
//       icon: Padding(
//         padding: EdgeInsets.only(bottom: 5.h),
//         child: Image.asset(
//           "assets/creche_profile/checkIn.png",
//           scale: widget.index == 3 ? 1.5 : 2.7,
//           color: widget.index == 3 ? Color(0xff5979AA) : Color(0xffAAAAAA),
//         ),
//       ),
//       label: Global.returnTrLable(locationControlls, CustomText.Stock, lng!),
//     ));
//     return bottomItem;
//   }
//
//   Future<void> onclick(int i) async {
//     if (i == 0) {
//       setState(() {});
//       // Navigator.of(context).push(MaterialPageRoute(
//       //     builder: (BuildContext context) => CresheTabScreen(name:widget.nameId)));
//     } else if (i == 1) {
//       setState(() {});
//       // Navigator.of(context).push(MaterialPageRoute(
//       //     builder: (BuildContext context) => EnrolledChildrenListingTab()));
//     } else if (i == 2) {
//     } else if (i == 3) {
//       Navigator.of(context).push(
//           MaterialPageRoute(builder: (BuildContext context) => CheckIns()));
//     } else if (i == 4) {
//     } else if (i == 5) {}
//   }
// }
