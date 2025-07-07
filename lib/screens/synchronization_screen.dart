import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/src/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/api/child_enrolled_exit_api.dart';
import 'package:shishughar/api/requisition_api.dart';
import 'package:shishughar/api/stock_api.dart';

import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/creche_helper/creche_data_helper.dart';
import 'package:shishughar/database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/database/helper/master_stock_helper.dart';
import 'package:shishughar/database/helper/partner_stock_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
import 'package:shishughar/database/helper/stock/stock_response_helper.dart';

import 'package:shishughar/screens/pendingSyncScreen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/doctype_update.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../api/cashBook_expenses_api.dart';
import '../api/cashbook_receipt_api.dart';
import '../api/child_attendance_download_api.dart';
import '../api/child_event_download_api.dart';
import '../api/child_followup_download-api.dart';
import '../api/child_grievance_download_api.dart';
import '../api/child_growth_dowload_api.dart';
import '../api/child_health_download_api.dart';
import '../api/child_immunization_download_api.dart';
import '../api/child_profile_data_download.api.dart';
import '../api/child_referral_download_api.dart';
import '../api/creche_Monitering_checkList_alm_api.dart';
import '../api/creche_checkIn_api.dart';
import '../api/creche_committie_download_api.dart';
import '../api/creche_data_api.dart';
import '../api/creche_monetering_checkList_cbm_api.dart';
import '../api/creche_monitoring_api.dart';
import '../api/download_data_api.dart';
import '../api/form_logic_api.dart';
import '../api/hh_data_upload_api.dart';
import '../api/language_translation_api.dart';
import '../api/master_api.dart';
import '../api/user_manual_pdf_api.dart';
import '../api/village_profile_meta_api.dart';
import '../custom_widget/double_button_dailog.dart';
import '../database/helper/anthromentory/child_growth_response_helper.dart';
import '../database/helper/block_data_helper.dart';
import '../database/helper/cashbook/expences/cashbook_response_expences_helper.dart';
import '../database/helper/cashbook/receipt/cashbook_receipt_response_helper.dart';
import '../database/helper/check_in/check_in_response_helper.dart';
import '../database/helper/child_attendence/attendance_responce_helper.dart';
import '../database/helper/child_attendence/child_attendance_helper_responce.dart';
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
import '../database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
import '../database/helper/district_data_helper.dart';
import '../database/helper/dynamic_screen_helper/house_hold_children_helper.dart';
import '../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import '../database/helper/follow_up/child_followUp_response_helper.dart';
import '../database/helper/form_logic_helper.dart';
import '../database/helper/gram_panchayat_data_helper.dart';
import '../database/helper/height_weight_boys_girls_helper.dart';
import '../database/helper/image_file_tab_responce_helper.dart';

import '../database/helper/mst_common_helper.dart';
import '../database/helper/mst_supervisor_helper.dart';

import '../database/helper/state_data_helper.dart';
import '../database/helper/translation_language_helper.dart';
import '../database/helper/user_manual_fields_meta_helper.dart';
import '../database/helper/vaccines_helper.dart';
import '../database/helper/village_data_helper.dart';
import '../database/helper/village_profile/village_profile_response_helper.dart';
import '../model/apimodel/form_logic_api_model.dart';
import '../model/apimodel/master_data_model.dart';
import '../model/apimodel/mater_data_other_model.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../model/databasemodel/tabBlock_model.dart';
import '../model/databasemodel/tabDistrict_model.dart';
import '../model/databasemodel/tabGramPanchayat_model.dart';
import '../model/databasemodel/tabVillage_model.dart';
import '../model/databasemodel/tabstate_model.dart';
import '../model/dynamic_screen_model/house_hold_tab_responce_model.dart';
import '../utils/validate.dart';
import 'coordinator_location_screen.dart';
import 'dashboardscreen_new.dart';
import 'login_screen.dart';

class SynchronizationScreen extends StatefulWidget {
  const SynchronizationScreen({super.key});

  @override
  State<SynchronizationScreen> createState() => _SynchronizationScreenState();
}

class _SynchronizationScreenState extends State<SynchronizationScreen> {
  List<String> image = [
    'assets/childrenenrolled.png',
    'assets/childrenenrolled.png',
    'assets/ic_master_data.png',
    'assets/ic_master_data.png',
  ];
  List<Translation> locationControlls = [];
  List<String> text = [
    CustomText.downloadData,
    CustomText.uploadData,
    CustomText.masterData,
    CustomText.updateDoctype
  ];

