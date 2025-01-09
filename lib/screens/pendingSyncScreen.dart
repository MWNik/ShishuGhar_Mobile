import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/api/child_enrolled_exit_api.dart';
import 'package:shishughar/api/requisition_api.dart';
import 'package:shishughar/api/stock_api.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:http/src/response.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
import 'package:shishughar/database/helper/stock/stock_response_helper.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import '../api/cashBook_expenses_api.dart';
import '../api/cashbook_receipt_api.dart';
import '../api/child_attendance_upload_api.dart';
import '../api/child_event_upload_api.dart';
import '../api/child_exit_upload_api.dart';
import '../api/child_followUp_upload_appi.dart';
import '../api/child_grievance_upload_api.dart';
import '../api/child_growth_meta_upload_api.dart';
import '../api/child_health_upload_api.dart';
import '../api/child_immunizatiion_upload_api.dart';
import '../api/child_profile_data_upload_api.dart';
import '../api/child_referral_upload_api.dart';
import '../api/creche_Monitering_checkList_ALM_api.dart';
import '../api/creche_checkIn_api.dart';
import '../api/creche_commettie_upload_api.dart';
import '../api/creche_monetering_checkList_cbm_api.dart';
import '../api/creche_monitering_checklist_cc_api.dart';
import '../api/creche_monitoring_api.dart';
import '../api/creche_profile_data_upload_api.dart';
import '../api/hh_data_upload_api.dart';
import '../api/image_file_api.dart';
import '../api/village_profile_meta_api.dart';
import '../custom_widget/custom_btn.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_custom_checkbox.dart';
import '../database/helper/anthromentory/child_growth_response_helper.dart';
import '../database/helper/cashbook/expences/cashbook_response_expences_helper.dart';
import '../database/helper/cashbook/receipt/cashbook_receipt_response_helper.dart';
import '../database/helper/check_in/check_in_response_helper.dart';
import '../database/helper/child_attendence/child_attendance_helper_responce.dart';
import '../database/helper/child_attendence/child_attendence_helper.dart';
import '../database/helper/child_event/child_event_response_helper.dart';
import '../database/helper/child_exit/child_exit_response_Helper.dart';
import '../database/helper/child_gravience/child_grievances_response_helper.dart';
import '../database/helper/child_health/child_health_response_helper.dart';
import '../database/helper/child_immunization/child_immunization_response_helper.dart';
import '../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../database/helper/cmc_CC/creche_monitering_checklist_CC_response_helper.dart';
import '../database/helper/cmc_alm/creche_monitering_checkList_ALM_response_helper.dart';
import '../database/helper/cmc_cbm/creche_monitering_checklist_CBM_response_helper.dart';
import '../database/helper/creche_comite_meeting/creche_committie_response_helper.dart';
import '../database/helper/creche_helper/creche_care_giver_helper.dart';
import '../database/helper/creche_helper/creche_data_helper.dart';
import '../database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
import '../database/helper/dynamic_screen_helper/house_hold_children_helper.dart';
import '../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import '../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../database/helper/follow_up/child_followUp_response_helper.dart';
import '../database/helper/image_file_tab_responce_helper.dart';
import '../database/helper/translation_language_helper.dart';
import '../database/helper/village_profile/village_profile_response_helper.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../utils/validate.dart';
import 'login_screen.dart';

class PendingSyncScreen extends StatefulWidget {
  const PendingSyncScreen({super.key});

  @override
  State<PendingSyncScreen> createState() => _PendingSyncScreenState();
}

