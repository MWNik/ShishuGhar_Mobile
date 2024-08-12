// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shishughar/custom_widget/custom_appbar.dart';
// import 'package:shishughar/custom_widget/custom_text.dart';
// import 'package:http/src/response.dart';
//
// import 'package:shishughar/style/styles.dart';
// import 'package:shishughar/utils/globle_method.dart';
//
// import '../api/cashBook_expenses_api.dart';
// import '../api/cashbook_receipt_api.dart';
// import '../api/child_attendance_upload_api.dart';
// import '../api/child_event_upload_api.dart';
// import '../api/child_exit_upload_api.dart';
// import '../api/child_followUp_upload_appi.dart';
// import '../api/child_grievance_upload_api.dart';
// import '../api/child_growth_meta_upload_api.dart';
// import '../api/child_health_upload_api.dart';
// import '../api/child_immunizatiion_upload_api.dart';
// import '../api/child_profile_data_upload_api.dart';
// import '../api/child_referral_upload_api.dart';
// import '../api/creche_Monitering_checkList_ALM_api.dart';
// import '../api/creche_checkIn_api.dart';
// import '../api/creche_commettie_upload_api.dart';
// import '../api/creche_monetering_checkList_cbm_api.dart';
// import '../api/creche_monitering_checklist_cc_api.dart';
// import '../api/creche_monitoring_api.dart';
// import '../api/creche_profile_data_upload_api.dart';
// import '../api/hh_data_upload_api.dart';
// import '../api/village_profile_meta_api.dart';
// import '../custom_widget/custom_btn.dart';
// import '../custom_widget/dynamic_screen_widget/dynamic_custom_checkbox.dart';
// import '../database/helper/anthromentory/child_growth_response_helper.dart';
// import '../database/helper/cashbook/expences/cashbook_response_expences_helper.dart';
// import '../database/helper/cashbook/receipt/cashbook_receipt_response_helper.dart';
// import '../database/helper/check_in/check_in_response_helper.dart';
// import '../database/helper/check_in_helper.dart';
// import '../database/helper/child_attendence/child_attendance_helper_responce.dart';
// import '../database/helper/child_attendence/child_attendence_helper.dart';
// import '../database/helper/child_event/child_event_response_helper.dart';
// import '../database/helper/child_exit/child_exit_response_Helper.dart';
// import '../database/helper/child_gravience/child_grievances_response_helper.dart';
// import '../database/helper/child_health/child_health_response_helper.dart';
// import '../database/helper/child_immunization/child_immunization_response_helper.dart';
// import '../database/helper/child_reffrel/child_refferal_response_helper.dart';
// import '../database/helper/cmc_CC/creche_monitering_checklist_CC_response_helper.dart';
// import '../database/helper/cmc_alm/creche_monitering_checkList_ALM_response_helper.dart';
// import '../database/helper/cmc_cbm/creche_monitering_checklist_CBM_response_helper.dart';
// import '../database/helper/creche_comite_meeting/creche_committie_response_helper.dart';
// import '../database/helper/creche_helper/creche_care_giver_helper.dart';
// import '../database/helper/creche_helper/creche_data_helper.dart';
// import '../database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
// import '../database/helper/dynamic_screen_helper/house_hold_children_helper.dart';
// import '../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
// import '../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
// import '../database/helper/follow_up/child_followUp_response_helper.dart';
// import '../database/helper/translation_language_helper.dart';
// import '../database/helper/village_profile/village_profile_response_helper.dart';
// import '../model/apimodel/translation_language_api_model.dart';
// import '../utils/validate.dart';
// import 'login_screen.dart';
//
// class PendingSyncScreenNew extends StatefulWidget {
//
//   const PendingSyncScreenNew({super.key});
//
//   @override
//   State<PendingSyncScreenNew> createState() => _PendingSyncScreenState();
// }
//
// class _PendingSyncScreenState extends State<PendingSyncScreenNew> {
//   TextEditingController Searchcontroller = TextEditingController();
//   Map<String, String> syncInfo = {};
//   Map<String, int> syncInfoCount = {};
//   String sysHeader = '';
//   String? userRole;
//   String? lng;
//   int selectAllOpt = 0;
//   int syncCount = 0;
//   bool _isLoading = true;
//   int currentUploadStatus=0;
//   List<Translation> locationControlls = [];
//   List<Future<void> Function(BuildContext)> methods = [];
//   List<Future<void> Function(BuildContext)> UploadAll = [];
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Center(child: CircularProgressIndicator());
//     } else {
//       return WillPopScope(
//         onWillPop: () async {
//           Navigator.pop(context, 'itemRefresh');
//           return true;
//         },
//         child: Scaffold(
//           appBar: CustomAppbar(
//             text: (lng != null)
//                 ? Global.returnTrLable(locationControlls, CustomText.sync, lng!)
//                 : "",
//             onTap: () {
//               Navigator.pop(context, 'itemRefresh');
//             },
//           ),
//           body: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//             child: Column(
//               children: [
//                 syncCount>0?DynamicCustomCheckboxWithLabel(
//                   label: CustomText.selectAllForUpload,
//                   initialValue: selectAllOpt,
//                   onChanged: (value) {
//                     setState(() {
//                       selectAllOpt=value;
//                     });
//                   },
//                 ):SizedBox(),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                       itemCount: syncInfo.keys
//                           .toList()
//                           .length,
//                       shrinkWrap: true,
//                       physics: BouncingScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       itemBuilder: (BuildContext context, int index) {
//                         return GestureDetector(
//                           onTap: () async {
//                             if (userRole == 'Creche Supervisor') {
//                                  if(selectAllOpt==0){
//                                    if (index > 0 && index < 11)
//                                      await uploadDataSequence1(context, index);
//                                    else
//                                      await methods[index](context);
//                                  }
//
//                             } else {
//                               await methods[index](context);
//                             }
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(vertical: 5.h),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0xff5A5A5A).withOpacity(
//                                           0.2), // Shadow color with opacity
//                                       offset: Offset(0,
//                                           3), // Horizontal and vertical offset
//                                       blurRadius: 6, // Blur radius
//                                       spreadRadius: 0, // Spread radius
//                                     ),
//                                   ],
//                                   color: Colors.white,
//                                   border: Border.all(color: Color(0xffE7F0FF)),
//                                   borderRadius: BorderRadius.circular(10.r)),
//                               height: 42.h,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10.w, vertical: 8.h),
//                                 child: Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         // Content (RichText)
//                                         Expanded(
//                                           child: RichText(
//                                             strutStyle: StrutStyle(height: 1.h),
//                                             overflow: TextOverflow.ellipsis,
//                                             text: TextSpan(
//                                               text:
//                                               "${syncInfo.keys
//                                                   .toList()[index]} : ",
//                                               style: Styles.urbanblack157,
//                                               children: parseBoldText(
//                                                 syncInfo[syncInfo.keys
//                                                     .toList()[index]] ??
//                                                     '',
//                                                 Styles.blue125,
//                                                 Styles.black144.copyWith(
//                                                     fontWeight:
//                                                     FontWeight.bold),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         selectAllOpt == 1 ? Image.asset(
//                                           checkAllForUpload(
//                                               syncInfo.keys.toList()[index]),
//                                           scale: 4.4,
//                                           color: Colors.grey,
//                                         ) : Image.asset(
//                                           "assets/sync_icon.png",
//                                           scale: 4.4,
//                                           color: Colors.grey,
//                                         ),
//                                       ],
//                                     ),
//                                     // Image to the right
//
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 selectAllOpt == 1 ? CElevatedButton(
//                   text: CustomText.uploadAll,
//                   color: Color(0xff369A8D),
//                   onPressed: () async {
//                     await uploadDataSequence1(context, 6);
//                   },
//                 ) : SizedBox()
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initializeData();
//   }
//
//   callUploadData() async {
//
//     sysHeader = '';
//
//     var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
//     syncInfo[Global.returnTrLable(
//         locationControlls, CustomText.HHListing, lng!)] =
//     '[b]${hhItems.length}[/b] ${Global.returnTrLable(
//         locationControlls, CustomText.recordAvailable, lng!)}';
//     syncInfoCount[Global.returnTrLable(
//         locationControlls, CustomText.HHListing, lng!)] = hhItems.length;
//     if (userRole == 'Creche Supervisor') {
//       syncCount=await callCountForUpload();
//       hhItems = hhItems
//           .where((element) =>
//       Global.stringToInt(Global.getItemValues(element.responces!,
//           'verification_status')) > 1)
//           .toList();
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.HHListing, lng!)] = hhItems.length;
//       var chilProfiles =
//       await EnrolledChilrenResponceHelper().callChildrenForUpload();
//
//       ///Child profile
//       if (chilProfiles.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildProfile, lng!)] =
//         '[b]${chilProfiles.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       }
//       else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildProfile, lng!)] =
//         '[b]${chilProfiles.length}[/b]  ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.ChildProfile, lng!)] =
//           chilProfiles.length;
//
//
//
//       var childexitdata =
//       await ChildExitResponceHelper().getEditedChildExitForUpload();
//       if (childexitdata.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildExit, lng!)] =
//         '[b]${childexitdata.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       }
//       else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildExit, lng!)] =
//         '[b]${childexitdata.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.ChildExit, lng!)] =
//           childexitdata.length;
//
//       var anthropomertydata = await ChildGrowthResponseHelper()
//           .callChildGrowthResponsesForUpload();
//       if (anthropomertydata.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.GrowthMonitoring, lng!)] =
//         '[b]${anthropomertydata.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       }
//       else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.GrowthMonitoring, lng!)] =
//         '[b]${anthropomertydata.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.GrowthMonitoring, lng!)] =
//           anthropomertydata.length;
//
//       var referralData =
//       await ChildReferralTabResponseHelper().getChildReferralForUpload();
//       if (referralData.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.childReferral, lng!)] =
//         '[b]${referralData.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       } else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.childReferral, lng!)] =
//         '[b]${referralData.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.childReferral, lng!)] =
//           referralData.length;
//
//       var followUpData =
//       await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
//       if (followUpData.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.fllowUp, lng!)] =
//         '[b]${followUpData.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       } else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.fllowUp, lng!)] =
//         '[b]${followUpData.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.fllowUp, lng!)] = followUpData.length;
//
//       var chilAttendence = await ChildAttendanceResponceHelper()
//           .callChildAttendencesAllForUpoad();
//       if (chilAttendence.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.childAttendence, lng!)] =
//         '[b]${chilAttendence.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       }
//       else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.childAttendence, lng!)] =
//         '[b]${chilAttendence.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.childAttendence, lng!)] =
//           chilAttendence.length;
//
//
//       var childeventResponses = await ChildEventTabResponceHelper()
//           .getEditedChildEventsForUpload();
//       if (childeventResponses.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildEvents, lng!)] =
//         '[b]${childeventResponses.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       }
//       else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildEvents, lng!)] =
//         '[b]${childeventResponses.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.ChildEvents, lng!)] =
//           childeventResponses.length;
//
//
//       var childHeathData = await ChildHealthTabResponceHelper()
//           .getChildHealthForUpload();
//       if (childeventResponses.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildHealth, lng!)] =
//         '[b]${childHeathData.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       }
//       else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildHealth, lng!)] =
//         '[b]${childHeathData.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.ChildHealth, lng!)] =
//           childHeathData.length;
//
//       var childImmunizationDAta = await ChildImmunizationResponseHelper()
//           .getChildImmunizationForUpload();
//       if (childeventResponses.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildImmunization, lng!)] =
//         '[b]${childImmunizationDAta.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       }
//       else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildImmunization, lng!)] =
//         '[b]${childImmunizationDAta.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.ChildImmunization, lng!)] =
//           childImmunizationDAta.length;
//
//       ///Shishu ghar
//
//       var creshePrfile = await CrecheDataHelper().callCrecheForUpload();
//       if (creshePrfile.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.CrecheProfileView, lng!)] =
//         '[b]${creshePrfile.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       }
//       else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.CrecheProfileView, lng!)] =
//         '[b]${creshePrfile.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.CrecheProfileView, lng!)] =
//           creshePrfile.length;
//
//       var checkins = await CheckInResponseHelper().callCrecheCheckInResponses();
//       if (checkins.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.checkIns, lng!)] =
//         '[b]${checkins.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       }
//       else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.checkIns, lng!)] =
//         '[b]${checkins.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.checkIns, lng!)] = checkins.length;
//
//       var grievanceData =
//       await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
//       if (grievanceData.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildGrievances, lng!)] =
//         '[b]${grievanceData.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       } else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.ChildGrievances, lng!)] =
//         '[b]${grievanceData.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.ChildGrievances, lng!)] =
//           grievanceData.length;
//
//
//       var creCheMonitoring = await CrecheMonitorResponseHelper()
//           .getCrecheResponseForUpload();
//       if (creCheMonitoring.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.VisitNotes, lng!)] =
//         '[b]${creCheMonitoring.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       } else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.VisitNotes, lng!)] =
//         '[b]${creCheMonitoring.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.VisitNotes, lng!)] =
//           creCheMonitoring.length;
//
//
//       var ccmData =
//       await CrecheCommittieResponnseHelper().getCrecheCommittieForUpload();
//       if (ccmData.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.CrecheCommitte, lng!)] =
//         '[b]${ccmData.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       } else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.CrecheCommitte, lng!)] =
//         '[b]${ccmData.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.CrecheCommitte, lng!)] = ccmData.length;
//
//
//       var cashBookDataExpences =
//       await CashBookResponseExpencesHelper()
//           .getEditedCashBookForExpenceUpload();
//       if (cashBookDataExpences.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.CashBookExpences, lng!)] =
//         '[b]${cashBookDataExpences.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       } else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.CashBookExpences, lng!)] =
//         '[b]${cashBookDataExpences.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.CashBookExpences, lng!)] =
//           cashBookDataExpences.length;
//
//
//       var cashBookDataReciept = await CashBookReceiptResponseHelper()
//           .getEditedCashBookReceiptForUpload();
//       if (cashBookDataReciept.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.CashBookReceipt, lng!)] =
//         '[b]${cashBookDataReciept.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       } else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.CashBookReceipt, lng!)] =
//         '[b]${cashBookDataReciept.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.CashBookReceipt, lng!)] =
//           cashBookDataReciept.length;
//
//
//       var villageProfiles = await VillageProfileResponseHelper().getVillageProfileforUpload();
//       if (villageProfiles.length > 1) {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.villageProfile, lng!)] =
//         '[b]${villageProfiles.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordsAvailable, lng!)}';
//       } else {
//         syncInfo[Global.returnTrLable(
//             locationControlls, CustomText.villageProfile, lng!)] =
//         '[b]${villageProfiles.length}[/b] ${Global.returnTrLable(
//             locationControlls, CustomText.recordAvailable, lng!)}';
//       }
//
//       syncInfoCount[Global.returnTrLable(
//           locationControlls, CustomText.villageProfile, lng!)] =
//           villageProfiles.length;
//     }
//
//     if (hhItems.length > 1) {
//       syncInfo[Global.returnTrLable(
//           locationControlls, CustomText.HHListing, lng!)] =
//       '[b]${hhItems.length}[/b] ${Global.returnTrLable(
//           locationControlls, CustomText.recordsAvailable, lng!)}';
//     } else {
//       syncInfo[Global.returnTrLable(
//           locationControlls, CustomText.HHListing, lng!)] =
//       '[b]${hhItems.length}[/b] ${Global.returnTrLable(
//           locationControlls, CustomText.recordAvailable, lng!)}';
//     }
//     syncInfoCount[Global.returnTrLable(
//         locationControlls, CustomText.HHListing, lng!)] = hhItems.length;
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//
//   Future<void> uploadData(BuildContext mContext) async {
//     var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
//     hhItems = hhItems
//         .where((element) =>
//     Global.stringToInt(Global.getItemValues(element.responces!,
//         'verification_status')) > 1)
//         .toList();
//     if (hhItems.length > 0) {
//       showLoaderDialog(context);
//       hhItems.forEach((element) async {
//         var cItems = await HouseHoldChildrenHelperHelper()
//             .getResponceHouseHoldChildren(element
//             .HHGUID!); //"{"name":684,"parent":413,"hhguid":"q9bYVpayHGNzNwlQbnCdlOzQ1714538085360","hhcguid":"BWJpZLlBtZO3B7v1K2tcc6QG1714538201579","app…"
//         Map<String, dynamic> resultMap =
//         jsonDecode(element.responces!); // Map format of the above
//         List<dynamic> childrensList = [];
//
//         for (var cItem in cItems) {
//           childrensList
//               .add(jsonDecode(cItem)); //Added to the List in JSON format
//         }
//         if (element.name == null) {
//           if (childrensList.length > 0) {
//             resultMap['children'] = childrensList;
//           }
//         }
//         // resultMap['verification_status'] = "3";
//
//         var token = await Validate().readString(Validate.appToken);
//         if (element.name != null) {
//           var responce = await HHDataUploadApi().uploadHHDataUpdate(
//               token!, element.name!, resultMap, childrensList);
//           if (responce.statusCode == 200) {
//             print('Upload: $responce');
//             await updateResponces(responce);
//             if ((hhItems.indexOf(element)) == (hhItems.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             return;
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce =
//           await HHDataUploadApi().uploadHHData(token!, resultMap);
//           if (responce.statusCode == 200) {
//             await updateResponces(responce);
//             if ((hhItems.indexOf(element)) == (hhItems.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//
//   Future<void> uploadChildProfile(BuildContext mContext) async {
//     var chilProfiles = await EnrolledChilrenResponceHelper()
//         .callChildrenForUpload();
//     if (chilProfiles.length > 0) {
//       showLoaderDialog(context);
//       chilProfiles.forEach((element) async {
//         var token = await Validate().readString(Validate.appToken);
//         Map<String, dynamic> resultMap = jsonDecode(element.responces!);
//         resultMap['status'] = '1';
//         var itemResponce = jsonEncode(resultMap);
//         if (element.name != null) {
//           var responce = await EnrolledChildProfileUploadApi()
//               .enrolledChildProfileUploadUpdate(
//               token!, itemResponce, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildProfile(responce);
//             if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false, context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(locationControlls,
//             //         CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false, context);
//
//             return;
//           }
//         }
//         else {
//           var responce =
//           await EnrolledChildProfileUploadApi().enrolledChildProfileUpload(
//               token!, itemResponce);
//           if (responce.statusCode == 200) {
//             await updateResponcesChildProfile(responce);
//             if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false, context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(locationControlls,
//             //         CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false, context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> uploadCreCheProfile(BuildContext mContext) async {
//     var crecheProfiles = await CrecheDataHelper().callCrecheForUpload();
//     if (crecheProfiles.length > 0) {
//       showLoaderDialog(context);
//       crecheProfiles.forEach((element) async {
//         var cItems = await CrecheCareGiverHelper()
//             .callCareGiverUpload(element.name!);
//         Map<String, dynamic> resultMap = jsonDecode(element.responces!);
//         List<dynamic> childrensList = [];
//
//         for (var cItem in cItems) {
//           childrensList.add(jsonDecode(cItem.responces!));
//         }
//         if (childrensList.length > 0) {
//           resultMap['creche_caregiver_table'] = childrensList;
//         }
//
//         var token = await Validate().readString(Validate.appToken);
//         if (element.name != null) {
//           var responce = await CrecheDataResponceUploadApi()
//               .crecheCareGiverUploadUpdate(
//             token!, jsonEncode(resultMap), element.name!,);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateCreCheProFile(responce);
//             if ((crecheProfiles.indexOf(element)) ==
//                 (crecheProfiles.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=11;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(locationControlls,
//             //         CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false, context);
//
//             return;
//           }
//         } else {
//           var responce = await CrecheDataResponceUploadApi()
//               .crecheCareGiverUpload(token!, jsonEncode(resultMap));
//           if (responce.statusCode == 200) {
//             await updateCreCheProFile(responce);
//             if ((crecheProfiles.indexOf(element)) ==
//                 (crecheProfiles.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=11;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(locationControlls,
//             //         CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false, context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=11;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> uploadDataCoordinator(BuildContext mContext) async {
//     var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
//
//     if (hhItems.length > 0) {
//       showLoaderDialog(context);
//       var token = await Validate().readString(Validate.appToken);
//       var userName = await Validate().readString(Validate.userName);
//       var password = await Validate().readString(Validate.Password);
//       List<Map<String, dynamic>> dataList = [];
//       hhItems.forEach((element) async {
//         Map<String, dynamic> resultMap = jsonDecode(element.responces!);
//         if (element.name != null) {
//           Map<String, dynamic> item = {};
//           item['name'] = element.name;
//           item['status'] = resultMap['verification_status'];
//           item['verified_by'] = resultMap['verified_by'];
//           item['verified_on'] = resultMap['verified_on'];
//           dataList.add(item);
//         }
//       });
//
//       var hhData = {
//         "usr": userName,
//         "pwd": password,
//         "hh": dataList,
//       };
//       var responce =
//       await HHDataUploadApi().uploadLatestApiHHData(token!, hhData);
//       if (responce.statusCode == 200) {
//         await updateVerification(responce, dataList);
//         Navigator.pop(mContext);
//         Validate().singleButtonPopup(
//             Global.returnTrLable(locationControlls,
//                 CustomText.data_upload_success_msg, lng!),
//             Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//             context);
//       } else if (responce.statusCode == 401) {
//         Navigator.pop(mContext);
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.remove(Validate.Password);
//         ScaffoldMessenger.of(mContext).showSnackBar(
//           SnackBar(content:
//           Text(Global.returnTrLable(
//               locationControlls, CustomText.token_expired, lng!))),
//         );
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (mContext) => LoginScreen(),
//             ));
//         // Validate().singleButtonPopup(
//         //     Global.returnTrLable(locationControlls,
//         //         CustomText.token_expired, lng!),
//         //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
//         return;
//       } else {
//         Navigator.pop(mContext);
//         await callUploadData();
//         Validate().singleButtonPopup(
//             Global.errorBodyToString(responce.body, 'message'),
//             Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//             context);
//
//         return;
//       }
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> uploadAttendance(BuildContext mContext) async {
//     var chilAttendence = await ChildAttendanceResponceHelper()
//         .callChildAttendencesAllForUpoad();
//     if (chilAttendence.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       chilAttendence.forEach((element) async {
//         var cItems = await ChildAttendenceHelper()
//             .callChildAttendencesForUpload(element.childattenguid,
//             Global.getItemValues(element.responces!, 'date_of_attendance'));
//
//         Map<String, dynamic> resultMap = jsonDecode(element.responces!);
//         List<dynamic> childrensList = [];
//
//         for (var cItem in cItems) {
//           childrensList.add(cItem);
//         }
//         if (childrensList.length > 0) {
//           resultMap['childattendancelist'] = childrensList;
//         }
//
//         if (element.name == null) {
//           var responce = await ChildAttendanceUploadApi()
//               .AttendanceUpload(token!, jsonEncode(resultMap));
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildAttendance(responce);
//             if ((chilAttendence.indexOf(element)) ==
//                 (chilAttendence.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=7;
//                 await methods[currentUploadStatus](context);
//               }else Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//
//             }
//           }
//           else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           }
//           else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildAttendanceUploadApi()
//               .childAttendanceUpload(
//               token!, jsonEncode(resultMap), element.name);
//           if (responce.statusCode == 200) {
//             await updateResponcesChildAttendance(responce);
//             if ((chilAttendence.indexOf(element)) ==
//                 (chilAttendence.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=7;
//                 await methods[currentUploadStatus](context);
//               }else Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           }
//           else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           }
//           else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=7;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> uploadCheckInData(BuildContext mContext) async {
//     var crecheCheckIn = await CheckInHelper().callCrecheCheckInResponses();
//     if (crecheCheckIn.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       crecheCheckIn.forEach((element) async {
//         Map<String, dynamic> jsonBody = element.toJson();
//         var creCheDetails =
//         await CrecheDataHelper().getCrecheResponceItem(element.creche_id!);
//         if (creCheDetails.length > 0) {
//           jsonBody['partner_id'] =
//               Global.getItemValues(creCheDetails[0].responces!, 'partner_id');
//           jsonBody['state_id'] =
//               Global.getItemValues(creCheDetails[0].responces!, 'state_id');
//           jsonBody['district_id'] =
//               Global.getItemValues(creCheDetails[0].responces!, 'district_id');
//           jsonBody['block_id'] =
//               Global.getItemValues(creCheDetails[0].responces!, 'block_id');
//           jsonBody['gp_id'] =
//               Global.getItemValues(creCheDetails[0].responces!, 'gp_id');
//           jsonBody['village_id'] =
//               Global.getItemValues(creCheDetails[0].responces!, 'village_id');
//           jsonBody['supervisor_id'] = Global.getItemValues(
//               creCheDetails[0].responces!, 'supervisor_id');
//         }
//         if (element.name == null) {
//           var responce = await CrecheCheckInApi()
//               .checkInUpload(token!, jsonEncode(jsonBody));
//           if (responce.statusCode == 200) {
//             await updateResponcesCrecheCheckIn(responce);
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             if ((crecheCheckIn.indexOf(element)) ==
//                 (crecheCheckIn.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=12;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           Navigator.pop(mContext);
//           Validate().singleButtonPopup(
//               Global.returnTrLable(locationControlls, 'GUID is Empty', lng!),
//               Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//               false,
//               mContext);
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=12;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesCrecheCheckIn(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await CheckInHelper().updateUploadedCrecheCheckInResponce(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> updateResponcesChildAttendance(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await ChildAttendanceResponceHelper()
//           .updateUploadedChildAttendanceItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> updateResponces(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await HouseHoldTabResponceHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> updateCreCheProFile(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await CrecheDataHelper().updateDownloadeData(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> updateResponcesChildProfile(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await EnrolledChilrenResponceHelper().updateUploadedChildProfileItem(
//           resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
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
//   Future<void> updateVerification(Response value,
//       List<Map<String, dynamic>> dataList) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       if (resultMap['Response'] == 'Success') {
//         await HouseHoldTabResponceHelper().updateVerficationUpload(dataList);
//         await callUploadData();
//       }
//       print(" responce $resultMap");
//       Validate().singleButtonPopup(Global.returnTrLable(
//           locationControlls, CustomText.data_upload_success_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//
//       Navigator.pop(context);
//     } catch (e) {
//       print("exp ${e.toString()}");
//       Validate().singleButtonPopup(Global.returnTrLable(
//           locationControlls, CustomText.data_not_uploaded_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!), false,
//           context);
//
//       Navigator.pop(context);
//     }
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
//                     locationControlls, CustomText.uploadingPleaseWait, lng!)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   Future<void> initializeData() async {
//     lng = await Validate().readString(Validate.sLanguage);
//     userRole = await Validate().readString(Validate.role);
//     List<String> valueNames = [
//       CustomText.recordAvailable,
//       CustomText.HHListing,
//       CustomText.sync,
//       CustomText.nothing_for_upload_msg,
//       CustomText.data_upload_success_msg,
//       CustomText.data_not_uploaded_msg,
//       CustomText.ok,
//       CustomText.uploadingPleaseWait,
//       CustomText.token_expired,
//       CustomText.ChildProfile,
//       CustomText.CrecheProfileView,
//       CustomText.fllowUp
//     ];
//     if (userRole == 'Creche Supervisor') {
//       methods = [
//         uploadData,
//         uploadChildProfile,
//         uploadChildExitData,
//         uploadChildGrowthData,
//         uploadChildReferralData,
//         uploadChildFollowUpData,
//         uploadAttendance,
//         uploadChildEventData,
//         uploadChildHealthData,
//         uploadChildImmunizationData,
//         uploadCreCheProfile,
//         uploadCheckInData,
//         uploadChildGrievanceData,
//         uploadCrecheMonitorData,
//         uploadCrecheCommittieData,
//         uploadCashbookData,
//         uploadCashbookReceiptData,
//         uploadVillageProfile,
//       ];
//     }
//     else if (userRole == 'Cluster Coordinator') {
//       methods = [
//         uploadDataCoordinator,
//         uploadcmcCCData
//       ];
//     }
//     else if (userRole == 'Accounts and Logistics Manager') {
//       methods = [
//         uploadcmcALMData,
//       ];
//     }
//     else if (userRole == 'Capacity and Building Manager') {
//       methods = [
//         uploadcmcCBMData,
//       ];
//     }
//
//     await TranslationDataHelper()
//         .callTranslateString(valueNames)
//         .then((value) => locationControlls = value);
//     await callUploadData();
//
//
//     setState(() {});
//   }
//
//   Future<void> uploadChildGrowthData(BuildContext mContext) async {
//     var anthropomertydata =
//     await ChildGrowthResponseHelper().callChildGrowthResponses();
//     if (anthropomertydata.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       anthropomertydata.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//
//         if (element.name != null) {
//           var responce = await ChildGrowthMetaUploadApi()
//               .childGrowthMetaUploadUpdate(
//               token!, jsonEncode(jsonBody), element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildGrowth(responce, element.responces!);
//             if ((anthropomertydata.indexOf(element)) ==
//                 (anthropomertydata.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           }
//           else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildGrowthMetaUploadApi()
//               .childGrowthMetaUpload(token!, jsonEncode(jsonBody));
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildGrowth(responce, element.responces!);
//             if ((anthropomertydata.indexOf(element)) ==
//                 (anthropomertydata.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           }
//           else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesChildGrowth(Response value,
//       String responcence) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await ChildGrowthResponseHelper()
//           .updateUploadedChildGrowthResponce(resultMap, responcence);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadChildEventData(BuildContext mContext) async {
//     var childeventdata =
//     await ChildEventTabResponceHelper().getEditedChildEventsForUpload();
//     if (childeventdata.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       childeventdata.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//
//         if (element.name != null) {
//           var responce = await ChildEventUploadApi().childEventUploadUpdate(
//               token!, jsonEncode(jsonBody), element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildEvent(responce);
//             if ((childeventdata.indexOf(element)) ==
//                 (childeventdata.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=8;
//                 await methods[currentUploadStatus](context);
//               }else Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildEventUploadApi()
//               .childEventUpload(token!, jsonEncode(jsonBody));
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildEvent(responce);
//             if ((childeventdata.indexOf(element)) ==
//                 (childeventdata.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=8;
//                 await methods[currentUploadStatus](context);
//               }else Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=8;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesChildEvent(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await ChildEventTabResponceHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadChildHealthData(BuildContext mContext) async {
//     var childhealthdata =
//     await ChildHealthTabResponceHelper().getChildHealthForUpload();
//     if (childhealthdata.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       childhealthdata.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//
//         if (element.name != null) {
//           var responce = await ChildHealthUploadApi().childHealthUploadUpdate(
//               token!, jsonEncode(jsonBody), element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildHealth(responce);
//             if ((childhealthdata.indexOf(element)) ==
//                 (childhealthdata.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=9;
//                 await methods[currentUploadStatus](context);
//               }else
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildHealthUploadApi()
//               .childHealthUpload(token!, jsonEncode(jsonBody));
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildHealth(responce);
//             if ((childhealthdata.indexOf(element)) ==
//                 (childhealthdata.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=9;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=9;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesChildHealth(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await ChildHealthTabResponceHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//
//   Future<void> uploadChildImmunizationData(BuildContext mContext) async {
//     var childimmunizationdata =
//     await ChildImmunizationResponseHelper().getChildImmunizationForUpload();
//     if (childimmunizationdata.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       childimmunizationdata.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//
//         if (element.name != null) {
//           var responce = await ChildImmunizationUploadApi()
//               .childImmunzationUploadUpdate(
//               token!, jsonEncode(jsonBody), element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildImmunization(responce);
//             if ((childimmunizationdata.indexOf(element)) ==
//                 (childimmunizationdata.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=10;
//                 await methods[currentUploadStatus](context);
//               }else Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildImmunizationUploadApi()
//               .childImmunzationUpload(token!, jsonEncode(jsonBody));
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildImmunization(responce);
//             if ((childimmunizationdata.indexOf(element)) ==
//                 (childimmunizationdata.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=10;
//                 await methods[currentUploadStatus](context);
//               }else Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=10;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesChildImmunization(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await ChildImmunizationResponseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadChildExitData(BuildContext mContext) async {
//     var childexitdata =
//     await ChildExitResponceHelper().getEditedChildExitForUpload();
//     if (childexitdata.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       childexitdata.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//
//         if (element.name != null) {
//           var responce = await ChildExitUploadApi().childExitUploadUpdate(
//               token!, jsonEncode(jsonBody), element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildExit(responce);
//             if ((childexitdata.indexOf(element)) ==
//                 (childexitdata.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildExitUploadApi()
//               .childExitUpload(token!, jsonEncode(jsonBody));
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildExit(responce);
//             if ((childexitdata.indexOf(element)) ==
//                 (childexitdata.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesChildExit(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await ChildExitResponceHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadChildGrievanceData(BuildContext mContext) async {
//     var grievancedata =
//     await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
//     if (grievancedata.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       grievancedata.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//         jsonBody['status'] = '1';
//         var itemResponce = jsonEncode(jsonBody);
//         if (element.name != null) {
//           var responce = await ChildGrievanceUploadApi()
//               .childGrievanceUploadUpdate(
//               token!, itemResponce, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildGrievance(responce);
//             if ((grievancedata.indexOf(element)) ==
//                 (grievancedata.length - 1)) {
//               Navigator.pop(mContext);
//
//               if(selectAllOpt==1){
//                 currentUploadStatus=13;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           }
//           else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildGrievanceUploadApi()
//               .childGrievanceUpload(token!, itemResponce);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildGrievance(responce);
//             if ((grievancedata.indexOf(element)) ==
//                 (grievancedata.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=13;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=13;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesChildGrievance(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await ChildGrievancesTabResponceHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadCrecheMonitorData(BuildContext mContext) async {
//     final crecheData =
//     await CrecheMonitorResponseHelper().getCrecheResponseForUpload();
//     if (crecheData.isNotEmpty) {
//       showLoaderDialog(mContext);
//
//       final token = await Validate().readString(Validate.appToken);
//
//       crecheData.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//
//         final itemResponse = jsonEncode(jsonBody);
//
//         if (element.name != null) {
//           final response = await CrecheMonitoringApi().updateUploadedCheckList(
//             appToken: token!,
//             dataResponse: itemResponse,
//             name: element.name ?? 0,
//           );
//           if (response.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponsesCrecheMonitorData(response);
//             if ((crecheData.indexOf(element)) ==
//                 (crecheData.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=14;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (response.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(response.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//         else {
//           final response = await CrecheMonitoringApi().uploadCheckList(
//             appToken: token!,
//             dataResponse: itemResponse,
//           );
//
//           if (response.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponsesCrecheMonitorData(response);
//             if ((crecheData.indexOf(element)) ==
//                 (crecheData.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=14;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (response.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(response.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=14;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponsesCrecheMonitorData(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" response $resultMap");
//       await CrecheMonitorResponseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadChildReferralData(BuildContext mContext) async {
//     var referralData =
//     await ChildReferralTabResponseHelper().getChildReferralForUpload();
//     if (referralData.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       referralData.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//         jsonBody['status'] = '1';
//         var itemResponce = jsonEncode(jsonBody);
//         if (element.name != null) {
//           var responce = await ChildReferralUploadApi()
//               .childReferralUploadUpdate(token!, itemResponce, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildReferral(responce);
//             if ((referralData.indexOf(element)) ==
//                 (referralData.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildReferralUploadApi()
//               .childReferralUpload(token!, itemResponce);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildReferral(responce);
//             if ((referralData.indexOf(element)) ==
//                 (referralData.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesChildReferral(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await ChildReferralTabResponseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadChildFollowUpData(BuildContext mContext) async {
//     var followUpData =
//     await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
//     if (followUpData.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       followUpData.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//         jsonBody['status'] = '1';
//         var itemResponce = jsonEncode(jsonBody);
//         if (element.name != null) {
//           var responce = await ChildFollowUpUploadApi()
//               .childFollowUpUploadUpdate(token!, itemResponce, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildFollowUp(responce);
//             if ((followUpData.indexOf(element)) ==
//                 (followUpData.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildFollowUpUploadApi()
//               .childFollowUpUpload(token!, itemResponce);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildFollowUp(responce);
//             if ((followUpData.indexOf(element)) ==
//                 (followUpData.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesChildFollowUp(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await ChildFollowUpTabResponseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadCrecheCommittieData(BuildContext mContext) async {
//     var ccmData =
//     await CrecheCommittieResponnseHelper().getCrecheCommittieForUpload();
//     if (ccmData.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       ccmData.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//         jsonBody['status'] = '1';
//         var itemResponce = jsonEncode(jsonBody);
//         if (element.name != null) {
//           var responce = await CrecheCommittieUploadApi()
//               .childCrecheCommittieUploadUpdate(
//               token!, itemResponce, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesCrecheCommittie(responce);
//             if ((ccmData.indexOf(element)) ==
//                 (ccmData.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=15;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await CrecheCommittieUploadApi()
//               .childCrecheCommittieUpload(token!, itemResponce);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesCrecheCommittie(responce);
//
//             if ((ccmData.indexOf(element)) ==
//                 (ccmData.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=15;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=15;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesCrecheCommittie(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await CrecheCommittieResponnseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//
//   Future<void> updateResponcesCmcCBm(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await CmcCBMTabResponseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//
//   Future<void> uploadCashbookData(BuildContext mContext) async {
//     var casgBookdata = await CashBookResponseExpencesHelper()
//         .getEditedCashBookForExpenceUpload();
//     if (casgBookdata.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       casgBookdata.forEach((element) async {
//         if (element.name != null) {
//           var responce = await CashBookExpensesApi()
//               .cashBookExpnesesUploadUdate(
//               token!, element.responces!, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesCashbookExpences(responce);
//             if ((casgBookdata.indexOf(element)) ==
//                 (casgBookdata.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=16;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(
//                   content: Text(Global.returnTrLable(
//                       locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await CashBookExpensesApi()
//               .cashBookExpensesUpload(token!, element.responces!);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesCashbookExpences(responce);
//             if ((casgBookdata.indexOf(element)) ==
//                 (casgBookdata.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=16;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(
//                   content: Text(Global.returnTrLable(
//                       locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=16;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesCashbookExpences(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await CashBookResponseExpencesHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadCashbookReceiptData(BuildContext mContext) async {
//     var cashbookReceiptData =
//     await CashBookReceiptResponseHelper().getEditedCashBookReceiptForUpload();
//     if (cashbookReceiptData.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       cashbookReceiptData.forEach((element) async {
//         // Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//         // jsonBody['status'] = '1';
//         // var itemResponce = jsonEncode(jsonBody);
//         if (element.name != null) {
//           var responce = await CashBookReceiptApi().cashBookReceiptUploadUdate(
//               token!, element.responces!, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesCashbookReceipt(responce);
//             if ((cashbookReceiptData.indexOf(element)) ==
//                 (cashbookReceiptData.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=17;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(
//                   content: Text(Global.returnTrLable(
//                       locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await CashBookReceiptApi()
//               .cashBookReceiptUpload(token!, element.responces!);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesCashbookReceipt(responce);
//             if ((cashbookReceiptData.indexOf(element)) ==
//                 (cashbookReceiptData.length - 1)) {
//               Navigator.pop(mContext);
//               if(selectAllOpt==1){
//                 currentUploadStatus=17;
//                 await methods[currentUploadStatus](context);
//               }else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(locationControlls,
//                         CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(
//                   content: Text(Global.returnTrLable(
//                       locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if(selectAllOpt==1){
//         currentUploadStatus=17;
//         await methods[currentUploadStatus](context);
//       }else
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesCashbookReceipt(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await CashBookReceiptResponseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadcmcALMData(BuildContext mContext) async {
//     var cmcALMData = await CmcALMTabResponseHelper().getAlmForUpload();
//     if (cmcALMData.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       cmcALMData.forEach((element) async {
//         if (element.name != null) {
//           var responce = await CrecheMonetringCheckListALMApi()
//               .cmcALMUploadUdate(token!, element.responces!, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponsescmcALMData(responce);
//             if ((cmcALMData.indexOf(element)) ==
//                 (cmcALMData.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(
//                   content: Text(Global.returnTrLable(
//                       locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await CrecheMonetringCheckListALMApi()
//               .cmcALMUpload(token!, element.responces!);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponsescmcALMData(responce);
//             if ((cmcALMData.indexOf(element)) ==
//                 (cmcALMData.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(
//                   content: Text(Global.returnTrLable(
//                       locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponsescmcALMData(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await CmcALMTabResponseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<void> uploadcmcCBMData(BuildContext mContext) async {
//     var cmcCBMData = await CmcCBMTabResponseHelper().getCBMForUpload();
//     if (cmcCBMData.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       cmcCBMData.forEach((element) async {
//         if (element.name != null) {
//           var responce = await CrecheMonetringCheckListCBMApi()
//               .cmcCBMUploadUdate(token!, element.responces!, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponsescmcCBMData(responce);
//             if ((cmcCBMData.indexOf(element)) ==
//                 (cmcCBMData.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(
//                   content: Text(Global.returnTrLable(
//                       locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await CrecheMonetringCheckListCBMApi()
//               .cmcCBMUpload(token!, element.responces!);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponsescmcCBMData(responce);
//             if ((cmcCBMData.indexOf(element)) ==
//                 (cmcCBMData.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(
//                   content: Text(Global.returnTrLable(
//                       locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponsescmcCBMData(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await CmcCBMTabResponseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//
//   Future<void> uploadcmcCCData(BuildContext mContext) async {
//     var cmcCCData = await CmcCCTabResponseHelper().getCcForUpload();
//     if (cmcCCData.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       cmcCCData.forEach((element) async {
//         // Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//         // jsonBody['status'] = '1';
//         // var itemResponce = jsonEncode(jsonBody);
//         if (element.name != null) {
//           var responce = await CrecheMonetringCheckListCCApi()
//               .cmcCCUploadUdate(token!, element.responces!, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponsescmcCCData(responce);
//             if ((cmcCCData.indexOf(element)) ==
//                 (cmcCCData.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(
//                   content: Text(Global.returnTrLable(
//                       locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await CrecheMonetringCheckListCCApi()
//               .cmcCCUpload(token!, element.responces!);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponsescmcCCData(responce);
//             if ((cmcCCData.indexOf(element)) ==
//                 (cmcCCData.length - 1)) {
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(
//                   content: Text(Global.returnTrLable(
//                       locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponsescmcCCData(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await CmcCCTabResponseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//
//   String checkAllForUpload(String key) {
//     String screenImage = 'assets/tranceparent_ic.png';
//     var item = syncInfoCount[key];
//     if (item != null) {
//       if (item > 0) {
//         screenImage = 'assets/check_ic_up.png';
//       }
//     }
//     return screenImage;
//   }
//
//   Future callAllUploade(BuildContext mContext) async {
//     List<Future> item = [];
//
//     final hhDataRe = uploadData(mContext);
//     item.add(hhDataRe);
//     final childProfileRe = uploadChildProfile(mContext);
//     item.add(childProfileRe);
//     final checheRe = uploadCreCheProfile(mContext);
//     item.add(checheRe);
//     final attendeRe = uploadAttendance(mContext);
//     item.add(attendeRe);
//     final checkInRe = uploadCheckInData(mContext);
//     item.add(checkInRe);
//     final growthRe = uploadChildGrowthData(mContext);
//     item.add(growthRe);
//     final eventRe = uploadChildEventData(mContext);
//     item.add(eventRe);
//     final healthRe = uploadChildHealthData(mContext);
//     item.add(healthRe);
//     final immunization = uploadChildImmunizationData(mContext);
//     item.add(immunization);
//     final childExit = uploadChildExitData(mContext);
//     item.add(childExit);
//     final gravienceRe = uploadChildGrievanceData(mContext);
//     item.add(gravienceRe);
//     final crechMonitoringRe = uploadCrecheMonitorData(mContext);
//     item.add(crechMonitoringRe);
//     final childReferralRe = uploadChildReferralData(mContext);
//     item.add(childReferralRe);
//     final childFollowUpRe = uploadChildFollowUpData(mContext);
//     item.add(childFollowUpRe);
//     final crecheCommiteRe = uploadCrecheCommittieData(mContext);
//     item.add(crecheCommiteRe);
//     final results = await Future.wait(item);
//     if (results.every((response) => response.statusCode == 200)) {
//       return results.map((response) => json.decode(response.body)).toList();
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//
//   List<TextSpan> parseBoldText(String text, TextStyle normalStyle,
//       TextStyle boldStyle) {
//     final RegExp boldTagRegExp = RegExp(r'\[b\](.*?)\[/b\]');
//     final List<TextSpan> spans = [];
//     int start = 0;
//
//     text.splitMapJoin(
//       boldTagRegExp,
//       onMatch: (Match match) {
//         if (match.start > start) {
//           spans.add(TextSpan(
//               text: text.substring(start, match.start), style: normalStyle));
//         }
//         spans.add(TextSpan(text: match.group(1), style: boldStyle));
//         start = match.end;
//         return '';
//       },
//       onNonMatch: (String nonMatch) {
//         spans.add(TextSpan(text: nonMatch, style: normalStyle));
//         return '';
//       },
//     );
//
//     return spans;
//   }
//
//   Future<void> uploadDataSequence1(BuildContext mContext,
//       int methodeIndex) async {
//     var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
//     hhItems = hhItems
//         .where((element) =>
//     Global.stringToInt(Global.getItemValues(element.responces!,
//         'verification_status')) > 1)
//         .toList();
//     if (hhItems.length > 0) {
//       showLoaderDialog(context);
//       hhItems.forEach((element) async {
//         var cItems = await HouseHoldChildrenHelperHelper()
//             .getResponceHouseHoldChildren(element
//             .HHGUID!); //"{"name":684,"parent":413,"hhguid":"q9bYVpayHGNzNwlQbnCdlOzQ1714538085360","hhcguid":"BWJpZLlBtZO3B7v1K2tcc6QG1714538201579","app…"
//         Map<String, dynamic> resultMap =
//         jsonDecode(element.responces!); // Map format of the above
//         List<dynamic> childrensList = [];
//
//         for (var cItem in cItems) {
//           childrensList
//               .add(jsonDecode(cItem)); //Added to the List in JSON format
//         }
//         if (element.name == null) {
//           if (childrensList.length > 0) {
//             resultMap['children'] = childrensList;
//           }
//         }
//         // if(resultMap['verification_status']!='4') {
//         //   resultMap['verification_status'] = "3";
//         // }
//
//         var token = await Validate().readString(Validate.appToken);
//         if (element.name != null) {
//           var responce = await HHDataUploadApi().uploadHHDataUpdate(
//               token!, element.name!, resultMap, childrensList);
//           if (responce.statusCode == 200) {
//             print('Upload: $responce');
//             await updateResponces(responce);
//             if ((hhItems.indexOf(element)) == (hhItems.length - 1)) {
//               Navigator.pop(mContext);
//               uploadChildProfileSequence2(mContext, methodeIndex);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             return;
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce =
//           await HHDataUploadApi().uploadHHData(token!, resultMap);
//           if (responce.statusCode == 200) {
//             await updateResponces(responce);
//             if ((hhItems.indexOf(element)) == (hhItems.length - 1)) {
//               Navigator.pop(mContext);
//               uploadChildProfileSequence2(mContext, methodeIndex);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       // Navigator.pop(mContext);
//       uploadChildProfileSequence2(mContext, methodeIndex);
//     }
//   }
//
//   Future<void> uploadChildProfileSequence2(BuildContext mContext,
//       int methodeIndex) async {
//     var chilProfiles = await EnrolledChilrenResponceHelper()
//         .callChildrenForUpload();
//     if (chilProfiles.length > 0) {
//       showLoaderDialog(context);
//       chilProfiles.forEach((element) async {
//         var token = await Validate().readString(Validate.appToken);
//         Map<String, dynamic> resultMap = jsonDecode(element.responces!);
//         resultMap['status'] = '1';
//         var itemResponce = jsonEncode(resultMap);
//         if (element.name != null) {
//           var responce = await EnrolledChildProfileUploadApi()
//               .enrolledChildProfileUploadUpdate(
//               token!, itemResponce, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildProfile(responce);
//             if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
//               Navigator.pop(mContext);
//               uploadChildExitDataSequence3(mContext, methodeIndex);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(locationControlls,
//             //         CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false, context);
//
//             return;
//           }
//         }
//         else {
//           var responce =
//           await EnrolledChildProfileUploadApi().enrolledChildProfileUpload(
//               token!, itemResponce);
//           if (responce.statusCode == 200) {
//             await updateResponcesChildProfile(responce);
//             if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
//               Navigator.pop(mContext);
//               uploadChildExitDataSequence3(mContext, methodeIndex);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(locationControlls,
//             //         CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false, context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       uploadChildExitDataSequence3(mContext, methodeIndex);
//     }
//   }
//
//   Future<void> uploadChildExitDataSequence3(BuildContext mContext,
//       int methodeIndex) async {
//     var childexitdata =
//     await ChildExitResponceHelper().getEditedChildExitForUpload();
//     if (childexitdata.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       childexitdata.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//
//         if (element.name != null) {
//           var responce = await ChildExitUploadApi().childExitUploadUpdate(
//               token!, jsonEncode(jsonBody), element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildExit(responce);
//             if ((childexitdata.indexOf(element)) ==
//                 (childexitdata.length - 1)) {
//               Navigator.pop(mContext);
//               uploadChildGrowthDataSeq1(mContext,methodeIndex);
//               // if (methodeIndex > 1 && (methodeIndex != 7)) {
//               //   await methods[methodeIndex](context);
//               // } else
//               //   Validate().singleButtonPopup(
//               //       Global.returnTrLable(
//               //           locationControlls, CustomText.data_upload_success_msg,
//               //           lng!),
//               //       Global.returnTrLable(
//               //           locationControlls, CustomText.ok, lng!),
//               //       false,
//               //       mContext);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildExitUploadApi()
//               .childExitUpload(token!, jsonEncode(jsonBody));
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildExit(responce);
//             if ((childexitdata.indexOf(element)) ==
//                 (childexitdata.length - 1)) {
//               Navigator.pop(mContext);
//               uploadChildGrowthDataSeq1(mContext,methodeIndex);
//               // if (methodeIndex > 1 && (methodeIndex != 7)) {
//               //   await methods[methodeIndex](context);
//               // } else
//               //   Validate().singleButtonPopup(
//               //       Global.returnTrLable(
//               //           locationControlls, CustomText.data_upload_success_msg,
//               //           lng!),
//               //       Global.returnTrLable(
//               //           locationControlls, CustomText.ok, lng!),
//               //       false,
//               //       mContext);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       uploadChildGrowthDataSeq1(mContext,methodeIndex);
//       // if (methodeIndex > 1 && (methodeIndex != 7)) {
//       //   await methods[methodeIndex](context);
//       // } else
//       //   Validate().singleButtonPopup(
//       //       Global.returnTrLable(
//       //           locationControlls, CustomText.data_upload_success_msg, lng!),
//       //       Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//       //       false,
//       //       mContext);
//     }
//   }
//
//   ///Child Growth Monitoring With Referral and follow up
//   Future<void> uploadChildGrowthDataSeq1(BuildContext mContext,int methodeIndex) async {
//     var anthropomertydata =
//     await ChildGrowthResponseHelper().callChildGrowthResponses();
//     if (anthropomertydata.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       anthropomertydata.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//
//         if (element.name != null) {
//           var responce = await ChildGrowthMetaUploadApi()
//               .childGrowthMetaUploadUpdate(
//               token!, jsonEncode(jsonBody), element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildGrowth(responce, element.responces!);
//             if ((anthropomertydata.indexOf(element)) ==
//                 (anthropomertydata.length - 1)) {
//               Navigator.pop(mContext);
//               uploadChildReferralDataSeq2(mContext, methodeIndex);
//             }
//           }
//           else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildGrowthMetaUploadApi()
//               .childGrowthMetaUpload(token!, jsonEncode(jsonBody));
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildGrowth(responce, element.responces!);
//             if ((anthropomertydata.indexOf(element)) ==
//                 (anthropomertydata.length - 1)) {
//               Navigator.pop(mContext);
//               uploadChildReferralDataSeq2(mContext, methodeIndex);
//             }
//           }
//           else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       uploadChildReferralDataSeq2(mContext, methodeIndex);
//     }
//   }
//
//   Future<void> uploadChildReferralDataSeq2(BuildContext mContext,int methodeIndex) async {
//     var referralData =
//     await ChildReferralTabResponseHelper().getChildReferralForUpload();
//     if (referralData.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       referralData.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//         jsonBody['status'] = '1';
//         var itemResponce = jsonEncode(jsonBody);
//         if (element.name != null) {
//           var responce = await ChildReferralUploadApi()
//               .childReferralUploadUpdate(token!, itemResponce, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildReferral(responce);
//             if ((referralData.indexOf(element)) ==
//                 (referralData.length - 1)) {
//               Navigator.pop(mContext);
//               uploadChildFollowUpDataSeq3(mContext,methodeIndex);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildReferralUploadApi()
//               .childReferralUpload(token!, itemResponce);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildReferral(responce);
//             if ((referralData.indexOf(element)) ==
//                 (referralData.length - 1)) {
//               Navigator.pop(mContext);
//               uploadChildFollowUpDataSeq3(mContext,methodeIndex);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       uploadChildFollowUpDataSeq3(mContext,methodeIndex);
//     }
//   }
//
//   Future<void> uploadChildFollowUpDataSeq3(BuildContext mContext,int methodeIndex) async {
//     var followUpData =
//     await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
//     if (followUpData.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       followUpData.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//         jsonBody['status'] = '1';
//         var itemResponce = jsonEncode(jsonBody);
//         if (element.name != null) {
//           var responce = await ChildFollowUpUploadApi()
//               .childFollowUpUploadUpdate(token!, itemResponce, element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildFollowUp(responce);
//             if ((followUpData.indexOf(element)) ==
//                 (followUpData.length - 1)) {
//               if (methodeIndex > 5) {
//                 await methods[methodeIndex](context);
//               } else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(
//                         locationControlls, CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     mContext);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await ChildFollowUpUploadApi()
//               .childFollowUpUpload(token!, itemResponce);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesChildFollowUp(responce);
//             if ((followUpData.indexOf(element)) ==
//                 (followUpData.length - 1)) {
//               Navigator.pop(mContext);
//               if (methodeIndex > 5 ) {
//                 await methods[methodeIndex](context);
//               } else
//                 Validate().singleButtonPopup(
//                     Global.returnTrLable(
//                         locationControlls, CustomText.data_upload_success_msg, lng!),
//                     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                     false,
//                     mContext);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//             // Validate().singleButtonPopup(
//             //     Global.returnTrLable(
//             //         locationControlls, CustomText.token_expired, lng!),
//             //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             //     false,
//             //     context);
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       if (methodeIndex > 5) {
//         await methods[methodeIndex](context);
//       } else
//         Validate().singleButtonPopup(
//             Global.returnTrLable(
//                 locationControlls, CustomText.data_upload_success_msg, lng!),
//             Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//             false,
//             mContext);
//     }
//   }
//
//
//
//   Future<void> uploadVillageProfile(BuildContext mContext) async {
//     var villageProfileData =
//     await VillageProfileResponseHelper().getVillageProfileforUpload();
//     if (villageProfileData.length > 0) {
//       showLoaderDialog(mContext);
//       var token = await Validate().readString(Validate.appToken);
//       villageProfileData.forEach((element) async {
//         Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
//
//         if (element.name != null) {
//           var responce = await VillageProfileMetaApi().callVillageUploadUdate(
//               token!, jsonEncode(jsonBody), element.name);
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesVillageProfile(responce);
//
//             if ((villageProfileData.indexOf(element)) ==
//                 (villageProfileData.length - 1)) {
//               Navigator.pop(mContext);
//               selectAllOpt = 0;
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           } else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           } else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         } else {
//           var responce = await VillageProfileMetaApi()
//               .villageProfileUpload(token!, jsonEncode(jsonBody));
//           if (responce.statusCode == 200) {
//             Validate().saveString(
//                 Validate.dataUploadDateTime, Validate().currentDateTime());
//             await updateResponcesVillageProfile(responce);
//             if ((villageProfileData.indexOf(element)) ==
//                 (villageProfileData.length - 1)) {
//               selectAllOpt = 0;
//               Navigator.pop(mContext);
//               Validate().singleButtonPopup(
//                   Global.returnTrLable(locationControlls,
//                       CustomText.data_upload_success_msg, lng!),
//                   Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                   false,
//                   context);
//             }
//           }
//           else if (responce.statusCode == 401) {
//             Navigator.pop(mContext);
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.remove(Validate.Password);
//             ScaffoldMessenger.of(mContext).showSnackBar(
//               SnackBar(content:
//               Text(Global.returnTrLable(
//                   locationControlls, CustomText.token_expired, lng!))),
//             );
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (mContext) => LoginScreen(),
//                 ));
//           }
//           else {
//             Navigator.pop(mContext);
//             await callUploadData();
//             Validate().singleButtonPopup(
//                 Global.errorBodyToStringFromList(responce.body),
//                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//                 false,
//                 context);
//
//             return;
//           }
//         }
//       });
//     } else {
//       selectAllOpt = 0;
//       Validate().singleButtonPopup(
//           Global.returnTrLable(
//               locationControlls, CustomText.nothing_for_upload_msg, lng!),
//           Global.returnTrLable(locationControlls, CustomText.ok, lng!),
//           false,
//           mContext);
//     }
//   }
//
//   Future<void> updateResponcesVillageProfile(Response value) async {
//     try {
//       Map<String, dynamic> resultMap = jsonDecode(value.body);
//       print(" responce $resultMap");
//       await VillageProfileResponseHelper().updateUploadedItem(resultMap);
//       await callUploadData();
//     } catch (e) {
//       print("exp ${e.toString()}");
//     }
//   }
//
//   Future<int> callCountForUpload() async {
//     showLoaderDialog(context);
//     var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
//     var chilProfiles =
//     await EnrolledChilrenResponceHelper().callChildrenForUpload();
//     var crecheProfile = await CrecheDataHelper().callCrecheForUpload();
//     var chilAttendence =
//     await ChildAttendanceResponceHelper().callChildAttendencesAllForUpoad();
//     var crecheCheckIn = await CheckInHelper().callCrecheCheckInResponses();
//     var anthropomentry =
//     await ChildGrowthResponseHelper().callChildGrowthResponsesForUpload();
//     var childeventResponses =
//     await ChildEventTabResponceHelper().getEditedChildEventsForUpload();
//     var childImmunizationDAta =
//     await ChildImmunizationResponseHelper().getChildImmunizationForUpload();
//     var childHeathData =
//     await ChildHealthTabResponceHelper().getChildHealthForUpload();
//     var childexitdata =
//     await ChildExitResponceHelper().getEditedChildExitForUpload();
//     var grievanceData =
//     await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
//     var creCheMonitoring =
//     await CrecheMonitorResponseHelper().getCrecheResponseForUpload();
//     var referralData =
//     await ChildReferralTabResponseHelper().getChildReferralForUpload();
//     var followUpData =
//     await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
//     var ccmData =
//     await CrecheCommittieResponnseHelper().getCrecheCommittieForUpload();
//     var cashBookDataExpences = await CashBookResponseExpencesHelper()
//         .getEditedCashBookForExpenceUpload();
//
//     var cashBookDataReciept = await CashBookReceiptResponseHelper()
//         .getEditedCashBookReceiptForUpload();
//
//     var villageProfiles = await VillageProfileResponseHelper().getVillageProfileforUpload();
//
//     hhItems = hhItems
//         .where((element) =>
//     Global.stringToInt(Global.getItemValues(
//         element.responces!, 'verification_status')) >
//         1)
//         .toList();
//
//     Navigator.pop(context);
//     int totalPendingCount = hhItems.length +
//         chilProfiles.length +
//         crecheProfile.length +
//         chilAttendence.length +
//         crecheCheckIn.length +
//         anthropomentry.length +
//         childeventResponses.length +
//         childImmunizationDAta.length +
//         childHeathData.length +
//         childexitdata.length +
//         grievanceData.length +
//         creCheMonitoring.length +
//         referralData.length +
//         followUpData.length +
//         ccmData.length +
//         cashBookDataExpences.length +
//         villageProfiles.length +
//         cashBookDataReciept.length;
//
//     return totalPendingCount;
//   }
// }
