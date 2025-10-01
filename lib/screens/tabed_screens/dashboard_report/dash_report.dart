import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../custom_widget/custom_appbar.dart';
import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
import '../../../database/helper/block_data_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/district_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/gram_panchayat_data_helper.dart';
import '../../../database/helper/state_data_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../database/helper/village_data_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_growth_responce_model.dart';
import '../../../model/databasemodel/tabBlock_model.dart';
import '../../../model/databasemodel/tabDistrict_model.dart';
import '../../../model/databasemodel/tabGramPanchayat_model.dart';
import '../../../model/databasemodel/tabVillage_model.dart';
import '../../../model/databasemodel/tabstate_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../../dashboard_report_card_details.dart';
import 'dash_report_card_details.dart';
import 'dashboard_report_helper.dart';

class DashReport extends StatefulWidget {
  DashReport({
    super.key,
  });

  @override
  _DashReportState createState() => _DashReportState();
}

class _DashReportState extends State<DashReport> {
  Map<String, dynamic> cardItems = {};
  List<OptionsModel> years = [];
  List<OptionsModel> months = [];
  List<Translation> translats = [];
  String lng = 'en';
  OptionsModel? selectedMonth;
  String selectedYear = '${DateTime.now().year}';
  String? role;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // bool apiIsCall=false;

  OptionsModel? selectedState;
  OptionsModel? selectedDistrict;
  OptionsModel? selectedBlock;
  OptionsModel? selectedGramPanchayat;

  // OptionsModel? selectedVillage;
  OptionsModel? selectedCreche;
  OptionsModel? selectedCrecheStatus;
  OptionsModel? selectedPartner;
  OptionsModel? selectedPhase;

  OptionsModel? tempSelectedState;
  OptionsModel? tempSelectedDistrict;
  OptionsModel? tempSelectedBlock;
  OptionsModel? tempSelectedGramPanchayat;

  // OptionsModel? tempSelectedVillage;
  OptionsModel? tempSelectedCreche;
  OptionsModel? tempSelectedCrecheStatus;
  OptionsModel? tempSelectedPartner;
  OptionsModel? tempSelectedPhase;

  List<OptionsModel> mstStates = [];
  List<OptionsModel> mstDistrict = [];
  List<OptionsModel> mstBlock = [];
  List<OptionsModel> mstGP = [];
  List<OptionsModel> mstVillage = [];
  List<OptionsModel> mstcreches = [];
  List<OptionsModel> crecheStatus = [];
  List<OptionsModel> parterns = [];
  List<OptionsModel> phases = [];

  List<TabState> states = [];
  List<TabDistrict> district = [];
  List<TabBlock> block = [];
  List<TabGramPanchayat> gramPanchayat = [];
  List<TabVillage> villages = [];
  List<CresheDatabaseResponceModel> creches = [];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _crecheSearchcontroller = TextEditingController();
  List<ChildGrowthMetaResponseModel> allAntroData = [];

  bool isCrecheCount = true;
  bool isCurrentActiveChildren = true;
  bool isChildrenEnrolledThisMonth = true;
  bool isChildrenExitThisMonth = true;
  bool isNoOfCrechesNotSubmittedAttendance = true;
  bool isNoOfCrechesSubmittedAttendance = true;
  bool isMaximumAttendanceADay = true;
  bool isCurrentEligibleChildren = true;
  bool isCumulativeEnrolledChildren = true;
  bool isCumulativeExitedChildren = true;
  bool isAvgNoOfDaysCrecheOpened = true;
  bool isAvgAttendancePerDay = true;
  bool isAvgNofDaysAttendanceSubmitted = true;
  bool isAnthroDataSubmitted = true;
  bool isAnthroDataNotSubmitted = true;
  bool isChildrenMeasurementTaken = true;
  bool isChildrenMeasurementNotTaken = true;
  bool isModeratelyUnderweight = true;
  bool isModeratelyWasted = true;
  bool isModeratelyStunted = true;
  bool isSeverelyUnderweight = true;
  bool isSeverelyStunted = true;
  bool isSeverelyWasted = true;
  bool isGf1 = true;
  bool isGf2 = true;
  bool isRedFlagChildren = true;

  final excludedKeys = [
    'AvgAttendancePerDay',
    'AvgNoOfDaysCrecheOpened',
    'AvgNoDaysAttendanceSubmitted',
    'MaximumAttendanceInDay',
    'CumulativeExitChildren',
    'CumulativeEnrolledChildren',
  ];

