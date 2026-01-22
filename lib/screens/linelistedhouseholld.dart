import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_double_button_dialog.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/mst_cammon_model.dart';
import 'package:shishughar/model/dynamic_screen_model/house_hold_tab_responce_model.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/hh_tabview_screen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:http/src/response.dart';
import '../custom_widget/custom_radio_btn.dart';
import '../custom_widget/custom_textfield.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../database/helper/backdated_configiration_helper.dart';
import '../database/helper/block_data_helper.dart';
import '../database/helper/creche_helper/creche_data_helper.dart';
import '../database/helper/district_data_helper.dart';
import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../database/helper/gram_panchayat_data_helper.dart';
import '../database/helper/state_data_helper.dart';
import '../database/helper/village_data_helper.dart';
import '../model/databasemodel/backdated_configiration_model.dart';
import '../model/databasemodel/tabBlock_model.dart';
import '../model/databasemodel/tabDistrict_model.dart';
import '../model/databasemodel/tabGramPanchayat_model.dart';
import '../model/databasemodel/tabVillage_model.dart';
import '../model/databasemodel/tabstate_model.dart';
import '../model/dynamic_screen_model/house_hold_children_model.dart';
import '../model/dynamic_screen_model/options_model.dart';
import '../utils/globle_method.dart';
import '../utils/validate.dart';

class LineholdlistedScreen extends StatefulWidget {
  final int crecheId;
   bool? isDraft;
   LineholdlistedScreen({super.key, required this.crecheId,  this.isDraft});

  @override
  State<LineholdlistedScreen> createState() => _LineholdlistedScreenState();
}

class _LineholdlistedScreenState extends State<LineholdlistedScreen> {
  TextEditingController Searchcontroller = TextEditingController();

  List<HouseHoldTabResponceMosdel> hhdata = [];
  List<HouseHoldChildrenModel> childHHData = [];

  String hhGuid = Validate().randomGuid();
  String? village;
  String? role;
  String? lng;
  String? selectedOdour;
  List<Translation> hhlistingControlls = [];
  List<OptionsModel> statushhdata = [];
  List<HouseHoldTabResponceMosdel> filterData = [];
  // TextEditingController StartDatecontroller = TextEditingController();
  String? calEndDate;
  String? calStartDate;
  List<MstCommonOtherModel> verificationStatus = [];

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
  List<TabVillage> villagesItemms = [];

  List<int> stateIdList = [];
  List<int> districtIdList = [];
  List<int> blockIdList = [];
  List<int> panchayatIdList = [];
  List<int> villageIdList = [];
  String? crecheOpeningDate;
  String? crecheClosingDate;
  String GeneralFilter = 'General Filter';
  int? maxAgeLimit;
  int? minAgeLimit;

  String? _selectedItem;
  List<OptionsModel> statusListItem = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isOnlyUnsynched =false;
  List<HouseHoldTabResponceMosdel> unsynchedList = [];
  List<HouseHoldTabResponceMosdel> allList = [];
  BackdatedConfigirationModel? backdatedConfigirationModel;
  bool isLoading = true;


  void validateDates() {
    if (calStartDate != null && calEndDate != null) {
      DateFormat inputFormata = DateFormat('yyyy-MM-dd');
      DateTime startDate = inputFormata.parse(calStartDate!);
      DateTime endDate = inputFormata.parse(calEndDate!);

      if (startDate.isAfter(endDate)) {
        calStartDate = null;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  width: MediaQuery.of(context).size.width * 5.00,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 40.h,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xff5979AA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Center(
                              child: Text(CustomText.SHISHUGHAR,
                                  style: Styles.white126P)),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05,
                                right:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Text(
                                Global.returnTrLable(hhlistingControlls,
                                    CustomText.startDateMsg, lng!),
                                style: Styles.black3125,
                                textAlign: TextAlign.center)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 70, vertical: 10),
                          child: CElevatedButton(
                            text: Global.returnTrLable(
                                hhlistingControlls, CustomText.ok, lng!),
                            color: Color(0xff369A8D),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        )
                      ])),
            );
          },
        );
      } else if (endDate.isBefore(startDate)) {
        // If end date is before start date, show error message for end date
        calStartDate = null;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  width: MediaQuery.of(context).size.width * 5.00,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 40.h,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xff5979AA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Center(
                              child: Text(CustomText.SHISHUGHAR,
                                  style: Styles.white126P)),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05,
                                right:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Text(
                                Global.returnTrLable(hhlistingControlls,
                                    CustomText.endDateMsg, lng!),
                                style: Styles.black3125,
                                textAlign: TextAlign.center)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 70, vertical: 10),
                          child: CElevatedButton(
                            text: Global.returnTrLable(
                                hhlistingControlls, CustomText.ok, lng!),
                            color: Color(0xff369A8D),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        )
                      ])),
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isOnlyUnsynched=widget.isDraft??false;
    fetchHhDataList();
  }
