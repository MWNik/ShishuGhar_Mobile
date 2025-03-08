import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
import '../../../database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_growth_responce_model.dart';
import '../../../model/databasemodel/tabVillage_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../../../utils/year_month_custom_calender.dart';
import 'child_growth_expended_form_screen.dart';

class ChildGrowthListingScreen extends StatefulWidget {
  final int creche_nameId;
  final String creche_name;

  const ChildGrowthListingScreen({
    super.key,
    required this.creche_nameId,
    required this.creche_name,
  });

  @override
  State<ChildGrowthListingScreen> createState() => _ChildGrowthListingState();
}

class _ChildGrowthListingState extends State<ChildGrowthListingScreen> {
  List<ChildGrowthMetaResponseModel> childHHData = [];
  List<ChildGrowthMetaResponseModel> anthropometryData = [];
  List<Translation> translats = [];
  List<TabVillage> villages = [];
  String lng = 'en';
  DateTime? lastGrowthDate;
  DateTime? maxGrowthDate;
  List<ChildGrowthMetaResponseModel> unsynchedList = [];
  List<ChildGrowthMetaResponseModel> allList = [];
  bool isOnlyUnsynched = false;
  bool isCalenderView = false;
  String? role;
  DateTime applicableDate = Validate().stringToDate("2024-12-31");

  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    role = (await Validate().readString(Validate.role))!;
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
      CustomText.ok,
      CustomText.all,
      CustomText.unsynched,
      CustomText.GrowthMonitoring,
      CustomText.schduleed,
      CustomText.measurementDate
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchEnrolleChild();

