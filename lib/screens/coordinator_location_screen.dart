import 'dart:convert';
import 'package:http/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/block_data_helper.dart';
import 'package:shishughar/database/helper/district_data_helper.dart';
import 'package:shishughar/database/helper/gram_panchayat_data_helper.dart';
import 'package:shishughar/database/helper/state_data_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/database/helper/village_data_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/tabBlock_model.dart';
import 'package:shishughar/model/databasemodel/tabDistrict_model.dart';
import 'package:shishughar/model/databasemodel/tabGramPanchayat_model.dart';
import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tabstate_model.dart';
import 'package:shishughar/screens/dashboardscreen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../api/creche_monitering_checklist_cc_api.dart';
import '../api/download_data_api.dart';
import '../api/user_manual_pdf_api.dart';
import '../custom_widget/custom_string_dropdown.dart';
import '../database/helper/cmc_CC/creche_monitering_checklist_CC_response_helper.dart';
import '../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import '../database/helper/user_manual_fields_meta_helper.dart';
import '../utils/globle_method.dart';
import 'login_screen.dart';

class CoordinatorLocationScreen extends StatefulWidget {
  const CoordinatorLocationScreen({super.key});

  @override
  State<CoordinatorLocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<CoordinatorLocationScreen> {
  String? selectedState;
  String? selectedDistrict;
  String? selectedBlock;
  String? selectedGramPanchayat;
  List<String> selectedVillage = [];

  List<String> stateList = [];
  List<String> districtList = [];
  List<String> blockList = [];
  List<String> gramPanchayatList = [];
  List<String> villageList = [];

  List<TabState> states = [];
  List<TabDistrict> district = [];
  List<TabBlock> block = [];
  List<TabGramPanchayat> gramPanchayat = [];
  List<TabVillage> village = [];

  String? lng;
  List<Translation> locationControlls = [];

  @override
  void initState() {
    super.initState();

    fetchStateList();
  }

  Future<void> fetchStateList() async {
    await getInitLocation();
    StateDataHelper databaseHelper = StateDataHelper();
    states = await databaseHelper.getTabStateList();
    states.forEach((element) {
      stateList.add(element.value!);
    });
    await initializeData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'itemRefresh');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => DashboardScreen(
        //         index: 0,
        //       )),
        // );
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
            // if (selectedState != null &&
            //     selectedDistrict != null &&
            //     selectedBlock != null &&
            //     selectedGramPanchayat != null &&
            //     selectedVillage != null) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => DashboardScreen(
            //               index: 0,
            //             )),
            //   );
            // } else {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => LoginScreen()),
            //   );
            // }
          },
        ),
        body: (stateList.length > 0)
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
                    CustomDropdownFieldString(
                      titleText: Global.returnTrLable(
                          locationControlls, CustomText.state, lng!),
                      items: stateList,
                      isRequred: 1,
                      selectedItem: selectedState,
                      onChanged: (value) async {
                        selectedState = value;
                        selectedDistrict = null;
                        selectedBlock = null;
                        selectedGramPanchayat = null;
                        selectedVillage.clear();
                        var stateId = states
                            .firstWhere((element) =>
                        element.value == selectedState)
                            .name;
                        DistrictDataHelper districtdata =
                        DistrictDataHelper();
                        List<TabDistrict> tempdistrict =
                        await districtdata.getTabDistrictList();
                        district = tempdistrict
                            .where((element) =>
                        element.stateId == stateId.toString())
                            .toList();
                        districtList.clear();
                        district.forEach((element) {
                          districtList.add(element.value!);
                        });
                        setState(() {
                          // Update districtList based on selectedState
                          // districtList = // data from database based on selectedState;
                        });
                      },
                    ),
                    CustomDropdownFieldString(
                      titleText: Global.returnTrLable(
                          locationControlls, CustomText.District, lng!),
                      items: districtList,
                      isRequred: 1,
                      selectedItem: selectedDistrict,
                      onChanged: (value) async {
                        selectedDistrict = value;
                        selectedBlock = null;
                        selectedGramPanchayat = null;
                        selectedVillage.clear();
                        var districtId = district
                            .firstWhere((element) =>
                        element.value == selectedDistrict)
                            .name;
                        BlockDataHelper blockdata = BlockDataHelper();
                        block = await blockdata.getTabBlockList();
                        block = block
                            .where((element) =>
                        element.districtId ==
                            districtId.toString())
                            .toList();
                        blockList.clear();
                        block.forEach((element) {
                          blockList.add(element.value!);
                        });
                        setState(() {
                          // Update blockList based on selectedDistrict
                          // blockList = // data from database based on selectedDistrict;
                        });
                      },
                    ),
                    CustomDropdownFieldString(
                      titleText: Global.returnTrLable(
                          locationControlls, CustomText.Block, lng!),
                      items: blockList,
                      isRequred: 1,
                      selectedItem: selectedBlock,
                      onChanged: (value) async {
                        selectedBlock = value;
                        selectedGramPanchayat = null;
                        selectedVillage.clear();
                        var blockId = block
                            .firstWhere((element) =>
                        element.value == selectedBlock)
                            .name;
                        GramPanchayatDataHelper gramPanchayatdata =
                        GramPanchayatDataHelper();
                        gramPanchayat = await gramPanchayatdata
                            .getTabGramPanchayatList();
                        gramPanchayat = gramPanchayat
                            .where((element) =>
                        element.blockId == blockId.toString())
                            .toList();
                        gramPanchayatList.clear();
                        gramPanchayat.forEach((element) {
                          gramPanchayatList.add(element.value!);
                        });
                        setState(() {
                          // Update gramPanchayatList based on selectedBlock
                          // gramPanchayatList = // data from database based on selectedBlock;
                        });
                      },
                    ),
                    CustomDropdownFieldString(
                      isRequred: 1,
                      titleText: Global.returnTrLable(locationControlls,
                          CustomText.GramPanchayat, lng!),
                      items: gramPanchayatList,
                      selectedItem: selectedGramPanchayat,
                      onChanged: (value) async {
                        selectedGramPanchayat = value;
                        selectedVillage.clear();
                        var gramPanchyatId = gramPanchayat
                            .firstWhere((element) =>
                        element.value == selectedGramPanchayat)
                            .name;
                        VillageDataHelper villagetdata =
                        VillageDataHelper();
                        village = await villagetdata.getTabVillageList();
                        village = village
                            .where((element) =>
                        element.gpId == gramPanchyatId.toString())
                            .toList();
                        villageList.clear();
                        village.forEach((element) {
                          villageList.add(element.value!);
                        });
                        setState(() {
                          // Update villageList based on selectedGramPanchayat
                          // villageList = // data from database based on selectedGramPanchayat;
                        });
                      },
                    ),
                    // CustomDropdownFieldString(
                    //   titleText: CustomText.Village,
                    //   items: villageList,
                    //   selectedItem: selectedVillage,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       selectedVillage = value;
                    //     });
                    //   },
                    // ),

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
                                selectedVillage = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 30.h),
                        CElevatedButton(
                          onPressed: () async {
                            if (selectedState == null) {
                              Validate().singleButtonPopup(Global.returnTrLable(
                                  locationControlls,
                                  CustomText.plSelect_state, lng!),
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lng!),
                                  false, context);
                            } else if (selectedDistrict == null) {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(locationControlls,
                                      CustomText.plSelect_district, lng!),
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lng!),
                                  false, context);
                            } else if (selectedBlock == null) {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(locationControlls,
                                      CustomText.plSelect_block, lng!),
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lng!),
                                  false, context);
                            } else if (selectedGramPanchayat == null) {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(locationControlls,
                                      CustomText.plSelect_geamPanchayat, lng!),
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lng!),
                                  false, context);
                            } else if (selectedVillage.length == 0) {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(locationControlls,
                                      CustomText.plSelect_village, lng!),
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lng!),
                                  false, context);
                            } else {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.setString(
                                  Validate.state, selectedState!);
                              prefs.setString(
                                  Validate.district, selectedDistrict!);
                              prefs.setString(
                                  Validate.block, selectedBlock!);
                              prefs.setString(Validate.gramPanchayat,
                                  selectedGramPanchayat!);
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
                              prefs.setString(
                                  Validate.villageIdES, villagesss);
                              callVillageFilterData(villagesss);
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

  getInitLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    selectedState = prefs.getString(Validate.state);
    selectedDistrict = prefs.getString(Validate.district);
    selectedBlock = prefs.getString(Validate.block);
    selectedGramPanchayat = prefs.getString(Validate.gramPanchayat);
    // selectedVillage = prefs.getStringList(Validate.village)!;
    List<String> getStringList(String key) {
      List<String>? value = prefs.getStringList(Validate.village);
      return value!;
    }

    if (selectedState != null) {
      // Update districtList based on selectedState
      StateDataHelper databaseHelper = StateDataHelper();
      List<TabState> tempstate = await databaseHelper.getTabStateList();
      var stateId = tempstate
          .firstWhere((element) => element.value == selectedState)
          .name;

      DistrictDataHelper districtdata = DistrictDataHelper();
      List<TabDistrict> tempdistrict = await districtdata.getTabDistrictList();
      district = tempdistrict
          .where((element) => element.stateId == stateId.toString())
          .toList();
      districtList.clear();
      district.forEach((element) {
        districtList.add(element.value!);
      });
    }

    if (selectedDistrict != null) {
      // Update blockList based on selectedDistrict
      var districtId = district
          .firstWhere((element) => element.value == selectedDistrict)
          .name;
      BlockDataHelper blockdata = BlockDataHelper();
      block = await blockdata.getTabBlockList();
      block = block
          .where((element) => element.districtId == districtId.toString())
          .toList();
      blockList.clear();
      block.forEach((element) {
        blockList.add(element.value!);
      });
    }

    if (selectedBlock != null) {
      // Update gramPanchayatList based on selectedBlock
      var blockId =
          block
              .firstWhere((element) => element.value == selectedBlock)
              .name;
      GramPanchayatDataHelper gramPanchayatdata = GramPanchayatDataHelper();
      gramPanchayat = await gramPanchayatdata.getTabGramPanchayatList();
      gramPanchayat = gramPanchayat
          .where((element) => element.blockId == blockId.toString())
          .toList();
      gramPanchayatList.clear();
      gramPanchayat.forEach((element) {
        gramPanchayatList.add(element.value!);
      });
    }

    if (selectedGramPanchayat != null) {
      // Update villageList based on selectedGramPanchayat
      var gramPanchyatId = gramPanchayat
          .firstWhere((element) => element.value == selectedGramPanchayat)
          .name;
      VillageDataHelper villagetdata = VillageDataHelper();
      village = await villagetdata.getTabVillageList();
      village = village
          .where((element) => element.gpId == gramPanchyatId.toString())
          .toList();
      villageList.clear();
      selectedVillage.clear();
      var selcVSaved = await Validate().readString(Validate.villageIdES);
      village.forEach((element) {
        villageList.add(element.value!);
        if (selcVSaved != null) {
          if (selcVSaved.contains(element.name.toString())) {
            selectedVillage.add(element.value!);
          }
        }
      });
    }
  }

  callVillageFilterData(String villages) async {
    var network = await Validate().checkNetworkConnection();
    if (network) {
      showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await DownloadDataApi().callVillagesDataDownload(
          villages.toString(), userName!, password!, token!);
      if (response.statusCode == 200) {
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await updateVillageResponces(response.body);
        Navigator.pop(context);
        callCMCCCchecklist(context);
      } else if (response.statusCode == 401) {
        Navigator.pop(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:
          Text(Global.returnTrLable(
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
            Global.returnTrLable(
                locationControlls, CustomText.somethingWentError, lng!),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            context);
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.nointernetconnectionavailable,
              lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> updateVillageResponces(String value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value);
      print(" responce $resultMap");
      await HouseHoldTabResponceHelper().downloadUpdateData(resultMap);
    } catch (e) {
      print("exp ${e.toString()}");
    }
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

  Future<void> initializeData() async {
    lng = await Validate().readString(Validate.sLanguage);
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

    setState(() {});
  }

  callCMCCCchecklist(BuildContext mContext) async {
    var network = await Validate().checkNetworkConnection();
    if (network) {
      showLoaderDialog(mContext);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await CrecheMonetringCheckListCCApi()
          .cmcCCDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateCMCCCchecklist(response);
        Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await initializeData();
        callUserManualData(mContext);

        // Validate().singleButtonPopup(
        //     Global.returnTrLable(locationControlls,
        //         CustomText.data_downloaded_successfully, lng!),
        //     Global.returnTrLable(locationControlls, CustomText.ok, lng!),
        //     false,
        //     mContext);
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

  Future<void> updateCMCCCchecklist(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await CmcCCTabResponseHelper().crecheALMDownloadData(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }


  callUserManualData(BuildContext mContext) async {
    var network = await Validate().checkNetworkConnection();
    if (network) {
      showLoaderDialog(mContext);
      var userName = await Validate().readString(Validate.userName);
      var password = await Validate().readString(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await UserManualApi()
          .userManualDownloadApi(userName!, password!, token!);
      if (response.statusCode == 200) {
        await updateUserManualData(response);
        Navigator.pop(mContext);
        Validate().saveString(
            Validate.dataDownloadDateTime, Validate().currentDateTime());
        await initializeData();
        // await callVillageProfiledata(mContext);

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
            mContext,
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
}

// var dislist =  DatabaseHelper.database!.rawQuery('SELECT * FROM TABLE tabGender Whare state_id=$stateId;');
