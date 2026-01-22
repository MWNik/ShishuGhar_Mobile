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
import 'package:shishughar/screens/synchronization_screen_new.dart';
import 'package:shishughar/screens/tabed_screens/child_follow_up/child_followup_completed_list_CC.dart';
import 'package:shishughar/screens/tabed_screens/child_follow_up/follow_up_tab_screen_all_child.dart';
import 'package:shishughar/screens/tabed_screens/child_gravience/child_grievance_home_listing.dart';
import 'package:shishughar/screens/tabed_screens/child_reffrel/referral_completed_listing_CC.dart';
import 'package:shishughar/screens/tabed_screens/child_reffrel/reffral_tab_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checkList_cbm/all_creche_monitering_checklist_CBM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_CC/all_creche_monitering_checklist_CC_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_SM/all_creche_monitering_checklist_SM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_alm/all_creche_monitering_checklist_ALM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitor/all_creche_monitor_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/dashboard_report/dash_report_card_details_for_home.dart';
import 'package:shishughar/screens/tabed_screens/dashboard_report/dashboard_report_helper.dart';
import 'package:shishughar/screens/tabed_screens/village_profile/village_profile_listing_screen.dart';
import 'package:shishughar/screens/user_my_profile_details.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/constants.dart';
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
import '../api/creche_monitering_checklist_sm_api.dart';
import '../api/creche_monitoring_api.dart';
import '../api/form_logic_api.dart';
import '../api/house_hold_fields_api.dart';
import '../api/master_api.dart';
import '../api/modified_date_api.dart';
import '../api/village_profile_meta_api.dart';
import '../custom_widget/single_poup_dailog.dart';
import '../database/database_helper.dart';
import '../database/helper/anthromentory/child_growth_meta_fields_helper.dart';
import '../database/helper/anthromentory/child_growth_response_helper.dart';
import '../database/helper/backdated_configiration_helper.dart';
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
import '../database/helper/cmc_SM/creche_monitering_checklist_SM_fields_helper.dart';
import '../database/helper/cmc_SM/creche_monitering_checklist_SM_response_helper.dart';
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
import '../database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import '../database/helper/enrolled_exit_child/enrolled_exit_children_field_helper.dart';
import '../database/helper/follow_up/child_followUp_fields_helper.dart';
import '../database/helper/follow_up/child_followUp_response_helper.dart';
import '../database/helper/height_weight_boys_girls_helper.dart';
import '../database/helper/house_field_item_helper.dart';
import '../database/helper/image_file_tab_responce_helper.dart';

