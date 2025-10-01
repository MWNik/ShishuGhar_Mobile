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
import '../../../database/helper/village_data_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/databasemodel/child_growth_responce_model.dart';
import '../../../model/databasemodel/tabBlock_model.dart';
import '../../../model/databasemodel/tabDistrict_model.dart';
import '../../../model/databasemodel/tabGramPanchayat_model.dart';
import '../../../model/databasemodel/tabVillage_model.dart';
import '../../../model/databasemodel/tabstate_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import 'dashboard_report_helper.dart';

class DashReportCardDetailForHomeScreen extends StatefulWidget {
  final String title;
  final String query_type;
  final OptionsModel month;
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

  DashReportCardDetailForHomeScreen(
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
      this.selectedPhase});

  @override
  _DashReportCardDetailState createState() => _DashReportCardDetailState();
}

class _DashReportCardDetailState extends State<DashReportCardDetailForHomeScreen> {
  List items = [];
  List growthChild = [];
  List<OptionsModel> years = [];
  List<OptionsModel> months = [];
  List<Translation> translats = [];
  String lng = 'en';
  OptionsModel? selectedMonth;
  String selectedYear = '${DateTime.now().year}';
  String? role;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  List<ChildGrowthMetaResponseModel> allAntroData =[];


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
    selectedMonth = months[crrentMonth - 1];
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
      CustomText.loading,
      CustomText.openingDate,
      CustomText.dateOfEnrollment,
      CustomText.currentAge,
      CustomText.IsEnrolled,
      CustomText.WeightForAgeZScore,
      CustomText.WeightForHeightZScore,
      CustomText.HeightForAgeZScore,
      CustomText.CrecheId,
      CustomText.CrecheName,
      CustomText.CrecheStatus,
      CustomText.openingDate,
      CustomText.Male,
      CustomText.Female,
      CustomText.State,
      CustomText.District,
      CustomText.Block,
      CustomText.GramPanchayat,
      CustomText.Phase,
      CustomText.ChildName,
      CustomText.DOB,
      CustomText.Gender,
      CustomText.ChildId,
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
        // endDrawer: SafeArea(
        //     child: Drawer(
        //         backgroundColor: Colors.white,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.only(),
        //         ),
        //         child: Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 15),
        //           child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.only(
        //                       left: 15, right: 15, top: 20, bottom: 10),
        //                   child: Row(
        //                     children: [
        //                       Image.asset(
        //                         "assets/filter_icon.png",
        //                         scale: 2.4,
        //                       ),
        //                       SizedBox(
        //                         width: 10.w,
        //                       ),
        //                       Text(
        //                         Global.returnTrLable(
        //                             translats, CustomText.Filter, lng),
        //                         style: Styles.labelcontrollerfont,
        //                       ),
        //                       Spacer(),
        //                       InkWell(
        //                           onTap: () async {
        //                             _scaffoldKey.currentState!.closeEndDrawer();
        //                           },
        //                           child: Image.asset(
        //                             'assets/cross.png',
        //                             color: Colors.grey,
        //                             scale: 4,
        //                           )),
        //                     ],
        //                   ),
        //                 ),
        //                 SizedBox(),
        //                 Expanded(
        //                     child: SingleChildScrollView(
        //                         controller: _scrollController,
        //                         physics: BouncingScrollPhysics(),
        //                         child: Column(
        //                             crossAxisAlignment:
        //                                 CrossAxisAlignment.start,
        //                             children: [
        //                               parterns.length > 0
        //                                   ? DynamicCustomDropdownField(
        //                                       hintText: Global.returnTrLable(
        //                                           translats,
        //                                           CustomText.Selecthere,
        //                                           lng),
        //                                       titleText: Global.returnTrLable(
        //                                           translats,
        //                                           CustomText.Partner,
        //                                           lng),
        //                                       isRequred: 0,
        //                                       items: parterns,
        //                                       selectedItem:
        //                                           selectedPartner != null
        //                                               ? selectedPartner?.name
        //                                               : null,
        //                                       onChanged: (value) {
        //                                         setState(() {
        //                                           selectedPartner = value;
        //                                         });
        //                                       },
        //                                     )
        //                                   : SizedBox(),
        //                               DynamicCustomDropdownField(
        //                                 hintText: Global.returnTrLable(
        //                                     translats,
        //                                     CustomText.select_here,
        //                                     lng),
        //                                 titleText: Global.returnTrLable(
        //                                     translats, CustomText.state, lng),
        //                                 items: mstStates,
        //                                 isRequred: 0,
        //                                 selectedItem: selectedState != null
        //                                     ? selectedState?.name
        //                                     : null,
        //                                 onChanged: (value) async {
        //                                   selectedState = value;
        //                                   selectedDistrict = null;
        //                                   selectedBlock = null;
        //                                   selectedGramPanchayat = null;
        //                                   // selectedVillage = null;
        //                                   // selectedCreche = null;
        //                                   mstDistrict = Global.callDistrict(
        //                                       district, lng, selectedState);
        //                                   if (mstDistrict.length == 1) {
        //                                     selectedDistrict =
        //                                         mstDistrict.first;
        //                                     mstBlock = Global.callBlocks(
        //                                         block, lng, selectedDistrict);
        //                                     mstcreches = Global
        //                                         .callFiltersCrechesByDistric(
        //                                             creches,
        //                                             lng,
        //                                             selectedDistrict);
        //                                     if (mstcreches.length == 1) {
        //                                       selectedCreche = mstcreches.first;
        //                                     }
        //                                     if (mstBlock.length == 1) {
        //                                       selectedBlock = mstBlock.first;
        //                                       mstGP = Global.callGramPanchyats(
        //                                           gramPanchayat,
        //                                           lng,
        //                                           selectedBlock);
        //                                       mstcreches = Global
        //                                           .callFiltersCrechesByBlock(
        //                                               creches,
        //                                               lng,
        //                                               selectedBlock);
        //                                       if (mstcreches.length == 1) {
        //                                         selectedCreche =
        //                                             mstcreches.first;
        //                                       }
        //                                       if (mstGP.length == 1) {
        //                                         selectedGramPanchayat =
        //                                             mstGP.first;
        //                                         mstcreches = Global
        //                                             .callFiltersCrechesByGP(
        //                                                 creches,
        //                                                 lng,
        //                                                 selectedGramPanchayat);
        //                                         if (mstcreches.length == 1) {
        //                                           selectedCreche =
        //                                               mstcreches.first;
        //                                         }
        //                                         // mstVillage = Global.callFiltersVillages(
        //                                         //     villages, lng, selectedGramPanchayat);
        //                                         //
        //                                         // if (mstVillage.length == 1) {
        //                                         //   selectedVillage = mstVillage.first;
        //                                         //   mstcreches = Global.callFiltersCreches(
        //                                         //       creches, lng, selectedVillage);
        //                                         // }
        //                                       }
        //                                     }
        //                                   } else {
        //                                     mstBlock = [];
        //                                     mstGP = [];
        //                                     mstVillage = [];
        //                                     mstcreches = Global
        //                                         .callFiltersCrechesByState(
        //                                             creches,
        //                                             lng,
        //                                             selectedState);
        //                                     if (mstcreches.length == 1) {
        //                                       selectedCreche = mstcreches.first;
        //                                     }
        //                                   }
        //                                   setState(() {
        //                                     // Update districtList based on selectedState
        //                                     // districtList = // data from database based on selectedState;
        //                                   });
        //                                 },
        //                               ),
        //                               DynamicCustomDropdownField(
        //                                 hintText: Global.returnTrLable(
        //                                     translats,
        //                                     CustomText.select_here,
        //                                     lng),
        //                                 titleText: Global.returnTrLable(
        //                                     translats,
        //                                     CustomText.District,
        //                                     lng),
        //                                 items: mstDistrict,
        //                                 isRequred: 0,
        //                                 selectedItem: selectedDistrict != null
        //                                     ? selectedDistrict?.name
        //                                     : null,
        //                                 onChanged: (value) async {
        //                                   selectedDistrict = value;
        //                                   selectedBlock = null;
        //                                   selectedGramPanchayat = null;
        //                                   // selectedVillage = null;
        //                                   // selectedCreche = null;
        //                                   mstBlock = Global.callBlocks(
        //                                       block, lng, selectedDistrict);
        //                                   if (mstBlock.length == 1) {
        //                                     selectedBlock = mstBlock.first;
        //                                     mstGP = Global.callGramPanchyats(
        //                                         gramPanchayat,
        //                                         lng,
        //                                         selectedBlock);
        //                                     mstcreches = Global
        //                                         .callFiltersCrechesByBlock(
        //                                             creches,
        //                                             lng,
        //                                             selectedBlock);
        //                                     if (mstcreches.length == 1) {
        //                                       selectedCreche = mstcreches.first;
        //                                     }
        //                                     if (mstGP.length == 1) {
        //                                       selectedGramPanchayat =
        //                                           mstGP.first;
        //                                       mstcreches =
        //                                           Global.callFiltersCrechesByGP(
        //                                               creches,
        //                                               lng,
        //                                               selectedGramPanchayat);
        //                                       if (mstcreches.length == 1) {
        //                                         selectedCreche =
        //                                             mstcreches.first;
        //                                       }
        //                                       // mstVillage = Global.callFiltersVillages(
        //                                       //     villages, lng, selectedGramPanchayat);
        //                                       //
        //                                       // if (mstVillage.length == 1) {
        //                                       //   selectedVillage = mstVillage.first;
        //                                       //   mstcreches = Global.callFiltersCreches(
        //                                       //       creches, lng, selectedVillage);
        //                                       // }
        //                                     }
        //                                   } else {
        //                                     mstGP = [];
        //                                     mstVillage = [];
        //                                     mstcreches = Global
        //                                         .callFiltersCrechesByDistric(
        //                                             creches,
        //                                             lng,
        //                                             selectedDistrict);
        //                                     if (mstcreches.length == 1) {
        //                                       selectedCreche = mstcreches.first;
        //                                     }
        //                                   }
        //                                   setState(() {
        //                                     // Update blockList based on selectedDistrict
        //                                     // blockList = // data from database based on selectedDistrict;
        //                                   });
        //                                 },
        //                               ),
        //                               DynamicCustomDropdownField(
        //                                 hintText: Global.returnTrLable(
        //                                     translats,
        //                                     CustomText.select_here,
        //                                     lng),
        //                                 titleText: Global.returnTrLable(
        //                                     translats, CustomText.Block, lng),
        //                                 items: mstBlock,
        //                                 isRequred: 0,
        //                                 selectedItem: selectedBlock != null
        //                                     ? selectedBlock?.name
        //                                     : null,
        //                                 onChanged: (value) async {
        //                                   selectedBlock = value;
        //                                   selectedGramPanchayat = null;
        //                                   // selectedVillage = null;
        //                                   // selectedCreche = null;
        //                                   mstGP = Global.callGramPanchyats(
        //                                       gramPanchayat,
        //                                       lng,
        //                                       selectedBlock);
        //                                   if (mstGP.length == 1) {
        //                                     selectedGramPanchayat = mstGP.first;
        //                                     mstcreches =
        //                                         Global.callFiltersCrechesByGP(
        //                                             creches,
        //                                             lng,
        //                                             selectedGramPanchayat);
        //                                     if (mstcreches.length == 1) {
        //                                       selectedCreche = mstcreches.first;
        //                                     }
        //                                     // mstVillage = Global.callFiltersVillages(
        //                                     //     villages, lng, selectedGramPanchayat);
        //                                     // if (mstVillage.length == 1) {
        //                                     //   selectedVillage = mstVillage.first;
        //                                     //   mstcreches = Global.callFiltersCreches(
        //                                     //       creches, lng, selectedVillage);
        //                                     // }
        //                                   } else {
        //                                     mstVillage = [];
        //                                     mstcreches = Global
        //                                         .callFiltersCrechesByBlock(
        //                                             creches,
        //                                             lng,
        //                                             selectedBlock);
        //                                     if (mstcreches.length == 1) {
        //                                       selectedCreche = mstcreches.first;
        //                                     }
        //                                   }
        //                                   setState(() {});
        //                                 },
        //                               ),
        //                               DynamicCustomDropdownField(
        //                                 isRequred: 0,
        //                                 titleText: Global.returnTrLable(
        //                                     translats,
        //                                     CustomText.GramPanchayat,
        //                                     lng),
        //                                 items: mstGP,
        //                                 hintText: Global.returnTrLable(
        //                                     translats,
        //                                     CustomText.Selecthere,
        //                                     lng),
        //                                 selectedItem:
        //                                     selectedGramPanchayat != null
        //                                         ? selectedGramPanchayat?.name
        //                                         : null,
        //                                 onChanged: (value) async {
        //                                   selectedGramPanchayat = value;
        //                                   selectedVillage = null;
        //                                   mstcreches =
        //                                       Global.callFiltersCrechesByGP(
        //                                           creches,
        //                                           lng,
        //                                           selectedGramPanchayat);
        //                                   if (mstcreches.length == 1) {
        //                                     selectedCreche = mstcreches.first;
        //                                   }
        //                                   // selectedCreche = null;
        //                                   // mstVillage = Global.callFiltersVillages(
        //                                   //     villages, lng, selectedGramPanchayat);
        //                                   // if (mstVillage.length == 1) {
        //                                   //   selectedVillage = mstVillage.first;
        //                                   //   if (mstVillage.length == 1) {
        //                                   //     selectedVillage = mstVillage.first;
        //                                   //     mstcreches = Global.callFiltersCreches(
        //                                   //         creches, lng, selectedVillage);
        //                                   //   }
        //                                   // }
        //                                   setState(() {});
        //                                 },
        //                               ),
        //                               // DynamicCustomDropdownField(
        //                               //   hintText: Global.returnTrLable(
        //                               //       translats, CustomText.Selecthere, lng),
        //                               //   titleText: Global.returnTrLable(
        //                               //       translats, CustomText.Village, lng),
        //                               //   isRequred: 0,
        //                               //   items: mstVillage,
        //                               //   selectedItem: selectedVillage != null
        //                               //       ? selectedVillage?.name
        //                               //       : null,
        //                               //   onChanged: (value) {
        //                               //     setState(() {
        //                               //       selectedVillage = value;
        //                               //       selectedCreche = null;
        //                               //       mstcreches = Global.callFiltersCreches(
        //                               //           creches, lng, selectedVillage);
        //                               //       if (mstcreches.length == 1) {
        //                               //         selectedCreche = mstcreches.first;
        //                               //       }
        //                               //     });
        //                               //   },
        //                               // ),
        //                               // DynamicCustomDropdownField(
        //                               //   hintText: Global.returnTrLable(
        //                               //       translats, CustomText.Selecthere, lng),
        //                               //   titleText: Global.returnTrLable(
        //                               //       translats, CustomText.Creches, lng),
        //                               //   isRequred: 0,
        //                               //   items: mstcreches,
        //                               //   selectedItem: selectedCreche != null
        //                               //       ? selectedCreche?.name
        //                               //       : null,
        //                               //   onChanged: (value) {
        //                               //     setState(() {
        //                               //       selectedCreche = value;
        //                               //     });
        //                               //   },
        //                               // ),
        //                               creches.length <= 1
        //                                   ? DynamicCustomDropdownField(
        //                                       hintText: Global.returnTrLable(
        //                                           translats,
        //                                           CustomText.Creches,
        //                                           lng),
        //                                       titleText: Global.returnTrLable(
        //                                           translats,
        //                                           CustomText.Creches,
        //                                           lng),
        //                                       isRequred: 0,
        //                                       items: mstcreches,
        //                                       selectedItem:
        //                                           selectedCreche != null
        //                                               ? selectedCreche?.name
        //                                               : null,
        //                                       onChanged: (value) {
        //                                         selectedCreche = value;
        //                                       },
        //                                     )
        //                                   : Column(
        //                                       crossAxisAlignment:
        //                                           CrossAxisAlignment.start,
        //                                       children: [
        //                                         Text(
        //                                           Global.returnTrLable(
        //                                               translats,
        //                                               CustomText.Creches,
        //                                               lng),
        //                                           style: Styles.black124,
        //                                         ),
        //                                         SizedBox(
        //                                           height: 5.h,
        //                                         ),
        //                                         Container(
        //                                           height: 35.h,
        //                                           decoration: BoxDecoration(
        //                                             color: Colors.white,
        //                                             border: Border.all(
        //                                                 color:
        //                                                     Color(0xffACACAC)),
        //                                             borderRadius:
        //                                                 BorderRadius.circular(
        //                                                     10.r),
        //                                           ),
        //                                           child: TypeAheadField<
        //                                               OptionsModel>(
        //                                             controller:
        //                                                 _crecheSearchcontroller,
        //                                             scrollController:
        //                                                 _scrollController,
        //                                             suggestionsCallback:
        //                                                 (pattern) async {
        //                                               try {
        //                                                 var filItems = mstcreches
        //                                                     .where((element) =>
        //                                                         element
        //                                                                     .values !=
        //                                                                 null &&
        //                                                             element.name !=
        //                                                                 null &&
        //                                                             element
        //                                                                 .values!
        //                                                                 .toLowerCase()
        //                                                                 .contains(pattern
        //                                                                     .toLowerCase()) ||
        //                                                         element.name!
        //                                                             .toLowerCase()
        //                                                             .contains(
        //                                                                 pattern
        //                                                                     .toLowerCase()))
        //                                                     .toList();
        //                                                 if (filItems.isEmpty ||
        //                                                     pattern.isEmpty) {
        //                                                   selectedCreche = null;
        //                                                   tempSelectedCreche =
        //                                                       null;
        //                                                   _crecheSearchcontroller
        //                                                       .text = '';
        //                                                 }
        //                                                 return filItems;
        //                                               } catch (e) {
        //                                                 debugPrint(
        //                                                     'TypeAhead error: $e');
        //                                                 return [];
        //                                               }
        //                                             },
        //                                             builder: (context,
        //                                                 controller, focusNode) {
        //                                               return TextField(
        //                                                   controller:
        //                                                       controller,
        //                                                   focusNode: focusNode,
        //                                                   // autofocus: true,
        //                                                   style:
        //                                                       Styles.black124,
        //                                                   decoration:
        //                                                       InputDecoration(
        //                                                     hintText: Global
        //                                                         .returnTrLable(
        //                                                             translats,
        //                                                             CustomText
        //                                                                 .Search,
        //                                                             lng),
        //                                                     contentPadding:
        //                                                         EdgeInsets.all(
        //                                                             10),
        //                                                     border: InputBorder
        //                                                         .none,
        //                                                     fillColor:
        //                                                         Colors.white,
        //                                                     filled: true,
        //                                                     focusedBorder:
        //                                                         OutlineInputBorder(
        //                                                       borderSide: BorderSide(
        //                                                           color: Colors
        //                                                               .transparent),
        //                                                       borderRadius:
        //                                                           BorderRadius
        //                                                               .circular(
        //                                                                   10),
        //                                                     ),
        //                                                     enabledBorder:
        //                                                         OutlineInputBorder(
        //                                                       borderSide: BorderSide(
        //                                                           color: Colors
        //                                                               .transparent),
        //                                                       borderRadius:
        //                                                           BorderRadius
        //                                                               .circular(
        //                                                                   10),
        //                                                     ),
        //                                                     disabledBorder:
        //                                                         OutlineInputBorder(
        //                                                       borderSide: BorderSide(
        //                                                           color: Colors
        //                                                               .transparent),
        //                                                       borderRadius:
        //                                                           BorderRadius
        //                                                               .circular(
        //                                                                   10),
        //                                                     ),
        //                                                   ));
        //                                             },
        //                                             itemBuilder:
        //                                                 (context, item) {
        //                                               return ListTile(
        //                                                 title:
        //                                                     Text(item.values!),
        //                                                 subtitle:
        //                                                     Text(item.name!),
        //                                               );
        //                                             },
        //                                             onSelected: (item) {
        //                                               selectedCreche = item;
        //                                               _crecheSearchcontroller
        //                                                       .text =
        //                                                   item.values ?? '';
        //                                               print('itm $item');
        //                                             },
        //                                             offset: Offset(0, 12),
        //                                             constraints: BoxConstraints(
        //                                                 maxHeight: 500),
        //                                             hideOnUnfocus: true,
        //                                             showOnFocus: true,
        //                                             hideWithKeyboard: false,
        //                                             loadingBuilder: (context) =>
        //                                                 const Text(
        //                                                     'Loading...'),
        //                                             errorBuilder: (context,
        //                                                     error) =>
        //                                                 const Text('Error!'),
        //                                             emptyBuilder: (context) =>
        //                                                 const Text(
        //                                                     'No items found!'),
        //                                           ),
        //                                         ),
        //                                         SizedBox(
        //                                           height: 10.h,
        //                                         ),
        //                                       ],
        //                                     ),
        //
        //                               DynamicCustomDropdownField(
        //                                 hintText: Global.returnTrLable(
        //                                     translats,
        //                                     CustomText.Selecthere,
        //                                     lng),
        //                                 titleText: Global.returnTrLable(
        //                                     translats,
        //                                     CustomText.CrecheStatus,
        //                                     lng),
        //                                 isRequred: 0,
        //                                 items: crecheStatus,
        //                                 selectedItem:
        //                                     selectedCrecheStatus != null
        //                                         ? selectedCrecheStatus?.name
        //                                         : null,
        //                                 onChanged: (value) {
        //                                   setState(() {
        //                                     selectedCrecheStatus = value;
        //                                   });
        //                                 },
        //                               ),
        //                               DynamicCustomDropdownField(
        //                                 hintText: Global.returnTrLable(
        //                                     translats,
        //                                     CustomText.Selecthere,
        //                                     lng),
        //                                 titleText: Global.returnTrLable(
        //                                     translats, CustomText.Phase, lng),
        //                                 isRequred: 0,
        //                                 items: phases,
        //                                 selectedItem: selectedPhase != null
        //                                     ? selectedPhase?.name
        //                                     : null,
        //                                 onChanged: (value) {
        //                                   setState(() {
        //                                     selectedPhase = value;
        //                                   });
        //                                 },
        //                               ),
        //                             ]))),
        //                 SizedBox(
        //                   height: 5.h,
        //                 ),
        //                 Padding(
        //                   padding: EdgeInsets.all(3.0),
        //                   child: Row(
        //                     children: [
        //                       Expanded(
        //                         child: CElevatedButton(
        //                           text: Global.returnTrLable(
        //                               translats, 'Clear', lng),
        //                           color: Color(0xffF26BA3),
        //                           onPressed: () {
        //                             Navigator.of(context).pop();
        //                             cleaAllFilter();
        //                           },
        //                         ),
        //                       ),
        //                       SizedBox(width: 4.w),
        //                       Expanded(
        //                         child: CElevatedButton(
        //                           text: Global.returnTrLable(
        //                               translats, 'Search', lng),
        //                           onPressed: () {
        //                             // widget.selectedState=null;
        //                             // widget.selectedDistrict=null;
        //                             // widget.selectedBlock=null;
        //                             // widget.selectedGramPanchayat=null;
        //                             // widget.selectedVillage=null;
        //                             // widget.selectedCreche=null;
        //                             // widget.selectedCrecheStatus=null;
        //                             // widget.selectedPartner=null;
        //
        //                             tempSelectedState = selectedState;
        //                             tempSelectedDistrict = selectedDistrict;
        //                             tempSelectedBlock = selectedBlock;
        //                             tempSelectedGramPanchayat =
        //                                 selectedGramPanchayat;
        //                             tempSelectedVillage = selectedVillage;
        //                             tempSelectedCreche = selectedCreche;
        //                             tempSelectedCrecheStatus =
        //                                 selectedCrecheStatus;
        //                             tempSelectedPartner = selectedPartner;
        //                             tempSelectedPhase = selectedPhase;
        //                             Navigator.of(context).pop();
        //                             callApiForDashboardApi();
        //                           },
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //                 SizedBox(
        //                     height: MediaQuery.of(context).viewInsets.bottom),
        //               ]),
        //         ))),
        body: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
            child:
                // apiIsCall?
                Column(children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: DynamicCustomDropdownField(
              //         hintText:
              //             Global.returnTrLable(translats, CustomText.Year, lng),
              //         items: getYearList(2020),
              //         // titleText:
              //         //     Global.returnTrLable(translats, CustomText.Year, lng),
              //         selectedItem: selectedYear,
              //         onChanged: (value) {
              //           setState(() {
              //             selectedYear = value!.name!;
              //             months =
              //                 getMonthList(Global.stringToInt(selectedYear));
              //             selectedMonth = null;
              //           });
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: DynamicCustomDropdownField(
              //         hintText: Global.returnTrLable(
              //             translats, CustomText.Month, lng),
              //         items: months,
              //         // titleText:
              //         //     Global.returnTrLable(translats, CustomText.Month, lng),
              //         selectedItem: selectedMonth?.name,
              //         onChanged: (value) {
              //           selectedMonth = value;
              //           callApiForDashboardApi();
              //         },
              //       ),
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         _scaffoldKey.currentState!.openEndDrawer();
              //       },
              //       child: Image.asset(
              //         "assets/filter_icon.png",
              //         scale: 2.4,
              //       ),
              //     ),
              //   ],
              // ),
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
                                  child: widgetType(items[index])),
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
                Text(Global.returnTrLable(
                    translats, CustomText.loading, lng)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future callApiForDashboardApi() async {
    String? stateId;
    String? districtId;
    String? blockId;
    String? gpId;
    String? villageId;
    String? crecheId;
    String? phase;
    String? partnerId;
    String? crecheStatus;

    showLoaderDialog(context);

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

    // no_of_creches
    if (widget.query_type == 'NoOfCreches') {
      items = await DashboardReportHelper().excuteCrecheCount(
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
      setState(() {});
    }

    //active_children
    if (widget.query_type == 'CurrentActiveChildren') {
      items = await DashboardReportHelper().excuteCurrentActiveChildren(
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
      setState(() {});
    }

    // no_creche_attendance_submitted
    if (widget.query_type == 'NoOfCrechesSubmittedAttendance') {
      items = await DashboardReportHelper().excuteNoOfCrecheSubmitedAttendence(
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
    }

    //no_of_creches_not_submitted_attendance
    if (widget.query_type == 'NoOfCrechesNotSubmittedAttendance') {
      items = await DashboardReportHelper()
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
    }

    //enrolled_children_this_month
    if (widget.query_type == 'ChildrenEnrolledThisMonth') {
      items = await DashboardReportHelper().excuteEnrolldCildThisMonth(
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
    }

    //exited_children_this_month
    if (widget.query_type == 'ChildrenExitedThisMonth') {
      items = await DashboardReportHelper().excuteExitCildThisMonth(
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
    }

    //current_eligible_children
    if (widget.query_type == 'CurrentEligibleChildren') {
      items = await DashboardReportHelper().excuteCurrentEligibleChild(
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
    }

    //anthro_data_submitted
    if (widget.query_type == 'AnthroDataSubmitted') {
      items = await DashboardReportHelper().excuteAnthroDataSubmitted(
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
    }

    //anthro_data_not_submitted
    if (widget.query_type == 'AnthroDataNotSubmitted') {
      items = await DashboardReportHelper().excuteAnthroDataNotSubmitted(
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
    }

    //child_measurement_taken
    if (widget.query_type == 'ChildrenMeasurementTaken') {
      var childItems = await DashboardReportHelper().excuteChildrenMeasermentTaken(
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
      var submitedId='';
      for (int i = 0; i < childItems.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${childItems[i]['childenrollguid']}'";
        }else submitedId="'${childItems[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }
    }

    //child_measurement_not_taken
    if (widget.query_type == 'ChildrenMeasurementNotTaken') {
      items = await DashboardReportHelper().excuteChildrenMeasermentNotTaken(
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
    }

    //measurement_data_not_submitted
    if (widget.query_type == 'AnthroDataNotSubmitted') {
      items = await DashboardReportHelper().excuteAnthroDataNotSubmitted(
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
    }

    //measurement_data_submitted
    if (widget.query_type == 'AnthroDataSubmitted') {
      items = await DashboardReportHelper().excuteAnthroDataSubmitted(
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
    }

    //moderately_underweight
    if (widget.query_type == 'ModeratelyUnderweight') {
      growthChild = await DashboardReportHelper().excuteModerateUnderWeight(
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

      var submitedId='';
      for (int i = 0; i < growthChild.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${growthChild[i]['childenrollguid']}'";
        }else submitedId="'${growthChild[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }
    }

    //Severely underweight
    if (widget.query_type == 'SeverelyUnderweight') {
      growthChild = await DashboardReportHelper().excuteSeverUnderWeight(
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

      var submitedId='';
      for (int i = 0; i < growthChild.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${growthChild[i]['childenrollguid']}'";
        }else submitedId="'${growthChild[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }
    }

    //Moderately wasted
    if (widget.query_type == 'ModeratelyWasted') {
      growthChild = await DashboardReportHelper().excuteModerateWastage(
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

      var submitedId='';
      for (int i = 0; i < growthChild.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${growthChild[i]['childenrollguid']}'";
        }else submitedId="'${growthChild[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }

    }

    //Severely wasted
    if (widget.query_type == 'SeverelyWasted') {
      growthChild = await DashboardReportHelper().excuteSeverelyWasted(
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

      var submitedId='';
      for (int i = 0; i < growthChild.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${growthChild[i]['childenrollguid']}'";
        }else submitedId="'${growthChild[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }
    }

    //Moderately Stunted
    if (widget.query_type == 'ModeratelyStunted') {
      growthChild = await DashboardReportHelper().excuteModerateStunted(
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

      var submitedId='';
      for (int i = 0; i < growthChild.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${growthChild[i]['childenrollguid']}'";
        }else submitedId="'${growthChild[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }
    }

    //Severely stunted
    if (widget.query_type == 'SeverelyStunted') {
      growthChild = await DashboardReportHelper().excuteSeverelyStunted(
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

      var submitedId='';
      for (int i = 0; i < growthChild.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${growthChild[i]['childenrollguid']}'";
        }else submitedId="'${growthChild[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }
    }

    //Growth faltering 2
    if (widget.query_type == 'Growthfaltering1') {
      allAntroData=await ChildGrowthResponseHelper().allAnthormentry();
      growthChild = await DashboardReportHelper().excuteGF1Anthro(
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
              Global.stringToInt(selectedMonth?.name)),allAntroData:allAntroData);

      var submitedId='';
      for (int i = 0; i < growthChild.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${growthChild[i]['childenrollguid']}'";
        }else submitedId="'${growthChild[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }
    }


      //Growth faltering 1
    if (widget.query_type == 'Growthfaltering2') {
      allAntroData=await ChildGrowthResponseHelper().allAnthormentry();
      growthChild = await DashboardReportHelper().excuteGF2Antro(
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
              Global.stringToInt(selectedMonth?.name)),allAntroData:allAntroData);

      var submitedId='';
      for (int i = 0; i < growthChild.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${growthChild[i]['childenrollguid']}'";
        }else submitedId="'${growthChild[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }
    }

    //Red flag
    if (widget.query_type == 'RedFlagChildren') {
      allAntroData=await ChildGrowthResponseHelper().allAnthormentry();
      growthChild = await DashboardReportHelper().excuteRedFlagAnthro(
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
              Global.stringToInt(selectedMonth?.name)),allAntroData:allAntroData);

      var submitedId='';
      for (int i = 0; i < growthChild.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${growthChild[i]['childenrollguid']}'";
        }else submitedId="'${growthChild[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }

    }

    //Children at risk
    if (widget.query_type == 'childrenAtRisk') {
      allAntroData=await ChildGrowthResponseHelper().allAnthormentry();
      var mesurmentTakenChild=await DashboardReportHelper()
          .excuteChildrenMeasermentTaken(stateId: stateId,
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
      growthChild = await DashboardReportHelper().excuteChildrenAtRiskMeasurmentTakenAllAnthro(
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
              Global.stringToInt(selectedMonth?.name)),
          allAntroData:allAntroData,
          childrenMeasurementTaken:mesurmentTakenChild
      );

      var submitedId='';
      for (int i = 0; i < growthChild.length; i++) {
        if(Global.validString(submitedId)){
          submitedId="$submitedId,'${growthChild[i]['childenrollguid']}'";
        }else submitedId="'${growthChild[i]['childenrollguid']}'";
      }
      if(Global.validString(submitedId)) {
        items = await DashboardReportHelper().excuteGetChildrenByGUIDES(
            childIdes: submitedId);
      }

    }

    //Children eligble but not enrolled
    if (widget.query_type == 'NotEligbleButNotEnrolled') {
      items=await DashboardReportHelper()
          .excuteCurrentEligibleButNotEnrlolledChild(stateId: stateId,
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

    }

    setState(() {});
    Navigator.pop(context);

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
    _crecheSearchcontroller.text =
        (widget.selectedCreche != null ? widget.selectedCreche?.values! : '')!;
    states = await StateDataHelper().getTabStateList();
    district = await DistrictDataHelper().getTabDistrictList();
    block = await BlockDataHelper().getTabBlockList();
    gramPanchayat = await GramPanchayatDataHelper().getTabGramPanchayatList();
    villages = await VillageDataHelper().getTabVillageList();
    mstStates = Global.callSatates(states, lng);
    creches = await CrecheDataHelper().getCrecheResponce();
    phases =
        await OptionsModelHelper().callDayOfWeekMstCommonOptions('Phase', lng);
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
      mstcreches =
          Global.callFiltersCrechesByState(creches, lng, selectedState);
    }
    if (mstStates.length > 0 && widget.selectedState != null) {
      selectedState = widget.selectedState;
      tempSelectedState = widget.selectedState;
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

    if (mstDistrict.length > 0 && widget.selectedDistrict != null) {
      selectedDistrict = widget.selectedDistrict;
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
    if (mstBlock.length > 0 && widget.selectedBlock != null) {
      selectedBlock = widget.selectedBlock;
      tempSelectedBlock = widget.selectedBlock;
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
    if (mstGP.length > 0 && widget.selectedGramPanchayat != null) {
      selectedGramPanchayat = widget.selectedGramPanchayat;
      mstVillage =
          Global.callFiltersVillages(villages, lng, selectedGramPanchayat);
      mstcreches =
          Global.callFiltersCrechesByGP(creches, lng, selectedGramPanchayat);
    }

    if (mstcreches.length > 0 && widget.selectedCreche != null) {
      selectedCreche = widget.selectedCreche;
      tempSelectedCreche = widget.selectedCreche;
    }
    if (mstcreches.length == 1 && widget.selectedCreche == null) {
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

  Widget widgetType(Map<String, dynamic> item) {
    if (widget.query_type == 'NoOfCreches') {
      return callCrecheItem(item);
    } else if (widget.query_type == 'CurrentActiveChildren'||
        widget.query_type == 'RedFlagChildren') {
      return callCurrentActiveChildItem(item);
    } else if (widget.query_type == 'NoOfCrechesSubmittedAttendance') {
      return callCrecheItem(item);
    } else if (widget.query_type == 'NoOfCrechesNotSubmittedAttendance') {
      return callCrecheItem(item);
    } else if (widget.query_type == 'CurrentEligibleChildren') {
      return callCurrentEligibleChildItem(item);
    } else if (widget.query_type == 'ChildrenEnrolledThisMonth') {
      return callCurrentActiveChildItem(item);
    } else if (widget.query_type == 'ChildrenExitedThisMonth') {
      return callExtedChildChildItem(item);
    } else if (widget.query_type == 'SeverelyUnderweight'||
        widget.query_type =='ModeratelyUnderweight') {
      return callUnderweightItem(item);
    } else if (widget.query_type == 'childrenAtRisk'||
        widget.query_type == 'SeverelyWasted'||
        widget.query_type == 'ModeratelyWasted') {
      return callWastedtItem(item);
    } else if (widget.query_type == 'ModeratelyStunted'||
        widget.query_type == 'SeverelyStunted') {
      return callStuntedItem(item);
    } else if (widget.query_type == 'Growthfaltering1'||
        widget.query_type == 'Growthfaltering2') {
      return callGrowthFaltringItem(item);
    } else if (widget.query_type == 'ChildrenMeasurementNotTaken'
        ||widget.query_type == 'ChildrenMeasurementTaken') {
      return callCurrentActiveChildItem(item);
    } else if (widget.query_type == 'AnthroDataNotSubmitted'
        ||widget.query_type == 'AnthroDataSubmitted') {
      return callCrecheItem(item);
    } else if (widget.query_type == 'NotEligbleButNotEnrolled') {
      return callCurrentEligibleChildItem(item);
    } else
      return SizedBox();
  }

  Widget callCrecheItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.CrecheId, lng),
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
              Global.getItemValues(item['crecheData'], 'creche_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
              Global.returnTrLable(
              translats,CustomText.CrecheName,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
    Global.returnTrLable(
    translats,CustomText.CrecheStatus,lng),
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
              getCrecheStatusName(
                  Global.getItemValues(item['crecheData'], 'creche_status_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
          Global.returnTrLable(
    translats,CustomText.openingDate,lng),
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
              Validate().displeDateFormate(Global.getItemValues(
                  item['crecheData'], 'creche_opening_date')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
    Global.returnTrLable(
    translats,CustomText.Partner,lng),
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
              getPartnerName(
                  Global.getItemValues(item['crecheData'], 'partner_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
    Global.returnTrLable(
    translats,CustomText.State,lng),
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
              getStateName(
                  Global.getItemValues(item['crecheData'], 'state_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
    Global.returnTrLable(
    translats,CustomText.District,lng),
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
              getDistrictName(
                  Global.getItemValues(item['crecheData'], 'district_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
          Global.returnTrLable(
    translats,CustomText.Block,lng),
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
              getBlockName(
                  Global.getItemValues(item['crecheData'], 'block_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
    Global.returnTrLable(
    translats,CustomText.GramPanchayat,lng),
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
              getGPName(Global.getItemValues(item['crecheData'], 'gp_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        )
      ]),
    );
  }

  Widget callCurrentActiveChildItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildId,lng),
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
              Global.getItemValues(item['responces'], 'child_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildName,lng),
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
              Global.getItemValues(item['responces'], 'child_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.DOB,lng),
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
                Global.validString(Global.getItemValues(item['responces'], 'child_dob'))?Validate().displeDateFormate(
                  Global.getItemValues(item['responces'], 'child_dob')):'',
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Gender,lng),
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
                  Global.getItemValues(item['responces'], 'gender_id') == '1'
                      ? Global.returnTrLable(
                      translats,CustomText.Male,lng)
                      :  Global.getItemValues(item['responces'], 'gender_id') == '2'?Global.returnTrLable(
                      translats,CustomText.Female,lng):Global.returnTrLable(
                      translats,CustomText.other,lng),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.dateOfEnrollment,lng),
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
              Validate().displeDateFormate(Global.getItemValues(
                  item['responces'], 'date_of_enrollment')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheId,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheName,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Partner,lng),
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
              getPartnerName(
                  Global.getItemValues(item['crecheData'], 'partner_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.State,lng),
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
              getStateName(
                  Global.getItemValues(item['crecheData'], 'state_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.District,lng),
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
              getDistrictName(
                  Global.getItemValues(item['crecheData'], 'district_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.Block, lng),
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
              getBlockName(
                  Global.getItemValues(item['crecheData'], 'block_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.GramPanchayat, lng),
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
              getGPName(Global.getItemValues(item['crecheData'], 'gp_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        )
      ]),
    );
  }

  Widget callExtedChildChildItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildId,lng),
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
              Global.getItemValues(item['responces'], 'child_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildName,lng),
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
              Global.getItemValues(item['responces'], 'child_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.DOB,lng),
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
              Validate().displeDateFormate(
                  Global.getItemValues(item['responces'], 'child_dob')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Gender,lng),
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
                  Global.getItemValues(item['responces'], 'gender_id') == '1'
                      ? Global.returnTrLable(
                      translats,CustomText.Male,lng)
                      :  Global.getItemValues(item['responces'], 'gender_id') == '2'?Global.returnTrLable(
                      translats,CustomText.Female,lng):Global.returnTrLable(
                      translats,CustomText.other,lng),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.dateOfEnrollment,lng),
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
              Validate().displeDateFormate(Global.getItemValues(
                  item['responces'], 'date_of_enrollment')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                CustomText.DateOfExit,
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
              Global.validString(
                      Global.getItemValues(item['responces'], 'date_of_exit'))
                  ? Validate().displeDateFormate(
                      Global.getItemValues(item['responces'], 'date_of_exit'))
                  : '',
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheId,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheName,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Partner,lng),
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
              getPartnerName(
                  Global.getItemValues(item['crecheData'], 'partner_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.State,lng),
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
              getStateName(
                  Global.getItemValues(item['crecheData'], 'state_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.District,lng),
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
              getDistrictName(
                  Global.getItemValues(item['crecheData'], 'district_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.Block, lng),
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
              getBlockName(
                  Global.getItemValues(item['crecheData'], 'block_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.GramPanchayat, lng),
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
              getGPName(Global.getItemValues(item['crecheData'], 'gp_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        )
      ]),
    );
  }

  Widget callWastedtItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildId,lng),
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
                  Global.getItemValues(item['responces'], 'child_id'),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildName,lng),
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
                  Global.getItemValues(item['responces'], 'child_name'),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.DOB,lng),
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
                  Validate().displeDateFormate(
                      Global.getItemValues(item['responces'], 'child_dob')),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Gender,lng),
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
                  Global.getItemValues(item['responces'], 'gender_id') == '1'
                      ? Global.returnTrLable(
                      translats,CustomText.Male,lng)
                      :  Global.getItemValues(item['responces'], 'gender_id') == '2'?
                  Global.returnTrLable(
                      translats,CustomText.Female,lng):Global.returnTrLable(
                      translats,CustomText.other,lng),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.dateOfEnrollment,lng),
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
                  Validate().displeDateFormate(Global.getItemValues(
                      item['responces'], 'date_of_enrollment')),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.WeightForHeightZScore,lng),
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
                  zScroreData('weight_for_height_zscore', Global.getItemValues(item['responces'], 'childenrollguid')),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheId,lng),
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
                  Global.getItemValues(item['crecheData'], 'creche_id'),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheName,lng),
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
                  Global.getItemValues(item['crecheData'], 'creche_name'),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Partner,lng),
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
                  getPartnerName(
                      Global.getItemValues(item['crecheData'], 'partner_id')),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.State,lng),
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
                  getStateName(
                      Global.getItemValues(item['crecheData'], 'state_id')),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.District,lng),
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
                  getDistrictName(
                      Global.getItemValues(item['crecheData'], 'district_id')),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.Block, lng),
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
                  getBlockName(
                      Global.getItemValues(item['crecheData'], 'block_id')),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.GramPanchayat, lng),
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
                  getGPName(Global.getItemValues(item['crecheData'], 'gp_id')),
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        )
      ]),
    );
  }

  Widget callUnderweightItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildId,lng),
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
              Global.getItemValues(item['responces'], 'child_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildName,lng),
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
              Global.getItemValues(item['responces'], 'child_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.DOB,lng),
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
              Validate().displeDateFormate(
                  Global.getItemValues(item['responces'], 'child_dob')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Gender,lng),
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
                  Global.getItemValues(item['responces'], 'gender_id') == '1'
                      ? Global.returnTrLable(
                      translats,CustomText.Male,lng)
                      :  Global.getItemValues(item['responces'], 'gender_id') == '2'?Global.returnTrLable(
                      translats,CustomText.Female,lng):Global.returnTrLable(
                      translats,CustomText.other,lng),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.dateOfEnrollment,lng),
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
              Validate().displeDateFormate(Global.getItemValues(
                  item['responces'], 'date_of_enrollment')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.WeightForAgeZScore,lng),
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
              zScroreData('weight_for_age_zscore', Global.getItemValues(item['responces'], 'childenrollguid')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheId,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheName,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Partner,lng),
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
              getPartnerName(
                  Global.getItemValues(item['crecheData'], 'partner_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.State,lng),
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
              getStateName(
                  Global.getItemValues(item['crecheData'], 'state_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.District,lng),
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
              getDistrictName(
                  Global.getItemValues(item['crecheData'], 'district_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.Block, lng),
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
              getBlockName(
                  Global.getItemValues(item['crecheData'], 'block_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.GramPanchayat, lng),
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
              getGPName(Global.getItemValues(item['crecheData'], 'gp_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        )
      ]),
    );
  }

  Widget callStuntedItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildId,lng),
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
              Global.getItemValues(item['responces'], 'child_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildName,lng),
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
              Global.getItemValues(item['responces'], 'child_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.DOB,lng),
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
              Validate().displeDateFormate(
                  Global.getItemValues(item['responces'], 'child_dob')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Gender,lng),
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
                  Global.getItemValues(item['responces'], 'gender_id') == '1'
                      ? Global.returnTrLable(
                      translats,CustomText.Male,lng)
                      :  Global.getItemValues(item['responces'], 'gender_id') == '2'?Global.returnTrLable(
                      translats,CustomText.Female,lng):Global.returnTrLable(
                      translats,CustomText.other,lng),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.dateOfEnrollment,lng),
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
              Validate().displeDateFormate(Global.getItemValues(
                  item['responces'], 'date_of_enrollment')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.HeightForAgeZScore,lng),
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
              zScroreData('height_for_age_zscore', Global.getItemValues(item['responces'], 'childenrollguid')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheId,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheName,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Partner,lng),
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
              getPartnerName(
                  Global.getItemValues(item['crecheData'], 'partner_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.State,lng),
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
              getStateName(
                  Global.getItemValues(item['crecheData'], 'state_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.District,lng),
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
              getDistrictName(
                  Global.getItemValues(item['crecheData'], 'district_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.Block, lng),
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
              getBlockName(
                  Global.getItemValues(item['crecheData'], 'block_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.GramPanchayat, lng),
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
              getGPName(Global.getItemValues(item['crecheData'], 'gp_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        )
      ]),
    );
  }

  Widget callGrowthFaltringItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildId,lng),
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
              Global.getItemValues(item['responces'], 'child_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildName,lng),
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
              Global.getItemValues(item['responces'], 'child_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.DOB,lng),
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
              Validate().displeDateFormate(
                  Global.getItemValues(item['responces'], 'child_dob')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Gender,lng),
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
              Global.getItemValues(item['responces'], 'gender_id') == '1'
                  ? Global.returnTrLable(
                  translats,CustomText.Male,lng)
                  :  Global.getItemValues(item['responces'], 'gender_id') == '2'?Global.returnTrLable(
                  translats,CustomText.Female,lng):Global.returnTrLable(
                  translats,CustomText.other,lng),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.dateOfEnrollment,lng),
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
              Validate().displeDateFormate(Global.getItemValues(
                  item['responces'], 'date_of_enrollment')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.HeightForAgeZScore,lng),
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
              zScroreData('height_for_age_zscore', Global.getItemValues(item['responces'], 'childenrollguid')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.WeightForHeightZScore,lng),
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
              zScroreData('weight_for_height_zscore', Global.getItemValues(item['responces'], 'childenrollguid')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.WeightForAgeZScore,lng),
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
              zScroreData('weight_for_age_zscore', Global.getItemValues(item['responces'], 'childenrollguid')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheId,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheName,lng),
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
              Global.getItemValues(item['crecheData'], 'creche_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Partner,lng),
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
              getPartnerName(
                  Global.getItemValues(item['crecheData'], 'partner_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.State,lng),
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
              getStateName(
                  Global.getItemValues(item['crecheData'], 'state_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.District,lng),
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
              getDistrictName(
                  Global.getItemValues(item['crecheData'], 'district_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.Block, lng),
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
              getBlockName(
                  Global.getItemValues(item['crecheData'], 'block_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.GramPanchayat, lng),
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
              getGPName(Global.getItemValues(item['crecheData'], 'gp_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        )
      ]),
    );
  }

  Widget callCurrentEligibleChildItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.ChildName,lng),
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
              Global.getItemValues(item['responces'], 'child_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.DOB,lng),
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
              Validate().displeDateFormate(
                  Global.getItemValues(item['responces'], 'child_dob')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.currentAge,lng),
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
                  '${currentAgeInMonth(Global.getItemValues(item['responces'],'child_dob'))}',
                  textAlign: TextAlign.left,
                  style: Styles.black3125,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Gender,lng),
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
                  Global.getItemValues(item['responces'], 'gender_id') == '1'
                      ? Global.returnTrLable(
                      translats,CustomText.Male,lng)
                      :  Global.getItemValues(item['responces'], 'gender_id') == '2'?Global.returnTrLable(
                      translats,CustomText.Female,lng):Global.returnTrLable(
                      translats,CustomText.other,lng),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.IsEnrolled,lng),
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
                item['enrolledChildResponce']!=null?CustomText.Yes:CustomText.No,
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheId,lng),
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
                  Global.getItemValues(item['crecheData'], 'creche_id'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.CrecheName,lng),
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
                  Global.getItemValues(item['crecheData'], 'creche_name'),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.Partner,lng),
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
              getPartnerName(
                  Global.getItemValues(item['crecheData'], 'partner_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.State,lng),
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
              getStateName(
                  Global.getItemValues(item['crecheData'], 'state_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats,CustomText.District,lng),
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
              getDistrictName(
                  Global.getItemValues(item['crecheData'], 'district_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.Block, lng),
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
              getBlockName(
                  Global.getItemValues(item['crecheData'], 'block_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                Global.returnTrLable(
                    translats, CustomText.GramPanchayat, lng),
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
              getGPName(Global.getItemValues(item['crecheData'], 'gp_id')),
              textAlign: TextAlign.left,
              style: Styles.black3125,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        )
      ]),
    );
  }

  String getCrecheStatusName(String id) {
    String returnValue = '';
    var items = crecheStatus.where((element) => element.name == id).toList();
    if (items.isNotEmpty) {
      returnValue = items.first.values!;
    }
    return returnValue;
  }

  String getGPName(String id) {
    String returnValue = '';
    var items = gramPanchayat
        .where((element) => Global.intToString(element.name) == id)
        .toList();
    if (items.isNotEmpty) {
      returnValue = Global.languageWise(
          lng, items.first.value, items.first.gp_hi, items.first.gp_od);
    }
    return returnValue;
  }

  String getBlockName(String id) {
    String returnValue = '';
    var items = block
        .where((element) => Global.intToString(element.name) == id)
        .toList();
    if (items.isNotEmpty) {
      returnValue = Global.languageWise(
          lng, items.first.value, items.first.block_hi, items.first.block_od);
    }
    return returnValue;
  }

  String getDistrictName(String id) {
    String returnValue = '';
    var items = district
        .where((element) => Global.intToString(element.name) == id)
        .toList();
    if (items.isNotEmpty) {
      returnValue = Global.languageWise(lng, items.first.value,
          items.first.district_hi, items.first.district_od);
    }
    return returnValue;
  }

  String getStateName(String id) {
    String returnValue = '';
    var items = states
        .where((element) => Global.intToString(element.name) == id)
        .toList();
    if (items.isNotEmpty) {
      returnValue = Global.languageWise(
          lng, items.first.value, items.first.state_hi, items.first.state_od);
    }
    return returnValue;
  }

  String getPartnerName(String id) {
    String returnValue = '';
    var items = parterns.where((element) => element.name == id).toList();
    if (items.isNotEmpty) {
      returnValue = items.first.values!;
    }
    return returnValue;
  }

  int currentAgeInMonth(String childDOB){
    var dob = Validate().stringToDateNull(childDOB);
    int calucalteDate = 0;
    if (dob != null) {
      calucalteDate =
          Validate().calculateAgeInMonths(dob);
    }
    return calucalteDate;
  }

  String zScroreData(String key,childGuid){
    String returnValue='';
    var items = growthChild
        .where((element) => element['childenrollguid'] == childGuid)
        .toList();
    if(items.isNotEmpty){
      returnValue=items.first[key];
    }
    return returnValue;
  }


}
