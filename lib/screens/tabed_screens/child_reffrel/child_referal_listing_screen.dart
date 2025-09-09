import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shishughar/database/helper/anthromentory/child_growth_response_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/child_referral_response_model.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/custom_textfield.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown_for_filter.dart';
import '../../../database/helper/backdated_configiration_helper.dart';
import '../../../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/databasemodel/backdated_configiration_model.dart';
import '../../../model/databasemodel/child_growth_responce_model.dart';
import '../../../style/styles.dart';
import 'child_refferal_tab_screen.dart';

class ChildReferralListingScreen extends StatefulWidget {
  String tabTitle;

  ChildReferralListingScreen({
    super.key,
    required this.tabTitle,
  });

  @override
  State<ChildReferralListingScreen> createState() =>
      _ChildReferralListingScreenState();
}

class _ChildReferralListingScreenState
    extends State<ChildReferralListingScreen> {
  List<ChildGrowthMetaResponseModel> childAnthro = [];
  List<ChildReferralTabResponceModel> followUpData = [];
  List<CresheDatabaseResponceModel> crecheData = [];

  List<EnrolledExitChildResponceModel> enrolledChildrenList = [];
  List<ChildReferralTabResponceModel> reffrelChildrenList = [];
  Map<String, dynamic> growthGuidByDate = {};
  Map<String, dynamic> filteredGrowthGuidByDate = {};
  List<String> childrenIdList = [];
  List<Translation> translats = [];
  DateTime? minDate;
  String lng = 'en';
  TextEditingController Searchcontroller = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OptionsModel> creches = [];
  String? selectedCreche;
  var applicableDate = Validate().stringToDate("2024-12-31");
  var now = DateTime.parse(Validate().currentDate());
  BackdatedConfigirationModel? backdatedConfigirationModel;
  final TextEditingController _creceSearchcontroller = TextEditingController();
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    var date = await Validate().readString(Validate.date);
    applicableDate = Validate().stringToDate(date ?? "2024-12-31");
    backdatedConfigirationModel = await BackdatedConfigirationHelper()
        .excuteBackdatedConfigirationModel(CustomText.ChildReffrel);

    translats.clear();
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.ChildId,
      CustomText.Creche_Name,
      CustomText.schduleDate,
      CustomText.Filter,
      CustomText.Creches,
      CustomText.clear
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    crecheData = await CrecheDataHelper().getCrecheResponce();
    creches = await OptionsModelHelper().callCrechInOptionAll('Creche');

    await fetchAllAnthroRecords();
  }

  Future<void> allChildWithlatest(
      List<ChildGrowthMetaResponseModel> childAnthro) async {
    if (childAnthro.isNotEmpty) {
      Map<String, dynamic> allAnthroWithChild = {};
      childAnthro.forEach((element) {
        allAnthroWithChild[
                Global.getItemValues(element.responces!, 'measurement_date')] =
            jsonDecode(element.responces!)['anthropromatic_details'];
      });
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');

      // Sort the entries by date keys
      List<MapEntry<String, dynamic>> sortedEntries = allAnthroWithChild.entries
          .toList()
        ..sort((e1, e2) =>
            dateFormat.parse(e1.key).compareTo(dateFormat.parse(e2.key)));

      // Create a new map from the sorted entries
      Map<String, dynamic> sortedMap = Map.fromEntries(sortedEntries);
      Map<String, dynamic> childWith = {};
      var entries = sortedMap.entries.toList();
      // sortedMap.forEach((key, value) async {
      for (int i = 0; i < entries.length; i++) {
        var key = entries[i].key;
        var value = entries[i].value;
        List<dynamic> childItem = value as List<dynamic>;
        for (int i = 0; i < childItem.length; i++) {
          var element = childItem[i];
          if(Global.stringToInt(element['do_you_have_height_weight'].toString()) == 1 ) {
            var gfReco =
            await checkSUWCondition(element['childenrollguid'], key, element);
            if (Global.stringToDouble(
                element['weight_for_height'].toString()) ==
                1 ||
                Global.validString(gfReco) ||
                Global.stringToInt(
                    element['any_medical_major_illness'].toString()) ==
                    1 ||
                Global.stringToDouble(element['weight_for_age'].toString()) ==
                    1) {
              Map<String, dynamic> growthData = {};
              growthData['childenrollguid'] = element['childenrollguid'];
              growthData['cgmguid'] = element['cgmguid'];
              growthData['measurement_taken_date'] =
              element['measurement_taken_date'];
              var category = '';
              if (Global.stringToInt(
                  element['any_medical_major_illness'].toString()) ==
                  1) {
                category = Global.validString(category)
                    ? '$category,Major Illness'
                    : 'Major Illness';
                // growthData['category'] = 'Major Illness';
              }
              if (Global.stringToDouble(element['weight_for_age'].toString()) ==
                  1 ||
                  Global.stringToDouble(
                      element['weight_for_height'].toString()) ==
                      1) {
                // growthData['category'] = 'SAM';
                category =
                Global.validString(category) ? '$category,SAM' : 'SAM';
              }
              if (Global.validString(gfReco)) {
                // growthData['category'] = gfReco;
                category = Global.validString(category)
                    ? '$category,$gfReco'
                    : '$gfReco';
              }
              growthData['category'] = category;
              if(category!='GF1'){
                childWith['$key#!${element['childenrollguid']}'] = growthData;
              }

            }
          }
        }
      }

      // });
      childWith.forEach((key, value) {
        var enrolChilGUID = value['childenrollguid'];
        childrenIdList.add(enrolChilGUID);
        growthGuidByDate[key] = value;
      });

      print("final child $childWith");
      enrolledChildrenList = await EnrolledExitChilrenResponceHelper()
          .callEnrollChildrenforByMultiEnrollGuid(childrenIdList);

      reffrelChildrenList =
          await ChildReferralTabResponseHelper().callAllReffralsWithoutExit();

      List<String> tempFoeRemove = [];
      growthGuidByDate.forEach((key, value) {
        var enrolledGUID = value['childenrollguid'];
        var cgmguid = value['cgmguid'];
        var filterItem = reffrelChildrenList
            .where((element) => (element.childenrolledguid == enrolledGUID &&
                element.cgmguid == cgmguid))
            .toList();
        if (filterItem.length > 0) {
          tempFoeRemove.add(key);
        } else {
          var extedItem = enrolledChildrenList
              .where((element) => (element.ChildEnrollGUID == enrolledGUID &&
                  Global.validString(element.date_of_exit)))
              .toList();
          if (extedItem.length > 0) {
            tempFoeRemove.add(key);
          }
        }
      });
      tempFoeRemove.forEach((element) {
        growthGuidByDate.remove(element);
      });
      filteredGrowthGuidByDate = growthGuidByDate;
    }
    isLoading=false;
    setState(() {});
  }

  Future<void> fetchAllAnthroRecords() async {
     isLoading=true;
    childAnthro = await ChildGrowthResponseHelper().allAnthormentryDisableOCT();
    crecheData = await CrecheDataHelper().getCrecheResponce();
    if (childAnthro.length > 0) {
      allChildWithlatest(childAnthro);
    }else  {
      isLoading=false;
      setState(() {
      });
    }
  }

  void cleaAllFilter() {
    filteredGrowthGuidByDate = growthGuidByDate;
    selectedCreche = null;
    _creceSearchcontroller.text = '';

    setState(() {});
  }

  filteredGetData(
    BuildContext mContext,
  ) async {
    if (selectedCreche != null) {
      filteredGrowthGuidByDate = Map.fromEntries(growthGuidByDate.entries.where(
          (entry) =>
              callDataByKey(entry.key, 'creche_id').toString() ==
              selectedCreche.toString()));
    } else {
      filteredGrowthGuidByDate = growthGuidByDate;
    }
    setState(() {});
  }

  filterDataQu(String entry) {
    if (entry.length > 0) {
      filteredGrowthGuidByDate = Map.fromEntries(growthGuidByDate.entries.where(
          (element) => callDataByKey(element.key, 'child_name')
              .toLowerCase()
              .startsWith(entry.toLowerCase())));
    } else {
      filteredGrowthGuidByDate = growthGuidByDate;
    }
    setState(() {});
    print('cLength: ${filteredGrowthGuidByDate.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                                translats, CustomText.Filter, lng),
                            style: Styles.labelcontrollerfont,
                          ),
                          Spacer(),
                          InkWell(
                              onTap: () async {
                                _scaffoldKey.currentState!.closeEndDrawer();
                                // cleaAllFilter();
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
                    creches.length <= 1
                        ? DynamicCustomDropdownForFilterField(
                            hintText: Global.returnTrLable(
                                translats, CustomText.Creches, lng),
                            items: creches,
                            selectedItem: selectedCreche,
                            onChanged: (value) {
                              selectedCreche = value?.name;
                            },
                          )
                        : Container(
                            height: 35.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xffACACAC)),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: TypeAheadField<OptionsModel>(
                              controller: _creceSearchcontroller,
                              suggestionsCallback: (pattern) async {
                                try {
                                  var items = creches
                                      .where((element) =>
                                          element.values != null &&
                                          element.name != null &&
                                          element.values!
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase())
                                              ||
                                              element.name!
                                                  .toLowerCase()
                                                  .contains(
                                                  pattern.toLowerCase()))
                                      .toList();

                                  if (items.isEmpty || pattern.isEmpty) {
                                    selectedCreche = null;
                                    _creceSearchcontroller.text = '';
                                  }
                                  return items;
                                } catch (e) {
                                  debugPrint('TypeAhead error: $e');
                                  return [];
                                }
                              },
                              builder: (context, controller, focusNode) {
                                return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    style: Styles.black124,
                                    // autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: Global.returnTrLable(
                                          translats, CustomText.creche, lng),
                                      contentPadding: EdgeInsets.all(10),
                                      border: InputBorder.none,
                                      fillColor: Colors.white,
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(10),
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
                                selectedCreche = item.name ?? null;
                                _creceSearchcontroller.text = item.values ?? '';
                                print('itm $item');
                              },
                              offset: Offset(0, 12),
                              constraints: BoxConstraints(maxHeight: 500),
                              hideOnUnfocus: true,
                              showOnFocus: true,
                              hideWithKeyboard: false,
                              loadingBuilder: (context) =>
                                  const Text('Loading...'),
                              errorBuilder: (context, error) =>
                                  const Text('Error!'),
                              emptyBuilder: (context) =>
                                  const Text('No items found!'),
                            ),
                          ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CElevatedButton(
                              text: Global.returnTrLable(
                                  translats, CustomText.clear, lng),
                              color: Color(0xffF26BA3),
                              onPressed: () {
                                Navigator.of(context).pop();
                                cleaAllFilter();
                              },
                            ),
                          ),
                          // Spacer(),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: CElevatedButton(
                              text: Global.returnTrLable(
                                  translats, CustomText.Search, lng),
                              onPressed: () {
                                Navigator.of(context).pop();
                                filteredGetData(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
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
                  hintText:
                      Global.returnTrLable(translats, CustomText.Search, lng),
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
          Expanded(
            child: isLoading?Center(
              child: CircularProgressIndicator(),
            ):(filteredGrowthGuidByDate.keys.toList().length > 0)
                ? ListView.builder(
                    itemCount: filteredGrowthGuidByDate.keys.toList().length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var childId = Global.stringToInt(callDataByKey(
                              filteredGrowthGuidByDate.keys.toList()[index],
                              'name'));
                          var childIdGen =
                              '${callDataByKey(filteredGrowthGuidByDate.keys.toList()[index], 'child_id')}';
                          var childName =
                              '${callDataByKey(filteredGrowthGuidByDate.keys.toList()[index], 'child_name')}';

                          var creche_id = Global.stringToInt(callDataByKey(
                              filteredGrowthGuidByDate.keys.toList()[index],
                              'creche_id'));
                          List<String> keyParts = filteredGrowthGuidByDate.keys
                              .toList()[index]
                              .toString()
                              .split('#!');
                          if (Global.validToInt(backdatedConfigirationModel
                                  ?.back_dated_data_entry_allowed) >
                              0) {
                            var backDate = now.isBefore(applicableDate)
                                ? DateTime(1992)
                                : DateTime.parse(Validate().currentDate())
                                    .subtract(Duration(
                                        days: backdatedConfigirationModel!
                                            .back_dated_data_entry_allowed!));
                            if (backDate.isAfter(DateTime.parse(keyParts[0]))) {
                              minDate = backDate;
                            } else {
                              minDate = DateTime.parse(keyParts[0]);
                            }
                            if (minDate != null) {
                              List<int> parts = Validate()
                                  .currentDate()
                                  .split('-')
                                  .map(int.parse)
                                  .toList();
                              if (DateTime(minDate!.year, minDate!.month)
                                  .isBefore(DateTime(parts[0], parts[1]))) {
                                minDate = DateTime(parts[0], parts[1], 1);
                              }
                            }
                          }
                          var child_referral_guid = '';
                          if (!Global.validString(child_referral_guid)) {
                            child_referral_guid = Validate().randomGuid();
                            var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => ChildReferralTabScreen(
                                    tabTitle: widget.tabTitle,
                                    GrowthMonitoringGUID: callDataByKey(
                                        filteredGrowthGuidByDate.keys
                                            .toList()[index],
                                        'cgmguid'),
                                    enrolChildGuid: callDataByKey(
                                        filteredGrowthGuidByDate.keys
                                            .toList()[index],
                                        'childenrollguid'),
                                    creche_id: creche_id,
                                    ChildDOB: callDataByKey(
                                        filteredGrowthGuidByDate.keys
                                            .toList()[index],
                                        'child_dob'),
                                    enrollDate: callDataByKey(
                                        filteredGrowthGuidByDate.keys.toList()[index],
                                        'date_of_enrollment'),
                                    child_id: childId,
                                    child_referral_guid: child_referral_guid,
                                    childName: childName,
                                    childId: childIdGen,
                                    scheduleDate: callDataByKey(filteredGrowthGuidByDate.keys.toList()[index], 'measurement_taken_date'),
                                    minDate: minDate,
                                    isEditable: true,
                                    isEditableForDischage: true,
                                    isDischarge: false)));

                            if (refStatus == 'itemRefresh') {
                              await fetchAllAnthroRecords();
                            }

                            if (refStatus == 'itemRefresh') {
                              await fetchAllAnthroRecords();
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
                                    offset: Offset(
                                        0, 3), // Horizontal and vertical offset
                                    blurRadius: 6, // Blur radius
                                    spreadRadius: 0, // Spread radius
                                  ),
                                ],
                                color: Colors.white,
                                border: Border.all(color: Color(0xffE7F0FF)),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 8.h),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.ChildName, lng).trim()} : ',
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.ChildId, lng).trim()} : ',
                                          strutStyle: StrutStyle(height: 1.2),
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.Creche_Name, lng).trim()} : ',
                                          strutStyle: StrutStyle(height: 1.2),
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.schduleDate, lng).trim()} : ',
                                          strutStyle: StrutStyle(height: 1.2),
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.category, lng).trim()} : ',
                                          strutStyle: StrutStyle(height: 1.2),
                                          style: Styles.black104,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      height: 30.h,
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
                                            callDataByKey(
                                                filteredGrowthGuidByDate.keys
                                                    .toList()[index],
                                                'child_name'),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            callDataByKey(
                                                filteredGrowthGuidByDate.keys
                                                    .toList()[index],
                                                'child_id'),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            callCrecheNameName(callDataByKey(
                                                filteredGrowthGuidByDate.keys
                                                    .toList()[index],
                                                'creche_id')),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Validate().displeDateFormate(
                                                callDataByKey(
                                                    filteredGrowthGuidByDate
                                                        .keys
                                                        .toList()[index],
                                                    'measurement_taken_date')),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            callDataByKey(
                                                filteredGrowthGuidByDate.keys
                                                    .toList()[index],
                                                'category'),
                                            style: Styles.red185,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                      ],
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Text(Global.returnTrLable(
                        translats, CustomText.NorecordAvailable, lng)),
                  ),
          )
        ]),
      ),
    );
  }

  String callCrecheNameName(String nameId) {
    String returnValue = '';
    var items = crecheData
        .where((element) => element.name == Global.stringToInt(nameId))
        .toList();
    if (items.length > 0) {
      returnValue = Global.getItemValues(items[0].responces!, 'creche_name');
    }
    return returnValue;
  }

  String callDataByKey(String key, valueKey) {
    String returnValue = '';
    var growthData = growthGuidByDate[key];
    var enrolledGUID = growthData['childenrollguid'];
    var cgmguid = growthData['cgmguid'];
    var measurement_taken_date = growthData['measurement_taken_date'];
    if ('measurement_taken_date' == valueKey) {
      returnValue = measurement_taken_date;
    } else if ('category' == valueKey) {
      returnValue = growthData['category'] ?? '';
    } else if (valueKey != 'cgmguid') {
      var reffItems = enrolledChildrenList
          .where((element) => element.ChildEnrollGUID == enrolledGUID)
          .toList();
      if (reffItems.length > 0) {
        returnValue = Global.getItemValues(reffItems.first.responces, valueKey);
      }
    } else
      returnValue = cgmguid;

    return returnValue;
  }

  Future<String?> checkSUWCondition(String enrolChildGuid,
      String measurement_date, Map<String, dynamic> growhthDetails)
  async {
    String? genratedValue;
    String lastMonthDate = Validate().getOneMonthPreviousDate(measurement_date);
    var lastMonthYear = Validate().dateToMonthYear(lastMonthDate);
    var lastAntroRecord = await ChildGrowthResponseHelper()
        .lastAntroDataByCmGuid(lastMonthYear, growhthDetails['cgmguid']);
    print('rgggg check $measurement_date $lastMonthYear');

    String secoundLast = Validate().getOneMonthPreviousDate(lastMonthDate);
    var secoundLastMonthYear = Validate().dateToMonthYear(secoundLast);
    var secondLastAntroRecord = await ChildGrowthResponseHelper()
        .lastAntroDataByCmGuid(secoundLastMonthYear, growhthDetails['cgmguid']);
    print('rgggg check2 $measurement_date $secoundLast $secoundLastMonthYear');

    Map<String, dynamic> lastGrowhthDetails = {};
    if (lastAntroRecord.length > 0) {
      Map<String, dynamic> lastGrowthRec =
          jsonDecode(lastAntroRecord.first.responces!);
      var lastdChild = lastGrowthRec['anthropromatic_details'];
      if (lastdChild != null) {
        var child = lastdChild
            .where((element) => element['childenrollguid'] == enrolChildGuid
            &&(Global.stringToInt(element['do_you_have_height_weight'].toString()) == 1 ))
            .toList();
        if (child.length > 0) {
          lastGrowhthDetails = child.first;
        }
      }
    }

    Map<String, dynamic> secondlastGrowhthDetails = {};
    if (secondLastAntroRecord.length > 0) {
      Map<String, dynamic> secondlastGrowthRec =
          jsonDecode(secondLastAntroRecord.first.responces!);
      var lastdChild = secondlastGrowthRec['anthropromatic_details'];
      if (lastdChild != null) {
        var child = lastdChild
            .where((element) => element['childenrollguid'] == enrolChildGuid
            &&(Global.stringToInt(element['do_you_have_height_weight'].toString()) == 1 ))
            .toList();
        if (child.length > 0) {
          secondlastGrowhthDetails = child.first;
        }
      }
    }

    if (lastGrowhthDetails.isNotEmpty &&
        (Global.stringToDouble(growhthDetails['weight'].toString()) <=
            Global.stringToDouble(lastGrowhthDetails['weight'].toString()))) {
      genratedValue = 'GF1';

      if (secondlastGrowhthDetails.isNotEmpty &&
          (Global.stringToDouble(
              growhthDetails['weight'].toString())<=
              Global.stringToDouble(secondlastGrowhthDetails['weight'].toString()))) {
        genratedValue = 'GF2';
      }
    }
    // else if (secondlastGrowhthDetails.isNotEmpty && lastGrowhthDetails.isEmpty &&
    //     (Global.stringToDouble(secondlastGrowhthDetails['weight'].toString()) <=
    //         Global.stringToDouble(growhthDetails['weight'].toString()))) {
    //   genratedValue = 'GF1';
    // }
    return genratedValue;
  }

  @override
  void dispose() {
    _creceSearchcontroller.dispose(); // Clean up controller
    super.dispose();
  }
}
