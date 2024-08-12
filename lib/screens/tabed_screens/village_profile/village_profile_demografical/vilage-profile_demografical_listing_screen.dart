import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/village_profile/village_profile_response_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/model/dynamic_screen_model/village_profile_response_model.dart';
import 'package:shishughar/screens/tabed_screens/village_profile/village_profile_demografical/village_profile_demografical_screen.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../../database/helper/translation_language_helper.dart';
import '../../../../model/apimodel/translation_language_api_model.dart';
import '../../../../style/styles.dart';

class DemograficalListingScreen extends StatefulWidget {
  final int vName;

  const DemograficalListingScreen({super.key, required this.vName});

  @override
  State<DemograficalListingScreen> createState() =>
      _DemograficalListingScreenState();
}

class _DemograficalListingScreenState extends State<DemograficalListingScreen> {
  // List<ChildEventTabResponceModel> childEventData = [];
  List<VillageProfileResponseModel> villageRecord = [];
  List<Map<String, dynamic>> demoListMap = [];
  List<OptionsModel> yearOptions = [];
  List<OptionsModel> detailOption = [];
  List<Translation> translats = [];
  String lng = 'en';
  DateTime? lastDate;

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
      CustomText.year,
      CustomText.population,
      CustomText.quarter
      
    ];
    yearOptions = await OptionsModelHelper().getMstCommonOptions(CustomText.year,lng);
    detailOption =
        await OptionsModelHelper().getMstCommonOptions('Demographic data',lng);
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchDemoList();
  }

  Future<void> fetchDemoList() async {
    villageRecord = await VillageProfileResponseHelper()
        .getVillageProfilebyName(widget.vName);
    if (villageRecord.isNotEmpty) {
      Map<String, dynamic> responseMap =
          jsonDecode(villageRecord[0].responces!);
      demoListMap =
          List<Map<String, dynamic>>.from(responseMap['demographical']);
    }
    print(demoListMap);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          String dGuid = '';
          if (!Global.validString(dGuid)) {
            Map<String, dynamic> emptyMap = {};
            dGuid = Validate().randomGuid();
            var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => DemograficalDetailsScreen(
                      vName: widget.vName,
                      dGuid: dGuid,
                      demoRec: emptyMap,
                    )));
            if (refStatus == CustomText.itemRefresh) {
              await fetchDemoList();
            }
          }
        },
        child: Image.asset(
          "assets/add_btn.png",
          scale: 2.7,
          color: Color(0xff5979AA),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          Expanded(
            child: (demoListMap.length > 0)
                ? ListView.builder(
                    itemCount: demoListMap.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          // var lstDate=await callDatesAlredDateList(Global.getItemValues(childEventData[index].responces!, 'date'));
                          var refStatus = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      // EnrolledChildDetailsSccreen(
                                      //   childEventGuid: childEventData[index]
                                      //       .child_event_guid,
                                      //   enName: widget.enName!,
                                      //   chilenrolledGUID: childEventData[index].childenrolledguid,
                                      //   creche_id: widget.creche_id,
                                      //     lastDate:lastDate,
                                      //     // maxDate:maxDate,
                                      //   childId: widget.childId,
                                      //   childName: widget.childName,
                                      // )
                                      DemograficalDetailsScreen(
                                        vName: widget.vName,
                                        dGuid: demoListMap[index]['demo_guid'],
                                        demoRec: demoListMap[index],
                                      )));
                          if (refStatus == CustomText.itemRefresh) {
                            await fetchDemoList();
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
                                        '${Global.returnTrLable(translats, CustomText.year, lng).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, '${CustomText.population}(${CustomText.quarter} 1)', lng).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, '${CustomText.population}(${CustomText.quarter} 2)', lng).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, '${CustomText.population}(${CustomText.quarter} 3)', lng).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, '${CustomText.population}(${CustomText.quarter} 4)', lng).trim()} : ',
                                        style: Styles.black104,
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
                                          callOptionValue(
                                              demoListMap[index]['year_id'],
                                              yearOptions),
                                          maxLines: 1,
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.validToString(demoListMap[index]
                                          ['population_q1']
                                              .toString()),
                                          maxLines: 1,
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.validToString(demoListMap[index]
                                          ['population_q2']
                                              .toString()),
                                          maxLines: 1,
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.validToString(demoListMap[index]
                                          ['population_q3']
                                              .toString()),
                                          maxLines: 1,
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.validToString(demoListMap[index]
                                          ['population_q4']
                                              .toString()),
                                          maxLines: 1,
                                          style: Styles.blue125,
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

  String callOptionValue(String? id, List<OptionsModel> optionsList) {
    String returnValue = "";

    if (Global.validString(id)) {
      var items = optionsList.where((element) => element.name == id).toList();
      if (items.length > 0) {
        returnValue = items[0].values!;
      }
    }

    return returnValue;
  }
}
