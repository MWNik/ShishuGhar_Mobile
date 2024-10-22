import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/api/requisition_api.dart';
import 'package:shishughar/api/stock_api.dart';

import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/cashbook/expences/cashbook_excepnces_meta_fileds_helper.dart';
import 'package:shishughar/database/helper/cashbook/expences/cashbook_response_expences_helper.dart';
import 'package:shishughar/database/helper/form_logic_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_fields_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
import 'package:shishughar/database/helper/stock/stock_fields_helper.dart';
import 'package:shishughar/database/helper/stock/stock_response_helper.dart';

import 'package:shishughar/model/apimodel/cashbook_receipt_fields_meta_model.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/requisition_fields_meta_model.dart';
import 'package:shishughar/model/apimodel/stock_fields_meta_model.dart';

import 'package:shishughar/screens/pad_viewer_using_dio.dart';
import 'package:shishughar/screens/shishu_ghar_screen.dart';
import 'package:shishughar/screens/synchronization_screen.dart';
import 'package:shishughar/screens/tabed_screens/child_follow_up/child_followup_completed_list_CC.dart';
import 'package:shishughar/screens/tabed_screens/child_follow_up/follow_up_tab_screen_all_child.dart';
import 'package:shishughar/screens/tabed_screens/child_gravience/child_grievance_home_listing.dart';
import 'package:shishughar/screens/tabed_screens/child_reffrel/referral_completed_listing_CC.dart';
import 'package:shishughar/screens/tabed_screens/child_reffrel/reffral_tab_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checkList_cbm/all_creche_monitering_checklist_CBM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_CC/all_creche_monitering_checklist_CC_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_alm/all_creche_monitering_checklist_ALM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitor/all_creche_monitor_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/village_profile/village_profile_listing_screen.dart';
import 'package:shishughar/screens/user_my_profile_details.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/constants.dart';
import 'package:shishughar/utils/get_Location.dart';
import 'package:shishughar/utils/secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/attendance_meta_api.dart';
import '../api/cashBook_expenses_api.dart';
import '../api/cashbook_receipt_api.dart';
import '../api/child_Grievances_meta_api.dart';
import '../api/child_enrolled_exit_api.dart';
import '../api/child_event_meta_api.dart';
import '../api/child_exit_meta_api.dart';
import '../api/child_followup_meta_api.dart';
import '../api/child_growth_meta_api.dart';
import '../api/child_health_meta_api.dart';
import '../api/child_hh_meta_api.dart';
import '../api/child_immunization_meta_api.dart';
import '../api/child_referral_meta_api.dart';
import '../api/creche_Monitering_checkList_ALM_api.dart';
import '../api/creche_checkIn_api.dart';
import '../api/creche_committie_meta_api.dart';
import '../api/creche_monetering_checkList_cbm_api.dart';
import '../api/creche_monitering_checklist_cc_api.dart';
import '../api/creche_monitoring_api.dart';
import '../api/form_logic_api.dart';
import '../api/house_hold_fields_api.dart';
import '../api/modified_date_api.dart';
import '../api/village_profile_meta_api.dart';
import '../database/database_helper.dart';
import '../database/helper/anthromentory/child_growth_meta_fields_helper.dart';
import '../database/helper/anthromentory/child_growth_response_helper.dart';
import '../database/helper/cashbook/receipt/cashbook_receipt_response_helper.dart';
import '../database/helper/check_in/check_in_response_helper.dart';
import '../database/helper/check_in/checkin_meta_helper.dart';
import '../database/helper/child_attendence/child_attendance_field_helper.dart';
import '../database/helper/child_attendence/child_attendance_helper_responce.dart';
import '../database/helper/child_event/child_event_meta_fields_helper.dart';
import '../database/helper/child_event/child_event_response_helper.dart';
import '../database/helper/child_exit/child_exit_meta_fields_helper.dart';
import '../database/helper/child_exit/child_exit_response_Helper.dart';
import '../database/helper/child_gravience/child_grievances_field_helper.dart';
import '../database/helper/child_gravience/child_grievances_response_helper.dart';
import '../database/helper/child_health/child_health_meta_fields_helper.dart';
import '../database/helper/child_health/child_health_response_helper.dart';
import '../database/helper/child_immunization/child_immunization_meta_fileds_helper.dart';
import '../database/helper/child_immunization/child_immunization_response_helper.dart';
import '../database/helper/child_reffrel/child_refferal_fields_helper.dart';
import '../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../database/helper/cmc_CC/creche_monitering_checklist_CC_fields_helper.dart';
import '../database/helper/cmc_CC/creche_monitering_checklist_CC_response_helper.dart';
import '../database/helper/cmc_alm/creche_monitering_checkList_ALM_fields_helper.dart';
import '../database/helper/cmc_alm/creche_monitering_checkList_ALM_response_helper.dart';
import '../database/helper/cmc_cbm/creche_monitering_checklist_CBM_fields_helper.dart';
import '../database/helper/cmc_cbm/creche_monitering_checklist_CBM_response_helper.dart';
import '../database/helper/creche_comite_meeting/creche_committe_fields_meta_helper.dart';
import '../database/helper/creche_comite_meeting/creche_committie_response_helper.dart';
import '../database/helper/creche_data_helper.dart';
import '../database/helper/creche_helper/creche_data_helper.dart';
import '../database/helper/creche_monitoring/creche_monitoring_helper.dart';
import '../database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
import '../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import '../database/helper/enrolled_children/enrolled_children_field_helper.dart';
import '../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import '../database/helper/enrolled_exit_child/enrolled_exit_children_field_helper.dart';
import '../database/helper/follow_up/child_followUp_fields_helper.dart';
import '../database/helper/follow_up/child_followUp_response_helper.dart';
import '../database/helper/house_field_item_helper.dart';
import '../database/helper/image_file_tab_responce_helper.dart';
import '../database/helper/modifieddatahelper.dart';

import '../database/helper/translation_language_helper.dart';
import '../database/helper/user_manual_fields_meta_helper.dart';
import '../database/helper/village_profile/village_profiile_fileds_helper.dart';
import '../database/helper/village_profile/village_profile_response_helper.dart';
import '../model/apimodel/cashbook_expenses_fields_meta_model.dart';
import '../model/apimodel/checkin_fields_meta_model.dart';
import '../model/apimodel/child_Immunization_meta_fields_model.dart';
import '../model/apimodel/child_attendance_field_model.dart';
import '../model/apimodel/child_event_meta_fields_model.dart';
import '../model/apimodel/child_exit_meta_fields_model.dart';
import '../model/apimodel/child_followUp_meta_fields_model.dart';
import '../model/apimodel/child_grievances_fields_model.dart';
import '../model/apimodel/child_growth_meta_model.dart';
import '../model/apimodel/child_referral_fields_model.dart';
import '../model/apimodel/cmc_CBM_meta_fields _model.dart';
import '../model/apimodel/cmc_CC_Meta_fields_model.dart';
import '../model/apimodel/creche_committe_meta_fields_model.dart';
import '../model/apimodel/creche_data_model.dart';
import '../model/apimodel/creche_monitering_checklist_ALM_fields_model.dart';
import '../model/apimodel/creche_monitoring_meta_model.dart';
import '../model/apimodel/enrolled_children_field_model.dart';
import '../model/apimodel/enrolled_exit_field_model.dart';
import '../model/apimodel/house_hold_field_model_api.dart';
import '../model/apimodel/modifiedDate_apiModel.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../model/apimodel/child_health_meta_data_Api_Model.dart';
import '../model/apimodel/village_profile_meta_fields_model.dart';
import '../model/dynamic_screen_model/user_manual_responses_model.dart';
import '../utils/globle_method.dart';
import '../utils/validate.dart';
import 'change_password_screen.dart';
import 'dashboardscreen_new.dart';
import 'login_screen.dart';

class HomeReplicaScreen extends StatefulWidget {
  static GlobalKey<ScaffoldState>? scaffoldKey;

  const HomeReplicaScreen({super.key});

  @override
  State<HomeReplicaScreen> createState() => _HomeReplicaScreenState();
}

class _HomeReplicaScreenState extends State<HomeReplicaScreen> {
  List<String> text = [];
  List<String> image = [];
  String? village;
  String? Creche;
  bool isConnected = false;
  var village_txt = "";
  String? role;
  String? lng;
  var change_language_text = "";
  int syncCount = 0;
  int countVerifyForPending = 0;
  String username = '';
  String fullName = '';
  List<Translation> locationControlls = [];
  String appVersionName = '';

