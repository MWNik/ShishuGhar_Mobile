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
import 'package:shishughar/screens/tabed_screens/attendence/attendance_listed_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checkList_cbm/all_creche_monitering_checklist_CBM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_CC/all_creche_monitering_checklist_CC_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_alm/all_creche_monitering_checklist_ALM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitor/all_creche_monitor_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/enrolled_exit_child/enrolled_exit_child_listing_tab.dart';
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
import '../api/master_api.dart';
import '../api/village_profile_meta_api.dart';
import '../custom_widget/custom_btn.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_custom_checkbox.dart';
import '../custom_widget/single_poup_dailog.dart';
import '../database/helper/anthromentory/child_growth_response_helper.dart';
import '../database/helper/backdated_configiration_helper.dart';
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
import '../model/apimodel/backdated_configiration_api_model.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../model/databasemodel/backdated_configiration_model.dart';
import '../model/databasemodel/child_attendance_responce_model.dart';
import '../model/dynamic_screen_model/creche_monitor_response_model.dart';
import '../model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
import '../model/dynamic_screen_model/house_hold_tab_responce_model.dart';
import '../utils/validate.dart';
import 'linelistedhouseholld.dart';
import 'login_screen.dart';

class DarftDataScreen extends StatefulWidget {
  const DarftDataScreen({super.key});

  @override
  State<DarftDataScreen> createState() => _DarftDataScreenState();
}

