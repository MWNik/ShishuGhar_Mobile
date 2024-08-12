import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar_child.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/child_event/child_event_response_helper.dart';
import 'package:shishughar/screens/tabed_screens/child_event/enrolled_child_event_details_screen.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_event_tab_response_model.dart';
import '../../../style/styles.dart';
import 'child_event_detail_view_screen.dart';

class ChildEventListingScreen extends StatefulWidget {
  final int? enName;
  final String? creche_id;
  final String? chilenrolledGUID;
  final String dateOfEnrollment;
  final String childId;
  final String childName;

  const ChildEventListingScreen({super.key, required this.enName,
    required this.creche_id,
    required this.chilenrolledGUID,
    required this.dateOfEnrollment,
    required this.childId,
    required this.childName
  });

  @override
  State<ChildEventListingScreen> createState() =>
      _ChildEventListingScreenState();
}

class _ChildEventListingScreenState extends State<ChildEventListingScreen> {
  List<ChildEventTabResponceModel> childEventData = [];
  List<Translation> translats = [];
  String lng = 'en';
  List<String> existingDates = [];
  DateTime? lastDate;

  // DateTime? maxDate;

  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    List<int> dateParts = widget.dateOfEnrollment.split('-')
        .map(int.parse)
        .toList();
    lastDate = DateTime(dateParts[0], dateParts[1], dateParts[2]).subtract(
        Duration(days: 1));

    var currDate=Validate().currentDate();
    List<int> crrntDateParts = currDate.split('-').map(int.parse).toList();
    var backDate = DateTime(crrntDateParts[0], crrntDateParts[1], crrntDateParts[2])
        .subtract(Duration(days: 30));
    if(lastDate != null){
      if(lastDate!.isBefore(backDate!)){
        lastDate = backDate;
      }
    }else if (lastDate == null){
      lastDate = backDate;
    }

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
      CustomText.ChildEvents,
      CustomText.DateS,
      CustomText.detail
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));


    await fetchChildevents();
  }

  Future<void> fetchChildevents() async {
    childEventData = await ChildEventTabResponceHelper()
        .childEventsByChild(widget.creche_id, widget.chilenrolledGUID);
    existingDates.clear();
    if (childEventData.isNotEmpty) {
      childEventData.forEach((element) {
        var date = Global.getItemValues(element.responces, 'date');
        if (Global.validString(date)) existingDates.add(date);
      });
    }
    // await fetchChildDetail();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          String chilevenGuid = '';
          if (!(Global.validString(chilevenGuid))) {
            chilevenGuid = Validate().randomGuid();
            var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    EnrolledChildDetailsSccreen(
                      childEventGuid: chilevenGuid,
                      enName: widget.enName!,
                      chilenrolledGUID: widget.chilenrolledGUID!,
                      creche_id: widget.creche_id,
                      lastDate: lastDate,
                      childId: widget.childId,
                      childName: widget.childName,
                      existingDates: existingDates,
                    )));
            if (refStatus == 'itemRefresh') {
              fetchChildevents();
            }
          }
        },
        child: Image.asset(
          "assets/add_btn.png",
          scale: 2.7,
          color: Color(0xff5979AA),
        ),
      ),
      appBar: CustomChildAppbar(
        text: Global.returnTrLable(translats, CustomText.ChildEvents, lng),
        subTitle1: widget.childName,
        subTitle2: widget.childId,
        onTap: () => Navigator.pop(context, 'itemRefresh'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          Expanded(
            child: (childEventData.length > 0)
                ? ListView.builder(
                itemCount: childEventData.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      var created_at = DateTime.parse(childEventData[index].created_at.toString());
                      var recordDate =
                      DateTime(created_at.year,created_at.month,created_at.day);
                      bool isUnEditable = recordDate
                          .add(Duration(days: 15))
                          .isBefore(
                          DateTime.parse(Validate().currentDate()));

                      if(existingDates.contains(Global.getItemValues(childEventData[index].responces, 'date'))){
                        var currentRecordDate = Global.getItemValues(childEventData[index].responces, 'date');
                        existingDates.remove(currentRecordDate);
                      }

                      // var lstDate=await callDatesAlredDateList(Global.getItemValues(childEventData[index].responces!, 'date'));
                      var refStatus = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  isUnEditable?ChildEventDetailsViewScreen(
                                    type: 1,
                                    childEventGuid:
                                    childEventData[index]
                                        .child_event_guid,
                                    enName: widget.enName!,
                                    chilenrolledGUID:
                                    childEventData[index]
                                        .childenrolledguid,
                                    creche_id: widget.creche_id,

                                    // maxDate:maxDate,
                                    childId: widget.childId,
                                    childName: widget.childName,
                                  ):EnrolledChildDetailsSccreen(
                                    childEventGuid: childEventData[index]
                                        .child_event_guid,
                                    enName: widget.enName!,
                                    chilenrolledGUID: childEventData[index]
                                        .childenrolledguid,
                                    creche_id: widget.creche_id,
                                    lastDate: lastDate,
                                    // maxDate:maxDate,
                                    childId: widget.childId,
                                    childName: widget.childName,
                                    existingDates: existingDates,
                                  )));
                      if (refStatus == 'itemRefresh') {
                        await fetchChildevents();
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
                                    '${Global.returnTrLable(
                                        translats, CustomText.DateS, lng).trim()} : ',
                                    style: Styles.black104,
                                    strutStyle: StrutStyle(height: 1),
                                  ),
                                  Text(
                                    '${Global.returnTrLable(
                                        translats, CustomText.detail, lng).trim()} : ',
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
                                      Validate().displeDateFormate(
                                          Global.getItemValues(
                                              childEventData[index].responces!,
                                              'date')),
                                      style: Styles.blue125,
                                      strutStyle: StrutStyle(height: .5),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      Global.getItemValues(
                                          childEventData[index].responces!,
                                          'details'),
                                      maxLines: 1,
                                      style: Styles.blue125,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              (childEventData[index].is_edited == 0 &&
                                  childEventData[index].is_uploaded == 1) ?
                              Image.asset(
                                "assets/sync.png",
                                scale: 1.5,
                              ) :
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
          )
        ]),
      ),
    );
  }

