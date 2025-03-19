import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown_for_filter.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/custom_textfield.dart';
import '../../../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import 'child_refferal_tab_screen.dart';

class ChildReferralCompletedListingScreen extends StatefulWidget {
  String tabTitle;
  String? enrolledChildGUID;
  bool isHomeScreen;
  ChildReferralCompletedListingScreen(
      {super.key,
      required this.tabTitle,
      this.enrolledChildGUID,
      required this.isHomeScreen});

  @override
  State<ChildReferralCompletedListingScreen> createState() =>
      _ChildReferralListingScreenState();
}

class _ChildReferralListingScreenState
    extends State<ChildReferralCompletedListingScreen> {
  List<Map<String, dynamic>> reffral = [];
  List<Map<String, dynamic>> filteredReferral = [];
  List<Map<String, dynamic>> usynchedList = [];
  List<Map<String, dynamic>> allList = [];

  List<CresheDatabaseResponceModel> crecheData = [];
  List<Translation> translats = [];
  String lng = 'en';
  DateTime? minDate;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController Searchcontroller = TextEditingController();
  List<OptionsModel> creches = [];
  String? selectedCreche;
  bool isOnlyUnsyched = false;
  var applicableDate = Validate().stringToDate("2024-12-31");
  var now = DateTime.parse(Validate().currentDate());

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    translats.clear();
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    var date = await Validate().readString(Validate.date);
    applicableDate = Validate().stringToDate(date ?? "2024-12-31");
    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.all,
      CustomText.unsynched,
      CustomText.Filter,
      CustomText.clear,
      CustomText.Creches,
      CustomText.ChildId,
      CustomText.Creche_Name,
      CustomText.visitDate,
      CustomText.DischangeDate
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchCompletedReffral();
  }

  Future<void> fetchCompletedReffral() async {
    if (Global.validString(widget.enrolledChildGUID))
      reffral = await ChildReferralTabResponseHelper()
          .callChildReffralsByEnrolledGUID(widget.enrolledChildGUID!);
    else
      reffral = await ChildReferralTabResponseHelper().callChildReffrals();
    usynchedList =
        reffral.where((element) => element['is_edited'] == 1).toList();
    allList = reffral;
    filteredReferral = isOnlyUnsyched ? usynchedList : allList;
    crecheData = await CrecheDataHelper().getCrecheResponce();
    creches = await OptionsModelHelper().callCrechInOptionAll('Creche');
    setState(() {});
  }

  void cleaAllFilter() {
    filteredReferral = isOnlyUnsyched ? usynchedList : allList;
    selectedCreche = null;

    setState(() {});
  }

  filteredGetData(BuildContext context) {
    var filterList = isOnlyUnsyched ? usynchedList : allList;
    if (selectedCreche != null) {
      filteredReferral = filterList.where((element) {
        var creche_id =
            Global.getItemValues(element['enrolledResponce'], 'creche_id');
        return creche_id.toString() == selectedCreche.toString();
      }).toList();
    } else {
      filteredReferral = filterList;
    }
    setState(() {});
  }

  filterDataQu(String entry) {
    var filterList = isOnlyUnsyched ? usynchedList : allList;
    if (entry.length > 0) {
      filteredReferral = filterList
          .where((element) =>
              (Global.getItemValues(element['enrolledResponce'], 'child_name'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()))
          .toList();
    } else {
      filteredReferral = filterList;
    }
    setState(() {});
    print('cLength: ${filteredReferral.length}');
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
                    DynamicCustomDropdownForFilterField(
                      hintText: Global.returnTrLable(
                          translats, CustomText.Creches, lng),
                      items: creches,
                      selectedItem: selectedCreche,
                      onChanged: (value) {
                        selectedCreche = value?.name;
                      },
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
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: AnimatedRollingSwitch(
                        title1: Global.returnTrLable(
                            translats, CustomText.all, lng),
                        title2: Global.returnTrLable(
                            translats, CustomText.unsynched, lng),
                        isOnlyUnsynched: isOnlyUnsyched,
                        onChange: (value) async {
                          setState(() {
                            isOnlyUnsyched = value;
                          });
                          await fetchCompletedReffral();
                        },
                      ),
                    )
                  ]),
            )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
        child: Column(children: [
          widget.isHomeScreen
              ? Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldRow(
                        controller: Searchcontroller,
                        onChanged: (value) {
                          print(value);
                          filterDataQu(value);
                        },
                        hintText: Global.returnTrLable(
                            translats, CustomText.Search, lng),
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
                )
              : Container(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: AnimatedRollingSwitch(
                      title1:
                          Global.returnTrLable(translats, CustomText.all, lng),
                      title2: Global.returnTrLable(
                          translats, CustomText.unsynched, lng),
                      isOnlyUnsynched: isOnlyUnsyched,
                      onChange: (value) async {
                        setState(() {
                          isOnlyUnsyched = value;
                        });
                        await fetchCompletedReffral();
                      },
                    ),
                  ),
                ),
          Expanded(
            child: (filteredReferral.length > 0)
                ? ListView.builder(
                    itemCount: filteredReferral.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var childId = Global.stringToInt(Global.getItemValues(
                              filteredReferral[index]['enrolledResponce'],
                              'name'));
                          var childIdGen =
                              '${Global.getItemValues(filteredReferral[index]['enrolledResponce'], 'child_id')}';
                          var childName =
                              '${Global.getItemValues(filteredReferral[index]['enrolledResponce'], 'child_name')}';

                          var creche_id = Global.stringToInt(
                              Global.getItemValues(
                                  filteredReferral[index]['enrolledResponce'],
                                  'creche_id'));
                          var child_referral_guid =
                              filteredReferral[index]['child_referral_guid'];
                          var backDate = now.isBefore(applicableDate)
                              ? DateTime(1992)
                              : DateTime.parse(Validate().currentDate())
                                  .subtract(Duration(days: 7));
                          if (backDate.isAfter(DateTime.parse(
                              filteredReferral[index]['date_of_referral']))) {
                            minDate = backDate;
                          } else {
                            minDate = DateTime.parse(
                                filteredReferral[index]['date_of_referral']);
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

                          var created_at = DateTime.parse(
                              filteredReferral[index]['created_at'].toString());
                          var date = DateTime(created_at.year, created_at.month,
                              created_at.day);
                          bool isEditable = date.add(Duration(days: 8)).isAfter(
                              DateTime.parse(Validate().currentDate()));

                          var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => ChildReferralTabScreen(
                                  tabTitle: widget.tabTitle,
                                  GrowthMonitoringGUID: filteredReferral[index]
                                      ['cgmguid'],
                                  enrolChildGuid: filteredReferral[index]
                                      ["childenrolledguid"],
                                  creche_id: creche_id,
                                  ChildDOB: Global.getItemValues(
                                      filteredReferral[index]
                                          ['enrolledResponce'],
                                      'child_dob'),
                                  enrollDate: Global.getItemValues(
                                      filteredReferral[index]
                                          ['enrolledResponce'],
                                      'date_of_enrollment'),
                                  child_id: childId,
                                  child_referral_guid: child_referral_guid,
                                  childName: childName,
                                  minDate: minDate!,
                                  isEditable: now.isBefore(applicableDate)
                                      ? true
                                      : isEditable,
                                  scheduleDate: filteredReferral[index]['date_of_referral'],
                                  childId: childIdGen,
                                  isDischarge: Global.validString(Global.getItemValues(filteredReferral[index]['responces'], 'discharge_date')))));

                          if (refStatus == 'itemRefresh') {
                            await fetchCompletedReffral();
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
                                          Global.validString(
                                                  Global.getItemValues(
                                                      filteredReferral[index]
                                                          ['responces'],
                                                      'discharge_date'))
                                              ? '${Global.returnTrLable(translats, CustomText.DischangeDate, lng).trim()} : '
                                              : '${Global.returnTrLable(translats, CustomText.visitDate, lng).trim()} : ',
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
                                            Global.getItemValues(
                                                filteredReferral[index]
                                                    ['enrolledResponce'],
                                                'child_name'),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Global.getItemValues(
                                                filteredReferral[index]
                                                    ['enrolledResponce'],
                                                'child_id'),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            callCrecheNameName(
                                                Global.getItemValues(
                                                    filteredReferral[index]
                                                        ['enrolledResponce'],
                                                    'creche_id')),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Global.validString(
                                                    Global.getItemValues(
                                                        filteredReferral[index]
                                                            ['responces'],
                                                        'discharge_date'))
                                                ? Validate().displeDateFormate(
                                                    Global.getItemValues(
                                                        filteredReferral[index]
                                                            ['responces'],
                                                        'discharge_date'))
                                                : Validate().displeDateFormate(
                                                    Global.getItemValues(
                                                        filteredReferral[index]
                                                            ['responces'],
                                                        'visit_date')),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    (filteredReferral[index]['is_edited'] ==
                                                0 &&
                                            filteredReferral[index]
                                                    ['is_uploaded'] ==
                                                1)
                                        ? Image.asset(
                                            "assets/sync.png",
                                            scale: 1.5,
                                          )
                                        : Image.asset(
                                            "assets/sync_gray.png",
                                            scale: 1.5,
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
}
