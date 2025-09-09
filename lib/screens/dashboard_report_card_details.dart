import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../api/dashboard_report_api.dart';
import '../custom_widget/custom_appbar.dart';
import '../custom_widget/custom_btn.dart';
import '../database/helper/block_data_helper.dart';
import '../database/helper/creche_helper/creche_data_helper.dart';
import '../database/helper/district_data_helper.dart';
import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../database/helper/gram_panchayat_data_helper.dart';
import '../database/helper/state_data_helper.dart';
import '../database/helper/village_data_helper.dart';
import '../model/apimodel/creche_database_responce_model.dart';
import '../model/databasemodel/tabBlock_model.dart';
import '../model/databasemodel/tabDistrict_model.dart';
import '../model/databasemodel/tabGramPanchayat_model.dart';
import '../model/databasemodel/tabVillage_model.dart';
import '../model/databasemodel/tabstate_model.dart';
import 'login_screen.dart';

class DashboardReportCardDetailScreen extends StatefulWidget {
  final String title;
  final String query_type;
  final String month;
  final String year;
  OptionsModel? selectedState;
  OptionsModel? selectedDistrict;
  OptionsModel? selectedBlock;
  OptionsModel? selectedGramPanchayat;
  OptionsModel? selectedVillage;
  OptionsModel? selectedCreche;
  OptionsModel? selectedCrecheStatus;
  OptionsModel? selectedPartner;
  OptionsModel? selectedPhase;

  DashboardReportCardDetailScreen(
      {super.key,
      required this.title,
      required this.query_type,
      required this.month,
      required this.year,
      this.selectedState,
      this.selectedDistrict,
      this.selectedBlock,
      this.selectedGramPanchayat,
      this.selectedVillage,
      this.selectedCreche,
      this.selectedCrecheStatus,
      this.selectedPartner,
      this.selectedPhase
      });

  @override
  _DashboardReportCardDetailState createState() =>
      _DashboardReportCardDetailState();
}

