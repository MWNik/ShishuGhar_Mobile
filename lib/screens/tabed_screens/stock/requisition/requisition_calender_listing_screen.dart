import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
import 'package:shishughar/database/helper/stock/stock_response_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/month_and_year_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/model/dynamic_screen_model/requisition_response_model.dart';
import 'package:shishughar/screens/tabed_screens/stock/requisition/requisition_details_screen.dart';
import 'package:shishughar/screens/tabed_screens/stock/requisition/requisition_details_screen_new.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../../database/helper/child_attendence/child_attendance_helper_responce.dart';

class RequisitionCalenderListingScreen extends StatefulWidget {
  final String creche_id;
  RequisitionCalenderListingScreen({super.key, required this.creche_id});

  @override
  State<RequisitionCalenderListingScreen> createState() =>
      _RequisitionCalenderListingScreenState();
}

class _RequisitionCalenderListingScreenState
    extends State<RequisitionCalenderListingScreen> {
  List<RequisitionResponseModel> requisitionData = [];
  List<Translation> translats = [];
  String lng = 'en';
  List<OptionsModel> yearList = [];
  List<OptionsModel> monthList = [];
  List<MonthYearModel> calenderList = [];
  List<MonthYearModel> unsynchList = [];
  List<MonthYearModel> allList = [];
  List<MonthYearModel> filteredList = [];
  bool isOnlyUnsynched = false;
  String? role;

  @override
  void initState() {
    super.initState();
    intitializeData();
  }

  Future<void> intitializeData() async {
    role = (await Validate().readString(Validate.role))!;
    translats.clear();
    lng = (await Validate().readString(Validate.sLanguage))!;
    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.addAttendance,
      CustomText.ok,
      CustomText.all,
      CustomText.usynchedAndDraft,
      'Month',
      'Year'
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    await OptionsModelHelper()
        .getMstCommonOptions('Year', lng)
        .then((value) => yearList.addAll(value));
    await OptionsModelHelper()
        .getMstCommonOptions('Months', lng)
        .then((value) => monthList.addAll(value));
    await fetchRequisitionData();
  }

  Future<void> fetchRequisitionData() async {
    requisitionData = await RequisitionResponseHelper()
        .getRequisitonsByMonth(Global.stringToInt(widget.creche_id));
    calenderList.clear();
    DateTime now = DateTime.now();
    if (requisitionData.isEmpty && role == CustomText.crecheSupervisor) {
      print("Month: ${now.month} , Year; ${now.year}");
      var monthYear = MonthYearModel(
        month: now.month,
        Year: getNameFromOptionValue(now.year),
        is_edited: 0,
        is_uploaded: 0,
      );
      calenderList.add(monthYear);
    } else if (requisitionData.isNotEmpty) {
      requisitionData.forEach((element) {
        var month = element.month;
        var year = element.year;
        if (month != null && year != null) {
          var monthYear = MonthYearModel(
              month: month,
              Year: year,
              is_edited: element.is_edited,
              is_uploaded: element.is_uploaded);
          calenderList.add(monthYear);
        }
      });
      List<MonthYearModel> missingList = findMissingMonths(calenderList);
      if (missingList.isNotEmpty) {
        calenderList.addAll(missingList);
      }
      // if (!calenderList.any((element) =>
      //         element.month == now.month &&
      //         element.Year == getNameFromOptionValue(now.year)) &&
      //     role == CustomText.crecheSupervisor) {
      //   calenderList.add(MonthYearModel(
      //       month: now.month,
      //       Year: getNameFromOptionValue(now.year),
      //       is_edited: 0,
      //       is_uploaded: 0));
      // }
    }
    if (calenderList.length > 1) {
      calenderList.sort((a, b) {
        if (a.Year != b.Year) {
          return b.Year!.compareTo(a.Year!);
        } else {
          return b.month!.compareTo(a.month!);
        }
      });
    }
    allList = calenderList;
    unsynchList = calenderList
        .where((element) =>
            element.is_edited == 1 ||
            (element.is_edited == 0 && element.is_uploaded == 0))
        .toList();

    filteredList = isOnlyUnsynched ? unsynchList : allList;
    setState(() {});
  }

  List<MonthYearModel> findMissingMonths(List<MonthYearModel> monthYearList) {
    if (monthYearList.isEmpty) return [];

    // Sort the list by the calculated year and month
    monthYearList.sort((a, b) {
      int yearDiff = a.Year!.compareTo(b.Year!);
      return yearDiff == 0 ? a.month!.compareTo(b.month!) : yearDiff;
    });

    // Get the current date
    DateTime now = DateTime.now();
    int currentYear = getNameFromOptionValue(now.year);
    int currentMonth = now.month;

    // Get the latest year and month in the list
    MonthYearModel latest = monthYearList.last;
    int latestYear = latest.Year!;
    int latestMonth = latest.month!;

    List<MonthYearModel> missingMonths = [];
    int year = latestYear;
    int month = latestMonth;
    int days = now.day;

    // Loop from the current month to the latest month, adding missing months
    while (currentYear > year ||
        (currentYear == year &&
            (currentMonth > month || currentMonth == month))) {
      bool monthExists =
          monthYearList.any((m) => m.Year == year && m.month == month);
      if (!monthExists) {
        missingMonths.add(MonthYearModel(
            Year: year, month: month, is_edited: 0, is_uploaded: 0));
      }

      if(currentMonth == month&&currentYear == year&&days>=20){
        var generateMonth=currentMonth;
        var generateYear=currentYear;
        if(currentMonth == 12){
          generateMonth=1;
          generateYear=currentYear+1;
        }else{
          generateMonth=currentMonth+1;
        }
        bool monthExists =
        monthYearList.any((m) => m.Year == generateYear && m.month == generateMonth);

        if (!monthExists) {
          missingMonths.add(MonthYearModel(
              Year: generateYear, month: generateMonth, is_edited: 0, is_uploaded: 0));
        }

      }

      // Move to the next month
      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
    }

    return missingMonths;
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
        // floatingActionButton: (requisitionData.isEmpty)
        //     ? InkWell(
        //         onTap: () async {
        //           String rguid = '';
        //           if (!Global.validString(rguid)) {
        //             rguid = Validate().randomGuid();

        //             var refStatus = await Navigator.of(context).push(
        //                 MaterialPageRoute(
        //                     builder: (BuildContext context) =>
        //                         RequisitionDetailsScreen(
        //                           rguid: rguid,
        //                           creche_id: widget.creche_id,
        //                         )));

        //             if (refStatus == 'itemRefresh') {
        //               fetchRequisitionData();
        //             }
        //           }
        //         },
        //         child: Image.asset(
        //           "assets/add_btn.png",
        //           scale: 2.7,
        //           color: Color(0xff5979AA),
        //         ),
        //       )
        //     : null,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(children: [
            Align(
              alignment: Alignment.topLeft,
              child: AnimatedRollingSwitch(
                isOnlyUnsynched: isOnlyUnsynched,
                title1: Global.returnTrLable(translats, CustomText.all, lng),
                title2: Global.returnTrLable(
                    translats, CustomText.usynchedAndDraft, lng),
                onChange: (value) async {
                  setState(() {
                    isOnlyUnsynched = value;
                  });
                  await fetchRequisitionData();
                },
              ),
            ),
            (filteredList.length > 0)
                ? Expanded(
                    child: ListView.builder(
                        itemCount: filteredList.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              // var previousMonthMap = fetchPreviousMoonthYear(
                              //     filteredList[index].month!,
                              //     filteredList[index].Year!);
                              // var list = await ChildAttendanceResponceHelper()
                              //     .fetchMostAttendancerecord(
                              //     Global.stringToInt(widget.creche_id),
                              //     previousMonthMap.keys.first,
                              //     previousMonthMap[
                              //     previousMonthMap.keys.first]??0);

                              var list = await ChildAttendanceResponceHelper()
                                  .callLastAttendenceMaxChildCount(
                                      Global.stringToInt(widget.creche_id),
                                      filteredList[index].month!,
                                      filteredList[index].Year!);

                              var requiRecord = await RequisitionResponseHelper()
                                  .getRequisitionByYearnMonth(
                                      Global.stringToInt(widget.creche_id),
                                      filteredList[index].month!,
                                      filteredList[index].Year!);
                              String? guid = requiRecord.isNotEmpty
                                  ? requiRecord.first.rguid
                                  : await Validate().randomGuid();
                              var stockData = await StockResponseHelper()
                                  .getStockByYearnMonth(
                                      Global.stringToInt(widget.creche_id),
                                      filteredList[index].month!,
                                      filteredList[index].Year!);

                              print(list.length);
                              if (list.isNotEmpty) {
                                if (list.first['children_count'] != null) {
                                  String childCount =
                                      list.first['children_count'].toString();

                                  var refStatus = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              RequisitionDetailsNew(
                                                  child_count: childCount,
                                                  stockData:
                                                      stockData.firstOrNull,
                                                  rguid: guid!,
                                                  month:
                                                      filteredList[index].month!,
                                                  year: filteredList[index].Year!,
                                                  creche_id: widget.creche_id,
                                                  name: requiRecord
                                                      .firstOrNull?.name,
                                                  isEdit: role ==
                                                      CustomText
                                                          .crecheSupervisor)));

                                  if (refStatus == 'itemRefresh') {
                                    fetchRequisitionData();
                                  }
                                } else
                                  Validate().singleButtonPopup(
                                      Global.returnTrLable(translats,
                                          CustomText.addAttendance, lng),
                                      Global.returnTrLable(
                                          translats, CustomText.ok, lng),
                                      false,
                                      context);
                              } else
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(
                                        translats, CustomText.addAttendance, lng),
                                    Global.returnTrLable(
                                        translats, CustomText.ok, lng),
                                    false,
                                    context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xff5A5A5A).withOpacity(0.2),
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                        spreadRadius: 0,
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
                                            '${Global.returnTrLable(translats, 'Month', lng).trim()} :',
                                            style: Styles.black104,
                                          ),
                                          Text(
                                            '${Global.returnTrLable(translats, 'Year', lng).trim()} :',
                                            style: Styles.black104,
                                            strutStyle: StrutStyle(height: 1.2),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        height: 10.h,
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
                                              getOptionsFromName(
                                                  filteredList[index].month!,
                                                  'Months'),
                                              style: Styles.cardBlue10,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              getOptionsFromName(
                                                  filteredList[index].Year!,
                                                  'Year'),
                                              style: Styles.cardBlue10,
                                              strutStyle: StrutStyle(height: 1.2),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      (filteredList[index].is_edited == 0 &&
                                              filteredList[index].is_uploaded ==
                                                  1)
                                          ? Image.asset(
                                              "assets/sync.png",
                                              scale: 1.5,
                                            )
                                          : filteredList[index].is_edited == 1 &&
                                                  filteredList[index]
                                                          .is_uploaded ==
                                                      0
                                              ? Image.asset(
                                                  "assets/sync_gray.png",
                                                  scale: 1.5,
                                                )
                                              : Icon(
                                                  Icons.error_outline,
                                                  color: Colors.red,
                                                  shadows: [
                                                    BoxShadow(
                                                        spreadRadius: 2,
                                                        blurRadius: 4,
                                                        color:
                                                            Colors.red.shade200)
                                                  ],
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
                      child: Text(Global.returnTrLable(
                          translats, CustomText.NorecordAvailable, lng)),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }

  String getOptionsFromName(int name, String flag) {
    String option = '';
    if (flag == "Year") {
      var list = yearList.where((element) {
        return Global.stringToInt(element.name) == name;
      });
      if (list.length > 0) option = list.first.values!;
    } else if (flag == 'Months') {
      var list = monthList.where((element) {
        return Global.stringToInt(element.name) == name;
      });
      if (list.length > 0) option = list.first.values!;
    }
    return option;
  }

  int getNameFromOptionValue(int value) {
    int name = 0;
    var list = yearList.where((element) {
      return Global.stringToInt(element.values) == value;
    });
    if (list.isNotEmpty) {
      name = Global.stringToInt(list.first.name);
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(translats, CustomText.requiCannotBeMadeYet, lng),
          Global.returnTrLable(translats, CustomText.ok, lng),
          true,
          context);
    }
    return name;
  }

  Map<int, int> fetchPreviousMoonthYear(int month, int year) {
    Map<int, int> monthYearmap = {};
    if (month == 1) {
      monthYearmap.addEntries([MapEntry(12, (year - 1))]);
    } else {
      monthYearmap.addEntries([MapEntry(month - 1, year)]);
    }

    return monthYearmap;
  }
}
