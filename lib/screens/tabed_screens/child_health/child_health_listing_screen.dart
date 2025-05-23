import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar_child.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/backdated_configiration_helper.dart';
import '../../../database/helper/child_health/child_health_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/backdated_configiration_model.dart';
import '../../../model/databasemodel/child_health_respose_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import 'child_health_detail_view_screen.dart';
import 'child_health_details_screen.dart';

class ChildHealthListing extends StatefulWidget {
  final int? enName;
  final String? creche_id;
  final String? chilenrolledGUID;
  final String dateofEnrollment;
  final String childName;
  final String childId;

  const ChildHealthListing(
      {super.key,
      required this.enName,
      required this.creche_id,
      required this.chilenrolledGUID,
      required this.dateofEnrollment,
      required this.childName,
      required this.childId});

  @override
  State<ChildHealthListing> createState() => _ChildHealthListingState();
}

class _ChildHealthListingState extends State<ChildHealthListing> {
  List<ChildHealthResponceModel> childHeathResponce = [];
  List<ChildHealthResponceModel> filterhealthData = [];
  List<ChildHealthResponceModel> usynchedList = [];
  List<ChildHealthResponceModel> allList = [];
  List<Translation> translats = [];
  String lng = 'en';
  List<String> existingDates = [];
  bool isOnlyUnsyched = false;
  String? role;
  BackdatedConfigirationModel? backdatedConfigirationModel;
  // DateTime? maxDate;

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
    backdatedConfigirationModel = await BackdatedConfigirationHelper().excuteBackdatedConfigirationModel(CustomText.ChildHealthDetails);
    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.DateS,
      CustomText.symptoms,
      CustomText.actionTaken,
      CustomText.ChildHealth,
      CustomText.all,
      CustomText.unsynched,
      CustomText.ChildHealthDetail,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchChildevents();
  }

  Future<void> fetchChildevents() async {
    childHeathResponce = await ChildHealthTabResponceHelper()
        .childEventByChild(widget.creche_id, widget.chilenrolledGUID!);
    usynchedList =
        childHeathResponce.where((element) => element.is_edited == 1).toList();
    allList = childHeathResponce;
    filterhealthData = isOnlyUnsyched ? usynchedList : allList;
    existingDates.clear();
    childHeathResponce.forEach((element) {
      var date = Global.getItemValues(element.responces, 'date');
      if (Global.validString(date)) existingDates.add(date);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: role == CustomText.crecheSupervisor.trim()
          ? InkWell(
              onTap: () async {
                String child_health_guid = '';
                if (!(Global.validString(child_health_guid))) {
                  child_health_guid = Validate().randomGuid();
                  String? minDate;
                  if(Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0){
                    minDate=await Validate().callMinDate(widget.dateofEnrollment, backdatedConfigirationModel!.back_dated_data_entry_allowed!);
                  }
                  var refStatus = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ChildHealthDetailScreen(
                                  child_health_guid: child_health_guid,
                                  enName: widget.enName!,
                                  creche_id: widget.creche_id,
                                  chilenrolledGUID: widget.chilenrolledGUID,
                                  lastDate: Global.validString(minDate)?Validate().stringToDate(minDate!).subtract(Duration(days: 1)):null,
                                  childName: widget.childName,
                                  childId: widget.childId,
                                  existingDates: existingDates)));
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
            )
          : SizedBox(),
      appBar: CustomChildAppbar(
        text:
            Global.returnTrLable(translats, CustomText.ChildHealthDetail, lng),
        subTitle1: widget.childName,
        subTitle2: widget.childId,
        onTap: () => Navigator.pop(context, 'itemRefresh'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
        child: Column(children: [
          role == CustomText.crecheSupervisor
              ? Align(
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
                      await fetchChildevents();
                    },
                  ),
                )
              : SizedBox(),
          Expanded(
            child: (filterhealthData.length > 0)
                ? ListView.builder(
                    itemCount: filterhealthData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {

                          bool isEdited=await Validate().checkEditable(filterhealthData[index].created_at, Validate().callEditfromCnfig(backdatedConfigirationModel));
                          String? minDate;
                          if(Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0){
                            minDate=await Validate().callMinDate(widget.dateofEnrollment, backdatedConfigirationModel!.back_dated_data_entry_allowed!);
                          }
                          
                          bool isUnEditable=true;
                          if(isEdited && role == CustomText.crecheSupervisor){
                            isUnEditable=false;
                          }


                          if (existingDates.contains(Global.getItemValues(
                              filterhealthData[index].responces, 'date'))) {
                            var currentRecordDate = Global.getItemValues(
                                filterhealthData[index].responces, 'date');
                            existingDates.remove(currentRecordDate);
                          }
                          var refStatus = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      isUnEditable
                                          ? ChildHealthDetailViewScreen(
                                              child_health_guid:
                                                  filterhealthData[index]
                                                      .child_health_guid,
                                              enName: widget.enName!,
                                              creche_id: widget.creche_id,
                                              chilenrolledGUID:
                                                  widget.chilenrolledGUID,
                                              childId: widget.childId,
                                              childName: widget.childName,
                                              type: 1,
                                            )
                                          : ChildHealthDetailScreen(
                                              child_health_guid:
                                                  filterhealthData[index]
                                                      .child_health_guid,
                                              enName: widget.enName!,
                                              creche_id: widget.creche_id,
                                              chilenrolledGUID:
                                                  widget.chilenrolledGUID,
                                              lastDate:Global.validString(minDate)?Validate().stringToDate(minDate!).subtract(Duration(days: 1)):null,
                                              childId: widget.childId,
                                              childName: widget.childName,
                                              existingDates: existingDates)));
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
                                        '${Global.returnTrLable(translats, CustomText.DateS, lng).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.symptoms, lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1.2),
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.actionTaken, lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1.2),
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
                                                  filterhealthData[index]
                                                      .responces!,
                                                  'date')),
                                          style: Styles.cardBlue10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.getItemValues(
                                              filterhealthData[index]
                                                  .responces!,
                                              'symptoms'),
                                          maxLines: 1,
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: 1.2),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.getItemValues(
                                              filterhealthData[index]
                                                  .responces!,
                                              'action_taken'),
                                          style: Styles.cardBlue10,
                                          maxLines: 1,
                                          strutStyle: StrutStyle(height: 1.2),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // Text(
                                        //   Global.getItemValues(
                                        //       childHHData[index].responces!,
                                        //       'age_months'),
                                        //   style: Styles.cardBlue10,
                                        //   strutStyle: StrutStyle(height: .5),
                                        //   overflow: TextOverflow.ellipsis,
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  (filterhealthData[index].is_edited == 0 &&
                                          filterhealthData[index].is_uploaded ==
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
          ),
        ]),
      ),
    );
  }

  // Future<void> fetchChildDetail() async {
  //   //added
  //   List<String> datesListString = [];
  //   if (childHeathResponce.isNotEmpty) {
  //     childHeathResponce.forEach((element) {
  //       var date = Global.getItemValues(element.responces!, 'date');
  //       if (Global.validString(date)) {
  //         datesListString.add(date);
  //       }
  //     });
  //     var dateList = datesListString.map((dateString) {
  //       List<int> dateParts = dateString.split('-').map(int.parse).toList();
  //       return DateTime(dateParts[0], dateParts[1], dateParts[2]);
  //     }).toList();
  //     if (dateList.length > 0) {
  //       lastDate = dateList.reduce(
  //           (value, element) => value.isAfter(element) ? value : element);
  //       // currentDate =
  //       //     lastDate == Validate().stringToDate(Validate().currentDate());
  //     }
  //   }
  // }

  // Future<DateTime?> callDatesAlredDateList(String date) async {
  //   DateTime? lastGrowthDateNew;
  //   List<String> dateStringData = [];
  //   childHeathResponce.forEach((element) {
  //     var date = Global.getItemValues(element.responces!, 'date');
  //     if (Global.validString(date)) {
  //       dateStringData.add(date);
  //     }
  //   });
  //   var dateList = dateStringData.map((dateString) {
  //     List<int> dateParts = dateString.split('-').map(int.parse).toList();
  //     return DateTime(dateParts[0], dateParts[1], dateParts[2]);
  //   }).toList();
  //
  //   List<int> dateCuuten = date.split('-').map(int.parse).toList();
  //
  //   var selecttedItemDate =
  //       DateTime(dateCuuten[0], dateCuuten[1], dateCuuten[2]);
  //
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
  //
  //   if (dateList.length > 0) {
  //     var minDateList = dateList
  //         .where((element) => (selecttedItemDate.isBefore(element)))
  //         .toList();
  //     DateTime? lowesttDate = minDateList.isNotEmpty
  //         ? minDateList.reduce(
  //             (value, element) => value.isBefore(element) ? value : element)
  //         : null;
  //     // maxDate=lowesttDate;
  //     print('min $lowesttDate');
  //   }
  //   // else maxDate=null;
  //   if (lastGrowthDateNew == null) {
  //     List<int> dateParts =
  //         widget.dateofEnrollment.split('-').map(int.parse).toList();
  //     lastGrowthDateNew = DateTime(dateParts[0], dateParts[1], dateParts[2])
  //         .subtract(Duration(days: 1));
  //   }
  //
  //   return lastGrowthDateNew;
  // }
}
