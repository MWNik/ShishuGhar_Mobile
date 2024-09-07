import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../../../database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../database/helper/village_data_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_growth_responce_model.dart';
import '../../../model/databasemodel/tabVillage_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import 'child_growth_expended_form_screen.dart';
import 'child_growth_form_screen.dart';

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
  List<Translation> translats = [];
  List<TabVillage> villages = [];
  String lng = 'en';
  DateTime? lastGrowthDate;
  DateTime? maxGrowthDate;

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

    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village
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
    if (childHHData.length > 0)
      await callDatesList();
    else
      lastGrowthDate = await fetchEarliestEnnrollDate();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: currentDateGrowth?null:InkWell(
      //   onTap: () async {
      //     String cgmguid = '';
      //     if (!Global.validString(cgmguid)) {
      //       cgmguid = Validate().randomGuid();
      //       var refStatus = await Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (BuildContext context) => ChildGrowthExpendedFormScreen(
      //             creche_nameId: widget.creche_nameId,
      //             creche_name: widget.creche_name,
      //             cgmguid: cgmguid,
      //             lastGrowthDate: lastGrowthDate,
      //           ),
      //         ),
      //       );
      //       if (refStatus == 'itemRefresh') {
      //         fetchEnrolleChild();
      //       }
      //     }
      //   },
      //   child: Image.asset(
      //     "assets/add_btn.png",
      //     scale: 2.7,
      //     color: Color(0xff5979AA),
      //   ),
      // ),
      appBar: CustomAppbar(
        text: Global.returnTrLable(translats, CustomText.GrowthMonitoring, lng),
        subTitle: widget.creche_name,
        onTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
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
                            var lstDate = await minMaxDate(childHHData[index].created_at);

                            if(callMeasurementEditableDate(childHHData[index].created_at!)){
                              var refStatus = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChildGrowthExpendedFormScreen(
                                            creche_nameId: widget.creche_nameId,
                                            creche_name: widget.creche_name,
                                            cgmguid: childHHData[index].cgmguid!,
                                            lastGrowthDate: lstDate,
                                            minGrowthDate: maxGrowthDate,
                                            createdAt: childHHData[index].created_at,
                                            isNew: childHHData[index].responces != null?true:false,
                                          )));

                              if (refStatus == 'itemRefresh') {
                                await fetchEnrolleChild();
                              }
                            }else Validate().singleButtonPopup(CustomText.growthMonitoring, CustomText.ok, false, context);

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
                                        // Text(
                                        //   '${Global.returnTrLable(translats, "Height", lng).trim()} : ',
                                        //   style: Styles.black104,
                                        //   strutStyle: StrutStyle(height: 1),
                                        // ),
                                        // Text(
                                        //   '${Global.returnTrLable(translats, 'Weight', lng).trim()} : ',
                                        //   style: Styles.black104,
                                        //   strutStyle: StrutStyle(height: 1),
                                        // ),
                                        // Text(
                                        //   '${Global.returnTrLable(translats, 'Child Age (In Months)', lng).trim()} : ',
                                        //   style: Styles.black104,
                                        //   strutStyle: StrutStyle(height: 1),
                                        // ),
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
                                            style: Styles.blue125,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // Text(
                                          //   Global.getItemValues(
                                          //       childHHData[index].responces!,
                                          //       'height'),
                                          //   style: Styles.blue125,
                                          //   strutStyle: StrutStyle(height: .5),
                                          //   overflow: TextOverflow.ellipsis,
                                          // ),
                                          // Text(
                                          //   Global.getItemValues(
                                          //       childHHData[index].responces!,
                                          //       'weight'),
                                          //   style: Styles.blue125,
                                          //   strutStyle: StrutStyle(height: .5),
                                          //   overflow: TextOverflow.ellipsis,
                                          // ),
                                          // Text(
                                          //   Global.getItemValues(
                                          //       childHHData[index].responces!,
                                          //       'age_months'),
                                          //   style: Styles.blue125,
                                          //   strutStyle: StrutStyle(height: .5),
                                          //   overflow: TextOverflow.ellipsis,
                                          // ),
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
        DateTime messureDate = DateTime(dateMesured.year,dateMesured.month);
        DateTime tDate = Validate().stringToDate(Validate().currentDate());
        DateTime todayDate = DateTime(tDate.year,tDate.month);
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
                    created_at: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(messureDate.year,messureDate.month,DateTime.now().day)));
                await ChildGrowthResponseHelper().inserts(item);
              }

              //     Validate().randomGuid(),
              //     null,
              //     widget.creche_nameId,
              //     null,
              //     (await Validate().readString(Validate.userName))!);

            }

      } else if (dateAladyCreate != null && dateMesured == null) {
        DateTime messureDate = DateTime(dateAladyCreate.year,dateAladyCreate.month);
        DateTime tDate = Validate().stringToDate(Validate().currentDate());
        DateTime todayDate = DateTime(tDate.year,tDate.month);
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
                created_at: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(messureDate.year,messureDate.month,DateTime.now().day)));
            await ChildGrowthResponseHelper().inserts(item);
          }

          //     Validate().randomGuid(),
          //     null,
          //     widget.creche_nameId,
          //     null,
          //     (await Validate().readString(Validate.userName))!);

        }
      } else if (dateAladyCreate != null && dateMesured != null) {
        DateTime messureDate = DateTime(dateAladyCreate.year,dateAladyCreate.month);
        if (dateAladyCreate.isAfter(dateMesured)) {
          messureDate = DateTime(dateAladyCreate.year,dateAladyCreate.month);
        }else  messureDate = DateTime(dateMesured.year,dateMesured.month);

        DateTime tDate = Validate().stringToDate(Validate().currentDate());
        DateTime todayDate = DateTime(tDate.year,tDate.month);


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
                created_at: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(messureDate.year,messureDate.month,DateTime.now().day)));
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
        if(Global.validString(Global.getItemValues(element.responces, 'date_of_enrollment'))){
          enrollDateListString
              .add(Global.getItemValues(element.responces, 'date_of_enrollment'));
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
        cgmguid = Validate().randomGuid();
        await ChildGrowthResponseHelper().insertUpdate(
            Validate().randomGuid(),null,
            null,
            widget.creche_nameId,
            null,
            (await Validate().readString(Validate.userName))!);
        childHHData = await ChildGrowthResponseHelper()
            .anthormentryByCreche(widget.creche_nameId);
      }
    }
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

  bool callMeasurementGrwthDate(String? lastGrowthDate){
    var spledDate = Global.splitData(lastGrowthDate, " ");
    if (spledDate.length == 2) {
      DateTime todayDate = Validate().stringToDate(Validate().currentDate());
      DateTime? celectedDate = Validate().stringToDateNull(spledDate[0]);
      var lastUpdatedDate=celectedDate!.add(Duration(days: 10));
      if(todayDate.isAfter(lastUpdatedDate)){
        return false;
      }else return true;
    }else{
      DateTime todayDate = Validate().stringToDate(Validate().currentDate());
      DateTime? celectedDate = Validate().stringToDateNull(lastGrowthDate!);
      var lastUpdatedDate=celectedDate!.add(Duration(days: 10));
      if(todayDate.isAfter(lastUpdatedDate)){
        return false;
      }else return true;
    }

  }

  bool callMeasurementEditableDate(String? date) {
    bool isEditable = true;
    if(Global.validString(date)){
      DateTime? selectedDate = DateTime.parse(date.toString());
      DateTime currentDate = DateTime.parse(Validate().currentDate());
      DateTime editableDate = DateTime(selectedDate!.year,selectedDate.month +1,11);
      if(currentDate.isBefore(editableDate)){
        isEditable = true;
      } else {
        isEditable = false;
      }
    }
    return isEditable;
  }
}