  @override
  void initState() {
    super.initState();

    initializeData();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Scroll to the bottom to make sure autocomplete is visible
        Future.delayed(Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose(); // Clean up controller
    _crecheSearchcontroller.dispose();
    super.dispose();
  }

  Future<void> initializeData() async {

    role = (await Validate().readString(Validate.role))!;
    years = getYearList(2000);
    months = getMonthList(Global.stringToInt(years.first.name));
    var crrentMonth = DateTime.now().month;
    selectedMonth = months[crrentMonth - 1];
    showLoaderDialog(context);
    allAntroData = await ChildGrowthResponseHelper().allAnthormentry();

    await fetchStateList();
    translats.clear();
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }

    List<String> valueItems = [
      CustomText.DashBoardReport,
      CustomText.NorecordAvailable,
      CustomText.pleaseSelectMonth,
      CustomText.pleaseWait,
      CustomText.clear,
      CustomText.Cancel,
      CustomText.Month,
      CustomText.Year,
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
      CustomText.select_here,
      CustomText.crecheNotAvailable,
      CustomText.childInfoNotAvailable,
      CustomText.Creches,
      CustomText.state,
      CustomText.District,
      CustomText.Block,
      CustomText.GramPanchayat,
      CustomText.Village,
      CustomText.CrecheStatus,
      CustomText.Partner,
      CustomText.Phase,
      CustomText.NoOfCreches,
      CustomText.loading,
      CustomText.NoOfCrechesSubmittedAttendance,
      CustomText.NoOfCrechesNotSubmittedAttendance,
      CustomText.CurrentActiveChildren,
      CustomText.CumulativeEnrolledChildren,
      CustomText.CumulativeExitChildren,
      CustomText.CurrentEligibleChildren,
      CustomText.ChildrenEnrolledThisMonth,
      CustomText.ChildrenExitedThisMonth,
      CustomText.RedFlagChildren,
      CustomText.AvgNoOfDaysCrecheOpened,
      CustomText.AvgAttendancePerDay,
      CustomText.AvgNoDaysAttendanceSubmitted,
      CustomText.MaximumAttendanceInDay,
      CustomText.AnthroDataSubmitted,
      CustomText.AnthroDataNotSubmitted,
      CustomText.ChildrenMeasurementTaken,
      CustomText.ChildrenMeasurementNotTaken,
      CustomText.ModeratelyUnderweight,
      CustomText.SeverelyUnderweight,
      CustomText.ModeratelyWasted,
      CustomText.SeverelyWasted,
      CustomText.ModeratelyStunted,
      CustomText.SeverelyStunted,
      CustomText.Growthfaltering1,
      CustomText.Growthfaltering2,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    initItems();
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
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          appBar: CustomAppbar(
            text: Global.returnTrLable(
                translats, CustomText.DashBoardReport, lng),
            onTap: () {
              Navigator.pop(context, 'itemRefresh');
            },
          ),
          endDrawer: Drawer(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(),
            ),
            child: SafeArea(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/filter_icon.png",
                            scale: 2.4,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            Global.returnTrLable(
                                translats, CustomText.Filter, lng),
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
                    SizedBox(),
                    Expanded(
                        child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: BouncingScrollPhysics(),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  parterns.length > 0
                                      ? DynamicCustomDropdownField(
                                          hintText: Global.returnTrLable(
                                              translats,
                                              CustomText.Selecthere,
                                              lng),
                                          titleText: Global.returnTrLable(
                                              translats,
                                              CustomText.Partner,
                                              lng),
                                          isRequred: 0,
                                          items: parterns,
                                          selectedItem: selectedPartner != null
                                              ? selectedPartner?.name
                                              : null,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedPartner = value;
                                            });
                                          },
                                        )
                                      : SizedBox(),
                                  DynamicCustomDropdownField(
                                    hintText: Global.returnTrLable(
                                        translats, CustomText.select_here, lng),
                                    titleText: Global.returnTrLable(
                                        translats, CustomText.state, lng),
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
                                      // selectedVillage = null;
                                      selectedCreche = null;
                                      _crecheSearchcontroller.text = '';

                                      mstDistrict = Global.callDistrict(
                                          district, lng, selectedState);
                                      if (mstDistrict.length == 1) {
                                        selectedDistrict = mstDistrict.first;
                                        mstBlock = Global.callBlocks(
                                            block, lng, selectedDistrict);
                                        mstcreches =
                                            Global.callFiltersCrechesByDistric(
                                                creches, lng, selectedDistrict);
                                        if (mstcreches.length == 1) {
                                          selectedCreche = mstcreches.first;
                                        }
                                        if (mstBlock.length == 1) {
                                          selectedBlock = mstBlock.first;
                                          mstGP = Global.callGramPanchyats(
                                              gramPanchayat,
                                              lng,
                                              selectedBlock);
                                          mstcreches =
                                              Global.callFiltersCrechesByBlock(
                                                  creches, lng, selectedBlock);
                                          if (mstcreches.length == 1) {
                                            selectedCreche = mstcreches.first;
                                          }
                                          if (mstGP.length == 1) {
                                            selectedGramPanchayat = mstGP.first;
                                            mstcreches =
                                                Global.callFiltersCrechesByGP(
                                                    creches,
                                                    lng,
                                                    selectedGramPanchayat);
                                            if (mstcreches.length == 1) {
                                              selectedCreche = mstcreches.first;
                                            }
                                          }
                                        }
                                      } else {
                                        mstBlock = [];
                                        mstGP = [];
                                        mstVillage = [];
                                        mstcreches =
                                            Global.callFiltersCrechesByState(
                                                creches, lng, selectedState);
                                        if (mstcreches.length == 1) {
                                          selectedCreche = mstcreches.first;
                                        }
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  DynamicCustomDropdownField(
                                    hintText: Global.returnTrLable(
                                        translats, CustomText.select_here, lng),
                                    titleText: Global.returnTrLable(
                                        translats, CustomText.District, lng),
                                    items: mstDistrict,
                                    isRequred: 0,
                                    selectedItem: selectedDistrict != null
                                        ? selectedDistrict?.name
                                        : null,
                                    onChanged: (value) async {
                                      selectedDistrict = value;
                                      selectedBlock = null;
                                      selectedGramPanchayat = null;
                                      // selectedVillage = null;
                                      selectedCreche = null;
                                      _crecheSearchcontroller.text = '';
                                      mstBlock = Global.callBlocks(
                                          block, lng, selectedDistrict);
                                      if (mstBlock.length == 1) {
                                        selectedBlock = mstBlock.first;
                                        mstGP = Global.callGramPanchyats(
                                            gramPanchayat, lng, selectedBlock);
                                        mstcreches =
                                            Global.callFiltersCrechesByBlock(
                                                creches, lng, selectedBlock);
                                        if (mstcreches.length == 1) {
                                          selectedCreche = mstcreches.first;
                                        }
                                        if (mstGP.length == 1) {
                                          selectedGramPanchayat = mstGP.first;
                                          // mstVillage =
                                          //     Global.callFiltersVillages(
                                          //         villages, lng,
                                          //         selectedGramPanchayat);

                                          // if (mstVillage.length == 1) {
                                          //   selectedVillage =
                                          //       mstVillage.first;
                                          //   mstcreches =
                                          //       Global.callFiltersCreches(
                                          //           creches, lng,
                                          //           selectedVillage);
                                          // }
                                          mstcreches =
                                              Global.callFiltersCrechesByGP(
                                                  creches,
                                                  lng,
                                                  selectedGramPanchayat);
                                          if (mstcreches.length == 1) {
                                            selectedCreche = mstcreches.first;
                                          }
                                        }
                                      } else {
                                        mstGP = [];
                                        mstVillage = [];
                                        mstcreches =
                                            Global.callFiltersCrechesByDistric(
                                                creches, lng, selectedDistrict);
                                        if (mstcreches.length == 1) {
                                          selectedCreche = mstcreches.first;
                                        }
                                      }
                                      setState(() {
                                        // Update blockList based on selectedDistrict
                                        // blockList = // data from database based on selectedDistrict;
                                      });
                                    },
                                  ),
                                  DynamicCustomDropdownField(
                                    hintText: Global.returnTrLable(
                                        translats, CustomText.select_here, lng),
                                    titleText: Global.returnTrLable(
                                        translats, CustomText.Block, lng),
                                    items: mstBlock,
                                    isRequred: 0,
                                    selectedItem: selectedBlock != null
                                        ? selectedBlock?.name
                                        : null,
                                    onChanged: (value) async {
                                      selectedBlock = value;
                                      selectedGramPanchayat = null;
                                      // selectedVillage = null;
                                      selectedCreche = null;
                                      _crecheSearchcontroller.text = '';
                                      mstGP = Global.callGramPanchyats(
                                          gramPanchayat, lng, selectedBlock);
                                      if (mstGP.length == 1) {
                                        selectedGramPanchayat = mstGP.first;
                                        mstcreches =
                                            Global.callFiltersCrechesByGP(
                                                creches,
                                                lng,
                                                selectedGramPanchayat);
                                        if (mstcreches.length == 1) {
                                          selectedCreche = mstcreches.first;
                                        }
                                        // mstVillage =
                                        //     Global.callFiltersVillages(
                                        //         villages, lng,
                                        //         selectedGramPanchayat);
                                        // if (mstVillage.length == 1) {
                                        //   selectedVillage =
                                        //       mstVillage.first;
                                        //   // mstcreches = Global.callFiltersCreches(
                                        //   //     creches, lng, selectedVillage);
                                        // }
                                      } else {
                                        mstVillage = [];
                                        mstcreches =
                                            Global.callFiltersCrechesByBlock(
                                                creches, lng, selectedBlock);
                                        if (mstcreches.length == 1) {
                                          selectedCreche = mstcreches.first;
                                        }
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  DynamicCustomDropdownField(
                                    isRequred: 0,
                                    titleText: Global.returnTrLable(translats,
                                        CustomText.GramPanchayat, lng),
                                    items: mstGP,
                                    hintText: Global.returnTrLable(
                                        translats, CustomText.Selecthere, lng),
                                    selectedItem: selectedGramPanchayat != null
                                        ? selectedGramPanchayat?.name
                                        : null,
                                    onChanged: (value) async {
                                      selectedGramPanchayat = value;
                                      // selectedVillage = null;
                                      selectedCreche = null;
                                      _crecheSearchcontroller.text = '';
                                      mstVillage = Global.callFiltersVillages(
                                          villages, lng, selectedGramPanchayat);
                                      mstcreches =
                                          Global.callFiltersCrechesByGP(creches,
                                              lng, selectedGramPanchayat);
                                      if (mstcreches.length == 1) {
                                        selectedCreche = mstcreches.first;
                                      }
                                      if (mstVillage.length == 1) {
                                        // selectedVillage = mstVillage.first;
                                        // if (mstVillage.length == 1) {
                                        //   selectedVillage =
                                        //       mstVillage.first;
                                        //   mstcreches =
                                        //       Global.callFiltersCreches(
                                        //           creches, lng,
                                        //           selectedVillage);
                                        // }
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  // DynamicCustomDropdownField(
                                  //   hintText: Global.returnTrLable(
                                  //       translats, CustomText.Selecthere,
                                  //       lng),
                                  //   titleText: Global.returnTrLable(
                                  //       translats, CustomText.Village, lng),
                                  //   isRequred: 0,
                                  //   items: mstVillage,
                                  //   selectedItem: selectedVillage != null
                                  //       ? selectedVillage?.name
                                  //       : null,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       selectedVillage = value;
                                  //       selectedCreche = null;
                                  //       mstcreches =
                                  //           Global.callFiltersCreches(
                                  //               creches, lng,
                                  //               selectedVillage);
                                  //       if (mstcreches.length == 1) {
                                  //         selectedCreche = mstcreches.first;
                                  //       }
                                  //     });
                                  //   },
                                  // ),
                                  // DynamicCustomDropdownField(
                                  //   hintText: Global.returnTrLable(
                                  //       translats, CustomText.Selecthere,
                                  //       lng),
                                  //   titleText: Global.returnTrLable(
                                  //       translats, CustomText.Creches, lng),
                                  //   isRequred: 0,
                                  //   items: mstcreches,
                                  //   selectedItem: selectedCreche != null
                                  //       ? selectedCreche?.name
                                  //       : null,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       selectedCreche = value;
                                  //     });
                                  //   },
                                  // ),
                                  creches.length <= 1
                                      ? DynamicCustomDropdownField(
                                          hintText: Global.returnTrLable(
                                              translats,
                                              CustomText.Creches,
                                              lng),
                                          titleText: Global.returnTrLable(
                                              translats,
                                              CustomText.Creches,
                                              lng),
                                          isRequred: 0,
                                          items: mstcreches,
                                          selectedItem: selectedCreche != null
                                              ? selectedCreche?.name
                                              : null,
                                          onChanged: (value) {
                                            selectedCreche = value;
                                          },
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Global.returnTrLable(translats,
                                                  CustomText.Creches, lng),
                                              style: Styles.black124,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Color(0xffACACAC)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child:
                                                  TypeAheadField<OptionsModel>(
                                                controller:
                                                    _crecheSearchcontroller,
                                                scrollController:
                                                    _scrollController,
                                                suggestionsCallback:
                                                    (pattern) async {
                                                  try {
                                                    var filItems = mstcreches
                                                        .where((element) =>
                                                            element.values !=
                                                                    null &&
                                                                element.name !=
                                                                    null &&
                                                                element.values!
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        pattern
                                                                            .toLowerCase()) ||
                                                            element.name!
                                                                .toLowerCase()
                                                                .contains(pattern
                                                                    .toLowerCase()))
                                                        .toList();
                                                    if (filItems.isEmpty ||
                                                        pattern.isEmpty) {
                                                      selectedCreche = null;
                                                      tempSelectedCreche = null;
                                                      _crecheSearchcontroller
                                                          .text = '';
                                                    }
                                                    return filItems;
                                                  } catch (e) {
                                                    debugPrint(
                                                        'TypeAhead error: $e');
                                                    return [];
                                                  }
                                                },
                                                builder: (context, controller,
                                                    focusNode) {
                                                  return TextField(
                                                      controller: controller,
                                                      focusNode: focusNode,
                                                      style: Styles.black124,
                                                      // autofocus: true,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: Global
                                                            .returnTrLable(
                                                                translats,
                                                                CustomText
                                                                    .Search,
                                                                lng),
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        border:
                                                            InputBorder.none,
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .transparent),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .transparent),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .transparent),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ));
                                                },
                                                itemBuilder: (context, item) {
                                                  return ListTile(
                                                    title: Text(item.values!),
                                                    subtitle: Text(item.name!),
                                                  );
                                                },
                                                onSelected: (item) {
                                                  selectedCreche = item;
                                                  _crecheSearchcontroller.text =
                                                      item.values ?? '';
                                                  print('itm $item');
                                                },
                                                offset: Offset(0, 12),
                                                constraints: BoxConstraints(
                                                    maxHeight: 500),
                                                hideOnUnfocus: true,
                                                showOnFocus: true,
                                                hideWithKeyboard: false,
                                                loadingBuilder: (context) =>
                                                    const Text('Loading...'),
                                                errorBuilder:
                                                    (context, error) =>
                                                        const Text('Error!'),
                                                emptyBuilder: (context) =>
                                                    const Text(
                                                        'No items found!'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                  DynamicCustomDropdownField(
                                    hintText: Global.returnTrLable(
                                        translats, CustomText.Selecthere, lng),
                                    titleText: Global.returnTrLable(translats,
                                        CustomText.CrecheStatus, lng),
                                    isRequred: 0,
                                    items: crecheStatus,
                                    selectedItem: selectedCrecheStatus != null
                                        ? selectedCrecheStatus?.name
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCrecheStatus = value;
                                      });
                                    },
                                  ),
                                  DynamicCustomDropdownField(
                                    hintText: Global.returnTrLable(
                                        translats, CustomText.Selecthere, lng),
                                    titleText: Global.returnTrLable(
                                        translats, CustomText.Phase, lng),
                                    isRequred: 0,
                                    items: phases,
                                    selectedItem: selectedPhase != null
                                        ? selectedPhase?.name
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPhase = value;
                                      });
                                    },
                                  ),
                                ]))),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: CElevatedButton(
                              text:
                                  Global.returnTrLable(translats, 'Clear', lng),
                              color: Color(0xffF26BA3),
                              onPressed: () {
                                Navigator.of(context).pop();
                                cleaAllFilter();
                              },
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: CElevatedButton(
                              text: Global.returnTrLable(
                                  translats, 'Search', lng),
                              onPressed: () {
                                tempSelectedState = selectedState;
                                tempSelectedDistrict = selectedDistrict;
                                tempSelectedBlock = selectedBlock;
                                tempSelectedGramPanchayat =
                                    selectedGramPanchayat;
                                tempSelectedCreche = selectedCreche;
                                tempSelectedCrecheStatus = selectedCrecheStatus;
                                tempSelectedPartner = selectedPartner;
                                tempSelectedPhase = selectedPhase;
                                Navigator.of(context).pop();
                                callRunProgressTrue();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ]),
            )),
          ),
          body: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child:
                  // apiIsCall?
                  Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DynamicCustomDropdownField(
                        hintText: Global.returnTrLable(
                            translats, CustomText.Year, lng),
                        items: getYearList(2020),
                        selectedItem: selectedYear,
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value!.name!;
                            months =
                                getMonthList(Global.stringToInt(selectedYear));
                            selectedMonth = null;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: DynamicCustomDropdownField(
                        hintText: Global.returnTrLable(
                            translats, CustomText.Month, lng),
                        items: months,
                        selectedItem: selectedMonth?.name,
                        onChanged: (value) {
                          selectedMonth = value;
                          callRunProgressTrue();
                        },
                      ),
                    ),
                    GestureDetector(
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
                  height: 10,
                ),
                Expanded(
                  child: (cardItems.isNotEmpty)
                      ? GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: cardItems.keys.toList().length,
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing:
                                15, // Vertical spacing (Add this line)
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return cardItem(
                                cardItems[cardItems.keys.toList()[index]],
                                cardItems.keys.toList()[index]);
                          },
                        )
                      : Center(
                          child: Text(Global.returnTrLable(
                              translats, CustomText.NorecordAvailable, lng)),
                        ),
                ),
              ])),
        ),
      ),
    );
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

  List<OptionsModel> getYearList(int startYear) {
    int currentYear = DateTime.now().year;
    // return List.generate((currentYear - startYear) + 1, (index) => startYear + index);
    var years = List.generate(
      (currentYear - startYear) + 1,
      (index) => OptionsModel(
        name: (startYear + index).toString(), // Convert index to string
        values: (startYear + index).toString(), // Year value
        flag: null, // Set flag to null
      ),
    ).reversed.toList();

    return years;
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
                SizedBox(height: 10),
                Text(Global.returnTrLable(translats, CustomText.loading, lng)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchStateList() async {
    states = await StateDataHelper().getTabStateList();
    district = await DistrictDataHelper().getTabDistrictList();
    block = await BlockDataHelper().getTabBlockList();
    gramPanchayat = await GramPanchayatDataHelper().getTabGramPanchayatList();
    villages = await VillageDataHelper().getTabVillageList();
    mstStates = Global.callSatates(states, lng);
    creches = await CrecheDataHelper().getCrecheResponce();
    phases =
        await OptionsModelHelper().callDayOfWeekMstCommonOptions('Phase', lng);
    crecheStatus =
        await OptionsModelHelper().getMstCommonOptions('Creche Status', lng);
    parterns =
        await OptionsModelHelper().getPartnerMstCommonOptions('Partner', {});
    if (parterns.isEmpty) {
      parterns = await OptionsModelHelper().getMstCommonOptions('Partner', lng);
    }
    mstcreches = await OptionsModelHelper().callCrechInOptionAll('Creche');

    if (mstStates.length == 1) {
      selectedState = mstStates.first;
      tempSelectedState = mstStates.first;
      mstDistrict = Global.callDistrict(district, lng, selectedState);
      mstcreches =
          Global.callFiltersCrechesByState(creches, lng, selectedState);
    }
    if (mstDistrict.length == 1) {
      selectedDistrict = mstDistrict.first;
      tempSelectedDistrict = mstDistrict.first;
      mstBlock = Global.callBlocks(block, lng, selectedDistrict);
      mstcreches =
          Global.callFiltersCrechesByDistric(creches, lng, selectedDistrict);
    }
    if (mstBlock.length == 1) {
      selectedBlock = mstBlock.first;
      tempSelectedBlock = mstBlock.first;
      mstGP = Global.callGramPanchyats(gramPanchayat, lng, selectedBlock);
      mstcreches =
          Global.callFiltersCrechesByBlock(creches, lng, selectedBlock);
    }
    if (mstGP.length == 1) {
      selectedGramPanchayat = mstGP.first;
      tempSelectedGramPanchayat = mstGP.first;
      mstVillage =
          Global.callFiltersVillages(villages, lng, selectedGramPanchayat);
      mstcreches =
          Global.callFiltersCrechesByGP(creches, lng, selectedGramPanchayat);
    }

    if (mstcreches.length == 1) {
      selectedCreche = mstcreches.first;
      tempSelectedCreche = mstcreches.first;
    }
    if (parterns.length == 1) {
      selectedPartner = parterns.first;
      tempSelectedPartner = parterns.first;
    }
    if (crecheStatus.length == 1) {
      selectedCrecheStatus = crecheStatus.first;
      tempSelectedCrecheStatus = crecheStatus.first;
    } else if (crecheStatus.length > 1) {
      var items = crecheStatus
          .where((element) => element.name == 3.toString())
          .toList();
      if (items.isNotEmpty) {
        selectedCrecheStatus = items.first;
        tempSelectedCrecheStatus = items.first;
      }
    }

    setState(() {});
  }

  void cleaAllFilter() async {
    selectedState = null;
    selectedDistrict = null;
    selectedBlock = null;
    selectedGramPanchayat = null;
    // selectedVillage = null;
    selectedCreche = null;
    selectedCrecheStatus = null;
    selectedPartner = null;
    selectedPhase = null;

    tempSelectedState = null;
    tempSelectedDistrict = null;
    tempSelectedBlock = null;
    tempSelectedGramPanchayat = null;
    // tempSelectedVillage = null;
    tempSelectedCreche = null;
    tempSelectedCrecheStatus = null;
    tempSelectedPartner = null;
    tempSelectedPhase = null;
    _crecheSearchcontroller.text = '';

    mstStates = [];
    mstDistrict = [];
    mstBlock = [];
    mstGP = [];
    mstVillage = [];
    mstcreches = [];
    crecheStatus = [];
    parterns = [];
    phases = [];
    await fetchStateList();
    callRunProgressTrue();
  }

  initItems() {
    cardItems['NoOfCreches'] = {
      'title': Global.returnTrLable(translats, CustomText.NoOfCreches, lng),
      'subtitle': '',
      'count': 0
    };

    cardItems['NoOfCrechesSubmittedAttendance'] = {
      'title': Global.returnTrLable(
          translats, CustomText.NoOfCrechesSubmittedAttendance, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['NoOfCrechesNotSubmittedAttendance'] = {
      'title': Global.returnTrLable(
          translats, CustomText.NoOfCrechesNotSubmittedAttendance, lng),
      'subtitle': '',
      'count': 0,
    };

    //child card
    cardItems['CurrentActiveChildren'] = {
      'title': Global.returnTrLable(
          translats, CustomText.CurrentActiveChildren, lng),
      // 'subtitle': Global.returnTrLable(
      //     translats, CustomText.SubCurrentActiveChildren, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['CumulativeEnrolledChildren'] = {
      'title': Global.returnTrLable(
          translats, CustomText.CumulativeEnrolledChildren, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['CumulativeExitChildren'] = {
      'title': Global.returnTrLable(
          translats, CustomText.CumulativeExitChildren, lng),
      // 'subtitle': Global.returnTrLable(
      //     translats, CustomText.SubCumulativeExitChildren, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['CurrentEligibleChildren'] = {
      'title': Global.returnTrLable(
          translats, CustomText.CurrentEligibleChildren, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['ChildrenEnrolledThisMonth'] = {
      'title': Global.returnTrLable(
          translats, CustomText.ChildrenEnrolledThisMonth, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['ChildrenExitedThisMonth'] = {
      'title': Global.returnTrLable(
          translats, CustomText.ChildrenExitedThisMonth, lng),
      // 'subtitle': Global.returnTrLable(
      //     translats, CustomText.SubChildrenExitedThisMonth, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['RedFlagChildren'] = {
      'title': Global.returnTrLable(translats, CustomText.RedFlagChildren, lng),
      // 'subtitle':
      //     Global.returnTrLable(translats, CustomText.SubRedFlagChildren, lng),
      'subtitle': '',
      'count': 0,
    };

    ///avg card

    cardItems['AvgNoOfDaysCrecheOpened'] = {
      'title': Global.returnTrLable(
          translats, CustomText.AvgNoOfDaysCrecheOpened, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['AvgAttendancePerDay'] = {
      'title':
          Global.returnTrLable(translats, CustomText.AvgAttendancePerDay, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['AvgNoDaysAttendanceSubmitted'] = {
      'title': Global.returnTrLable(
          translats, CustomText.AvgNoDaysAttendanceSubmitted, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['MaximumAttendanceInDay'] = {
      'title': Global.returnTrLable(
          translats, CustomText.MaximumAttendanceInDay, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['AnthroDataSubmitted'] = {
      'title':
          Global.returnTrLable(translats, CustomText.AnthroDataSubmitted, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['AnthroDataNotSubmitted'] = {
      'title': Global.returnTrLable(
          translats, CustomText.AnthroDataNotSubmitted, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['ChildrenMeasurementTaken'] = {
      'title': Global.returnTrLable(
          translats, CustomText.ChildrenMeasurementTaken, lng),
      // 'subtitle': Global.returnTrLable(
      //     translats, CustomText.SubChildrenMeasurementTaken, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['ChildrenMeasurementNotTaken'] = {
      'title': Global.returnTrLable(
          translats, CustomText.ChildrenMeasurementNotTaken, lng),
      'subtitle': '',
      'count': 0,
    };

    ///anthro card

    cardItems['ModeratelyUnderweight'] = {
      'title': Global.returnTrLable(
          translats, CustomText.ModeratelyUnderweight, lng),
      // 'subtitle': Global.returnTrLable(
      //     translats, CustomText.SubModeratelyUnderweight, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['SeverelyUnderweight'] = {
      'title':
          Global.returnTrLable(translats, CustomText.SeverelyUnderweight, lng),
      // 'subtitle': Global.returnTrLable(
      //     translats, CustomText.SubSeverelyUnderweight, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['ModeratelyWasted'] = {
      'title':
          Global.returnTrLable(translats, CustomText.ModeratelyWasted, lng),
      // 'subtitle':
      //     Global.returnTrLable(translats, CustomText.SubModeratelyWasted, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['SeverelyWasted'] = {
      'title': Global.returnTrLable(translats, CustomText.SeverelyWasted, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['ModeratelyStunted'] = {
      'title':
          Global.returnTrLable(translats, CustomText.ModeratelyStunted, lng),
      // 'subtitle':
      //     Global.returnTrLable(translats, CustomText.SubModeratelyStunted, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['SeverelyStunted'] = {
      'title': Global.returnTrLable(translats, CustomText.SeverelyStunted, lng),
      // 'subtitle':
      //     Global.returnTrLable(translats, CustomText.SubSeverelyStunted, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['Growthfaltering1'] = {
      'title':
          Global.returnTrLable(translats, CustomText.Growthfaltering1, lng),
      // 'subtitle':
      //     Global.returnTrLable(translats, CustomText.SubGrowthfaltering1, lng),
      'subtitle': '',
      'count': 0,
    };

    cardItems['Growthfaltering2'] = {
      'title':
          Global.returnTrLable(translats, CustomText.Growthfaltering2, lng),
      // 'subtitle':
      //     Global.returnTrLable(translats, CustomText.SubGrowthfaltering2, lng),
      'subtitle': '',
      'count': 0,
    };
    setState(() {});
    multipleAsyncCalls();

  }

  Widget cardItem(Map<String, dynamic> item, String key) {
    return InkWell(
      onTap: () async {
        if (!excludedKeys.contains(key)) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => DashReportCardDetailScreen(
                    title: item['title'],
                    query_type: key,
                    month: selectedMonth!,
                    year: selectedYear,
                    selectedState: tempSelectedState,
                    selectedDistrict: tempSelectedDistrict,
                    selectedBlock: tempSelectedBlock,
                    selectedGramPanchayat: tempSelectedGramPanchayat,
                    // selectedVillage:
                    // tempSelectedVillage,
                    selectedCreche: tempSelectedCreche,
                    selectedCrecheStatus: tempSelectedCrecheStatus,
                    selectedPartner: tempSelectedPartner,
                    selectedPhase: tempSelectedPhase,
                  )));
        }
      },
      child: Container(
        width: double.infinity, // Takes full width of grid cell
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xff5A5A5A).withOpacity(0.2),
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
          color: Global.getCardColor(key),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Global.getCardBorderColor(key)),
        ),
        child: AspectRatio(
          aspectRatio: 1, // Keeps it square, change as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // item['isProgress'] == false
              //     ? Text(
              //         item['count'].toString(),
              //         style: Styles.blue148,
              //       )
              //     : CircularProgressIndicator(),
              Text(
                item['count'].toString(),
                style: Styles.blue148,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(item['title'],
                      textAlign: TextAlign.center, style: Styles.red145)),
              Global.validString(item['subtitle'].toString())
                  ? Text(item['subtitle'],
                      textAlign: TextAlign.center, style: Styles.red125)
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Future dataExecution() async {
    showLoaderDialog(context);
    String? stateId;
    String? districtId;
    String? blockId;
    String? gpId;
    String? villageId;
    String? crecheId;
    String? phase;
    String? partnerId;
    String? crecheStatus;

    if (tempSelectedState != null) {
      stateId = tempSelectedState?.name;
    }

    if (tempSelectedDistrict != null) {
      districtId = tempSelectedDistrict?.name;
    }

    if (tempSelectedBlock != null) {
      blockId = tempSelectedBlock?.name;
    }

    if (tempSelectedGramPanchayat != null) {
      gpId = tempSelectedGramPanchayat?.name;
    }

    if (tempSelectedCreche != null) {
      crecheId = tempSelectedCreche?.name;
    }

    if (tempSelectedCrecheStatus != null) {
      crecheStatus = tempSelectedCrecheStatus?.name;
    }

    if (tempSelectedPartner != null) {
      partnerId = tempSelectedPartner?.name;
    }

    if (tempSelectedPhase != null) {
      phase = tempSelectedPhase?.name;
    }

    ///Number of creche
    var crecheCount = await DashboardReportHelper().excuteCrecheCount(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: Global.getDateByMonthYear(Global.stringToInt(selectedYear),
            Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('NoOfCreches')) {
      cardItems['NoOfCreches'] = {
        'title': Global.returnTrLable(translats, CustomText.NoOfCreches, lng),
        'subtitle': '',
        'count': crecheCount.length
      };
    }

    ///Current active children
    var currentActiveChildren = await DashboardReportHelper()
        .excuteCurrentActiveChildren(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('CurrentActiveChildren')) {
      cardItems['CurrentActiveChildren'] = {
        'title': Global.returnTrLable(
            translats, CustomText.CurrentActiveChildren, lng),
        'subtitle': '',
        'count': currentActiveChildren.length
      };
      setState(() {});
    }

    /// Children Enrolled This Month
    var childrenEnrolledThisMonth = await DashboardReportHelper()
        .excuteEnrolldCildThisMonth(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('ChildrenEnrolledThisMonth')) {
      cardItems['ChildrenEnrolledThisMonth'] = {
        'title': Global.returnTrLable(
            translats, CustomText.ChildrenEnrolledThisMonth, lng),
        'subtitle': '',
        'count': childrenEnrolledThisMonth.length
      };
      setState(() {});
    }

    /// Children exit This Month
    var childrenExitThisMonth = await DashboardReportHelper()
        .excuteExitCildThisMonth(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('ChildrenExitedThisMonth')) {
      cardItems['ChildrenExitedThisMonth'] = {
        'title': Global.returnTrLable(
            translats, CustomText.ChildrenExitedThisMonth, lng),
        'subtitle': '',
        'count': childrenExitThisMonth.length
      };
      setState(() {});
    }

    /// No Of Creches Not Submitted Attendance (All days this month)
    var noOfCrechesNotSubmittedAttendance = await DashboardReportHelper()
        .excuteNoOfCrecheNotSubmitedAttendence(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('NoOfCrechesNotSubmittedAttendance')) {
      cardItems['NoOfCrechesNotSubmittedAttendance'] = {
        'title': Global.returnTrLable(
            translats, CustomText.NoOfCrechesNotSubmittedAttendance, lng),
        'subtitle': '',
        'count': noOfCrechesNotSubmittedAttendance.length
      };
      setState(() {});
    }

    /// No Of Creches Submitted Attendance
    var noOfCrechesSubmittedAttendance = await DashboardReportHelper()
        .excuteNoOfCrecheSubmitedAttendence(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('NoOfCrechesSubmittedAttendance')) {
      cardItems['NoOfCrechesSubmittedAttendance'] = {
        'title': Global.returnTrLable(
            translats, CustomText.NoOfCrechesSubmittedAttendance, lng),
        'subtitle': '',
        'count': noOfCrechesSubmittedAttendance.length
      };
      setState(() {});
    }

    /// Maximum Attendance In Day
    var maximumAttendanceADay = await DashboardReportHelper()
        .excuteMaximumAttendanceADay(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('MaximumAttendanceInDay')) {
      cardItems['MaximumAttendanceInDay'] = {
        'title': Global.returnTrLable(
            translats, CustomText.MaximumAttendanceInDay, lng),
        'subtitle': '',
        'count': maximumAttendanceADay
      };
      setState(() {});
    }

    /// Current eligible children
    var currentEligibleChildren = await DashboardReportHelper()
        .excuteCurrentEligibleChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('CurrentEligibleChildren')) {
      cardItems['CurrentEligibleChildren'] = {
        'title': Global.returnTrLable(
            translats, CustomText.CurrentEligibleChildren, lng),
        'subtitle': '',
        'count': currentEligibleChildren.length
      };
      setState(() {});
    }

    /// Cumulative Enrolled Children
    var cumulativeEnrolledChildren = await DashboardReportHelper()
        .excuteCumulativeEnrolledChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('CumulativeEnrolledChildren')) {
      cardItems['CumulativeEnrolledChildren'] = {
        'title': Global.returnTrLable(
            translats, CustomText.CumulativeEnrolledChildren, lng),
        'subtitle': '',
        'count': cumulativeEnrolledChildren.length
      };
      setState(() {});
    }

    /// Cumulative exited Children
    var cumulativeExitedChildren = await DashboardReportHelper()
        .excuteCumulativeExitChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('CumulativeExitChildren')) {
      cardItems['CumulativeExitChildren'] = {
        'title': Global.returnTrLable(
            translats, CustomText.CumulativeExitChildren, lng),
        'subtitle': '',
        'count': cumulativeExitedChildren.length
      };
      setState(() {});
    }

    /// Avg. no. of days creche opened
    var avgNoOfDaysCrecheOpened = await DashboardReportHelper()
        .excuteAvgNoOfDaysCrecheOpenedChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('AvgNoOfDaysCrecheOpened')) {
      cardItems['AvgNoOfDaysCrecheOpened'] = {
        'title': Global.returnTrLable(
            translats, CustomText.AvgNoOfDaysCrecheOpened, lng),
        'subtitle': '',
        'count': avgNoOfDaysCrecheOpened
      };
      setState(() {});
    }

    /// Avg. attendance per day
    var avgAttendancePerDay = await DashboardReportHelper()
        .excuteAvgAttendancePerDay(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('AvgAttendancePerDay')) {
      cardItems['AvgAttendancePerDay'] = {
        'title': Global.returnTrLable(
            translats, CustomText.AvgAttendancePerDay, lng),
        'subtitle': '',
        'count': avgAttendancePerDay
      };
      setState(() {});
    }

    /// Avg No Days Attendance Submitted
    var avgNofDaysAttendanceSubmitted = await DashboardReportHelper()
        .excuteDaysAttendanceSubmitted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('AvgNoDaysAttendanceSubmitted')) {
      cardItems['AvgNoDaysAttendanceSubmitted'] = {
        'title': Global.returnTrLable(
            translats, CustomText.AvgNoDaysAttendanceSubmitted, lng),
        'subtitle': '',
        'count': avgNofDaysAttendanceSubmitted
      };
      setState(() {});
    }

    /// Anthro data submitted
    var anthroDataSubmitted = await DashboardReportHelper()
        .excuteAnthroDataSubmitted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('AnthroDataSubmitted')) {
      cardItems['AnthroDataSubmitted'] = {
        'title': Global.returnTrLable(
            translats, CustomText.AnthroDataSubmitted, lng),
        'subtitle': '',
        'count': anthroDataSubmitted.length
      };
      setState(() {});
    }

    /// Anthro DataNot Submitted
    var anthroDataNotSubmitted = await DashboardReportHelper()
        .excuteAnthroDataNotSubmitted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('AnthroDataNotSubmitted')) {
      cardItems['AnthroDataNotSubmitted'] = {
        'title': Global.returnTrLable(
            translats, CustomText.AnthroDataNotSubmitted, lng),
        'subtitle': '',
        'count': anthroDataNotSubmitted.length
      };
      setState(() {});
    }

    /// Children measurement taken
    var childrenMeasurementTaken = await DashboardReportHelper()
        .excuteChildrenMeasermentTaken(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('ChildrenMeasurementTaken')) {
      cardItems['ChildrenMeasurementTaken'] = {
        'title': Global.returnTrLable(
            translats, CustomText.ChildrenMeasurementTaken, lng),
        'subtitle': '',
        'count': childrenMeasurementTaken.length
      };
      setState(() {});
    }

    /// Children measurement not taken
    var childrenMeasurementNotTaken = await DashboardReportHelper()
        .excuteChildrenMeasermentNotTaken(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('ChildrenMeasurementNotTaken')) {
      cardItems['ChildrenMeasurementNotTaken'] = {
        'title': Global.returnTrLable(
            translats, CustomText.ChildrenMeasurementNotTaken, lng),
        'subtitle': '',
        'count': childrenMeasurementNotTaken.length
      };
      setState(() {});
    }

    /// Moderately underweight
    var moderatelyUnderweight = await DashboardReportHelper()
        .excuteModerateUnderWeight(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('ModeratelyUnderweight')) {
      cardItems['ModeratelyUnderweight'] = {
        'title': Global.returnTrLable(
            translats, CustomText.ModeratelyUnderweight, lng),
        'subtitle': '',
        'count': moderatelyUnderweight.length
      };
      setState(() {});
    }

    /// Moderately wasted
    var moderatelyWasted = await DashboardReportHelper().excuteModerateWastage(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: Global.getDateByMonthYear(Global.stringToInt(selectedYear),
            Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('ModeratelyWasted')) {
      cardItems['ModeratelyWasted'] = {
        'title':
            Global.returnTrLable(translats, CustomText.ModeratelyWasted, lng),
        'subtitle': '',
        'count': moderatelyWasted.length
      };
      setState(() {});
    }

    /// Moderately Stunted
    var moderatelyStunted = await DashboardReportHelper().excuteModerateStunted(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: Global.getDateByMonthYear(Global.stringToInt(selectedYear),
            Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('ModeratelyStunted')) {
      cardItems['ModeratelyStunted'] = {
        'title':
            Global.returnTrLable(translats, CustomText.ModeratelyStunted, lng),
        'subtitle': '',
        'count': moderatelyStunted.length
      };
      setState(() {});
    }

    /// Severely underweight
    var severelyUnderweight = await DashboardReportHelper()
        .excuteSeverUnderWeight(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('SeverelyUnderweight')) {
      cardItems['SeverelyUnderweight'] = {
        'title': Global.returnTrLable(
            translats, CustomText.SeverelyUnderweight, lng),
        'subtitle': '',
        'count': severelyUnderweight.length
      };
      setState(() {});
    }

    /// Severely stunted
    var severelyStunted = await DashboardReportHelper().excuteSeverelyStunted(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: Global.getDateByMonthYear(Global.stringToInt(selectedYear),
            Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('SeverelyStunted')) {
      cardItems['SeverelyStunted'] = {
        'title':
            Global.returnTrLable(translats, CustomText.SeverelyStunted, lng),
        'subtitle': '',
        'count': severelyStunted.length
      };
      setState(() {});
    }

    /// Severely wasted
    var severelyWasted = await DashboardReportHelper().excuteSeverelyWasted(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: Global.getDateByMonthYear(Global.stringToInt(selectedYear),
            Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('SeverelyWasted')) {
      cardItems['SeverelyWasted'] = {
        'title':
            Global.returnTrLable(translats, CustomText.SeverelyWasted, lng),
        'subtitle': '',
        'count': severelyWasted.length
      };
      setState(() {});
    }

    /// Growth faltering 1
    var gf1 = await DashboardReportHelper().excuteGF1(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: Global.getDateByMonthYear(Global.stringToInt(selectedYear),
            Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('Growthfaltering1')) {
      cardItems['Growthfaltering1'] = {
        'title':
            Global.returnTrLable(translats, CustomText.Growthfaltering1, lng),
        'subtitle': '',
        'count': gf1.length
      };
      setState(() {});
    }

    /// Growth faltering 2
    var gf2 = await DashboardReportHelper().excuteGF2(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: Global.getDateByMonthYear(Global.stringToInt(selectedYear),
            Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('Growthfaltering2')) {
      cardItems['Growthfaltering2'] = {
        'title':
            Global.returnTrLable(translats, CustomText.Growthfaltering2, lng),
        'subtitle': '',
        'count': gf2.length
      };
      setState(() {});
    }

    /// Red flag
    var redFlagChildren = await DashboardReportHelper().excuteRedFlag(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: Global.getDateByMonthYear(Global.stringToInt(selectedYear),
            Global.stringToInt(selectedMonth?.name)));

    if (cardItems.containsKey('RedFlagChildren')) {
      cardItems['RedFlagChildren'] = {
        'title':
            Global.returnTrLable(translats, CustomText.RedFlagChildren, lng),
        'subtitle': '',
        'count': redFlagChildren.length
      };
      setState(() {});
    }
    Navigator.pop(context);
  }

  callDataInit() {
    String? stateId;
    String? districtId;
    String? blockId;
    String? gpId;
    String? villageId;
    String? crecheId;
    String? phase;
    String? partnerId;
    String? crecheStatus;
    String filtredMonthDate = Global.getDateByMonthYear(
        Global.stringToInt(selectedYear),
        Global.stringToInt(selectedMonth?.name));

    if (tempSelectedState != null) {
      stateId = tempSelectedState?.name;
    }

    if (tempSelectedDistrict != null) {
      districtId = tempSelectedDistrict?.name;
    }

    if (tempSelectedBlock != null) {
      blockId = tempSelectedBlock?.name;
    }

    if (tempSelectedGramPanchayat != null) {
      gpId = tempSelectedGramPanchayat?.name;
    }

    if (tempSelectedCreche != null) {
      crecheId = tempSelectedCreche?.name;
    }

    if (tempSelectedCrecheStatus != null) {
      crecheStatus = tempSelectedCrecheStatus?.name;
    }

    if (tempSelectedPartner != null) {
      partnerId = tempSelectedPartner?.name;
    }

    if (tempSelectedPhase != null) {
      phase = tempSelectedPhase?.name;
    }

    // callAnthroDataExcution(stateId,
    //     districtId,
    //     blockId,
    //     gpId,
    //     villageId,
    //     crecheId,
    //     phase,
    //     partnerId,
    //     crecheStatus,
    //     filtredMonthDate);

    crecheCount(stateId, districtId, blockId, gpId, villageId, crecheId, phase,
        partnerId, crecheStatus, filtredMonthDate);

    currentActiveChildren(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    childrenEnrolledThisMonth(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    childrenExitThisMonth(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    noOfCrechesNotSubmittedAttendance(stateId, districtId, blockId, gpId,
        villageId, crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    noOfCrechesSubmittedAttendance(stateId, districtId, blockId, gpId,
        villageId, crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    maximumAttendanceADay(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    currentEligibleChildren(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    cumulativeEnrolledChildren(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    cumulativeExitedChildren(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    avgNoOfDaysCrecheOpened(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    avgAttendancePerDay(stateId, districtId, blockId, gpId, villageId, crecheId,
        phase, partnerId, crecheStatus, filtredMonthDate);

    avgNofDaysAttendanceSubmitted(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    anthroDataSubmitted(stateId, districtId, blockId, gpId, villageId, crecheId,
        phase, partnerId, crecheStatus, filtredMonthDate);

    anthroDataNotSubmitted(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    // childrenMeasurementTaken(
    //     stateId,
    //     districtId,
    //     blockId,
    //     gpId,
    //     villageId,
    //     crecheId,
    //     phase,
    //     partnerId,
    //     crecheStatus,
    //     filtredMonthDate);

    childrenMeasurementNotTaken(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    moderatelyUnderweight(stateId, districtId, blockId, gpId, villageId,
        crecheId, phase, partnerId, crecheStatus, filtredMonthDate);

    moderatelyWasted(stateId, districtId, blockId, gpId, villageId, crecheId,
        phase, partnerId, crecheStatus, filtredMonthDate);

    moderatelyStunted(stateId, districtId, blockId, gpId, villageId, crecheId,
        phase, partnerId, crecheStatus, filtredMonthDate);

    severelyUnderweight(stateId, districtId, blockId, gpId, villageId, crecheId,
        phase, partnerId, crecheStatus, filtredMonthDate);

    severelyStunted(stateId, districtId, blockId, gpId, villageId, crecheId,
        phase, partnerId, crecheStatus, filtredMonthDate);

    severelyWasted(stateId, districtId, blockId, gpId, villageId, crecheId,
        phase, partnerId, crecheStatus, filtredMonthDate);

    // gf1(
    //     stateId,
    //     districtId,
    //     blockId,
    //     gpId,
    //     villageId,
    //     crecheId,
    //     phase,
    //     partnerId,
    //     crecheStatus,
    //     filtredMonthDate);
    //
    // gf2(
    //     stateId,
    //     districtId,
    //     blockId,
    //     gpId,
    //     villageId,
    //     crecheId,
    //     phase,
    //     partnerId,
    //     crecheStatus,
    //     filtredMonthDate);

    // redFlagChildren(
    //     stateId,
    //     districtId,
    //     blockId,
    //     gpId,
    //     villageId,
    //     crecheId,
    //     phase,
    //     partnerId,
    //     crecheStatus,
    //     filtredMonthDate);
  }

  crecheCount(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    var crecheCount = await DashboardReportHelper().excuteCrecheCount(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate);

    if (cardItems.containsKey('NoOfCreches')) {
      cardItems['NoOfCreches'] = {
        'title': Global.returnTrLable(translats, CustomText.NoOfCreches, lng),
        'subtitle': '',
        'count': crecheCount.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  currentActiveChildren(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    ///Current active children
    var currentActiveChildren = await DashboardReportHelper()
        .excuteCurrentActiveChildren(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('CurrentActiveChildren')) {
      cardItems['CurrentActiveChildren'] = {
        'title': Global.returnTrLable(
            translats, CustomText.CurrentActiveChildren, lng),
        'subtitle': '',
        'count': currentActiveChildren.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  childrenEnrolledThisMonth(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Children Enrolled This Month
    var childrenEnrolledThisMonth = await DashboardReportHelper()
        .excuteEnrolldCildThisMonth(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('ChildrenEnrolledThisMonth')) {
      cardItems['ChildrenEnrolledThisMonth'] = {
        'title': Global.returnTrLable(
            translats, CustomText.ChildrenEnrolledThisMonth, lng),
        'subtitle': '',
        'count': childrenEnrolledThisMonth.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  childrenExitThisMonth(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Children exit This Month
    var childrenExitThisMonth = await DashboardReportHelper()
        .excuteExitCildThisMonth(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('ChildrenExitedThisMonth')) {
      cardItems['ChildrenExitedThisMonth'] = {
        'title': Global.returnTrLable(
            translats, CustomText.ChildrenExitedThisMonth, lng),
        'subtitle': '',
        'count': childrenExitThisMonth.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  noOfCrechesNotSubmittedAttendance(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// No Of Creches Not Submitted Attendance (All days this month)
    var noOfCrechesNotSubmittedAttendance = await DashboardReportHelper()
        .excuteNoOfCrecheNotSubmitedAttendence(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('NoOfCrechesNotSubmittedAttendance')) {
      cardItems['NoOfCrechesNotSubmittedAttendance'] = {
        'title': Global.returnTrLable(
            translats, CustomText.NoOfCrechesNotSubmittedAttendance, lng),
        'subtitle': '',
        'count': noOfCrechesNotSubmittedAttendance.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  noOfCrechesSubmittedAttendance(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// No Of Creches Submitted Attendance
    var noOfCrechesSubmittedAttendance = await DashboardReportHelper()
        .excuteNoOfCrecheSubmitedAttendence(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('NoOfCrechesSubmittedAttendance')) {
      cardItems['NoOfCrechesSubmittedAttendance'] = {
        'title': Global.returnTrLable(
            translats, CustomText.NoOfCrechesSubmittedAttendance, lng),
        'subtitle': '',
        'count': noOfCrechesSubmittedAttendance.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  maximumAttendanceADay(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Maximum Attendance In Day
    var maximumAttendanceADay = await DashboardReportHelper()
        .excuteMaximumAttendanceADay(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('MaximumAttendanceInDay')) {
      cardItems['MaximumAttendanceInDay'] = {
        'title': Global.returnTrLable(
            translats, CustomText.MaximumAttendanceInDay, lng),
        'subtitle': '',
        'count': maximumAttendanceADay,
        'isProgress': false
      };
      setState(() {});
    }
  }

  currentEligibleChildren(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Current eligible children
    var currentEligibleChildren = await DashboardReportHelper()
        .excuteCurrentEligibleChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('CurrentEligibleChildren')) {
      cardItems['CurrentEligibleChildren'] = {
        'title': Global.returnTrLable(
            translats, CustomText.CurrentEligibleChildren, lng),
        'subtitle': '',
        'count': currentEligibleChildren.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  cumulativeEnrolledChildren(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Cumulative Enrolled Children
    var cumulativeEnrolledChildren = await DashboardReportHelper()
        .excuteCumulativeEnrolledChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('CumulativeEnrolledChildren')) {
      cardItems['CumulativeEnrolledChildren'] = {
        'title': Global.returnTrLable(
            translats, CustomText.CumulativeEnrolledChildren, lng),
        'subtitle': '',
        'count': cumulativeEnrolledChildren.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  cumulativeExitedChildren(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Cumulative exited Children
    var cumulativeExitedChildren = await DashboardReportHelper()
        .excuteCumulativeExitChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('CumulativeExitChildren')) {
      cardItems['CumulativeExitChildren'] = {
        'title': Global.returnTrLable(
            translats, CustomText.CumulativeExitChildren, lng),
        'subtitle': '',
        'count': cumulativeExitedChildren.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  avgNoOfDaysCrecheOpened(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Avg. no. of days creche opened
    var avgNoOfDaysCrecheOpened = await DashboardReportHelper()
        .excuteAvgNoOfDaysCrecheOpenedChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('AvgNoOfDaysCrecheOpened')) {
      cardItems['AvgNoOfDaysCrecheOpened'] = {
        'title': Global.returnTrLable(
            translats, CustomText.AvgNoOfDaysCrecheOpened, lng),
        'subtitle': '',
        'count': avgNoOfDaysCrecheOpened,
        'isProgress': false
      };
      setState(() {});
    }
  }

  avgAttendancePerDay(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Avg. attendance per day
    var avgAttendancePerDay = await DashboardReportHelper()
        .excuteAvgAttendancePerDay(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('AvgAttendancePerDay')) {
      cardItems['AvgAttendancePerDay'] = {
        'title': Global.returnTrLable(
            translats, CustomText.AvgAttendancePerDay, lng),
        'subtitle': '',
        'count': avgAttendancePerDay,
        'isProgress': false
      };
      setState(() {});
    }
  }

  avgNofDaysAttendanceSubmitted(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Avg No Days Attendance Submitted
    var avgNofDaysAttendanceSubmitted = await DashboardReportHelper()
        .excuteDaysAttendanceSubmitted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('AvgNoDaysAttendanceSubmitted')) {
      cardItems['AvgNoDaysAttendanceSubmitted'] = {
        'title': Global.returnTrLable(
            translats, CustomText.AvgNoDaysAttendanceSubmitted, lng),
        'subtitle': '',
        'count': avgNofDaysAttendanceSubmitted,
        'isProgress': false
      };
      setState(() {});
    }
  }

  anthroDataSubmitted(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Anthro data submitted
    var anthroDataSubmitted = await DashboardReportHelper()
        .excuteAnthroDataSubmitted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('AnthroDataSubmitted')) {
      cardItems['AnthroDataSubmitted'] = {
        'title': Global.returnTrLable(
            translats, CustomText.AnthroDataSubmitted, lng),
        'subtitle': '',
        'count': anthroDataSubmitted.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  anthroDataNotSubmitted(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Anthro DataNot Submitted
    var anthroDataNotSubmitted = await DashboardReportHelper()
        .excuteAnthroDataNotSubmitted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('AnthroDataNotSubmitted')) {
      cardItems['AnthroDataNotSubmitted'] = {
        'title': Global.returnTrLable(
            translats, CustomText.AnthroDataNotSubmitted, lng),
        'subtitle': '',
        'count': anthroDataNotSubmitted.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  childrenMeasurementTaken(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Children measurement taken
    var childrenMeasurementTaken = await DashboardReportHelper()
        .excuteChildrenMeasermentTaken(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('ChildrenMeasurementTaken')) {
      cardItems['ChildrenMeasurementTaken'] = {
        'title': Global.returnTrLable(
            translats, CustomText.ChildrenMeasurementTaken, lng),
        'subtitle': '',
        'count': childrenMeasurementTaken.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  childrenMeasurementNotTaken(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Children measurement not taken
    var childrenMeasurementNotTaken = await DashboardReportHelper()
        .excuteChildrenMeasermentNotTaken(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('ChildrenMeasurementNotTaken')) {
      cardItems['ChildrenMeasurementNotTaken'] = {
        'title': Global.returnTrLable(
            translats, CustomText.ChildrenMeasurementNotTaken, lng),
        'subtitle': '',
        'count': childrenMeasurementNotTaken.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  moderatelyUnderweight(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Moderately underweight
    var moderatelyUnderweight = await DashboardReportHelper()
        .excuteModerateUnderWeight(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('ModeratelyUnderweight')) {
      cardItems['ModeratelyUnderweight'] = {
        'title': Global.returnTrLable(
            translats, CustomText.ModeratelyUnderweight, lng),
        'subtitle': '',
        'count': moderatelyUnderweight.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  moderatelyWasted(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Moderately wasted
    var moderatelyWasted = await DashboardReportHelper().excuteModerateWastage(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate);

    if (cardItems.containsKey('ModeratelyWasted')) {
      cardItems['ModeratelyWasted'] = {
        'title':
            Global.returnTrLable(translats, CustomText.ModeratelyWasted, lng),
        'subtitle': '',
        'count': moderatelyWasted.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  moderatelyStunted(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Moderately Stunted
    var moderatelyStunted = await DashboardReportHelper().excuteModerateStunted(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate);

    if (cardItems.containsKey('ModeratelyStunted')) {
      cardItems['ModeratelyStunted'] = {
        'title':
            Global.returnTrLable(translats, CustomText.ModeratelyStunted, lng),
        'subtitle': '',
        'count': moderatelyStunted.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  severelyUnderweight(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Severely underweight
    var severelyUnderweight = await DashboardReportHelper()
        .excuteSeverUnderWeight(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate);

    if (cardItems.containsKey('SeverelyUnderweight')) {
      cardItems['SeverelyUnderweight'] = {
        'title': Global.returnTrLable(
            translats, CustomText.SeverelyUnderweight, lng),
        'subtitle': '',
        'count': severelyUnderweight.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  severelyStunted(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Severely stunted
    var severelyStunted = await DashboardReportHelper().excuteSeverelyStunted(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate);

    if (cardItems.containsKey('SeverelyStunted')) {
      cardItems['SeverelyStunted'] = {
        'title':
            Global.returnTrLable(translats, CustomText.SeverelyStunted, lng),
        'subtitle': '',
        'count': severelyStunted.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  severelyWasted(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Severely wasted
    var severelyWasted = await DashboardReportHelper().excuteSeverelyWasted(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate);

    if (cardItems.containsKey('SeverelyWasted')) {
      cardItems['SeverelyWasted'] = {
        'title':
            Global.returnTrLable(translats, CustomText.SeverelyWasted, lng),
        'subtitle': '',
        'count': severelyWasted.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  gf1(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Growth faltering 1
    var gf1 = await DashboardReportHelper().excuteGF1(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate);

    if (cardItems.containsKey('Growthfaltering1')) {
      cardItems['Growthfaltering1'] = {
        'title':
            Global.returnTrLable(translats, CustomText.Growthfaltering1, lng),
        'subtitle': '',
        'count': gf1.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  gf2(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Growth faltering 2
    var gf2 = await DashboardReportHelper().excuteGF2(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate);

    if (cardItems.containsKey('Growthfaltering2')) {
      cardItems['Growthfaltering2'] = {
        'title':
            Global.returnTrLable(translats, CustomText.Growthfaltering2, lng),
        'subtitle': '',
        'count': gf2.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  redFlagChildren(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate) async {
    /// Red flag
    var redFlagChildren = await DashboardReportHelper().excuteRedFlag(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate);

    if (cardItems.containsKey('RedFlagChildren')) {
      cardItems['RedFlagChildren'] = {
        'title':
            Global.returnTrLable(translats, CustomText.RedFlagChildren, lng),
        'subtitle': '',
        'count': redFlagChildren.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  Future<void> multipleAsyncCalls() async {
    // showLoaderDialog(context);
    String? stateId;
    String? districtId;
    String? blockId;
    String? gpId;
    String? villageId;
    String? crecheId;
    String? phase;
    String? partnerId;
    String? crecheStatus;

    if (tempSelectedState != null) {
      stateId = tempSelectedState?.name;
    }

    if (tempSelectedDistrict != null) {
      districtId = tempSelectedDistrict?.name;
    }

    if (tempSelectedBlock != null) {
      blockId = tempSelectedBlock?.name;
    }

    if (tempSelectedGramPanchayat != null) {
      gpId = tempSelectedGramPanchayat?.name;
    }

    if (tempSelectedCreche != null) {
      crecheId = tempSelectedCreche?.name;
    }

    if (tempSelectedCrecheStatus != null) {
      crecheStatus = tempSelectedCrecheStatus?.name;
    }

    if (tempSelectedPartner != null) {
      partnerId = tempSelectedPartner?.name;
    }

    if (tempSelectedPhase != null) {
      phase = tempSelectedPhase?.name;
    }
    try {
      final results = await Future.wait([
        DashboardReportHelper().excuteCrecheCount(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteCurrentActiveChildren(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteEnrolldCildThisMonth(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteExitCildThisMonth(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteNoOfCrecheNotSubmitedAttendence(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteNoOfCrecheSubmitedAttendence(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteMaximumAttendanceADay(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteCurrentEligibleChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteCumulativeEnrolledChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteCumulativeExitChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteAvgNoOfDaysCrecheOpenedChild(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteAvgAttendancePerDay(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteDaysAttendanceSubmitted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteAnthroDataSubmitted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteAnthroDataNotSubmitted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteChildrenMeasermentTaken(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteChildrenMeasermentNotTaken(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteModerateUnderWeight(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteModerateWastage(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteModerateStunted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteSeverUnderWeight(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteSeverelyStunted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        DashboardReportHelper().excuteSeverelyWasted(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: Global.getDateByMonthYear(
                Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name))),
        // DashboardReportHelper().excuteGF1(
        //     stateId: stateId,
        //     districtId: districtId,
        //     blockId: blockId,
        //     gpId: gpId,
        //     villageId: villageId,
        //     crecheId: crecheId,
        //     phase: phase,
        //     partnerId: partnerId,
        //     crecheStatus: crecheStatus,
        //     filterDate: Global.getDateByMonthYear(
        //         Global.stringToInt(selectedYear),
        //         Global.stringToInt(selectedMonth?.name))),
        // DashboardReportHelper().excuteGF2(
        //     stateId: stateId,
        //     districtId: districtId,
        //     blockId: blockId,
        //     gpId: gpId,
        //     villageId: villageId,
        //     crecheId: crecheId,
        //     phase: phase,
        //     partnerId: partnerId,
        //     crecheStatus: crecheStatus,
        //     filterDate: Global.getDateByMonthYear(
        //         Global.stringToInt(selectedYear),
        //         Global.stringToInt(selectedMonth?.name))),
        // DashboardReportHelper().excuteRedFlag(
        //     stateId: stateId,
        //     districtId: districtId,
        //     blockId: blockId,
        //     gpId: gpId,
        //     villageId: villageId,
        //     crecheId: crecheId,
        //     phase: phase,
        //     partnerId: partnerId,
        //     crecheStatus: crecheStatus,
        //     filterDate: Global.getDateByMonthYear(
        //         Global.stringToInt(selectedYear),
        //         Global.stringToInt(selectedMonth?.name)))
      ]);

      ///Number of creche
      if (cardItems.containsKey('NoOfCreches')) {
        cardItems['NoOfCreches'] = {
          'title': Global.returnTrLable(translats, CustomText.NoOfCreches, lng),
          'subtitle': '',
          'count': (results[0] as List).length,
          'isProgress':false
        };
      }

      ///Current active children

      if (cardItems.containsKey('CurrentActiveChildren')) {
        cardItems['CurrentActiveChildren'] = {
          'title': Global.returnTrLable(
              translats, CustomText.CurrentActiveChildren, lng),
          'subtitle': '',
          'count': (results[1] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Children Enrolled This Month

      if (cardItems.containsKey('ChildrenEnrolledThisMonth')) {
        cardItems['ChildrenEnrolledThisMonth'] = {
          'title': Global.returnTrLable(
              translats, CustomText.ChildrenEnrolledThisMonth, lng),
          'subtitle': '',
          'count': (results[2] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Children exit This Month

      if (cardItems.containsKey('ChildrenExitedThisMonth')) {
        cardItems['ChildrenExitedThisMonth'] = {
          'title': Global.returnTrLable(
              translats, CustomText.ChildrenExitedThisMonth, lng),
          'subtitle': '',
          'count': (results[3] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// No Of Creches Not Submitted Attendance (All days this month)

      if (cardItems.containsKey('NoOfCrechesNotSubmittedAttendance')) {
        cardItems['NoOfCrechesNotSubmittedAttendance'] = {
          'title': Global.returnTrLable(
              translats, CustomText.NoOfCrechesNotSubmittedAttendance, lng),
          'subtitle': '',
          'count': (results[4] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// No Of Creches Submitted Attendance

      if (cardItems.containsKey('NoOfCrechesSubmittedAttendance')) {
        cardItems['NoOfCrechesSubmittedAttendance'] = {
          'title': Global.returnTrLable(
              translats, CustomText.NoOfCrechesSubmittedAttendance, lng),
          'subtitle': '',
          'count': (results[5] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Maximum Attendance In Day

      if (cardItems.containsKey('MaximumAttendanceInDay')) {
        cardItems['MaximumAttendanceInDay'] = {
          'title': Global.returnTrLable(
              translats, CustomText.MaximumAttendanceInDay, lng),
          'subtitle': '',
          'count': (results[6]),
          'isProgress':false
        };
        setState(() {});
      }

      /// Current eligible children

      if (cardItems.containsKey('CurrentEligibleChildren')) {
        cardItems['CurrentEligibleChildren'] = {
          'title': Global.returnTrLable(
              translats, CustomText.CurrentEligibleChildren, lng),
          'subtitle': '',
          'count': (results[7] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Cumulative Enrolled Children

      if (cardItems.containsKey('CumulativeEnrolledChildren')) {
        cardItems['CumulativeEnrolledChildren'] = {
          'title': Global.returnTrLable(
              translats, CustomText.CumulativeEnrolledChildren, lng),
          'subtitle': '',
          'count': (results[8] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Cumulative exited Children

      if (cardItems.containsKey('CumulativeExitChildren')) {
        cardItems['CumulativeExitChildren'] = {
          'title': Global.returnTrLable(
              translats, CustomText.CumulativeExitChildren, lng),
          'subtitle': '',
          'count': (results[9] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Avg. no. of days creche opened

      if (cardItems.containsKey('AvgNoOfDaysCrecheOpened')) {
        cardItems['AvgNoOfDaysCrecheOpened'] = {
          'title': Global.returnTrLable(
              translats, CustomText.AvgNoOfDaysCrecheOpened, lng),
          'subtitle': '',
          'count': results[10],
          'isProgress':false
        };
        setState(() {});
      }

      /// Avg. attendance per day

      if (cardItems.containsKey('AvgAttendancePerDay')) {
        cardItems['AvgAttendancePerDay'] = {
          'title': Global.returnTrLable(
              translats, CustomText.AvgAttendancePerDay, lng),
          'subtitle': '',
          'count': results[11],
          'isProgress':false
        };
        setState(() {});
      }

      /// Avg No Days Attendance Submitted

      if (cardItems.containsKey('AvgNoDaysAttendanceSubmitted')) {
        cardItems['AvgNoDaysAttendanceSubmitted'] = {
          'title': Global.returnTrLable(
              translats, CustomText.AvgNoDaysAttendanceSubmitted, lng),
          'subtitle': '',
          'count': results[12],
          'isProgress':false
        };
        setState(() {});
      }

      /// Anthro data submitted

      if (cardItems.containsKey('AnthroDataSubmitted')) {
        cardItems['AnthroDataSubmitted'] = {
          'title': Global.returnTrLable(
              translats, CustomText.AnthroDataSubmitted, lng),
          'subtitle': '',
          'count': (results[13] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Anthro DataNot Submitted

      if (cardItems.containsKey('AnthroDataNotSubmitted')) {
        cardItems['AnthroDataNotSubmitted'] = {
          'title': Global.returnTrLable(
              translats, CustomText.AnthroDataNotSubmitted, lng),
          'subtitle': '',
          'count': (results[14] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Children measurement taken

      if (cardItems.containsKey('ChildrenMeasurementTaken')) {
        cardItems['ChildrenMeasurementTaken'] = {
          'title': Global.returnTrLable(
              translats, CustomText.ChildrenMeasurementTaken, lng),
          'subtitle': '',
          'count': (results[15] as List).length,
          'isProgress':false
        };
        setState(() {});
        callAnthroDataExcution(
            stateId,
            districtId,
            blockId,
            gpId,
            villageId,
            crecheId,
            phase,
            partnerId,
            crecheStatus,
            Global.getDateByMonthYear(Global.stringToInt(selectedYear),
                Global.stringToInt(selectedMonth?.name)),
            results[15] as List<Map<String, dynamic>>);
      }

      /// Children measurement not taken

      if (cardItems.containsKey('ChildrenMeasurementNotTaken')) {
        cardItems['ChildrenMeasurementNotTaken'] = {
          'title': Global.returnTrLable(
              translats, CustomText.ChildrenMeasurementNotTaken, lng),
          'subtitle': '',
          'count': (results[16] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Moderately underweight

      if (cardItems.containsKey('ModeratelyUnderweight')) {
        cardItems['ModeratelyUnderweight'] = {
          'title': Global.returnTrLable(
              translats, CustomText.ModeratelyUnderweight, lng),
          'subtitle': '',
          'count': (results[17] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Moderately wasted

      if (cardItems.containsKey('ModeratelyWasted')) {
        cardItems['ModeratelyWasted'] = {
          'title':
              Global.returnTrLable(translats, CustomText.ModeratelyWasted, lng),
          'subtitle': '',
          'count': (results[18] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Moderately Stunted

      if (cardItems.containsKey('ModeratelyStunted')) {
        cardItems['ModeratelyStunted'] = {
          'title': Global.returnTrLable(
              translats, CustomText.ModeratelyStunted, lng),
          'subtitle': '',
          'count': (results[19] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Severely underweight

      if (cardItems.containsKey('SeverelyUnderweight')) {
        cardItems['SeverelyUnderweight'] = {
          'title': Global.returnTrLable(
              translats, CustomText.SeverelyUnderweight, lng),
          'subtitle': '',
          'count': (results[20] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Severely stunted

      if (cardItems.containsKey('SeverelyStunted')) {
        cardItems['SeverelyStunted'] = {
          'title':
              Global.returnTrLable(translats, CustomText.SeverelyStunted, lng),
          'subtitle': '',
          'count': (results[21] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Severely wasted

      if (cardItems.containsKey('SeverelyWasted')) {
        cardItems['SeverelyWasted'] = {
          'title':
              Global.returnTrLable(translats, CustomText.SeverelyWasted, lng),
          'subtitle': '',
          'count': (results[22] as List).length,
          'isProgress':false
        };
        setState(() {});
      }

      /// Growth faltering 1

      // if (cardItems.containsKey('Growthfaltering1')) {
      //   cardItems['Growthfaltering1'] = {
      //     'title':
      //         Global.returnTrLable(translats, CustomText.Growthfaltering1, lng),
      //     'subtitle': '',
      //     'count': (results[23] as List).length
      //   };
      //   setState(() {});
      // }
      //
      // /// Growth faltering 2
      //
      // if (cardItems.containsKey('Growthfaltering2')) {
      //   cardItems['Growthfaltering2'] = {
      //     'title':
      //         Global.returnTrLable(translats, CustomText.Growthfaltering2, lng),
      //     'subtitle': '',
      //     'count': (results[24] as List).length
      //   };
      //   setState(() {});
      // }
      //
      // /// Red flag
      //
      // if (cardItems.containsKey('RedFlagChildren')) {
      //   cardItems['RedFlagChildren'] = {
      //     'title':
      //         Global.returnTrLable(translats, CustomText.RedFlagChildren, lng),
      //     'subtitle': '',
      //     'count': (results[25] as List).length
      //   };
      //   setState(() {});
      // }
      Navigator.pop(context);
      print('All calls completed successfully');
    } catch (e) {
      print('Error in one of the calls: $e');
    }
  }

  callRunProgressTrue() {
    for (var element in cardItems.keys.toList()) {
      var item = cardItems[element];
      if (item['isProgress'] != null) {
        item.remove('isProgress');
        cardItems[element] = item;
      }
    }
    showLoaderDialog(context);
    multipleAsyncCalls();
  }

  callAnthroDataExcution(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate,
      List<Map<String, dynamic>> childrenMeasurementTaken) async {
    /// Children measurement taken
    // var childrenMeasurementTaken = await DashboardReportHelper()
    //     .excuteChildrenMeasermentTaken(
    //     stateId: stateId,
    //     districtId: districtId,
    //     blockId: blockId,
    //     gpId: gpId,
    //     villageId: villageId,
    //     crecheId: crecheId,
    //     phase: phase,
    //     partnerId: partnerId,
    //     crecheStatus: crecheStatus,
    //     filterDate: filterDate);
    //
    // if (cardItems.containsKey('ChildrenMeasurementTaken')) {
    //   cardItems['ChildrenMeasurementTaken'] = {
    //     'title': Global.returnTrLable(
    //         translats, CustomText.ChildrenMeasurementTaken, lng),
    //     'subtitle': '',
    //     'count': childrenMeasurementTaken.length,
    //     'isProgress': false
    //   };
    //   setState(() {});
    // }

    var gf1 = await DashboardReportHelper().excuteGF1AllAnthro(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate,
        childrenMeasurementTaken: childrenMeasurementTaken,
        allAntroData: allAntroData);

    if (cardItems.containsKey('Growthfaltering1')) {
      cardItems['Growthfaltering1'] = {
        'title':
            Global.returnTrLable(translats, CustomText.Growthfaltering1, lng),
        'subtitle': '',
        'count': gf1.length,
        'isProgress': false
      };
      setState(() {});
    }

    var gf2 = await DashboardReportHelper().excuteGF2MeasurementTakenAllAnthro(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate,
        childrenMeasurementTaken: childrenMeasurementTaken,
        allAntroData: allAntroData);
    if (cardItems.containsKey('Growthfaltering2')) {
      cardItems['Growthfaltering2'] = {
        'title':
            Global.returnTrLable(translats, CustomText.Growthfaltering2, lng),
        'subtitle': '',
        'count': gf2.length,
        'isProgress': false
      };
      setState(() {});
    }

    var redFlagAllAnthro = await DashboardReportHelper()
        .excuteRedFlagMeasurmentTakenAllAnthro(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate,
            childrenMeasurementTaken: childrenMeasurementTaken,
            allAntroData: allAntroData);
    if (cardItems.containsKey('RedFlagChildren')) {
      cardItems['RedFlagChildren'] = {
        'title':
            Global.returnTrLable(translats, CustomText.RedFlagChildren, lng),
        'subtitle': '',
        'count': redFlagAllAnthro.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  Future gf1WithMeasurementTaken(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate,
      List<Map<String, dynamic>>? childrenMeasurementTaken) async {
    /// Growth faltering 1
    var gf1 = await DashboardReportHelper().excuteGF1WithMeasurementTaken(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate,
        childrenMeasurementTaken: childrenMeasurementTaken);

    if (cardItems.containsKey('Growthfaltering1')) {
      cardItems['Growthfaltering1'] = {
        'title':
            Global.returnTrLable(translats, CustomText.Growthfaltering1, lng),
        'subtitle': '',
        'count': gf1.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  Future gf2WithMeasurementTaken(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate,
      List<Map<String, dynamic>> measurementTaken) async {
    /// Growth faltering 2
    var gf2 = await DashboardReportHelper().excuteGF2MeasurementTaken(
        stateId: stateId,
        districtId: districtId,
        blockId: blockId,
        gpId: gpId,
        villageId: villageId,
        crecheId: crecheId,
        phase: phase,
        partnerId: partnerId,
        crecheStatus: crecheStatus,
        filterDate: filterDate,
        childrenMeasurementTaken: measurementTaken);

    if (cardItems.containsKey('Growthfaltering2')) {
      cardItems['Growthfaltering2'] = {
        'title':
            Global.returnTrLable(translats, CustomText.Growthfaltering2, lng),
        'subtitle': '',
        'count': gf2.length,
        'isProgress': false
      };
      setState(() {});
    }
  }

  Future redFlagChildrenWithMeasurementTaken(
      String? stateId,
      String? districtId,
      String? blockId,
      String? gpId,
      String? villageId,
      String? crecheId,
      String? phase,
      String? partnerId,
      String? crecheStatus,
      String filterDate,
      List<Map<String, dynamic>> measurementTaken) async {
    /// Red flag
    var redFlagChildren = await DashboardReportHelper()
        .excuteRedFlagMeasurmentTaken(
            stateId: stateId,
            districtId: districtId,
            blockId: blockId,
            gpId: gpId,
            villageId: villageId,
            crecheId: crecheId,
            phase: phase,
            partnerId: partnerId,
            crecheStatus: crecheStatus,
            filterDate: filterDate,
            childrenMeasurementTaken: measurementTaken);

    if (cardItems.containsKey('RedFlagChildren')) {
      cardItems['RedFlagChildren'] = {
        'title':
            Global.returnTrLable(translats, CustomText.RedFlagChildren, lng),
        'subtitle': '',
        'count': redFlagChildren.length,
        'isProgress': false
      };
      setState(() {});
    }
  }
}