//   Future<void> fetchChildDetail() async {
//     //added
//     List<String> datesListString = [];
//     if (childEventData.isNotEmpty) {
//       childEventData.forEach((element) {
//         var date=Global.getItemValues(element.responces!, 'date');
//         if(Global.validString(date)) {
//           datesListString.add(date);
//         }
//       });
//       var dateList = datesListString.map((dateString) {
//         List<int> dateParts = dateString.split('-').map(int.parse).toList();
//         return DateTime(dateParts[0], dateParts[1], dateParts[2]);
//       }).toList();
//       if(dateList.length>0) {
//         lastDate = dateList
//             .reduce((value, element) => value.isAfter(element) ? value : element);
//         currentDate =
//             lastDate == Validate().stringToDate(Validate().currentDate());
//       }
//
//     }
//
//   }
//
//   Future<DateTime?> callDatesAlredDateList(String date) async {
//     DateTime?  lastGrowthDateNew;
//     List<String> dateStringData = [];
//     childEventData.forEach((element) {
//       var date=Global.getItemValues(element.responces!, 'date');
//       if(Global.validString(date)) {
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
//     var selecttedItemDate=DateTime(dateCuuten[0], dateCuuten[1], dateCuuten[2]);
//
//     if(dateList.length>0) {
//       var maxDateList=dateList.where((element) => (selecttedItemDate.isAfter(element))).toList();
//       DateTime? greatestDate = maxDateList.isNotEmpty
//           ? maxDateList.reduce((value, element) => value.isAfter(element) ? value : element)
//           : null;
//       print('max $greatestDate');
//       lastGrowthDateNew = greatestDate;
//     }
//
//     if(dateList.length>0) {
//       var minDateList=dateList.where((element) => (selecttedItemDate.isBefore(element))).toList();
//       DateTime? lowesttDate = minDateList.isNotEmpty
//           ? minDateList.reduce((value, element) => value.isBefore(element) ? value : element)
//           : null;
//       maxDate=lowesttDate;
//       print('min $lowesttDate');
//     }else maxDate=null;
// if(lastGrowthDateNew==null) {
//   List<int> dateParts = widget.dateOfEnrollment.split('-')
//       .map(int.parse)
//       .toList();
//   lastGrowthDateNew = DateTime(dateParts[0], dateParts[1], dateParts[2]).subtract(
//       Duration(days: 1));
// }
//     return lastGrowthDateNew;
//   }

}