    setState(() {});
  }

  Future<void> fetchEnrolleChild() async {
    childHHData = await ChildGrowthResponseHelper()
        .anthormentryByCreche(widget.creche_nameId);
    anthropometryData = await ChildGrowthResponseHelper()
        .anthormentryByCrecheIdAsc(widget.creche_nameId);
    if (childHHData.length > 0)
      await callDatesListAddBackDatedEntryByJadish();
    else
      lastGrowthDate = await fetchEarliestEnnrollDate();

    unsynchedList = childHHData.where((element) => element.is_edited == 1).toList();
    allList = childHHData;
    childHHData = isOnlyUnsynched ? unsynchedList : allList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: Global.returnTrLable(translats, CustomText.GrowthMonitoring, lng),
        subTitle: widget.creche_name,
        onTap: () => Navigator.pop(context),
        actions: [
          IconButton(onPressed: () async {
            isCalenderView=isCalenderView?false:true;
            setState(() {

            });
          }, icon: Icon(isCalenderView?Icons.list_alt:Icons.calendar_month,color:Colors.white))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
        child: isCalenderView?YearMonthCalendar(
            initialDate: DateTime.now(),
            mesures: anthropometryData,
            onTap: (data) async {
              var selectedItems=childHHData.where((element) => element.cgmguid == Global.validToString(data)).toList();
             if(selectedItems.isNotEmpty){
               var lstDate = await minMaxDate(selectedItems.first.created_at);

               if (callMeasurementEditableDate(
                   selectedItems.first.created_at!)) {
                 var refStatus = await Navigator.of(context).push(
                     MaterialPageRoute(
                         builder: (BuildContext context) =>
                             ChildGrowthExpendedFormScreen(
                               creche_nameId: widget.creche_nameId,
                               creche_name: widget.creche_name,
                               cgmguid:
                               selectedItems.first.cgmguid!,
                               lastGrowthDate: lstDate,
                               minGrowthDate: maxGrowthDate,
                               createdAt:
                               selectedItems.first.created_at,
                               isNew:
                               selectedItems.first.responces !=
                                   null
                                   ? true
                                   : false,
                             )));

                 if (refStatus == 'itemRefresh') {
                   await fetchEnrolleChild();
                 }
               } else
                 Validate().singleButtonPopup(
                     Global.returnTrLable(translats, CustomText.growthMonitoring, lng),
                     Global.returnTrLable(translats, CustomText.ok, lng),
                     false,
                     context);
             }

            }
        ):Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Align(
                alignment: Alignment.topRight,
                child: AnimatedRollingSwitch(
                  title1: Global.returnTrLable(translats, CustomText.all, lng),
                  title2: Global.returnTrLable(
                      translats, CustomText.unsynched, lng),
                  isOnlyUnsynched: isOnlyUnsynched ?? false,
                  onChange: (value) async {
                    setState(() {
                      isOnlyUnsynched = value;
                    });
                    await fetchEnrolleChild();
                  },
                ),
              ),
            ),
            Expanded(
              child: (childHHData.length > 0)
                  ? ListView.builder(
                      itemCount: childHHData.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            var lstDate =
                                await minMaxDate(childHHData[index].created_at);

                            if (callMeasurementEditableDate(
                                childHHData[index].created_at!)) {
                              var refStatus = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChildGrowthExpendedFormScreen(
                                            creche_nameId: widget.creche_nameId,
                                            creche_name: widget.creche_name,
                                            cgmguid:
                                                childHHData[index].cgmguid!,
                                            lastGrowthDate: lstDate,
                                            minGrowthDate: maxGrowthDate,
                                            createdAt:
                                                childHHData[index].created_at,
                                            isNew:
                                                childHHData[index].responces !=
                                                        null
                                                    ? true
                                                    : false,
                                          )));

                              if (refStatus == 'itemRefresh') {
                                await fetchEnrolleChild();
                              }
                            } else
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(translats, CustomText.growthMonitoring, lng),
                                  Global.returnTrLable(translats, CustomText.ok, lng),
                                  false,
                                  context);
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          Global.validString(
                                                  childHHData[index].responces)
                                              ? '${Global.returnTrLable(translats, CustomText.measurementDate, lng).trim()} : '
                                              : '${Global.returnTrLable(translats, CustomText.schduleed, lng).trim()} : ',
                                          style: Styles.black104,
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
                                            Global.validString(
                                                    childHHData[index]
                                                        .responces)
                                                ? Validate().displeDateFormate(
                                                    Global.getItemValues(
                                                        childHHData[index]
                                                            .responces!,
                                                        'measurement_date'))
                                                : showStringDayMonth(
                                                    childHHData[index]
                                                        .created_at!),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    (childHHData[index].is_edited == 0 &&
                                            childHHData[index].is_uploaded == 1)
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
                      },
                    )
                  : Center(
                      child: Text(Global.returnTrLable(
                          translats, CustomText.NorecordAvailable, lng)),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> callDatesList() async {
    List<String> dateStringData = [];
    DateTime? dateAladyCreate;
    DateTime? dateMesured;
    var childGroth =
        childHHData.where((element) => element.responces != null).toList();
    childGroth.forEach((element) {
      var date = Global.getItemValues(element.responces!, 'measurement_date');
      if (Global.validString(date)) {
        dateStringData.add(date);
      }
    });
    var dateList = dateStringData.map((dateString) {
      List<int> dateParts = dateString.split('-').map(int.parse).toList();
      return DateTime(dateParts[0], dateParts[1], dateParts[2]);
    }).toList();

    //// is not fill data in mesuremt

    List<String> dateStringDataCreated = [];
    var childGrothCreated =
        childHHData.where((element) => element.responces == null).toList();
    childGrothCreated.forEach((element) {
      var spledDate = Global.splitData(element.created_at!, " ");
      if (spledDate.length == 2) {
        DateTime? celectedDate = Validate().stringToDateNull(spledDate[0]);
        if (celectedDate != null) {
          dateStringDataCreated.add(spledDate[0]);
        }
      }
    });

    var createdData = dateStringDataCreated.map((dateString) {
      List<int> dateParts = dateString.split('-').map(int.parse).toList();
      return DateTime(dateParts[0], dateParts[1], dateParts[2]);
    }).toList();

    if (createdData.length > 0) {
      dateAladyCreate = createdData
          .reduce((value, element) => value.isAfter(element) ? value : element);
    }

    if (dateList.length > 0) {
      dateMesured = dateList
          .reduce((value, element) => value.isAfter(element) ? value : element);
    }
    if (dateMesured != null || dateAladyCreate != null) {
      if (dateMesured != null && dateAladyCreate == null) {
        DateTime messureDate = DateTime(dateMesured.year, dateMesured.month);
        DateTime tDate = Validate().stringToDate(Validate().currentDate());
        DateTime todayDate = DateTime(tDate.year, tDate.month);
        if (todayDate.isAfter(messureDate)) {
          while (messureDate.isBefore(todayDate)) {
            messureDate = DateTime(messureDate.year, messureDate.month + 1);
            if (messureDate.month > 12) {
              messureDate = DateTime(messureDate.year + 1, 1);
            }
            var item = ChildGrowthMetaResponseModel(
                cgmguid: Validate().randomGuid(),
                responces: null,
                is_uploaded: 0,
                is_edited: 1,
                is_deleted: 0,
                name: null,
                creche_id: widget.creche_nameId,
                created_by: (await Validate().readString(Validate.userName))!,
                created_at: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(
                    messureDate.year, messureDate.month, DateTime.now().day)));
            await ChildGrowthResponseHelper().inserts(item);
          }

          //     Validate().randomGuid(),
          //     null,
          //     widget.creche_nameId,
          //     null,
          //     (await Validate().readString(Validate.userName))!);
        }
      } else if (dateAladyCreate != null && dateMesured == null) {
        DateTime messureDate =
            DateTime(dateAladyCreate.year, dateAladyCreate.month);
        DateTime tDate = Validate().stringToDate(Validate().currentDate());
        DateTime todayDate = DateTime(tDate.year, tDate.month);
        if (todayDate.isAfter(messureDate)) {
          while (messureDate.isBefore(todayDate)) {
            messureDate = DateTime(messureDate.year, messureDate.month + 1);
            if (messureDate.month > 12) {
              messureDate = DateTime(messureDate.year + 1, 1);
            }
            var item = ChildGrowthMetaResponseModel(
                cgmguid: Validate().randomGuid(),
                responces: null,
                is_uploaded: 0,
                is_edited: 1,
                is_deleted: 0,
                name: null,
                creche_id: widget.creche_nameId,
                created_by: (await Validate().readString(Validate.userName))!,
                created_at: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(
                    messureDate.year, messureDate.month, DateTime.now().day)));
            await ChildGrowthResponseHelper().inserts(item);
          }

          //     Validate().randomGuid(),
          //     null,
          //     widget.creche_nameId,
          //     null,
          //     (await Validate().readString(Validate.userName))!);
        }
      } else if (dateAladyCreate != null && dateMesured != null) {
        DateTime messureDate =
            DateTime(dateAladyCreate.year, dateAladyCreate.month);
        if (dateAladyCreate.isAfter(dateMesured)) {
          messureDate = DateTime(dateAladyCreate.year, dateAladyCreate.month);
        } else
          messureDate = DateTime(dateMesured.year, dateMesured.month);

        DateTime tDate = Validate().stringToDate(Validate().currentDate());
        DateTime todayDate = DateTime(tDate.year, tDate.month);

        if (todayDate.isAfter(messureDate)) {
          while (messureDate.isBefore(todayDate)) {
            messureDate = DateTime(messureDate.year, messureDate.month + 1);
            if (messureDate.month > 12) {
              messureDate = DateTime(messureDate.year + 1, 1);
            }
            var item = ChildGrowthMetaResponseModel(
                cgmguid: Validate().randomGuid(),
                responces: null,
                is_uploaded: 0,
                is_edited: 1,
                is_deleted: 0,
                name: null,
                creche_id: widget.creche_nameId,
                created_by: (await Validate().readString(Validate.userName))!,
                created_at: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(
                    messureDate.year, messureDate.month, DateTime.now().day)));
            await ChildGrowthResponseHelper().inserts(item);
          }

          //     Validate().randomGuid(),
          //     null,
          //     widget.creche_nameId,
          //     null,
          //     (await Validate().readString(Validate.userName))!);
        }
      }
    }
    childHHData = await ChildGrowthResponseHelper()
        .anthormentryByCreche(widget.creche_nameId);
  }

  Future<void> callDatesListAddBackDatedEntryByJadish() async {
    //25/09/2024
    List<String> dateStringData = [];
    var childGroth =
        childHHData.where((element) => element.responces != null).toList();
    childGroth.forEach((element) {
      var date = Global.getItemValues(element.responces!, 'measurement_date');
      if (Global.validString(date)) {
        dateStringData.add(date);
      }
    });
    var dateList = dateStringData.map((dateString) {
      List<int> dateParts = dateString.split('-').map(int.parse).toList();
      return DateTime(dateParts[0], dateParts[1], 1);
    }).toList();

    //// is not fill data in mesuremt

    List<String> dateStringDataCreated = [];
    var childGrothCreated =
        childHHData.where((element) => element.responces == null).toList();
    childGrothCreated.forEach((element) {
      var spledDate = Global.splitData(element.created_at!, " ");
      if (spledDate.length == 2) {
        DateTime? celectedDate = Validate().stringToDateNull(spledDate[0]);
        if (celectedDate != null) {
          dateStringDataCreated.add(spledDate[0]);
        }
      }
    });

    var createdData = dateStringDataCreated.map((dateString) {
      List<int> dateParts = dateString.split('-').map(int.parse).toList();
      return DateTime(dateParts[0], dateParts[1], 1);
    }).toList();
    dateList.addAll(createdData);

    var cutDate = Validate().stringToDate(Validate().currentDate());
    DateTime currentDateMonth =
        DateTime(cutDate.year, cutDate.month, cutDate.day, 0, 1);
    DateTime messureDate = DateTime(2023, 11, 1);

    if (currentDateMonth.isAfter(messureDate)) {
      while (messureDate.isBefore(currentDateMonth)) {
        messureDate = DateTime(messureDate.year, messureDate.month + 1);
        if (messureDate.month > 12) {
          messureDate = DateTime(messureDate.year + 1,1);
        }
        var dateItems = dateList
            .where((element) => (element.month == messureDate.month &&
                element.year == messureDate.year))
            .toList();
        if (dateItems.length == 0 && messureDate.isBefore(currentDateMonth)) {
          var item = ChildGrowthMetaResponseModel(
              cgmguid: Validate().randomGuid(),
              responces: null,
              is_uploaded: 0,
              is_edited: 1,
              is_deleted: 0,
              name: null,
              creche_id: widget.creche_nameId,
              created_by: (await Validate().readString(Validate.userName))!,
              created_at: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(
                  messureDate.year, messureDate.month, 1)));
          print(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(
              messureDate.year, messureDate.month, 1)));
          await ChildGrowthResponseHelper().inserts(item);
        }
      }
    }

    childHHData = await ChildGrowthResponseHelper()
        .anthormentryByCreche(widget.creche_nameId);
  }

  // Future<DateTime?> callDatesAlredDateList(String date) async {
  //   DateTime? lastGrowthDateNew;
  //   if (Global.validString(date)) {
  //     List<String> dateStringData = [];
  //     var chilGrowth =
  //         childHHData.where((element) => element.responces != null).toList();
  //     chilGrowth.forEach((element) {
  //       var date = Global.getItemValues(element.responces!, 'measurement_date');
  //       if (Global.validString(date)) {
  //         dateStringData.add(date);
  //       }
  //     });
  //     var dateList = dateStringData.map((dateString) {
  //       List<int> dateParts = dateString.split('-').map(int.parse).toList();
  //       return DateTime(dateParts[0], dateParts[1], dateParts[2]);
  //     }).toList();
  //
  //     List<int> dateCuuten = date.split('-').map(int.parse).toList();
  //
  //     var selecttedItemDate =
  //         DateTime(dateCuuten[0], dateCuuten[1], dateCuuten[2]);
  //
  //     if (dateList.length > 0) {
  //       var maxDateList = dateList
  //           .where((element) => (selecttedItemDate.isAfter(element)))
  //           .toList();
  //       DateTime? greatestDate = maxDateList.isNotEmpty
  //           ? maxDateList.reduce(
  //               (value, element) => value.isAfter(element) ? value : element)
  //           : null;
  //       print('max $greatestDate');
  //       lastGrowthDateNew = greatestDate;
  //     }
  //
  //     if (dateList.length > 0) {
  //       var minDateList = dateList
  //           .where((element) => (selecttedItemDate.isBefore(element)))
  //           .toList();
  //       DateTime? lowesttDate = minDateList.isNotEmpty
  //           ? minDateList.reduce(
  //               (value, element) => value.isBefore(element) ? value : element)
  //           : null;
  //       maxGrowthDate = lowesttDate;
  //       print('min $lowesttDate');
  //     } else
  //       maxGrowthDate = null;
  //   }
  //
  //   return lastGrowthDateNew;
  // }

  Future<DateTime?> minMaxDate(String? createDate) async {
    print("createDate $createDate");
    DateTime? lastMindate;
    if (Global.validString(createDate)) {
      var spledDate = Global.splitData(createDate, " ");
      if (spledDate.length == 2) {
        DateTime? celectedDate = Validate().stringToDateNull(spledDate[0]);
        if (celectedDate != null) {
          DateTime todayDate =
              Validate().stringToDate(Validate().currentDate());
          lastMindate = DateTime(celectedDate.year, celectedDate.month, 1)
              .subtract(Duration(days: 1));

          if (todayDate.month == celectedDate.month) {
            maxGrowthDate = todayDate.add(Duration(days: 1));
          } else {
            lastMindate = DateTime(celectedDate.year, celectedDate.month, 1)
                .subtract(Duration(days: 1));
            DateTime firstDayOfNextMonth = (celectedDate.month < 12)
                ? DateTime(celectedDate.year, celectedDate.month + 1, 1)
                : DateTime(celectedDate.year + 1, 1, 1);

            maxGrowthDate = firstDayOfNextMonth;
          }
        }
      }
    }
    return lastMindate;
  }

  Future<DateTime?> fetchEarliestEnnrollDate() async {
    DateTime? minEnrollDate;
    var childRecord = await EnrolledExitChilrenResponceHelper()
        .enrolledChildByCreche(widget.creche_nameId);
    if (childRecord.length > 0) {
      List<String> enrollDateListString = [];
      childRecord.forEach((element) {
        if (Global.validString(
            Global.getItemValues(element.responces, 'date_of_enrollment'))) {
          enrollDateListString.add(
              Global.getItemValues(element.responces, 'date_of_enrollment'));
        }
      });
      List<DateTime> enrollDatelist = [];
      enrollDateListString.forEach((element) {
        enrollDatelist.add(DateTime.parse(element));
      });
      minEnrollDate = enrollDatelist.reduce(
          (value, element) => value.isBefore(element) ? value : element);
    }
    if (minEnrollDate != null) {
      String cgmguid = '';
      if (!Global.validString(cgmguid)) {
        cgmguid=Validate().randomGuid();
        await ChildGrowthResponseHelper().insertUpdate(
            cgmguid,
            null,
            null,
            widget.creche_nameId,
            null,
            (await Validate().readString(Validate.userName))!,
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(
                DateTime.now().year, DateTime.now().month, 1)),null,null
            );
        childHHData = await ChildGrowthResponseHelper()
            .anthormentryByCreche(widget.creche_nameId);
      }
    }
    await callDatesListAddBackDatedEntryByJadish();

    ///for back dated entry
    return minEnrollDate;
  }

  String showStringDayMonth(String createDate) {
    String schudleDate = '';
    var spledDate = Global.splitData(createDate, " ");
    if (spledDate.length == 2) {
      DateTime? celectedDate = Validate().stringToDateNull(spledDate[0]);
      if (celectedDate != null) {
        celectedDate = DateTime(celectedDate.year, celectedDate.month, 1);
        schudleDate = DateFormat('MMM-yyyy').format(celectedDate);
      }
    }

    return schudleDate;
  }

  bool callMeasurementGrwthDate(String? lastGrowthDate) {
    var spledDate = Global.splitData(lastGrowthDate, " ");
    if (spledDate.length == 2) {
      DateTime todayDate = Validate().stringToDate(Validate().currentDate());
      DateTime? celectedDate = Validate().stringToDateNull(spledDate[0]);
      var lastUpdatedDate = celectedDate!.add(Duration(days: 10));
      if (todayDate.isAfter(lastUpdatedDate)) {
        return false;
      } else
        return true;
    } else {
      DateTime todayDate = Validate().stringToDate(Validate().currentDate());
      DateTime? celectedDate = Validate().stringToDateNull(lastGrowthDate!);
      var lastUpdatedDate = celectedDate!.add(Duration(days: 10));
      if (todayDate.isAfter(lastUpdatedDate)) {
        return false;
      } else
        return true;
    }
  }

  bool callMeasurementEditableDate(String? date) {
    bool isEditable = true;
    if (Global.validString(date)) {
      DateTime? selectedDate = DateTime.parse(date.toString());
      DateTime currentDate = DateTime.parse(Validate().currentDate());
      DateTime editableDate =
          DateTime(selectedDate!.year, selectedDate.month + 1, 11);
      if (currentDate.isBefore(editableDate)) {
        isEditable = true;
      } else {
        isEditable = currentDate.isBefore(applicableDate) ? true : false;
      }
    }
    return isEditable;
  }
}
