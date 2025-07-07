import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/screens/shishu_ghar_details.dart';
import 'package:shishughar/screens/shishu_ghar_details_bottom_bar.dart';
import 'package:shishughar/screens/shishu_ghar_details_bottom_bar_new.dart';
import 'package:shishughar/screens/shishu_ghar_details_replica_screen.dart';
import 'package:shishughar/screens/shishu_ghar_list_navigation.dart';
import 'package:shishughar/screens/tabed_screens/child_gravience/child_grievances_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checkList_cbm/creche_monitering_checklist_CBM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_CC/creche_monitering_checklist_CC_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_alm/creche_monitering_checklist_ALM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitor/creche_monitor_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creshe/creshe_tab_screen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/village_data_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../custom_widget/custom_btn.dart';
import '../custom_widget/custom_string_dropdown.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../database/helper/block_data_helper.dart';
import '../database/helper/district_data_helper.dart';
import '../database/helper/gram_panchayat_data_helper.dart';
import '../database/helper/state_data_helper.dart';
import '../model/databasemodel/tabBlock_model.dart';
import '../model/databasemodel/tabDistrict_model.dart';
import '../model/databasemodel/tabGramPanchayat_model.dart';
import '../model/databasemodel/tabstate_model.dart';
import '../model/dynamic_screen_model/options_model.dart';

class ShiShuGharScreen extends StatefulWidget {
  final int type;
  ShiShuGharScreen({super.key, required this.type});

  _ShiShuGharScreenState createState() => _ShiShuGharScreenState();
}

class _ShiShuGharScreenState extends State<ShiShuGharScreen> {
  TextEditingController Searchcontroller = TextEditingController();
  List<CresheDatabaseResponceModel> crecheData = [];
  List<CresheDatabaseResponceModel> filteredCrecheData = [];
  List<Translation> translatsLabel = [];
  String lng = 'en';
  String role = '';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isExpanded = false;

  OptionsModel? selectedState;
  OptionsModel? selectedDistrict;
  OptionsModel? selectedBlock;
  OptionsModel? selectedGramPanchayat;
  OptionsModel? selectedVillage;

  List<OptionsModel> mstStates = [];
  List<OptionsModel> mstDistrict = [];
  List<OptionsModel> mstBlock = [];
  List<OptionsModel> mstGP = [];
  List<OptionsModel> mstVillage = [];

  List<TabState> states = [];
  List<TabDistrict> district = [];
  List<TabBlock> block = [];
  List<TabGramPanchayat> gramPanchayat = [];
  List<TabVillage> villages = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    var lngtr = await Validate().readString(Validate.sLanguage);
    role = (await Validate().readString(Validate.role))!;

