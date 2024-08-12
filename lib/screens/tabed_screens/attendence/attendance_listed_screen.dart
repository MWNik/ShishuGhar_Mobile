import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/database/helper/child_attendence/child_attendence_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_attendance_responce_model.dart';
import '../../../model/databasemodel/child_for_attendence_model.dart';
import '../../../model/databasemodel/tabVillage_model.dart';
import '../../../model/dynamic_screen_model/enrolled_children_responce_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import 'attendance_form_screen_tab.dart';
import 'attendance_responce_helper.dart';

class AttendanceListedScreen extends StatefulWidget {
  final int? creche_nameId;
  final String? creche_name;

  const AttendanceListedScreen(
      {super.key,
      required this.creche_nameId,
      required this.creche_name});

  @override
  State<AttendanceListedScreen> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceListedScreen> {
  TextEditingController searchController = TextEditingController();
  bool isVisible = false;
  List<ChildAttendanceResponceModel> childAttendance = [];
  List<ChildAttendanceResponceModel> FilteredAttendance = [];
  List<ChildForAttendenceModel> attentcedChild = [];
  List<EnrolledExitChildResponceModel> childForEnrolled = [];
  List<TabVillage> villages = [];
  List<Translation> translats = [];
  List<String> existingDates = [];
  String lng = 'en';
  bool currentDateAttendece=false;
  DateTime? maxDate;
  DateTime? minDate;
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

    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.DateofAttendance,
      CustomText.TotalChildren,
      CustomText.PresChild,
      CustomText.SubOn,
      CustomText.AttenList
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    attendeceChildRecord();
    setState(() {});
  }

