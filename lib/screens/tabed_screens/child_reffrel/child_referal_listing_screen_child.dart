import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/database/helper/anthromentory/child_growth_response_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/child_referral_response_model.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../../../database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/databasemodel/child_growth_responce_model.dart';
import '../../../model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
import '../../../model/dynamic_screen_model/enrolled_children_responce_model.dart';
import '../../../style/styles.dart';
import 'child_refferal_tab_screen.dart';

class ChildReferralSpecificChildListingScreen extends StatefulWidget {
  String tabTitle;
  String? enrolledChildGUID;
  ChildReferralSpecificChildListingScreen(
      {super.key, required this.tabTitle, this.enrolledChildGUID});

  @override
  State<ChildReferralSpecificChildListingScreen> createState() =>
      _ChildReferralListingScreenState();
}

class _ChildReferralListingScreenState
    extends State<ChildReferralSpecificChildListingScreen> {
  bool _isLoading = true;

  List<ChildGrowthMetaResponseModel> childAnthro = [];
  List<ChildReferralTabResponceModel> followUpData = [];
  List<CresheDatabaseResponceModel> crecheData = [];
  List<EnrolledExitChildResponceModel> enrolledChildrenList = [];
  List<ChildReferralTabResponceModel> reffrelChildrenList = [];
  Map<String, dynamic> growthGuidByDate = {};
  List<String> childrenIdList = [];
  List<Translation> translats = [];
  String lng = 'en';
  DateTime? minDate;
  var applicableDate = Validate().stringToDate("2024-12-31");
  var now = DateTime.parse(Validate().currentDate());

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    var date = await Validate().readString(Validate.date);
    applicableDate = Validate().stringToDate(date ?? "2024-12-31");
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
      CustomText.schduleDate
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchAllAnthroRecords();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> allChildWithlatestSpecifChild(
      List<ChildGrowthMetaResponseModel> childAnthro) async {
    if (childAnthro.isEmpty) {
      throw ArgumentError('The list of objects cannot be empty.');
    }

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
    sortedMap.forEach((key, value) {
      List<dynamic> childItem = value as List<dynamic>;
      childItem.forEach((element) {
        if (Global.stringToDouble(
                    element['weight_for_height'].toString()) ==
                1 ||
            Global.stringToDouble(element['weight_for_height'].toString()) ==
                2 ||
            Global.stringToInt(
                    element['any_medical_major_illness'].toString()) ==
                1 ||
            Global.stringToDouble(element['weight_for_age'].toString()) == 1) {
          if (widget.enrolledChildGUID == element['childenrollguid']) {
            Map<String, dynamic> growthData = {};
            growthData['childenrollguid'] = element['childenrollguid'];
            growthData['cgmguid'] = element['cgmguid'];
            childWith[key] = growthData;
          }
        }
      });
    });
    childWith.forEach((key, value) {
      var enrolChilGUID = value['childenrollguid'];
      childrenIdList.add(enrolChilGUID);
      growthGuidByDate[key] = value;
    });
    print("final child $childWith");
    enrolledChildrenList = await EnrolledExitChilrenResponceHelper()
        .callEnrollChildrenforByMultiEnrollGuid(childrenIdList);

    reffrelChildrenList =
        await ChildReferralTabResponseHelper().callAllReffrals();
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
      }
    });
    tempFoeRemove.forEach((element) {
      growthGuidByDate.remove(element);
    });

    setState(() {});
  }

  Future<void> fetchAllAnthroRecords() async {
    childAnthro = await ChildGrowthResponseHelper().allAnthormentryDisableOCT();
    crecheData = await CrecheDataHelper().getCrecheResponce();
    if (childAnthro.length > 0) {
      if (Global.validString(widget.enrolledChildGUID))
        allChildWithlatestSpecifChild(childAnthro);
      // else allChildWithlatest(childAnthro);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    else {
      return Scaffold(
        // appBar: CustomAppbar(
        //   text: Global.returnTrLable(translats, CustomText.childReferral, lng),
        //   onTap: () => Navigator.pop(context, 'itemRefresh'),
        // ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
          child: Column(children: [
            Expanded(
              child: (growthGuidByDate.keys.toList().length > 0)
                  ? ListView.builder(
                      itemCount: growthGuidByDate.keys.toList().length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            var childId = Global.stringToInt(callDataByKey(
                                growthGuidByDate.keys.toList()[index], 'name'));
                            var childIdGen =
                                '${callDataByKey(growthGuidByDate.keys.toList()[index], 'child_id')}';
                            var childName =
                                '${callDataByKey(growthGuidByDate.keys.toList()[index], 'child_name')}';

                            var creche_id = Global.stringToInt(callDataByKey(
                                growthGuidByDate.keys.toList()[index],
                                'creche_id'));
                            List<String> keyParts = growthGuidByDate.keys
                                .toList()[index]
                                .toString()
                                .split('#!');
                            var backDate = now.isBefore(applicableDate)
                                ? DateTime(1992)
                                : DateTime.parse(Validate().currentDate())
                                    .subtract(Duration(days: 7));
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

                            var child_referral_guid = '';
                            if (!Global.validString(child_referral_guid)) {
                              child_referral_guid = Validate().randomGuid();
                              var refStatus = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChildReferralTabScreen(
                                            tabTitle: widget.tabTitle,
                                            GrowthMonitoringGUID: callDataByKey(
                                                growthGuidByDate.keys
                                                    .toList()[index],
                                                'cgmguid'),
                                            enrolChildGuid: callDataByKey(
                                                growthGuidByDate.keys
                                                    .toList()[index],
                                                'childenrollguid'),
                                            creche_id: creche_id,
                                            ChildDOB: callDataByKey(
                                                growthGuidByDate.keys
                                                    .toList()[index],
                                                'child_dob'),
                                            enrollDate: callDataByKey(
                                                growthGuidByDate.keys
                                                    .toList()[index],
                                                'date_of_enrollment'),
                                            child_id: childId,
                                            child_referral_guid:
                                                child_referral_guid,
                                            childName: childName,
                                            childId: childIdGen,
                                            scheduleDate: keyParts[0],
                                            minDate: minDate!,
                                            isDischarge: false,
                                            isEditable: true,
                                          )));

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
                                      offset: Offset(0,
                                          3), // Horizontal and vertical offset
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
                                            '${Global.returnTrLable(translats, CustomText.ChildName, lng).trim()} : ',
                                            style: Styles.black104,
                                          ),
                                          Text(
                                            '${Global.returnTrLable(translats, CustomText.ChildId, lng).trim()} : ',
                                            style: Styles.black104,
                                            strutStyle: StrutStyle(height: 1.2),
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
                                                  growthGuidByDate.keys
                                                      .toList()[index],
                                                  'child_name'),
                                              style: Styles.cardBlue10,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              callDataByKey(
                                                  growthGuidByDate.keys
                                                      .toList()[index],
                                                  'child_id'),
                                              style: Styles.cardBlue10,
                                              strutStyle:
                                                  StrutStyle(height: 1.2),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              callCrecheNameName(callDataByKey(
                                                  growthGuidByDate.keys
                                                      .toList()[index],
                                                  'creche_id')),
                                              style: Styles.cardBlue10,
                                              strutStyle:
                                                  StrutStyle(height: 1.2),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              Validate().displeDateFormate(
                                                  growthGuidByDate.keys
                                                      .toList()[index]),
                                              style: Styles.cardBlue10,
                                              strutStyle:
                                                  StrutStyle(height: 1.2),
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
    if (valueKey != 'cgmguid') {
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
}
