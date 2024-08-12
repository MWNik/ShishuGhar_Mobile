// import 'dart:convert';
//
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shishughar/custom_widget/custom_text.dart';
// import 'package:shishughar/database/helper/form_logic_helper.dart';
// import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
// import 'package:shishughar/screens/dashboardscreen.dart';
// import 'package:shishughar/screens/shishu_ghar_screen.dart';
// import 'package:shishughar/screens/synchronization_screen.dart';
// import 'package:shishughar/screens/tabed_screens/child_follow_up/followUp_child_listing_screen.dart';
// import 'package:shishughar/screens/tabed_screens/child_reffrel/child_referal_listing_screen.dart';
// import 'package:shishughar/style/styles.dart';
//
// import '../api/attendance_meta_api.dart';
// import '../api/cashBook_api.dart';
// import '../api/child_Grievances_meta_api.dart';
// import '../api/child_event_meta_api.dart';
// import '../api/child_exit_meta_api.dart';
// import '../api/child_followup_meta_api.dart';
// import '../api/child_growth_meta_api.dart';
// import '../api/child_health_meta_api.dart';
// import '../api/child_hh_meta_api.dart';
// import '../api/child_immunization_meta_api.dart';
// import '../api/child_referral_meta_api.dart';
// import '../api/creche_Monitering_checkList_alm_api.dart';
// import '../api/creche_committie_meta_api.dart';
// import '../api/creche_monetering_checkList_cbm_api.dart';
// import '../api/creche_monitoring_api.dart';
// import '../api/form_logic_api.dart';
// import '../api/house_hold_fields_api.dart';
// import '../api/modified_date_api.dart';
// import '../database/database_helper.dart';
// import '../database/helper/anthromentory/child_growth_meta_fields_helper.dart';
// import '../database/helper/anthromentory/child_growth_response_helper.dart';
// import '../database/helper/cashbook/cashbook_excepnces_meta_fileds_helper.dart';
// import '../database/helper/cashbook/cashbook_response_expences_helper.dart';
// import '../database/helper/check_in_helper.dart';
// import '../database/helper/child_attendence/child_attendance_field_helper.dart';
// import '../database/helper/child_attendence/child_attendance_helper_responce.dart';
// import '../database/helper/child_event/child_event_meta_fields_helper.dart';
// import '../database/helper/child_event/child_event_response_helper.dart';
// import '../database/helper/child_exit/child_exit_meta_fields_helper.dart';
// import '../database/helper/child_exit/child_exit_response_Helper.dart';
// import '../database/helper/child_gravience/child_grievances_field_helper.dart';
// import '../database/helper/child_gravience/child_grievances_response_helper.dart';
// import '../database/helper/child_health/child_health_meta_fields_helper.dart';
// import '../database/helper/child_health/child_health_response_helper.dart';
// import '../database/helper/child_immunization/child_immunization_meta_fileds_helper.dart';
// import '../database/helper/child_immunization/child_immunization_response_helper.dart';
// import '../database/helper/child_reffrel/child_refferal_fields_helper.dart';
// import '../database/helper/child_reffrel/child_refferal_response_helper.dart';
// import '../database/helper/cmc_alm/creche_monitering_checkList_ALM_fields_helper.dart';
// import '../database/helper/cmc_alm/creche_monitering_checkList_ALM_response_helper.dart';
// import '../database/helper/cmc_cbm/creche_monitering_checklist_CBM_fields_helper.dart';
// import '../database/helper/cmc_cbm/creche_monitering_checklist_CBM_response_helper.dart';
// import '../database/helper/creche_comite_meeting/creche_committe_fields_meta_helper.dart';
// import '../database/helper/creche_comite_meeting/creche_committie_response_helper.dart';
// import '../database/helper/creche_data_helper.dart';
// import '../database/helper/creche_helper/creche_data_helper.dart';
// import '../database/helper/creche_monitoring/creche_monitoring_helper.dart';
// import '../database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
// import '../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
// import '../database/helper/enrolled_children/enrolled_children_field_helper.dart';
// import '../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
// import '../database/helper/follow_up/child_followUp_fields_helper.dart';
// import '../database/helper/follow_up/child_followUp_response_helper.dart';
// import '../database/helper/house_field_item_helper.dart';
// import '../database/helper/modifieddatahelper.dart';
// import '../database/helper/translation_language_helper.dart';
// import '../model/apimodel/cashbook_fields_meta_model.dart';
// import '../model/apimodel/child_Immunization_meta_fields_model.dart';
// import '../model/apimodel/child_attendance_field_model.dart';
// import '../model/apimodel/child_event_meta_fields_model.dart';
// import '../model/apimodel/child_exit_meta_fields_model.dart';
// import '../model/apimodel/child_followUp_meta_fields_model.dart';
// import '../model/apimodel/child_grievances_fields_model.dart';
// import '../model/apimodel/child_growth_meta_model.dart';
// import '../model/apimodel/child_referral_fields_model.dart';
// import '../model/apimodel/cmc_cbm_meta_fields _model.dart';
// import '../model/apimodel/creche_committe_meta_fields_model.dart';
// import '../model/apimodel/creche_data_model.dart';
// import '../model/apimodel/creche_monitering_checklist_ALM_fields_model.dart';
// import '../model/apimodel/creche_monitoring_meta_model.dart';
// import '../model/apimodel/enrolled_children_field_model.dart';
// import '../model/apimodel/house_hold_field_model_api.dart';
// import '../model/apimodel/modifiedDate_apiModel.dart';
// import '../model/apimodel/translation_language_api_model.dart';
// import '../model/apimodel/child_health_meta_data_Api_Model.dart';
// import '../utils/globle_method.dart';
// import '../utils/validate.dart';
// import 'VerificationForPending.dart';
// import 'change_password_screen.dart';
// import 'linelistedhouseholld.dart';
// import 'login_screen.dart';
//
//
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//
//   List<String> text = [];
//   List<String> image = [];
//
//   String? village;
//   String? Creche;
//   bool isConnected = false;
//   var village_txt = "";
//   String? role;
//   String? lng;
//   var change_language_text = "";
//   int syncCount = 0;
//   int countVerifyForPending = 0;
//   String selectedLanguage = 'en';
//   String username = '';
//   String fullName = '';
//   List<Translation> locationControlls = [];
//   String appVersionName = '';
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => LoginScreen()),
//         // );
//         setState(() {});
//         return true;
//       },
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           backgroundColor: Color(0xff5979AA),
//           leading: InkWell(
//             onTap: () {
//               _scaffoldKey.currentState?.openDrawer();
//             },
//             child: Padding(
//               padding: EdgeInsets.only(left: 15.w),
//               child: Image.asset(
//                 "assets/menu_icon.png",
//                 color: Colors.white,
//                 scale: 3,
//               ),
//             ),
//           ),
//           centerTitle: true,
//           title: Text(
//             CustomText.ShishuGhar,
//             style: Styles.white145,
//           ),
//           actions: [
//
//             isConnected ? Image.asset("assets/online.png", scale: 2,)
//                 : Image.asset("assets/offline.png", scale: 2),
//
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext context) =>
//                         SynchronizationScreen()));
//               },
//               child: Stack(
//                 children: [
//                   SizedBox(
//                     height: 40,
//                     width: 40,
//                     child: Image.asset(
//                       "assets/reset.png",
//                       scale: 3,
//                     ),
//                   ),
//                   syncCount>0?Positioned(
//                     top: 0,
//                     bottom: 24,
//                     left: 20,
//                     right: 0,
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xffF26BA3),
//                       ),
//                       padding: EdgeInsets.all(4),
//                       child: Text(
//                         syncCount>9?'9+':"$syncCount",
//                         style: Styles.white74P,
//                       ),
//                     ),
//                   ):SizedBox(),
//                 ],
//               ),
//             ),
//
//             Visibility(
//               child: Stack(
//                 children: [
//                   SizedBox(
//                     height: 40,
//                     width: 40,
//                     child: Image.asset(
//                       "assets/notification.png",
//                       scale: 3,
//                     ),
//                   ),
//                   Positioned(
//                     top: 0,
//                     bottom: 24,
//                     left: 20,
//                     right: 0,
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xffF26BA3),
//                       ),
//                       padding: EdgeInsets.all(4),
//                       child: Text(
//                         '1',
//                         style: Styles.white74P,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//
//             SizedBox(
//               width: 10.w,
//             ),
//           ],
//         ),
//         drawer: Drawer(
//             backgroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(50),
//                 bottomRight: Radius.circular(50),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                     padding: EdgeInsets.only(
//                       left: 20,
//                       right: 20,
//                       top: 40,
//                     ),
//                     height: 150,
//                     decoration: BoxDecoration(
//                       color: Color(0xffF2F7FF),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         InkWell(
//                             onTap: () async {
//                               _scaffoldKey.currentState?.closeDrawer();
//                             },
//                             child: Image.asset(
//                               'assets/cross.png',
//                               color: Colors.grey,
//                               scale: 4,
//                             )),
//                         // child: Image.memory(bytes:Validate().imageBase64Toimage())),
//                         Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Visibility(
//                                 visible: false,
//                                 child: Container(
//                                     height: 46.h,
//                                     width: 46.w,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(
//                                         color: Colors.white,
//                                         width: 2,
//                                       ),
//                                     ),
//                                     child: Image.asset(
//                                       'assets/childrenenrolled.png',
//                                     )),
//                               ),
//                               SizedBox(width: 10),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text("$fullName", style: Styles.black126P),
//                                   Text("$username", style: Styles.black126P),
//                                   Text("$role", style: Styles.Grey104),
//                                 ],
//                               )
//                             ]),
//                       ],
//                     )),
//                 Expanded(
//                   child: ListView(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       children: [
//                         Visibility(
//                           visible: false,
//                           child: ListTile(
//                             leading: const Icon(Icons.person),
//                             title: Container(
//                               padding: EdgeInsets.all(8.0),
//                               decoration:
//                               BoxDecoration(color: Color(0xffF1F1F1)),
//                               child: Text(
//                                 CustomText.MyProfile,
//                                 style: Styles.black125,
//                               ),
//                             ),
//                             onTap: () {},
//                           ),
//                         ),
//                         Visibility(
//                           visible: false,
//                           child: Divider(
//                             color: Color(0xffEEEEEE),
//                             indent: 15,
//                             endIndent: 15,
//                           ),
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.language),
//                           title: Text(
//                             lng != null ? Global.returnTrLable(
//                                 locationControlls,
//                                 CustomText.change_language_text, lng!) : '',
//                             style: Styles.black125,
//                           ),
//                           onTap: () {
//                             _scaffoldKey.currentState?.closeDrawer();
//                             _showLanguageDialog(context);
//                           },
//                         ),
//                         Visibility(
//                           visible: true,
//                           child: Divider(
//                             color: Color(0xffEEEEEE),
//                             indent: 15,
//                             endIndent: 15,
//                           ),
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.lock),
//                           title: Text(
//                             lng != null ? Global.returnTrLable(
//                                 locationControlls, CustomText.ChangePassword,
//                                 lng!) : '',
//                             style: Styles.black125,
//                           ),
//                           onTap: () {
//                             _scaffoldKey.currentState?.closeDrawer();
//
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ChangePasswordScreen()),
//                             );
//                           },
//                         ),
//                         Visibility(
//                           visible: true,
//                           child: Divider(
//                             color: Color(0xffEEEEEE),
//                             indent: 15,
//                             endIndent: 15,
//                           ),
//                         ),
//                         ListTile(
//                           leading: Image.asset(
//                             "assets/logout.png",
//                             scale: 3,
//                           ),
//                           title: Text(
//                             lng != null
//                                 ? Global.returnTrLable(
//                                 locationControlls, CustomText.Logout, lng!)
//                                 : '',
//                             style: Styles.red125,
//                           ),
//                           onTap: () async {
//                             _scaffoldKey.currentState?.closeDrawer();
//                             if (syncCount > 0) {
//                                   Validate().singleButtonPopup(Global.returnTrLable(
//                                       locationControlls, CustomText.logoutPendingDataMsg, lng!), Global.returnTrLable(
//                                       locationControlls, CustomText.ok, lng!), false, context);
//                             } else {
//                               SharedPreferences prefs =
//                               await SharedPreferences.getInstance();
//
//                               // await prefs.remove(Validate.Password);
//                               // await prefs.getString(Validate.Password);
//                               showLoaderDialog(context);
//                               await prefs.clear();
//                               await DatabaseHelper().deleteAllRecords();
//                               Navigator.pop(context);
//
//                               _scaffoldKey.currentState?.closeDrawer();
//                               Navigator.pushAndRemoveUntil(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (
//                                           context) => const LoginScreen()),
//                                       (Route<dynamic> route) => false);
//                             };
//                           }
//                         ),
//                         Divider(
//                           color: Color(0xffEEEEEE),
//                           indent: 15,
//                           endIndent: 15,
//                         ),
//                       ]),
//                 ),
//                 Center(
//                   child: RichText(
//                     text: TextSpan(
//                       text: CustomText.Version,
//                       style: Styles.black124,
//                       children: <TextSpan>[
//                         TextSpan(
//                             text: "$appVersionName", style: Styles.black126P),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 )
//               ],
//             )),
//         body: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: 20.w,
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 10.h,
//               ),
//               // Container(
//               //   decoration: BoxDecoration(
//               //       color: Color(0xff62ADA8),
//               //       borderRadius: BorderRadius.circular(5.r)),
//               //   child: (role == 'Creche Supervisor')
//               //       ? Padding(
//               //           padding: EdgeInsets.symmetric(
//               //               vertical: 10.h, horizontal: 10),
//               //           child:Row(
//               //             children: [
//               //
//               //               Column(
//               //                 crossAxisAlignment: CrossAxisAlignment.start,
//               //                 children: [
//               //                   Creche != null
//               //                       ? RichText(
//               //                       overflow: TextOverflow.ellipsis,
//               //                       text: TextSpan(
//               //                           text: Global.returnTrLable(
//               //                               locationControlls,
//               //                               CustomText.Creches,
//               //                               lng!),
//               //                           style: Styles.white104P,
//               //                           children: [
//               //                             TextSpan(
//               //                                 text: ' : $Creche',
//               //                                 style: Styles.white125),
//               //                           ]))
//               //                       : SizedBox(),
//               //                   RichText(
//               //                       overflow: TextOverflow.ellipsis,
//               //                       text: TextSpan(
//               //                           text: Global.returnTrLable(
//               //                               locationControlls,
//               //                               CustomText.Village,
//               //                               lng!),
//               //                           style: Styles.white104P,
//               //                           children: [
//               //                             TextSpan(
//               //                                 text: ' : $village',
//               //                                 style: Styles.white125),
//               //                           ])),
//               //
//               //                 ],
//               //               ),
//               //               // SizedBox(width: 10.w),
//               //               Spacer(),
//               //               isConnected
//               //                   ? Image.asset(
//               //                 "assets/online.png",
//               //                 scale: 2,
//               //               )
//               //                   : Image.asset("assets/offline.png", scale: 2),
//               //             ],
//               //           ),
//               //         )
//               //       : SizedBox(),
//               // ),
//               // SizedBox(
//               //   height: 10.h,
//               // ),
//               ListView.builder(
//                   itemCount: 0,
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Padding(
//                       padding: EdgeInsets.symmetric(vertical: 3.h),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: Color(0xff62ADA8),
//                             borderRadius: BorderRadius.circular(5.r)),
//                         height: 64.h,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 10.w, vertical: 3.h),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               index == 0
//                                   ? Image.asset(
//                                 "assets/watch.png",
//                                 height: 55.h,
//                                 width: 55.w,
//                               )
//                                   : Image.asset(
//                                 "assets/Thumbs.png",
//                                 height: 55.h,
//                                 width: 55.w,
//                               ),
//                               SizedBox(
//                                 width: 10.w,
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       index == 0
//                                           ? CustomText.Activities
//                                           : CustomText.FollowUps,
//                                       style: Styles.white126P,
//                                     ),
//
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//               SizedBox(
//                 height: 5.h,
//               ),
//               Expanded(
//                 child: GridView.builder(
//                   scrollDirection: Axis.vertical,
//                   shrinkWrap: true,
//                   itemCount: text.length,
//                   physics: BouncingScrollPhysics(),
//                   itemBuilder: (ctx, i) {
//                     return InkWell(
//                       onTap: () async {
//                         onclick(i, image[i]);
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(0xff5A5A5A).withOpacity(
//                                     0.1), // Shadow color with opacity
//                                 offset: Offset(0,
//                                     1), // Horizontal and vertical offset
//                                 blurRadius: 5, // Blur radius
//                                 spreadRadius: 0, // Spread radius
//                               ),
//                             ],
//                             color: Color(0xffF2F7FF),
//                             borderRadius: BorderRadius.circular(5.r),
//                             border: Border.all(
//                               color: Color(0xffE7F0FF),
//                             )),
//                         height: 168.h,
//                         width: 146.w,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment
//                                     .center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Visibility(
//                                     visible: true,
//                                     child: Stack(
//                                       children: [
//                                         SizedBox(
//                                           height: 40,
//                                           width: 40,
//                                           child: Image.asset(
//                                             image[i],
//                                             filterQuality: FilterQuality
//                                                 .high,
//                                             scale: image[i] ==
//                                                 'assets/verifydata.png'
//                                                 ? 2.7
//                                                 : 3.8,
//                                             color: Color(0xff5979AA),
//                                           ),
//                                         ),
//                                         if(image[i] == 'assets/verifydata.png')
//                                           if (countVerifyForPending > 0)
//                                             Positioned(
//                                               top: 0,
//                                               bottom: 24,
//                                               left: 14,
//                                               right: 0,
//                                               child: Container(
//                                                 alignment: Alignment.center,
//                                                 height: 70,
//                                                 width: 70,
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: Color(0xffF26BA3),
//                                                 ),
//                                                 padding: EdgeInsets.all(4),
//                                                 child: Text(
//                                                   "$countVerifyForPending",
//                                                   style: Styles.white74P,
//                                                 ),
//                                               ),
//                                             ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 15.h,
//                                   ),
//                                   Padding(
//                                     padding:
//                                     EdgeInsets.symmetric(horizontal: 7),
//                                     child: Text(
//                                       Global.returnTrLable(
//                                           locationControlls, text[i], lng!),
//                                       style: Styles.listlablefont,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 8,
//                       mainAxisSpacing: 8,
//                       mainAxisExtent: 90.h),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   showLoaderDialog(BuildContext context) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircularProgressIndicator(),
//                 SizedBox(height: 10.h),
//                 Text(Global.returnTrLable(
//                     locationControlls, CustomText.pleaseWait, lng!)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   callFieldData() async {
//     var network = await Validate().checkNetworkConnection();
//
//     if (network) {
//       showLoaderDialog(context);
//       var userName = await Validate().readString(Validate.userName);
//       var password = await Validate().readString(Validate.Password);
//       var token = await Validate().readString(Validate.appToken);
//       var response = await HouseHoldFieldsApiService()
//           .houseHoldFieldsData(userName!, password!, token!);
//       if (response.statusCode == 200) {
//         HouseHoldFieldModel houseHoldFieldModel =
//         HouseHoldFieldModel.fromJson(jsonDecode(response.body));
//         await callInsertHouseHoldFields(houseHoldFieldModel);
//
//         Validate().saveString(Validate.householdForm,
//             houseHoldFieldModel.tabHousehold_Form!.modified!);
//         Validate().saveString(Validate.householdChildForm,
//             houseHoldFieldModel.tabHousehold_Child_Form!.modified!);
//
//         await callApiLogicData(userName, password, token);
//       } else if (response.statusCode == 401) {
//         Navigator.pop(context);
//         Validate().singleButtonPopup(Global.returnTrLable(locationControlls,
//             CustomText.token_expired, lng!),
//             Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//             context);
//       } else {
//         Navigator.pop(context);
//         Validate().singleButtonPopup(
//             Global.errorBodyToString(response.body, 'message'),
//             Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//             context);
//       }
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(locationControlls,
//               CustomText.nointernetconnectionavailable, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callCreshDataApi(String userName, String password,
//       String token) async {
//     var cresheData = await HouseHoldFieldsApiService()
//         .syncCrecheData(userName, password, token);
//     if (cresheData.statusCode == 200) {
//       CrecheFieldModel houseHoldFieldModel =
//       CrecheFieldModel.fromJson(jsonDecode(cresheData.body));
//       Validate().saveString(Validate.creChemodifiedDate,
//           houseHoldFieldModel.tabCreche!.modified!);
//       await callInsertCrecheFields(houseHoldFieldModel);
//       await callAttendanceData(userName, password, token);
//       // Navigator.pop(context);
//     } else if (cresheData.statusCode == 401) {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(Global.returnTrLable(locationControlls,
//           CustomText.token_expired, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(cresheData.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//     }
//   }
//
//   Future<void> callEnrooledChildrenDataApi(String userName, String password,
//       String token) async {
//     var child_data = await ChildEnrolledDataMetaApi()
//         .callChildHHMeta(userName, password, token);
//
//     if (child_data.statusCode == 200) {
//       EnrolledChildrenFieldModel childMetaModel =
//       EnrolledChildrenFieldModel.fromJson(jsonDecode(child_data.body));
//       Validate().saveString(Validate.childProfilemodifiedDate,
//           childMetaModel.tabChild_HH_Meta_Form!.modified!);
//       await callInsertEnrolledChildrendHHFields(childMetaModel);
//       await callCreshDataApi(userName, password, token);
//     } else if (child_data.statusCode == 401) {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(Global.returnTrLable(locationControlls,
//           CustomText.token_expired, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(child_data.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//     }
//   }
//
//   Future<void> callApiLogicData(String userName, String password,
//       String token) async {
//     var logisResponce =
//     await FormLogicApiService().fetchLogicData(userName, password, token);
//
//     if (logisResponce.statusCode == 200) {
//       Map<String, dynamic> responseData = json.decode(logisResponce.body);
//       await initFormLogic(FormLogicApiModel.fromJson(responseData));
//       await callEnrooledChildrenDataApi(userName, password, token);
//     } else if (logisResponce.statusCode == 401) {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(Global.returnTrLable(locationControlls,
//           CustomText.token_expired, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(logisResponce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//     }
//   }
//
//   Future<void> initFormLogic(FormLogicApiModel? formLogicApiModel) async {
//     if (formLogicApiModel != null) {
//       List<TabFormsLogic>? formLogicList = formLogicApiModel.tabFormsLogic;
//       if (formLogicList != null) {
//         print("Insert formlogic data into the database");
//         await FormLogicDataHelper().insertFormLogic(formLogicList);
//       } else {
//         print("Not Insert formlogic data into the database");
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // callFieldData();
//     callInitBlock();
//   }
//
//   Future<void> callInsertHouseHoldFields(HouseHoldFieldModel items) async {
//     await DatabaseHelper.database!.delete('tabhouseholdfield');
//     if (items.tabHousehold_Form != null) {
//       print("dataCount ${items.tabHousehold_Form!.fields!.length}");
//       await HouseHoldFieldHelper()
//           .insertHouseHoldField(items.tabHousehold_Form!.fields!);
//     }
//     if (items.tabHousehold_Child_Form != null) {
//       print("dataCount Child ${items.tabHousehold_Child_Form!.fields!.length}");
//       await HouseHoldFieldHelper()
//           .insertHouseHoldField(items.tabHousehold_Child_Form!.fields!);
//     }
//   }
//
//   Future<void> callInsertCrecheFields(CrecheFieldModel items) async {
//     await DatabaseHelper.database!.delete('tabCrechefield');
//     if (items.tabCreche != null) {
//       print("dataCount ${items.tabCreche!.fields!.length}");
//       await CrecheFieldHelper().insertCrecheField(items.tabCreche!.fields!);
//     }
//     if (items.tabCreche_caregiver != null) {
//       print("dataCount Creche ${items.tabCreche_caregiver!.fields!.length}");
//       await CrecheFieldHelper()
//           .insertCrecheField(items.tabCreche_caregiver!.fields!);
//     }
//   }
//
//   callInitBlock() async {
//     var householdForm = await Validate().readString(Validate.householdForm);
//     village = await Validate().readString(Validate.village);
//     Creche = await Validate().readString(Validate.CrecheSName);
//     selectedLanguage = (await Validate().readString(Validate.sLanguage))!;
//     username = (await Validate().readString(Validate.userName))!;
//     fullName = (await Validate().readString(Validate.fullName))!;
//     await _getAppVersionName();
//     await locationData();
//     await pendingDataForVerify();
//     await checkConnectivity();
//     if (householdForm != null) {
//       await callModifiedFieldData();
//     } else {
//       await callFieldData();
//     }
//     setState(() {});
//   }
//
//   callModifiedFieldData() async {
//     ModifiedDateApiService modifiedDateApiService = ModifiedDateApiService();
//
//     var responce = await modifiedDateApiService.getModifiedData();
//     if (responce.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(responce.body);
//       var modifiedApiModel = ModifiedApiModel.fromJson(responseData);
//       if (responseData.isNotEmpty) {
//         List<DocType>? docTypeList = modifiedApiModel.docType;
//         ModifiedDataHelper modifiedDataHelper = ModifiedDataHelper();
//         if (docTypeList != null) {
//           // print("Insert  Modified data into the database");
//           await modifiedDataHelper.insertModifiedData(docTypeList);
//           for (int i = 0; i < modifiedApiModel.docType!.length; i++) {
//             var element = modifiedApiModel.docType![i];
//             if (element.name.toString() == 'Household Form') {
//               var date2 = element.modified.toString();
//               var date1 = await Validate().readString(Validate.householdForm);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Household Child Form') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.householdChildForm);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Child Profile') {
//               var date2 = element.modified.toString();
//               var date1 = await Validate()
//                   .readString(Validate.childProfilemodifiedDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Creche') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.creChemodifiedDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Creche Monitoring Checklist') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.crecheMonitoringMeta);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Child Growth Monitoring') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.ChildAntroUpdateDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Creche Monitoring Checklist ALM') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.cmcALMMetaUpdatedate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Child Attendance') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.ChildAttendeceUpdateDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Child Immunization') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.ChildImmunizationUpdateDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Child Exit') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.childExitUpdatedDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Child Health') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.ChildHealthUpdateDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Child Event') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.childEventUpdateDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Child Follow up') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.childFollowUpUpdatedDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Creche Monitoring Checklist CBM') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.cmcCBMMetaUpdatedate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Child Referral') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.childReferralUpdatedDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//             else if (element.name.toString() == 'Grievance') {
//               var date2 = element.modified.toString();
//               var date1 =
//               await Validate().readString(Validate.childGravienceUpdatedDate);
//               // print(' share prf hh modified date: $date1');
//               // compareDates(date1!, date2);
//               if (compareDates(date1!, date2)) {
//                 callFieldData();
//                 print("Not Insert translation data into the database");
//                 break;
//               }
//             }
//           }
//         } else {
//           print("Not Insert translation data into the database");
//         }
//       }
//     }
//     else if (responce.statusCode == 401) {
//       // Navigator.pop(context);
//       // Validate().singleButtonPopup(Global.returnTrLable(locationControlls,
//       //     CustomText.token_expired, lng!),
//       //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//       //     context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:
//         Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       // Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//     }
//   }
//
//   bool compareDates(String dateString1, String dateString2) {
//     DateTime date1 = DateTime.parse(dateString1);
//     DateTime date2 = DateTime.parse(dateString2);
//
//     if (date1.isBefore(date2)) {
//       return true;
//       // print('$dateString1 is earlier than $dateString2');
//     } else if (date1.isAfter(date2)) {
//       // print('$dateString1 is later than $dateString2');
//     } else {
//       // print('$dateString1 is equal to $dateString2');
//     }
//     return false;
//   }
//
//   Future<void> checkConnectivity() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     setState(() {
//       isConnected = connectivityResult == ConnectivityResult.mobile ||
//           connectivityResult == ConnectivityResult.wifi;
//     });
//     // Add a listener to listen for changes in connectivity
//     Connectivity().onConnectivityChanged.listen((result) {
//       setState(() {
//         isConnected = result == ConnectivityResult.mobile ||
//             result == ConnectivityResult.wifi;
//       });
//     });
//   }
//
//   Future<void> locationData() async {
//     lng = await Validate().readString(Validate.sLanguage);
//     role = await Validate().readString(Validate.role);
//
//
//     if (role == 'Cluster Coordinator') {
//       image = [
//         'assets/household.png',
//         'assets/shishughar.png',
//         'assets/verifydata.png',
//         'assets/note.png',
//         'assets/cashbook.png',
//         'assets/flagged.png',
//         'assets/ic_sync_n.png',
//       ];
//       text = [
//         CustomText.HHListing,
//         CustomText.ShishuGharDetails,
//         CustomText.Pendingforverify,
//         CustomText.VisitNote,
//         CustomText.Cashbook,
//         CustomText.FlaggedChilderen,
//         CustomText.sync,
//       ];
//     } else {
//       image = [
//         'assets/household.png',
//         'assets/shishughar.png',
//         'assets/note.png',
//         'assets/cashbook.png',
//         'assets/flagged.png',
//         'assets/childdetailissue.png',
//         'assets/ic_sync_n.png',
//       ];
//       text = [
//         CustomText.HHListing,
//         CustomText.ShishuGharDetails,
//         CustomText.VisitNote,
//         CustomText.Cashbook,
//         CustomText.FlaggedChilderen,
//         CustomText.ChildReffrel,
//         CustomText.sync,
//       ];
//     }
//
//     List<String> valueNames = [
//       CustomText.change_language_text,
//       CustomText.HHListing,
//       CustomText.Enrolledchildren,
//       CustomText.VerifyData,
//       CustomText.VisitNote,
//       CustomText.GrowthMonitoring,
//       CustomText.Attendance,
//       CustomText.CrecheCommittee,
//       CustomText.GrievanceIssuTracking,
//       CustomText.Rollout,
//       CustomText.TrainingMeeting,
//       CustomText.ChilderenExistingshishuGhar,
//       CustomText.FlaggedChilderen,
//       CustomText.ShishuGharDetails,
//       CustomText.RequisitionReceipts,
//       CustomText.Cashbook,
//       CustomText.sync,
//       CustomText.Pendingforverify,
//       CustomText.ChilderenExistingshishuGhar,
//       CustomText.Village,
//       CustomText.Yes,
//       CustomText.No,
//       CustomText.logoutMsg,
//       CustomText.nointernetconnectionavailable,
//       CustomText.ok,
//       CustomText.pleaseWait,
//       CustomText.data_downloaded_successfully,
//       CustomText.token_expired,
//       CustomText.pleaseselectcrechefirst,
//       CustomText.CrecheProfileView,
//       CustomText.Creches,
//       CustomText.Logout,
//       CustomText.ChangePassword
//     ];
//     await TranslationDataHelper()
//         .callTranslateString(valueNames)
//         .then((value) => locationControlls = value);
//
//     setState(() {});
//   }
//
//   void _showLanguageDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(Global.returnTrLable(
//               locationControlls, CustomText.change_language_text, lng!),
//             style: Styles.black128,),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               DropdownButton<String>(
//                 value: selectedLanguage,
//                 items: [
//                   DropdownMenuItem<String>(
//                     value: 'en',
//                     child: Text('English'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'hi',
//                     child: Text(CustomText.Hindi),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'od',
//                     child: Text(CustomText.Odiya),
//                   ),
//                 ],
//                 onChanged: (String? value) {
//                   if (value != null) {
//                     setState(() {
//                       selectedLanguage = value;
//                     });
//                     Validate().saveString(Validate.sLanguage, selectedLanguage);
//                     Navigator.of(context).pop();
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               DashboardScreen(
//                                 index: 0,
//                               )),
//                     );
//                   }
//                 },
//                 isExpanded: true,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> pendingDataForVerify() async {
//     var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItemsMap();
//     if (role == 'Creche Supervisor') {
//       hhItems = hhItems
//           .where((element) =>
//       Global.getItemValues(element.responces!,
//           'verification_status') ==
//           '2' && element.is_edited==1 )
//           .toList();
//
//       var chilProfiles =
//       await EnrolledChilrenResponceHelper().callChildrenForUpload();
//       var crecheProfile = await CrecheDataHelper().callCrecheForUpload();
//       var chilAttendence =
//       await ChildAttendanceResponceHelper().callChildAttendencesAllForUpoad();
//       var crecheCheckIn = await CheckInHelper().callCrecheCheckInResponses();
//       var anthropomentry = await ChildGrowthResponseHelper().callChildGrowthResponsesForUpload();
//       var childeventResponses = await ChildEventTabResponceHelper().getEditedChildEventsForUpload();
//       var childHeathData = await ChildHealthTabResponceHelper().getChildHealthForUpload();
//       var childImmunizationDAta = await ChildImmunizationResponseHelper().getChildImmunizationForUpload();
//       var childexitdata =
//       await ChildExitResponceHelper().getEditedChildExitForUpload();
//       var grievanceData = await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
//       var creCheMonitoring = await CrecheMonitorResponseHelper().getCrecheResponseForUpload();
//       var referralData =
//       await ChildReferralTabResponseHelper().getChildReferralForUpload();
//       var followUpData =
//       await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
//       var ccmData =
//       await CrecheCommittieResponnseHelper().getCrecheCommittieForUpload();
//       var cmcCBMData =
//       await CmcCBMTabResponseHelper().getCBMForUpload();
//       var cmcAlmData =
//       await CmcALMTabResponseHelper().getAlmForUpload();
//       var cashBookData = await CashBookResponseHelper()
//           .getEditedCashBookForUpload();
//
//       syncCount= anthropomentry.length +hhItems.length +chilProfiles.length +
//           crecheProfile.length + chilAttendence .length + crecheCheckIn .length
//           + childeventResponses .length+ childHeathData .length+
//           childImmunizationDAta .length+childexitdata.length
//           +grievanceData.length+creCheMonitoring.length+
//           referralData.length+followUpData.length+cmcCBMData.length
//           +ccmData.length+cmcAlmData.length+cashBookData.length ;
//
//     }else {
//       hhItems = hhItems
//           .where((element) =>
//       (Global.getItemValues(element.responces!,
//           'verification_status') ==
//           '4' || Global.getItemValues(element.responces!,
//           'verification_status') ==
//           '5') && element.is_edited==1 )
//           .toList();
//
//       syncCount = hhItems.length;
//
//       var pendingItems=await HouseHoldTabResponceHelper().getHouseHoldUploadeItems();
//       pendingItems = pendingItems
//           .where((element) =>
//       (Global.getItemValues(element.responces!,
//           'verification_status') ==
//           '3'))
//           .toList();
//       countVerifyForPending=pendingItems.length;
//     }
//
//
//   }
//
//
//   String getItemValues(String response, String key) {
//     String returnValue = "";
//     Map<String, dynamic> itemresponse = jsonDecode(response);
//     var value = itemresponse[key];
//     if (value != null) {
//       returnValue = value.toString();
//     }
//     return returnValue;
//   }
//
//   Future<void> callInsertEnrolledChildrendHHFields(
//       EnrolledChildrenFieldModel items) async {
//     await DatabaseHelper.database!.delete('tabchildprofilefield');
//     if (items.tabChild_HH_Meta_Form != null) {
//       print("dataCount ChildHH${items.tabChild_HH_Meta_Form!.fields!.length}");
//       await EnrolledChildrenFieldHelper()
//           .insertsChildrenEnrolledField(items.tabChild_HH_Meta_Form!.fields!);
//     }
//     if (items.tabEntitlement_child_table != null) {
//       print("dataCount Child${items.tabEntitlement_child_table!.fields!.length}");
//       await EnrolledChildrenFieldHelper()
//           .insertsChildrenEnrolledField(items.tabEntitlement_child_table!.fields!);
//     }
//   }
//
//   Future<void> _getAppVersionName() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     setState(() {
//       appVersionName = packageInfo.version;
//     });
//   }
//
//
//   Future<void> onclick(int i, String imsgeItem) async {
//     if (i == 0) {
//       var refStatus=await Navigator.of(context).push(MaterialPageRoute(
//           builder: (BuildContext context) => LineholdlistedScreen()));
//       if (refStatus == 'itemRefresh') {
//         await callInitBlock();
//       }
//     } else if (i == 1) {
//       var refStatus=await Navigator.of(context).push(MaterialPageRoute(
//           builder: (BuildContext context) => ShiShuGharScreen()));
//       if (refStatus == 'itemRefresh') {
//         await callInitBlock();
//       }
//     } else if (i == 2) {
//       if (role == 'Cluster Coordinator') {
//         var refStatus=await Navigator.of(context).push(MaterialPageRoute(
//             builder: (BuildContext context) => VerficationForPending()));
//         if (refStatus == 'itemRefresh') {
//           await callInitBlock();
//         }
//       }
//     } else if (i == 3) {
//
//     } else if (i == 4) {
//       if ((role == 'Creche Supervisor')) {
//         var refStatus=await Navigator.of(context).push(MaterialPageRoute(
//             builder: (BuildContext context) => FollowUpChildListingScreen()));
//         if (refStatus == 'itemRefresh') {
//           await callInitBlock();
//         }
//       }
//     } else if (i == 5) {
//       if (!(role == 'Cluster Coordinator')) {
//         var refStatus=await Navigator.of(context).push(MaterialPageRoute(
//             builder: (BuildContext context) => ChildReferralListingScreen()));
//         if (refStatus == 'itemRefresh') {
//           await callInitBlock();
//         }
//       }
//     } else if (i == 6) {
//       // if (role == 'Cluster Coordinator') {
//         var refStatus= await Navigator.of(context).push(MaterialPageRoute(
//             builder: (BuildContext context) => SynchronizationScreen()));
//         if (refStatus == 'itemRefresh') {
//           await callInitBlock();
//         // }
//       }
//     }
//   }
//
//
//   callAttendanceData(String userName, String password, String token) async {
//     var responce = await AttendanceMetaApi()
//         .callAttendanceData(userName, password, token);
//     if (responce.statusCode == 200) {
//       ChildAttendanceFieldModel attendanceData =
//       ChildAttendanceFieldModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertChildAttendance(attendanceData);
//       await callAnthropomertryData(userName, password, token);
//       Validate().saveString(Validate.ChildAttendeceUpdateDate,
//           attendanceData.tabChild_Attendance!.modified!);
//       // Navigator.pop(context);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       // Validate().singleButtonPopup(Global.returnTrLable(locationControlls,
//       //     CustomText.token_expired, lng!),
//       //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//       //     context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:
//         Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//     }
//   }
//
//
//   Future<void> callInsertChildAttendance(
//       ChildAttendanceFieldModel items) async {
//     await DatabaseHelper.database!.delete('tabChildAttendance');
//     if (items.tabChild_Attendance != null) {
//       await ChildAttendanceFieldHelper()
//           .insertChildAttendanceField(items.tabChild_Attendance!.fields!);
//     }
//     if (items.tabChild_Attendance_List != null) {
//       await ChildAttendanceFieldHelper()
//           .insertChildAttendanceField(items.tabChild_Attendance_List!.fields!);
//     }
//   }
//
//   callAnthropomertryData(String userName, String password, String token) async {
//     var responce = await ChildGrowthMetaApi()
//         .callChildGrowthMeta(userName, password, token);
//     if (responce.statusCode == 200) {
//       ChildGrowthMetaFieldsModel childGrowthMetaFields =
//       ChildGrowthMetaFieldsModel.fromJson(jsonDecode(responce.body));
//
//       Validate().saveString(Validate.ChildAntroUpdateDate,
//           childGrowthMetaFields.tabChild_Growth_Meta!.modified!);
//
//       await callInsertAnthropomertry(childGrowthMetaFields);
//
//       callChildEventData(userName, password, token);
//       // Navigator.pop(context);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       // Validate().singleButtonPopup(Global.returnTrLable(locationControlls,
//       //     CustomText.token_expired, lng!),
//       //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//       //     context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:
//         Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//     }
//   }
//
//   Future<void> callInsertAnthropomertry(
//       ChildGrowthMetaFieldsModel items) async {
//     await DatabaseHelper.database!.delete('tabChildGrowthMeta');
//     if (items.tabChild_Growth_Meta != null) {
//       await ChildGrowthMetaFieldsHelper()
//           .insertChildGrowthMeta(items.tabChild_Growth_Meta!.fields!);
//     }
//     if (items.tabAnthropromatic_Data != null) {
//       await ChildGrowthMetaFieldsHelper()
//           .insertChildGrowthMeta(items.tabAnthropromatic_Data!.fields!);
//     }
//   }
//
//   callChildEventData(String userName, String password, String token) async {
//     var responce =
//     await ChildEventMetaApi().callChildEventMeta(userName, password, token);
//     if (responce.statusCode == 200) {
//       ChildEventMetaFieldsModel childEventMetaFields =
//       ChildEventMetaFieldsModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertChildEvent(childEventMetaFields);
//
//       Validate().saveString(Validate.childEventUpdateDate,
//           childEventMetaFields.tabChild_Event_Meta!.modified!);
//       await callChildImmunizationData(userName, password, token);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       // Validate().singleButtonPopup(
//       //     Global.returnTrLable(
//       //         locationControlls, CustomText.token_expired, lng!),
//       //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//       //     false,
//       //     context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:
//         Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertChildEvent(ChildEventMetaFieldsModel items) async {
//     await DatabaseHelper.database!.delete('tab_child_event');
//     if (items.tabChild_Event_Meta != null) {
//       await ChildEventMetaFieldsHelper()
//           .insertChildEventMeta(items.tabChild_Event_Meta!.fields!);
//     }
//   }
//
//   callChildImmunizationData(
//       String userName, String password, String token) async {
//     var responce = await ChildImmunizationMetaApi()
//         .callChildImmunizationMeta(userName, password, token);
//     if (responce.statusCode == 200) {
//       ChildImmunizationMetaFieldsModel childImmunizationMetaFields =
//       ChildImmunizationMetaFieldsModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertChildImmunization(childImmunizationMetaFields);
//       Validate().saveString(Validate.ChildImmunizationUpdateDate,
//           childImmunizationMetaFields.tabChild_Immunization_Meta!.modified!);
//       await callChildHealthData(userName, password, token);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       // Validate().singleButtonPopup(
//       //     Global.returnTrLable(
//       //         locationControlls, CustomText.token_expired, lng!),
//       //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//       //     false,
//       //     context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:
//         Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertChildImmunization(
//       ChildImmunizationMetaFieldsModel items) async {
//     await DatabaseHelper.database!.delete('tab_child_immunization');
//     if (items.tabChild_Immunization_Meta != null) {
//       await ChildImmunizationMetaFieldsHelper().insertChildImmunizationMeta(
//           items.tabChild_Immunization_Meta!.fields!);
//     }
//     if (items.tabChild_Vaccine_Details != null) {
//       await ChildImmunizationMetaFieldsHelper()
//           .insertChildImmunizationMeta(items.tabChild_Vaccine_Details!.fields!);
//     }
//   }
//
//   callChildHealthData(String userName, String password, String token) async {
//     var responce = await ChildHealthDataMetaApi()
//         .callChildHealthMeta(userName, password, token);
//     if (responce.statusCode == 200) {
//       ChildHelthMetaFieldsModel childHealthMetaFields =
//       ChildHelthMetaFieldsModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertChildHealth(childHealthMetaFields);
//       Validate().saveString(Validate.ChildHealthUpdateDate,
//           childHealthMetaFields.tabChild_Health_Meta!.modified!);
//       callChildExitMeta(userName,password,token);
//       // Navigator.pop(context);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       // Validate().singleButtonPopup(
//       //     Global.returnTrLable(
//       //         locationControlls, CustomText.token_expired, lng!),
//       //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//       //     false,
//       //     context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:
//         Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertChildHealth(ChildHelthMetaFieldsModel items) async {
//     await DatabaseHelper.database!.delete('tab_child_health');
//     if (items.tabChild_Health_Meta != null) {
//       await ChildHealthMetaFieldsHelper()
//           .insertChildHealthMeta(items.tabChild_Health_Meta!.fields!);
//     }
//   }
//
//   callChildExitMeta(String userName, String password, String token) async {
//     var responce =
//     await ChildExitMetaApi().callChidExitMeta(userName, password, token);
//     if (responce.statusCode == 200) {
//       ChildExitMetaFieldsModel childExitMetaFields =
//       ChildExitMetaFieldsModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertChildExit(childExitMetaFields);
//
//       Validate().saveString(Validate.childExitUpdatedDate,
//           childExitMetaFields.tabChild_Exit_Meta!.modified!);
//       await callChildGrievancesMeta(userName, password, token);
//       // Navigator.pop(context);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       // Validate().singleButtonPopup(
//       //     Global.returnTrLable(
//       //         locationControlls, CustomText.token_expired, lng!),
//       //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//       //     false,
//       //     context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:
//         Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertChildExit(ChildExitMetaFieldsModel items) async {
//     await DatabaseHelper.database!.delete('tab_child_exit');
//     if (items.tabChild_Exit_Meta != null) {
//       await ChildExitMetaFieldsHelper()
//           .insertChildExitMeta(items.tabChild_Exit_Meta!.fields!);
//     }
//   }
//
//
//   callChildGrievancesMeta(
//       String userName, String password, String token) async {
//     var responce = await ChildGrievancesMetaApi()
//         .callChildGrievancesMeta(userName, password, token);
//     if (responce.statusCode == 200) {
//       ChildGrievancesMetaFieldsModel childExitMetaFields =
//       ChildGrievancesMetaFieldsModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertChildGrievances(childExitMetaFields);
//
//       Validate().saveString(Validate.childGravienceUpdatedDate,
//           childExitMetaFields.tabChild_Grievances_Meta!.modified!);
//       await crecheMonitoringApiMeta(userName,password,token);
//       // Navigator.pop(context);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       // Validate().singleButtonPopup(
//       //     Global.returnTrLable(
//       //         locationControlls, CustomText.token_expired, lng!),
//       //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//       //     false,
//       //     context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:
//         Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertChildGrievances(
//       ChildGrievancesMetaFieldsModel items) async {
//     await DatabaseHelper.database!.delete('tab_child_grievances');
//     if (items.tabChild_Grievances_Meta != null) {
//       await ChildGrievancesMetaFieldsHelper()
//           .insertChildGrievancesMeta(items.tabChild_Grievances_Meta!.fields!);
//     }
//   }
//
//
//   Future<void> crecheMonitoringApiMeta(
//       String userName, String password, String token) async {
//     final response = await CrecheMonitoringApi()
//         .getMetaData(username: userName, password: password, appToken: token);
//
//     if (response.statusCode == 200) {
//       final childExitMetaFields =
//       CrecheMonitoringMetaModel.fromJson(jsonDecode(response.body));
//
//       await callInsertCrecheMonitoringMeta(childExitMetaFields);
//
//       Validate().saveString(
//           Validate.crecheMonitoringMeta, childExitMetaFields.meta!.modified!);
//       await callChildReffrelMeta(userName,password,token);
//       // Navigator.pop(context);
//     } else if (response.statusCode == 401) {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.token_expired, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(response.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertCrecheMonitoringMeta(
//       CrecheMonitoringMetaModel items) async {
//     await DatabaseHelper.database!.delete('tabCrecheMonitorMeta');
//
//     if (items.meta == null) return;
//
//     await CrecheMonitoringFieldHelper()
//         .insertCrecheMonitorFields(items.meta!.fields!);
//   }
//
//   callChildReffrelMeta(String userName, String password, String token) async {
//     var responce = await ChildReferralMetaApi()
//         .callChildReferralMeta(userName, password, token);
//     if (responce.statusCode == 200) {
//       ChildReferralMetaFieldsModel childFollowUpMetaFields =
//       ChildReferralMetaFieldsModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertChildReferral(childFollowUpMetaFields);
//
//       Validate().saveString(Validate.childReferralUpdatedDate,
//           childFollowUpMetaFields.tabChild_referral_Meta!.modified!);
//       await callChildFollowUpMeta(userName,password,token);
//       // Navigator.pop(context);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       // Validate().singleButtonPopup(
//       //     Global.returnTrLable(
//       //         locationControlls, CustomText.token_expired, lng!),
//       //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//       //     false,
//       //     context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:
//         Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertChildReferral(
//       ChildReferralMetaFieldsModel items) async {
//     await DatabaseHelper.database!.delete('tab_child_referral');
//     if (items.tabChild_referral_Meta != null) {
//       await ChildReferralFieldsHelper()
//           .insertChildFollowUpMeta(items.tabChild_referral_Meta!.fields!);
//     }
//
//     if (items.tabDiagnosis_child_table != null) {
//       await ChildReferralFieldsHelper()
//           .insertChildFollowUpMeta(items.tabDiagnosis_child_table!.fields!);
//     }
//
//     if (items.tabReferral_child_table != null) {
//       await ChildReferralFieldsHelper()
//           .insertChildFollowUpMeta(items.tabReferral_child_table!.fields!);
//     }
//
//     if (items.tabTreatment_child_table != null) {
//       await ChildReferralFieldsHelper()
//           .insertChildFollowUpMeta(items.tabTreatment_child_table!.fields!);
//     }
//
//     if (items.tabTreatment_NRC_child_table != null) {
//       await ChildReferralFieldsHelper()
//           .insertChildFollowUpMeta(items.tabTreatment_NRC_child_table!.fields!);
//     }
//   }
//
//   callChildFollowUpMeta(String userName, String password, String token) async {
//     var responce = await ChildFollowUpMetaApi()
//         .callChildFollowUpMeta(userName, password, token);
//     if (responce.statusCode == 200) {
//       ChildFollowUpMetaFieldsModel childFollowUpMetaFields =
//       ChildFollowUpMetaFieldsModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertChildFollowUp(childFollowUpMetaFields);
//
//       Validate().saveString(Validate.childFollowUpUpdatedDate,
//           childFollowUpMetaFields.tabChild_FollowUp_Meta!.modified!);
//     await callCrecheCommitteMeta(userName,password,token);
//       // Navigator.pop(context);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content:
//             Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//           );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertChildFollowUp(
//       ChildFollowUpMetaFieldsModel items) async {
//     await DatabaseHelper.database!.delete('tab_child_followup');
//     if (items.tabChild_FollowUp_Meta != null) {
//       await ChildFollowUpFieldsHelper()
//           .insertChildFollowUpMeta(items.tabChild_FollowUp_Meta!.fields!);
//     }
//   }
//
//   callCrecheCommitteMeta(String userName, String password, String token) async {
//     var responce = await CrecheCommitteeMeetingMetaApi()
//         .callCrecheCommitteeMeetingMeta(userName, password, token);
//     if (responce.statusCode == 200) {
//       CrecheCommitteFieldsMetaModel crecheCommitteMetaFields =
//       CrecheCommitteFieldsMetaModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertCrecheCommitte(crecheCommitteMetaFields);
//
//       Validate().saveString(Validate.crecheCommitteUpdateDate,
//           crecheCommitteMetaFields.tabChild_creche_committe_Meta!.modified!);
//
//       // Navigator.pop(context);
//       await callCmcCBMMEtaApi(userName,password,token);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       // Validate().singleButtonPopup(
//       //     Global.returnTrLable(
//       //         locationControlls, CustomText.token_expired, lng!),
//       //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//       //     false,
//       //     context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove(Validate.Password);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:
//         Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lng!))),
//       );
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (mContext) => LoginScreen(),
//           ));
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertCrecheCommitte(
//       CrecheCommitteFieldsMetaModel items) async {
//     await DatabaseHelper.database!.delete('tab_creche_committe');
//     if (items.tabChild_creche_committe_Meta != null) {
//       await CrecheCommitteFieldsMetaHelper().insertCrecheCommitteMeta(
//           items.tabChild_creche_committe_Meta!.fields!);
//     }
//     if (items.tabAttendees_child_table != null) {
//       await CrecheCommitteFieldsMetaHelper().insertCrecheCommitteMeta(
//           items.tabAttendees_child_table!.fields!);
//     }
//   }
//
//
//   callCmcCBMMEtaApi(String userName, String password, String token) async {
//     var responce = await CrecheMonetringCheckListCBMApi()
//         .cmcCBMMetaApi(userName, password, token);
//     if (responce.statusCode == 200) {
//       CmcCBMMetaFieldsModel cmcCBMMetaFields =
//       CmcCBMMetaFieldsModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertcmcCBMMeta(cmcCBMMetaFields);
//
//       Validate().saveString(Validate.cmcCBMMetaUpdatedate,
//           cmcCBMMetaFields.tabCreche_Monitoring_CheckList_CBM!.modified!);
//       await callCmcALMMetaApi(userName, password, token);
//       // Navigator.pop(context);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.token_expired, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertcmcCBMMeta(CmcCBMMetaFieldsModel items) async {
//     await DatabaseHelper.database!.delete('tabCreche_Monitering_CheckList_CMB');
//     if (items.tabCreche_Monitoring_CheckList_CBM != null) {
//       await CrecheMoniteringCheckListCMBFieldsHelper()
//           .insertcmcCBMMeta(items.tabCreche_Monitoring_CheckList_CBM!.fields!);
//     }
//   }
//
//   callCmcALMMetaApi(String userName, String password, String token) async {
//     var responce = await CrecheMonetringCheckListALMApi()
//         .cmcALMMetaApi(userName, password, token);
//     if (responce.statusCode == 200) {
//       CmcALMMetaFieldsModel cmcALMMetaFields =
//       CmcALMMetaFieldsModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertcmcALMMeta(cmcALMMetaFields);
//
//       Validate().saveString(Validate.cmcALMMetaUpdatedate,
//           cmcALMMetaFields.tabCreche_Monitoring_CheckList_ALM!.modified!);
//
//       Navigator.pop(context);
//       // await callCashBookMetaApi(userName,password,token);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.token_expired, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertcmcALMMeta(CmcALMMetaFieldsModel items) async {
//     await DatabaseHelper.database!.delete('tabCreche_Monitering_CheckList_ALM');
//     if (items.tabCreche_Monitoring_CheckList_ALM != null) {
//       await CrecheMoniteringCheckListALMFieldsHelper()
//           .insertcmcALMMeta(items.tabCreche_Monitoring_CheckList_ALM!.fields!);
//     }
//   }
//
//   callCashBookMetaApi(String userName, String password, String token) async {
//     var responce =
//     await CashBookAPI().callCashBookMeta(userName, password, token);
//     if (responce.statusCode == 200) {
//       CashBookFieldsMetaModel cashbookMetaFields =
//       CashBookFieldsMetaModel.fromJson(jsonDecode(responce.body));
//
//       await callInsertCashBookMeta(cashbookMetaFields);
//
//       Validate().saveString(Validate.cashbookMetaUpdateDate,
//           cashbookMetaFields.tab_cashbook!.modified!);
//
//       Navigator.pop(context);
//     } else if (responce.statusCode == 401) {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.token_expired, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     } else {
//       Navigator.pop(context);
//       Validate().singleButtonPopup(
//           Global.errorBodyToString(responce.body, 'message'),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           context);
//     }
//   }
//
//   Future<void> callInsertCashBookMeta(CashBookFieldsMetaModel items) async {
//     await DatabaseHelper.database!.delete('tab_cashbook_fields');
//     if (items.tab_cashbook != null) {
//       await CashbookMetaFieldsHelper()
//           .insertCashBooketa(items.tab_cashbook!.fields!);
//     }
//   }
//
// }
//
//
//
//
//
//
//
//
//