    if (lngtr != null) {
      lng = lngtr;
    }
    List<String> valueItems = [
      CustomText.Search,
      CustomText.Creches_,
      CustomText.CrecheId,
      CustomText.Creche_Name,
      CustomText.state,
      CustomText.District,
      CustomText.Block,
      CustomText.GramPanchayat,
      CustomText.Village,
      CustomText.Selecthere,
      CustomText.Generalfilter,
      CustomText.Locationfilter,
      CustomText.plSelect_state,
      CustomText.plSelect_district,
      CustomText.plSelect_block,
      CustomText.plSelect_geamPanchayat,
      CustomText.plSelect_village,
      CustomText.NorecordAvailable,
      CustomText.pleaseWait,
      CustomText.ok,
      CustomText.select_here,
      CustomText.ShishuGharList,
      CustomText.Filter,
      CustomText.clear
    ];
    await fetchStateList();
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translatsLabel.addAll(value));

    await fetchCrecheDataList();
  }

  Future<void> fetchCrecheDataList() async {
    crecheData = await CrecheDataHelper().getCrecheResponce();
    filteredCrecheData = crecheData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, 'itemRefresh');
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppbar(
            text: Global.returnTrLable(
                translatsLabel, CustomText.ShishuGharList, lng),
            onTap: () {
              Navigator.pop(context, 'itemRefresh');
            },
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShishuGHarNavigation())),
                  child: Icon(
                    Icons.place_rounded,
                    size: 15.sp,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          endDrawer: SafeArea(
              child: Drawer(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 30),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/filter_icon.png",
                                  scale: 2.4,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  Global.returnTrLable(
                                      translatsLabel, CustomText.Filter, lng),
                                  style: Styles.labelcontrollerfont,
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: () async {
                                      _scaffoldKey.currentState!.closeEndDrawer();
                                    },
                                    child: Image.asset(
                                      'assets/cross.png',
                                      color: Colors.grey,
                                      scale: 4,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(),
                          DynamicCustomDropdownField(
                            hintText: Global.returnTrLable(translatsLabel, CustomText.select_here, lng!),
                            titleText: Global.returnTrLable(
                                translatsLabel, CustomText.state, lng!),
                            items: mstStates,
                            isRequred: 0,
                            selectedItem: selectedState != null
                                ? selectedState?.name
                                : null,
                            onChanged: (value) async {
                              selectedState = value;
                              selectedDistrict = null;
                              selectedBlock = null;
                              selectedGramPanchayat = null;
                              selectedVillage = null;
                              mstDistrict = Global.callDistrict(
                                  district, lng!, selectedState);
                              if (mstDistrict.length == 1) {
                                selectedDistrict = mstDistrict.first;
                                mstBlock = Global.callBlocks(
                                    block, lng, selectedDistrict);
                                if (mstBlock.length == 1) {
                                  selectedBlock = mstBlock.first;
                                  mstGP = Global.callGramPanchyats(
                                      gramPanchayat, lng, selectedBlock);
                                  if (mstGP.length == 1) {
                                    selectedGramPanchayat = mstGP.first;
                                    mstVillage = Global.callFiltersVillages(
                                        villages, lng, selectedGramPanchayat);
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
                            hintText: Global.returnTrLable(translatsLabel, CustomText.select_here, lng!),
                            titleText: Global.returnTrLable(
                                translatsLabel, CustomText.District, lng!),
                            items: mstDistrict,
                            isRequred: 0,
                            selectedItem: selectedDistrict != null
                                ? selectedDistrict?.name
                                : null,
                            onChanged: (value) async {
                              selectedDistrict = value;
                              selectedBlock = null;
                              selectedGramPanchayat = null;
                              selectedVillage = null;
                              mstBlock =
                                  Global.callBlocks(block, lng, selectedDistrict);
                              if (mstBlock.length == 1) {
                                selectedBlock = mstBlock.first;
                                mstGP = Global.callGramPanchyats(
                                    gramPanchayat, lng, selectedBlock);
                                if (mstGP.length == 1) {
                                  selectedGramPanchayat = mstGP.first;
                                  mstVillage = Global.callFiltersVillages(
                                      villages, lng, selectedGramPanchayat);
                                }
                              }
                              setState(() {
                                // Update blockList based on selectedDistrict
                                // blockList = // data from database based on selectedDistrict;
                              });
                            },
                          ),
                          DynamicCustomDropdownField(
                            hintText: Global.returnTrLable(translatsLabel, CustomText.select_here, lng!),
                            titleText: Global.returnTrLable(
                                translatsLabel, CustomText.Block, lng!),
                            items: mstBlock,
                            isRequred: 0,
                            selectedItem: selectedBlock != null
                                ? selectedBlock?.name
                                : null,
                            onChanged: (value) async {
                              selectedBlock = value;
                              selectedGramPanchayat = null;
                              selectedVillage = null;
                              mstGP = Global.callGramPanchyats(
                                  gramPanchayat, lng!, selectedBlock);
                              if (mstGP.length == 1) {
                                selectedGramPanchayat = mstGP.first;
                                mstVillage = Global.callFiltersVillages(
                                    villages, lng!, selectedGramPanchayat);
                              }
                              setState(() {
                                // Update gramPanchayatList based on selectedBlock
                                // gramPanchayatList = // data from database based on selectedBlock;
                              });
                            },
                          ),
                          DynamicCustomDropdownField(
                            isRequred: 0,
                            titleText: Global.returnTrLable(
                                translatsLabel, CustomText.GramPanchayat, lng!),
                            items: mstGP,
                            hintText: Global.returnTrLable(
                                translatsLabel, CustomText.Selecthere, lng),
                            selectedItem: selectedGramPanchayat != null
                                ? selectedGramPanchayat?.name
                                : null,
                            onChanged: (value) async {
                              selectedGramPanchayat = value;
                              selectedVillage = null;
                              mstVillage = Global.callFiltersVillages(
                                  villages, lng!, selectedGramPanchayat);
                              if (mstVillage.length == 1) {
                                selectedVillage = mstVillage.first;
                              }
                              setState(() {
                                // Update villageList based on selectedGramPanchayat
                                // villageList = // data from database based on selectedGramPanchayat;
                              });
                            },
                          ),
                          DynamicCustomDropdownField(
                            hintText: Global.returnTrLable(
                                translatsLabel, CustomText.Selecthere, lng),
                            titleText: Global.returnTrLable(
                                translatsLabel, CustomText.Village, lng!),
                            isRequred: 0,
                            items: mstVillage,
                            selectedItem: selectedVillage != null
                                ? selectedVillage?.name
                                : null,
                            onChanged: (value) {
                              setState(() {
                                selectedVillage = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CElevatedButton(
                                    text: Global.returnTrLable(
                                        translatsLabel, 'Clear', lng!),
                                    color: Color(0xffF26BA3),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      cleaAllFilter();
                                    },
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: CElevatedButton(
                                    text: Global.returnTrLable(
                                        translatsLabel, 'Search', lng!),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      filteredgetData(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ))),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextFieldRow(
                      controller: Searchcontroller,
                      onChanged: (value) {
                        print(value);
                        filterDataQu(value);
                      },
                      hintText: Global.returnTrLable(
                          translatsLabel, CustomText.Search, lng),
                      prefixIcon: Image.asset(
                        "assets/search.png",
                        scale: 2.4,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    child: Image.asset(
                      "assets/filter_icon.png",
                      scale: 2.4,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              (filteredCrecheData.length > 0)
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: filteredCrecheData.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                if (widget.type == 1) {
                                  var refStatus = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ChildGrievancesListing(
                                                  crecheName:
                                                      Global.getItemValues(
                                                          filteredCrecheData[
                                                                  index]
                                                              .responces!,
                                                          'creche_name'),
                                                  creche_id:
                                                      filteredCrecheData[index]
                                                          .name
                                                          .toString())));
                                  if (refStatus == 'itemRefresh') {
                                    await fetchCrecheDataList();
                                  }
                                } else if (widget.type == 0) {
                                  // Validate().saveString(Validate.villageId,
                                  //     Global.getItemValues(
                                  //         filteredCrecheData[index].responces!,
                                  //         'village_id'));
                                  var refStatus = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ShishuGharDetailsBottomBar(
                                                crecheId:
                                                    filteredCrecheData[index]
                                                        .name!,
                                                index: 2,
                                                crecheName: Global.getItemValues(
                                                    filteredCrecheData[index]
                                                        .responces!,
                                                    'creche_name'),
                                                crecheCode: Global.getItemValues(
                                                    filteredCrecheData[index]
                                                        .responces!,
                                                    'creche_id'),
                                                isUpdateImage: Global.validString(
                                                    Global.getItemValues(
                                                        crecheData[index]
                                                            .responces!,
                                                        'image')),
                                              )));
                                  if (refStatus == 'itemRefresh') {
                                    await fetchCrecheDataList();
                                  }
                                } else if (widget.type == 2) {
                                  String refStatus = '';
                                  // Validate().saveString(Validate.villageId,
                                  //     Global.getItemValues(
                                  //         filteredCrecheData[index].responces!,
                                  //         'village_id'));
                                  if (role == 'Creche Supervisor') {
                                    refStatus = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                CrecheMonitorListingScreen(
                                                    crecheId:
                                                        filteredCrecheData[index]
                                                            .name
                                                            .toString(),
                                                    crecheName:
                                                        Global.getItemValues(
                                                            filteredCrecheData[
                                                                    index]
                                                                .responces!,
                                                            'creche_name'))));
                                  } else if (role == 'Cluster Coordinator') {
                                    refStatus = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                cmcCCListingScreen(
                                                    creche_id:
                                                        filteredCrecheData[index]
                                                            .name
                                                            .toString(),
                                                    crecheName:
                                                        Global.getItemValues(
                                                            filteredCrecheData[
                                                                    index]
                                                                .responces!,
                                                            'creche_name'))));
                                  } else if (role ==
                                      'Accounts and Logistics Manager') {
                                    refStatus = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                cmcALMListingScreen(
                                                    creche_id:
                                                        filteredCrecheData[index]
                                                            .name
                                                            .toString(),
                                                    crecheName:
                                                        Global.getItemValues(
                                                            filteredCrecheData[
                                                                    index]
                                                                .responces!,
                                                            'creche_name'))));
                                  } else if (role ==
                                      'Capacity and Building Manager') {
                                    refStatus = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                cmcCBMListingScreen(
                                                    creche_id:
                                                        filteredCrecheData[index]
                                                            .name
                                                            .toString(),
                                                    crecheName:
                                                        Global.getItemValues(
                                                            filteredCrecheData[
                                                                    index]
                                                                .responces!,
                                                            'creche_name'))));
                                  }
                                  if (refStatus == 'itemRefresh') {
                                    await fetchCrecheDataList();
                                  }
                                }
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
                                      border:
                                          Border.all(color: Color(0xffE7F0FF)),
                                      borderRadius: BorderRadius.circular(10.r)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 8.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${Global.returnTrLable(translatsLabel, CustomText.CrecheId, lng).trim()} :',
                                              style: Styles.black104,
                                            ),
                                            Text(
                                              '${Global.returnTrLable(translatsLabel, CustomText.Creche_Name, lng).trim()} :',
                                              style: Styles.black104,
                                              strutStyle: StrutStyle(height: 1.3),
                                            ),
                                            Text(
                                              '${Global.returnTrLable(translatsLabel, CustomText.Village, lng).trim()} :',
                                              style: Styles.black104,
                                              strutStyle: StrutStyle(height: 1.3),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10),
                                        SizedBox(
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.06,
                                          width: 2,
                                          child: VerticalDivider(
                                            color: Color(0xffE6E6E6),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  Global.getItemValues(
                                                      filteredCrecheData[index]
                                                          .responces!,
                                                      'creche_id'),
                                                  style: Styles.cardBlue10,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              Text(
                                                  Global.getItemValues(
                                                      filteredCrecheData[index]
                                                          .responces!,
                                                      'creche_name'),
                                                  style: Styles.cardBlue10,
                                                  strutStyle:
                                                      StrutStyle(height: 1.3),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              Text(
                                                  callVillageName(
                                                      filteredCrecheData[index]
                                                          .responces!),
                                                  style: Styles.cardBlue10,
                                                  strutStyle:
                                                      StrutStyle(height: 1.3),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ],
                                          ),
                                        ),
                                        (filteredCrecheData[index].is_edited ==
                                                    0 &&
                                                filteredCrecheData[index]
                                                        .is_uploaded ==
                                                    1)
                                            ? Image.asset(
                                                "assets/sync.png",
                                                scale: 1.5,
                                              )
                                            : Image.asset(
                                                "assets/sync_gray.png",
                                                scale: 1.5,
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : Expanded(
                      child: Center(
                          child: Text(Global.returnTrLable(translatsLabel,
                              CustomText.NorecordAvailable, lng)))),
              SizedBox(
                height: 10.h,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  filterDataQu(String entry) {
    if (entry.length > 0) {
      filteredCrecheData = crecheData
          .where((element) =>
              (Global.getItemValues(element.responces!, 'creche_id'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()) ||
              (Global.getItemValues(element.responces!, 'creche_name'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()))
          .toList();
    } else {
      filteredCrecheData = crecheData;
    }
    setState(() {});
    print('cLength: ${filteredCrecheData.length}');
  }

  String callVillageName(String crecheItem) {
    String returnValue = '';
    var items = villages
        .where((element) =>
            element.name ==
            int.parse(Global.getItemValues(crecheItem, 'village_id')))
        .toList();
    if (items.length > 0) {
      returnValue = items[0].value!;
    }
    return returnValue;
  }

  void cleaAllFilter() {
    filteredCrecheData = crecheData;
    selectedVillage = null;
    selectedGramPanchayat = null;
    Searchcontroller.text = '';
    setState(() {});
  }

  filteredgetData(
    BuildContext mContext,
  ) async {
    // if (selectedState == null) {
    //   Validate().singleButtonPopup(
    //       Global.returnTrLable(translatsLabel, CustomText.plSelect_state, lng!),
    //       Global.returnTrLable(translatsLabel, CustomText.ok, lng!),
    //       false,
    //       context);
    // } else if (selectedDistrict == null) {
    //   Validate().singleButtonPopup(
    //       Global.returnTrLable(translatsLabel, CustomText.plSelect_district, lng!),
    //       Global.returnTrLable(translatsLabel, CustomText.ok, lng!),
    //       false,
    //       context);
    // } else if (selectedBlock == null) {
    //   Validate().singleButtonPopup(
    //       Global.returnTrLable(translatsLabel, CustomText.plSelect_block, lng!),
    //       Global.returnTrLable(translatsLabel, CustomText.ok, lng!),
    //       false,
    //       context);
    // } else if (selectedGramPanchayat == null) {
    //   Validate().singleButtonPopup(
    //       Global.returnTrLable(translatsLabel, CustomText.plSelect_geamPanchayat, lng!),
    //       Global.returnTrLable(translatsLabel, CustomText.ok, lng!),
    //       false,
    //       context);
    // } else if (selectedVillage == null) {
    //   Validate().singleButtonPopup(
    //       Global.returnTrLable(translatsLabel, CustomText.plSelect_village, lng!),
    //       Global.returnTrLable(translatsLabel, CustomText.ok, lng!),
    //       false,
    //       context);
    // } else {
    //   var villageId = villages.where((element) =>
    //   element.value!.toLowerCase() == selectedVillage!.toLowerCase())
    //       .toList();
    //   if (villageId.length > 0) {

    //     filteredCrecheData = crecheData.where((item) {
    //       var viItem = Global.getItemValues(item.responces!, 'village_id');
    //       return viItem.toString() == villageId[0].name.toString();
    //     }).toList();

    //   }
    // }
    if (selectedGramPanchayat != null && selectedVillage != null) {
      filteredCrecheData = crecheData.where((item) {
        var viItem = Global.getItemValues(item.responces!, 'village_id');
        var grItem = Global.getItemValues(item.responces!, 'gp_id');
        return viItem.toString() == selectedVillage?.name.toString() &&
            grItem.toString() == selectedGramPanchayat?.name.toString();
      }).toList();
    } else if (selectedGramPanchayat != null) {
      filteredCrecheData = crecheData.where((item) {
        var grItem = Global.getItemValues(item.responces!, 'gp_id');
        return grItem.toString() == selectedGramPanchayat?.name.toString();
      }).toList();
    } else if (selectedVillage != null) {
      filteredCrecheData = crecheData.where((item) {
        var viItem = Global.getItemValues(item.responces!, 'village_id');
        return viItem.toString() == selectedVillage?.name.toString();
      }).toList();
    }

    setState(() {});
  }

  Future<void> fetchStateList() async {
    states = await StateDataHelper().getTabStateList();
    district = await DistrictDataHelper().getTabDistrictList();
    block = await BlockDataHelper().getTabBlockList();
    gramPanchayat = await GramPanchayatDataHelper().getTabGramPanchayatList();
    villages = await VillageDataHelper().getTabVillageList();

    mstStates = Global.callSatates(states, lng);

    if (mstStates.length == 1) {
      selectedState = mstStates.first;
      mstDistrict = Global.callDistrict(district, lng, selectedState);
    }
    if (mstDistrict.length == 1) {
      selectedDistrict = mstDistrict.first;
      mstBlock = Global.callBlocks(block, lng, selectedDistrict);
    }
    if (mstBlock.length == 1) {
      selectedBlock = mstBlock.first;
      mstGP = Global.callGramPanchyats(gramPanchayat, lng, selectedBlock);
    }
    if (mstGP.length == 1) {
      selectedGramPanchayat = mstGP.first;
      mstVillage =
          Global.callFiltersVillages(villages, lng, selectedGramPanchayat);
    }

    setState(() {});
  }
}
