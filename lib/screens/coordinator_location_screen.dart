import 'dart:convert';
import 'package:http/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/api/creche_Monitering_checkList_alm_api.dart';
import 'package:shishughar/api/creche_monetering_checkList_cbm_api.dart';
import 'package:shishughar/api/requisition_api.dart';
import 'package:shishughar/api/stock_api.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/block_data_helper.dart';
import 'package:shishughar/database/helper/cmc_alm/creche_monitering_checkList_ALM_response_helper.dart';
import 'package:shishughar/database/helper/cmc_cbm/creche_monitering_checklist_CBM_response_helper.dart';
import 'package:shishughar/database/helper/district_data_helper.dart';
import 'package:shishughar/database/helper/gram_panchayat_data_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
import 'package:shishughar/database/helper/state_data_helper.dart';
import 'package:shishughar/database/helper/stock/stock_response_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/database/helper/village_data_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/tabBlock_model.dart';
import 'package:shishughar/model/databasemodel/tabDistrict_model.dart';
import 'package:shishughar/model/databasemodel/tabGramPanchayat_model.dart';
import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tabstate_model.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../api/cashBook_expenses_api.dart';
import '../api/cashbook_receipt_api.dart';
import '../api/child_attendance_download_api.dart';
import '../api/child_enrolled_exit_api.dart';
import '../api/child_event_download_api.dart';
import '../api/child_followup_download-api.dart';
import '../api/child_grievance_download_api.dart';
import '../api/child_growth_dowload_api.dart';
import '../api/child_health_download_api.dart';
import '../api/child_immunization_download_api.dart';
import '../api/child_profile_data_download.api.dart';
import '../api/child_referral_download_api.dart';
import '../api/creche_checkIn_api.dart';
import '../api/creche_committie_download_api.dart';
import '../api/creche_monitering_checklist_cc_api.dart';
import '../api/download_data_api.dart';
import '../api/user_manual_pdf_api.dart';
import '../api/village_profile_meta_api.dart';
import '../custom_widget/custom_string_dropdown.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../database/helper/anthromentory/child_growth_response_helper.dart';
import '../database/helper/cashbook/expences/cashbook_response_expences_helper.dart';
import '../database/helper/cashbook/receipt/cashbook_receipt_response_helper.dart';
import '../database/helper/check_in/check_in_response_helper.dart';
import '../database/helper/child_attendence/attendance_responce_helper.dart';
import '../database/helper/child_event/child_event_response_helper.dart';
import '../database/helper/child_gravience/child_grievances_response_helper.dart';
import '../database/helper/child_health/child_health_response_helper.dart';
import '../database/helper/child_immunization/child_immunization_response_helper.dart';
import '../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../database/helper/cmc_CC/creche_monitering_checklist_CC_response_helper.dart';
import '../database/helper/creche_comite_meeting/creche_committie_response_helper.dart';
import '../database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
import '../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import '../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import '../database/helper/follow_up/child_followUp_response_helper.dart';
import '../database/helper/user_manual_fields_meta_helper.dart';
import '../database/helper/village_profile/village_profile_response_helper.dart';
import '../model/dynamic_screen_model/options_model.dart';
import '../utils/globle_method.dart';
import 'login_screen.dart';

class CoordinatorLocationScreen extends StatefulWidget {
  final String role;
  const CoordinatorLocationScreen({super.key, required this.role});