  @override
  Widget build(BuildContext context) {
    HomeReplicaScreen.scaffoldKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: () async {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginScreen()),
        // );
        setState(() {});
        return true;
      },
      child: Scaffold(
        key: HomeReplicaScreen.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xff5979AA),
          leading: InkWell(
            onTap: () {
              HomeReplicaScreen.scaffoldKey!.currentState?.openDrawer();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Image.asset(
                "assets/menu_icon.png",
                color: Colors.white,
                scale: 3,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            lng != null
                ? Global.returnTrLable(
                    locationControlls, CustomText.ShishuGharDetails, lng!)
                : '',
            style: Styles.white145,
          ),
          actions: [
            isConnected
                ? Image.asset(
                    "assets/online.png",
                    scale: 2,
                  )
                : Image.asset("assets/offline.png", scale: 2),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        SynchronizationScreen()));
              },
              child: Stack(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      "assets/reset.png",
                      scale: 3,
                    ),
                  ),
                  syncCount > 0
                      ? Positioned(
                          top: 0,
                          bottom: 24,
                          left: 20,
                          right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffF26BA3),
                            ),
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "$syncCount",
                              style: Styles.white74P,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Visibility(
              child: Stack(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      "assets/notification.png",
                      scale: 3,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 24,
                    left: 20,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffF26BA3),
                      ),
                      padding: EdgeInsets.all(4),
                      child: Text(
                        '1',
                        style: Styles.white74P,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
        drawer: Drawer(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 40,
                    ),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xffF2F7FF),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () async {
                              HomeReplicaScreen.scaffoldKey!.currentState
                                  ?.closeDrawer();
                            },
                            child: Image.asset(
                              'assets/cross.png',
                              color: Colors.grey,
                              scale: 4,
                            )),
                        // child: Image.memory(bytes:Validate().imageBase64Toimage())),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: false,
                                child: Container(
                                    height: 46.h,
                                    width: 46.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Image.asset(
                                      'assets/childrenenrolled.png',
                                    )),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("$fullName", style: Styles.black126P),
                                  Text("$username", style: Styles.black126P),
                                  Text("$role", style: Styles.Grey104),
                                ],
                              )
                            ]),
                      ],
                    )),
                Expanded(
                  child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                            lng != null
                                ? Global.returnTrLable(locationControlls,
                                    CustomText.MyProfile, lng!)
                                : '',
                            style: Styles.black125,
                          ),
                          onTap: () {
                            HomeReplicaScreen.scaffoldKey!.currentState
                                ?.closeDrawer();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserDetailsScreen(
                                          isEdit: true,
                                        )));
                            // _showLanguageDialog(context);
                          },
                        ),
                        Visibility(
                          visible: true,
                          child: Divider(
                            color: Color(0xffEEEEEE),
                            indent: 15,
                            endIndent: 15,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.lock),
                          title: Text(
                            lng != null
                                ? Global.returnTrLable(locationControlls,
                                    CustomText.ChangePassword, lng!)
                                : '',
                            style: Styles.black125,
                          ),
                          onTap: () {
                            HomeReplicaScreen.scaffoldKey!.currentState
                                ?.closeDrawer();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePasswordScreen()),
                            );
                          },
                        ),
                        Visibility(
                          visible: true,
                          child: Divider(
                            color: Color(0xffEEEEEE),
                            indent: 15,
                            endIndent: 15,
                          ),
                        ),
                        ExpansionTile(
                          leading: const Icon(Icons.language),
                          title: Text(
                            lng != null
                                ? Global.returnTrLable(locationControlls,
                                    CustomText.languages, lng!)
                                : '',
                            style: Styles.black125,
                          ),
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                lng != null
                                    ? Global.returnTrLable(locationControlls,
                                        CustomText.English, lng!)
                                    : '',
                                style: Styles.Grey10,
                              ),
                              onTap: () async {
                                HomeReplicaScreen.scaffoldKey!.currentState
                                    ?.closeDrawer();
                                Validate().saveString(Validate.sLanguage, 'en');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashboardScreen(
                                            index: 0,
                                          )),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                lng != null
                                    ? Global.returnTrLable(locationControlls,
                                        CustomText.Hindi, lng!)
                                    : '',
                                style: Styles.Grey10,
                              ),
                              onTap: () async {
                                HomeReplicaScreen.scaffoldKey!.currentState
                                    ?.closeDrawer();
                                Validate().saveString(Validate.sLanguage, 'hi');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashboardScreen(
                                            index: 0,
                                          )),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                lng != null
                                    ? Global.returnTrLable(locationControlls,
                                        CustomText.Odiya, lng!)
                                    : '',
                                style: Styles.Grey10,
                              ),
                              onTap: () async {
                                HomeReplicaScreen.scaffoldKey!.currentState
                                    ?.closeDrawer();
                                Validate().saveString(Validate.sLanguage, 'od');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashboardScreen(
                                            index: 0,
                                          )),
                                );
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: true,
                          child: Divider(
                            color: Color(0xffEEEEEE),
                            indent: 15,
                            endIndent: 15,
                          ),
                        ),
                        ExpansionTile(
                          leading: Image.asset(
                            'assets/user_manual.png',
                            color: Colors.black,
                            scale: 1.5,
                          ),
                          title: Text(
                            lng != null
                                ? Global.returnTrLable(locationControlls,
                                    CustomText.userMannual, lng!)
                                : '',
                            style: Styles.black125,
                          ),
                          onExpansionChanged: (value) {},
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                lng != null
                                    ? Global.returnTrLable(locationControlls,
                                        CustomText.English, lng!)
                                    : '',
                                style: Styles.Grey10,
                              ),
                              onTap: () async {
                                List<UserManualResponsesModel> responce =
                                    await UserManualFieldsHelper()
                                        .getResponsebylang('English');
                                String url = responce[0].url ?? '';
                                if (Global.validString(url)) {
                                  showLoaderDialog(context);
                                  await PDFDownloaderState()
                                      .downloadAndOpenPDF(url, context);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            ListTile(
                              title: Text(
                                lng != null
                                    ? Global.returnTrLable(locationControlls,
                                        CustomText.Hindi, lng!)
                                    : '',
                                style: Styles.Grey10,
                              ),
                              onTap: () async {
                                List<UserManualResponsesModel> responce =
                                    await UserManualFieldsHelper()
                                        .getResponsebylang('Hindi');
                                String url = responce[0].url ?? '';
                                if (Global.validString(url)) {
                                  showLoaderDialog(context);
                                  await PDFDownloaderState()
                                      .downloadAndOpenPDF(url, context);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            ListTile(
                              title: Text(
                                lng != null
                                    ? Global.returnTrLable(locationControlls,
                                        CustomText.Odiya, lng!)
                                    : '',
                                style: Styles.Grey10,
                              ),
                              onTap: () async {
                                List<UserManualResponsesModel> responce =
                                    await UserManualFieldsHelper()
                                        .getResponsebylang('Odia');
                                String url = responce[0].url ?? '';
                                if (Global.validString(url)) {
                                  showLoaderDialog(context);
                                  await PDFDownloaderState()
                                      .downloadAndOpenPDF(url, context);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: true,
                          child: Divider(
                            color: Color(0xffEEEEEE),
                            indent: 15,
                            endIndent: 15,
                          ),
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/app_info.png',
                            color: Colors.black,
                            scale: 1.5,
                          ),
                          title: Text(
                            lng != null
                                ? Global.returnTrLable(
                                    locationControlls, CustomText.appInfo, lng!)
                                : '',
                            style: Styles.black125,
                          ),
                          onTap: () {
                            HomeReplicaScreen.scaffoldKey!.currentState
                                ?.closeDrawer();
                            // _showLanguageDialog(context);
                          },
                        ),
                        Visibility(
                          visible: true,
                          child: Divider(
                            color: Color(0xffEEEEEE),
                            indent: 15,
                            endIndent: 15,
                          ),
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/grievance.png',
                            color: Colors.black,
                            scale: 5.5,
                          ),
                          title: Text(
                            lng != null
                                ? Global.returnTrLable(locationControlls,
                                    CustomText.ticketSupport, lng!)
                                : '',
                            style: Styles.black125,
                          ),
                          onTap: () async {
                            HomeReplicaScreen.scaffoldKey!.currentState
                                ?.closeDrawer();
                            var network =
                                await Validate().checkNetworkConnection();
                            if (network) {
                              _launchInBrowser(Constants.tickcetSupport);
                            } else {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(
                                      locationControlls,
                                      CustomText.nointernetconnectionavailable,
                                      lng!),
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lng!),
                                  false,
                                  context);
                            }
                            // _showLanguageDialog(context);
                          },
                        ),
                        Visibility(
                          visible: true,
                          child: Divider(
                            color: Color(0xffEEEEEE),
                            indent: 15,
                            endIndent: 15,
                          ),
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/database_ic.png',
                            color: Colors.black,
                            scale: 1.5,
                          ),
                          title: Text(
                            lng != null
                                ? Global.returnTrLable(locationControlls,
                                    CustomText.dbBackup, lng!)
                                : '',
                            style: Styles.black125,
                          ),
                          onTap: () async {
                            HomeReplicaScreen.scaffoldKey!.currentState
                                ?.closeDrawer();
                            // _showLanguageDialog(context);
                            // throw Exception();
                            await Validate().createDbBackup();
                          },
                        ),
                        Visibility(
                          visible: true,
                          child: Divider(
                            color: Color(0xffEEEEEE),
                            indent: 15,
                            endIndent: 15,
                          ),
                        ),
                        ListTile(
                            leading: Image.asset(
                              "assets/logout.png",
                              scale: 3,
                            ),
                            title: Text(
                              lng != null
                                  ? Global.returnTrLable(locationControlls,
                                      CustomText.Logout, lng!)
                                  : '',
                              style: Styles.red125,
                            ),
                            onTap: () async {
                              if (syncCount > 0) {
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(locationControlls,
                                        CustomText.logoutPendingDataMsg, lng!),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lng!),
                                    false,
                                    context);
                              } else
                              {
                                var darftData=await callDarftData();
                                if(darftData==0){
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                showLoaderDialog(context);
                                await prefs.clear();
                                await DatabaseHelper().deleteAllRecords();
                                Navigator.pop(context);

                                HomeReplicaScreen.scaffoldKey!.currentState
                                    ?.closeDrawer();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (Route<dynamic> route) => false);
                              }else Validate().singleButtonPopup(
                                    Global.returnTrLable(locationControlls,
                                        CustomText.darftDataForLogoyt, lng!),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lng!),
                                    false,
                                    context);
                              }
                              ;
                            }),
                        Divider(
                          color: Color(0xffEEEEEE),
                          indent: 15,
                          endIndent: 15,
                        ),
                      ]),
                ),
                Center(
                  child: GestureDetector(
                    onDoubleTap: () async {
                      HomeReplicaScreen.scaffoldKey!.currentState
                          ?.closeDrawer();
                      var databaseDir =
                          Directory('${Constants.uploadeJsonFile}json_.txt');
                      File file = File(databaseDir.path);
                      var status = await file.exists();
                      if (status) {
                        await Validate().shareFile(file);
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                        text: CustomText.Version,
                        style: Styles.black124,
                        children: <TextSpan>[
                          TextSpan(
                              text: "$appVersionName", style: Styles.black126P),
                          Constants.baseUrl == 'https://uat.shishughar.in/api/'
                              ? TextSpan(text: "  (UAT)", style: Styles.red125)
                              : Constants.baseUrl ==
                                      'https://shishughar.in/api/'
                                  ? TextSpan(text: "", style: Styles.red125)
                                  : TextSpan(
                                      text: "  (DEV)", style: Styles.red125),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                )
              ],
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              ListView.builder(
                  itemCount: 0,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff62ADA8),
                            borderRadius: BorderRadius.circular(5.r)),
                        height: 64.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 3.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              index == 0
                                  ? Image.asset(
                                      "assets/watch.png",
                                      height: 55.h,
                                      width: 55.w,
                                    )
                                  : Image.asset(
                                      "assets/Thumbs.png",
                                      height: 55.h,
                                      width: 55.w,
                                    ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      index == 0
                                          ? CustomText.Activities
                                          : CustomText.FollowUps,
                                      style: Styles.white126P,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              SizedBox(
                height: 5.h,
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
                        onclick(i, image[i], lng!);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff5A5A5A).withOpacity(
                                    0.1), // Shadow color with opacity
                                offset: Offset(
                                    0, 1), // Horizontal and vertical offset
                                blurRadius: 5, // Blur radius
                                spreadRadius: 0, // Spread radius
                              ),
                            ],
                            color: Color(0xffF2F7FF),
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                              color: Color(0xffE7F0FF),
                            )),
                        height: 168.h,
                        width: 146.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: true,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 40,
                                          // child: Image.asset(
                                          //   image[i],
                                          //   filterQuality: FilterQuality.high,
                                          //   scale: image[i] ==
                                          //               'assets/verifydata.png' ||
                                          //           image[i] ==
                                          //               'assets/creche_profile/flagged_children_new.png' ||
                                          //           image[i] ==
                                          //               'assets/creche_profile/child_followUp_new.png'
                                          //       ? image[i] ==
                                          //               'assets/verifydata.png'
                                          //           ? 2.7
                                          //           : 0.9
                                          //       : 3.8,
                                          //   color: image[i] ==
                                          //           'assets/creche_profile/flagged_children_new.png'
                                          //       ? null
                                          //       : Color(0xff5979AA),
                                          // ),
                                          child: Image.asset(
                                            image[i],
                                            filterQuality: FilterQuality.high,
                                            scale:
                                                // image[i] ==
                                                //             'assets/verifydata.png' ||
                                                image[i] == 'assets/creche_profile/flagged_children_new.png' ||
                                                        image[i] ==
                                                            'assets/creche_profile/child_followUp_new.png' ||
                                                        image[i] ==
                                                            'assets/village_ic.png'
                                                    ? image[i] ==
                                                            'assets/verifydata.png'
                                                        ? 2.7
                                                        : 0.9
                                                    : 3.8,
                                            color: image[i] ==
                                                    'assets/creche_profile/flagged_children_new.png'
                                                ? null
                                                : Color(0xff5979AA),
                                          ),
                                        ),
                                        if (image[i] == 'assets/verifydata.png')
                                          if (countVerifyForPending > 0)
                                            Positioned(
                                              top: 0,
                                              bottom: 24,
                                              left: 14,
                                              right: 0,
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 70,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xffF26BA3),
                                                ),
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                  "$countVerifyForPending",
                                                  style: Styles.white74P,
                                                ),
                                              ),
                                            ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 7),
                                    child: Text(
                                      Global.returnTrLable(
                                          locationControlls, text[i], lng!),
                                      style: Styles.listlablefont,
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
      ),
    );
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
                    locationControlls, CustomText.pleaseWait, lng!)),
              ],
            ),
          ),
        );
      },
    );
  }

  callFieldData(bool only) async {
    var network = await Validate().checkNetworkConnection();

    if (network) {
      // if (only == false)
      showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      // var password = await Validate().readString(Validate.Password);
      var password = await SecureStorage.readStringValue(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await HouseHoldFieldsApiService()
          .houseHoldFieldsData(userName!, password!, token!);
      if (response.statusCode == 200) {
        HouseHoldFieldModel houseHoldFieldModel =
            HouseHoldFieldModel.fromJson(jsonDecode(response.body));
        await callInsertHouseHoldFields(houseHoldFieldModel);

        if (only == false) {
          Validate().saveString(Validate.householdForm,
              houseHoldFieldModel.tabHousehold_Form!.modified!);
          Validate().saveString(Validate.householdChildForm,
              houseHoldFieldModel.tabHousehold_Child_Form!.modified!);
        }

        if (only == false) {
          await callApiLogicData(userName, password, token, false);
        } else {
          Navigator.of(context).pop();
        }
      } else if (response.statusCode == 401) {
        Navigator.pop(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(context).showSnackBar(
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
        Navigator.pop(context);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            context);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> _launchInBrowser(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode
            .externalApplication, // This opens the URL in the default browser (Chrome Custom Tab or Safari)
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> callCreshDataApi(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var cresheData = await HouseHoldFieldsApiService()
        .syncCrecheData(userName, password, token);
    if (cresheData.statusCode == 200) {
      CrecheFieldModel houseHoldFieldModel =
          CrecheFieldModel.fromJson(jsonDecode(cresheData.body));
      if (only == false) {
        Validate().saveString(Validate.creChemodifiedDate,
            houseHoldFieldModel.tabCreche!.modified!);
      }
      await callInsertCrecheFields(houseHoldFieldModel);
      if (only == false) {
        await callAttendanceData(userName, password, token, false);
      } else {
        Navigator.pop(context);
      }
    } else if (cresheData.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(cresheData.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callEnrooledChildrenDataApi(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var child_data = await ChildEnrolledDataMetaApi()
        .callChildHHMeta(userName, password, token);

    if (child_data.statusCode == 200) {
      EnrolledChildrenFieldModel childMetaModel =
          EnrolledChildrenFieldModel.fromJson(jsonDecode(child_data.body));
      if (only == false) {
        Validate().saveString(Validate.childProfilemodifiedDate,
            childMetaModel.tabChild_HH_Meta_Form!.modified!);
      }
      await callInsertEnrolledChildrendHHFields(childMetaModel);
      if (only == false) {
        await callEnrolledExitMetaApi(userName, password, token, false);
      } else {
        Navigator.pop(context);
      }
    } else if (child_data.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(child_data.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callEnrolledExitMetaApi(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var child_data = await ChildEnrolledExitApi()
        .callChildEnrolledExitMetaApi(userName, password, token);

    if (child_data.statusCode == 200) {
      EnrolledExitChildrenFieldModel childMetaModel =
          EnrolledExitChildrenFieldModel.fromJson(jsonDecode(child_data.body));
      if (only == false) {
        Validate().saveString(Validate.childEnrolledExitmodifiedData,
            childMetaModel.tabChild_Enrollment_and_Exit!.modified!);
      }
      await callInsertEnrolledExitCMeta(childMetaModel);
      if (only == false)
        await callCreshDataApi(userName, password, token, false);
    } else if (child_data.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(child_data.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callApiLogicData(
      String userName, String password, String token, bool only) async {
    var logisResponce =
        await FormLogicApiService().fetchLogicData(userName, password, token);

    if (logisResponce.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(logisResponce.body);
      await initFormLogic(FormLogicApiModel.fromJson(responseData));
      if (only == false)
        await callEnrooledChildrenDataApi(userName, password, token, false);
    } else if (logisResponce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(logisResponce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> initFormLogic(FormLogicApiModel? formLogicApiModel) async {
    if (formLogicApiModel != null) {
      List<TabFormsLogic>? formLogicList = formLogicApiModel.tabFormsLogic;
      if (formLogicList != null) {
        print("Insert formlogic data into the database");
        await FormLogicDataHelper().insertFormLogic(formLogicList);
      } else {
        print("Not Insert formlogic data into the database");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    callInitBlock();
  }

  Future<void> callInsertHouseHoldFields(HouseHoldFieldModel items) async {
    await DatabaseHelper.database!.delete('tabhouseholdfield');
    if (items.tabHousehold_Form != null) {
      print("dataCount ${items.tabHousehold_Form!.fields!.length}");
      await HouseHoldFieldHelper()
          .insertHouseHoldField(items.tabHousehold_Form!.fields!);
    }
    if (items.tabHousehold_Child_Form != null) {
      print("dataCount Child ${items.tabHousehold_Child_Form!.fields!.length}");
      await HouseHoldFieldHelper()
          .insertHouseHoldField(items.tabHousehold_Child_Form!.fields!);
    }
  }

  Future<void> callInsertCrecheFields(CrecheFieldModel items) async {
    await DatabaseHelper.database!.delete('tabCrechefield');
    if (items.tabCreche != null) {
      print("dataCount ${items.tabCreche!.fields!.length}");
      await CrecheFieldHelper().insertCrecheField(items.tabCreche!.fields!);
    }
    if (items.tabCreche_caregiver != null) {
      print("dataCount Creche ${items.tabCreche_caregiver!.fields!.length}");
      await CrecheFieldHelper()
          .insertCrecheField(items.tabCreche_caregiver!.fields!);
    }
  }

  callInitBlock() async {
    var householdForm = await Validate().readString(Validate.householdForm);
    village = await Validate().readString(Validate.village);
    Creche = await Validate().readString(Validate.CrecheSName);
    username = (await Validate().readString(Validate.userName))!;
    fullName = (await Validate().readString(Validate.fullName))!;
    // await GetLocation().cachingCurrentLocationn(context);
    await _getAppVersionName();
    await locationData();
    await pendingDataForVerify();
    await checkConnectivity();
    if (householdForm != null) {
      await callModifiedFieldData();
    } else {
      await callFieldData(false);
    }
    setState(() {});
  }

  callModifiedFieldData() async {
    ModifiedDateApiService modifiedDateApiService = ModifiedDateApiService();
    var network = await Validate().checkNetworkConnection();
    if (network) {
      var userName = (await Validate().readString(Validate.userName))!;
      var password = (await Validate().readString(Validate.Password))!;
      var token = (await Validate().readString(Validate.appToken))!;
      var response = await modifiedDateApiService.getModifiedData();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        var modifiedApiModel = ModifiedApiModel.fromJson(responseData);

        if (responseData.isNotEmpty) {
          List<DocType>? docTypeList = modifiedApiModel.docType;
          ModifiedDataHelper modifiedDataHelper = ModifiedDataHelper();

          if (docTypeList != null) {
            await modifiedDataHelper.insertModifiedData(docTypeList);

            // Map to store the document type names and corresponding actions
            final docActions = {
              CustomText.houseHoldForm: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.householdForm, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callFieldData(true);
                }
              },
              CustomText.houseHoldChildForm:
                  (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.householdChildForm, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callFieldData(true);
                }
              },
              CustomText.childEnrollExit: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(
                      Validate.childEnrolledExitmodifiedData, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callEnrolledExitMetaApi(
                      userName, password, token, true);
                }
              },
              CustomText.childProfileDoctype:
                  (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate()
                      .saveString(Validate.childProfilemodifiedDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callEnrooledChildrenDataApi(
                      userName, password, token, true);
                }
              },
              CustomText.creche: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.creChemodifiedDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callCreshDataApi(userName, password, token, true);
                }
              },
              CustomText.childHealthDoctype:
                  (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.ChildHealthUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callChildHealthData(userName, password, token, true);
                }
              },
              CustomText.childEventDoctype: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.childEventUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callChildEventData(userName, password, token, true);
                }
              },
              CustomText.childreferralDoctype:
                  (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate()
                      .saveString(Validate.childReferralUpdatedDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callChildReffrelMeta(userName, password, token, true);
                }
              },
              CustomText.childExit: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.childExitUpdatedDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callChildExitMeta(userName, password, token, true);
                }
              },
              CustomText.childImmunization: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate()
                      .saveString(Validate.ChildImmunizationUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callChildImmunizationData(
                      userName, password, token, true);
                }
              },
              CustomText.childFollowUp: (String date1, String date2) async {
                if (!Global.validString(date1)) {
                  Validate()
                      .saveString(Validate.childFollowUpUpdatedDate, date2);
                }
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callChildFollowUpMeta(userName, password, token, true);
                }
              },
              CustomText.childGrowthMonitoring:
                  (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.ChildAntroUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callAnthropomertryData(userName, password, token, true);
                }
              },
              CustomText.cashbook: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(
                      Validate.cashbookExpencesMetaUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callCashBookExpensesMetaApi(
                      userName, password, token, true);
                }
              },
              CustomText.childAttendance: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate()
                      .saveString(Validate.ChildAttendeceUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callAttendanceData(userName, password, token, true);
                }
              },
              CustomText.village: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate()
                      .saveString(Validate.villageProfileUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await villageProfileMetaApi(userName, password, token, true);
                }
              },
              CustomText.crceheCheckIn: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.chechInUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await checkinFieldsMeta(userName, password, token, true);
                }
              },
              CustomText.cmcALMDoctype: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.crecheMonitoringMeta, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callCMCALMMetaApi(userName, password, token, true);
                }
              },
              CustomText.crecheMeeting: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate()
                      .saveString(Validate.crecheCommitteUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callCrecheCommitteMeta(userName, password, token, true);
                }
              },
              CustomText.cmcDoctype: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.crecheMonitoringMeta, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await crecheMonitoringApiMeta(
                      userName, password, token, true);
                }
              },
              CustomText.cmcCCDoctype: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.crecheMonitoringMeta, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2))
                  await callApiLogicData(userName, password, token, true);
                await callCMCCCMetaApi(userName, password, token, true);
              },
              CustomText.cmcCBMDoxtype: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.crecheMonitoringMeta, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callCMCCBMMetaApi(userName, password, token, true);
                }
              },
              CustomText.grievienceDoctype: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate()
                      .saveString(Validate.childGravienceUpdatedDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await callChildGrievancesMeta(
                      userName, password, token, true);
                }
              },
              CustomText.crecheStock: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate().saveString(Validate.stockmetaUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await stockMetaData(userName, password, token, true);
                }
              },
              CustomText.crecheRequisiton: (String date1, String date2) async {
                if (!Global.validString(date1))
                  Validate()
                      .saveString(Validate.requisitionMetaUpdateDate, date2);
                if (compareDates(
                    Global.validString(date1) ? date1 : date2, date2)) {
                  await callApiLogicData(userName, password, token, true);
                  await requisitionMetaData(userName, password, token, true);
                }
              },
            };

            for (var element in docTypeList) {
              var date2 = element.modified.toString();
              // setModifiedDateTime(element.name.toString(), date2);
              var date1 = await getDateFromValidate(element.name.toString());

              if (docActions.containsKey(element.name)) {
                await docActions[element.name]!(date1 ?? '', date2);
                // break;
              }
            }
          } else {
            print("Not Insert translation data into the database");
          }
        }
      } else if (response.statusCode == 401) {
        await handleUnauthorized();
      } else {
        handleErrorResponse(response);
      }
    }
  }

  Future<String?> getDateFromValidate(String docTypeName) async {
    switch (docTypeName) {
      case 'Household Form':
        return await Validate().readString(Validate.householdForm);
      case 'Household Child Form':
        return await Validate().readString(Validate.householdChildForm);
      case 'Child Profile':
        return await Validate().readString(Validate.childProfilemodifiedDate);
      case 'Creche':
        return await Validate().readString(Validate.creChemodifiedDate);
      case 'Child Health':
        return await Validate().readString(Validate.ChildHealthUpdateDate);
      case 'Child Event':
        return await Validate().readString(Validate.childEventUpdateDate);
      case 'Child Referral':
        return await Validate().readString(Validate.childReferralUpdatedDate);
      case 'Child Exit':
        return await Validate().readString(Validate.childExitUpdatedDate);
      case 'Child Immunization':
        return await Validate()
            .readString(Validate.ChildImmunizationUpdateDate);
      case 'Child Follow up':
        return await Validate().readString(Validate.childFollowUpUpdatedDate);
      case 'Child Growth Monitoring':
        return await Validate().readString(Validate.ChildAntroUpdateDate);
      case 'Cashbook':
        return await Validate()
            .readString(Validate.cashbookExpencesMetaUpdateDate);
      case 'Child Attendance':
        return await Validate().readString(Validate.ChildAttendeceUpdateDate);
      case 'Village':
        return await Validate().readString(Validate.villageProfileUpdateDate);
      case 'Creche Check In':
        return await Validate().readString(Validate.chechInUpdateDate);
      case 'Creche Monitoring Checklist ALM':
        return await Validate().readString(Validate.crecheMonitoringMeta);
      case 'Creche Committee Meeting':
        return await Validate().readString(Validate.crecheCommitteUpdateDate);
      case 'Creche Monitoring Checklist':
        return await Validate().readString(Validate.crecheMonitoringMeta);

      case 'Creche Monitoring Checklist CC':
        return await Validate().readString(Validate.crecheMonitoringMeta);
      case 'Creche Monitoring Checklist CBM':
        return await Validate().readString(Validate.crecheMonitoringMeta);
      case 'Grievance':
        return await Validate().readString(Validate.childGravienceUpdatedDate);
      case 'Creche Stock':
        return await Validate().readString(Validate.stockmetaUpdateDate);
      case 'Creche Requisition':
        return await Validate().readString(Validate.requisitionMetaUpdateDate);
      default:
        return null;
    }
  }

  Future<void> handleUnauthorized() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Validate.Password);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!))),
    );
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (mContext) => LoginScreen(),
        ));
  }

  void handleErrorResponse(var response) {
    Validate().singleButtonPopup(
        Global.errorBodyToString(response.body, 'message'),
        Global.returnTrLable(locationControlls, CustomText.ok, lng!),
        false,
        context);
  }

  bool compareDates(String dateString1, String dateString2) {
    DateTime date1 = DateTime.parse(dateString1);
    DateTime date2 = DateTime.parse(dateString2);
    var dateTillMinut1 =
        DateTime(date1.year, date1.month, date1.day, date1.hour, date1.minute);
    var dateTillMinut2 =
        DateTime(date2.year, date2.month, date2.day, date2.hour, date2.minute);

    if (dateTillMinut1.isBefore(dateTillMinut2)) {
      return true;
      // print('$dateString1 is earlier than $dateString2');
    } else if (dateTillMinut1.isAfter(dateTillMinut2)) {
      // print('$dateString1 is later than $dateString2');
    } else {
      // print('$dateString1 is equal to $dateString2');
    }
    return false;
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi));
    });
    // Add a listener to listen for changes in connectivity
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        // isConnected = result ==
        //     (connectivityResult.contains(ConnectivityResult.mobile) ||
        //         connectivityResult.contains(ConnectivityResult.wifi));
        isConnected = result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi);
      });
    });
  }

  Future<void> locationData() async {
    lng = await Validate().readString(Validate.sLanguage);
    role = await Validate().readString(Validate.role);

    if (role == 'Cluster Coordinator') {
      image = [
        // 'assets/verifydata.png',
        'assets/shishughar.png',
        'assets/creche_profile/flagged_children_new.png',
        'assets/creche_profile/child_followUp_new.png',
        'assets/note.png',
        'assets/village_ic.png',
        'assets/grievance.png',
        'assets/ic_sync_n.png',
      ];
      text = [
        // CustomText.Pendingforverify,
        CustomText.ShishuGharDetails,
        CustomText.FlaggedChilderen,
        CustomText.fllowUp,
        CustomText.VisitNote,
        CustomText.villageProfile,
        CustomText.Grievance,
        CustomText.sync,
      ];
    } else {
      image = [
        'assets/shishughar.png',
        'assets/creche_profile/flagged_children_new.png',
        'assets/creche_profile/child_followUp_new.png',
        'assets/note.png',
        'assets/village_ic.png',
        'assets/grievance.png',
        'assets/ic_sync_n.png',
      ];
      text = [
        CustomText.ShishuGharDetails,
        CustomText.FlaggedChilderen,
        CustomText.fllowUp,
        CustomText.VisitNote,
        CustomText.villageProfile,
        CustomText.Grievance,
        CustomText.sync,
      ];
    }

    List<String> valueNames = [
      CustomText.change_language_text,
      CustomText.HHListing,
      CustomText.Enrolledchildren,
      CustomText.VerifyData,
      CustomText.VisitNote,
      CustomText.GrowthMonitoring,
      CustomText.Attendance,
      CustomText.CrecheCommittee,
      CustomText.GrievanceIssuTracking,
      CustomText.Rollout,
      CustomText.TrainingMeeting,
      CustomText.fllowUp,
      CustomText.ChilderenExistingshishuGhar,
      CustomText.FlaggedChilderen,
      CustomText.ShishuGharDetails,
      CustomText.RequisitionReceipts,
      CustomText.Cashbook,
      CustomText.sync,
      CustomText.Pendingforverify,
      CustomText.ChilderenExistingshishuGhar,
      CustomText.Village,
      CustomText.Yes,
      CustomText.No,
      CustomText.logoutMsg,
      CustomText.nointernetconnectionavailable,
      CustomText.ok,
      CustomText.pleaseWait,
      CustomText.data_downloaded_successfully,
      CustomText.token_expired,
      CustomText.pleaseselectcrechefirst,
      CustomText.CrecheProfileView,
      CustomText.Creches,
      CustomText.Logout,
      CustomText.ChangePassword,
      CustomText.Grievance,
      CustomText.ShishuGharDetails,
      CustomText.villageProfile,
      CustomText.appInfo,
      CustomText.languages,
      CustomText.MyProfile,
      CustomText.userMannual,
      CustomText.logoutPendingDataMsg,
      CustomText.ticketSupport,
      CustomText.languages,
      CustomText.darftDataForLogoyt
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => locationControlls = value);

    setState(() {});
  }

  // void _showLanguageDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           Global.returnTrLable(
  //               locationControlls, CustomText.change_language_text, lng!),
  //           style: Styles.black128,
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             DropdownButton<String>(
  //               value: selectedLanguage,
  //               items: [
  //                 DropdownMenuItem<String>(
  //                   value: 'en',
  //                   child: Text('English'),
  //                 ),
  //                 DropdownMenuItem<String>(
  //                   value: 'hi',
  //                   child: Text(CustomText.Hindi),
  //                 ),
  //                 DropdownMenuItem<String>(
  //                   value: 'od',
  //                   child: Text(CustomText.Odiya),
  //                 ),
  //               ],
  //               onChanged: (String? value) {
  //                 if (value != null) {
  //                   setState(() {
  //                     selectedLanguage = value;
  //                   });
  //                   Validate().saveString(Validate.sLanguage, selectedLanguage);
  //                   Navigator.of(context).pop();
  //                   Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => DashboardScreen(
  //                               index: 0,
  //                             )),
  //                   );
  //                 }
  //               },
  //               isExpanded: true,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> pendingDataForVerify() async {
    if (role == 'Creche Supervisor') {
      syncCount = await callCountForUpload();
    } else if (role == 'Cluster Coordinator') {
      syncCount = await callCountForUploadCC();
    } else if (role == 'Accounts and Logistics Manager') {
      var visitNots =
          await CmcALMTabResponseHelper().getAlmForUpload();
      syncCount = visitNots.length;
    } else if (role == 'Capacity and Building Manager') {
      var visitNots = await CmcCBMTabResponseHelper().getCBMForUpload();

      syncCount = visitNots.length;
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

  Future<void> callInsertEnrolledChildrendHHFields(
      EnrolledChildrenFieldModel items) async {
    await DatabaseHelper.database!.delete('tabchildprofilefield');
    if (items.tabChild_HH_Meta_Form != null) {
      print("dataCount ChildHH${items.tabChild_HH_Meta_Form!.fields!.length}");
      await EnrolledChildrenFieldHelper()
          .insertsChildrenEnrolledField(items.tabChild_HH_Meta_Form!.fields!);
    }
    if (items.tabEntitlement_child_table != null) {
      print(
          "dataCount Child${items.tabEntitlement_child_table!.fields!.length}");
      await EnrolledChildrenFieldHelper().insertsChildrenEnrolledField(
          items.tabEntitlement_child_table!.fields!);
    }
    if (items.tabSpecially_abled_child_table != null) {
      print(
          "dataCount Child${items.tabSpecially_abled_child_table!.fields!.length}");
      await EnrolledChildrenFieldHelper().insertsChildrenEnrolledField(
          items.tabSpecially_abled_child_table!.fields!);
    }
  }

  Future<void> callInsertEnrolledExitCMeta(
      EnrolledExitChildrenFieldModel items) async {
    await DatabaseHelper.database!.delete('tab_enrolled_exit_meta');
    if (items.tabChild_Enrollment_and_Exit != null) {
      await EnrolledExitChildrenFieldHelper().insertsEnrolledExitField(
          items.tabChild_Enrollment_and_Exit!.fields!);
    }
  }

  Future<void> _getAppVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersionName = packageInfo.version;
    });
  }

  Future<void> onclick(int i, String imsgeItem, String lng) async {
    String? refStatus;
    if (i == 0) {
      // if (role == CustomText.crecheSupervisor.trim() ||
      //     role == CustomText.clusterCoordinator.trim()) {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ShiShuGharScreen(type: 0)));
      // }
    } else if (i == 1) {
      if (role == CustomText.crecheSupervisor.trim()) {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ReffralTabScreen(
                  tabTitle: Global.returnTrLable(
                      locationControlls, CustomText.FlaggedChilderen, lng),
                )));
      }
      //  else if (role == CustomText.clusterCoordinator.trim()) {
        else {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ReferallCompletedListForCC(isHomeScreen: true),
        ));
      }
    } else if (i == 2) {
      if (role == CustomText.crecheSupervisor.trim()) {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => FollowUpTabScreenAllChild(
                  tabTitle: Global.returnTrLable(
                      locationControlls, CustomText.fllowUp, lng),
                )));
      } 
      // else if (role == CustomText.clusterCoordinator.trim()) {
      else {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                FollowCompletedListForCC(isHomeScreen: true)));
      }
    } else if (i == 3) {
      if (role == CustomText.clusterCoordinator.trim()) {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AllcmcCCListingScreen()));
      } else if (role == CustomText.crecheSupervisor.trim()) {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                AllCrecheMonitorListingScreen()));
      } else if (role == CustomText.alm.trim()) {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AllcmcALMListingScreen()));
      } else if (role == CustomText.cbm.trim()) {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AllcmcCBMListingScreen()));
      }
    } else if (i == 4) {
      // if (role == CustomText.crecheSupervisor.trim() ||
      //     role == CustomText.clusterCoordinator.trim()) {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => VillageProfileListingScreen()));
      // }
    } else if (i == 5) {
      // if (role == CustomText.crecheSupervisor.trim() ||
      //     role == CustomText.clusterCoordinator.trim()) {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => GrievanceHomeListing()));
      // }
    } else if (i == 6) {
      refStatus = await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SynchronizationScreen()));
    }

    if (refStatus == 'itemRefresh') {
      await callInitBlock();
    }
  }

  callAttendanceData(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce =
        await AttendanceMetaApi().callAttendanceData(userName, password, token);
    if (responce.statusCode == 200) {
      ChildAttendanceFieldModel attendanceData =
          ChildAttendanceFieldModel.fromJson(jsonDecode(responce.body));

      await callInsertChildAttendance(attendanceData);
      // Validate().saveString(Validate.ChildAttendeceUpdateDate,
      //     attendanceData.tabChild_Attendance!.modified!);
      if (only == false) {
        await callAnthropomertryData(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildAttendance(
      ChildAttendanceFieldModel items) async {
    await DatabaseHelper.database!.delete('tabChildAttendance');
    if (items.tabChild_Attendance != null) {
      await ChildAttendanceFieldHelper()
          .insertChildAttendanceField(items.tabChild_Attendance!.fields!);
    }
    if (items.tabChild_Attendance_List != null) {
      await ChildAttendanceFieldHelper()
          .insertChildAttendanceField(items.tabChild_Attendance_List!.fields!);
    }
  }

  callAnthropomertryData(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await ChildGrowthMetaApi()
        .callChildGrowthMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildGrowthMetaFieldsModel childGrowthMetaFields =
          ChildGrowthMetaFieldsModel.fromJson(jsonDecode(responce.body));

      // Validate().saveString(Validate.ChildAntroUpdateDate,
      //     childGrowthMetaFields.tabChild_Growth_Meta!.modified!);

      await callInsertAnthropomertry(childGrowthMetaFields);

      if (only == false) {
        callChildEventData(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertAnthropomertry(
      ChildGrowthMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tabChildGrowthMeta');
    if (items.tabChild_Growth_Meta != null) {
      await ChildGrowthMetaFieldsHelper()
          .insertChildGrowthMeta(items.tabChild_Growth_Meta!.fields!);
    }
    if (items.tabAnthropromatic_Data != null) {
      await ChildGrowthMetaFieldsHelper()
          .insertChildGrowthMeta(items.tabAnthropromatic_Data!.fields!);
    }
  }

  callChildEventData(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce =
        await ChildEventMetaApi().callChildEventMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildEventMetaFieldsModel childEventMetaFields =
          ChildEventMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildEvent(childEventMetaFields);

      // Validate().saveString(Validate.childEventUpdateDate,
      //     childEventMetaFields.tabChild_Event_Meta!.modified!);
      if (only == false) {
        await callChildImmunizationData(userName, password, token, false);
      } else {
        Navigator.pop(context);
      }
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildEvent(ChildEventMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_event');
    if (items.tabChild_Event_Meta != null) {
      await ChildEventMetaFieldsHelper()
          .insertChildEventMeta(items.tabChild_Event_Meta!.fields!);
    }
  }

  callChildImmunizationData(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await ChildImmunizationMetaApi()
        .callChildImmunizationMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildImmunizationMetaFieldsModel childImmunizationMetaFields =
          ChildImmunizationMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildImmunization(childImmunizationMetaFields);
      // Validate().saveString(Validate.ChildImmunizationUpdateDate,
      //     childImmunizationMetaFields.tabChild_Immunization_Meta!.modified!);
      if (only == false) {
        await callChildHealthData(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildImmunization(
      ChildImmunizationMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_immunization');
    if (items.tabChild_Immunization_Meta != null) {
      await ChildImmunizationMetaFieldsHelper().insertChildImmunizationMeta(
          items.tabChild_Immunization_Meta!.fields!);
    }
    if (items.tabChild_Vaccine_Details != null) {
      await ChildImmunizationMetaFieldsHelper()
          .insertChildImmunizationMeta(items.tabChild_Vaccine_Details!.fields!);
    }
  }

  callChildHealthData(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await ChildHealthDataMetaApi()
        .callChildHealthMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildHelthMetaFieldsModel childHealthMetaFields =
          ChildHelthMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildHealth(childHealthMetaFields);
      // Validate().saveString(Validate.ChildHealthUpdateDate,
      //     childHealthMetaFields.tabChild_Health_Meta!.modified!);
      if (only == false) {
        callChildExitMeta(userName, password, token, false);
      } else {
        Navigator.pop(context);
      }
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildHealth(ChildHelthMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_health');
    if (items.tabChild_Health_Meta != null) {
      await ChildHealthMetaFieldsHelper()
          .insertChildHealthMeta(items.tabChild_Health_Meta!.fields!);
    }
  }

  callChildExitMeta(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce =
        await ChildExitMetaApi().callChidExitMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildExitMetaFieldsModel childExitMetaFields =
          ChildExitMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildExit(childExitMetaFields);

      // Validate().saveString(Validate.childExitUpdatedDate,
      //     childExitMetaFields.tabChild_Exit_Meta!.modified!);
      if (only == false) {
        await callChildGrievancesMeta(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildExit(ChildExitMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_exit');
    if (items.tabChild_Exit_Meta != null) {
      await ChildExitMetaFieldsHelper()
          .insertChildExitMeta(items.tabChild_Exit_Meta!.fields!);
    }
  }

  callChildGrievancesMeta(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await ChildGrievancesMetaApi()
        .callChildGrievancesMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildGrievancesMetaFieldsModel childExitMetaFields =
          ChildGrievancesMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildGrievances(childExitMetaFields);

      // Validate().saveString(Validate.childGravienceUpdatedDate,
      //     childExitMetaFields.tabChild_Grievances_Meta!.modified!);
      if (only == false) {
        await callChildReffrelMeta(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildGrievances(
      ChildGrievancesMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_grievances');
    if (items.tabChild_Grievances_Meta != null) {
      await ChildGrievancesMetaFieldsHelper()
          .insertChildGrievancesMeta(items.tabChild_Grievances_Meta!.fields!);
    }
  }

  callChildReffrelMeta(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await ChildReferralMetaApi()
        .callChildReferralMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildReferralMetaFieldsModel childFollowUpMetaFields =
          ChildReferralMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildReferral(childFollowUpMetaFields);

      // Validate().saveString(Validate.childReferralUpdatedDate,
      //     childFollowUpMetaFields.tabChild_referral_Meta!.modified!);
      if (only == false) {
        await callChildFollowUpMeta(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildReferral(
      ChildReferralMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_referral');
    if (items.tabChild_referral_Meta != null) {
      await ChildReferralFieldsHelper()
          .insertChildFollowUpMeta(items.tabChild_referral_Meta!.fields!);
    }

    if (items.tabDiagnosis_child_table != null) {
      await ChildReferralFieldsHelper()
          .insertChildFollowUpMeta(items.tabDiagnosis_child_table!.fields!);
    }

    if (items.tabReferral_child_table != null) {
      await ChildReferralFieldsHelper()
          .insertChildFollowUpMeta(items.tabReferral_child_table!.fields!);
    }

    if (items.tabTreatment_child_table != null) {
      await ChildReferralFieldsHelper()
          .insertChildFollowUpMeta(items.tabTreatment_child_table!.fields!);
    }

    if (items.tabTreatment_NRC_child_table != null) {
      await ChildReferralFieldsHelper()
          .insertChildFollowUpMeta(items.tabTreatment_NRC_child_table!.fields!);
    }
  }

  callChildFollowUpMeta(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await ChildFollowUpMetaApi()
        .callChildFollowUpMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildFollowUpMetaFieldsModel childFollowUpMetaFields =
          ChildFollowUpMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildFollowUp(childFollowUpMetaFields);

      // Validate().saveString(Validate.childFollowUpUpdatedDate,
      //     childFollowUpMetaFields.tabChild_FollowUp_Meta!.modified!);
      if (only == false) {
        await callCrecheCommitteMeta(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildFollowUp(
      ChildFollowUpMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_followup');
    if (items.tabChild_FollowUp_Meta != null) {
      await ChildFollowUpFieldsHelper()
          .insertChildFollowUpMeta(items.tabChild_FollowUp_Meta!.fields!);
    }
  }

  callCrecheCommitteMeta(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await CrecheCommitteeMeetingMetaApi()
        .callCrecheCommitteeMeetingMeta(userName, password, token);
    if (responce.statusCode == 200) {
      CrecheCommitteFieldsMetaModel crecheCommitteMetaFields =
          CrecheCommitteFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await callInsertCrecheCommitte(crecheCommitteMetaFields);

      // Validate().saveString(Validate.crecheCommitteUpdateDate,
      //     crecheCommitteMetaFields.tabChild_creche_committe_Meta!.modified!);

      if (only == false) {
        await callCashBookExpensesMetaApi(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCrecheCommitte(
      CrecheCommitteFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tab_creche_committe');
    if (items.tabChild_creche_committe_Meta != null) {
      await CrecheCommitteFieldsMetaHelper().insertCrecheCommitteMeta(
          items.tabChild_creche_committe_Meta!.fields!);
    }
    if (items.tabAttendees_child_table != null) {
      await CrecheCommitteFieldsMetaHelper()
          .insertCrecheCommitteMeta(items.tabAttendees_child_table!.fields!);
    }
  }

  callCashBookExpensesMetaApi(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await CashBookExpensesApi()
        .callCashBookExpensesMeta(userName, password, token);
    if (responce.statusCode == 200) {
      CashBookExpensesFieldsMetaModel cashbookExpensesMetaFields =
          CashBookExpensesFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await callInsertCashBookExpensesMeta(cashbookExpensesMetaFields);

      // Validate().saveString(Validate.cashbookExpencesMetaUpdateDate,
      //     cashbookExpensesMetaFields.tab_cashbook_expenses!.modified!);
      if (only == false) {
        await checkinFieldsMeta(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCashBookExpensesMeta(
      CashBookExpensesFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tab_cashbook_expences_fields');
    if (items.tab_cashbook_expenses != null) {
      await CashbookExpencesMetaFieldsHelper()
          .insertCashBookMeta(items.tab_cashbook_expenses!.fields!);
    }
  }

  callCashBookReceiptMetaApi(
      String userName, String password, String token) async {
    var responce = await CashBookReceiptApi()
        .callCashBookReceiptMeta(userName, password, token);
    if (responce.statusCode == 200) {
      CashBookReceiptFieldsMetaModel cashbookReceiptMetaFields =
          CashBookReceiptFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await callInsertCashBookreceiptMeta(cashbookReceiptMetaFields);

      // Validate().saveString(Validate.cashbookRecieptMetaUpdateDate,
      //     cashbookReceiptMetaFields.tab_cashbook_receipt!.modified!);
      if (role == 'Cluster Coordinator') {
        await callCMCCCMetaApi(userName, password, token, false);
      } else if (role == 'Creche Supervisor') {
        await crecheMonitoringApiMeta(userName, password, token, false);
      } else if (role == 'Accounts and Logistics Manager') {
        await callCMCALMMetaApi(userName, password, token, false);
      } else {
        await callCMCCBMMetaApi(userName, password, token, false);
      }
      // Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCashBookreceiptMeta(
      CashBookReceiptFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tab_cashbook_receipts_fields');
    if (items.tab_cashbook_receipt != null) {
      await CashbookExpencesMetaFieldsHelper()
          .insertCashBookReceipt(items.tab_cashbook_receipt!.fields!);
    }
  }

  callCMCALMMetaApi(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await CrecheMonetringCheckListALMApi()
        .cmcALMMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      CmcALMMetaFieldsModel cmcALMMEtaFields =
          CmcALMMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertcmcALMData(cmcALMMEtaFields);

      // Validate().saveString(Validate.crecheMonitoringMeta,
      //     cmcALMMEtaFields.tabCreche_Monitoring_CheckList_ALM!.modified!);
      Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertcmcALMData(CmcALMMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_Monitering_CheckList_ALM');
    if (items.tabCreche_Monitoring_CheckList_ALM != null) {
      await CrecheMoniteringCheckListALMFieldsHelper()
          .insertcmcALMMeta(items.tabCreche_Monitoring_CheckList_ALM!.fields!);
    }
  }

  callCMCCBMMetaApi(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await CrecheMonetringCheckListCBMApi()
        .cmcCBMMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      CmcCBMMetaFieldsModel cmcCBMMEtaFields =
          CmcCBMMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertcmcCBMData(cmcCBMMEtaFields);

      // Validate().saveString(Validate.crecheMonitoringMeta,
      //     cmcCBMMEtaFields.tabCreche_Monitoring_CheckList_CBM!.modified!);
      Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertcmcCBMData(CmcCBMMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_Monitering_CheckList_CMB');
    if (items.tabCreche_Monitoring_CheckList_CBM != null) {
      await CrecheMoniteringCheckListCMBFieldsHelper()
          .insertcmcCBMMeta(items.tabCreche_Monitoring_CheckList_CBM!.fields!);
    }
  }

  callCMCCCMetaApi(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await CrecheMonetringCheckListCCApi()
        .cmcCCMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      CmcCCMetaFieldsModel cmcCCMEtaFields =
          CmcCCMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertcmcCCData(cmcCCMEtaFields);

      // Validate().saveString(Validate.crecheMonitoringMeta,
      //     cmcCCMEtaFields.tabCreche_Monitoring_CheckList_CC!.modified!);
      Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertcmcCCData(CmcCCMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_Monitering_CheckList_CC');
    if (items.tabCreche_Monitoring_CheckList_CC != null) {
      await CrecheMoniteringCheckListCCFieldsHelper()
          .insertcmcCCMeta(items.tabCreche_Monitoring_CheckList_CC!.fields!);
    }
  }

  Future<void> crecheMonitoringApiMeta(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    final response = await CrecheMonitoringApi()
        .getMetaData(username: userName, password: password, appToken: token);

    if (response.statusCode == 200) {
      final childExitMetaFields =
          CrecheMonitoringMetaModel.fromJson(jsonDecode(response.body));

      await callInsertCrecheMonitoringMeta(childExitMetaFields);

      // Validate().saveString(
      //     Validate.crecheMonitoringMeta, childExitMetaFields.meta!.modified!);
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
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
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(response.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCrecheMonitoringMeta(
      CrecheMonitoringMetaModel items) async {
    await DatabaseHelper.database!.delete('tabCrecheMonitorMeta');

    if (items.meta == null) return;

    await CrecheMonitoringFieldHelper()
        .insertCrecheMonitorFields(items.meta!.fields!);
  }

  villageProfileMetaApi(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await VillageProfileMetaApi()
        .callVillageProfileMeta(userName, password, token);
    if (responce.statusCode == 200) {
      VillageProfileMetaFieldsModel villageProfileMetaFields =
          VillageProfileMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertVillageProfileMeta(villageProfileMetaFields);

      // Validate().saveString(Validate.villageProfileUpdateDate,
      //     villageProfileMetaFields.tab_village!.modified!);

      if (only == false) {
        await stockMetaData(userName, password, token, false);
        // await callCashBookReceiptMetaApi(userName, password, token);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertVillageProfileMeta(
      VillageProfileMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_village_profile_meta');
    if (items.tab_village != null) {
      await VillageProfileFieldsHelper()
          .insertVillageProfile(items.tab_village!.fields!);
    }
    if (items.tab_demographic_detail != null) {
      await VillageProfileFieldsHelper()
          .insertVillageProfile(items.tab_demographic_detail!.fields!);
    }
    if (items.tab_caste_child != null) {
      await VillageProfileFieldsHelper()
          .insertVillageProfile(items.tab_caste_child!.fields!);
    }
  }

  checkinFieldsMeta(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce =
        await CrecheCheckInApi().checkInMeta(userName, password, token);
    if (responce.statusCode == 200) {
      CheckInFieldsMetaModel checkInMetaFields =
          CheckInFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await callInsertCheckInFields(checkInMetaFields);

      // Validate().saveString(Validate.chechInUpdateDate,
      //     checkInMetaFields.tab_checkin_meta!.modified!);

      // await callCashBookReceiptMetaApi(userName, password, token);
      if (only == false) {
        await villageProfileMetaApi(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCheckInFields(CheckInFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tab_checkin_meta');
    if (items.tab_checkin_meta != null) {
      await CheckInMetaHelper().insertCheckin(items.tab_checkin_meta!.fields!);
    }
    if (items.tab_visit_purpose != null) {
      await CheckInMetaHelper().insertCheckin(items.tab_visit_purpose!.fields!);
    }
  }

  stockMetaData(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await StockApi().stockMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      StockFieldsMetaModel villageProfileMetaFields =
          StockFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await calllInsertStockMetaData(villageProfileMetaFields);

      // Validate().saveString(Validate.stockmetaUpdateDate,
      //     villageProfileMetaFields.tab_stock_meta!.modified!);

      if (only == false) {
        await requisitionMetaData(userName, password, token, false);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> calllInsertStockMetaData(StockFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_stock_fields');
    if (items.tab_stock_meta != null) {
      await StockFieldHelper().insertStock(items.tab_stock_meta!.fields!);
    }
    if (items.tabStock_child_table != null) {
      await StockFieldHelper().insertStock(items.tabStock_child_table!.fields!);
    }
  }

  requisitionMetaData(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce =
        await RequisitionApi().requisitionMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      RequisitionFieldsMetaModel requisitionMetaFields =
          RequisitionFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await callInsertRequisitionMetaData(requisitionMetaFields);

      // Validate().saveString(Validate.requisitionMetaUpdateDate,
      //     requisitionMetaFields.tab_requisition_meta!.modified!);

      if (only == false) {
        await callCashBookReceiptMetaApi(userName, password, token);
      } else
        Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertRequisitionMetaData(
      RequisitionFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_requisition_fields');
    if (items.tab_requisition_meta != null) {
      await RequisitionFieldsHelper()
          .insertRequsiition(items.tab_requisition_meta!.fields!);
    }
    if (items.tab_requisition_child_table != null) {
      await RequisitionFieldsHelper()
          .insertRequsiition(items.tab_requisition_child_table!.fields!);
    }
  }

  Future<int> callCountForUploadCC() async {
    showLoaderDialog(context);

    var crecheCheckIn =
        await CheckInResponseHelper().callCrecheCheckInResponses();

    var grievanceData = await ChildGrievancesTabResponceHelper()
        .getChildGrievanceForUploadDarft();
    var creCheMonitoring =
        await CmcCCTabResponseHelper().getCcForUpload();

    var ImageFileData = await ImageFileTabHelper().getImageForUpload();

    Navigator.pop(context);
    int totalPendingCount = crecheCheckIn.length +
        grievanceData.length +
        creCheMonitoring.length +
        ImageFileData.length;

    return totalPendingCount;
  }

  Future<int> callCountForUpload() async {
    showLoaderDialog(context);
    var hhItems =
        await HouseHoldTabResponceHelper().getHouseHoldItems();
    hhItems = hhItems
        .where((element) =>
    Global.stringToInt(Global.getItemValues(
        element.responces!, 'verification_status')) >
        1)
        .toList();
    var childEnrollExitData = await EnrolledExitChilrenResponceHelper()
        .callChildrenForUpload();
    var crecheProfile = await CrecheDataHelper().callCrecheForUpload();
    var chilAttendence = await ChildAttendanceResponceHelper()
        .callChildAttendencesAllForUpoad();
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
    var creCheMonitoring = await CrecheMonitorResponseHelper()
        .getCrecheResponseForUpload();
    var referralData =
        await ChildReferralTabResponseHelper().getChildReferralForUpload();
    var followUpData =
        await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
    var ccmData =
        await CrecheCommittieResponnseHelper().getCrecheCommittieForUpload();
    var cashBookDataExpences = await CashBookResponseExpencesHelper()
        .getEditedCashBookForExpenceUpload();
    var stockData = await StockResponseHelper().getStockForUpload();
    var requisitionData =
        await RequisitionResponseHelper().getRequisitonsForUpload();

    var cashBookDataReciept = await CashBookReceiptResponseHelper()
        .getEditedCashBookReceiptForUpload();

    var villageProfiles = await VillageProfileResponseHelper()
        .getVillageProfileforUploadDarftEdit();
    var ImageFileData = await ImageFileTabHelper().getImageForUpload();

    hhItems = hhItems
        .where((element) =>
            Global.stringToInt(Global.getItemValues(
                element.responces!, 'verification_status')) >=
            1)
        .toList();

    Navigator.pop(context);
    int totalPendingCount = hhItems.length +
        childEnrollExitData.length +
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
        stockData.length +
        requisitionData.length;

    return totalPendingCount;
  }


  Future<int> callDarftData() async{
     if (role == 'Creche Supervisor') {
       var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
       var childEnrollExitData = await EnrolledExitChilrenResponceHelper().callChildrenForUpload();
       var villageProfile = await await CrecheMonitorResponseHelper().getVillageProfileforUploadDarftEdit();
       var creCheMonitoring = await CrecheMonitorResponseHelper().getVillageProfileforUploadDarftEdit();
       var chilAttendence = await ChildAttendanceResponceHelper().callChildAttendencesAllForUpoadEditDarft();
       return (hhItems.length+childEnrollExitData.length+villageProfile.length+creCheMonitoring.length+chilAttendence.length);
     } else if (role == 'Cluster Coordinator') {
       var creCheMonitoring =
       await CmcCCTabResponseHelper().getCcForUploadEditDarft();
       return creCheMonitoring.length;
     } else if (role == 'Accounts and Logistics Manager') {
       var visitNots =
           await CmcALMTabResponseHelper().getAlmForUploadDarftEdited();
       return visitNots.length;
     } else if (role == 'Capacity and Building Manager') {
       var visitNots = await CmcCBMTabResponseHelper().getCBMForUploadDarft();
       return visitNots.length;
     }return 0;
  }
}