/*hhdata= allData.where((element) =>
    !((Global.stringToInt(getItemValues(element.responces!,'verification_status'))==4))
    ).toList();*/

  Future<void> fetchHhDataList() async {
    lng = await Validate().readString(Validate.sLanguage);
    calEndDate = Global.initCurrentDate();
    var panchayatId = await Validate().readInt(Validate.panchayatId);
    role = await Validate().readString(Validate.role);
    var creches = await CrecheDataHelper().getCrecheResponceItem(widget.crecheId);
    backdatedConfigirationModel = await BackdatedConfigirationHelper().excuteBackdatedConfigirationModel(CustomText.houseHoldForm);
    if(creches.length>0){
      crecheOpeningDate=Global.getItemValues(creches.first.responces, 'creche_opening_date');
      crecheClosingDate=Global.getItemValues(creches.first.responces, 'creche_closing_date');
    }
    filterData.clear();
    hhdata.clear();
    var allData = await HouseHoldTabResponceHelper()
        .getHouseHoldItemsMapByCreche(widget.crecheId);
    childHHData = await HouseHoldTabResponceHelper()
        .getAllChildByHHCreche(widget.crecheId);
    if (role == 'CRP') {
      hhdata = allData
          .where((element) =>
              getItemValues(element.responces!, 'gp_id') ==
              panchayatId.toString())
          .toList();
    }
    else if (role == CustomText.clusterCoordinator) {
      hhdata = allData;
    }
    else
      hhdata = allData;
    unsynchedList = hhdata
        .where((element) =>
            element.is_edited == 1 ||
            Global.stringToInt(Global.getItemValues(
                    element.responces, 'verification_status')) ==
                1)
        .toList();
    allList = hhdata;
    filterData = isOnlyUnsynched ? unsynchedList : allList;
    if (filterData.isNotEmpty && filterData.length > 0) {
      stateIdList = await _fetchSpecificElement(filterData, 'state_id');
      districtIdList = await _fetchSpecificElement(filterData, 'district_id');
      blockIdList = await _fetchSpecificElement(filterData, 'block_id');
      panchayatIdList = await _fetchSpecificElement(filterData, 'gp_id');
      villageIdList = await _fetchSpecificElement(filterData, 'village_id');
    }

    await fetchStateList();

    await setWidgetText();
    statushhdata = await OptionsModelHelper()
        .getMstCommonOptions('Verfication Status', lng!);
    villagesItemms = await VillageDataHelper().getTabVillageList();
    if (role == CustomText.clusterCoordinator) {
      statusListItem = statushhdata
          .where((element) =>
              (element.name == '3') ||
              (element.name == '5') ||
              (element.name == '4'))
          .toList();
    } else {
      statusListItem = statushhdata;
    }
    isLoading=false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'itemRefresh');
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: (role == CustomText.crecheSupervisor)
              ? InkWell(
                  onTap: () async {
                    // if (crechedOpeningDate()) {
                    //   if(crechedCloseDate()) {
                        _showConsentDialog(context);
                    //   }else{
                    //     Validate().singleButtonPopup(
                    //         Global.returnTrLable(hhlistingControlls,
                    //             CustomText.crecheClosingDateMsg, lng!),
                    //         Global.returnTrLable(
                    //             hhlistingControlls, CustomText.ok, lng!),
                    //         false,
                    //         context);
                    //   }
                    // }else{
                    //   Validate().singleButtonPopup(
                    //       Global.validString(crecheOpeningDate)?Global.returnTrLable(hhlistingControlls,
                    //           CustomText.crecheOpeningDateAfterDateForHH, lng!):Global.returnTrLable(hhlistingControlls,
                    //           CustomText.crecheOpeningDateMsg, lng!),
                    //       Global.returnTrLable(
                    //           hhlistingControlls, CustomText.ok, lng!),
                    //       false,
                    //       context);
                    // }
                  },
                  child: Image.asset(
                    "assets/add_btn.png",
                    scale: 2.7,
                    color: Color(0xff5979AA),
                  ),
                )
              : null,
          appBar: CustomAppbar(
            text: (lng != null)
                ? (village != null)
                    ? Global.returnTrLable(
                            hhlistingControlls, CustomText.HHlist, lng!) +
                        '-' +
                        village.toString()
                    : Global.returnTrLable(
                        hhlistingControlls, CustomText.HHlist, lng!)
                : '',
            onTap: () {
              Navigator.pop(context, 'itemRefresh');
            },
          ),
          endDrawer: SafeArea(
            child: Drawer(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: (lng != null)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              SizedBox(
                                height: 30.h,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/filter_icon.png",
                                    scale: 2.4,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    Global.returnTrLable(hhlistingControlls,
                                        CustomText.Filter, lng!),
                                    style: Styles.labelcontrollerfont,
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: () async {
                                        _scaffoldKey.currentState!
                                            .closeEndDrawer();
                                        // cleaAllFilter();
                                      },
                                      child: Image.asset(
                                        'assets/cross.png',
                                        color: Colors.grey,
                                        scale: 4,
                                      )),
                                ],
                              ),
                              (role == CustomText.clusterCoordinator ||
                                      role == 'CRP' ||
                                      role == CustomText.crecheSupervisor)
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: CustomRadioButton(
                                            value: "General Filter",
                                            groupValue: GeneralFilter,
                                            onChanged: (value) {
                                              setState(() {
                                                GeneralFilter = value!;
                                              });
                                            },
                                            label: Global.returnTrLable(
                                                hhlistingControlls,
                                                CustomText.Generalfilter,
                                                lng!),
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomRadioButton(
                                            value: "Location Filter",
                                            groupValue: GeneralFilter,
                                            onChanged: (value) {
                                              setState(() {
                                                GeneralFilter = value!;
                                              });
                                            },
                                            label: Global.returnTrLable(
                                                hhlistingControlls,
                                                CustomText.Locationfilter,
                                                lng!),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              if (GeneralFilter == "General Filter") ...[
                                // DynamicCustomDropdownField(
                                //   titleText: Global.returnTrLable(
                                //       hhlistingControlls, 'Status', lng!),
                                //   items: statusListItem,
                                //   selectedItem: _selectedItem,
                                //   hintText: CustomText.Selecthere,
                                //   onChanged: (value) {
                                //     if (value != null)
                                //       String selectedId = value.name!;
                                //     setState(() {
                                //       _selectedItem = value?.name!;
                                //     });
                                //
                                //     //    filterDataByCriteria();
                                //   },
                                // ),
                                CustomDatepickerDynamic(
                                  initialvalue: calStartDate,
                                  isRequred: 0,
                                  calenderValidate: [],
                                  titleText: Global.returnTrLable(
                                      hhlistingControlls, 'Start Date', lng!),
                                  onChanged: (value) {
                                    calStartDate = value;
                                    validateDates();
                                  },
                                ),
                                CustomDatepickerDynamic(
                                  fieldName: 'date_of_visit',
                                  initialvalue: calEndDate,
                                  calenderValidate: [],
                                  titleText: Global.returnTrLable(
                                      hhlistingControlls, 'End Date', lng!),
                                  onChanged: (value) {
                                    calEndDate = value;
                                    // setState(() {});
        
                                    validateDates();
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: DynamicCustomTextFieldInt(
                                        // width: MediaQuery.of(context).size.width * 0.36,
                                        initialvalue: minAgeLimit,
                                        hintText: Global.returnTrLable(
                                            hhlistingControlls, CustomText.minAgeInMonthEn, lng!),
                                        // isRequred: 1,
                                        onChanged: (value) {
                                          minAgeLimit = value;
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: DynamicCustomTextFieldInt(
                                        // width: MediaQuery.of(context).size.width * 0.36,
                                        initialvalue: maxAgeLimit,
                                        hintText: Global.returnTrLable(
                                            hhlistingControlls, CustomText.maxAgeInMonthEn, lng!),
                                        onChanged: (value) {
                                          maxAgeLimit = value;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ] else ...[
                                DynamicCustomDropdownField(
          hintText: Global.returnTrLable(hhlistingControlls, CustomText.select_here, lng!),
                                  titleText: Global.returnTrLable(
                                      hhlistingControlls, CustomText.state, lng!),
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
                                    }
                                    setState(() {});
                                  },
                                ),
                                DynamicCustomDropdownField(
                                  hintText: Global.returnTrLable(hhlistingControlls, CustomText.select_here, lng!),
                                  titleText: Global.returnTrLable(
                                      hhlistingControlls,
                                      CustomText.District,
                                      lng!),
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
                                    mstBlock = Global.callBlocks(
                                        block, lng!, selectedDistrict);
                                    if (mstBlock.length == 1) {
                                      selectedBlock = mstBlock.first;
                                    }
                                    setState(() {
                                      // Update blockList based on selectedDistrict
                                      // blockList = // data from database based on selectedDistrict;
                                    });
                                  },
                                ),
                                DynamicCustomDropdownField(
                                  hintText: Global.returnTrLable(hhlistingControlls, CustomText.select_here, lng!),
                                  titleText: Global.returnTrLable(
                                      hhlistingControlls, CustomText.Block, lng!),
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
                                    }
                                    setState(() {
                                      // Update gramPanchayatList based on selectedBlock
                                      // gramPanchayatList = // data from database based on selectedBlock;
                                    });
                                  },
                                ),
                                DynamicCustomDropdownField(
                                  hintText: Global.returnTrLable(
                                      hhlistingControlls,
                                      CustomText.select_here,
                                      lng!),
                                  isRequred: 0,
                                  titleText: Global.returnTrLable(
                                      hhlistingControlls,
                                      CustomText.GramPanchayat,
                                      lng!),
                                  items: mstGP,
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
                                    setState(() {});
                                  },
                                ),
                                DynamicCustomDropdownField(
                                  hintText: Global.returnTrLable(
                                      hhlistingControlls,
                                      CustomText.select_here,
                                      lng!),
                                  titleText: Global.returnTrLable(
                                      hhlistingControlls,
                                      CustomText.Village,
                                      lng!),
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
                              ],
                              SizedBox(
                                height: 10.h,
                              ),
                              Padding(
                                padding: EdgeInsets.all(3),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CElevatedButton(
                                        text: Global.returnTrLable(
                                            hhlistingControlls, 'Clear', lng!),
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
                                            hhlistingControlls, 'Search', lng!),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          filteredgetData(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              role == CustomText.crecheSupervisor
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 25),
                                      child: AnimatedRollingSwitch(
                                        title1: Global.returnTrLable(
                                            hhlistingControlls,
                                            CustomText.all,
                                            lng!),
                                        title2: Global.returnTrLable(
                                            hhlistingControlls,
                                            CustomText.usynchedAndDraft,
                                            lng!),
                                        isOnlyUnsynched: isOnlyUnsynched ?? false,
                                        onChange: (value) async {
                                          setState(() {
                                            isOnlyUnsynched = value;
                                          });
                                          await fetchHhDataList();
                                        },
                                      ),
                                    )
                                  : SizedBox()
                            ])
                      : SizedBox(),
                )),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldRow(
                        controller: Searchcontroller,
                        onChanged: (value) {
                          print(value);
                          filterDataQu(value);
                        },
                        hintText: (lng != null)
                            ? Global.returnTrLable(
                                hhlistingControlls, 'Search', lng!)
                            : '',
                        prefixIcon: Image.asset(
                          "assets/search.png",
                          scale: 2.4,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Image.asset(
                        "assets/filter_icon.png",
                        scale: 2.4,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  SizedBox(),
                  Text(
                      lng != null
                          ? Global.returnTrLable(
                                  hhlistingControlls, CustomText.totalHH, lng!) +
                              " : ${filterData.length}"
                          : CustomText.totalHH + " : ${filterData.length}",
                      style: Styles.black127P,
                      strutStyle: StrutStyle(height: 1.2),
                      textAlign: TextAlign.left),
                ]),
                isLoading?Expanded(
                    child: Center(
                        child: CircularProgressIndicator())):
                (filterData.length > 0) ? Expanded(
                        child: ListView.builder(
                          itemCount: filterData.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                // Handle item tap here
                                print('Item $index tapped');
                                String? minDate;
                                if(Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0){
                                  minDate=await Validate().requredOnlyMinimum(filterData[index].created_at, backdatedConfigirationModel!.back_dated_data_entry_allowed!);
                                }
                                String? maxDate=filterData[index].created_at;
                                var refStatus = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HHTabScreen(
                                            hhGuid: filterData[index].HHGUID!,
                                            crecheId: widget.crecheId,minDate:minDate,maxDate:maxDate),
                                  ),
                                );
                                if (refStatus == 'itemRefresh') {
                                  await fetchHhDataList();
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                child: Stack(
                                  children: [
                                    Container(
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
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 8.h,
                                        ),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Global.returnTrLable(
                                                          hhlistingControlls,
                                                          CustomText.hhID,
                                                          lng!) +
                                                      " : ",
                                                  style: Styles.black104,
                                                ),
                                                Text(
                                                  Global.returnTrLable(
                                                          hhlistingControlls,
                                                          CustomText
                                                              .RespondentName,
                                                          lng!) +
                                                      " : ",
                                                  style: Styles.black104,
                                                ),
                                                Text(
                                                  Global.returnTrLable(
                                                          hhlistingControlls,
                                                          CustomText.hhNameS,
                                                          lng!) +
                                                      " : ",
                                                  style: Styles.black104,
                                                  strutStyle:
                                                      StrutStyle(height: 1.2),
                                                ),
                                                Text(
                                                  Global.returnTrLable(
                                                          hhlistingControlls,
                                                          CustomText.datevisit,
                                                          lng!) +
                                                      " : ",
                                                  style: Styles.black104,
                                                  strutStyle:
                                                      StrutStyle(height: 1.2),
                                                ),
                                                Text(
                                                  Global.returnTrLable(
                                                          hhlistingControlls,
                                                          CustomText.Village,
                                                          lng!) +
                                                      " : ",
                                                  style: Styles.black104,
                                                  strutStyle:
                                                      StrutStyle(height: 1.2),
                                                ),
                                                Text(
                                                  Global.returnTrLable(
                                                          hhlistingControlls,
                                                          CustomText.Status,
                                                          lng!) +
                                                      " : ",
                                                  style: Styles.black104,
                                                  strutStyle:
                                                      StrutStyle(height: 1.2),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            VerticalDivider(
                                              color: Color(0xffE6E6E6),
                                              width: 2,
                                              thickness: 2,
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
                                                      getItemValues(
                                                          filterData[index]
                                                              .responces!,
                                                          'hhid'),
                                                      style: Styles.cardBlue10,
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                  Text(
                                                      getItemValues(
                                                          filterData[index]
                                                              .responces!,
                                                          'respondent_name'),
                                                      style: Styles.cardBlue10,
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                  Text(
                                                      getItemValues(
                                                          filterData[index]
                                                              .responces!,
                                                          'hosuehold_head_name'),
                                                      style: Styles.cardBlue10,
                                                      strutStyle:
                                                          StrutStyle(height: 1.2),
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                  Text(
                                                      Validate().displeDateFormate(
                                                          getItemValues(
                                                              filterData[index]
                                                                  .responces!,
                                                              'date_of_visit')),
                                                      style: Styles.cardBlue10,
                                                      strutStyle:
                                                          StrutStyle(height: 1.2),
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                  Text(
                                                      callVillageName(
                                                          filterData[index]
                                                              .responces!),
                                                      style: Styles.cardBlue10,
                                                      strutStyle:
                                                          StrutStyle(height: 1.2),
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                  Text(
                                                      getfindStatusValues(
                                                          getItemValues(
                                                              filterData[index]
                                                                  .responces!,
                                                              'verification_status')),
                                                      style: Styles.cardBlue10,
                                                      strutStyle:
                                                          StrutStyle(height: 1.2),
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            ((Global.stringToInt(Global.getItemValues(
                                                        filterData[index]
                                                            .responces!,
                                                        'verification_status')) ==
                                                    3))
                                                ? Image.asset(
                                                    "assets/sync.png",
                                                    scale: 1.5,
                                                  )
                                                : ((Global.stringToInt(
                                                            Global.getItemValues(
                                                                filterData[index]
                                                                    .responces!,
                                                                'verification_status')) ==
                                                        1)
                                                    ? SizedBox()
                                                    // Icon(
                                                    //     Icons.error_outline,
                                                    //     color:
                                                    //         Colors.red.shade500,
                                                    //     shadows: [
                                                    //       BoxShadow(
                                                    //           spreadRadius: 2,
                                                    //           blurRadius: 4,
                                                    //           color: Colors
                                                    //               .red.shade200)
                                                    //     ],
                                                    //   )
                                                    : Image.asset(
                                                        "assets/sync_gray.png",
                                                        scale: 1.5,
                                                      ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                        visible: Global.stringToInt(
                                                Global.getItemValues(
                                                    filterData[index].responces!,
                                                    'verification_status')) ==
                                            1,
                                        child: Positioned(
                                          top: 24,
                                          right: 10,
                                          child: InkWell(
                                            onTap: () async {
                                              showDeleteDialog(filterData[index]);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.red),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.h, horizontal: 2.w),
                                              child: Icon(
                                                Icons.delete_rounded,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        )),
                                    Visibility(
                                        visible: Global.stringToInt(
                                                Global.getItemValues(
                                                    filterData[index].responces!,
                                                    'verification_status')) ==
                                            1,
                                        child: Positioned(
                                            bottom: 24,
                                            right: 8,
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              shadows: [
                                                BoxShadow(
                                                    spreadRadius: 2,
                                                    blurRadius: 4,
                                                    color: Colors.red.shade200)
                                              ],
                                            )))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
                            child: Text((lng != null)
                                ? Global.returnTrLable(hhlistingControlls,
                                    CustomText.NorecordAvailable, lng!)
                                : '')))

                ,
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void cleaAllFilter() {
    selectedVillage = null;
    selectedGramPanchayat = null;
    calEndDate = null;
    calStartDate = null;
    maxAgeLimit = null;
    minAgeLimit = null;
    filterData = isOnlyUnsynched ? unsynchedList : allList;
    _selectedItem = null;
    setState(() {});
  }

  showDeleteDialog(HouseHoldTabResponceMosdel record) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDoubleButton(
              message: Global.returnTrLable(
                  hhlistingControlls, CustomText.areSureToDelete, lng ?? 'en'),
              posButton: Global.returnTrLable(
                  hhlistingControlls, CustomText.delete, lng ?? 'en'),
              negButton: Global.returnTrLable(
                  hhlistingControlls, CustomText.Cancel, lng ?? 'en'),
              onPositive: () async {
                await HouseHoldTabResponceHelper().deleteDraftRecords(record);
                await fetchHhDataList();
                Navigator.of(context).pop(true);
                setState(() {});
              });
        });
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

  String getfindStatusValues(String id) {
    String returnValue = "";

    if (Global.validString(id)) {
      var reltionvl =
          statushhdata.where((element) => element.name == id).toList();
      if (reltionvl.length > 0) {
        returnValue = reltionvl[0].values!;
      }
    }

    return returnValue;
  }

  // callVerificationStatusData() async {
  //   var network = await Validate().checkNetworkConnection();
  //   var villageId =await Validate().readInt(Validate.villageId);
  //   if (network) {
  //     showLoaderDialog(context);
  //     var userName = await Validate().readString( Validate.userName);
  //     var password = await Validate().readString( Validate.Password);
  //     var token = await Validate().readString( Validate.appToken);
  //     await VerificationStatusUpdateApi().callVerificationStatusApi(villageId.toString(),userName!,password!,token!).then((
  //         value) async =>
  //     await updateResponces(value));
  //     Navigator.pop(context);
  //     await fetchHhDataList();
  //
  //   } else {
  //     Validate().singleButtonPopup(
  //         Global.returnTrLable(hhlistingControlls, CustomText.nointernetconnectionavailable, lng!),
  //         Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
  //         false, context);
  //   }
  // }

  Future<void> updateResponces(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await HouseHoldTabResponceHelper().updateUploadedHHDataItem(resultMap);
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
                    hhlistingControlls, CustomText.pleaseWait, lng!)),
              ],
            ),
          ),
        );
      },
    );
  }

  filterDataQu(String entry) {
    var filteredList = isOnlyUnsynched ? unsynchedList : allList;
    if (entry.length > 0) {
      filterData = filteredList
          .where((element) =>
              (getItemValues(element.responces!, 'hosuehold_head_name'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()) ||
              (getItemValues(element.responces!, 'respondent_name'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()))
          .toList();
    } else
      filterData = filteredList;
    setState(() {});
    print('dd ${filterData.length}');
  }

  Future<void> setWidgetText() async {
    // lng = await Validate().readString(Validate.sLanguage);
    // role = await Validate().readString(Validate.role);
    List<String> valueNames = [
      CustomText.RespondentName,
      CustomText.hhNameS,
      CustomText.datevisit,
      CustomText.Status,
      CustomText.StartDate,
      CustomText.EndDate,
      CustomText.Search,
      CustomText.Cancel,
      CustomText.HHlist,
      CustomText.state,
      CustomText.District,
      CustomText.Block,
      CustomText.GramPanchayat,
      CustomText.Village,
      CustomText.Generalfilter,
      CustomText.Locationfilter,
      CustomText.plSelect_state,
      CustomText.plSelect_district,
      CustomText.plSelect_block,
      CustomText.plSelect_geamPanchayat,
      CustomText.plSelect_village,
      CustomText.NorecordAvailable,
      CustomText.ok,
      CustomText.error,
      CustomText.startDateMsg,
      CustomText.endDateMsg,
      CustomText.pleaseWait,
      CustomText.nointernetconnectionavailable,
      CustomText.ok,
      CustomText.pleaseSelectStartDate,
      CustomText.select_here,
      CustomText.IAgree,
      CustomText.PrivacyPolicy,
      CustomText.PrivacyPolicyDescription,
      CustomText.all,
      CustomText.usynchedAndDraft,
      CustomText.totalHH,
      CustomText.hhID,
      CustomText.Filter,
      CustomText.clear,
      CustomText.Cancel,
      CustomText.areSureToDelete,
      CustomText.delete,
      CustomText.crecheOpeningDateMsg,
      CustomText.crecheClosingDateMsg,
      CustomText.minAgeInMonthEn,
      CustomText.maxAgeInMonthEn,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => hhlistingControlls.addAll(value));

    setState(() {});
  }

  filteredgetData(
    BuildContext mContext,
  ) async {
    var filteredList = isOnlyUnsynched ? unsynchedList : allList;
    if (GeneralFilter == 'General Filter') {
      String? selectedStatus = _selectedItem;

      filterData = filteredList.where((item) {
        String status = getItemValues(item.responces!, 'verification_status');
        String dateOfVisit = getItemValues(item.responces!, 'date_of_visit');
        print("$status");

        if ((selectedStatus != null && selectedStatus.isNotEmpty) &&
            (calStartDate != null && calEndDate != null)) {
          DateFormat inputFormata = DateFormat('yyyy-MM-dd');
          DateTime itemDate = inputFormata.parse(dateOfVisit);
          DateTime sdate = inputFormata.parse(calStartDate!);
          DateTime edate = inputFormata.parse(calEndDate!);

          if (status == selectedStatus &&
              (!itemDate.isBefore(sdate) && !itemDate.isAfter(edate))) {
            return true;
          } else {
            return false;
          }
        } else if (selectedStatus != null && selectedStatus.isNotEmpty) {
          if (status == selectedStatus) {
            return true;
          } else {
            return false;
          }
        } else if (calStartDate != null && calEndDate != null) {
          DateFormat inputFormata = DateFormat('yyyy-MM-dd');
          DateTime itemDate = inputFormata.parse(dateOfVisit);
          DateTime sdate = inputFormata.parse(calStartDate!);
          DateTime edate = inputFormata.parse(calEndDate!);

          if (itemDate.isBefore(sdate) || itemDate.isAfter(edate)) {
            return false;
          } else {
            return true;
          }
        }

        return true;
      }).toList();
      filterData=await HouseHoldTabResponceHelper().filterChildAge(minAgeLimit,
          maxAgeLimit, filterData,childHHData);

    }
    // else {
    //   return await showDialog(
    //     context: mContext,
    //     builder: (mContext) {
    //       return SingleButtonPopupDialog(
    //           message: Global.returnTrLable(
    //               hhlistingControlls, CustomText.pleaseSelectStartDate, lng!),
    //           button: Global.returnTrLable(
    //               hhlistingControlls, CustomText.ok, lng!));
    //     },
    //   );
    // }
    else if (GeneralFilter == 'Location Filter') {
      // if (selectedState == null) {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(
      //           hhlistingControlls, CustomText.plSelect_state, lng!),
      //       Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
      //       false,
      //       context);
      // } else if (selectedDistrict == null) {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(
      //           hhlistingControlls, CustomText.plSelect_district, lng!),
      //       Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
      //       false,
      //       context);
      // } else if (selectedBlock == null) {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(
      //           hhlistingControlls, CustomText.plSelect_block, lng!),
      //       Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
      //       false,
      //       context);
      // } else if (selectedGramPanchayat == null) {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(
      //           hhlistingControlls, CustomText.plSelect_geamPanchayat, lng!),
      //       Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
      //       false,
      //       context);
      // } else if (selectedVillage == null) {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(
      //           hhlistingControlls, CustomText.plSelect_village, lng!),
      //       Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
      //       false,
      //       context);
      // } else {
      if (selectedGramPanchayat != null && selectedVillage != null) {
        filterData = filteredList.where((item) {
          var viItem = getItemValues(item.responces!, 'village_id');
          var grItem = getItemValues(item.responces!, 'gp_id');
          return viItem.toString() == selectedVillage?.name.toString() &&
              grItem.toString() == selectedGramPanchayat?.name.toString();
        }).toList();
      } else if (selectedGramPanchayat != null) {
        filterData = filteredList.where((item) {
          var grItem = getItemValues(item.responces!, 'gp_id');
          return grItem.toString() == selectedGramPanchayat?.name.toString();
        }).toList();
      } else if (selectedVillage != null) {
        filterData = filteredList.where((item) {
          var viItem = Global.getItemValues(item.responces!, 'village_id');
          return viItem.toString() == selectedVillage?.name.toString();
        }).toList();
      }
    }
    setState(() {});
  }

  Future<void> fetchStateList() async {
    StateDataHelper databaseHelper = StateDataHelper();
    if (stateIdList.isNotEmpty && stateIdList.length > 0) {
      states = await databaseHelper.getStateListByStateId(stateIdList);
    } else {
      states = await databaseHelper.getTabStateList();
    }
    if (districtIdList.isNotEmpty && districtIdList.length > 0) {
      district = await DistrictDataHelper()
          .getDistrictListByDistrictId(districtIdList);
    } else
      district = await DistrictDataHelper().getTabDistrictList();

    if (blockIdList.isNotEmpty && blockIdList.length > 0) {
      block = await BlockDataHelper().getBlockListByBlockId(blockIdList);
    } else
      block = await BlockDataHelper().getTabBlockList();

    if (panchayatIdList.isNotEmpty && panchayatIdList.length > 0) {
      gramPanchayat = await GramPanchayatDataHelper()
          .getGramPanchayatListByPanchayatId(panchayatIdList);
    } else
      gramPanchayat = await GramPanchayatDataHelper().getTabGramPanchayatList();

    if (villageIdList.isNotEmpty && villageIdList.length > 0) {
      villages =
          await VillageDataHelper().getVillageListByVillageId(villageIdList);
    } else
      villages = await VillageDataHelper().getTabVillageList();

    mstStates = Global.callSatates(states, lng!);

    if (mstStates.length == 1) {
      selectedState = mstStates.first;
      mstDistrict = Global.callDistrict(district, lng!, selectedState);
    }
    if (mstDistrict.length == 1) {
      selectedDistrict = mstDistrict.first;
      mstBlock = Global.callBlocks(block, lng!, selectedDistrict);
    }
    if (mstBlock.length == 1) {
      selectedBlock = mstBlock.first;
      mstGP = Global.callGramPanchyats(gramPanchayat, lng!, selectedBlock);
    }
    if (mstGP.length == 1) {
      selectedGramPanchayat = mstGP.first;
      mstVillage =
          Global.callFiltersVillages(villages, lng!, selectedGramPanchayat);
    }

    setState(() {});
  }

  Future<List<int>> _fetchSpecificElement(
      List<HouseHoldTabResponceMosdel> hhDataList, String key) async {
    List<int> _specificElementList = [];
    // Parse the JSON data
    for (int i = 0; i < hhDataList.length; i++) {
      String response = hhDataList[i].responces!;
      Map<String, dynamic> parsedJson = json.decode(response);

      // Extract the specific element
      int itemName = int.parse(parsedJson[key]);
      if (!_specificElementList.contains(itemName)) {
        _specificElementList.add(itemName);
      }
        }
    return _specificElementList;
  }

  String callVillageName(String crecheItem) {
    String returnValue = '';
    var items = villagesItemms
        .where((element) =>
            element.name.toString() ==
            Global.getItemValues(crecheItem, 'village_id'))
        .toList();
    if (items.length > 0) {
      returnValue = items[0].value!;
    }
    return returnValue;
  }

  void _showConsentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
              title: Center(
                child: Text(
                  Global.returnTrLable(
                      hhlistingControlls, CustomText.PrivacyPolicy, lng!),
                  style: Styles.black3125,
                ),
              ),
              content: Text(
                Global.returnTrLable(hhlistingControlls,
                    CustomText.PrivacyPolicyDescription, lng!),
                textAlign: TextAlign.justify,
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Space buttons evenly
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        Global.returnTrLable(
                            hhlistingControlls, CustomText.Cancel, lng!),
                        style: Styles.red125,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0), // Adjust padding as needed
                        backgroundColor: Color(0xff369A8D), // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Round corners
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        String hhGuid = '';
                        if (!Global.validString(hhGuid)) {
                          hhGuid = Validate().randomGuid();
                          String? minDate;
                          if(Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0){
                            minDate=await Validate().requredOnlyMinimum(null, backdatedConfigirationModel!.back_dated_data_entry_allowed!);
                          }
                          print("line $hhGuid");
                          var refStatus = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => HHTabScreen(
                                  hhGuid: hhGuid, crecheId: widget.crecheId,minDate: minDate),
                            ),
                          );
                          if (refStatus == 'itemRefresh') {
                            await fetchHhDataList();
                          }
                        }
                      },
                      child: Text(
                        Global.returnTrLable(
                            hhlistingControlls, CustomText.IAgree, lng!),
                        style: Styles.white125,
                      ),
                    ),
                  ],
                )
              ]),
        );
      },
    );
  }
  bool crechedCloseDate() {
    DateTime? closingDate = Global.stringToDate(crecheClosingDate);
    if (closingDate != null) {
      return closingDate.isAfter(DateTime.now()) ||
          closingDate.isAtSameMomentAs(DateTime.now());
    } else
      return true;
  }

  bool crechedOpeningDate() {
    DateTime? openningDate = Global.stringToDate(crecheOpeningDate);
    if (openningDate != null) {
      return DateTime.now().isAfter(openningDate) ||
          openningDate.isAtSameMomentAs(DateTime.now());
    } else return false;
  }
}
