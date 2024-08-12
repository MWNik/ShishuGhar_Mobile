import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_children_responce_model.dart';
import 'package:shishughar/screens/tabed_screens/child_exit/child_exit_details_screen.dart';
import 'package:shishughar/screens/tabed_screens/child_exit/exit_enrolld_child/exit_enrolled_child_tab.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/child_exit/child_exit_response_Helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_exit_response_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../screens/tabed_screens/child_exit/exited_child_detail_view_screen.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';

class ExitedChildListingScreen extends StatefulWidget {
  final String? creche_id;

  const ExitedChildListingScreen({
    super.key,
    required this.creche_id,
  });

  @override
  State<ExitedChildListingScreen> createState() =>
      _ExitedChildListingScreenState();
}

class _ExitedChildListingScreenState extends State<ExitedChildListingScreen> {
  List<Map<String, dynamic>> childExitData = [];
  List<Translation> translats = [];
  String lng = 'en';
  List<OptionsModel> reasonOfExit = [];
  bool currentDate = false;
  DateTime? lastDate;
  DateTime? maxDate;

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
      CustomText.ChildName,
      CustomText.ChildId,
      CustomText.DateOfExit,
      CustomText.Village,
      CustomText.AgeOnDayOfExit,
      CustomText.ReasForExit
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    reasonOfExit =
        await OptionsModelHelper().getMstCommonOptions('Reason for child exit',lng);