class _DarftDataScreenState extends State<DarftDataScreen> {
  Map<String, dynamic> syncInfo = {};
  String? userRole;
  String? lng;
  bool _isLoading = true;
  List<Translation> locationControlls = [];
  List<Future<void> Function(BuildContext)> methods = [];

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    if (_isLoading) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    } else {
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, 'itemRefresh');
            return true;
          },
          child: Scaffold(
            appBar: CustomAppbar(
              text: (lng != null)
                  ? Global.returnTrLable(locationControlls, CustomText.darftData, lng!)
                  : "",
              onTap: () async {
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
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: syncInfo.isEmpty?Center(child: Text(Global.returnTrLable(
                        locationControlls, CustomText.NorecordAvailable, lng!)),
                    ):ListView.builder(
                        itemCount: syncInfo.keys.toList().length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              onClickItems(syncInfo.keys.toList()[index]);
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
                                                '${getDataBykey(syncInfo.keys.toList()[index],'title')} : ',
                                                style: Styles
                                                    .urbanblack157,
                                                children: parseBoldText(
                                                    syncInfo.keys.toList()[index],
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
                                          Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Colors.grey,
                                          )
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
                ],
              ),
            ]),
          ),
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
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



  Future<void> initializeData() async {
    lng = await Validate().readString(Validate.sLanguage);
    userRole = await Validate().readString(Validate.role);
    List<String> valueNames = [
      CustomText.recordsForDraft,
      CustomText.recordForDraft,
      CustomText.HHListing,
      CustomText.sync,
      CustomText.ok,
      CustomText.uploadingPleaseWait,
      CustomText.token_expired,
      CustomText.ChildProfile,
      CustomText.CrecheProfileView,
      CustomText.nointernetconnectionavailable,
      CustomText.uploading,
      CustomText.childAttendance,
      CustomText.houseHoldChildForm,
      CustomText.houseHoldForm,
      CustomText.VisitNotes,
      CustomText.enrollExitChild,
      CustomText.unsynched,
      CustomText.darftData,
      CustomText.dataNotFoundYet,
    ];

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => locationControlls.addAll(value));

    callGetDraftData();


  }

  Future callGetDraftData() async{
    syncInfo={};
    if (userRole == 'Creche Supervisor') {
    var chilAttendence =
    await ChildAttendanceResponceHelper().callChildAttendencesAllForDarft();
    var creCheMonitoring =
    await CrecheMonitorResponseHelper().getCrecheResponseForDraft();
    var chilProfiles =
    await EnrolledExitChilrenResponceHelper().callChildrenForDraft();
    var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
    var hhDartItems=hhItems
        .where((element) =>
        Global.stringToInt(Global.getItemValues(
            element.responces, 'verification_status')) ==
            1)
        .toList();
    if(hhDartItems.length>0){
      syncInfo['hhProfile']={
        'title': Global.returnTrLable(locationControlls, CustomText.HHListing, lng!),
        'count':hhDartItems.length,
        'items':hhDartItems
      };
    }
    if(chilProfiles.length>0){
      syncInfo['enrollExitChild']={
        'title': Global.returnTrLable(locationControlls, CustomText.enrollExitChild, lng!),
        'count':chilProfiles.length,
        'items':chilProfiles
      };
    }
    if(chilAttendence.length>0){
      syncInfo['childAttendence']={
        'title': Global.returnTrLable(locationControlls, CustomText.childAttendence, lng!),
        'count':chilAttendence.length,
        'items':chilAttendence
      };
    }
    if(creCheMonitoring.length>0){
      syncInfo['VisitNotes']={
        'title': Global.returnTrLable(locationControlls, CustomText.VisitNotes, lng!),
        'count':creCheMonitoring.length,
        'items':creCheMonitoring
      };
    }
    }
    else if (userRole == 'Cluster Coordinator') {
      var cmcCCData = await CmcCCTabResponseHelper().getCcForDarft();
      if(cmcCCData.length>0){
        syncInfo['VisitNotes']={
          'title': Global.returnTrLable(locationControlls, CustomText.VisitNotes, lng!),
          'count':cmcCCData.length,
          'items':cmcCCData
        };
      }
    }
    else if (userRole == 'Accounts and Logistics Manager') {
      var cmcALMData = await CmcALMTabResponseHelper().getAlmForDraft();
      if(cmcALMData.length>0){
        syncInfo['VisitNotes']={
          'title': Global.returnTrLable(locationControlls, CustomText.VisitNotes, lng!),
          'count':cmcALMData.length,
          'items':cmcALMData

        };
      }
    }
    else if (userRole == 'Capacity and Building Manager') {
      var cmcCBMData = await CmcCBMTabResponseHelper().getCBMForDraft();
      if(cmcCBMData.length>0){
        syncInfo['VisitNotes']={
          'title': Global.returnTrLable(locationControlls, CustomText.VisitNotes, lng!),
          'count':cmcCBMData.length,
          'items':cmcCBMData
        };
      }
    }
    _isLoading=false;
    setState(() {});
  }

 String getDataBykey(String indexKey,String key){
    return syncInfo[indexKey][key].toString();
 }




  List<TextSpan> parseBoldText(String key, TextStyle normalStyle,
      TextStyle boldStyle, TextStyle redboldStyle) {
    final List<TextSpan> spans = [];
    spans.add(TextSpan(
        text: ' ${getDataBykey(key,'count')} ',
        style:  redboldStyle));

    spans.add(TextSpan(
        text: Global.stringToInt(getDataBykey(key,'count')) > 1?Global.returnTrLable(locationControlls,
            CustomText.recordsForDraft, lng!):Global.returnTrLable(locationControlls, CustomText.recordForDraft, lng!),
        style: Global.stringToInt(getDataBykey(key,'count')) > 0
            ? normalStyle
            : boldStyle));

    return spans;
  }


    onClickItems(key) async {
      String refreshStatus = '';
      if(key=='hhProfile'&& userRole == 'Creche Supervisor'){
        List<HouseHoldTabResponceMosdel> data=syncInfo[key]['items'] as List<HouseHoldTabResponceMosdel>;
        HouseHoldTabResponceMosdel item=data.first;
        if(item.creche_id!=null){
          refreshStatus = await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LineholdlistedScreen(
                crecheId: item.creche_id!,isDraft: true,
              )));
        }
      }
      else if(key=='enrollExitChild'&& userRole == 'Creche Supervisor'){
        List<EnrolledExitChildResponceModel> data=syncInfo[key]['items'] as List<EnrolledExitChildResponceModel>;
        EnrolledExitChildResponceModel item=data.first;
        if(item.creche_id!=null){
          refreshStatus = await  Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => EnrolledExitChildListingTab(
                  creCheId: item.creche_id!,isDraft: true,
                  village_id:
                  Global.getItemValues(item.responces!, 'village_id'))));
        }
      }
      else if(key=='childAttendence'&& userRole == 'Creche Supervisor'){
        List<ChildAttendanceResponceModel> data=syncInfo[key]['items'] as List<ChildAttendanceResponceModel>;
        ChildAttendanceResponceModel item=data.first;
        if(item.creche_id!=null){
          refreshStatus = await  Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AttendanceListedScreen(
                creche_nameId: item.creche_id,isDraft: true,
                creche_name: Global.getItemValues(item.responces!, 'creche_name')
              )));
        }
      }
      else if(key=='VisitNotes'&& userRole == 'Creche Supervisor'){
          refreshStatus = await  Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AllCrecheMonitorListingScreen(isDraft: true,
              )));
      }
      else if(key=='VisitNotes'&& userRole == 'Cluster Coordinator'){
        refreshStatus = await  Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AllcmcCCListingScreen(isDraft: true,
            )));
      }
      else if(key=='VisitNotes'&& userRole == 'Accounts and Logistics Manager'){
        refreshStatus = await  Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AllcmcALMListingScreen(isDraft: true,
            )));
      }
      else if(key=='VisitNotes'&& userRole == 'Capacity and Building Manager'){
        List<CrecheMonitorResponseModel> data=syncInfo[key] as List<CrecheMonitorResponseModel>;
        CrecheMonitorResponseModel item=data.first;
        if(item.creche_id!=null){
          refreshStatus = await  Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AllcmcCBMListingScreen(isDraft: true,
              )));
        }
      }

      if (refreshStatus == 'itemRefresh') {
        await callGetDraftData();
      }
      if(syncInfo.isEmpty){
        bool? shouldProceed = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return SingleButtonPopupDialog(
                message: Global.returnTrLable(
                    locationControlls, CustomText.dataNotFoundYet, lng!),
                button:
                Global.returnTrLable(locationControlls, CustomText.ok, lng!));
          },
        );
        if(shouldProceed!=null){
          Navigator.pop(context, 'itemRefresh');
        }else Navigator.pop(context, 'itemRefresh');
      }
    }




}
