import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/follow_up/child_followUp_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_followUp_response_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'child_followUp_tab_screen.dart';

class CompletedChildFollowUpsForChildListingScreen extends StatefulWidget {
  final String tabTitle;
  final String childenrollguid;
  final int creche_id;
  int? childNameId;
  final String childId;
  final String childName;

  CompletedChildFollowUpsForChildListingScreen({
    super.key,
    required this.tabTitle,
    required this.childenrollguid,
    required this.creche_id,
    this.childNameId,
    required this.childId,
    required this.childName,
  });

  @override
  State<CompletedChildFollowUpsForChildListingScreen> createState() =>
      _ChildFollowUpsListingScreenState();
}

class _ChildFollowUpsListingScreenState
    extends State<CompletedChildFollowUpsForChildListingScreen> {
  List<ChildFollowUpTabResponceModel> followUpsList = [];
  List<ChildFollowUpTabResponceModel> usynchedList = [];
  List<ChildFollowUpTabResponceModel> allList = [];
  bool isOnlyUnsyched = false;
  List<Translation> translats = [];
  String lng = 'en';
  List<CresheDatabaseResponceModel> crecheData = [];
  var applicableDate = Validate().stringToDate(Validate().currentDate());

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
      CustomText.Creches,
      CustomText.all,
      CustomText.unsynched,
      CustomText.schduleDate,
      CustomText.followup_visit_date,
      CustomText.weight
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchFollowUpList();
  }

  Future<void> fetchFollowUpList() async {
    followUpsList = await ChildFollowUpTabResponseHelper()
        .callCompletedReffralForChild(widget.childenrollguid);
    usynchedList =
        followUpsList.where((element) => element.is_edited == 1).toList();
    allList = followUpsList;
    followUpsList = isOnlyUnsyched ? usynchedList : allList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
        child: Column(children: [
          Container(
            child: Align(
              alignment: Alignment.topRight,
              child: AnimatedRollingSwitch(
                title1: Global.returnTrLable(translats, CustomText.all, lng),
                title2:
                    Global.returnTrLable(translats, CustomText.unsynched, lng),
                isOnlyUnsynched: isOnlyUnsyched,
                onChange: (value) async {
                  setState(() {
                    isOnlyUnsyched = value;
                  });
                  await fetchFollowUpList();
                },
              ),
            ),
          ),
          Expanded(
            child: (followUpsList.length > 0)
                ? ListView.builder(
                    itemCount: followUpsList.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var child_followup_guid =
                              followUpsList[index].child_followup_guid;

                          var currentDate =
                              DateTime.parse(Validate().currentDate());
                          bool isEditable = currentDate.isBefore(DateTime.parse(
                                  followUpsList[index].created_at.toString())
                              .add(Duration(days: 7)));
                          var dateString = followUpsList[index].schedule_date!;
                          var parts = dateString
                              .toString()
                              .split('-')
                              .map(int.parse)
                              .toList();
                          var date = DateTime(parts[0], parts[1], parts[2]);
                          var backDate = currentDate.isBefore(applicableDate)
                              ? DateTime(1992)
                              : DateTime.parse(Validate().currentDate())
                                  .subtract(Duration(days: 7));
                          var backDateSD = date.subtract(Duration(days: 7));

                          if (Global.validString(child_followup_guid)) {
                            var refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChildFollowUpTabScreen(
                                          tabTitle: widget.tabTitle,
                                          child_referral_guid:
                                              followUpsList[index]
                                                  .child_referral_guid!,
                                          discharge_date: Global.getItemValues(
                                              followUpsList[index].responces,
                                              'discharge_date'),
                                          followup_visit_date:
                                              followUpsList[index]
                                                  .followup_visit_date!,
                                          schedule_date: followUpsList[index]
                                              .schedule_date!,
                                          enrollChildGuid:
                                              widget.childenrollguid,
                                          creche_id: widget.creche_id,
                                          child_id: widget.childNameId,
                                          child_followup_guid:
                                              child_followup_guid!,
                                          childId: widget.childId,
                                          childName: widget.childName,
                                          minDate: backDate.isBefore(backDateSD)
                                              ? backDateSD
                                              : backDate,
                                          isEditable: currentDate
                                                  .isBefore(applicableDate)
                                              ? true
                                              : isEditable,
                                        )));

                            if (refStatus == 'itemRefresh') {
                              await fetchFollowUpList();
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
                                          '${Global.returnTrLable(translats, CustomText.schduleDate, lng).trim()} : ',
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.followup_visit_date, lng).trim()} : ',
                                          strutStyle: StrutStyle(height: 1.2),
                                          style: Styles.black104,
                                        ),
                                        /*Text(
                                      '${Global.returnTrLable(translats, CustomText.height, lng).trim()} : ',
                                      style: Styles.black104,
                                    ),*/
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.weight, lng).trim()} : ',
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
                                            Validate().displeDateFormate(
                                                followUpsList[index]
                                                    .schedule_date!),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Validate().displeDateFormate(
                                                Global.getItemValues(
                                                    followUpsList[index]
                                                        .responces,
                                                    'followup_visit_date')),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),

                                          /* Text(
                                        Global.getItemValues(
                                            followUpsList[index].responces,
                                            'height'),
                                        style: Styles.cardBlue10,
                                        overflow: TextOverflow.ellipsis,
                                      ),*/
                                          Text(
                                            Global.getItemValues(
                                                followUpsList[index].responces,
                                                'weight'),
                                            style: Styles.cardBlue10,
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
                                    ),
                                    (followUpsList[index].is_edited == 0 &&
                                            followUpsList[index].is_uploaded ==
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

  String calldateOfRefferl(String? responce) {
    String date = '';
    if (responce != null) {
      var itemDate = Global.getItemValues(responce, 'followup_visit_date');
      if (Global.validString(itemDate)) {
        date = Validate().displeDateFormate(itemDate);
      }
    }
    return date;
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