import '../database/helper/translation_language_helper.dart';
import '../database/helper/user_manual_fields_meta_helper.dart';
import '../database/helper/village_profile/village_profiile_fileds_helper.dart';
import '../database/helper/village_profile/village_profile_response_helper.dart';
import '../model/apimodel/backdated_configiration_api_model.dart';
import '../model/apimodel/cashbook_expenses_fields_meta_model.dart';
import '../model/apimodel/checkin_fields_meta_model.dart';
import '../model/apimodel/checklist_sm_Meta_fields_model.dart';
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
import '../model/apimodel/master_data_model.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../model/apimodel/child_health_meta_data_Api_Model.dart';
import '../model/apimodel/village_profile_meta_fields_model.dart';
import '../model/databasemodel/backdated_configiration_model.dart';
import '../model/databasemodel/child_growth_responce_model.dart';
import '../model/dynamic_screen_model/options_model.dart';
import '../model/dynamic_screen_model/user_manual_responses_model.dart';
import '../utils/globle_method.dart';
import '../utils/validate.dart';
import 'change_password_screen.dart';
import 'dashboardscreen_new.dart';
import 'draft_data_screen.dart';
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
  String lng='en';
  var change_language_text = "";
  int syncCount = 0;
  int countVerifyForPending = 0;
  String username = '';
  String fullName = '';
  List<Translation> locationControlls = [];
  String appVersionName = '';
  bool shouldDownloadFirst = false;
  Map<String, int> itemCount = {};

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
            Global.returnTrLable(
                locationControlls, CustomText.ShishuGharDetails, lng),
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
                        SynchronizationScreenNew()));
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
              visible: false,
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
                                  Text(
                                    "$username",
                                    style: Styles.black126P,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Text(
                                      "${Global.returnTrLable(locationControlls, role, lng)}",
                                      style: Styles.roleLabe),
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
                            Global.returnTrLable(locationControlls,
                                CustomText.MyProfile, lng),
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
                          leading: const Icon(Icons.holiday_village_outlined),
                          title: Text(
                            Global.returnTrLable(locationControlls,
                                CustomText.villageProfile, lng),
                            style: Styles.black125,
                          ),
                          onTap: () {
                            HomeReplicaScreen.scaffoldKey!.currentState
                                ?.closeDrawer();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VillageProfileListingScreen()));
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
                          leading: const Icon(Icons.info_rounded),
                          title: Text(
                            Global.returnTrLable(locationControlls,
                                CustomText.Grievance, lng),
                            style: Styles.black125,
                          ),
                          onTap: () {
                            HomeReplicaScreen.scaffoldKey!.currentState
                                ?.closeDrawer();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GrievanceHomeListing()));
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
                            Global.returnTrLable(locationControlls,
                                CustomText.ChangePassword, lng),
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
                            Global.returnTrLable(locationControlls,
                                CustomText.languages, lng),
                            style: Styles.black125,
                          ),
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                Global.returnTrLable(locationControlls,
                                    CustomText.English, lng),
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
                                Global.returnTrLable(locationControlls,
                                    CustomText.Hindi, lng),
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
                                Global.returnTrLable(locationControlls,
                                    CustomText.Odiya, lng),
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
                            ListTile(
                              title: Text(
                                Global.returnTrLable(locationControlls,
                                    CustomText.Kannad, lng),
                                style: Styles.Grey10,
                              ),
                              onTap: () async {
                                HomeReplicaScreen.scaffoldKey!.currentState
                                    ?.closeDrawer();
                                Validate().saveString(Validate.sLanguage, 'kn');
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
                            Global.returnTrLable(locationControlls,
                                CustomText.userMannual, lng),
                            style: Styles.black125,
                          ),
                          onExpansionChanged: (value) {},
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                Global.returnTrLable(locationControlls,
                                    CustomText.English, lng),
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
                                Global.returnTrLable(locationControlls,
                                    CustomText.Hindi, lng),
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
                                Global.returnTrLable(locationControlls,
                                    CustomText.Odiya, lng),
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
                            ListTile(
                              title: Text(
                                Global.returnTrLable(locationControlls,
                                    CustomText.Kannad, lng),
                                style: Styles.Grey10,
                              ),
                              onTap: () async {
                                List<UserManualResponsesModel> responce =
                                    await UserManualFieldsHelper()
                                        .getResponsebylang('Kannada');
                                if (responce.isNotEmpty) {
                                  String url = responce.first.url ?? '';
                                  if(Global.validString(url)){
                                  showLoaderDialog(context);
                                  await PDFDownloaderState()
                                      .downloadAndOpenPDF(url, context);
                                  Navigator.pop(context);}
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
                            Global.returnTrLable(
                                locationControlls, CustomText.appInfo, lng),
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
                            Global.returnTrLable(locationControlls,
                                CustomText.ticketSupport, lng),
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
                                      lng),
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lng),
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
                            Global.returnTrLable(locationControlls,
                                CustomText.dbBackup, lng),
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
                              Global.returnTrLable(locationControlls,
                                  CustomText.Logout, lng),
                              style: Styles.red125,
                            ),
                            onTap: () async {
                              if (syncCount > 0) {
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(locationControlls,
                                        CustomText.logoutPendingDataMsg, lng),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lng),
                                    false,
                                    context);
                              } else {
                                var darftData = await callDarftData();
                                if (darftData == 0) {
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
                                } else {
                                  bool? shouldProceed = await showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return SingleButtonPopupDialog(
                                          message: Global.returnTrLable(
                                              locationControlls,
                                              CustomText.darftDataForLogoyt,
                                              lng),
                                          button: Global.returnTrLable(
                                              locationControlls,
                                              CustomText.ok,
                                              lng));
                                    },
                                  );
                                  if (shouldProceed == true) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DarftDataScreen()));
                                  }
                                  // Validate().singleButtonPopup(
                                  //     Global.returnTrLable(locationControlls,
                                  //         CustomText.darftDataForLogoyt, lng),
                                  //     Global.returnTrLable(locationControlls,
                                  //         CustomText.ok, lng),
                                  //     false,
                                  //     context);
                                }
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
                        text: '${Global.returnTrLable(locationControlls, CustomText.Version, lng)}: ',
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
                    return homeScreenCardItem(i);
                    // return InkWell(
                    //   onTap: () async {
                    //     onclick(i, image[i], lng);
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Color(0xff5A5A5A).withOpacity(
                    //                 0.1), // Shadow color with opacity
                    //             offset: Offset(
                    //                 0, 1), // Horizontal and vertical offset
                    //             blurRadius: 5, // Blur radius
                    //             spreadRadius: 0, // Spread radius
                    //           ),
                    //         ],
                    //         color: Color(0xffF2F7FF),
                    //         borderRadius: BorderRadius.circular(5.r),
                    //         border: Border.all(
                    //           color: Color(0xffE7F0FF),
                    //         )),
                    //     height: 168.h,
                    //     width: 146.w,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Expanded(
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Visibility(
                    //                 visible: true,
                    //                 child: Stack(
                    //                   children: [
                    //                     SizedBox(
                    //                       height: 40,
                    //                       width: 40,
                    //                       // child: Image.asset(
                    //                       //   image[i],
                    //                       //   filterQuality: FilterQuality.high,
                    //                       //   scale: image[i] ==
                    //                       //               'assets/verifydata.png' ||
                    //                       //           image[i] ==
                    //                       //               'assets/creche_profile/flagged_children_new.png' ||
                    //                       //           image[i] ==
                    //                       //               'assets/creche_profile/child_followUp_new.png'
                    //                       //       ? image[i] ==
                    //                       //               'assets/verifydata.png'
                    //                       //           ? 2.7
                    //                       //           : 0.9
                    //                       //       : 3.8,
                    //                       //   color: image[i] ==
                    //                       //           'assets/creche_profile/flagged_children_new.png'
                    //                       //       ? null
                    //                       //       : Color(0xff5979AA),
                    //                       // ),
                    //                       child: Image.asset(
                    //                         image[i],
                    //                         filterQuality: FilterQuality.high,
                    //                         scale:
                    //                             // image[i] ==
                    //                             //             'assets/verifydata.png' ||
                    //                             image[i] == 'assets/creche_profile/flagged_children_new.png' ||
                    //                                     image[i] ==
                    //                                         'assets/creche_profile/child_followUp_new.png' ||
                    //                                     image[i] ==
                    //                                         'assets/village_ic.png'
                    //                                 ? image[i] ==
                    //                                         'assets/verifydata.png'
                    //                                     ? 2.7
                    //                                     : 0.9
                    //                                 : 3.8,
                    //                         color: image[i] ==
                    //                                 'assets/creche_profile/flagged_children_new.png'
                    //                             ? null
                    //                             : Color(0xff5979AA),
                    //                       ),
                    //                     ),
                    //                     if (image[i] == 'assets/shishughar.png')
                    //                       // if (countVerifyForPending > 0)
                    //                         Positioned(
                    //                           top: 0,
                    //                           bottom: 10,
                    //                           left: 15,
                    //                           right: 0,
                    //                           child: Container(
                    //                             alignment: Alignment.center,
                    //                             height: 100,
                    //                             width: 100,
                    //                             decoration: BoxDecoration(
                    //                               shape: BoxShape.circle,
                    //                               color: Color(0xffF26BA3),
                    //                             ),
                    //                             padding: EdgeInsets.all(4),
                    //                             child: Text(
                    //                               "$countVerifyForPending",
                    //                               style: Styles.blue148,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                     Positioned(
                    //                       top: -5,      // Increased from 0
                    //                       bottom: 15,   // Decreased from 24 to give more space
                    //                       left: 15,     // Decreased from 24
                    //                       right: -5,    // Increased from 0
                    //                       child: Container(
                    //                         alignment: Alignment.center,
                    //                         height: 120,  // Increased from 100
                    //                         width: 120,   // Increased from 100
                    //                         decoration: BoxDecoration(
                    //                           shape: BoxShape.circle,
                    //                           color: Color(0xffF26BA3),
                    //                         ),
                    //                         padding: EdgeInsets.all(6),  // Increased padding
                    //                         child: Text(
                    //                           "$countVerifyForPending",
                    //                           style: Styles.blue148.copyWith(fontSize: 16), // Larger text
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 15.h,
                    //               ),
                    //               Padding(
                    //                 padding:
                    //                     EdgeInsets.symmetric(horizontal: 7),
                    //                 child: Text(
                    //                   Global.returnTrLable(
                    //                       locationControlls, text[i], lng),
                    //                   style: Styles.listlablefont,
                    //                   textAlign: TextAlign.center,
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // );
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
                    locationControlls, CustomText.loading, lng)),
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
                  locationControlls, CustomText.token_expired, lng))),
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
            Global.returnTrLable(locationControlls, CustomText.ok, lng),
            false,
            context);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    }
  }

  Future<void> callEnrooledChildrenDataApi(
      String userName, String password, String token, bool only)
  async {
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    }
  }

  Future<void> callEnrolledExitMetaApi(
      String userName, String password, String token, bool only)
  async {
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    }
  }

  Future<void> callApiLogicData(
      String userName, String password, String token, bool only)
  async {
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    }
  }

  Future<void> initFormLogic(FormLogicApiModel? formLogicApiModel) async {
    if (formLogicApiModel != null) {
      List<TabFormsLogic>? formLogicList = formLogicApiModel.tabFormsLogic;
      print("Insert formlogic data into the database");
      await FormLogicDataHelper().insertFormLogic(formLogicList);
    }
  }

  @override
  void initState() {
    super.initState();
    callInitBlock();
  }

  // void checkZscoreValue(double weight,double m,double l,double s){
  //   double value=Global.retrunValidNum(m).toDouble();
  //   double zScore = Global.calculateZScore(weight,m,l,s);
  //   int days = Global.getbackDaysByMonth('2025-04-01',25);
  //   print('zScore $zScore  $days');
  //
  // }

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
    // var data=Validate().ungzip("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");
    // print(data);

    var householdForm = await Validate().readString(Validate.householdForm);
    village = await Validate().readString(Validate.village);
    Creche = await Validate().readString(Validate.CrecheSName);
    username = (await Validate().readString(Validate.userName))!;
    fullName = (await Validate().readString(Validate.fullName))!;
    int? houseHold = await Validate().readInt((Validate.household));
    String? downloadTimeStamp =
        await Validate().readString(Validate.dataDownloadDateTime);
    shouldDownloadFirst =
        (houseHold ?? 0) > 0 && !Global.validString(downloadTimeStamp);
    // await GetLocation().cachingCurrentLocationn(context);
    await checkConnectivity();
    await _getAppVersionName();
    await locationData();
    await pendingDataForVerify();
    var tabHeightforageBoys =
        await HeightWeightBoysGirlsHelper().callHeightForAgeBoys();
    if (tabHeightforageBoys.isNotEmpty) {
      if (tabHeightforageBoys.first.l == null &&
          tabHeightforageBoys.first.m == null &&
          tabHeightforageBoys.first.s == null) {
        await callBackdatedConfigirationData();
      } else {
        if (householdForm != null) {
          await callModifiedFieldData();
        } else {
          await callFieldData(false);
        }
      }
    } else {
      await callBackdatedConfigirationData();
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

      if (response.statusCode == 401) {
        await handleUnauthorized();
      } else {
        countDataExcution();
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
              locationControlls, CustomText.token_expired, lng))),
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
        Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
    lng = await Validate().readString(Validate.sLanguage)??'en';
    role = await Validate().readString(Validate.role);

    if (role == CustomText.clusterCoordinator) {
      image = [
        // 'assets/verifydata.png',
        'assets/shishughar.png',
        'assets/creche_profile/flagged_children_new.png',

        'assets/creche_profile/creche_profile_new.png',
        'assets/creche_profile/attendance.png',
        'assets/creche_profile/anatomy.png',
        'assets/creche_profile/enrolled_child_new.png',
        'assets/creche_profile/health_detail_new.png',
        'assets/creche_profile/sam.png',
        'assets/creche_profile/suw.png',
        'assets/creche_profile/gf_1.png',
        'assets/creche_profile/gf_2.png',
        'assets/creche_profile/child_at_risk.png',

        'assets/creche_profile/child_followUp_new.png',
        'assets/note.png',
        // 'assets/village_ic.png',
        // 'assets/grievance.png',
        'assets/ic_sync_n.png',
      ];
      text = [
        // CustomText.Pendingforverify,
        CustomText.ShishuGharDetails,
        CustomText.FlaggedChilderen,
        CustomText.CurrentActiveChildren,
        CustomText.NoOfCrechesNotSubmittedAttendance,
        CustomText.AnthroDataNotSubmitted,
        CustomText.childEligbleButNotEnrollrd,
        CustomText.ChildrenMeasurementNotTaken,
        CustomText.SeverelyStunted,
        CustomText.SeverelyUnderweight,
        CustomText.Growthfaltering1,
        CustomText.Growthfaltering2,
        CustomText.childrenAtRisk,
        CustomText.fllowUp,
        CustomText.VisitNote,
        // CustomText.villageProfile,
        // CustomText.Grievance,
        CustomText.sync,
      ];
    } else {
      image = [
        'assets/shishughar.png',
        'assets/creche_profile/flagged_children_new.png',

        // 'assets/village_ic.png',
        // 'assets/grievance.png',

        'assets/creche_profile/creche_profile_new.png',
        'assets/creche_profile/attendance.png',
        'assets/creche_profile/anatomy.png',
        'assets/creche_profile/enrolled_child_new.png',
        'assets/creche_profile/health_detail_new.png',
        'assets/creche_profile/sam.png',
        'assets/creche_profile/suw.png',
        'assets/creche_profile/gf_1.png',
        'assets/creche_profile/gf_2.png',
        'assets/creche_profile/child_at_risk.png',

        'assets/creche_profile/child_followUp_new.png',
        'assets/note.png',
        'assets/ic_sync_n.png',
      ];
      text = [
        CustomText.ShishuGharDetails,
        CustomText.FlaggedChilderen,
        // CustomText.fllowUp,
        // CustomText.VisitNote,
        // CustomText.villageProfile,
        // CustomText.Grievance,
        // CustomText.sync,

        CustomText.CurrentActiveChildren,
        CustomText.NoOfCrechesNotSubmittedAttendance,
        CustomText.AnthroDataNotSubmitted,
        CustomText.childEligbleButNotEnrollrd,
        CustomText.ChildrenMeasurementNotTaken,
        CustomText.SeverelyStunted,
        CustomText.SeverelyUnderweight,
        CustomText.Growthfaltering1,
        CustomText.Growthfaltering2,
        CustomText.childrenAtRisk,
        CustomText.fllowUp,
        CustomText.VisitNote,
        CustomText.sync,
      ];
    }

    List<String> valueNames = [
      CustomText.change_language_text,
      CustomText.HHListing,
      CustomText.Enrolledchildren,
      CustomText.VerifyData,
      CustomText.VisitNote,
      CustomText.Version,
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
      CustomText.loading,
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
      CustomText.dbBackup,
      CustomText.languages,
      CustomText.darftDataForLogoyt,
      CustomText.schduleDate,
      CustomText.complted,
      CustomText.downloadFiyrst,
      CustomText.CurrentActiveChildren,
      CustomText.NoOfCrechesNotSubmittedAttendance,
      CustomText.AnthroDataNotSubmitted,
      CustomText.childEligbleButNotEnrollrd,
      CustomText.ChildrenMeasurementNotTaken,
      CustomText.SeverelyStunted,
      CustomText.SeverelyUnderweight,
      CustomText.Growthfaltering1,
      CustomText.Growthfaltering2,
      CustomText.childrenAtRisk,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => locationControlls.addAll(value));

    setState(() {});
  }

  Future<void> pendingDataForVerify() async {
    if (role == CustomText.crecheSupervisor) {
      syncCount = await callCountForUpload();
    }
    else if (role == CustomText.clusterCoordinator) {
      syncCount = await callCountForUploadCC();
    }
    else if (role == CustomText.alm) {
      var crecheCheckIn =
          await CheckInResponseHelper().callCrecheCheckInResponses();
      var grievanceData = await ChildGrievancesTabResponceHelper()
          .getChildGrievanceForUploadDarft();
      var ImageFileData = await ImageFileTabHelper().getImageForUpload();
      var visitNots = await CmcALMTabResponseHelper().getAlmForUpload();
      syncCount = visitNots.length +
          crecheCheckIn.length +
          grievanceData.length +
          ImageFileData.length;
    }
    else if (role == CustomText.cbm) {
      var crecheCheckIn =
          await CheckInResponseHelper().callCrecheCheckInResponses();
      var grievanceData = await ChildGrievancesTabResponceHelper()
          .getChildGrievanceForUploadDarft();
      var ImageFileData = await ImageFileTabHelper().getImageForUpload();
      var visitNots = await CmcCBMTabResponseHelper().getCBMForUpload();

      syncCount = visitNots.length +
          crecheCheckIn.length +
          grievanceData.length +
          ImageFileData.length;
    }
    else if (role == CustomText.partnerAdministrator) {
      var crecheCheckIn =
          await CheckInResponseHelper().callCrecheCheckInResponses();
      var ImageFileData = await ImageFileTabHelper().getImageForUpload();

      syncCount =
          crecheCheckIn.length +
          ImageFileData.length;
    }
    else if (role == CustomText.MISAdministrator) {
      var crecheCheckIn =
      await CheckInResponseHelper().callCrecheCheckInResponses();
      var ImageFileData = await ImageFileTabHelper().getImageForUpload();

      syncCount =
          crecheCheckIn.length +
              ImageFileData.length;
    }
    else if (role == CustomText.safetyManager) {
      var crecheCheckIn = await CheckInResponseHelper().callCrecheCheckInResponses();
      var ImageFileData = await ImageFileTabHelper().getImageForUpload();
      var visitNots = await CmcSMTabResponseHelper().getSMForUpload();

      syncCount =
          crecheCheckIn.length +
              ImageFileData.length+visitNots.length;
    }
    else {
      var grievanceData = await ChildGrievancesTabResponceHelper()
          .getChildGrievanceForUploadDarft();
      syncCount = grievanceData.length;
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
      if (shouldDownloadFirst)
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.downloadFiyrst, lng),
            Global.returnTrLable(locationControlls, CustomText.ok, lng),
            false,
            context);
      else
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
    } else if (i > 1 && i < 12) {
      if (shouldDownloadFirst) {
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.downloadFiyrst, lng),
            Global.returnTrLable(locationControlls, CustomText.ok, lng),
            false,
            context);
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DashReportCardDetailForHomeScreen(
                  title: Global.returnTrLable(locationControlls, text[i], lng),
                  query_type: getQueryTitle(i),
                  month: getMonthList(
                      DateTime.now().year)[(DateTime.now().month) - 1],
                  year: '${DateTime.now().year}',
                  selectedCrecheStatus: OptionsModel(
                    name: '3',
                    values: '3',
                    flag: null, // Set flag to null
                  ),
                )));
      }
    } else if (i == 12) {
      if (role == CustomText.crecheSupervisor.trim()) {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => FollowUpTabScreenAllChild(
                  tabTitle: Global.returnTrLable(
                      locationControlls, CustomText.fllowUp, lng),
                  tabOneTitle: Global.returnTrLable(
                      locationControlls, CustomText.schduleDate, lng),
                  tabTwoTitle: Global.returnTrLable(
                      locationControlls, CustomText.complted, lng),
                )));
      }
      // else if (role == CustomText.clusterCoordinator.trim()) {
      else {
        refStatus = await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                FollowCompletedListForCC(isHomeScreen: true)));
      }
    } else if (i == 13) {
      if (shouldDownloadFirst) {
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.downloadFiyrst, lng),
            Global.returnTrLable(locationControlls, CustomText.ok, lng),
            false,
            context);
      } else {
        if (role == CustomText.clusterCoordinator) {
          refStatus = await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AllcmcCCListingScreen()));
        } else if (role == CustomText.crecheSupervisor) {
          refStatus = await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  AllCrecheMonitorListingScreen()));
        } else if (role == CustomText.alm) {
          refStatus = await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AllcmcALMListingScreen()));
        } else if (role == CustomText.cbm) {
          refStatus = await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AllcmcCBMListingScreen()));
        } else if (role == CustomText.safetyManager) {
          refStatus = await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AllcmcSMListingScreen()));
        }
      }
    }
    // else if (i == 4) {
    //   // if (role == CustomText.crecheSupervisor.trim() ||
    //   //     role == CustomText.clusterCoordinator.trim()) {
    //   refStatus = await Navigator.of(context).push(MaterialPageRoute(
    //       builder: (BuildContext context) => VillageProfileListingScreen()));
    //   // }
    // }
    // else if (i == 5) {
    //   // if (role == CustomText.crecheSupervisor.trim() ||
    //   //     role == CustomText.clusterCoordinator.trim()) {
    //   if (shouldDownloadFirst) {
    //     Validate().singleButtonPopup(
    //         Global.returnTrLable(
    //             locationControlls, CustomText.downloadFiyrst, lng),
    //         Global.returnTrLable(locationControlls, CustomText.ok, lng),
    //         false,
    //         context);
    //   } else
    //     refStatus = await Navigator.of(context).push(MaterialPageRoute(
    //         builder: (BuildContext context) => GrievanceHomeListing()));
    //   // }
    // }
    else if (i == 14) {
      refStatus = await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SynchronizationScreenNew()));
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
              locationControlls, CustomText.token_expired, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
      Validate().saveString(
          Validate.doctypeUpdateTimeStamp, DateTime.now().toString());

      // Validate().saveString(Validate.cashbookRecieptMetaUpdateDate,
      //     cashbookReceiptMetaFields.tab_cashbook_receipt!.modified!);
      if (role == CustomText.clusterCoordinator) {
        await callCMCCCMetaApi(userName, password, token, false);
      } else if (role == CustomText.crecheSupervisor) {
        await crecheMonitoringApiMeta(userName, password, token, false);
      } else if (role == CustomText.alm) {
        await callCMCALMMetaApi(userName, password, token, false);
      } else if (role == CustomText.cbm){
        await callCMCCBMMetaApi(userName, password, token, false);
      } else if (role == CustomText.safetyManager){
        await callSMCheckListMMetaApi(userName, password, token, false);
      }else {
        Navigator.pop(context);
        countDataExcution();
      }

      // Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
              locationControlls, CustomText.token_expired, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
    }
    else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    }
    else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    }
  }

  callSMCheckListMMetaApi(
      String userName, String password, String token, bool only) async {
    if (only) showLoaderDialog(context);
    var responce = await CrecheMonetringCheckListSMApi()
        .smCheckListMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      CheckListSMMetaFieldsModel cmcCBMMEtaFields =
      CheckListSMMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertSMCheckListData(cmcCBMMEtaFields);

      Navigator.pop(context);
    }
    else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    }
    else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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

  Future<void> callInsertSMCheckListData(CheckListSMMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_Monitering_CheckList_SM');
    if (items.tabCreche_Monitoring_CheckList_SM != null) {
      await CrecheMoniteringCheckListSMFieldsHelper()
          .insertcmcSMMeta(items.tabCreche_Monitoring_CheckList_SM!.fields!);
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
    }
    else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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

      if (shouldDownloadFirst) {
        print("Data needs to be downloaded first ====>");
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.downloadFiyrst, lng),
            Global.returnTrLable(locationControlls, CustomText.ok, lng),
            false,
            context);
      }
    } else if (response.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng))),
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
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
              locationControlls, CustomText.token_expired, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
              locationControlls, CustomText.token_expired, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
              locationControlls, CustomText.token_expired, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
              locationControlls, CustomText.token_expired, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
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
    // showLoaderDialog(context);

    var crecheCheckIn =
        await CheckInResponseHelper().callCrecheCheckInResponses();
    var grievanceData = await ChildGrievancesTabResponceHelper()
        .getChildGrievanceForUploadDarft();
    var ImageFileData = await ImageFileTabHelper().getImageForUpload();
    var creCheMonitoring = await CmcCCTabResponseHelper().getCcForUpload();

    // Navigator.pop(context);
    int totalPendingCount = crecheCheckIn.length +
        grievanceData.length +
        creCheMonitoring.length +
        ImageFileData.length;

    return totalPendingCount;
  }

  Future<int> callCountForUpload() async {
    // showLoaderDialog(context);
    var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
    hhItems = hhItems
        .where((element) =>
            Global.stringToInt(Global.getItemValues(
                element.responces!, 'verification_status')) >
            1)
        .toList();
    var childEnrollExitData =
        await EnrolledExitChilrenResponceHelper().callChildrenForUpload();
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

    // Navigator.pop(context);
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

  Future<int> callDarftData() async {
    if (role == CustomText.crecheSupervisor) {
      var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
      var childEnrollExitData = await EnrolledExitChilrenResponceHelper()
          .callChildrenForUploadDarftEdited();
      // var childProfile = await EnrolledChilrenResponceHelper().callChildrenForUpload();
      var villageProfile = await await CrecheMonitorResponseHelper()
          .getVillageProfileforUploadDarftEdit();
      var creCheMonitoring = await CrecheMonitorResponseHelper()
          .getVillageProfileforUploadDarftEdit();
      var chilAttendence = await ChildAttendanceResponceHelper()
          .callChildAttendencesAllForUpoadEditDarft();
      return (hhItems.length +
          childEnrollExitData.length +
          villageProfile.length +
          creCheMonitoring.length +
          chilAttendence.length);
    } else if (role == CustomText.clusterCoordinator) {
      var creCheMonitoring =
          await CmcCCTabResponseHelper().getCcForUploadEditDarft();
      return creCheMonitoring.length;
    } else if (role == CustomText.alm) {
      var visitNots =
          await CmcALMTabResponseHelper().getAlmForUploadDarftEdited();
      return visitNots.length;
    } else if (role == CustomText.cbm) {
      var visitNots = await CmcCBMTabResponseHelper().getCBMForUploadDarft();
      return visitNots.length;
    }
    return 0;
  }

  Future<void> callBackdatedConfigirationData() async {
    var network = await Validate().checkNetworkConnection();
    if (network) {
      var userName = (await Validate().readString(Validate.userName))!;
      var password = (await Validate().readString(Validate.Password))!;
      var token = (await Validate().readString(Validate.appToken))!;
      showLoaderDialog(context);
      var logisResponce = await MasterApiService()
          .backdatedConfigiration(userName, password, token);
      if (logisResponce.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(logisResponce.body);
        await initBackdatedConfigirationData(
            BackdatedConfigirationModelApiModel.fromJson(responseData));
        await callMasterData(userName, password, token);
      } else if (logisResponce.statusCode == 401) {
        await handleUnauthorized();
      } else {
        Navigator.pop(context);
        Validate().singleButtonPopup(
            Global.errorBodyToString(logisResponce.body, 'message'),
            'ok',
            false,
            context);
      }
    }
  }

  Future<void> initBackdatedConfigirationData(
      BackdatedConfigirationModelApiModel? item) async {
    if (item != null) {
      List<BackdatedConfigirationModel>? items =
          item.backdatedConfigirationModel;
      if (items.isNotEmpty) {
        await BackdatedConfigirationHelper()
            .insertBackdatedConfigirationModel(items);
      }
    }
  }

  Future<void> callMasterData(
      String userName, String password, String token) async {
    var msterDataResponse =
        await MasterApiService().fetchmasterData(userName, password, token);

    if (msterDataResponse.statusCode == 200) {
      MasterDataModel masterDataApiModel =
          MasterDataModel.fromJson(json.decode(msterDataResponse.body));
      await initMasterData(masterDataApiModel);
      Navigator.pop(context);
      var householdForm = await Validate().readString(Validate.householdForm);
      if (householdForm != null) {
        await callModifiedFieldData();
      } else {
        await callFieldData(false);
      }
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(msterDataResponse.body, 'message'),
          'ok',
          false,
          context);
    }
  }

  Future initMasterData(MasterDataModel master) async {
    /////////Height Weight for age
    if (master.tabHeightforAgeBoys != null) {
      await HeightWeightBoysGirlsHelper()
          .insertHeightForAgeBoys(master.tabHeightforAgeBoys!);
    }

    if (master.tabHeightforAgeGirls != null) {
      await HeightWeightBoysGirlsHelper()
          .insertHeightForAgeGirls(master.tabHeightforAgeGirls!);
    }

    if (master.tabWeightforAgeBoys != null) {
      await HeightWeightBoysGirlsHelper()
          .insertWeightForAgeBoys(master.tabWeightforAgeBoys!);
    }

    if (master.tabWeightforAgeGirls != null) {
      await HeightWeightBoysGirlsHelper()
          .insertWeightForAgeGirls(master.tabWeightforAgeGirls!);
    }
    if (master.tabWeightToHeightBoys != null) {
      await HeightWeightBoysGirlsHelper()
          .insertWeightToHeightBoys(master.tabWeightToHeightBoys!);
    }

    if (master.tabWeightToHeightGirls != null) {
      await HeightWeightBoysGirlsHelper()
          .insertWeightToHeightGirls(master.tabWeightToHeightGirls!);
    }
  }

  Widget homeScreenCardItem(int i) {
    return InkWell(
      onTap: () async {
        onclick(i, image[i], lng);
      },
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xff5A5A5A)
                    .withOpacity(0.1), // Shadow color with opacity
                offset: Offset(0, 1), // Horizontal and vertical offset
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
                          width: 60,
                          child: Image.asset(
                            height: 30,
                            width: 30,
                            image[i],
                            filterQuality: FilterQuality.high,
                            // scale: image[i] == 'assets/creche_profile/flagged_children_new.png' ||
                            //     image[i] == 'assets/creche_profile/child_followUp_new.png' ||
                            //     image[i] == 'assets/village_ic.png'
                            //     ? 0.9
                            //     : 3.8,
                            color: image[i] ==
                                    'assets/creche_profile/flagged_children_new.png'
                                ? null
                                : Color(0xff5979AA),
                          ),
                        ),
                        // if (image[i] == 'assets/shishughar.png'||
                        //     image[i]=='assets/creche_profile/flagged_children_new.png'||
                        //     image[i]=='assets/creche_profile/child_followUp_new.png')
                        if (getCount(image[i]) > 0)
                          Positioned(
                            left: 30,
                            bottom: 10,
                            child: Container(
                              alignment: Alignment.center,
                              height: 25,
                              // Smaller badge size
                              width: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffF26BA3),
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: Text(
                                "${getCount(image[i])}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
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
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      Global.returnTrLable(locationControlls, text[i], lng),
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
  }

  countDataExcution() async {
    itemCount = {
      'assets/shishughar.png': 0,
      'assets/creche_profile/flagged_children_new.png': 0,
      'assets/creche_profile/child_followUp_new.png': 0,
      'assets/creche_profile/creche_profile_new.png': 0,
      'assets/creche_profile/attendance.png': 0,
      'assets/creche_profile/anatomy.png': 0,
      'assets/creche_profile/enrolled_child_new.png': 0,
      'assets/creche_profile/health_detail_new.png': 0,
    };

    showLoaderDialog(context);
    final results = await Future.wait([
      DashboardReportHelper().excuteCrecheCount(
          crecheStatus: '3', filterDate: Global.initCurrentDate()),
      DashboardReportHelper().excuteNoOfCrecheNotSubmitedAttendence(
          crecheStatus: '3', filterDate: Global.initCurrentDate()),
      DashboardReportHelper().excuteAnthroDataNotSubmitted(
          crecheStatus: '3', filterDate: Global.initCurrentDate()),
      DashboardReportHelper().excuteChildrenMeasermentNotTaken(
          crecheStatus: '3', filterDate: Global.initCurrentDate()),
      DashboardReportHelper().excuteChildrenMeasermentTaken(
          crecheStatus: '3', filterDate: Global.initCurrentDate()),
      ChildGrowthResponseHelper().allAnthormentry(),
      DashboardReportHelper().excuteCurrentActiveChildren(
          crecheStatus: '3', filterDate: Global.initCurrentDate()),
      DashboardReportHelper().excuteCurrentEligibleButNotEnrlolledChild(
          crecheStatus: '3', filterDate: Global.initCurrentDate())
    ]);
    itemCount['assets/shishughar.png'] = results[0].length;
    itemCount['assets/creche_profile/attendance.png'] = results[1].length;
    itemCount['assets/creche_profile/anatomy.png'] = results[2].length;
    itemCount['assets/creche_profile/health_detail_new.png'] =
        results[3].length;
    itemCount['assets/creche_profile/creche_profile_new.png'] =
        results[6].length;
    itemCount['assets/creche_profile/enrolled_child_new.png'] =
        results[7].length;
    itemCount['assets/ic_sync_n.png'] = syncCount;
    var allAnthoItem = results[5] as List<ChildGrowthMetaResponseModel>;
    var mesumentTaken = results[4] as List<Map<String, dynamic>>;

    callAnthoItemsCount(mesumentTaken, allAnthoItem);
  }

  callAnthoItemsCount(List<Map<String, dynamic>> childrenMeasurementTaken,
      List<ChildGrowthMetaResponseModel> allAntroData) async {
    final results = await Future.wait([
      DashboardReportHelper().excuteGF1AllAnthro(
          childrenMeasurementTaken: childrenMeasurementTaken,
          allAntroData: allAntroData),
      DashboardReportHelper().excuteGF2MeasurementTakenAllAnthro(
          childrenMeasurementTaken: childrenMeasurementTaken,
          allAntroData: allAntroData),
      DashboardReportHelper().excuteRedFlagMeasurmentTakenAllAnthro(
          childrenMeasurementTaken: childrenMeasurementTaken,
          allAntroData: allAntroData),
      DashboardReportHelper().excuteChildrenAtRiskMeasurmentTakenAllAnthro(
          childrenMeasurementTaken: childrenMeasurementTaken,
          allAntroData: allAntroData),
      DashboardReportHelper().excuteSeverelyStunted(
          crecheStatus: '3', filterDate: Global.initCurrentDate()),
      DashboardReportHelper().excuteSeverUnderWeight(
          crecheStatus: '3', filterDate: Global.initCurrentDate()),
    ]);
    itemCount['assets/creche_profile/gf_1.png'] = results[0].length;
    itemCount['assets/creche_profile/gf_2.png'] = results[1].length;
    itemCount['assets/creche_profile/flagged_children_new.png'] =
        results[2].length;
    itemCount['assets/creche_profile/child_at_risk.png'] = results[3].length;
    itemCount['assets/creche_profile/sam.png'] = results[4].length;
    itemCount['assets/creche_profile/suw.png'] = results[5].length;

    // if (results[2].length > 0) {
    //   var submitedId = '';
    //   for (int i = 0; i < results[2].length; i++) {
    //     if (Global.validString(submitedId)) {
    //       submitedId = "$submitedId,'${results[2][i]['childenrollguid']}'";
    //     } else
    //       submitedId = "'${results[2][i]['childenrollguid']}'";
    //   }
    //   if(Global.validString(submitedId)){
    //    var redFlagItems = await DashboardReportHelper().excuteGetChildrenByGUIDES(
    //         childIdes: submitedId);
    //    itemCount['assets/creche_profile/flagged_children_new.png'] =
    //        redFlagItems.length;
    //   }
    // }

    Navigator.pop(context);
    setState(() {});
  }

  int getCount(String key) {
    if (itemCount.containsKey(key)) {
      return itemCount[key] ?? 0;
    } else
      return 0;
  }

  String getQueryTitle(int i) {
    String queryTitle = '';
    if (image[i] == 'assets/creche_profile/attendance.png') {
      queryTitle = 'NoOfCrechesNotSubmittedAttendance';
    } else if (image[i] == 'assets/creche_profile/anatomy.png') {
      queryTitle = 'AnthroDataNotSubmitted';
    } else if (image[i] == 'assets/creche_profile/health_detail_new.png') {
      queryTitle = 'ChildrenMeasurementNotTaken';
    } else if (image[i] == 'assets/creche_profile/creche_profile_new.png') {
      queryTitle = 'CurrentActiveChildren';
    } else if (image[i] == 'assets/creche_profile/enrolled_child_new.png') {
      queryTitle = 'NotEligbleButNotEnrolled';
    } else if (image[i] == 'assets/creche_profile/gf_1.png') {
      queryTitle = 'Growthfaltering1';
    } else if (image[i] == 'assets/creche_profile/gf_2.png') {
      queryTitle = 'Growthfaltering2';
    } else if (image[i] == 'assets/creche_profile/child_at_risk.png') {
      queryTitle = 'childrenAtRisk';
    } else if (image[i] == 'assets/creche_profile/sam.png') {
      queryTitle = 'SeverelyStunted';
    } else if (image[i] == 'assets/creche_profile/suw.png') {
      queryTitle = 'SeverelyUnderweight';
    }
    return queryTitle;
  }

  List<OptionsModel> getMonthList(int year) {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int monthLimit = (year == currentYear) ? currentMonth : 12;
    List<String> months = [
      CustomText.January,
      CustomText.February,
      CustomText.March,
      CustomText.April,
      CustomText.May,
      CustomText.June,
      CustomText.July,
      CustomText.August,
      CustomText.September,
      CustomText.October,
      CustomText.November,
      CustomText.December,
    ];
    return List.generate(
      monthLimit,
      (index) => OptionsModel(
        name: (index + 1).toString(), // Month name
        values: months[index], // Month number (1-12)
        flag: null, // Set flag to null
      ),
    );
    // If the input year is the current year, return only past & current months
    // return (year == currentYear) ? months.sublist(0, currentMonth) : months;
  }
}
