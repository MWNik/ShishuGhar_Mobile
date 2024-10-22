import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/cmc_CC/creche_monitering_checklist_CC_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/creche_monitering_checklist_CC_response_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'creche_monitering_checklist_CC_tab_screen.dart';

class cmcCCListingScreen extends StatefulWidget {
  final String? creche_id;
  final String crecheName;

  cmcCCListingScreen(
      {super.key, required this.creche_id, required this.crecheName});

  @override
  State<cmcCCListingScreen> createState() => _cmcCCListingScreenState();
}

class _cmcCCListingScreenState extends State<cmcCCListingScreen> {
  List<CmcCCResponseModel> cmcCCData = [];
  List<CmcCCResponseModel> filterCCdata = [];
  List<CmcCCResponseModel> usynchedList = [];
  List<CmcCCResponseModel> allList = [];
  List<Translation> translats = [];
  String lng = 'en';
  bool isOnlyUnsyched = false;

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
      CustomText.EntryTime,
      CustomText.ExitTime,
      CustomText.Creche,
      CustomText.datevisit,
      CustomText.VisitNotes,
      CustomText.all,
      CustomText.usynchedAndDraft
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchCmcCCRecords();

    setState(() {});
  }

  Future<void> fetchCmcCCRecords() async {
    cmcCCData = await CmcCCTabResponseHelper()
        .childALMChild(Global.stringToInt(widget.creche_id));
    usynchedList =
        cmcCCData.where((element) => element.is_edited == 1 || element.is_edited == 2).toList();
    allList = cmcCCData;
    filterCCdata = isOnlyUnsyched ? usynchedList : allList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          String ccGuid = '';
          if (!(Global.validString(ccGuid))) {
            ccGuid = Validate().randomGuid();
            var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CmcCCTabSCreen(
                      cmc_cc_guid: ccGuid,
                      crecheName: widget.crecheName,
                      creche_id: Global.stringToInt(widget.creche_id),
                      isEdit: false,
                      isViewScreen: false,
                    )));

            if (refStatus == 'itemRefresh') {
              await fetchCmcCCRecords();
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
        text: Global.returnTrLable(translats, CustomText.VisitNotes, lng),
        subTitle: widget.crecheName,
        onTap: () => Navigator.pop(context, 'itemRefresh'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w,right: 20.w, bottom:10.h),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedRollingSwitch(
                title1: Global.returnTrLable(translats, CustomText.all, lng),
                title2: Global.returnTrLable(translats, CustomText.usynchedAndDraft, lng),
                isOnlyUnsynched: isOnlyUnsyched,
                onChange: (value) async {
                  setState(() {
                    isOnlyUnsyched = value;
                  });
                  await fetchCmcCCRecords();
                },
              )
            ],
          ),
          Expanded(
            child: (filterCCdata.length > 0)
                ? ListView.builder(
                    itemCount: filterCCdata.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var ccGuid = filterCCdata[index].cmc_cc_guid;
                          if (Global.validString(ccGuid)) {
                            var created_at = DateTime.parse(
                                filterCCdata[index].created_at.toString());
                            var date = DateTime(created_at.year,
                                created_at.month, created_at.day);
                            bool isViewScreen = date
                                .add(Duration(days: 7))
                                .isBefore(
                                    DateTime.parse(Validate().currentDate()));
                            var refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CmcCCTabSCreen(
                                            cmc_cc_guid: ccGuid!,
                                            crecheName: widget.crecheName,
                                            creche_id: Global.stringToInt(
                                                widget.creche_id),
                                            isEdit: false,
                                            isViewScreen: isViewScreen,
                                            date_of_visit: Global.getItemValues(
                                                filterCCdata[index].responces!,
                                                'date_of_visit'))));

                            if (refStatus == 'itemRefresh') {
                              await fetchCmcCCRecords();
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
                                        // Text(
                                        //   '${Global.returnTrLable(translats, CustomText.Creche, lng).trim()} : ',
                                        //   style: Styles.black104,
                                        // ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.datevisit, lng).trim()} : ',
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
                                          // Text(
                                          //   widget.creche_id!,
                                          //   style: Styles.blue125,
                                          //   overflow: TextOverflow.ellipsis,
                                          // ),
                                          Text(
                                            Global.getItemValues(
                                                filterCCdata[index].responces!,
                                                'date_of_visit'),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    (filterCCdata[index].is_edited == 0 &&
                                          filterCCdata[index].is_uploaded == 1)
                                      ? Image.asset(
                                          "assets/sync.png",
                                          scale: 1.5,
                                        )
                                      : (filterCCdata[index].is_edited == 1 &&
                                              filterCCdata[index].is_uploaded == 0)
                                          ? Image.asset(
                                              "assets/sync_gray.png",
                                              scale: 1.5,
                                            )
                                          : Icon(
                                              Icons.error_outline_outlined,
                                              color: Colors.red.shade700,
                                              shadows: [
                                                BoxShadow(
                                                    spreadRadius: 2,
                                                    blurRadius: 4,
                                                    color: Colors.red.shade200)
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
          ),
        ]),
      ),
    );
  }
}