class _DashboardReportCardDetailState
    extends State<DashboardReportCardDetailScreen> {
  List items = [];
  List<OptionsModel> years = [];
  List<OptionsModel> months = [];
  List<Translation> translats = [];
  String lng = 'en';
  String? selectedMonth;
  String selectedYear = '${DateTime.now().year}';
  String? role;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // bool apiIsCall=false;

  OptionsModel? selectedState;
  OptionsModel? selectedDistrict;
  OptionsModel? selectedBlock;
  OptionsModel? selectedGramPanchayat;
  OptionsModel? selectedVillage;
  OptionsModel? selectedCreche;
  OptionsModel? selectedCrecheStatus;
  OptionsModel? selectedPartner;
  OptionsModel? selectedPhase;

  OptionsModel? tempSelectedState;
  OptionsModel? tempSelectedDistrict;
  OptionsModel? tempSelectedBlock;
  OptionsModel? tempSelectedGramPanchayat;
  OptionsModel? tempSelectedVillage;
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
    _crecheSearchcontroller.dispose(); // Clean up controller
    super.dispose();
  }

  Future<void> initializeData() async {

    role = (await Validate().readString(Validate.role))!;
    years = getYearList(2000);
    months = getMonthList(Global.stringToInt(years.first.name));
    var crrentMonth = DateTime.now().month;
    selectedMonth = months[crrentMonth - 1].name;
    selectedYear = widget.year;
    months = getMonthList(Global.stringToInt(selectedYear));
    selectedMonth = widget.month;
  
    await fetchStateList();
    // if(creches.length>0){
    //   selectedCreche=creches.first.name!;
    // }
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
      CustomText.CrecheStatus,
      CustomText.Partner,
      CustomText.totalCount,
      CustomText.Search,
      CustomText.Phase,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await callApiForDashboardApi();
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppbar(
          text: Global.returnTrLable(translats, widget.title, lng),
          onTap: () {
            Navigator.pop(context);
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
                                width: 10.w,
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
                        Expanded(
                            child: SingleChildScrollView(
                                controller: _scrollController,
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                          parterns.length > 0
                              ? DynamicCustomDropdownField(
                                  hintText: Global.returnTrLable(
                                      translats, CustomText.Selecthere, lng),
                                  titleText: Global.returnTrLable(
                                      translats, CustomText.Partner, lng),
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
                              // selectedCreche = null;
                              mstDistrict = Global.callDistrict(
                                  district, lng, selectedState);
                              if (mstDistrict.length == 1) {
                                selectedDistrict = mstDistrict.first;
                                mstBlock = Global.callBlocks(
                                    block, lng, selectedDistrict);
                                mstcreches = Global.callFiltersCrechesByDistric(creches, lng, selectedDistrict);
                                if (mstcreches.length == 1) {
                                  selectedCreche = mstcreches.first;
                                }
                                if (mstBlock.length == 1) {
                                  selectedBlock = mstBlock.first;
                                  mstGP = Global.callGramPanchyats(
                                      gramPanchayat, lng, selectedBlock);
                                  mstcreches = Global.callFiltersCrechesByBlock(creches, lng, selectedBlock);
                                  if (mstcreches.length == 1) {
                                    selectedCreche = mstcreches.first;
                                  }
                                  if (mstGP.length == 1) {
                                    selectedGramPanchayat = mstGP.first;
                                    mstcreches = Global.callFiltersCrechesByGP(creches, lng, selectedGramPanchayat);
                                    if (mstcreches.length == 1) {
                                      selectedCreche = mstcreches.first;
                                    }
                                    // mstVillage = Global.callFiltersVillages(
                                    //     villages, lng, selectedGramPanchayat);
                                    //
                                    // if (mstVillage.length == 1) {
                                    //   selectedVillage = mstVillage.first;
                                    //   mstcreches = Global.callFiltersCreches(
                                    //       creches, lng, selectedVillage);
                                    // }
                                  }
                                }
                              } else {
                                mstBlock = [];
                                mstGP = [];
                                mstVillage = [];
                                mstcreches = Global.callFiltersCrechesByState(creches, lng, selectedState);
                                if (mstcreches.length == 1) {
                                  selectedCreche = mstcreches.first;
                                }
                              }
                              setState(() {
                                // Update districtList based on selectedState
                                // districtList = // data from database based on selectedState;
                              });
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
                              // selectedCreche = null;
                              mstBlock = Global.callBlocks(
                                  block, lng, selectedDistrict);
                              if (mstBlock.length == 1) {
                                selectedBlock = mstBlock.first;
                                mstGP = Global.callGramPanchyats(
                                    gramPanchayat, lng, selectedBlock);
                                mstcreches = Global.callFiltersCrechesByBlock(creches, lng, selectedBlock);
                                if (mstcreches.length == 1) {
                                  selectedCreche = mstcreches.first;
                                }
                                if (mstGP.length == 1) {
                                  selectedGramPanchayat = mstGP.first;
                                  mstcreches = Global.callFiltersCrechesByGP(creches, lng, selectedGramPanchayat);
                                  if (mstcreches.length == 1) {
                                    selectedCreche = mstcreches.first;
                                  }
                                  // mstVillage = Global.callFiltersVillages(
                                  //     villages, lng, selectedGramPanchayat);
                                  //
                                  // if (mstVillage.length == 1) {
                                  //   selectedVillage = mstVillage.first;
                                  //   mstcreches = Global.callFiltersCreches(
                                  //       creches, lng, selectedVillage);
                                  // }
                                }
                              } else {
                                mstGP = [];
                                mstVillage = [];
                                mstcreches = Global.callFiltersCrechesByDistric(creches, lng, selectedDistrict);
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
                              // selectedCreche = null;
                              mstGP = Global.callGramPanchyats(
                                  gramPanchayat, lng, selectedBlock);
                              if (mstGP.length == 1) {
                                selectedGramPanchayat = mstGP.first;
                                mstcreches = Global.callFiltersCrechesByGP(creches, lng, selectedGramPanchayat);
                                if (mstcreches.length == 1) {
                                  selectedCreche = mstcreches.first;
                                }
                                // mstVillage = Global.callFiltersVillages(
                                //     villages, lng, selectedGramPanchayat);
                                // if (mstVillage.length == 1) {
                                //   selectedVillage = mstVillage.first;
                                //   mstcreches = Global.callFiltersCreches(
                                //       creches, lng, selectedVillage);
                                // }
                              } else {
                                mstVillage = [];
                                mstcreches = Global.callFiltersCrechesByBlock(creches, lng, selectedBlock);
                                if (mstcreches.length == 1) {
                                  selectedCreche = mstcreches.first;
                                }
                              }
                              setState(() {});
                            },
                          ),
                          DynamicCustomDropdownField(
                            isRequred: 0,
                            titleText: Global.returnTrLable(
                                translats, CustomText.GramPanchayat, lng),
                            items: mstGP,
                            hintText: Global.returnTrLable(
                                translats, CustomText.Selecthere, lng),
                            selectedItem: selectedGramPanchayat != null
                                ? selectedGramPanchayat?.name
                                : null,
                            onChanged: (value) async {
                              selectedGramPanchayat = value;
                              selectedVillage = null;
                              mstcreches = Global.callFiltersCrechesByGP(creches, lng, selectedGramPanchayat);
                              if (mstcreches.length == 1) {
                                selectedCreche = mstcreches.first;
                              }
                              // selectedCreche = null;
                              // mstVillage = Global.callFiltersVillages(
                              //     villages, lng, selectedGramPanchayat);
                              // if (mstVillage.length == 1) {
                              //   selectedVillage = mstVillage.first;
                              //   if (mstVillage.length == 1) {
                              //     selectedVillage = mstVillage.first;
                              //     mstcreches = Global.callFiltersCreches(
                              //         creches, lng, selectedVillage);
                              //   }
                              // }
                              setState(() {});
                            },
                          ),
                          // DynamicCustomDropdownField(
                          //   hintText: Global.returnTrLable(
                          //       translats, CustomText.Selecthere, lng),
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
                          //       mstcreches = Global.callFiltersCreches(
                          //           creches, lng, selectedVillage);
                          //       if (mstcreches.length == 1) {
                          //         selectedCreche = mstcreches.first;
                          //       }
                          //     });
                          //   },
                          // ),
                          // DynamicCustomDropdownField(
                          //   hintText: Global.returnTrLable(
                          //       translats, CustomText.Selecthere, lng),
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
                                      creches.length<=1? DynamicCustomDropdownField(
                                        hintText: Global.returnTrLable(
                                            translats, CustomText.Creches, lng),
                                        titleText: Global.returnTrLable(
                                            translats, CustomText.Creches, lng),
                                        isRequred: 0,
                                        items: mstcreches,
                                        selectedItem:  selectedCreche != null? selectedCreche?.name:null,
                                        onChanged: (value) {
                                          selectedCreche = value;
                                        },
                                      ):Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(Global.returnTrLable(
                                          translats, CustomText.Creches, lng),
                                        style: Styles.black124,),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Container(
                                        height: 35.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Color(0xffACACAC)),
                                          borderRadius: BorderRadius.circular(
                                              10.r),
                                        ),
                                        child: TypeAheadField<OptionsModel>(
                                          controller: _crecheSearchcontroller,
                                          scrollController: _scrollController,
                                          suggestionsCallback: (pattern) async {
                                            try {
                                              var filItems= mstcreches.where((
                                                  element) =>
                                              element.values != null &&
                                                  element.name != null &&
                                                  element.values!
                                                      .toLowerCase()
                                                      .contains(
                                                      pattern.toLowerCase())||
                                                  element.name!
                                                      .toLowerCase()
                                                      .contains(
                                                      pattern.toLowerCase())
                                              ).toList();
                                              if(filItems.isEmpty||pattern.isEmpty){
                                                selectedCreche=null;
                                                tempSelectedCreche=null;
                                                _crecheSearchcontroller.text='';
                                              }
                                              return filItems;
                                            } catch (e) {
                                              debugPrint('TypeAhead error: $e');
                                              return [];
                                            }
                                          },
                                          builder: (context, controller,
                                              focusNode) {
                                            return TextField(
                                                controller: controller,
                                                focusNode: focusNode,
                                                // autofocus: true,
                                                style:  Styles.black124,
                                                decoration: InputDecoration(
                                                  hintText: Global.returnTrLable(
                                                      translats, CustomText.Search, lng),
                                                  contentPadding: EdgeInsets
                                                      .all(10),
                                                  border: InputBorder.none,
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent),
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent),
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent),
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                )
                                            );
                                          },
                                          itemBuilder: (context, item) {
                                            return ListTile(
                                              title: Text(item.values!),
                                              subtitle: Text(item.name!),
                                            );
                                          },
                                          onSelected: (item) {
                                            selectedCreche = item;
                                            _crecheSearchcontroller.text = item.values ?? '';
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
                                          errorBuilder: (context,
                                              error) => const Text('Error!'),
                                          emptyBuilder: (context) =>
                                          const Text('No items found!'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    ],
                                  ),

                          DynamicCustomDropdownField(
                            hintText: Global.returnTrLable(
                                translats, CustomText.Selecthere, lng),
                            titleText: Global.returnTrLable(
                                translats, CustomText.CrecheStatus, lng),
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
                          height: 5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: CElevatedButton(
                                  text: Global.returnTrLable(
                                      translats, 'Clear', lng),
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
                                      translats, 'Search', lng),
                                  onPressed: () {
                                    // widget.selectedState=null;
                                    // widget.selectedDistrict=null;
                                    // widget.selectedBlock=null;
                                    // widget.selectedGramPanchayat=null;
                                    // widget.selectedVillage=null;
                                    // widget.selectedCreche=null;
                                    // widget.selectedCrecheStatus=null;
                                    // widget.selectedPartner=null;

                                    tempSelectedState = selectedState;
                                    tempSelectedDistrict = selectedDistrict;
                                    tempSelectedBlock = selectedBlock;
                                    tempSelectedGramPanchayat =
                                        selectedGramPanchayat;
                                    tempSelectedVillage = selectedVillage;
                                    tempSelectedCreche = selectedCreche;
                                    tempSelectedCrecheStatus =
                                        selectedCrecheStatus;
                                    tempSelectedPartner = selectedPartner;
                                    tempSelectedPhase = selectedPhase;
                                    Navigator.of(context).pop();
                                    callApiForDashboardApi();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom),
                      ]),
                ))),
        body: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
            child:
                // apiIsCall?
                Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DynamicCustomDropdownField(
                      hintText:
                          Global.returnTrLable(translats, CustomText.Year, lng),
                      items: getYearList(2020),
                      // titleText:
                      //     Global.returnTrLable(translats, CustomText.Year, lng),
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
                      // titleText:
                      //     Global.returnTrLable(translats, CustomText.Month, lng),
                      selectedItem: selectedMonth,
                      onChanged: (value) {
                        selectedMonth = value?.name;
                        callApiForDashboardApi();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${Global.returnTrLable(translats, CustomText.totalCount, lng)}: ${items.length}',
                    style: Styles.black12700,
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: (items.length > 0)
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: items.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {},
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                  width: double
                                      .infinity, // Takes full width of grid cell
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xff5A5A5A).withOpacity(0.2),
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                    color: Color(0xffF2F7FF),
                                    borderRadius: BorderRadius.circular(5.r),
                                    border:
                                        Border.all(color: Color(0xffE7F0FF)),
                                  ),
                                  child: callCardItem(items[index])),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(Global.returnTrLable(
                            translats, CustomText.NorecordAvailable, lng)),
                      ),
              ),
            ])
            //   :Center(
            // child: Text(Global.returnTrLable(translats,
            //     CustomText.NorecordAvailable, lng)))
            ),
      ),
    );
  }

  Future callApiForDashboardApi() async {
    var token = await Validate().readString(Validate.appToken);
    var network = await Validate().checkNetworkConnection();
    String? userName = null;
    String? usr = await Validate().readString(Validate.userName);
    String? pswd = await Validate().readString(Validate.Password);
    if (role == CustomText.crecheSupervisor) {
      userName = usr;
      usr = null;
      pswd = null;
    }
    if (network) {
      showLoaderDialog(context);
      var response = await DashboardReportApi().callDashboardCardDetailsApi(
          userName,
          widget.query_type,
          selectedYear,
          selectedMonth!,
          tempSelectedState,
          tempSelectedDistrict,
          tempSelectedBlock,
          tempSelectedGramPanchayat,
          tempSelectedVillage,
          tempSelectedCreche,
          tempSelectedCrecheStatus,
          tempSelectedPartner,
          tempSelectedPhase,
          token!,
          usr,
          pswd);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['data'] != null) {
          Navigator.pop(context);
          items = data['data'] as List;
          setState(() {
            // apiIsCall = true;
          });
        }else{
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(Global.returnTrLable(
                    translats, data['Error']??'No data found', lng))),
          );
        }
      } else if (response.statusCode == 401) {
        Navigator.pop(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  translats, CustomText.token_expired, lng))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
        return false;
      } else {
        Navigator.pop(context);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(translats, CustomText.ok, lng),
            false,
            context);
        return false;
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              translats, CustomText.nointernetconnectionavailable, lng),
          Global.returnTrLable(translats, CustomText.ok, lng),
          false,
          context);
    }
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
      CustomText.select_here,
      CustomText.DashBoardReport,
      CustomText.NorecordAvailable,
      CustomText.pleaseSelectMonth,
      CustomText.pleaseWait,
      CustomText.clear,
      CustomText.Cancel,
      CustomText.crecheNotAvailable,
      CustomText.childInfoNotAvailable,
      CustomText.Creches,
      CustomText.state,
      CustomText.District,
      CustomText.Block,
      CustomText.GramPanchayat,
      CustomText.Village,
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
                SizedBox(height: 10.h),
                Text(Global.returnTrLable(
                    translats, CustomText.pleaseWait, lng)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchStateList() async {
    tempSelectedState = widget.selectedState;
    tempSelectedDistrict = widget.selectedDistrict;
    tempSelectedBlock = widget.selectedBlock;
    tempSelectedGramPanchayat = widget.selectedGramPanchayat;
    tempSelectedVillage = widget.selectedVillage;
    tempSelectedCreche = widget.selectedCreche;
    tempSelectedPartner = widget.selectedPartner;
    tempSelectedCrecheStatus = widget.selectedCrecheStatus;
    tempSelectedPhase = widget.selectedPhase;
    _crecheSearchcontroller.text=(widget.selectedCreche!=null?widget.selectedCreche?.values!:'')!;
    states = await StateDataHelper().getTabStateList();
    district = await DistrictDataHelper().getTabDistrictList();
    block = await BlockDataHelper().getTabBlockList();
    gramPanchayat = await GramPanchayatDataHelper().getTabGramPanchayatList();
    villages = await VillageDataHelper().getTabVillageList();
    mstStates = Global.callSatates(states, lng);
    creches = await CrecheDataHelper().getCrecheResponce();
    phases = await OptionsModelHelper().callDayOfWeekMstCommonOptions('Phase',lng);
    mstcreches = await OptionsModelHelper().callCrechInOptionAll('Creche');
    crecheStatus =
        await OptionsModelHelper().getMstCommonOptions('Creche Status', lng);
    parterns =
        await OptionsModelHelper().getPartnerMstCommonOptions('Partner', {});
    if (parterns.isEmpty) {
      parterns = await OptionsModelHelper().getMstCommonOptions('Partner', lng);
    }
    if (mstStates.length == 1) {
      selectedState = mstStates.first;
      tempSelectedState = mstStates.first;
      mstDistrict = Global.callDistrict(district, lng, selectedState);
      mstcreches = Global.callFiltersCrechesByState(creches, lng, selectedState);
    }
    if (mstStates.length > 0 && widget.selectedState != null) {
      selectedState = widget.selectedState;
      tempSelectedState = widget.selectedState;
      mstDistrict = Global.callDistrict(district, lng, selectedState);
      mstcreches = Global.callFiltersCrechesByState(creches, lng, selectedState);
    }

    if (mstDistrict.length == 1) {
      selectedDistrict = mstDistrict.first;
      tempSelectedDistrict = mstDistrict.first;
      mstBlock = Global.callBlocks(block, lng, selectedDistrict);
      mstcreches = Global.callFiltersCrechesByDistric(creches, lng, selectedDistrict);
    }

    if (mstDistrict.length > 0 && widget.selectedDistrict != null) {
      selectedDistrict = widget.selectedDistrict;
      mstBlock = Global.callBlocks(block, lng, selectedDistrict);
      mstcreches = Global.callFiltersCrechesByDistric(creches, lng, selectedDistrict);
    }

    if (mstBlock.length == 1) {
      selectedBlock = mstBlock.first;
      tempSelectedBlock = mstBlock.first;
      mstGP = Global.callGramPanchyats(gramPanchayat, lng, selectedBlock);
      mstcreches = Global.callFiltersCrechesByBlock(creches, lng, selectedBlock);
    }
    if (mstBlock.length > 0 && widget.selectedBlock != null) {
      selectedBlock = widget.selectedBlock;
      tempSelectedBlock = widget.selectedBlock;
      mstGP = Global.callGramPanchyats(gramPanchayat, lng, selectedBlock);
      mstcreches = Global.callFiltersCrechesByBlock(creches, lng, selectedBlock);
    }

    if (mstGP.length == 1) {
      selectedGramPanchayat = mstGP.first;
      tempSelectedGramPanchayat = mstGP.first;
      mstVillage =
          Global.callFiltersVillages(villages, lng, selectedGramPanchayat);
      mstcreches = Global.callFiltersCrechesByGP(creches, lng, selectedGramPanchayat);
    }
    if (mstGP.length > 0 && widget.selectedGramPanchayat != null) {
      selectedGramPanchayat = widget.selectedGramPanchayat;
      mstVillage =
          Global.callFiltersVillages(villages, lng, selectedGramPanchayat);
      mstcreches = Global.callFiltersCrechesByGP(creches, lng, selectedGramPanchayat);
    }

    // if (mstVillage.length == 1) {
    //   selectedVillage = mstVillage.first;
    //   tempSelectedVillage = mstVillage.first;
    //   // mstcreches = Global.callFiltersCreches(creches, lng, selectedVillage);
    // }
    // if (mstVillage.length > 0 && widget.selectedVillage != null) {
    //   selectedVillage = widget.selectedVillage;
    //   // mstcreches = Global.callFiltersCreches(creches, lng, selectedVillage);
    // }

    if (mstcreches.length > 0 && widget.selectedCreche != null) {
      selectedCreche = widget.selectedCreche;
      tempSelectedCreche = widget.selectedCreche;
    }
    if (mstcreches.length ==  1&& widget.selectedCreche == null) {
      selectedCreche = widget.selectedCreche;
      tempSelectedCreche = widget.selectedCreche;
    }
    if (parterns.length > 0 && widget.selectedPartner != null) {
      selectedPartner = widget.selectedPartner;
    } else if (parterns.length == 1) {
      selectedPartner = parterns.first;
      tempSelectedPartner = parterns.first;
    }
    if (phases.length > 0 && widget.selectedPhase != null) {
      selectedPhase = widget.selectedPhase;
      tempSelectedPhase = widget.selectedPhase;
    }

    if (crecheStatus.length > 0 && widget.selectedCrecheStatus != null) {
      selectedCrecheStatus = widget.selectedCrecheStatus;
    } else if (crecheStatus.length == 1) {
      selectedCrecheStatus = crecheStatus.first;
      tempSelectedCrecheStatus = crecheStatus.first;
    } else if (crecheStatus.length > 1) {
      var items = crecheStatus
          .where((element) => element.name == 3.toString())
          .toList();
      if (items.isNotEmpty) {
        tempSelectedCrecheStatus = items.first;
        selectedCrecheStatus = items.first;
      }
    }

    setState(() {});
  }

  void cleaAllFilter() async {
    selectedState = null;
    selectedDistrict = null;
    selectedBlock = null;
    selectedGramPanchayat = null;
    selectedVillage = null;
    selectedCreche = null;
    selectedPartner = null;
    selectedCrecheStatus = null;
    selectedPhase = null;

    tempSelectedState = null;
    tempSelectedDistrict = null;
    tempSelectedBlock = null;
    tempSelectedGramPanchayat = null;
    tempSelectedVillage = null;
    tempSelectedCreche = null;
    tempSelectedPartner = null;
    tempSelectedCrecheStatus = null;
    tempSelectedPhase = null;

    widget.selectedState = null;
    widget.selectedDistrict = null;
    widget.selectedBlock = null;
    widget.selectedGramPanchayat = null;
    widget.selectedVillage = null;
    widget.selectedCreche = null;
    widget.selectedPartner = null;
    widget.selectedCrecheStatus = null;
    widget.selectedPhase = null;
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
    await callApiForDashboardApi();
  }

  Widget callCardItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: item.entries.map((entry) {
          if (entry.key.toLowerCase().contains('guid')) return SizedBox();
          return Row(
            children: [
              Expanded(
                child: Text(
                  entry.key,
                  style: Styles.blue125,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 5),
              Text(
                ':',
                textAlign: TextAlign.left,
                style: Styles.blue125,
              ),
              SizedBox(width: 5),
              Expanded(
                  child: Text(
                entry.value.toString(),
                textAlign: TextAlign.left,
                style: Styles.black3125,
                overflow: TextOverflow.ellipsis,
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}