  @override
  State<CoordinatorLocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<CoordinatorLocationScreen> {
  OptionsModel? selectedState;
  OptionsModel? selectedDistrict;
  OptionsModel? selectedBlock;
  OptionsModel? selectedGramPanchayat;
  List<String> selectedVillage = [];

  List<OptionsModel> mstStates = [];
  List<OptionsModel> mstDistrict = [];
  List<OptionsModel> mstBlock = [];
  List<OptionsModel> mstGP = [];
  List<String> villageList = [];

  List<TabState> states = [];
  List<TabDistrict> district = [];
  List<TabBlock> block = [];
  List<TabGramPanchayat> gramPanchayat = [];
  List<TabVillage> village = [];

  String? lng;
  List<Translation> locationControlls = [];
  int downloadedApi = 0;
  int totalApiCount = 0;
  int loadingText = 0;

  @override
  void initState() {
    super.initState();

    fetchStateList();
  }

  Future<void> fetchStateList() async {
    await initializeData();
    lng = await Validate().readString(Validate.sLanguage);
    states = await StateDataHelper().getTabStateList();
    district = await DistrictDataHelper().getTabDistrictList();
    block = await BlockDataHelper().getTabBlockList();
    gramPanchayat = await GramPanchayatDataHelper().getTabGramPanchayatList();
    village = await VillageDataHelper().getTabVillageList();
    mstStates = Global.callSatates(states, lng!);

    String? sts = await Validate().readString(Validate.state);
    String? slds = await Validate().readString(Validate.district);
    String? blk = await Validate().readString(Validate.block);
    String? gmp = await Validate().readString(Validate.gramPanchayat);

    if (sts != null) {
      var state =
          states.where((element) => element.name.toString() == sts).firstOrNull;
      if (state != null) {
        var value = "${state.value}";
        if (lng == 'hi' && Global.validString(state.state_hi.toString())) {
          value = state.state_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(state.state_od.toString())) {
          value = state.state_od.toString();
        }
        selectedState = OptionsModel(
            name: state.name.toString(), values: value, flag: 'tabState');
      } else
        throw Exception("State is not available");
      mstDistrict = Global.callDistrict(district, lng!, selectedState);
    }

    if (slds != null) {
      var disct = district
          .where((element) => element.name.toString() == slds)
          .firstOrNull;
      if (disct != null) {
        var value = "${disct.value}";
        if (lng == 'hi' && Global.validString(disct.district_hi.toString())) {
          value = disct.district_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(disct.district_od.toString())) {
          value = disct.district_od.toString();
        }
        selectedDistrict = OptionsModel(
            name: disct.name.toString(), values: value, flag: 'tabDistrict');
      } else
        throw Exception("District not available");
      mstBlock = Global.callBlocks(block, lng!, selectedDistrict);
    }

    if (blk != null) {
      var blks =
          block.where((element) => element.name.toString() == blk).firstOrNull;
      if (blks != null) {
        var value = "${blks.value}";
        if (lng == 'hi' && Global.validString(blks.block_hi.toString())) {
          value = blks.block_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(blks.block_od.toString())) {
          value = blks.block_od.toString();
        }
        selectedBlock = OptionsModel(
            name: blks.name.toString(), values: value, flag: 'tabBlock');
      } else
        throw Exception("Block not availaable");
      mstGP = Global.callGramPanchyats(gramPanchayat, lng!, selectedBlock);
    }

    if (gmp != null) {
      var gp = gramPanchayat
          .where((element) => element.name.toString() == gmp)
          .firstOrNull;
      if (gp != null) {
        var value = "${gp.value}";
        if (lng == 'hi' && Global.validString(gp.gp_hi.toString())) {
          value = gp.gp_hi.toString();
        } else if (lng == 'od' && Global.validString(gp.gp_od.toString())) {
          value = gp.gp_od.toString();
        }
        selectedGramPanchayat =
            OptionsModel(name: gp.name.toString(), values: value, flag: 'taGp');
      } else
        throw Exception("Gram Panchayat not available");
      villageList = callFiltersVillages(village, lng!, selectedGramPanchayat);
      selectedVillage.clear();
      var selcVSaved = await Validate().readString(Validate.villageIdES);
      village.forEach((element) {
        if (selcVSaved != null) {
          if (selcVSaved.contains(element.name.toString())) {
            var value = "${element.value}";
            if (lng == 'hi' &&
                Global.validString(element.village_hi.toString())) {
              value = element.village_hi.toString();
            } else if (lng == 'od' &&
                Global.validString(element.village_od.toString())) {
              value = element.village_od.toString();
            }
            selectedVillage.add(value);
          }
        }
      });
    }

    if (mstStates.length == 1 && villageList.length == 0) {
      selectedState = mstStates.first;
      mstDistrict = Global.callDistrict(district, lng!, selectedState);
      if (mstDistrict.length == 1) {
        selectedDistrict = mstDistrict.first;
        mstBlock = Global.callBlocks(block, lng!, selectedDistrict);
        if (mstBlock.length == 1) {
          selectedBlock = mstBlock.first;
          mstGP = Global.callGramPanchyats(gramPanchayat, lng!, selectedBlock);
          if (mstGP.length == 1) {
            selectedGramPanchayat = mstGP.first;
            villageList =
                callFiltersVillages(village, lng!, selectedGramPanchayat);
          }
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'itemRefresh');
        return true;
      },
      child: Scaffold(
        appBar: CustomAppbar(
          text: (lng != null)
              ? Global.returnTrLable(
                  locationControlls, CustomText.geoWiDownDwnload, lng!)
              : '',
          onTap: () {
            Navigator.pop(context, 'itemRefresh');
          },
        ),
        body: (mstStates.length > 0)
            ? SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          Text(
                            (lng != null)
                                ? Global.returnTrLable(locationControlls,
                                    CustomText.geoWiDownDwnload, lng!)
                                : '',
                            style: Styles.red145,
                          ),
                          SizedBox(height: 10.h),
                          DynamicCustomDropdownField(
                            titleText: Global.returnTrLable(
                                locationControlls, CustomText.state, lng!),
                            items: mstStates,
                            isRequred: 1,
                            selectedItem: selectedState != null
                                ? selectedState?.name
                                : null,
                            onChanged: (value) async {
                              selectedState = value;
                              selectedDistrict = null;
                              selectedBlock = null;
                              selectedGramPanchayat = null;
                              selectedVillage = [];
                              mstDistrict = Global.callDistrict(
                                  district, lng!, selectedState);
                              if (mstDistrict.length == 1) {
                                selectedDistrict = mstDistrict.first;
                                mstBlock = Global.callBlocks(
                                    block, lng!, selectedDistrict);
                                if (mstBlock.length == 1) {
                                  selectedBlock = mstBlock.first;
                                  mstGP = Global.callGramPanchyats(
                                      gramPanchayat, lng!, selectedBlock);
                                  if (mstGP.length == 1) {
                                    selectedGramPanchayat = mstGP.first;
                                    villageList = callFiltersVillages(
                                        village, lng!, selectedGramPanchayat);
                                  }
                                }
                              }
                              setState(() {
                                // Update districtList based on selectedState
                                // districtList = // data from database based on selectedState;
                              });
                            },
                          ),
                          DynamicCustomDropdownField(
                            titleText: Global.returnTrLable(
                                locationControlls, CustomText.District, lng!),
                            items: mstDistrict,
                            isRequred: 1,
                            selectedItem: selectedDistrict != null
                                ? selectedDistrict?.name
                                : null,
                            onChanged: (value) async {
                              selectedDistrict = value;
                              selectedBlock = null;
                              selectedGramPanchayat = null;
                              selectedVillage = [];
                              mstBlock = Global.callBlocks(
                                  block, lng!, selectedDistrict);
                              if (mstBlock.length == 1) {
                                selectedBlock = mstBlock.first;
                                mstGP = Global.callGramPanchyats(
                                    gramPanchayat, lng!, selectedBlock);
                                if (mstGP.length == 1) {
                                  selectedGramPanchayat = mstGP.first;
                                  villageList = callFiltersVillages(
                                      village, lng!, selectedGramPanchayat);
                                }
                              }
                              setState(() {
                                // Update blockList based on selectedDistrict
                                // blockList = // data from database based on selectedDistrict;
                              });
                            },
                          ),
                          DynamicCustomDropdownField(
                            titleText: Global.returnTrLable(
                                locationControlls, CustomText.Block, lng!),
                            items: mstBlock,
                            isRequred: 1,
                            selectedItem: selectedBlock != null
                                ? selectedBlock?.name
                                : null,
                            onChanged: (value) async {
                              selectedBlock = value;
                              selectedGramPanchayat = null;
                              selectedVillage = [];
                              mstGP = Global.callGramPanchyats(
                                  gramPanchayat, lng!, selectedBlock);
                              if (mstGP.length == 1) {
                                selectedGramPanchayat = mstGP.first;
                                villageList = callFiltersVillages(
                                    village, lng!, selectedGramPanchayat);
                              }
                              setState(() {
                                // Update gramPanchayatList based on selectedBlock
                                // gramPanchayatList = // data from database based on selectedBlock;
                              });
                            },
                          ),
                          DynamicCustomDropdownField(
                            isRequred: 1,
                            titleText: Global.returnTrLable(locationControlls,
                                CustomText.GramPanchayat, lng!),
                            items: mstGP,
                            hintText: Global.returnTrLable(
                                locationControlls, CustomText.Selecthere, lng!),
                            selectedItem: selectedGramPanchayat != null
                                ? selectedGramPanchayat?.name
                                : null,
                            onChanged: (value) async {
                              selectedGramPanchayat = value;
                              selectedVillage = [];
                              villageList = callFiltersVillages(
                                  village, lng!, selectedGramPanchayat);
                              setState(() {
                                // Update villageList based on selectedGramPanchayat
                                // villageList = // data from database based on selectedGramPanchayat;
                              });
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: Global.returnTrLable(locationControlls,
                                      CustomText.Village, lng!),
                                  style: Styles.black124,
                                  children: [
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffACACAC)),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: MultiSelectDialogField(
                                  initialValue: selectedVillage,
                                  dialogHeight: 150.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                  ),
                                  title: Text(Global.returnTrLable(
                                      locationControlls,
                                      CustomText.Village,
                                      lng!)),
                                  buttonIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey.shade700,
                                  ),
                                  buttonText: Text(CustomText.SelectVillage),
                                  items: villageList
                                      .map((e) =>
                                          MultiSelectItem(e, e.toString()))
                                      .toList(),
                                  listType: MultiSelectListType.LIST,
                                  onConfirm: (value) {
                                    setState(() {
                                      print(value);
                                      selectedVillage = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 30.h),
                              CElevatedButton(
                                onPressed: () async {
                                  if (selectedState == null) {
                                    Validate().singleButtonPopup(
                                        Global.returnTrLable(locationControlls,
                                            CustomText.plSelect_state, lng!),
                                        Global.returnTrLable(locationControlls,
                                            CustomText.ok, lng!),
                                        false,
                                        context);
                                  } else if (selectedDistrict == null) {
                                    Validate().singleButtonPopup(
                                        Global.returnTrLable(locationControlls,
                                            CustomText.plSelect_district, lng!),
                                        Global.returnTrLable(locationControlls,
                                            CustomText.ok, lng!),
                                        false,
                                        context);
                                  } else if (selectedBlock == null) {
                                    Validate().singleButtonPopup(
                                        Global.returnTrLable(locationControlls,
                                            CustomText.plSelect_block, lng!),
                                        Global.returnTrLable(locationControlls,
                                            CustomText.ok, lng!),
                                        false,
                                        context);
                                  } else if (selectedGramPanchayat == null) {
                                    Validate().singleButtonPopup(
                                        Global.returnTrLable(
                                            locationControlls,
                                            CustomText.plSelect_geamPanchayat,
                                            lng!),
                                        Global.returnTrLable(locationControlls,
                                            CustomText.ok, lng!),
                                        false,
                                        context);
                                  } else if (selectedVillage.length == 0) {
                                    Validate().singleButtonPopup(
                                        Global.returnTrLable(locationControlls,
                                            CustomText.plSelect_village, lng!),
                                        Global.returnTrLable(locationControlls,
                                            CustomText.ok, lng!),
                                        false,
                                        context);
                                  } else {
                                    Validate().saveString(
                                        Validate.state, selectedState!.name!);
                                    Validate().saveString(Validate.district,
                                        selectedDistrict!.name!);
                                    Validate().saveString(
                                        Validate.block, selectedBlock!.name!);
                                    Validate().saveString(
                                        Validate.gramPanchayat,
                                        selectedGramPanchayat!.name!);
                                    String villagesss = '';
                                    village.forEach((element) {
                                      if (selectedVillage
                                          .contains(element.value)) {
                                        if (Global.validString(villagesss)) {
                                          villagesss =
                                              '$villagesss,${element.name}';
                                        } else
                                          villagesss = '${element.name}';
                                      }
                                    });
                                    Validate().saveString(
                                        Validate.villageIdES, villagesss);
                                    totalApiCount = 19;
                                    callVillageFilterDataCC(
                                        context, villagesss);
                                  }
                                },
                                text: Global.returnTrLable(locationControlls,
                                    CustomText.downloadData, lng!),
                              )
                            ],
                          ),
                        ])),
              )
            : SizedBox(),
      ),
    );
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
            return AlertDialog(
                content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 10.h),
                Text(
                    '${Global.returnTrLable(locationControlls, CustomText.pleaseWait, lng!)} ${(loadingText)}/100%'),
              ],
            ));
          }),
        );
      },
    );
  }

  Future<void> initializeData() async {
    List<String> valueNames = [
      CustomText.geoWiDownDwnload,
      CustomText.downloadData,
      CustomText.state,
      CustomText.District,
      CustomText.Block,
      CustomText.GramPanchayat,
      CustomText.Village,
      CustomText.plSelect_state,
      CustomText.plSelect_district,
      CustomText.plSelect_block,
      CustomText.plSelect_geamPanchayat,
      CustomText.plSelect_village,
      CustomText.nointernetconnectionavailable,
      CustomText.data_downloaded_successfully,
      CustomText.somethingWentError,
      CustomText.ok
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => locationControlls = value);
  }

  callVillageFilterDataCC(BuildContext mContext, String villagesss) async {
    downloadedApi = 0;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(mContext);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await DownloadDataApi()
          .callVillagesDataDownloadCC(villagesss, userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateVillageResponces(response);
        Navigator.pop(mContext);
        callVillageEnrolledChildProfileDataCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.returnTrLable(locationControlls,
                Global.errorBodyToString(response.body, 'message'), lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callVillageEnrolledChildProfileDataCC(BuildContext mContext,
      String villagesss, String userName, String password, String token) async {
    downloadedApi = 1;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(mContext);

      var response = await ChilProfileDataDownloadApi()
          .childProfileDataDownloadCC(villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updateVillageEnrolledChildResponces(response);
        Navigator.pop(mContext);
        await callChildAttendanceDownloadDataCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callChildAttendanceDownloadDataCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 2;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(mContext);

      var response = await ChildAttendanceDataDownloadApi()
          .childAttendanceDataDownloadCC(token, userName, password, villagesss);
      if (response.statusCode == 200) {
        await updateAttendenceResponce(response);
        Navigator.pop(mContext);
        await callCheckInDownloadApiCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callCheckInDownloadApiCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 3;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(mContext);
      var response = await CrecheCheckInApi().callDownloadCreCheCheckINApiCC(
          villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updateCrecheCheckInResponce(response);
        Navigator.pop(mContext);
        await callAnthropometryDownloadApiCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callAnthropometryDownloadApiCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 4;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(mContext);

      var response = await ChildGrowthDownloadApi()
          .callChildGrowthDataCC(villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updateChildGrowthResponce(response);
        Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callEventDownloadApiCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callEventDownloadApiCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 5;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(mContext);

      var response = await ChildEventDataDownloadApi()
          .childEventDataDownloadCC(villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updateChildEventResponce(response);
        Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());

        await callHealthDownloadApiCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callHealthDownloadApiCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 6;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(mContext);

      var response = await ChildHealthDataDownloadApi()
          .childHealthDataDownloadCC(villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updateChildHealthResponce(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);
        await callImmunizationDownloadApiCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callImmunizationDownloadApiCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 7;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(mContext);

      var response = await ChildImmunizationDataDownloadApi()
          .childImmunizationDataDownloadCC(
        villagesss,
        token,
        userName,
        password,
      );
      if (response.statusCode == 200) {
        await updateChildImmunizationResponce(response);

        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);
        await callGrievanceDownloadApi(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callVillageProfiledataCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 9;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);

      var response = await VillageProfileMetaApi()
          .VillageProfileDownloadApiCC(villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updateVillageProfiledata(response);

        Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        if (widget.role == CustomText.clusterCoordinator)
          await callCMCCCchecklist(
              mContext, villagesss, userName, password, token);
        else if (widget.role == CustomText.alm)
          await callALMCMCchecklist(
              mContext, villagesss, userName, password, token);
        else if (widget.role == CustomText.cbm)
          await callCMCCBMchecklist(
              mContext, villagesss, userName, password, token);
        else
          await callFollowUpDownloadApiCC(
              mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callCMCCCchecklist(BuildContext mContext, String villagesss, String userName,
      String password, String token) async {
    downloadedApi = 10;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(mContext);
      var response = await CrecheMonetringCheckListCCApi()
          .cmcCCDownloadApi(userName, password, token);
      if (response.statusCode == 200) {
        await updateCMCCCchecklist(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);
        await callFollowUpDownloadApiCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callReferralDownloadApiCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 12;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);

      var response = await ChildReferralDataDownloadApi()
          .childReferralDataDownloadCC(villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updateChildReferralResponce(response);

        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);
        await callCrecheCommitteeMeetingDownloadApiCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callFollowUpDownloadApiCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 11;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);

      var response = await ChildFollowUpDataDownloadApi()
          .childFollowUpDataDownloadCC(villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updateChildFollowUpResponce(response);

        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);
        await callReferralDownloadApiCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callCrecheCommitteeMeetingDownloadApiCC(BuildContext mContext,
      String villagesss, String userName, String password, String token) async {
    downloadedApi = 13;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);

      var response = await CrecheCommitteeMeetingDownloadApi()
          .callCrecheCommitteeMeetingDownloadDataCC(
              villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updateCrecheCommitteeMeetingResponce(response);

        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);
        await callCashbookExpensesDownloadDataCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callCashbookExpensesDownloadDataCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 14;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);

      var response = await CashBookExpensesApi()
          .cashbookExpensesDownloadApiCC(villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updatecashbookExpensesdata(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);
        await callCashbookReceiptDownloadDataCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callCashbookReceiptDownloadDataCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 15;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);

      var response = await CashBookReceiptApi()
          .cashbookReceiptDownloadApiCC(villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updatecashbookReceiptdata(response);
        Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await callChildEnrollExitCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callGrievanceDownloadApi(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 8;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);

      var response = await ChildGrievanceDataDownloadApi()
          .childGrievanceDataDownload(userName, password, token);
      if (response.statusCode == 200) {
        await updateChildGrievanceResponce(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);
        await callVillageProfiledataCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callChildEnrollExitCC(BuildContext mContext, String villagesss,
      String userName, String password, String token) async {
    downloadedApi = 16;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);

      var response = await ChildEnrolledExitApi()
          .callChildEnrolledExitDownloadApiCC(
              villagesss, userName, password, token);
      if (response.statusCode == 200) {
        await updateChildEnrollExit(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);
        // await callUserManualData(mContext, 17, userName, password, token);
        await callStockData(mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          mContext);
    }
  }

  callUserManualData(BuildContext mContext, int downloadCount, String userName,
      String password, String token) async {
    downloadedApi = downloadCount;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);
      var response = await UserManualApi()
          .userManualDownloadApi(userName, password, token);
      if (response.statusCode == 200) {
        await updateUserManualData(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.returnTrLable(locationControlls,
                CustomText.data_downloaded_successfully, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
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
      print(" responce $resultMap");
      await EnrolledChilrenResponceHelper().childProfileData(resultMap);
    } catch (e) {
      print("exp ${e.toString()}");
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

  Future<void> updateChildGrowthResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildGrowthResponseHelper().childGrowthMetaData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
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

  Future<void> updateChildHealthResponce(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await ChildHealthTabResponceHelper().childDownloadHealthData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
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

  Future<void> updateCrecheMonitorResponse(Response response) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(response.body);
      print("Response : $resultMap");

      await CrecheMonitorResponseHelper().downloadChecklistData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
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

  Future<void> updatecashbookExpensesdata(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CashBookResponseExpencesHelper().childCashbookMetaData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
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

  Future<void> updateChildEnrollExit(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await EnrolledExitChilrenResponceHelper().childProfileData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }

  callALMCMCchecklist(BuildContext mContext, String villagesss, String userName,
      String password, String token) async {
    var network = await Validate().checkNetworkConnection();
    if (network) {
      downloadedApi = 10;
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);

      var response = await CrecheMonetringCheckListALMApi()
          .cmcALMDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateALMCMCchecklist(response);
        Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await initializeData();

        await callFollowUpDownloadApiCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
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

  callCMCCBMchecklist(BuildContext mContext, String villagesss, String userName,
      String password, String token) async {
    var network = await Validate().checkNetworkConnection();
    if (network) {
      downloadedApi = 10;
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);

      var response = await CrecheMonetringCheckListCBMApi()
          .cmcCBMDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateCMCCBMchecklist(response);
        Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await initializeData();

        await callFollowUpDownloadApiCC(
            mContext, villagesss, userName, password, token);
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
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
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

  callStockData(BuildContext mContext, String villages, String username,
      String password, String token) async {
    downloadedApi = 17;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);
      // updateLoadingText(dialogSetState);
      // var userName = await Validate().readString(Validate.userName);
      // var password = await Validate().readString(Validate.Password);
      // var token = await Validate().readString(Validate.appToken);

      var response = await StockApi()
          .stockDownloadApiforCC(villages, username!, password!, token!);
      if (response.statusCode == 200) {
        await updateStockResponse(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        // await initializeData();
        Navigator.pop(mContext);

        await callRequisitionData(
            mContext, villages, username, password, token);
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
        Validate().singleButtonPopup(
            Global.returnTrLable(locationControlls,
                Global.errorBodyToString(response.body, 'message'), lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
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

  callRequisitionData(BuildContext mContext, String villages, String username,
      String password, String token) async {
    downloadedApi = 18;
    var network = await Validate().checkNetworkConnection();
    if (network) {
      loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      showLoaderDialog(context);
      // updateLoadingText(dialogSetState);
      // var userName = await Validate().readString(Validate.userName);
      // var password = await Validate().readString(Validate.Password);
      // var token = await Validate().readString(Validate.appToken);

      var response = await RequisitionApi()
          .requisitionDownloadApiforCC(villages, username!, password!, token!);
      if (response.statusCode == 200) {
        await updateRequisitionresponse(response);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);

        // await initializeData();
        await callUserManualData(mContext, 19, username, password, token);
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
        Validate().singleButtonPopup(
            Global.returnTrLable(locationControlls,
                Global.errorBodyToString(response.body, 'message'), lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            mContext);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
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

  List<String> callFiltersVillages(
      List<TabVillage> villages, String lng, OptionsModel? parentItem) {
    List<String> teVillage = [];
    if (parentItem != null && villages.length > 0) {
      villages =
          villages.where((element) => element.gpId == parentItem.name).toList();
      villages.forEach((element) {
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.village_hi.toString())) {
          value = element.village_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.village_od.toString())) {
          value = element.village_od.toString();
        }
        teVillage.add(value);
      });
    }
    return teVillage;
  }
}

// var dislist =  DatabaseHelper.database!.rawQuery('SELECT * FROM TABLE tabGender Whare state_id=$stateId;');