  var role;
  String? lngtr;
  String dataDownloadDateTime = '';
  String dataUploadDateTime = '';
  String msterDownloadDateTime = '';
  String doctypeUpdateDateTime = '';
  int pendindTaskCount = 0;
  int totalApiCount = 0;
  int downloadedApi = 0;
  double percetageCode = 0;
  late StateSetter dialogSetState;
  int loadingText = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, 'itemRefresh');
          return false;
        },
        child: Scaffold(
          appBar: CustomAppbar(
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context, 'itemRefresh');
                },
                child: Image.asset(
                  "assets/home.png",
                  color: Colors.white,
                  scale: 2,
                ),
              ),
              SizedBox(width: 25)
            ],
            text: (lngtr != null)
                ? Global.returnTrLable(locationControlls, CustomText.sync, lngtr!)
                : "",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardScreen(
                          index: 0,
                        )),
              );
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
                      return Container();
                    }),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: text.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () async {
                          if (i == 0) {
                            if (role == 'Creche Supervisor') {
                              if (pendindTaskCount == 0) {
                                var hhItems = await HouseHoldTabResponceHelper()
                                    .getHouseHoldItems();
                                // var childProfile = await EnrolledChilrenResponceHelper().callChildrenForUpload();
                                var childEnrollExitData =
                                    await EnrolledExitChilrenResponceHelper()
                                        .callChildrenForUploadDarftEdited();
                                var villageProfile =
                                    await await CrecheMonitorResponseHelper()
                                        .getVillageProfileforUploadDarftEdit();
                                var creCheMonitoring =
                                    await CrecheMonitorResponseHelper()
                                        .getVillageProfileforUploadDarftEdit();
                                var chilAttendence =
                                    await ChildAttendanceResponceHelper()
                                        .callChildAttendencesAllForUpoadEditDarft();

                                var daftCount = hhItems.length +
                                    childEnrollExitData.length +
                                    villageProfile.length +
                                    chilAttendence.length +
                                    // childProfile.length +
                                    creCheMonitoring.length;
                                if (daftCount == 0) {
                                  totalApiCount = 19;
                                  callVillageFilterData(context);
                                } else {
                                  Validate().singleButtonPopup(
                                      Global.returnTrLable(
                                          locationControlls,
                                          CustomText.darftDataForComplete,
                                          lngtr!),
                                      Global.returnTrLable(locationControlls,
                                          CustomText.ok, lngtr!),
                                      false,
                                      context);
                                }
                              } else
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(locationControlls,
                                        CustomText.pleaseUploadDataFirst, lngtr!),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lngtr!),
                                    false,
                                    context);
                            } else {
                              if (pendindTaskCount == 0) {
                                List<dynamic> visitNotes = [];
                                if (role == CustomText.clusterCoordinator)
                                  visitNotes = await CmcCCTabResponseHelper()
                                      .getCcForUploadEditDarft();
                                else if (role == CustomText.alm)
                                  visitNotes = await CmcALMTabResponseHelper()
                                      .getAlmForUploadDarftEdited();
                                else if (role == CustomText.cbm)
                                  visitNotes = await CmcCBMTabResponseHelper()
                                      .getCBMForUploadDarft();
                                var crecheCheckIn = await CheckInResponseHelper()
                                    .callCrecheCheckInResponses();

                                var grievanceData =
                                    await ChildGrievancesTabResponceHelper()
                                        .getChildGrievanceForUpload();

                                var ImageFileData = await ImageFileTabHelper()
                                    .getImageForUpload();
                                var usynchedData = visitNotes.length +
                                    crecheCheckIn.length +
                                    grievanceData.length +
                                    ImageFileData.length;
                                if (usynchedData == 0) {
                                  // totalApiCount = 19;
                                  // callVillageFilterDataCC(context);
                                  var syncItem = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CoordinatorLocationScreen(
                                              role: role,
                                            )),
                                  );
                                  if (syncItem == 'itemRefresh') {
                                    await initializeData();
                                  }
                                } else {
                                  Validate().singleButtonPopup(
                                      Global.returnTrLable(
                                          locationControlls,
                                          CustomText.darftDataForComplete,
                                          lngtr!),
                                      Global.returnTrLable(locationControlls,
                                          CustomText.ok, lngtr!),
                                      false,
                                      context);
                                }
                              } else
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(locationControlls,
                                        CustomText.pleaseUploadDataFirst, lngtr!),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lngtr!),
                                    false,
                                    context);
                            }
                          }
                          else if (i == 1) {
                            String refStatus = '';
                            if (role == CustomText.crecheSupervisor) {
                              if (pendindTaskCount > 0) {
                                refStatus = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PendingSyncScreen()),
                                    ) ??
                                    '';
                              } else
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(
                                        locationControlls,
                                        CustomText.nothing_for_upload_msg,
                                        lngtr!),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lngtr!),
                                    false,
                                    context);
                            } else if (role == CustomText.clusterCoordinator) {
                              if (pendindTaskCount > 0) {
                                refStatus = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PendingSyncScreen()),
                                    ) ??
                                    '';
                              } else
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(
                                        locationControlls,
                                        CustomText.nothing_for_upload_msg,
                                        lngtr!),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lngtr!),
                                    false,
                                    context);
                            } else if (role == 'Accounts and Logistics Manager') {
                              var visitNots = await CmcALMTabResponseHelper()
                                  .getAlmForUpload();
                              if (pendindTaskCount > 0) {
                                refStatus = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PendingSyncScreen()),
                                    ) ??
                                    '';
                              } else
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(
                                        locationControlls,
                                        CustomText.nothing_for_upload_msg,
                                        lngtr!),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lngtr!),
                                    false,
                                    context);
                            } else if (role == 'Capacity and Building Manager') {
                              var visitNots = await CmcCBMTabResponseHelper()
                                  .getCBMForUpload();
                              if (pendindTaskCount > 0) {
                                refStatus = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PendingSyncScreen()),
                                    ) ??
                                    '';
                              } else
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(
                                        locationControlls,
                                        CustomText.nothing_for_upload_msg,
                                        lngtr!),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lngtr!),
                                    false,
                                    context);
                            } else {
                              if (pendindTaskCount > 0) {
                                refStatus = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PendingSyncScreen()),
                                    ) ??
                                    '';
                              } else
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(
                                        locationControlls,
                                        CustomText.nothing_for_upload_msg,
                                        lngtr!),
                                    Global.returnTrLable(
                                        locationControlls, CustomText.ok, lngtr!),
                                    false,
                                    context);
                            }
                            if (refStatus == 'itemRefresh') {
                              await initializeData();
                            }
                          }
                          else if (i == 2) {
                            totalApiCount = 5;
                            callMasterData(context);
                          } else if (i == 3) {
                            try {
                              await DoctypeUpdate(
                                      locationControlls: locationControlls,
                                      lng: lngtr!,
                                      role: role,
                                      mt: mounted)
                                  .callFieldData(context);
                              setState(() {});
                            } catch (e) {
                              print("Error Updating doctype - $e");
                            }
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 136.h,
                              width: 170.w,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xff5A5A5A).withOpacity(
                                          0.2), // Shadow color with opacity
                                      offset: Offset(
                                          0, 3), // Horizontal and vertical offset
                                      blurRadius: 6, // Blur radius
                                      spreadRadius: 0, // Spread radius
                                    ),
                                  ],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        (i == 1)
                                            ? Stack(
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                    width: 40,
                                                    child: Image.asset(image[i],
                                                        filterQuality:
                                                            FilterQuality.high,
                                                        scale: 4.2,
                                                        color: Color(0xff5979AA)),
                                                  ),
                                                  pendindTaskCount > 0
                                                      ? Positioned(
                                                          top: 0,
                                                          bottom: 24,
                                                          left: 27,
                                                          right: 0,
                                                          child: Container(
                                                            alignment:
                                                                Alignment.center,
                                                            height: 80,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape:
                                                                  BoxShape.circle,
                                                              color: Color(
                                                                  0xffF26BA3),
                                                            ),
                                                            // padding: EdgeInsets.all(4),
                                                            child: Text(
                                                              pendindTaskCount > 9
                                                                  ? '9+'
                                                                  : '$pendindTaskCount',
                                                              style:
                                                                  Styles.white74P,
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              )
                                            : Image.asset(
                                                image[i],
                                                filterQuality: FilterQuality.high,
                                                scale: 4,
                                                color: Color(0xff5979AA),
                                              ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 7),
                                          child: Text(
                                            (lngtr != null)
                                                ? Global.returnTrLable(
                                                    locationControlls,
                                                    text[i],
                                                    lngtr!)
                                                : '',
                                            style: Styles.black123,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 7),
                                          child: Text(
                                            (i == 0)
                                                ? dataDownloadDateTime
                                                : (i == 1)
                                                    ? dataUploadDateTime
                                                    : (i == 2)
                                                        ? msterDownloadDateTime
                                                        : doctypeUpdateDateTime,
                                            style: Styles.black123,
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: 20),
                            //   child: Divider(
                            //     indent: 40,
                            //     endIndent: 40,
                            //     color: Color(0xffEAEAEA),
                            //   ),
                            // )
                            (text.length - 1) > i
                                ? Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Divider(
                                      indent: 60,
                                      endIndent: 60,
                                      color: Color(0xffEAEAEA),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      );
                    },
                    // itemBuilder: (ctx, i) {
                    //   return InkWell(
                    //     onTap: () async {
                    //       if (i == 0) {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => DownloadTempletScreen()),
                    //         );
                    //        }
                    //       else if (i == 2) {
                    //         var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
                    //         if(hhItems.length>0){
                    //           uploadData(hhItems);
                    //         }else{
                    //           Validate().singleButtonPopup(
                    //               "Nothing for upload",
                    //               false,
                    //               context);
                    //         }
                    //
                    //       }
                    //       else if (i == 1) {
                    //         callVillageFilterData();
                    //       }
                    //     },
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left: 60,right: 60,bottom: 10),
                    //       child: Container(
                    //         height: 130.h,
                    //         // width: 70.w,
                    //         decoration: BoxDecoration(
                    //             color: Color(0xffF2F7FF),
                    //             borderRadius: BorderRadius.circular(5.r),
                    //             border: Border.all(
                    //               color: Color(0xffE7F0FF),
                    //             )),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Expanded(
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.center,
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Image.asset(
                    //                     image[i],
                    //                     filterQuality: FilterQuality.high,
                    //                     scale: 4,
                    //                     color: Color(0xff5979AA),
                    //                   ),
                    //                   SizedBox(
                    //                     height: 15.h,
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.symmetric(horizontal: 7),
                    //                     child: Text(
                    //                       text[i],
                    //                       style: Styles.black123,
                    //                       textAlign: TextAlign.center,
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   );
                    // },
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 3,
                    //     crossAxisSpacing: 8,
                    //     mainAxisSpacing: 8,
                    //     mainAxisExtent: 90.h),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadData(List<HouseHoldTabResponceMosdel> hhItems) async {
    var shouldProceed = await showDialog(
      context: context,
      builder: (context) {
        return DoubleButtonDailog(
          posButton:
              Global.returnTrLable(locationControlls, CustomText.Yes, lngtr!),
          negButton:
              Global.returnTrLable(locationControlls, CustomText.No, lngtr!),
          message: Global.returnTrLable(
              locationControlls, CustomText.do_you_want_to_upload, lngtr!),
        );
      },
    );

    if (shouldProceed) {
      // List<Map<String, dynamic>> postData = [];

      if (hhItems.length > 0) {
        showLoaderDialog(context);
        hhItems.forEach((element) async {
          var cItems = await HouseHoldChildrenHelperHelper()
              .getResponceHouseHoldChildren(element.HHGUID!);
          Map<String, dynamic> resultMap = jsonDecode(element.responces!);
          List<dynamic> childrensList = [];

          for (var cItem in cItems) {
            childrensList.add(jsonDecode(cItem));
          }

          resultMap['children'] = childrensList;
          // resultMap['verification_status'] = "3";
          // postData.add(resultMap);

          var token = await Validate().readString(Validate.appToken);
          // if (element.name != null) {
          //   await HHDataUploadApi()
          //       .uploadHHDataUpdate(token!, element.name!, resultMap)
          //       .then((value) async => await updateResponces(value));
          // } else {
          //   await HHDataUploadApi()
          //       .uploadHHData(token!, resultMap)
          //       .then((value) async => await updateResponces(value));
          // }
          // };
        });
        // }
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.data_upload_success_msg, lngtr!),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            context);

        Navigator.pop(context);
      } else {
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lngtr!),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            context);
      }
    }
  }

  Future<void> downloadData(List<HouseHoldTabResponceMosdel> hhItems) async {
    var shouldProceed = await showDialog(
      context: context,
      builder: (context) {
        return DoubleButtonDailog(
          posButton:
              Global.returnTrLable(locationControlls, CustomText.Yes, lngtr!),
          negButton:
              Global.returnTrLable(locationControlls, CustomText.No, lngtr!),
          message: Global.returnTrLable(
              locationControlls, CustomText.do_you_want_to_download, lngtr!),
        );
      },
    );

    if (shouldProceed) {
      if (hhItems.length > 0) {
        showLoaderDialog(context);
        hhItems.forEach((element) async {
          var token = await Validate().readString(Validate.appToken);
          if (element.name != null) {
            await HHDataUploadApi()
                .downloadHHData(token!, element.name!)
                .then((value) async => await updateResponces(value));
          }

          // };
        });
        // }
        var datadownsuccess = await TranslationDataHelper()
            .getTranslation(CustomText.data_downloaded_successfully, lngtr!);
        Validate().singleButtonPopup(
            datadownsuccess,
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            context);
        Navigator.pop(context);
      } else {
        var nothig_for_download = await TranslationDataHelper()
            .getTranslation(CustomText.nothing_for_download, lngtr!);
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.nothing_for_upload_msg, lngtr!),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            context);
      }
    }
  }

  Future<void> updateResponces(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await HouseHoldTabResponceHelper().updateUploadedItem(resultMap);
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  showLoaderDialog(BuildContext mContext) {
    loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
    showDialog(
      barrierDismissible: false,
      context: mContext,
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
                Text(
                    '${Global.returnTrLable(locationControlls, CustomText.pleaseWait, lngtr!)} ${(loadingText)}/100%'),
              ],
            ));
          }),
        );
      },
    );
  }

  callVillageFilterData(BuildContext mContext) async {
    downloadedApi = 0;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var selectedVillage = await VillageDataHelper().getTabVillageList();
      if (selectedVillage.length > 0) {
        showLoaderDialog(mContext);
        String villagesss = '';
        selectedVillage.forEach((element) {
          if (Global.validString(villagesss)) {
            villagesss = '$villagesss,${element.name}';
          } else
            villagesss = '${element.name}';
        });
        print(villagesss);
        // updateLoadingText(dialogSetState);
        var response = await DownloadDataApi()
            .callVillagesDataDownload(villagesss, userName!, password!, token!);
        if (response.statusCode == 200) {
          // Validate().singleButtonPopup(
          //     Global.returnTrLable(locationControlls, CustomText.data_downloaded_successfully, lngtr!),
          //     Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          //     false,
          //     mContext);

          await updateVillageResponces(response);
          // Navigator.pop(mContext);
          callVillageEnrolledChildProfileData(mContext);
        } else if (response.statusCode == 401) {
          Navigator.pop(mContext);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove(Validate.Password);
          ScaffoldMessenger.of(mContext).showSnackBar(
            SnackBar(
                content: Text(Global.returnTrLable(
                    locationControlls, CustomText.token_expired, lngtr!))),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (mContext) => LoginScreen(),
              ));
        } else {
          Navigator.pop(mContext);
          Validate().singleButtonPopup(
              Global.returnTrLable(locationControlls,
                  Global.errorBodyToString(response.body, 'message'), lngtr!),
              Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
              false,
              mContext);
        }
      } else {
        Validate().singleButtonPopup(
            Global.returnTrLable(
                locationControlls, CustomText.geoGraphyIsNotAssign, lngtr!),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  callVillageEnrolledChildProfileData(BuildContext mContext) async {
    downloadedApi = 1;
    var network = await Validate().checkNetworkConnection();
    // var villageId = await Validate().readInt(Validate.villageId);
    if (network) {
      updateLoadingText(dialogSetState);
      // showLoaderDialog(mContext);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await ChilProfileDataDownloadApi()
          .childProfileDataDownload(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateVillageEnrolledChildResponces(response);
        // Navigator.pop(mContext);
        await callChildAttendanceDownloadData(mContext);
        // Validate().singleButtonPopup(Global.returnTrLable(locationControlls,
        //     CustomText.data_downloaded_successfully, lngtr!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lngtr!), false, mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateVillageResponces(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await HouseHoldTabResponceHelper().downloadUpdateData(resultMap);
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> updateVillageEnrolledChildResponces(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      debugPrint(" responce $resultMap");
      await EnrolledChilrenResponceHelper().childProfileData(resultMap);
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<void> initializeData() async {
    lngtr = await Validate().readString(Validate.sLanguage);
    role = await Validate().readString(Validate.role);
    var dateDataDown =
        await Validate().readString(Validate.dataDownloadDateTime);
    if (dateDataDown != null) {
      dataDownloadDateTime =
          Validate().displeDateFormateMobileDateTimeFormate(dateDataDown);
    }

    var dataUploadDate =
        await Validate().readString(Validate.dataUploadDateTime);
    if (dataUploadDate != null) {
      dataUploadDateTime =
          Validate().displeDateFormateMobileDateTimeFormate(dataUploadDate);
    }

    var msterDownloadDate =
        await Validate().readString(Validate.msterDownloadDateTime);
    if (msterDownloadDate != null) {
      msterDownloadDateTime =
          Validate().displeDateFormateMobileDateTimeFormate(msterDownloadDate);
    }

    var doctypeDownloadDate =
        await Validate().readString(Validate.doctypeUpdateTimeStamp);
    if (doctypeDownloadDate != null) {
      doctypeUpdateDateTime = Validate()
          .displeDateFormateMobileDateTimeFormate(doctypeDownloadDate);
    }

    if (role == 'Creche Supervisor') {
      pendindTaskCount = await callCountForUpload();
    } else if (role == 'Cluster Coordinator') {
      pendindTaskCount = await callCountForUploadCC();
    } else if (role == 'Accounts and Logistics Manager') {
      var crecheCheckIn =
          await CheckInResponseHelper().callCrecheCheckInResponses();

      var grievanceData =
          await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();

      var ImageFileData = await ImageFileTabHelper().getImageForUpload();
      var visitNots = await CmcALMTabResponseHelper().getAlmForUpload();
      pendindTaskCount = visitNots.length +
          crecheCheckIn.length +
          grievanceData.length +
          ImageFileData.length;
    } else if (role == 'Capacity and Building Manager') {
      var crecheCheckIn =
          await CheckInResponseHelper().callCrecheCheckInResponses();

      var grievanceData =
          await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();

      var ImageFileData = await ImageFileTabHelper().getImageForUpload();
      var visitNots = await CmcCBMTabResponseHelper().getCBMForUpload();
      pendindTaskCount = visitNots.length +
          crecheCheckIn.length +
          grievanceData.length +
          ImageFileData.length;
    } else {
      var grievanceData = await ChildGrievancesTabResponceHelper()
          .getChildGrievanceForUploadDarft();
      pendindTaskCount = grievanceData.length;
    }

    List<String> valueNames = [
      CustomText.data_upload_success_msg,
      CustomText.nothing_for_upload_msg,
      CustomText.do_you_want_to_upload,
      CustomText.do_you_want_to_download,
      CustomText.Yes,
      CustomText.No,
      CustomText.data_downloaded_successfully,
      CustomText.sync,
      CustomText.masterData,
      CustomText.uploadData,
      CustomText.downloadData,
      CustomText.master_data_download,
      CustomText.nointernetconnectionavailable,
      CustomText.ok,
      CustomText.pleaseWait,
      CustomText.token_expired,
      CustomText.darftDataForComplete,
      CustomText.geoGraphyIsNotAssign,
      CustomText.pleaseUploadDataFirst,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => locationControlls = value);

    setState(() {});
  }

////

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Global.applyDisplayCutout(const Color(0xff5979AA));
    });
    initializeData();
  }

  Future initMasterData(MasterDataModel master) async {
    if (master != null) {
      List<TabState> stateList = master.tabState!;

      await StateDataHelper().insertMasterStates(stateList);

      List<TabBlock> blockList = master.tabBlock!;

      await BlockDataHelper().insertMasterBlock(blockList);

      List<TabDistrict> districtList = master.tabDistrict!;

      await DistrictDataHelper().insertMasterDistrict(districtList);

      List<TabVillage> villageList = master.tabVillage!;

      await VillageDataHelper().insertMasterVillage(villageList);

      List<TabGramPanchayat> gramPanchayatList = master.tabGramPanchayat!;

      await GramPanchayatDataHelper()
          .insertMasterGramPanchayat(gramPanchayatList);

      if (master.tabSuperVisor != null) {
        await MstSuperVisorHelper().inserts(master.tabSuperVisor!);
      }

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

      if (master.tabVaccines != null) {
        await VaccinesDataHelper().insert(master.tabVaccines!);
      }
      if (master.tabMasterStock != null) {
        await MasterStockHelper().insert(master.tabMasterStock!);
      }
      if (master.tabPartnerStock != null) {
        await PartnerStockHelper().insert(master.tabPartnerStock!);
      }
    }
  }

  Future<void> downMaster(BuildContext mContext, String userName,
      String password, String token) async {
    ////master user auth
    downloadedApi = 2;
    updateLoadingText(dialogSetState);
    var villagesList = await VillageDataHelper().getTabVillageList();
    String villagesListString = '';
    villagesList.forEach((element) {
      if (Global.validString(villagesListString)) {
        villagesListString = '$villagesListString,${element.name}';
      } else
        villagesListString = '${element.name}';
    });

    var masterOtherDataResponse = await MasterApiService()
        .fetchmasterOtherData(userName, password, token);
    if (masterOtherDataResponse.statusCode == 200) {
      MstCommonModel mstCommonModel =
          MstCommonModel.fromJson(json.decode(masterOtherDataResponse.body));

      await MstCommonHelper().insertMstCommonData(mstCommonModel.tabCommon!);

      await callApiLogicData(
          mContext, userName, password, token, villagesListString);
    } else if (masterOtherDataResponse.statusCode == 401) {
      Navigator.pop(mContext);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lngtr!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(mContext);
      var errorMsg =
          Global.errorBodyToString(masterOtherDataResponse.body, 'message');
      Validate().singleButtonPopup(
          errorMsg,
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          context);
    }
  }

  Future<void> callApiLogicData(BuildContext mContext, String userName,
      String password, String token, String villagesListString) async {
    downloadedApi = 3;
    updateLoadingText(dialogSetState);
    var logisResponce =
        await FormLogicApiService().fetchLogicData(userName, password, token);

    if (logisResponce.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(logisResponce.body);
      await initFormLogic(FormLogicApiModel.fromJson(responseData));
      await callApiTranslateData(
          mContext, userName, password, token, villagesListString);
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(logisResponce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          context);
    }
  }

  Future<void> callApiTranslateData(BuildContext mContext, String userName,
      String password, String token, String villagesListString) async {
    downloadedApi = 4;
    updateLoadingText(dialogSetState);
    var translateResponce =
        await TranslationService().translateApi(userName, password, token);

    if (translateResponce.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(translateResponce.body);
      await initTranslation(TranslationModel.fromJson(responseData));
      // await callMasterData( mContext, userName, password, token);
      if (role == CustomText.crecheSupervisor.trim())
        await getCrecheData(mContext, userName, password, token);
      else
        await getCrecheDataCC(
            mContext, userName, password, token, villagesListString);
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(translateResponce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          context);
    }
  }

  Future<void> callMasterData(BuildContext mContext) async {
    downloadedApi = 1;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      showLoaderDialog(context);
      var token = await Validate().readString(Validate.appToken);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var msterDataResponse = await MasterApiService()
          .fetchmasterData(userName!, password!, token!);
      if (msterDataResponse.statusCode == 200) {
        MasterDataModel masterDataApiModel =
            MasterDataModel.fromJson(json.decode(msterDataResponse.body));
        await initMasterData(masterDataApiModel);
        await downMaster(mContext, userName, password, token);
      } else if (msterDataResponse.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        var errorMsg =
            Global.errorBodyToString(msterDataResponse.body, 'message');
        Validate().singleButtonPopup(
            errorMsg,
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            context);
      }
    } else
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          context);
  }

  Future<void> initTranslation(TranslationModel? translationModel) async {
    if (translationModel != null) {
      List<Translation>? translationList = translationModel.translation;
      if (translationList != null) {
        print("Insert translation data into the database");
        await TranslationDataHelper()
            .insertTranslationLanguage(translationList);
      } else {
        print("Not Insert translation data into the database");
      }
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

  Future<void> getCrecheData(BuildContext mContext, String userName,
      String password, String appToken) async {
    downloadedApi = 5;
    updateLoadingText(dialogSetState);
    var response = await CrecehDataDownloadApi()
        .crechedatadownloadapi(userName, password, appToken);
    if (response.statusCode == 200) {
      Map<String, dynamic> resultMap = jsonDecode(response.body);
      await CrecheDataHelper().downloadCrecheData(resultMap);
      Validate().saveString(
          Validate.msterDownloadDateTime, Validate().currentDateTime());
      await initializeData();
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.master_data_download, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          context);
    } else if (response.statusCode == 401) {
      Navigator.pop(mContext);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lngtr!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(response.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          context);
    }
  }

  Future<void> getCrecheDataCC(BuildContext mContext, String userName,
      String password, String appToken, String villagesListString) async {
    downloadedApi = 5;
    updateLoadingText(dialogSetState);
    var response = await CrecehDataDownloadApi().crechedatadownloadapiCC(
        villagesListString, userName, password, appToken);
    if (response.statusCode == 200) {
      Map<String, dynamic> resultMap = jsonDecode(response.body);
      await CrecheDataHelper().downloadCrecheData(resultMap);
      Validate().saveString(
          Validate.msterDownloadDateTime, Validate().currentDateTime());
      await initializeData();
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.master_data_download, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          context);
    } else if (response.statusCode == 401) {
      Navigator.pop(mContext);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lngtr!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(response.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          context);
    }
  }

  callChildAttendanceDownloadData(BuildContext mContext) async {
    downloadedApi = 2;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      // showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await ChildAttendanceDataDownloadApi()
          .childAttendanceDataDownload(token!, userName!, password!);
      if (response.statusCode == 200) {
        await updateAttendenceResponce(response);
        await callCheckInDownloadApi(mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateAttendenceResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await AttendanceResponnceHelper().childAttendanceData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  Future<void> updateCrecheCheckInResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CheckInResponseHelper().crecheCheckInDwownload(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callCheckInDownloadApi(BuildContext mContext) async {
    downloadedApi = 3;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      // showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await CrecheCheckInApi()
          .callDownloadCreCheCheckINApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateCrecheCheckInResponce(response);
        // Navigator.pop(mContext);
        await callAnthropometryDownloadApi(mContext);
        // Validate().singleButtonPopup(
        //     Global.returnTrLable(locationControlls,
        //         CustomText.data_downloaded_successfully, lngtr!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
        //     false,
        //     mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  callAnthropometryDownloadApi(BuildContext mContext) async {
    downloadedApi = 4;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      // showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await ChildGrowthDownloadApi()
          .callChildGrowthData(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateChildGrowthResponce(response);
        // Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callEventDownloadApi(mContext);
        // Validate().singleButtonPopup(
        //     Global.returnTrLable(locationControlls,
        //         CustomText.data_downloaded_successfully, lngtr!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
        //     false,
        //     mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateChildGrowthResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildGrowthResponseHelper().childGrowthMetaData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callEventDownloadApi(BuildContext mContext) async {
    downloadedApi = 5;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      // showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await ChildEventDataDownloadApi()
          .childEventDataDownload(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateChildEventResponce(response);
        // Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callHealthDownloadApi(mContext);
        // Validate().singleButtonPopup(
        //     Global.returnTrLable(locationControlls,
        //         CustomText.data_downloaded_successfully, lngtr!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
        //     false,
        //     mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateChildEventResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildEventTabResponceHelper().childEventMetaData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callHealthDownloadApi(BuildContext mContext) async {
    downloadedApi = 6;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      // showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await ChildHealthDataDownloadApi()
          .childHealthDataDownload(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateChildHealthResponce(response);
        // Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callImmunizationDownloadApi(mContext);
        // Validate().singleButtonPopup(
        //     Global.returnTrLable(locationControlls,
        //         CustomText.data_downloaded_successfully, lngtr!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
        //     false,
        //     mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateChildHealthResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildHealthTabResponceHelper().childDownloadHealthData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callImmunizationDownloadApi(BuildContext mContext) async {
    downloadedApi = 7;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      // showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await ChildImmunizationDataDownloadApi()
          .childImmunizationDataDownload(
        token!,
        userName!,
        password!,
      );
      if (response.statusCode == 200) {
        await updateChildImmunizationResponce(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callGrievanceDownloadApi(mContext);
        // Validate().singleButtonPopup(
        //     Global.returnTrLable(locationControlls,
        //         CustomText.data_downloaded_successfully, lngtr!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
        //     false,
        //     mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateChildImmunizationResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildImmunizationResponseHelper()
          .childImmunizationDownloadData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callGrievanceDownloadApi(BuildContext mContext) async {
    downloadedApi = 8;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      // loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      // showLoaderDialog(context);
      updateLoadingText(dialogSetState);

      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await ChildGrievanceDataDownloadApi()
          .childGrievanceDataDownload(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateChildGrievanceResponce(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callVillageProfiledata(mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateChildGrievanceResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildGrievancesTabResponceHelper()
          .childDownloadGrievanceData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callVillageProfiledata(BuildContext mContext) async {
    downloadedApi = 9;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await VillageProfileMetaApi()
          .VillageProfileDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateVillageProfiledata(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callCrecheMonitorDownload(mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateVillageProfiledata(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await VillageProfileResponseHelper()
          .villageProfileDataDownload(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  Future<void> updateCMCCCchecklist(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CmcCCTabResponseHelper().crecheALMDownloadData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  Future<void> callCrecheMonitorDownload(BuildContext mContext) async {
    downloadedApi = 10;
    final bool network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      final username = await Validate().readString(Validate.userName);
      final password = await Validate().readString(Validate.Password);
      final appToken = await Validate().readString(Validate.appToken);
      // updateLoadingText(dialogSetState);
      final response = await CrecheMonitoringApi().getCheckListData(
          username: username!, password: password!, appToken: appToken!);

      if (response.statusCode == 200) {
        await updateCrecheMonitorResponse(response);

        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callFollowUpDownloadApi(mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateCrecheMonitorResponse(Response response) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(response.body);
      print("Response : $resultMap");

      await CrecheMonitorResponseHelper().downloadChecklistData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callReferralDownloadApi(BuildContext mContext) async {
    downloadedApi = 12;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await ChildReferralDataDownloadApi()
          .childReferralDataDownload(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateChildReferralResponce(response);

        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callCrecheCommitteeMeetingDownloadApi(mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateChildReferralResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildReferralTabResponseHelper()
          .childDownloadReferralData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callFollowUpDownloadApi(BuildContext mContext) async {
    downloadedApi = 11;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      // updateLoadingText(dialogSetState);
      var response = await ChildFollowUpDataDownloadApi()
          .childFollowUpDataDownload(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateChildFollowUpResponce(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callReferralDownloadApi(mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateChildFollowUpResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildFollowUpTabResponseHelper()
          .childDownloadFollowUpData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callCrecheCommitteeMeetingDownloadApi(BuildContext mContext) async {
    downloadedApi = 13;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await CrecheCommitteeMeetingDownloadApi()
          .callCrecheCommitteeMeetingDownloadData(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateCrecheCommitteeMeetingResponce(response);

        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callCashbookExpensesDownloadData(mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateCrecheCommitteeMeetingResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CrecheCommittieResponnseHelper()
          .crecheCommitteeMeetingDownloadData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callCashbookExpensesDownloadData(BuildContext mContext) async {
    downloadedApi = 14;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      // updateLoadingText(dialogSetState);
      var response = await CashBookExpensesApi()
          .cashbookExpensesDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updatecashbookExpensesdata(response);

        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callCashbookReceiptDownloadData(mContext);
        // Validate().singleButtonPopup(
        //     Global.returnTrLable(locationControlls,
        //         CustomText.data_downloaded_successfully, lngtr!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
        //     false,
        //     mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updatecashbookExpensesdata(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CashBookResponseExpencesHelper().childCashbookMetaData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callCashbookReceiptDownloadData(BuildContext mContext) async {
    downloadedApi = 15;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);

      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      // updateLoadingText(dialogSetState);
      var response = await CashBookReceiptApi()
          .cashbookReceiptDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updatecashbookReceiptdata(response);

        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callChildEnrollExit(mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updatecashbookReceiptdata(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CashBookReceiptResponseHelper().childCashbookMetaData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callCMCCBMchecklist(BuildContext mContext) async {
    var network = await Validate().checkNetworkConnection();
    if (network) {
      downloadedApi = 0;
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await CrecheMonetringCheckListCBMApi()
          .cmcCBMDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateCMCCBMchecklist(response);
        Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await initializeData();

        // Validate().singleButtonPopup(
        //     Global.returnTrLable(locationControlls,
        //         CustomText.data_downloaded_successfully, lngtr!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
        //     false,
        //     mContext);
        callUserManualData(mContext, 1);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateCMCCBMchecklist(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CmcCBMTabResponseHelper().crecheCBMDownloadData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callALMCMCchecklist(BuildContext mContext) async {
    var network = await Validate().checkNetworkConnection();
    if (network) {
      downloadedApi = 0;
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await CrecheMonetringCheckListALMApi()
          .cmcALMDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateALMCMCchecklist(response);
        Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await initializeData();

        // Validate().singleButtonPopup(
        //     Global.returnTrLable(locationControlls,
        //         CustomText.data_downloaded_successfully, lngtr!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
        //     false,
        //     mContext);
        callUserManualData(mContext, 1);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateALMCMCchecklist(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CmcALMTabResponseHelper().crecheALMDownloadData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callUserManualData(BuildContext mContext, int downloadCount) async {
    downloadedApi = downloadCount;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await UserManualApi()
          .userManualDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateUserManualData(response);

        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await initializeData();
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.returnTrLable(locationControlls,
                CustomText.data_downloaded_successfully, lngtr!),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateUserManualData(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await UserManualFieldsHelper().userManualDownloadData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callChildEnrollExit(BuildContext mContext) async {
    downloadedApi = 16;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      // updateLoadingText(dialogSetState);
      var response = await ChildEnrolledExitApi()
          .callChildEnrolledExitDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateChildEnrollExit(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());

        // await callUserManualData(mContext, 17);
        await callStockData(mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateChildEnrollExit(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await EnrolledExitChilrenResponceHelper().childProfileData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callStockData(BuildContext mContext) async {
    downloadedApi = 17;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);

      var response =
          await StockApi().stockDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateStockResponse(response);
        // Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        // await initializeData();

        await callRequisitionData(mContext);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.returnTrLable(locationControlls,
                Global.errorBodyToString(response.body, 'message'), lngtr!),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateStockResponse(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await StockResponseHelper().StockDataDownload(resultMap);
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  callRequisitionData(BuildContext mContext) async {
    downloadedApi = 18;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      updateLoadingText(dialogSetState);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);

      var response = await RequisitionApi()
          .requisitionDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateRequisitionresponse(response);
        // Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        // await initializeData();
        await callUserManualData(mContext, 19);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lngtr!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.returnTrLable(locationControlls,
                Global.errorBodyToString(response.body, 'message'), lngtr!),
            Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lngtr!),
          Global.returnTrLable(locationControlls, CustomText.ok, lngtr!),
          false,
          mContext);
    }
  }

  Future<void> updateRequisitionresponse(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await RequisitionResponseHelper().RequisitionDataDownload(resultMap);
    } catch (e) {
      print("exp ${e.toString()}");
    }
  }

  Future<int> callCountForUpload() async {
    var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
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
    var villageProfiles =
        await VillageProfileResponseHelper().getVillageProfileforUpload();
    var ImageFileData = await ImageFileTabHelper().getImageForUpload();
    var childEnrollExitData =
        await EnrolledExitChilrenResponceHelper().callChildrenForUpload();
    hhItems = hhItems
        .where((element) =>
            Global.stringToInt(Global.getItemValues(
                element.responces!, 'verification_status')) >
            1)
        .toList();

    int totalPendingCount = hhItems.length +
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
        ImageFileData.length +
        villageProfiles.length +
        cashBookDataReciept.length +
        childEnrollExitData.length +
        stockData.length +
        requisitionData.length;

    return totalPendingCount;
  }

  void updateLoadingText(StateSetter setState) {
    if (mounted) {
      setState(() {
        loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      });
    }
  }

  Future<int> callCountForUploadCC() async {
    var creCheMonitoring = await CmcCCTabResponseHelper().getCcForUpload();
    var crecheCheckIn =
        await CheckInResponseHelper().callCrecheCheckInResponses();

    var grievanceData =
        await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();

    var ImageFileData = await ImageFileTabHelper().getImageForUpload();

    int totalPendingCount = crecheCheckIn.length +
        grievanceData.length +
        creCheMonitoring.length +
        ImageFileData.length;

    return totalPendingCount;
  }
}
