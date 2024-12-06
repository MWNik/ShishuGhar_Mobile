import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/follow_up/child_followUp_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_followUp_response_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'child_followUp_tab_screen.dart';

class SchudleFollowUpsForChildListingScreen extends StatefulWidget {
  final String tabTitle;
  final String childenrollguid;
  final int creche_id;
  int? childNameId;
  final String childId;
  final String childName;

  SchudleFollowUpsForChildListingScreen({
    super.key,
    required this.tabTitle,
    required this.childenrollguid,
    required this.creche_id,
    this.childNameId,
    required this.childId,
    required this.childName,
  });

  @override
  State<SchudleFollowUpsForChildListingScreen> createState() =>
      _ChildFollowUpsListingScreenState();
}

class _ChildFollowUpsListingScreenState
    extends State<SchudleFollowUpsForChildListingScreen> {
  List<ChildFollowUpTabResponceModel> followUpsList = [];
  List<Translation> translats = [];
  String lng = 'en';
  DateTime applicableDate = Validate().stringToDate("2024-12-31");
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
      CustomText.height,
      CustomText.weight,
      CustomText.schduleDate
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    await callFolloupData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
        child: Column(children: [
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
                          if (Global.validString(child_followup_guid)) {
                            var followUpDate = followUpsList[index]
                                .followup_visit_date!
                                .split('-')
                                .map(int.parse)
                                .toList();
                            var date = DateTime(followUpDate[0],
                                followUpDate[1], followUpDate[2]);
                            // if (date.subtract(Duration(days: 1)).isBefore(
                            //     DateTime.parse(Validate().currentDate()))) {
                            if (date.subtract(Duration(days: 7)).isBefore(
                                    DateTime.parse(Validate().currentDate())) &&
                                date.isAfter(
                                    DateTime.parse(Validate().currentDate())
                                        .subtract(Duration(days: 8)))) {
                              var backDate = now.isBefore(applicableDate)
                                  ? DateTime(1992)
                                  : DateTime.parse(Validate().currentDate())
                                      .subtract(Duration(days: 7));
                              var backDateSD = date.subtract(Duration(days: 7));
                              var refStatus = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder:
                                          (BuildContext context) =>
                                              ChildFollowUpTabScreen(
                                                  tabTitle: widget.tabTitle,
                                                  child_referral_guid:
                                                      followUpsList[index]
                                                          .child_referral_guid!,
                                                  discharge_date: "",
                                                  followup_visit_date:
                                                      followUpsList[
                                                              index]
                                                          .followup_visit_date!,
                                                  schedule_date: followUpsList[
                                                          index]
                                                      .followup_visit_date!,
                                                  enrollChildGuid:
                                                      widget.childenrollguid,
                                                  creche_id: widget.creche_id,
                                                  child_id: widget.childNameId,
                                                  child_followup_guid:
                                                      child_followup_guid!,
                                                  childId: widget.childId,
                                                  childName: widget.childName,
                                                  minDate: backDate
                                                          .isBefore(backDateSD)
                                                      ? backDateSD
                                                      : backDate,
                                                  isEditable: true)));
                              if (refStatus == 'itemRefresh') {
                                await callFolloupData();
                              }
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
                                        /*Text(
                                          '${Global.returnTrLable(translats, CustomText.height, lng).trim()} : ',
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.weight, lng).trim()} : ',
                                          style: Styles.black104,
                                        ),*/
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
                                                    .followup_visit_date!),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          /*Text(
                                            Global.getItemValues(
                                                followUpsList[index].responces,
                                                'height'),
                                            style: Styles.blue125,
                                            overflow: TextOverflow.ellipsis,
                                          ),*/
                                          /*Text(
                                            Global.getItemValues(
                                                followUpsList[index].responces,
                                                'weight'),
                                            style: Styles.blue125,
                                            overflow: TextOverflow.ellipsis,
                                          ),*/
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

  Future callFolloupData() async {
    followUpsList = await ChildFollowUpTabResponseHelper()
        .callSchudledReffralForChild(widget.childenrollguid);
    setState(() {});
  }
}