    await fetchChildevents();
  }

  Future<void> fetchChildevents() async {
    childExitData = await ChildExitResponceHelper()
        .childExtedlistingByCrechenew(Global.stringToInt(widget.creche_id));

    await fetchChildDetail();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          Expanded(
            child: (childExitData.length > 0)
                ? ListView.builder(
                    itemCount: childExitData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                        /*  var detailMap = await fetchChildtDetailbyGuid(
                              childExitData[index]['ChildEnrollGUID']!);*/
                        //  var childId = detailMap.keys.first;
                          var date_of_enrollment = Global.getItemValues(childExitData[index]['responces'], 'date_of_enrollment');

                          var created_at = DateTime.parse(childExitData[index]['created_at'].toString());
                          var date = DateTime(created_at.year,created_at.month,created_at.day);
                          bool isEditable = date.add(Duration(days: 16)).isAfter(DateTime.parse(Validate().currentDate()));

                         // var childName = detailMap.values.first;
                          var refStatus = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                     ExitEnrolledChilrenTab(
                                         CHHGUID: childExitData[index]['CHHGUID'],
                                         EnrolledChilGUID: childExitData[index]['ChildEnrollGUID'],
                                         HHname: childExitData[index]['HHname'],
                                         crecheId: Global.stringToInt(widget.creche_id),
                                         HHGUID: Global.getItemValues(childExitData[index]['responces'], 'hhguid'),
                                         isNew: 0,
                                         isImageUpdate: false,
                                         isEditable: isEditable,
                                         minDate:date_of_enrollment)));
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.ChildName, lng).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.ChildId, lng).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.DateOfExit, lng).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.AgeOnDayOfExit, lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1),
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.ReasForExit, lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1),
                                      ),
                                      // Text(
                                      //   '${Global.returnTrLable(translats, 'Child Age (In Months)', lng).trim()} : ',
                                      //   style: Styles.black104,
                                      //   strutStyle: StrutStyle(height: 1),
                                      // ),
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
                                          Global.getItemValues(
                                              childExitData[index]
                                                  ['responces'],
                                              'child_name'),
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.getItemValues(
                                              childExitData[index]
                                                  ['responces'],
                                              'child_id'),
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Validate().displeDateFormate(
                                              Global.getItemValues(
                                                  childExitData[index]
                                                      ['responces'],
                                                  'date_of_exit')),
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.getItemValues(
                                              childExitData[index]['responces'],
                                              'age_of_exit'),
                                          style: Styles.blue125,
                                          strutStyle: StrutStyle(height: .5),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          getReasonOfExit(Global.getItemValues(
                                              childExitData[index]['responces'],
                                              'reason_for_exit')),
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  (childExitData[index]['is_edited'] == 0 &&
                                          childExitData[index]['is_uploaded'] ==
                                              1)
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

  String getReasonOfExit(String reasonId) {
    String reason = '';
    var items = reasonOfExit
        .where((element) => element.name.toString() == reasonId)
        .toList();
    if (items.length > 0) {
      reason = items[0].values!;
    }
    return reason;
  }

  Future<Map<String, String>> fetchChildtDetailbyGuid(String guid) async {
    List<EnrolledExitChildResponceModel> childRecord =
        await EnrolledExitChilrenResponceHelper().callChildrenResponce(guid);
    var childId = Global.getItemValues(childRecord[0].responces, 'child_id');
    var childName =
        Global.getItemValues(childRecord[0].responces, 'child_name');
    Map<String, String> result = {childId: childName};
    return result;
  }

  Future<void> fetchChildDetail() async {
    //added
    List<String> datesListString = [];
    if (childExitData.isNotEmpty) {
      childExitData.forEach((element) {
        var date = Global.getItemValues(element['responces'], 'date_of_exit');
        if (Global.validString(date)) {
          datesListString.add(date);
        }
      });
      var dateList = datesListString.map((dateString) {
        List<int> dateParts = dateString.split('-').map(int.parse).toList();
        return DateTime(dateParts[0], dateParts[1], dateParts[2]);
      }).toList();
      if (dateList.length > 0) {
        lastDate = dateList.reduce(
            (value, element) => value.isAfter(element) ? value : element);
        currentDate =
            lastDate == Validate().stringToDate(Validate().currentDate());
      }
    }
  }

  // Future<DateTime?> callDatesAlredDateList(String date) async {
  //   DateTime? lastGrowthDateNew;
  //   List<String> dateStringData = [];
  //   childExitData.forEach((element) {
  //     var date = Global.getItemValues(element.responces!, 'date_of_exit');
  //     if (Global.validString(date)) {
  //       dateStringData.add(date);
  //     }
  //   });
  //   var dateList = dateStringData.map((dateString) {
  //     List<int> dateParts = dateString.split('-').map(int.parse).toList();
  //     return DateTime(dateParts[0], dateParts[1], dateParts[2]);
  //   }).toList();

  //   List<int> dateCuuten = date.split('-').map(int.parse).toList();

  //   var selecttedItemDate =
  //       DateTime(dateCuuten[0], dateCuuten[1], dateCuuten[2]);

  //   if (dateList.length > 0) {
  //     var maxDateList = dateList
  //         .where((element) => (selecttedItemDate.isAfter(element)))
  //         .toList();
  //     DateTime? greatestDate = maxDateList.isNotEmpty
  //         ? maxDateList.reduce(
  //             (value, element) => value.isAfter(element) ? value : element)
  //         : null;
  //     print('max $greatestDate');
  //     lastGrowthDateNew = greatestDate;
  //   }

  //   if (dateList.length > 0) {
  //     var minDateList = dateList
  //         .where((element) => (selecttedItemDate.isBefore(element)))
  //         .toList();
  //     DateTime? lowesttDate = minDateList.isNotEmpty
  //         ? minDateList.reduce(
  //             (value, element) => value.isBefore(element) ? value : element)
  //         : null;
  //     maxDate = lowesttDate;
  //     print('min $lowesttDate');
  //   } else
  //     maxDate = null;
  //   if (lastGrowthDateNew == null) {
  //     List<int> dateParts =
  //         widget.dateOfEnrollment.split('-').map(int.parse).toList();
  //     lastGrowthDateNew = DateTime(dateParts[0], dateParts[1], dateParts[2])
  //         .subtract(Duration(days: 1));
  //   }

  //   return lastGrowthDateNew;
  // }
}
