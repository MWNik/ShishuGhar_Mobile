import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../database/helper/creche_comite_meeting/creche_committie_response_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/creche_committie_response_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'creche_committe_details_screen.dart';
import 'creche_committie_details_view_screen.dart';

class CrecheCommitteListingScreen extends StatefulWidget {
  String? creche_id;
  String crecheName;

  CrecheCommitteListingScreen(
      {super.key, required this.creche_id, required this.crecheName});

  @override
  State<CrecheCommitteListingScreen> createState() =>
      _CrecheCommitteListingScreenState();
}

class _CrecheCommitteListingScreenState
    extends State<CrecheCommitteListingScreen> {
  List<CrecheCommittieResponseModel> meetinglist = [];
  List<Translation> translats = [];
  List<String> existingDate = [];
  String lng = 'en';
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
      CustomText.DateS,
      CustomText.MajorTopic,
      CustomText.ccListing
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    await fetchCommittieMeetingrecords();
  }

  Future<void> fetchCommittieMeetingrecords() async {
    meetinglist = await CrecheCommittieResponnseHelper()
        .childEventByChild(widget.creche_id);
    existingDate.clear();
    meetinglist.forEach((element) {
      var date = Global.getItemValues(element.responces, 'meeting_date');
      if (Global.validString(date)) existingDate.add(date);
    });

    // await fetchCreationDate();

    var currentDateString = Validate().currentDate();
    List<int> parts = currentDateString.split('-').map(int.parse).toList();
    var backDate =
    DateTime(parts[0], parts[1], parts[2]).subtract(Duration(days: 7));
    if (minDate != null) {
      if (minDate!.isBefore(backDate)) {
        minDate = backDate;
      }
    } else if(minDate == null){
      minDate = backDate;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          String ccGuid = '';
          if (!Global.validString(ccGuid)) {
            ccGuid = Validate().randomGuid();
            var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    CrecheCommitteDetailsScreen(
                      creche_id: widget.creche_id,
                      ccGuid: ccGuid,
                      isImageUpdate: false,
                      minDate: minDate,
                        existingList:existingDate
                    )));
            if (refStatus == 'itemRefresh') {
              await fetchCommittieMeetingrecords();
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
        text: Global.returnTrLable(translats, CustomText.ccListing, lng),
        subTitle: widget.crecheName,
        onTap: () => Navigator.pop(context, 'itemRefresh'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
        child: Column(children: [
          Expanded(
            child: (meetinglist.length > 0)
                ? ListView.builder(
                itemCount: meetinglist.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      var created_at = DateTime.parse(
                          meetinglist[index].created_at.toString());
                      var date = DateTime(created_at.year, created_at.month,
                          created_at.day);
                      bool isUneditable = date
                          .add(Duration(days: 7))
                          .isBefore(
                          DateTime.parse(Validate().currentDate()));
                      if (existingDate.contains(Global.getItemValues(
                          meetinglist[index].responces, 'meeting_date'))) {
                        var currentRecordDate = Global.getItemValues(
                            meetinglist[index].responces, 'meeting_date');
                        existingDate.remove(currentRecordDate);
                      }

                      var ccGuid = meetinglist[index].ccguid;
                      if (Global.validString(ccGuid)) {
                        var refStatus = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                isUneditable ? CrecheCommitteDetailsViewScreen(
                                  creche_id: widget.creche_id,
                                  ccGuid: ccGuid,
                                ) : CrecheCommitteDetailsScreen(
                                    creche_id: widget.creche_id,
                                    ccGuid: ccGuid,
                                    minDate: minDate,
                                    existingList:existingDate,
                                    isImageUpdate: Global.validString(
                                        Global.getItemValues(
                                            meetinglist[index]
                                                .responces!,
                                            'image')))));

                        if (refStatus == 'itemRefresh') {
                          await fetchCommittieMeetingrecords();
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Container(
                        decoration: BoxDecoration(
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
                                      '${Global.returnTrLable(
                                          translats, CustomText.DateS, lng).trim()} : ',
                                      style: Styles.black104,
                                    ),
                                    Text(
                                      '${Global.returnTrLable(
                                          translats, CustomText.MajorTopic, lng)
                                          .trim()} : ',
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
                                                meetinglist[index]
                                                    .responces!,
                                                'meeting_date')),
                                        style: Styles.blue125,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        Global.getItemValues(
                                            meetinglist[index].responces!,
                                            'major_topic'),
                                        style: Styles.blue125,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                                (meetinglist[index].is_edited == 0 &&
                                    meetinglist[index].is_uploaded == 1)
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

  // Future<void> fetchCreationDate() async {
  //   var crecheRespo = await CrecheDataHelper()
  //       .getCrecheResponceItem(Global.stringToInt(widget.creche_id));
  //   if (crecheRespo[0].created_at != null) {
  //     setState(() {
  //       minDate = DateTime.parse(crecheRespo[0].created_at!);
  //     });
  //   }
  // }

}