  Future<void> attendeceChildRecord() async {
    childAttendance = await AttendanceResponnceHelper()
        .callChildAttendences(widget.creche_nameId!);
    attentcedChild = await ChildAttendenceHelper().callChildAttendences();
    childForEnrolled = await EnrolledExitChilrenResponceHelper()
        .enrolledChildByCreche(widget.creche_nameId!);
    if (childAttendance.isEmpty) {
      maxDate = await fetchEarliestEnrollDate(childForEnrolled);
      DateTime todayDate = Validate().stringToDate(Validate().currentDate());
      if (maxDate != null) {
        if (todayDate.day == maxDate!.day &&
            todayDate.month == maxDate!.month &&
            todayDate.year == maxDate!.year) {
          maxDate = maxDate!.subtract(Duration(days: 1));
        } else if (maxDate!.isBefore(DateTime.parse(Validate().currentDate())
            .subtract(Duration(days: 10)))) {
          maxDate = DateTime.parse(Validate().currentDate())
              .subtract(Duration(days: 10));
        }
      }
    } else {
      existingDates = fetchExistingDates(childAttendance);
    }
    maxDate =
        DateTime.parse(Validate().currentDate()).subtract(Duration(days: 10));

    FilteredAttendance = childAttendance;
    searchController.text = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     floatingActionButton:  currentDateAttendece?null:InkWell(
       onTap: () async {
         String ChildAttenGUID = '';
         if (!Global.validString(ChildAttenGUID)) {
           ChildAttenGUID = Validate().randomGuid();
           var refStatus = await Navigator.of(context).push(
             MaterialPageRoute(
               builder: (BuildContext context) => AddAttendanceScreenFormTab(
                   crexhe_name: widget.creche_name,
                   creche_nameId: widget.creche_nameId,
                   ChildAttenGUID: ChildAttenGUID,
                   lastGrowthDate:maxDate,
                   existingDates:existingDates,
                   isEdit:false),
             ),
           );
           if (refStatus == 'itemRefresh') {
             await attendeceChildRecord();
           }
         }
       },
       child: Image.asset(
         "assets/add_btn.png",
         scale: 2.7,
         color: Color(0xff5979AA),
       ),
     ),
      appBar: CustomAppbar(
        text: Global.returnTrLable(translats, CustomText.AttenList, lng),
        subTitle: widget.creche_name,
        onTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          // Row(
          //   children: [
          //     Expanded(
          //         child: CustomTextFieldRow(
          //       controller: searchController,
          //       onChanged: (value) {},
          //       hintText: 'Search',
          //       prefixIcon: Image.asset(
          //         "assets/search.png",
          //         scale: 2.4,
          //       ),
          //     )),
          //     SizedBox(
          //       width: 10.w,
          //     ),
          //     InkWell(
          //       onTap: () {},
          //       child: Image.asset(
          //         "assets/filter_icon.png",
          //         scale: 2.4,
          //       ),
          //     )
          //   ],
          // ),
          Expanded(
            child: (FilteredAttendance.length > 0)
                ? ListView.builder(
                    itemCount: FilteredAttendance.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var selecteItem = FilteredAttendance[index];
                          var currentRecordDate = Global.getItemValues(FilteredAttendance[index].responces, 'date_of_attendance');
                          if(existingDates.contains(currentRecordDate)){
                            existingDates.remove(currentRecordDate);
                          }

                          String refStatus = '';

                          var lstDate=await callDatesAlredDateList(Global.getItemValues(FilteredAttendance[index].responces!, 'date_of_attendance'));
                            refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AddAttendanceScreenFormTab(
                                            crexhe_name: widget.creche_name,
                                            creche_nameId: selecteItem.creche_id,
                                            ChildAttenGUID: selecteItem.childattenguid!,
                                            lastGrowthDate:lstDate,
                                            minGrowthDate:minDate,
                                            existingDates:existingDates,
                                            isEdit:true)));
                          if (refStatus == 'itemRefresh') {
                            await attendeceChildRecord();
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.DateofAttendance, lng).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.TotalChildren, lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1),
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.PresChild, lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1),
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.SubOn, lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    height: 40.h,
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
                                          Validate().displeDateFormate(Global.getItemValues(
                                              FilteredAttendance[index].responces!,
                                              'date_of_attendance')),
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${attentcedChild.where((element) =>
                                          element.childattenguid==FilteredAttendance[index].childattenguid).toList().length}',
                                          style: Styles.blue125,
                                          strutStyle: StrutStyle(height: .5),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${attentcedChild.where((element) =>
                                          element.childattenguid==FilteredAttendance[index].childattenguid
                                              && element.attendance==1).toList().length}',
                                          style: Styles.blue125,
                                          strutStyle: StrutStyle(height: .5),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Validate().displeDateFormateMobileDateTimeFormate(FilteredAttendance[index].created_at!),
                                          style: Styles.blue125,
                                          strutStyle: StrutStyle(height: .5),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  (FilteredAttendance[index].is_edited==0 && FilteredAttendance[index].is_uploaded==1)?
                                  Image.asset(
                                    "assets/sync.png",
                                    scale: 1.5,
                                  ):
                                  Image.asset(
                                    "assets/sync_gray.png",
                                    scale: 1.5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Text(Global.returnTrLable(
                        translats, CustomText.NorecordAvailable, lng)),
                  ),
          ),
          SizedBox(height: 10.h)
        ]),
      ),
    );
  }

  filterDataQu(String entry) {
    if (entry.length > 0) {
      FilteredAttendance = childAttendance
          .where((element) =>
              (Global.getItemValues(
                      element.responces!, 'hosuehold_head_name'))
                  .toLowerCase()
                  .contains(entry.toLowerCase()) ||
              (Global.getItemValues( element.responces!, 'child_name'))
                  .toLowerCase()
                  .contains(entry.toLowerCase()))
          .toList();
    } else
      FilteredAttendance = childAttendance;
    setState(() {});
  }

  String callVillageName(String crecheItem) {
    String returnValue = '';
    var items = villages
        .where((element) =>
            element.name ==
            int.parse(Global.getItemValues(crecheItem, 'village_id')))
        .toList();
    if (items.length > 0) {
      returnValue = items[0].value!;
    }
    return returnValue;
  }

  // Future<void> callDatesList() async {
  //   var data =
  //   await ChildAttendanceResponceHelper().callChilsAttendanceAllResponces();
  //   if(data.length!=0) {
  //     List<String> dateStringData = [];
  //     data.forEach((element) {
  //       dateStringData
  //           .add(
  //           Global.getItemValues(element.responces!, 'date_of_attendance'));
  //     });
  //     var dateList = dateStringData.map((dateString) {
  //       List<int> dateParts = dateString.split('-').map(int.parse).toList();
  //       return DateTime(dateParts[0], dateParts[1], dateParts[2]);
  //     }).toList();
  //     maxDate = dateList
  //         .reduce((value, element) => value.isAfter(element) ? value : element);
  //     var maDateString = '${maxDate!.year}-${maxDate!.month}-${maxDate!.day}';
  //   }else maxDate=null;
  //   setState(() {});
  // }

  Future<void> callDatesList() async {
    List<String> dateStringData = [];
    childAttendance.forEach((element) {
      var date=Global.getItemValues(element.responces!, 'date_of_attendance');
      if(Global.validString(date)) {
        dateStringData.add(date);
      }
    });
    var dateList = dateStringData.map((dateString) {
      List<int> dateParts = dateString.split('-').map(int.parse).toList();
      return DateTime(dateParts[0], dateParts[1], dateParts[2]);
    }).toList();
    if(dateList.length>0) {
      maxDate = dateList
          .reduce((value, element) => value.isAfter(element) ? value : element);
      currentDateAttendece =
          maxDate == Validate().stringToDate(Validate().currentDate());
    }
    if(maxDate==null){
      maxDate= DateTime.now().subtract(Duration(days: 30));
    }
    // lastGrowthDate = '${maxDate.year}-${maxDate.month}-${maxDate.day}';
  }

  Future<DateTime?> callDatesAlredDateList(String date) async {
    DateTime?  lastGrowthDateNew;
    List<String> dateStringData = [];
    childAttendance.forEach((element) {
      var date=Global.getItemValues(element.responces!, 'date_of_attendance');
      if(Global.validString(date)) {
        dateStringData.add(date);
      }
    });
    var dateList = dateStringData.map((dateString) {
      List<int> dateParts = dateString.split('-').map(int.parse).toList();
      return DateTime(dateParts[0], dateParts[1], dateParts[2]);
    }).toList();

    List<int> dateCuuten = date.split('-').map(int.parse).toList();

    var selecttedItemDate=DateTime(dateCuuten[0], dateCuuten[1], dateCuuten[2]);

    if(dateList.length>0) {
      var maxDateList=dateList.where((element) => (selecttedItemDate.isAfter(element))).toList();
      DateTime? greatestDate = maxDateList.isNotEmpty
          ? maxDateList.reduce((value, element) => value.isAfter(element) ? value : element)
          : null;
      print('max $greatestDate');
      lastGrowthDateNew = greatestDate;
    }

    if(dateList.length>0) {
      var minDateList=dateList.where((element) => (selecttedItemDate.isBefore(element))).toList();
      DateTime? lowesttDate = minDateList.isNotEmpty
          ? minDateList.reduce((value, element) => value.isBefore(element) ? value : element)
          : null;
      minDate=lowesttDate;
      print('min $lowesttDate');
    }else minDate=null;
    if(lastGrowthDateNew==null){
      lastGrowthDateNew= DateTime.now().subtract(Duration(days: 30));
    }

    return lastGrowthDateNew;
  }

  Future<DateTime> fetchEarliestEnrollDate(
      List<EnrolledExitChildResponceModel> childList) async {
    List<String> enrollDatesListString = [];
    childList.forEach((element) {
      enrollDatesListString
          .add(Global.getItemValues(element.responces, 'date_of_enrollment'));
    });
    List<DateTime> enrollDatesList = [];
    enrollDatesListString.forEach((element) {
      enrollDatesList.add(DateTime.parse(element));
    });
    return enrollDatesList
        .reduce((value, element) => value.isAfter(element) ? value : element);
  }

  List<String> fetchExistingDates(List<ChildAttendanceResponceModel> records) {
    List<String> datesStringList = [];
    records.forEach((element) {
      var date = Global.getItemValues(element.responces, 'date_of_attendance');
      if (Global.validString(date)) datesStringList.add(date);
    });

    return datesStringList;
  }
}