class _PendingSyncScreenState extends State<PendingSyncScreen> {
  TextEditingController Searchcontroller = TextEditingController();
  Map<String, String> syncInfo = {};
  Map<String, int> syncInfoCount = {};
  String sysHeader = '';
  String? userRole;
  String? lng;
  int selectAllOpt = 0;
  int syncCount = 0;
  bool _isLoading = true;
  int currentUploadStatus = 0;
  List<Translation> locationControlls = [];
  List<Future<void> Function(BuildContext)> methods = [];
  List<Future<void> Function(BuildContext)> UploadAll = [];
  String loadingText = "";
  String loadingTextUpdatedText = "";
  String loadingTextUpdatedCount = "";
  late StateSetter dialogSetState;
  bool isUnsynched = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, 'itemRefresh');
          return true;
        },
        child: Scaffold(
          appBar: CustomAppbar(
            text: (lng != null)
                ? Global.returnTrLable(locationControlls, CustomText.sync, lng!)
                : "",
            onTap: () {
              Navigator.pop(context, 'itemRefresh');
            },
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    syncCount > 0
                        ? Flexible(
                            child: DynamicCustomCheckboxWithLabel(
                              label: Global.returnTrLable(locationControlls,
                                  CustomText.selectAllForUpload, lng!),
                              initialValue: selectAllOpt,
                              onChanged: (value) {
                                setState(() {
                                  selectAllOpt = value;
                                });
                              },
                            ),
                          )
                        : SizedBox(
                            width: 20,
                          ),
                    // Spacer(),
                    Flexible(
                      flex: syncCount > 0 ? 1 : 2,
                      child: AnimatedRollingSwitch(
                        isOnlyUnsynched: isUnsynched,
                        title1: Global.returnTrLable(
                            locationControlls, CustomText.all, lng!),
                        title2: Global.returnTrLable(
                            locationControlls, CustomText.unsynched, lng!),
                        onChange: (value) async {
                          setState(() {
                            isUnsynched = value;
                          });
                          await callUploadData();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: syncInfo.keys.toList().length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return isUnsynched
                            ? (unsyncCount(
                                      syncInfo[syncInfo.keys.toList()[index]] ??
                                          '',
                                    ) >
                                    0
                                ? GestureDetector(
                                    onTap: () async {
                                      var checkInte = await Validate()
                                          .checkNetworkConnection();
                                      if (checkInte) {
                                        if (userRole == 'Creche Supervisor') {
                                          if (selectAllOpt == 0) {
                                            if (index > 0 && index < 9)
                                              await uploadDataSequence1(
                                                  context, index);
                                            else
                                              await methods[index](context);
                                          }
                                        } else {
                                          await methods[index](context);
                                        }
                                      } else
                                        Validate().singleButtonPopup(
                                            Global.returnTrLable(
                                                locationControlls,
                                                CustomText
                                                    .nointernetconnectionavailable,
                                                lng!),
                                            Global.returnTrLable(
                                                locationControlls,
                                                CustomText.ok,
                                                lng!),
                                            true,
                                            context);
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.h),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xff5A5A5A)
                                                    .withOpacity(
                                                        0.2), // Shadow color with opacity
                                                offset: Offset(0,
                                                    3), // Horizontal and vertical offset
                                                blurRadius: 6, // Blur radius
                                                spreadRadius:
                                                    0, // Spread radius
                                              ),
                                            ],
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Color(0xffE7F0FF)),
                                            borderRadius:
                                                BorderRadius.circular(10.r)),
                                        height: 42.h,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 8.h),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  // Content (RichText)
                                                  Expanded(
                                                    child: RichText(
                                                      strutStyle: StrutStyle(
                                                          height: 1.h),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                        text:
                                                            "${syncInfo.keys.toList()[index]} : ",
                                                        style: Styles
                                                            .urbanblack157,
                                                        children: parseBoldText(
                                                            syncInfo[syncInfo
                                                                        .keys
                                                                        .toList()[
                                                                    index]] ??
                                                                '',
                                                            Styles.blue125,
                                                            Styles.black144.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            Styles.red185.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ),
                                                  ),
                                                  selectAllOpt == 1
                                                      ? Image.asset(
                                                          checkAllForUpload(
                                                              syncInfo
                                                                      .keys
                                                                      .toList()[
                                                                  index]),
                                                          scale: 4.4,
                                                          color: Colors.grey,
                                                        )
                                                      : Image.asset(
                                                          "assets/sync_icon.png",
                                                          scale: 4.4,
                                                          color: Colors.grey,
                                                        ),
                                                ],
                                              ),
                                              // Image to the right
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox())
                            : GestureDetector(
                                onTap: () async {
                                  var checkInte =
                                      await Validate().checkNetworkConnection();
                                  if (checkInte) {
                                    if (userRole == 'Creche Supervisor') {
                                      if (selectAllOpt == 0) {
                                        if (index > 0 && index < 9)
                                          await uploadDataSequence1(
                                              context, index);
                                        else
                                          await methods[index](context);
                                      }
                                    } else {
                                      await methods[index](context);
                                    }
                                  } else
                                    Validate().singleButtonPopup(
                                        Global.returnTrLable(
                                            locationControlls,
                                            CustomText
                                                .nointernetconnectionavailable,
                                            lng!),
                                        Global.returnTrLable(locationControlls,
                                            CustomText.ok, lng!),
                                        true,
                                        context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xff5A5A5A).withOpacity(
                                                0.2), // Shadow color with opacity
                                            offset: Offset(0,
                                                3), // Horizontal and vertical offset
                                            blurRadius: 6, // Blur radius
                                            spreadRadius: 0, // Spread radius
                                          ),
                                        ],
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Color(0xffE7F0FF)),
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    height: 42.h,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 8.h),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              // Content (RichText)
                                              Expanded(
                                                child: RichText(
                                                  strutStyle:
                                                      StrutStyle(height: 1.h),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text:
                                                        "${syncInfo.keys.toList()[index]} : ",
                                                    style: Styles.urbanblack157,
                                                    children: parseBoldText(
                                                        syncInfo[syncInfo.keys
                                                                    .toList()[
                                                                index]] ??
                                                            '',
                                                        Styles.blue125,
                                                        Styles.black144
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        Styles.red185.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                              ),
                                              selectAllOpt == 1
                                                  ? Image.asset(
                                                      checkAllForUpload(syncInfo
                                                          .keys
                                                          .toList()[index]),
                                                      scale: 4.4,
                                                      color: Colors.grey,
                                                    )
                                                  : Image.asset(
                                                      "assets/sync_icon.png",
                                                      scale: 4.4,
                                                      color: Colors.grey,
                                                    ),
                                            ],
                                          ),
                                          // Image to the right
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      }),
                ),
                SizedBox(
                  height: 10.h,
                ),
                syncCount > 0
                    ? selectAllOpt == 1
                        ? CElevatedButton(
                            text: Global.returnTrLable(locationControlls, CustomText.uploadAll , lng!),
                            color: Color(0xff369A8D),
                            onPressed: () async {
                              var checkInte =
                                  await Validate().checkNetworkConnection();
                              if (checkInte) {
                                await uploadDataSequence1(context, 5);
                              } else
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(
                                        locationControlls,
                                        CustomText
                                            .nointernetconnectionavailable,
                                        lng!),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lng!),
                                    true,
                                    context);
                            },
                          )
                        : SizedBox()
                    : SizedBox()
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  callUploadData() async {
    sysHeader = '';

    if (userRole == 'Creche Supervisor') {
      var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
      syncCount = await callCountForUpload();
      //    syncCount = 1;
      hhItems = hhItems
          .where((element) =>
              Global.stringToInt(Global.getItemValues(
                  element.responces!, 'verification_status')) >
              1)
          .toList();

      if (hhItems.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.HHListing, lng!)] =
            '[b]${hhItems.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.HHListing, lng!)] =
            '[b]${hhItems.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.HHListing, lng!)] = hhItems.length;

      // var chilProfiles =
      // await EnrolledChilrenResponceHelper().callChildrenForUpload();

      // ///Child profile
      // if (chilProfiles.length > 1) {
      //   syncInfo[Global.returnTrLable(
      //       locationControlls, CustomText.ChildProfile, lng!)] =
      //   '[b]${chilProfiles.length}[/b] ${Global.returnTrLable(
      //       locationControlls, CustomText.recordsAvailable, lng!)}';
      // }
      // else {
      //   syncInfo[Global.returnTrLable(
      //       locationControlls, CustomText.ChildProfile, lng!)] =
      //   '[b]${chilProfiles.length}[/b]  ${Global.returnTrLable(
      //       locationControlls, CustomText.recordAvailable, lng!)}';
      // }
      // syncInfoCount[Global.returnTrLable(
      //     locationControlls, CustomText.ChildProfile, lng!)] =
      //     chilProfiles.length;
      var childEnrollExitData =
          await EnrolledExitChilrenResponceHelper().callChildrenForUpload();
      if (childEnrollExitData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.enrollExitChild, lng!)] =
            '[b]${childEnrollExitData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.enrollExitChild, lng!)] =
            '[b]${childEnrollExitData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.enrollExitChild, lng!)] =
          childEnrollExitData.length;

      // var childexitdata =
      //     await ChildExitResponceHelper().getEditedChildExitForUpload();
      // if (childexitdata.length > 1) {
      //   syncInfo[Global.returnTrLable(
      //           locationControlls, CustomText.ChildExit, lng!)] =
      //       '[b]${childexitdata.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      // } else {
      //   syncInfo[Global.returnTrLable(
      //           locationControlls, CustomText.ChildExit, lng!)] =
      //       '[b]${childexitdata.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      // }
      // syncInfoCount[Global.returnTrLable(
      //         locationControlls, CustomText.ChildExit, lng!)] =
      //     childexitdata.length;

      var anthropomertydata =
          await ChildGrowthResponseHelper().callChildGrowthResponsesForUpload();
      if (anthropomertydata.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.GrowthMonitoring, lng!)] =
            '[b]${anthropomertydata.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.GrowthMonitoring, lng!)] =
            '[b]${anthropomertydata.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.GrowthMonitoring, lng!)] =
          anthropomertydata.length;

      var referralData =
          await ChildReferralTabResponseHelper().getChildReferralForUpload();
      if (referralData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.childReferral, lng!)] =
            '[b]${referralData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.childReferral, lng!)] =
            '[b]${referralData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.childReferral, lng!)] =
          referralData.length;

      var followUpData =
          await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
      if (followUpData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.fllowUp, lng!)] =
            '[b]${followUpData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.fllowUp, lng!)] =
            '[b]${followUpData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.fllowUp, lng!)] = followUpData.length;

      var chilAttendence = await ChildAttendanceResponceHelper()
          .callChildAttendencesAllForUpoad();
      if (chilAttendence.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.childAttendence, lng!)] =
            '[b]${chilAttendence.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.childAttendence, lng!)] =
            '[b]${chilAttendence.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.childAttendence, lng!)] =
          chilAttendence.length;

      var childeventResponses =
          await ChildEventTabResponceHelper().getEditedChildEventsForUpload();
      if (childeventResponses.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildEvents, lng!)] =
            '[b]${childeventResponses.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildEvents, lng!)] =
            '[b]${childeventResponses.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.ChildEvents, lng!)] =
          childeventResponses.length;

      var childHeathData =
          await ChildHealthTabResponceHelper().getChildHealthForUpload();
      if (childeventResponses.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildHealth, lng!)] =
            '[b]${childHeathData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildHealth, lng!)] =
            '[b]${childHeathData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.ChildHealth, lng!)] =
          childHeathData.length;

      var childImmunizationDAta = await ChildImmunizationResponseHelper()
          .getChildImmunizationForUpload();
      if (childeventResponses.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildImmunization, lng!)] =
            '[b]${childImmunizationDAta.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildImmunization, lng!)] =
            '[b]${childImmunizationDAta.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.ChildImmunization, lng!)] =
          childImmunizationDAta.length;

      ///Shishu ghar

      var creshePrfile = await CrecheDataHelper().callCrecheForUpload();
      if (creshePrfile.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.CrecheProfileView, lng!)] =
            '[b]${creshePrfile.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.CrecheProfileView, lng!)] =
            '[b]${creshePrfile.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.CrecheProfileView, lng!)] =
          creshePrfile.length;
      var checkins = await CheckInResponseHelper().callCrecheCheckInResponses();
      if (checkins.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.checkIns, lng!)] =
            '[b]${checkins.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.checkIns, lng!)] =
            '[b]${checkins.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.checkIns, lng!)] = checkins.length;

      var grievanceData =
          await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
      if (grievanceData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildGrievances, lng!)] =
            '[b]${grievanceData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildGrievances, lng!)] =
            '[b]${grievanceData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.ChildGrievances, lng!)] =
          grievanceData.length;

      var creCheMonitoring =
          await CrecheMonitorResponseHelper().getCrecheResponseForUpload();
      if (creCheMonitoring.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.VisitNotes, lng!)] =
            '[b]${creCheMonitoring.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.VisitNotes, lng!)] =
            '[b]${creCheMonitoring.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.VisitNotes, lng!)] =
          creCheMonitoring.length;

      var ccmData =
          await CrecheCommittieResponnseHelper().getCrecheCommittieForUpload();
      if (ccmData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.CrecheCommitte, lng!)] =
            '[b]${ccmData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.CrecheCommitte, lng!)] =
            '[b]${ccmData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.CrecheCommitte, lng!)] = ccmData.length;

      var cashBookDataExpences = await CashBookResponseExpencesHelper()
          .getEditedCashBookForExpenceUpload();
      if (cashBookDataExpences.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.CashBookExpences, lng!)] =
            '[b]${cashBookDataExpences.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.CashBookExpences, lng!)] =
            '[b]${cashBookDataExpences.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.CashBookExpences, lng!)] =
          cashBookDataExpences.length;

      var cashBookDataReciept = await CashBookReceiptResponseHelper()
          .getEditedCashBookReceiptForUpload();
      if (cashBookDataReciept.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.CashBookReceipt, lng!)] =
            '[b]${cashBookDataReciept.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.CashBookReceipt, lng!)] =
            '[b]${cashBookDataReciept.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.CashBookReceipt, lng!)] =
          cashBookDataReciept.length;

      var villageProfiles =
          await VillageProfileResponseHelper().getVillageProfileforUpload();
      if (villageProfiles.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.villageProfile, lng!)] =
            '[b]${villageProfiles.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.villageProfile, lng!)] =
            '[b]${villageProfiles.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.villageProfile, lng!)] =
          villageProfiles.length;

      var stockData = await StockResponseHelper().getStockForUpload();
      if (stockData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.Stock, lng!)] =
            '[b]${stockData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.Stock, lng!)] =
            '[b]${stockData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[
              Global.returnTrLable(locationControlls, CustomText.Stock, lng!)] =
          stockData.length;

      var requisitionData =
          await RequisitionResponseHelper().getRequisitonsForUpload();
      if (requisitionData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.requisition, lng!)] =
            '[b]${requisitionData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.requisition, lng!)] =
            '[b]${requisitionData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.requisition, lng!)] =
          requisitionData.length;

      var imageData = await ImageFileTabHelper().getImageForUpload();
      if (imageData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.imageFiles, lng!)] =
            '[b]${imageData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.imageFiles, lng!)] =
            '[b]${imageData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.imageFiles, lng!)] = imageData.length;
    }
    else if (userRole == 'Cluster Coordinator') {

      var cmcCCData = await CmcCCTabResponseHelper().getCcForUpload();
      if (cmcCCData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.VisitNotes, lng!)] =
            '[b]${cmcCCData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.VisitNotes, lng!)] =
            '[b]${cmcCCData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.VisitNotes, lng!)] = cmcCCData.length;

      var grievanceData =
          await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
      if (grievanceData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildGrievances, lng!)] =
            '[b]${grievanceData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildGrievances, lng!)] =
            '[b]${grievanceData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.ChildGrievances, lng!)] =
          grievanceData.length;

      var checkins = await CheckInResponseHelper().callCrecheCheckInResponses();
      if (checkins.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.checkIns, lng!)] =
            '[b]${checkins.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.checkIns, lng!)] =
            '[b]${checkins.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.checkIns, lng!)] = checkins.length;
      var imageData = await ImageFileTabHelper().getImageForUpload();
      if (imageData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.imageFiles, lng!)] =
            '[b]${imageData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.imageFiles, lng!)] =
            '[b]${imageData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.imageFiles, lng!)] = imageData.length;
    }
    else if (userRole == 'Accounts and Logistics Manager') {
      var cmcALMData = await CmcALMTabResponseHelper().getAlmForUpload();
      if (cmcALMData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.VisitNotes, lng!)] =
            '[b]${cmcALMData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.VisitNotes, lng!)] =
            '[b]${cmcALMData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.VisitNotes, lng!)] = cmcALMData.length;

      var grievanceData =
          await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
      if (grievanceData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildGrievances, lng!)] =
            '[b]${grievanceData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildGrievances, lng!)] =
            '[b]${grievanceData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.ChildGrievances, lng!)] =
          grievanceData.length;

      var checkins = await CheckInResponseHelper().callCrecheCheckInResponses();
      if (checkins.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.checkIns, lng!)] =
            '[b]${checkins.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.checkIns, lng!)] =
            '[b]${checkins.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.checkIns, lng!)] = checkins.length;
      var imageData = await ImageFileTabHelper().getImageForUpload();
      if (imageData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.imageFiles, lng!)] =
            '[b]${imageData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.imageFiles, lng!)] =
            '[b]${imageData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.imageFiles, lng!)] = imageData.length;
    }
    else if (userRole == 'Capacity and Building Manager') {
      var cmcCBMData = await CmcCBMTabResponseHelper().getCBMForUpload();
      if (cmcCBMData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.VisitNotes, lng!)] =
            '[b]${cmcCBMData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.VisitNotes, lng!)] =
            '[b]${cmcCBMData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.VisitNotes, lng!)] = cmcCBMData.length;

      var grievanceData =
          await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
      if (grievanceData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildGrievances, lng!)] =
            '[b]${grievanceData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildGrievances, lng!)] =
            '[b]${grievanceData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.ChildGrievances, lng!)] =
          grievanceData.length;

      var checkins = await CheckInResponseHelper().callCrecheCheckInResponses();
      if (checkins.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.checkIns, lng!)] =
            '[b]${checkins.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.checkIns, lng!)] =
            '[b]${checkins.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.checkIns, lng!)] = checkins.length;
      var imageData = await ImageFileTabHelper().getImageForUpload();
      if (imageData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.imageFiles, lng!)] =
            '[b]${imageData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.imageFiles, lng!)] =
            '[b]${imageData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }

      syncInfoCount[Global.returnTrLable(
          locationControlls, CustomText.imageFiles, lng!)] = imageData.length;
    }
    else {
      var grievanceData =
          await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
      if (grievanceData.length > 1) {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildGrievances, lng!)] =
            '[b]${grievanceData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordsAvailable, lng!)}';
      } else {
        syncInfo[Global.returnTrLable(
                locationControlls, CustomText.ChildGrievances, lng!)] =
            '[b]${grievanceData.length}[/b] ${Global.returnTrLable(locationControlls, CustomText.recordAvailable, lng!)}';
      }
      syncInfoCount[Global.returnTrLable(
              locationControlls, CustomText.ChildGrievances, lng!)] =
          grievanceData.length;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> uploadData(BuildContext mContext) async {
    var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
    hhItems = hhItems
        .where((element) =>
            Global.stringToInt(Global.getItemValues(
                element.responces!, 'verification_status')) >
            1)
        .toList();
    if (hhItems.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.HHListing, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${hhItems.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < hhItems.length; i++) {
        var element = hhItems[i];
        var cItems = await HouseHoldChildrenHelperHelper()
            .getResponceHouseHoldChildren(element
                .HHGUID!); //"{"name":684,"parent":413,"hhguid":"q9bYVpayHGNzNwlQbnCdlOzQ1714538085360","hhcguid":"BWJpZLlBtZO3B7v1K2tcc6QG1714538201579","app…"
        Map<String, dynamic> resultMap =
            jsonDecode(element.responces!); // Map format of the above
        List<dynamic> childrensList = [];

        for (var cItem in cItems) {
          childrensList
              .add(jsonDecode(cItem)); //Added to the List in JSON format
        }
        if (element.name == null) {
          if (childrensList.length > 0) {
            resultMap['children'] = childrensList;
          }
        }
        resultMap['verification_status'] = "3";

        if (element.name != null) {
          var responce = await HHDataUploadApi().uploadHHDataUpdate(
              token!, element.name!, resultMap, childrensList);
          if (responce.statusCode == 200) {
            print('Upload: $responce');
            await updateResponces(responce);
            if ((hhItems.indexOf(element)) == (hhItems.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${hhItems.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            return;
          } else {
            Navigator.pop(mContext);
            var msg = await TranslationDataHelper().getTranslation(
                Global.errorBodyToStringFromList(responce.body), lng!);
            await callUploadData();
            Validate().singleButtonPopup(
                msg,
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce =
              await HHDataUploadApi().uploadHHData(token!, resultMap);
          if (responce.statusCode == 200) {
            await updateResponces(responce);
            if ((hhItems.indexOf(element)) == (hhItems.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${hhItems.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            var msg = await TranslationDataHelper().getTranslation(
                Global.errorBodyToStringFromList(responce.body), lng!);
            await callUploadData();
            Validate().singleButtonPopup(
                msg,
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  // Future<void> uploadChildProfile(BuildContext mContext) async {
  //   var chilProfiles =
  //       await EnrolledChilrenResponceHelper().callChildrenForUpload();
  //   if (chilProfiles.length > 0) {
  //     showLoaderDialog(context);
  //     chilProfiles.forEach((element) async {
  //       var token = await Validate().readString(Validate.appToken);
  //       Map<String, dynamic> resultMap = jsonDecode(element.responces!);
  //       resultMap['status'] = '1';
  //       var itemResponce = jsonEncode(resultMap);
  //       if (element.name != null) {
  //         var responce = await EnrolledChildProfileUploadApi()
  //             .enrolledChildProfileUploadUpdate(
  //                 token!, itemResponce, element.name);
  //         if (responce.statusCode == 200) {
  //           Validate().saveString(
  //               Validate.dataUploadDateTime, Validate().currentDateTime());
  //           await updateResponcesChildProfile(responce);
  //           if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
  //             Navigator.pop(mContext);
  //             Validate().singleButtonPopup(
  //                 Global.returnTrLable(locationControlls,
  //                     CustomText.data_upload_success_msg, lng!),
  //                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
  //                 false,
  //                 context);
  //           }
  //         } else if (responce.statusCode == 401) {
  //           Navigator.pop(mContext);
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           await prefs.remove(Validate.Password);
  //           ScaffoldMessenger.of(mContext).showSnackBar(
  //             SnackBar(
  //                 content: Text(Global.returnTrLable(
  //                     locationControlls, CustomText.token_expired, lng!))),
  //           );
  //           Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (mContext) => LoginScreen(),
  //               ));
  //           // Validate().singleButtonPopup(
  //           //     Global.returnTrLable(locationControlls,
  //           //         CustomText.token_expired, lng!),
  //           //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
  //         } else {
  //           Navigator.pop(mContext);
  //           await callUploadData();
  //           Validate().singleButtonPopup(
  //               Global.errorBodyToStringFromList(responce.body),
  //               Global.returnTrLable(locationControlls, CustomText.ok, lng!),
  //               false,
  //               context);
  //
  //           return;
  //         }
  //       } else {
  //         var responce = await EnrolledChildProfileUploadApi()
  //             .enrolledChildProfileUpload(token!, itemResponce);
  //         if (responce.statusCode == 200) {
  //           await updateResponcesChildProfile(responce);
  //           if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
  //             Navigator.pop(mContext);
  //             Validate().singleButtonPopup(
  //                 Global.returnTrLable(locationControlls,
  //                     CustomText.data_upload_success_msg, lng!),
  //                 Global.returnTrLable(locationControlls, CustomText.ok, lng!),
  //                 false,
  //                 context);
  //           }
  //         } else if (responce.statusCode == 401) {
  //           Navigator.pop(mContext);
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           await prefs.remove(Validate.Password);
  //           ScaffoldMessenger.of(mContext).showSnackBar(
  //             SnackBar(
  //                 content: Text(Global.returnTrLable(
  //                     locationControlls, CustomText.token_expired, lng!))),
  //           );
  //           Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (mContext) => LoginScreen(),
  //               ));
  //           // Validate().singleButtonPopup(
  //           //     Global.returnTrLable(locationControlls,
  //           //         CustomText.token_expired, lng!),
  //           //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
  //         } else {
  //           Navigator.pop(mContext);
  //           await callUploadData();
  //           Validate().singleButtonPopup(
  //               Global.errorBodyToStringFromList(responce.body),
  //               Global.returnTrLable(locationControlls, CustomText.ok, lng!),
  //               false,
  //               context);
  //
  //           return;
  //         }
  //       }
  //     });
  //   } else {
  //     Validate().singleButtonPopup(
  //         Global.returnTrLable(
  //             locationControlls, CustomText.nothing_for_upload_msg, lng!),
  //         Global.returnTrLable(locationControlls, CustomText.ok, lng!),
  //         false,
  //         mContext);
  //   }
  // }

  Future<void> uploadCreCheProfile(BuildContext mContext) async {
    var crecheProfiles = await CrecheDataHelper().callCrecheForUpload();
    if (crecheProfiles.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.CrecheProfileView, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${crecheProfiles.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < crecheProfiles.length; i++) {
        var element = crecheProfiles[i];
        var cItems =
            await CrecheCareGiverHelper().callCareGiverUpload(element.name!);
        Map<String, dynamic> resultMap = jsonDecode(element.responces!);
        List<dynamic> childrensList = [];

        for (var cItem in cItems) {
          childrensList.add(jsonDecode(cItem.responces!));
        }
        if (childrensList.length > 0) {
          resultMap['creche_caregiver_table'] = childrensList;
        }

        if (element.name != null) {
          var responce =
              await CrecheDataResponceUploadApi().crecheCareGiverUploadUpdate(
            token!,
            jsonEncode(resultMap),
            element.name!,
          );
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateCreCheProFile(responce);
            if ((crecheProfiles.indexOf(element)) ==
                (crecheProfiles.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 10;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${crecheProfiles.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(locationControlls,
            //         CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await CrecheDataResponceUploadApi()
              .crecheCareGiverUpload(token!, jsonEncode(resultMap));
          if (responce.statusCode == 200) {
            await updateCreCheProFile(responce);
            if ((crecheProfiles.indexOf(element)) ==
                (crecheProfiles.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 10;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${crecheProfiles.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(locationControlls,
            //         CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 10;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> uploadDataCoordinator(BuildContext mContext) async {
    var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();

    if (hhItems.length > 0) {
      showLoaderDialog(context);
      var token = await Validate().readString(Validate.appToken);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      List<Map<String, dynamic>> dataList = [];
      hhItems.forEach((element) async {
        Map<String, dynamic> resultMap = jsonDecode(element.responces!);
        if (element.name != null) {
          Map<String, dynamic> item = {};
          item['name'] = element.name;
          item['status'] = resultMap['verification_status'];
          item['verified_by'] = resultMap['verified_by'];
          item['verified_on'] = resultMap['verified_on'];
          dataList.add(item);
        }
      });

      var hhData = {
        "usr": userName,
        "pwd": password,
        "hh": dataList,
      };
      var responce =
          await HHDataUploadApi().uploadLatestApiHHData(token!, hhData);
      if (responce.statusCode == 200) {
        await updateVerification(responce, dataList);
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.data_upload_success_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            context);
      } else if (responce.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lng!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
        // Validate().singleButtonPopup(
        //     Global.returnTrLable(locationControlls,
        //         CustomText.token_expired, lng!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
        return;
      } else {
        Navigator.pop(mContext);
        await callUploadData();
        Validate().singleButtonPopup(
            Global.errorBodyToString(responce.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            context);

        return;
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  Future<void> uploadAttendance(BuildContext mContext) async {
    var chilAttendence =
        await ChildAttendanceResponceHelper().callChildAttendencesAllForUpoad();
    if (chilAttendence.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.childAttendence, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${chilAttendence.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < chilAttendence.length; i++) {
        var element = chilAttendence[i];
        var cItems = await ChildAttendenceHelper()
            .callChildAttendencesForUpload(element.childattenguid,
                Global.getItemValues(element.responces!, 'date_of_attendance'));

        Map<String, dynamic> resultMap = jsonDecode(element.responces!);
        List<dynamic> childrensList = [];

        for (var cItem in cItems) {
          childrensList.add(cItem);
        }
        if (childrensList.length > 0) {
          resultMap['childattendancelist'] = childrensList;
        }
        // if (element.name != null) {
        //   resultMap.remove("name");
        // }

        // if (element.name == null) {
        var responce = await ChildAttendanceUploadApi()
            .AttendanceUpload(token!, jsonEncode(resultMap));
        if (responce.statusCode == 200) {
          Validate().saveString(
              Validate.dataUploadDateTime, Validate().currentDateTime());
          await updateResponcesChildAttendance(responce);
          if ((chilAttendence.indexOf(element)) ==
              (chilAttendence.length - 1)) {
            Navigator.pop(mContext);
            if (selectAllOpt == 1) {
              currentUploadStatus = 6;
              await methods[currentUploadStatus](context);
            } else
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
          } else {
            currentItem = currentItem + 1;
            loadingTextUpdatedCount = '$currentItem/${chilAttendence.length}';
            loadingText = Global.returnTrLable(
                locationControlls, CustomText.uploading, lng!);
            loadingText =
                '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
            updateLoadingText(dialogSetState, loadingText);
          }
        } else if (responce.statusCode == 401) {
          Navigator.pop(mContext);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove(Validate.Password);
          ScaffoldMessenger.of(mContext).showSnackBar(
            SnackBar(
                content: Text(Global.returnTrLable(
                    locationControlls, CustomText.token_expired, lng!))),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (mContext) => LoginScreen(),
              ));
          // Validate().singleButtonPopup(
          //     Global.returnTrLable(
          //         locationControlls, CustomText.token_expired, lng!),
          //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          //     false,
          //     context);
        } else {
          Navigator.pop(mContext);
          await callUploadData();
          debugPrint(responce.body);
          Validate().singleButtonPopup(
              Global.errorBodyToStringFromList(responce.body),
              Global.returnTrLable(locationControlls, CustomText.ok, lng!),
              false,
              context);

          return;
        }
        // } else {
        //   var responce = await ChildAttendanceUploadApi().childAttendanceUpload(
        //       token!, jsonEncode(resultMap), element.name);
        //   if (responce.statusCode == 200) {
        //     await updateResponcesChildAttendance(responce);
        //     if ((chilAttendence.indexOf(element)) ==
        //         (chilAttendence.length - 1)) {
        //       Navigator.pop(mContext);
        //       if (selectAllOpt == 1) {
        //         currentUploadStatus = 6;
        //         await methods[currentUploadStatus](context);
        //       } else
        //         Validate().singleButtonPopup(
        //             Global.returnTrLable(locationControlls,
        //                 CustomText.data_upload_success_msg, lng!),
        //             Global.returnTrLable(
        //                 locationControlls, CustomText.ok, lng!),
        //             false,
        //             context);
        //     } else {
        //       currentItem = currentItem + 1;
        //       loadingTextUpdatedCount = '$currentItem/${chilAttendence.length}';
        //       loadingText = Global.returnTrLable(
        //           locationControlls, CustomText.uploading, lng!);
        //       loadingText =
        //           '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
        //       updateLoadingText(dialogSetState, loadingText);
        //     }
        //   } else if (responce.statusCode == 401) {
        //     Navigator.pop(mContext);
        //     SharedPreferences prefs = await SharedPreferences.getInstance();
        //     await prefs.remove(Validate.Password);
        //     ScaffoldMessenger.of(mContext).showSnackBar(
        //       SnackBar(
        //           content: Text(Global.returnTrLable(
        //               locationControlls, CustomText.token_expired, lng!))),
        //     );
        //     Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (mContext) => LoginScreen(),
        //         ));
        //     // Validate().singleButtonPopup(
        //     //     Global.returnTrLable(
        //     //         locationControlls, CustomText.token_expired, lng!),
        //     //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
        //     //     false,
        //     //     context);
        //   } else {
        //     Navigator.pop(mContext);
        //     await callUploadData();
        //     debugPrint(responce.body);
        //     Validate().singleButtonPopup(
        //         Global.errorBodyToStringFromList(responce.body),
        //         Global.returnTrLable(locationControlls, CustomText.ok, lng!),
        //         false,
        //         context);

        //     return;
        //   }
        // }
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 6;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateResponcesCrecheCheckIn(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CheckInResponseHelper()
          .updateUploadedCrecheCheckInResponce(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadCheckInData(BuildContext mContext) async {
    var crecheCheckIn =
        await CheckInResponseHelper().callCrecheCheckInResponses();
    if (crecheCheckIn.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.checkIns, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${crecheCheckIn.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < crecheCheckIn.length; i++) {
        var element = crecheCheckIn[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
        if (!Global.validString(jsonBody['checkin_location'])) {
          if (Global.validString(jsonBody['latitude']) &&
              Global.validString(jsonBody['longitude'])) {
            var latitude = Global.stringToDouble(jsonBody['latitude']);
            var longitude = Global.stringToDouble(jsonBody['longitude']);
            jsonBody['checkin_location'] =
                await Validate().getAddressFromLatLng(latitude, longitude);
          }
        }
        if (element.name == null) {
          var responce = await CrecheCheckInApi()
              .checkInUpload(token!, jsonEncode(jsonBody));
          if (responce.statusCode == 200) {
            await updateResponcesCrecheCheckIn(responce);
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            if ((crecheCheckIn.indexOf(element)) ==
                (crecheCheckIn.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 11;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${crecheCheckIn.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          Navigator.pop(mContext);
          Validate().singleButtonPopup(
              Global.returnTrLable(locationControlls, 'GUID is Empty', lng!),
              Global.returnTrLable(locationControlls, CustomText.ok, lng!),
              false,
              mContext);
        }
        // });
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 11;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateResponcesChildAttendance(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildAttendanceResponceHelper()
          .updateUploadedChildAttendanceItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> updateResponces(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await HouseHoldTabResponceHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> updateCreCheProFile(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CrecheDataHelper().updateDownloadeData(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> updateResponcesChildProfile(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await EnrolledChilrenResponceHelper()
          .updateUploadedChildProfileItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  String getItemValues(String response, String key) {
    String returnValue = "";
    Map<String, dynamic> itemresponse = jsonDecode(response);
    var value = itemresponse[key];
    if (value != null) {
      returnValue = value.toString();
    }
    return returnValue;
  }

  Future<void> updateVerification(
      Response value, List<Map<String, dynamic>> dataList) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      if (resultMap['Response'] == 'Success') {
        await HouseHoldTabResponceHelper().updateVerficationUpload(dataList);
        await callUploadData();
      }
      print(" responce $resultMap");
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.data_upload_success_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);

      Navigator.pop(context);
    } catch (e) {
      print("exp ${e.toString()}");
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.data_not_uploaded_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);

      Navigator.pop(context);
    }
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            dialogSetState = setState;
            return AlertDialog(
                content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 10.h),
                Text(loadingText),
              ],
            ));
          }),
        );
      },
    );
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return StatefulBuilder(
    //       builder: (BuildContext context, StateSetter setState) {
    //         dialogSetState = setState; // Capture StateSetter
    //         return AlertDialog(
    //           content: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               const CircularProgressIndicator(),
    //               Text(loadingText), // Text that will be updated
    //             ],
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );
  }

  Future<void> initializeData() async {
    lng = await Validate().readString(Validate.sLanguage);
    userRole = await Validate().readString(Validate.role);
    showLoaderDialog(context);
    List<String> valueNames = [
      CustomText.recordAvailable,
      CustomText.HHListing,
      CustomText.sync,
      CustomText.uploadAll,
      CustomText.nothing_for_upload_msg,
      CustomText.data_upload_success_msg,
      CustomText.data_not_uploaded_msg,
      CustomText.ok,
      CustomText.uploadingPleaseWait,
      CustomText.token_expired,
      CustomText.ChildProfile,
      CustomText.CrecheProfileView,
      CustomText.fllowUp,
      CustomText.nointernetconnectionavailable,
      CustomText.uploading,
      CustomText.recordsAvailable,
      CustomText.childGrowthMonitoring,
      CustomText.AnthroData,
      CustomText.creche,
      CustomText.crceheCaregiver,
      CustomText.village,
      CustomText.demographicalDetail,
      CustomText.cashbookReceipt,
      CustomText.crecheStock,
      CustomText.formLogic,
      CustomText.crecheRequisiton,
      CustomText.childProfileDoctype,
      CustomText.requisitionChildTable,
      CustomText.cmcCCDoctype,
      CustomText.childEnrollExit,
      CustomText.grievienceDoctype,
      CustomText.cmcCBMDoxtype,
      CustomText.cmcDoctype,
      CustomText.crecheMeeting,
      CustomText.cmcALMDoctype,
      CustomText.childAttendance,
      CustomText.cashbook,
      CustomText.childFollowUp,
      CustomText.childExit,
      CustomText.childreferralDoctype,
      CustomText.childHealthDoctype,
      CustomText.houseHoldChildForm,
      CustomText.houseHoldForm,
      CustomText.childEventDoctype,
      CustomText.childImmunization,
      CustomText.anyMedical,
      CustomText.crceheCheckIn,
      CustomText.visitPurpose,
      CustomText.disability,
      CustomText.VisitNotes,
      CustomText.enrollExitChild,
      CustomText.GrowthMonitoring,
      CustomText.childReferral,
      CustomText.childAttendence,
      CustomText.ChildEvents,
      CustomText.ChildHealth,
      CustomText.ChildImmunization,
      CustomText.checkIns,
      CustomText.CrecheCommitte,
      CustomText.CashBookExpences,
      CustomText.CashBookReceipt,
      CustomText.villageProfile,
      CustomText.Stock,
      CustomText.requisition,
      CustomText.imageFiles,
      CustomText.selectAllForUpload,
      CustomText.all,
      CustomText.unsynched,
    ];
    if (userRole == 'Creche Supervisor') {
      methods = [
        uploadData, //0
        uploadChildEnrolledExit, //1
        uploadChildGrowthData, //2
        uploadChildReferralData, //3
        uploadChildFollowUpData, //4
        uploadAttendance, //5
        uploadChildEventData, //6
        uploadChildHealthData, //7
        uploadChildImmunizationData, //8
        uploadCreCheProfile, //9
        uploadCheckInData, //10
        uploadChildGrievanceData, //11
        uploadCrecheMonitorData, //12
        uploadCrecheCommittieData, //13
        uploadCashbookData, //14
        uploadCashbookReceiptData, //15
        uploadVillageProfile, //16
        uploadStock, //17
        uploadRequisition, //18
        uploadImageFile, //19
      ];
    }
    else if (userRole == 'Cluster Coordinator') {
      methods = [
        uploadcmcCCData,
        uploadChildGrievanceData,
        uploadCheckInData,
        uploadImageFile
      ];
    }
    else if (userRole == 'Accounts and Logistics Manager') {
      methods = [
        uploadcmcALMData,
        uploadChildGrievanceData,
        uploadCheckInData,
        uploadImageFile
      ];
    } else if (userRole == 'Capacity and Building Manager') {
      methods = [
        uploadcmcCBMData,
        uploadChildGrievanceData,
        uploadCheckInData,
        uploadImageFile
      ];
    } else {
      methods = [
        uploadChildGrievanceData,
      ];
    }

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => locationControlls.addAll(value));

    Navigator.pop(context);

    await callUploadData();
  }

  Future<void> uploadChildGrowthData(BuildContext mContext) async {
    var anthropomertydata =
        await ChildGrowthResponseHelper().callChildGrowthResponses();
    if (anthropomertydata.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.enrollExitChild, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${anthropomertydata.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < anthropomertydata.length; i++) {
        var element = anthropomertydata[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);


          var responce = await ChildGrowthMetaUploadApi()
              .childGrowthMetaUpload(token!, jsonEncode(jsonBody));
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildGrowth(responce, element.responces!);
            if ((anthropomertydata.indexOf(element)) ==
                (anthropomertydata.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            }
          }
          else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;

        }
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  Future<void> updateResponcesChildGrowth(
      Response value, String responcence) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildGrowthResponseHelper()
          .updateUploadedChildGrowthResponce(resultMap, responcence);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadChildEventData(BuildContext mContext) async {
    var childeventdata =
        await ChildEventTabResponceHelper().getEditedChildEventsForUpload();
    if (childeventdata.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.ChildEvents, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${childeventdata.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < childeventdata.length; i++) {
        var element = childeventdata[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);

        if (element.name != null) {
          var responce = await ChildEventUploadApi().childEventUploadUpdate(
              token!, jsonEncode(jsonBody), element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildEvent(responce);
            if ((childeventdata.indexOf(element)) ==
                (childeventdata.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 7;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${childeventdata.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await ChildEventUploadApi()
              .childEventUpload(token!, jsonEncode(jsonBody));
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildEvent(responce);
            if ((childeventdata.indexOf(element)) ==
                (childeventdata.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 7;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${childeventdata.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 7;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateResponcesChildEvent(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildEventTabResponceHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadChildHealthData(BuildContext mContext) async {
    var childhealthdata =
        await ChildHealthTabResponceHelper().getChildHealthForUpload();
    if (childhealthdata.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.ChildHealth, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${childhealthdata.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < childhealthdata.length; i++) {
        var element = childhealthdata[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);

        if (element.name != null) {
          var responce = await ChildHealthUploadApi().childHealthUploadUpdate(
              token!, jsonEncode(jsonBody), element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildHealth(responce);
            if ((childhealthdata.indexOf(element)) ==
                (childhealthdata.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 8;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount =
                  '$currentItem/${childhealthdata.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await ChildHealthUploadApi()
              .childHealthUpload(token!, jsonEncode(jsonBody));
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildHealth(responce);
            if ((childhealthdata.indexOf(element)) ==
                (childhealthdata.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 8;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount =
                  '$currentItem/${childhealthdata.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 8;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateResponcesChildHealth(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildHealthTabResponceHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadChildImmunizationData(BuildContext mContext) async {
    var childimmunizationdata =
        await ChildImmunizationResponseHelper().getChildImmunizationForUpload();
    if (childimmunizationdata.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.ChildImmunization, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${childimmunizationdata.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < childimmunizationdata.length; i++) {
        var element = childimmunizationdata[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);

        // if (element.name != null) {
        var responce = await ChildImmunizationUploadApi()
            .childImmunzationUploadUpdate(token!, jsonEncode(jsonBody));
        if (responce.statusCode == 200) {
          Validate().saveString(
              Validate.dataUploadDateTime, Validate().currentDateTime());
          await updateResponcesChildImmunization(responce);
          if ((childimmunizationdata.indexOf(element)) ==
              (childimmunizationdata.length - 1)) {
            Navigator.pop(mContext);
            if (selectAllOpt == 1) {
              currentUploadStatus = 9;
              await methods[currentUploadStatus](context);
            } else
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
          } else {
            currentItem = currentItem + 1;
            loadingTextUpdatedCount =
                '$currentItem/${childimmunizationdata.length}';
            loadingText = Global.returnTrLable(
                locationControlls, CustomText.uploading, lng!);
            loadingText =
                '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
            updateLoadingText(dialogSetState, loadingText);
          }
        } else if (responce.statusCode == 401) {
          Navigator.pop(mContext);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove(Validate.Password);
          ScaffoldMessenger.of(mContext).showSnackBar(
            SnackBar(
                content: Text(Global.returnTrLable(
                    locationControlls, CustomText.token_expired, lng!))),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (mContext) => LoginScreen(),
              ));
          // Validate().singleButtonPopup(
          //     Global.returnTrLable(
          //         locationControlls, CustomText.token_expired, lng!),
          //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          //     false,
          //     context);
        } else {
          Navigator.pop(mContext);
          await callUploadData();
          Validate().singleButtonPopup(
              Global.errorBodyToStringFromList(responce.body),
              Global.returnTrLable(locationControlls, CustomText.ok, lng!),
              false,
              context);

          return;
        }
        // } else {
        //   var responce = await ChildImmunizationUploadApi()
        //       .childImmunzationUpload(token!, jsonEncode(jsonBody));
        //   if (responce.statusCode == 200) {
        //     Validate().saveString(
        //         Validate.dataUploadDateTime, Validate().currentDateTime());
        //     await updateResponcesChildImmunization(responce);
        //     if ((childimmunizationdata.indexOf(element)) ==
        //         (childimmunizationdata.length - 1)) {
        //       Navigator.pop(mContext);
        //       if (selectAllOpt == 1) {
        //         currentUploadStatus = 9;
        //         await methods[currentUploadStatus](context);
        //       } else
        //         Validate().singleButtonPopup(
        //             Global.returnTrLable(locationControlls,
        //                 CustomText.data_upload_success_msg, lng!),
        //             Global.returnTrLable(
        //                 locationControlls, CustomText.ok, lng!),
        //             false,
        //             context);
        //     } else {
        //       currentItem = currentItem + 1;
        //       loadingTextUpdatedCount =
        //           '$currentItem/${childimmunizationdata.length}';
        //       loadingText = Global.returnTrLable(
        //           locationControlls, CustomText.uploading, lng!);
        //       loadingText =
        //           '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
        //       updateLoadingText(dialogSetState, loadingText);
        //     }
        //   } else if (responce.statusCode == 401) {
        //     Navigator.pop(mContext);
        //     SharedPreferences prefs = await SharedPreferences.getInstance();
        //     await prefs.remove(Validate.Password);
        //     ScaffoldMessenger.of(mContext).showSnackBar(
        //       SnackBar(
        //           content: Text(Global.returnTrLable(
        //               locationControlls, CustomText.token_expired, lng!))),
        //     );
        //     Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (mContext) => LoginScreen(),
        //         ));
        //     // Validate().singleButtonPopup(
        //     //     Global.returnTrLable(
        //     //         locationControlls, CustomText.token_expired, lng!),
        //     //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
        //     //     false,
        //     //     context);
        //   } else {
        //     Navigator.pop(mContext);
        //     await callUploadData();
        //     Validate().singleButtonPopup(
        //         Global.errorBodyToStringFromList(responce.body),
        //         Global.returnTrLable(locationControlls, CustomText.ok, lng!),
        //         false,
        //         context);

        //     return;
        //   }
        // }
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 9;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateResponcesChildImmunization(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildImmunizationResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadChildExitData(BuildContext mContext) async {
    var childexitdata =
        await ChildExitResponceHelper().getEditedChildExitForUpload();
    if (childexitdata.length > 0) {
      showLoaderDialog(mContext);
      var token = await Validate().readString(Validate.appToken);
      childexitdata.forEach((element) async {
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);

        if (element.name != null) {
          var responce = await ChildExitUploadApi().childExitUploadUpdate(
              token!, jsonEncode(jsonBody), element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildExit(responce);
            if ((childexitdata.indexOf(element)) ==
                (childexitdata.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await ChildExitUploadApi()
              .childExitUpload(token!, jsonEncode(jsonBody));
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildExit(responce);
            if ((childexitdata.indexOf(element)) ==
                (childexitdata.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      });
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  Future<void> updateResponcesChildExit(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildExitResponceHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadChildGrievanceData(BuildContext mContext) async {
    var grievancedata =
        await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
    if (grievancedata.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.ChildGrievances, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${grievancedata.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < grievancedata.length; i++) {
        var element = grievancedata[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
        jsonBody['status'] = '1';
        var itemResponce = jsonEncode(jsonBody);
        if (element.name != null) {
          var responce = await ChildGrievanceUploadApi()
              .childGrievanceUploadUpdate(token!, itemResponce, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildGrievance(responce);
            if ((grievancedata.indexOf(element)) ==
                (grievancedata.length - 1)) {
              Navigator.pop(mContext);

              if (selectAllOpt == 1) {
                currentUploadStatus = 12;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${grievancedata.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await ChildGrievanceUploadApi()
              .childGrievanceUpload(token!, itemResponce);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildGrievance(responce);
            if ((grievancedata.indexOf(element)) ==
                (grievancedata.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 12;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${grievancedata.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 12;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateResponcesChildGrievance(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildGrievancesTabResponceHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadCrecheMonitorData(BuildContext mContext) async {
    final crecheData =
        await CrecheMonitorResponseHelper().getCrecheResponseForUpload();
    if (crecheData.isNotEmpty) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.VisitNotes, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${crecheData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < crecheData.length; i++) {
        var element = crecheData[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);

        final itemResponse = jsonEncode(jsonBody);

        if (element.name != null) {
          final response = await CrecheMonitoringApi().updateUploadedCheckList(
            appToken: token!,
            dataResponse: itemResponse,
            name: element.name ?? 0,
          );
          if (response.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponsesCrecheMonitorData(response);
            if ((crecheData.indexOf(element)) == (crecheData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 13;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${crecheData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (response.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(response.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          final response = await CrecheMonitoringApi().uploadCheckList(
            appToken: token!,
            dataResponse: itemResponse,
          );

          if (response.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponsesCrecheMonitorData(response);
            if ((crecheData.indexOf(element)) == (crecheData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 13;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${crecheData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (response.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(response.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 13;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateResponsesCrecheMonitorData(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" response $resultMap");
      await CrecheMonitorResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadChildReferralData(BuildContext mContext) async {
    var referralData =
        await ChildReferralTabResponseHelper().getChildReferralForUpload();
    if (referralData.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.childReferral, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${referralData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < referralData.length; i++) {
        var element = referralData[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
        jsonBody['status'] = '1';
        var itemResponce = jsonEncode(jsonBody);
        if (element.name != null) {
          var responce = await ChildReferralUploadApi()
              .childReferralUploadUpdate(token!, itemResponce, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildReferral(responce);
            if ((referralData.indexOf(element)) == (referralData.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${referralData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await ChildReferralUploadApi()
              .childReferralUpload(token!, itemResponce);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildReferral(responce);
            if ((referralData.indexOf(element)) == (referralData.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${referralData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  Future<void> updateResponcesChildReferral(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildReferralTabResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadChildFollowUpData(BuildContext mContext) async {
    var followUpData =
        await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
    if (followUpData.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.fllowUp, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${followUpData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < followUpData.length; i++) {
        var element = followUpData[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
        jsonBody['status'] = '1';
        var itemResponce = jsonEncode(jsonBody);
        if (element.name != null) {
          var responce = await ChildFollowUpUploadApi()
              .childFollowUpUploadUpdate(token!, itemResponce, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildFollowUp(responce);
            if ((followUpData.indexOf(element)) == (followUpData.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${followUpData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await ChildFollowUpUploadApi()
              .childFollowUpUpload(token!, itemResponce);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildFollowUp(responce);
            if ((followUpData.indexOf(element)) == (followUpData.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${followUpData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  Future<void> updateResponcesChildFollowUp(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildFollowUpTabResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadCrecheCommittieData(BuildContext mContext) async {
    var ccmData =
        await CrecheCommittieResponnseHelper().getCrecheCommittieForUpload();
    if (ccmData.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.CrecheCommitte, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${ccmData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < ccmData.length; i++) {
        var element = ccmData[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
        jsonBody['status'] = '1';
        var itemResponce = jsonEncode(jsonBody);
        if (element.name != null) {
          var responce = await CrecheCommittieUploadApi()
              .childCrecheCommittieUploadUpdate(
                  token!, itemResponce, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesCrecheCommittie(responce);
            if ((ccmData.indexOf(element)) == (ccmData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 14;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${ccmData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            var msg = await TranslationDataHelper().getTranslation(
                Global.errorBodyToStringFromList(responce.body), lng!);
            await callUploadData();
            Validate().singleButtonPopup(
                msg,
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await CrecheCommittieUploadApi()
              .childCrecheCommittieUpload(token!, itemResponce);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesCrecheCommittie(responce);

            if ((ccmData.indexOf(element)) == (ccmData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 14;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${ccmData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 14;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateResponcesCrecheCommittie(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CrecheCommittieResponnseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> updateResponcesCmcCBm(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CmcCBMTabResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadCashbookData(BuildContext mContext) async {
    var casgBookdata = await CashBookResponseExpencesHelper()
        .getEditedCashBookForExpenceUpload();
    if (casgBookdata.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.CashBookExpences, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${casgBookdata.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < casgBookdata.length; i++) {
        var element = casgBookdata[i];
        if (element.name != null) {
          var responce = await CashBookExpensesApi()
              .cashBookExpnesesUploadUdate(
                  token!, element.responces!, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesCashbookExpences(responce);
            if ((casgBookdata.indexOf(element)) == (casgBookdata.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 15;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${casgBookdata.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await CashBookExpensesApi()
              .cashBookExpensesUpload(token!, element.responces!);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesCashbookExpences(responce);
            if ((casgBookdata.indexOf(element)) == (casgBookdata.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 15;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${casgBookdata.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 15;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateResponcesCashbookExpences(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CashBookResponseExpencesHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadCashbookReceiptData(BuildContext mContext) async {
    var cashbookReceiptData = await CashBookReceiptResponseHelper()
        .getEditedCashBookReceiptForUpload();
    if (cashbookReceiptData.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.CashBookReceipt, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${cashbookReceiptData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < cashbookReceiptData.length; i++) {
        var element = cashbookReceiptData[i];
        if (element.name != null) {
          var responce = await CashBookReceiptApi().cashBookReceiptUploadUdate(
              token!, element.responces!, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesCashbookReceipt(responce);
            if ((cashbookReceiptData.indexOf(element)) ==
                (cashbookReceiptData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 16;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount =
                  '$currentItem/${cashbookReceiptData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await CashBookReceiptApi()
              .cashBookReceiptUpload(token!, element.responces!);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesCashbookReceipt(responce);
            if ((cashbookReceiptData.indexOf(element)) ==
                (cashbookReceiptData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 16;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount =
                  '$currentItem/${cashbookReceiptData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      if (selectAllOpt == 1) {
        currentUploadStatus = 16;
        await methods[currentUploadStatus](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateResponcesCashbookReceipt(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CashBookReceiptResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadcmcALMData(BuildContext mContext) async {
    var cmcALMData = await CmcALMTabResponseHelper().getAlmForUpload();
    if (cmcALMData.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.VisitNotes, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${cmcALMData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(mContext);
      cmcALMData.forEach((element) async {
        if (element.name != null) {
          var responce = await CrecheMonetringCheckListALMApi()
              .cmcALMUploadUdate(token!, element.responces!, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponsescmcALMData(responce);
            if ((cmcALMData.indexOf(element)) == (cmcALMData.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${cmcALMData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await CrecheMonetringCheckListALMApi()
              .cmcALMUpload(token!, element.responces!);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponsescmcALMData(responce);
            if ((cmcALMData.indexOf(element)) == (cmcALMData.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${cmcALMData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      });
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  Future<void> updateResponsescmcALMData(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CmcALMTabResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadcmcCBMData(BuildContext mContext) async {
    var cmcCBMData = await CmcCBMTabResponseHelper().getCBMForUpload();
    if (cmcCBMData.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.VisitNotes, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${cmcCBMData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(mContext);
      cmcCBMData.forEach((element) async {
        if (element.name != null) {
          var responce = await CrecheMonetringCheckListCBMApi()
              .cmcCBMUploadUdate(token!, element.responces!, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponsescmcCBMData(responce);
            if ((cmcCBMData.indexOf(element)) == (cmcCBMData.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${cmcCBMData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await CrecheMonetringCheckListCBMApi()
              .cmcCBMUpload(token!, element.responces!);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponsescmcCBMData(responce);
            if ((cmcCBMData.indexOf(element)) == (cmcCBMData.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${cmcCBMData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      });
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  Future<void> updateResponsescmcCBMData(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CmcCBMTabResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadcmcCCData(BuildContext mContext) async {
    var cmcCCData = await CmcCCTabResponseHelper().getCcForUpload();
    if (cmcCCData.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.VisitNotes, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${cmcCCData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(mContext);
      cmcCCData.forEach((element) async {
        // Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
        // jsonBody['status'] = '1';
        // var itemResponce = jsonEncode(jsonBody);
        if (element.name != null) {
          var responce = await CrecheMonetringCheckListCCApi()
              .cmcCCUploadUdate(token!, element.responces!, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponsescmcCCData(responce);
            if ((cmcCCData.indexOf(element)) == (cmcCCData.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${cmcCCData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await CrecheMonetringCheckListCCApi()
              .cmcCCUpload(token!, element.responces!);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponsescmcCCData(responce);
            if ((cmcCCData.indexOf(element)) == (cmcCCData.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${cmcCCData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      });
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  Future<void> updateResponsescmcCCData(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CmcCCTabResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  String checkAllForUpload(String key) {
    String screenImage = 'assets/tranceparent_ic.png';
    var item = syncInfoCount[key];
    if (item != null) {
      if (item > 0) {
        screenImage = 'assets/check_ic_up.png';
      }
    }
    return screenImage;
  }

  List<TextSpan> parseBoldText(String text, TextStyle normalStyle,
      TextStyle boldStyle, TextStyle redboldStyle) {
    final RegExp boldTagRegExp = RegExp(r'\[b\](.*?)\[/b\]');
    final List<TextSpan> spans = [];
    int start = 0;

    text.splitMapJoin(
      boldTagRegExp,
      onMatch: (Match match) {
        if (match.start > start) {
          spans.add(TextSpan(
              text: text.substring(start, match.start), style: normalStyle));
        }
        spans.add(TextSpan(
            text: match.group(1),
            style: Global.stringToInt(match.group(1)) > 0
                ? redboldStyle
                : boldStyle));
        start = match.end;
        return '';
      },
      onNonMatch: (String nonMatch) {
        spans.add(TextSpan(text: nonMatch, style: normalStyle));
        return '';
      },
    );

    return spans;
  }

  int unsyncCount(String text) {
    final RegExp boldTagRegExp = RegExp(r'\[b\](.*?)\[/b\]');
    final List<TextSpan> spans = [];
    int unsycCount = 0;

    text.splitMapJoin(
      boldTagRegExp,
      onMatch: (Match match) {
        unsycCount =
            Global.stringToInt(Global.validToString(match.group(1)).trim());
        return '';
      },
    );

    return unsycCount;
  }

  Future<void> uploadDataSequence1(
      BuildContext mContext, int methodeIndex) async {
    var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
    hhItems = hhItems
        .where((element) =>
            Global.stringToInt(Global.getItemValues(
                element.responces!, 'verification_status')) >
            1)
        .toList();
    if (hhItems.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.HHListing, lng!);
      int currentItem = 1;
      loadingTextUpdatedCount = '$currentItem/${hhItems.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < hhItems.length; i++) {
        var element = hhItems[i];
        var cItems = await HouseHoldChildrenHelperHelper()
            .getResponceHouseHoldChildren(element
                .HHGUID!); //"{"name":684,"parent":413,"hhguid":"q9bYVpayHGNzNwlQbnCdlOzQ1714538085360","hhcguid":"BWJpZLlBtZO3B7v1K2tcc6QG1714538201579","app…"
        Map<String, dynamic> resultMap =
            jsonDecode(element.responces!); // Map format of the above
        List<dynamic> childrensList = [];

        for (var cItem in cItems) {
          Map<String, dynamic> map = jsonDecode(cItem);
          map.remove('owner');
          childrensList.add(map); //Added to the List in JSON format
        }
        if (element.name == null) {
          if (childrensList.length > 0) {
            resultMap['children'] = childrensList;
          }
        }
        // if(resultMap['verification_status']!='4') {
        resultMap['verification_status'] = "3";
        // }
        resultMap.remove('owner');
        var token = await Validate().readString(Validate.appToken);
        if (element.name != null) {
          var responce = await HHDataUploadApi().uploadHHDataUpdate(
              token!, element.name!, resultMap, childrensList);
          if (responce.statusCode == 200) {
            print('Upload: $responce');
            await updateResponces(responce);
            if ((hhItems.indexOf(element)) == (hhItems.length - 1)) {
              Navigator.pop(mContext);
              uploadChildProfileSequence2(mContext, methodeIndex);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${hhItems.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            return;
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce =
              await HHDataUploadApi().uploadHHData(token!, resultMap);
          if (responce.statusCode == 200) {
            await updateResponces(responce);
            if ((hhItems.indexOf(element)) == (hhItems.length - 1)) {
              Navigator.pop(mContext);
              uploadChildProfileSequence2(mContext, methodeIndex);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${hhItems.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      // Navigator.pop(mContext);
      uploadChildProfileSequence2(mContext, methodeIndex);
    }
  }

  Future<void> uploadChildProfileSequence2(
      BuildContext mContext, int methodeIndex) async {
    var chilProfiles =
        await EnrolledChilrenResponceHelper().callChildrenForUpload();
    if (chilProfiles.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.ChildProfile, lng!);
      int currentItem = 1;
      loadingTextUpdatedCount = '$currentItem/${chilProfiles.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < chilProfiles.length; i++) {
        var element = chilProfiles[i];
        var token = await Validate().readString(Validate.appToken);
        Map<String, dynamic> resultMap = jsonDecode(element.responces!);
        resultMap['status'] = '1';
        resultMap.remove('owner');
        var itemResponce = jsonEncode(resultMap);

        if (element.name != null) {
          var responce = await EnrolledChildProfileUploadApi()
              .enrolledChildProfileUploadUpdate(
                  token!, itemResponce, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildProfile(responce);
            if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
              Navigator.pop(mContext);
              uploadChildProfileSequence3(mContext, methodeIndex);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${chilProfiles.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(locationControlls,
            //         CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await EnrolledChildProfileUploadApi()
              .enrolledChildProfileUpload(token!, itemResponce);
          if (responce.statusCode == 200) {
            await updateResponcesChildProfile(responce);
            if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
              Navigator.pop(mContext);
              uploadChildProfileSequence3(mContext, methodeIndex);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${chilProfiles.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(locationControlls,
            //         CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      uploadChildProfileSequence3(mContext, methodeIndex);
    }
  }

  Future<void> uploadChildProfileSequence3(
      BuildContext mContext, int methodeIndex) async {
    var chilProfiles =
        await EnrolledExitChilrenResponceHelper().callChildrenForUpload();
    if (chilProfiles.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.enrollExitChild, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${chilProfiles.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < chilProfiles.length; i++) {
        var element = chilProfiles[i];
        Map<String, dynamic> resultMap = jsonDecode(element.responces!);
        resultMap['status'] = '1';
        resultMap.remove('owner');
        var itemResponce = jsonEncode(resultMap);
        if (element.name != null) {
          var responce = await ChildEnrolledExitApi()
              .enrollExitChildUpdate(token!, itemResponce, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateChildEnrollExitResponse(responce);
            if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
              Navigator.pop(mContext);
              uploadChildGrowthDataSeq1(mContext, methodeIndex);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${chilProfiles.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(locationControlls,
            //         CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await ChildEnrolledExitApi()
              .enrollExitChildUpload(token!, itemResponce);
          if (responce.statusCode == 200) {
            await updateChildEnrollExitResponse(responce);
            if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
              Navigator.pop(mContext);
              uploadChildGrowthDataSeq1(mContext, methodeIndex);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${chilProfiles.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(locationControlls,
            //         CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            debugPrint(responce.body);
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      uploadChildGrowthDataSeq1(mContext, methodeIndex);
    }
  }

  // Future<void> uploadChildExitDataSequence3(
  //     BuildContext mContext, int methodeIndex) async {
  //   var childexitdata =
  //       await ChildExitResponceHelper().getEditedChildExitForUpload();
  //   if (childexitdata.length > 0) {
  //     showLoaderDialog(mContext);
  //     var token = await Validate().readString(Validate.appToken);
  //     childexitdata.forEach((element) async {
  //       Map<String, dynamic> jsonBody = jsonDecode(element.responces!);

  //       if (element.name != null) {
  //         var responce = await ChildExitUploadApi().childExitUploadUpdate(
  //             token!, jsonEncode(jsonBody), element.name);
  //         if (responce.statusCode == 200) {
  //           Validate().saveString(
  //               Validate.dataUploadDateTime, Validate().currentDateTime());
  //           await updateResponcesChildExit(responce);
  //           if ((childexitdata.indexOf(element)) ==
  //               (childexitdata.length - 1)) {
  //             Navigator.pop(mContext);
  //             uploadChildGrowthDataSeq1(mContext, methodeIndex);
  //             // if (methodeIndex > 1 && (methodeIndex != 7)) {
  //             //   await methods[methodeIndex](context);
  //             // } else
  //             //   Validate().singleButtonPopup(
  //             //       Global.returnTrLable(
  //             //           locationControlls, CustomText.data_upload_success_msg,
  //             //           lng!),
  //             //       Global.returnTrLable(
  //             //           locationControlls, CustomText.ok, lng!),
  //             //       false,
  //             //       mContext);
  //           }
  //         } else if (responce.statusCode == 401) {
  //           Navigator.pop(mContext);
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           await prefs.remove(Validate.Password);
  //           ScaffoldMessenger.of(mContext).showSnackBar(
  //             SnackBar(
  //                 content: Text(Global.returnTrLable(
  //                     locationControlls, CustomText.token_expired, lng!))),
  //           );
  //           Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (mContext) => LoginScreen(),
  //               ));
  //           // Validate().singleButtonPopup(
  //           //     Global.returnTrLable(
  //           //         locationControlls, CustomText.token_expired, lng!),
  //           //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
  //           //     false,
  //           //     context);
  //         } else {
  //           Navigator.pop(mContext);
  //           await callUploadData();
  //           Validate().singleButtonPopup(
  //               Global.errorBodyToStringFromList(responce.body),
  //               Global.returnTrLable(locationControlls, CustomText.ok, lng!),
  //               false,
  //               context);

  //           return;
  //         }
  //       } else {
  //         var responce = await ChildExitUploadApi()
  //             .childExitUpload(token!, jsonEncode(jsonBody));
  //         if (responce.statusCode == 200) {
  //           Validate().saveString(
  //               Validate.dataUploadDateTime, Validate().currentDateTime());
  //           await updateResponcesChildExit(responce);
  //           if ((childexitdata.indexOf(element)) ==
  //               (childexitdata.length - 1)) {
  //             Navigator.pop(mContext);
  //             uploadChildGrowthDataSeq1(mContext, methodeIndex);
  //             // if (methodeIndex > 1 && (methodeIndex != 7)) {
  //             //   await methods[methodeIndex](context);
  //             // } else
  //             //   Validate().singleButtonPopup(
  //             //       Global.returnTrLable(
  //             //           locationControlls, CustomText.data_upload_success_msg,
  //             //           lng!),
  //             //       Global.returnTrLable(
  //             //           locationControlls, CustomText.ok, lng!),
  //             //       false,
  //             //       mContext);
  //           }
  //         } else if (responce.statusCode == 401) {
  //           Navigator.pop(mContext);
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           await prefs.remove(Validate.Password);
  //           ScaffoldMessenger.of(mContext).showSnackBar(
  //             SnackBar(
  //                 content: Text(Global.returnTrLable(
  //                     locationControlls, CustomText.token_expired, lng!))),
  //           );
  //           Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (mContext) => LoginScreen(),
  //               ));
  //           // Validate().singleButtonPopup(
  //           //     Global.returnTrLable(
  //           //         locationControlls, CustomText.token_expired, lng!),
  //           //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
  //           //     false,
  //           //     context);
  //         } else {
  //           Navigator.pop(mContext);
  //           await callUploadData();
  //           Validate().singleButtonPopup(
  //               Global.errorBodyToStringFromList(responce.body),
  //               Global.returnTrLable(locationControlls, CustomText.ok, lng!),
  //               false,
  //               context);

  //           return;
  //         }
  //       }
  //     });
  //   } else {
  //     uploadChildGrowthDataSeq1(mContext, methodeIndex);
  //     // if (methodeIndex > 1 && (methodeIndex != 7)) {
  //     //   await methods[methodeIndex](context);
  //     // } else
  //     //   Validate().singleButtonPopup(
  //     //       Global.returnTrLable(
  //     //           locationControlls, CustomText.data_upload_success_msg, lng!),
  //     //       Global.returnTrLable(locationControlls, CustomText.ok, lng!),
  //     //       false,
  //     //       mContext);
  //   }
  // }

  ///Child Growth Monitoring With Referral and follow up
  Future<void> uploadChildGrowthDataSeq1(
      BuildContext mContext, int methodeIndex) async {
    var anthropomertydata =
        await ChildGrowthResponseHelper().callChildGrowthResponses();
    if (anthropomertydata.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.GrowthMonitoring, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${anthropomertydata.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < anthropomertydata.length; i++) {
        var element = anthropomertydata[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);

        // if (element.name != null) {
        var responce = await ChildGrowthMetaUploadApi()
            .childGrowthMetaUpload(token!, jsonEncode(jsonBody));
        if (responce.statusCode == 200) {
          Validate().saveString(
              Validate.dataUploadDateTime, Validate().currentDateTime());
          await updateResponcesChildGrowth(responce, element.responces!);
          if ((anthropomertydata.indexOf(element)) ==
              (anthropomertydata.length - 1)) {
            Navigator.pop(mContext);
            uploadChildReferralDataSeq2(mContext, methodeIndex);
          }
        } else if (responce.statusCode == 401) {
          Navigator.pop(mContext);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove(Validate.Password);
          ScaffoldMessenger.of(mContext).showSnackBar(
            SnackBar(
                content: Text(Global.returnTrLable(
                    locationControlls, CustomText.token_expired, lng!))),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (mContext) => LoginScreen(),
              ));
          // Validate().singleButtonPopup(
          //     Global.returnTrLable(
          //         locationControlls, CustomText.token_expired, lng!),
          //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          //     false,
          //     context);
        } else {
          Navigator.pop(mContext);
          await callUploadData();
          Validate().singleButtonPopup(
              Global.errorBodyToStringFromList(responce.body),
              Global.returnTrLable(locationControlls, CustomText.ok, lng!),
              false,
              context);

          return;
        }
        // } else {
        //   var responce = await ChildGrowthMetaUploadApi()
        //       .childGrowthMetaUpload(token!, jsonEncode(jsonBody));
        //   if (responce.statusCode == 200) {
        //     Validate().saveString(
        //         Validate.dataUploadDateTime, Validate().currentDateTime());
        //     await updateResponcesChildGrowth(responce, element.responces!);
        //     if ((anthropomertydata.indexOf(element)) ==
        //         (anthropomertydata.length - 1)) {
        //       Navigator.pop(mContext);
        //       uploadChildReferralDataSeq2(mContext, methodeIndex);
        //     }
        //   } else if (responce.statusCode == 401) {
        //     Navigator.pop(mContext);
        //     SharedPreferences prefs = await SharedPreferences.getInstance();
        //     await prefs.remove(Validate.Password);
        //     ScaffoldMessenger.of(mContext).showSnackBar(
        //       SnackBar(
        //           content: Text(Global.returnTrLable(
        //               locationControlls, CustomText.token_expired, lng!))),
        //     );
        //     Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (mContext) => LoginScreen(),
        //         ));
        //     // Validate().singleButtonPopup(
        //     //     Global.returnTrLable(
        //     //         locationControlls, CustomText.token_expired, lng!),
        //     //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
        //     //     false,
        //     //     context);
        //   } else {
        //     Navigator.pop(mContext);
        //     await callUploadData();
        //     debugPrint(responce.body);
        //     Validate().singleButtonPopup(
        //         Global.errorBodyToStringFromList(responce.body),
        //         Global.returnTrLable(locationControlls, CustomText.ok, lng!),
        //         false,
        //         context);

        //     return;
        //   }
        // }
      }
    } else {
      uploadChildReferralDataSeq2(mContext, methodeIndex);
    }
  }

  Future<void> uploadChildReferralDataSeq2(
      BuildContext mContext, int methodeIndex) async {
    var referralData =
        await ChildReferralTabResponseHelper().getChildReferralForUpload();
    if (referralData.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.childReferral, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${referralData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < referralData.length; i++) {
        var element = referralData[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
        jsonBody['status'] = '1';
        var itemResponce = jsonEncode(jsonBody);
        if (element.name != null) {
          var responce = await ChildReferralUploadApi()
              .childReferralUploadUpdate(token!, itemResponce, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildReferral(responce);
            if ((referralData.indexOf(element)) == (referralData.length - 1)) {
              Navigator.pop(mContext);
              uploadChildFollowUpDataSeq3(mContext, methodeIndex);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${referralData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await ChildReferralUploadApi()
              .childReferralUpload(token!, itemResponce);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildReferral(responce);
            if ((referralData.indexOf(element)) == (referralData.length - 1)) {
              Navigator.pop(mContext);
              uploadChildFollowUpDataSeq3(mContext, methodeIndex);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${referralData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      uploadChildFollowUpDataSeq3(mContext, methodeIndex);
    }
  }

  Future<void> uploadChildFollowUpDataSeq3(
      BuildContext mContext, int methodeIndex) async {
    var followUpData =
        await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
    if (followUpData.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.fllowUp, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${followUpData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < followUpData.length; i++) {
        var element = followUpData[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);
        jsonBody['status'] = '1';
        var itemResponce = jsonEncode(jsonBody);
        if (element.name != null) {
          var responce = await ChildFollowUpUploadApi()
              .childFollowUpUploadUpdate(token!, itemResponce, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildFollowUp(responce);
            if ((followUpData.indexOf(element)) == (followUpData.length - 1)) {
              Navigator.pop(mContext);
              if (methodeIndex > 4) {
                await methods[methodeIndex](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    mContext);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${followUpData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await ChildFollowUpUploadApi()
              .childFollowUpUpload(token!, itemResponce);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesChildFollowUp(responce);
            if ((followUpData.indexOf(element)) == (followUpData.length - 1)) {
              Navigator.pop(mContext);
              if (methodeIndex > 4) {
                await methods[methodeIndex](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    mContext);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${followUpData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(
            //         locationControlls, CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            //     false,
            //     context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else {
      if (methodeIndex > 4) {
        await methods[methodeIndex](context);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.data_upload_success_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> uploadVillageProfile(BuildContext mContext) async {
    var villageProfileData =
        await VillageProfileResponseHelper().getVillageProfileforUpload();
    if (villageProfileData.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.villageProfile, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${villageProfileData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < villageProfileData.length; i++) {
        var element = villageProfileData[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);

        if (element.name != null) {
          var responce = await VillageProfileMetaApi().callVillageUploadUdate(
              token!, jsonEncode(jsonBody), element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());

            await updateResponcesVillageProfile(responce);

            if ((villageProfileData.indexOf(element)) ==
                (villageProfileData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 17;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount =
                  '$currentItem/${villageProfileData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await VillageProfileMetaApi()
              .villageProfileUpload(token!, jsonEncode(jsonBody));
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateResponcesVillageProfile(responce);

            if ((villageProfileData.indexOf(element)) ==
                (villageProfileData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 17;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount =
                  '$currentItem/${villageProfileData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else if (selectAllOpt == 1) {
      currentUploadStatus = 17;
      await methods[currentUploadStatus](context);
    } else
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
  }

  Future<void> updateResponcesVillageProfile(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await VillageProfileResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadImageFile(BuildContext mContext) async {
    var ImageFileData = await ImageFileTabHelper().getImageForUpload();
    if (ImageFileData.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.imageFiles, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${ImageFileData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < ImageFileData.length; i++) {
        var element = ImageFileData[i];
        var responce = await ImageFileApi().ImageFileUpload(token!, element);
        if (responce.statusCode == 200) {
          Validate().saveString(
              Validate.dataUploadDateTime, Validate().currentDateTime());
          await updateImageResponse(responce);
          if ((ImageFileData.indexOf(element)) == (ImageFileData.length - 1)) {
            Navigator.pop(mContext);
            Validate().singleButtonPopup(
                Global.returnTrLable(locationControlls,
                    CustomText.data_upload_success_msg, lng!),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);
          } else {
            currentItem = currentItem + 1;
            loadingTextUpdatedCount = '$currentItem/${ImageFileData.length}';
            loadingText = Global.returnTrLable(
                locationControlls, CustomText.uploading, lng!);
            loadingText =
                '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
            updateLoadingText(dialogSetState, loadingText);
          }
        } else if (responce.statusCode == 401) {
          Navigator.pop(mContext);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove(Validate.Password);
          ScaffoldMessenger.of(mContext).showSnackBar(
            SnackBar(
                content: Text(Global.returnTrLable(
                    locationControlls, CustomText.token_expired, lng!))),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (mContext) => LoginScreen(),
              ));
        } else {
          Navigator.pop(mContext);
          await callUploadData();
          Validate().singleButtonPopup(
              Global.errorBodyToStringFromList(responce.body),
              Global.returnTrLable(locationControlls, CustomText.ok, lng!),
              false,
              context);

          return;
        }
      }
    } else {
      if (selectAllOpt == 1) {
        selectAllOpt = 0;
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.data_upload_success_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      } else
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
    }
  }

  Future<void> updateImageResponse(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ImageFileTabHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadChildEnrolledExit(BuildContext mContext) async {
    var chilProfiles =
        await EnrolledExitChilrenResponceHelper().callChildrenForUpload();
    if (chilProfiles.length > 0) {
      loadingTextUpdatedText = Global.returnTrLable(
          locationControlls, CustomText.enrollExitChild, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${chilProfiles.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < chilProfiles.length; i++) {
        var element = chilProfiles[i];
        Map<String, dynamic> resultMap = jsonDecode(element.responces!);
        resultMap['status'] = '1';
        var itemResponce = jsonEncode(resultMap);
        if (element.name != null) {
          var responce = await ChildEnrolledExitApi()
              .enrollExitChildUpdate(token!, itemResponce, element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());
            await updateChildEnrollExitResponse(responce);
            if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  mContext);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${chilProfiles.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(locationControlls,
            //         CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await ChildEnrolledExitApi()
              .enrollExitChildUpload(token!, itemResponce);
          if (responce.statusCode == 200) {
            await updateChildEnrollExitResponse(responce);
            if ((chilProfiles.indexOf(element)) == (chilProfiles.length - 1)) {
              Navigator.pop(mContext);
              Validate().singleButtonPopup(
                  Global.returnTrLable(locationControlls,
                      CustomText.data_upload_success_msg, lng!),
                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                  false,
                  mContext);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${chilProfiles.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
            // Validate().singleButtonPopup(
            //     Global.returnTrLable(locationControlls,
            //         CustomText.token_expired, lng!),
            //     Global.returnTrLable(locationControlls, CustomText.ok, lng!), false, context);
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
  }

  Future<void> updateChildEnrollExitResponse(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await EnrolledExitChilrenResponceHelper()
          .updateUploadedChildProfileItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadStock(BuildContext mContext) async {
    var stockData = await StockResponseHelper().getStockForUpload();
    if (stockData.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.Stock, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${stockData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < stockData.length; i++) {
        var element = stockData[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);

        if (element.name == null) {
          var responce =
              await StockApi().stockUploadApi(token!, jsonEncode(jsonBody));
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());

            await updateStockResponse(responce);

            if ((stockData.indexOf(element)) == (stockData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 18;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${stockData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await StockApi()
              .stockUpdateApi(token!, jsonEncode(jsonBody), element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());

            await updateStockResponse(responce);

            if ((stockData.indexOf(element)) == (stockData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 18;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount = '$currentItem/${stockData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else if (selectAllOpt == 1) {
      currentUploadStatus = 18;
      await methods[currentUploadStatus](context);
    } else
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
  }

  Future<void> updateStockResponse(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await StockResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> uploadRequisition(BuildContext mContext) async {
    var requisitionData =
        await RequisitionResponseHelper().getRequisitonsForUpload();
    if (requisitionData.length > 0) {
      loadingTextUpdatedText =
          Global.returnTrLable(locationControlls, CustomText.requisition, lng!);
      int currentItem = 1;
      var token = await Validate().readString(Validate.appToken);
      loadingTextUpdatedCount = '$currentItem/${requisitionData.length}';
      loadingText =
          Global.returnTrLable(locationControlls, CustomText.uploading, lng!);
      loadingText =
          '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
      showLoaderDialog(context);
      for (int i = 0; i < requisitionData.length; i++) {
        var element = requisitionData[i];
        Map<String, dynamic> jsonBody = jsonDecode(element.responces!);

        if (element.name == null) {
          var responce = await RequisitionApi()
              .requisitionUploadApi(token!, jsonEncode(jsonBody));
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());

            await updateRequisitionData(responce);

            if ((requisitionData.indexOf(element)) ==
                (requisitionData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 19;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount =
                  '$currentItem/${requisitionData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        } else {
          var responce = await RequisitionApi()
              .requisitionUpdateApi(token!, jsonEncode(jsonBody), element.name);
          if (responce.statusCode == 200) {
            Validate().saveString(
                Validate.dataUploadDateTime, Validate().currentDateTime());

            await updateRequisitionData(responce);

            if ((requisitionData.indexOf(element)) ==
                (requisitionData.length - 1)) {
              Navigator.pop(mContext);
              if (selectAllOpt == 1) {
                currentUploadStatus = 19;
                await methods[currentUploadStatus](context);
              } else
                Validate().singleButtonPopup(
                    Global.returnTrLable(locationControlls,
                        CustomText.data_upload_success_msg, lng!),
                    Global.returnTrLable(
                        locationControlls, CustomText.ok, lng!),
                    false,
                    context);
            } else {
              currentItem = currentItem + 1;
              loadingTextUpdatedCount =
                  '$currentItem/${requisitionData.length}';
              loadingText = Global.returnTrLable(
                  locationControlls, CustomText.uploading, lng!);
              loadingText =
                  '$loadingText, $loadingTextUpdatedText $loadingTextUpdatedCount';
              updateLoadingText(dialogSetState, loadingText);
            }
          } else if (responce.statusCode == 401) {
            Navigator.pop(mContext);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(Validate.Password);
            ScaffoldMessenger.of(mContext).showSnackBar(
              SnackBar(
                  content: Text(Global.returnTrLable(
                      locationControlls, CustomText.token_expired, lng!))),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (mContext) => LoginScreen(),
                ));
          } else {
            Navigator.pop(mContext);
            await callUploadData();
            Validate().singleButtonPopup(
                Global.errorBodyToStringFromList(responce.body),
                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                false,
                context);

            return;
          }
        }
      }
    } else if (selectAllOpt == 1) {
      currentUploadStatus = 19;
      await methods[currentUploadStatus](context);
    } else
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nothing_for_upload_msg, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
  }

  Future<void> updateRequisitionData(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await RequisitionResponseHelper().updateUploadedItem(resultMap);
      await callUploadData();
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<int> callCountForUpload() async {
    var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
    var chilProfiles =
        await EnrolledChilrenResponceHelper().callChildrenForUpload();
    var crecheProfile = await CrecheDataHelper().callCrecheForUpload();
    var chilAttendence =
        await ChildAttendanceResponceHelper().callChildAttendencesAllForUpoad();
    var crecheCheckIn =
        await CheckInResponseHelper().callCrecheCheckInResponses();
    var anthropomentry =
        await ChildGrowthResponseHelper().callChildGrowthResponsesForUpload();
    var childeventResponses =
        await ChildEventTabResponceHelper().getEditedChildEventsForUpload();
    var childImmunizationDAta =
        await ChildImmunizationResponseHelper().getChildImmunizationForUpload();
    var childHeathData =
        await ChildHealthTabResponceHelper().getChildHealthForUpload();
    var childexitdata =
        await ChildExitResponceHelper().getEditedChildExitForUpload();
    var grievanceData =
        await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
    var creCheMonitoring =
        await CrecheMonitorResponseHelper().getCrecheResponseForUpload();
    var referralData =
        await ChildReferralTabResponseHelper().getChildReferralForUpload();
    var followUpData =
        await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
    var ccmData =
        await CrecheCommittieResponnseHelper().getCrecheCommittieForUpload();
    var cashBookDataExpences = await CashBookResponseExpencesHelper()
        .getEditedCashBookForExpenceUpload();

    var cashBookDataReciept = await CashBookReceiptResponseHelper()
        .getEditedCashBookReceiptForUpload();
    var ImageFileData = await ImageFileTabHelper().getImageForUpload();

    var villageProfiles =
        await VillageProfileResponseHelper().getVillageProfileforUpload();
    var childEnrollExitData =
        await EnrolledExitChilrenResponceHelper().callChildrenForUpload();
    var stockData = await StockResponseHelper().getStockForUpload();
    var requisitionData =
        await RequisitionResponseHelper().getRequisitonsForUpload();

    hhItems = hhItems
        .where((element) =>
            Global.stringToInt(Global.getItemValues(
                element.responces!, 'verification_status')) >
            1)
        .toList();

    int totalPendingCount = hhItems.length +
        // chilProfiles.length +
        crecheProfile.length +
        chilAttendence.length +
        crecheCheckIn.length +
        anthropomentry.length +
        childeventResponses.length +
        childImmunizationDAta.length +
        childHeathData.length +
        childexitdata.length +
        grievanceData.length +
        creCheMonitoring.length +
        referralData.length +
        followUpData.length +
        ccmData.length +
        cashBookDataExpences.length +
        villageProfiles.length +
        ImageFileData.length +
        cashBookDataReciept.length +
        childEnrollExitData.length +
        stockData.length +
        requisitionData.length;

    return totalPendingCount;
  }

  void updateLoadingText(StateSetter setState, String newText) {
    print(newText);
    setState(() {
      loadingText = newText;
    });
  }
}
