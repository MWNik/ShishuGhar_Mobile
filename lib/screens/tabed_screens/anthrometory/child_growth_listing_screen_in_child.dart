import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';

import '../../../custom_widget/custom_appbar_child.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
import '../../../database/helper/height_weight_boys_girls_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/tabHeight_for_age_Boys_model.dart';
import '../../../model/apimodel/tabHeight_for_age_Girls_model.dart';
import '../../../model/apimodel/tabWeight_for_age_Boys _model.dart';
import '../../../model/apimodel/tabWeight_for_age_Girls _model.dart';
import '../../../model/apimodel/tabWeight_to_Height_Boys_model.dart';
import '../../../model/apimodel/tabWeight_to_Height_Girls_model.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_growth_responce_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class ChildGrowthListingScreenInChild extends StatefulWidget {
  final String childEnrollment;
  final int creche_nameId;
  final String childName;
  final String childId;
  final String gender;

  const ChildGrowthListingScreenInChild({
    super.key,
    required this.creche_nameId,
    required this.childEnrollment,
    required this.childName,
    required this.childId,
    required this.gender,
  });

  @override
  State<ChildGrowthListingScreenInChild> createState() =>
      _ChildGrowthListingState();
}

class _ChildGrowthListingState extends State<ChildGrowthListingScreenInChild> {
  List<ChildGrowthMetaResponseModel> childHHData = [];
  List<HouseHoldFielItemdModel> formItem = [];
  List<Translation> translats = [];
  List<OptionsModel> mesureMentEqupmet = [];
  List<OptionsModel> inless = [];
  String lng = 'en';
  bool currentDateGrowth = false;
  DateTime? lastGrowthDate;
  DateTime? maxGrowthDate;
  List<OptionsModel> options = [];
  List<TabHeightforageBoysModel> tabHeightforageBoys = [];
  List<TabHeightforageGirlsModel> tHeightforageGirls = [];
  List<TabWeightforageBoysModel> tabWeightforageBoys = [];
  List<TabWeightforageGirlsModel> tabWeightforageGirls = [];
  List<TabWeightToHeightBoysModel> tabWeightToHeightBoys = [];
  List<TabWeightToHeightGirlsModel> tabWeightToHeightGirls = [];

  List<String> staticVisbleItem = [
    'awc',
    'vhsnd',
    'thr',
    'any_medical_major_illness',
    'measurement_reason',
    'measurement_taken_date',
  ];

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
      CustomText.anthropomertry,
      CustomText.childAgeInDaysbrac,
      CustomText.Yes,
      CustomText.No,
      CustomText.select_here,
      'Measurement Date',
      "Height",
      'Weight',
      'Measurement Equipment',
      'Measurement taken',
      'Z - Score',
      'Weight for age',
      'Weight for Height',
      'Height for Age',
      CustomText.Severe,
      CustomText.Moderate,
      CustomText.Normal
    ];
    tabHeightforageBoys =
        await HeightWeightBoysGirlsHelper().callHeightForAgeBoys();
    tHeightforageGirls =
        await HeightWeightBoysGirlsHelper().callHeightForAgeGirls();
    tabWeightforageBoys =
        await HeightWeightBoysGirlsHelper().callWeightforAgeBoys();
    tabWeightforageGirls =
        await HeightWeightBoysGirlsHelper().callWeightforAgeGirls();
    tabWeightToHeightBoys =
        await HeightWeightBoysGirlsHelper().callWeightToHeightBoys();
    tabWeightToHeightGirls =
        await HeightWeightBoysGirlsHelper().callWeightToHeightGirls();

    mesureMentEqupmet = await OptionsModelHelper()
        .getMstCommonOptions('Measurement Equipment', lng);
    inless = await OptionsModelHelper().getMstCommonOptions('Illness', lng);

    await ChildGrowthResponseHelper()
        .getChildHHFieldsForm('Child Growth Monitoring')
        .then((value) {
      formItem = value;
    });

    formItem = formItem
        .where((element) => staticVisbleItem.contains(element.fieldname!))
        .toList();
    List<String> defaultCommon = [];

    formItem.forEach((element) {
      if (Global.validString(element.label))
        valueItems.add(element.label!.trim());
    });
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    for (int i = 0; i < formItem.length; i++) {
      if (Global.validString(formItem[i].options)) {
        defaultCommon.add('tab${formItem[i].options!.trim()}');
      }
    }

    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng)
        .then((data) {
      options.addAll(data);
    });

    fetchEnrolleChild();
    setState(() {});
  }

  Future<void> fetchEnrolleChild() async {
    childHHData = await ChildGrowthResponseHelper()
        .anthormentryByCrecheINChild(widget.creche_nameId);

    childHHData = childHHData.where((element) {
      var item = jsonDecode(element.responces!)['anthropromatic_details']
          as List<dynamic>;
      var childItem = item
          .where((itItem) =>
              // itItem['childenrollguid']==widget.childEnrollment &&
              //     itItem['height']!=null && itItem['weight']!=null
              //     && Global.stringToDouble(itItem['weight'].toString())>0
              // && Global.stringToDouble(itItem['height'].toString())>0).toList();
              itItem['childenrollguid'] == widget.childEnrollment &&
              itItem['do_you_have_height_weight'] != null)
          .toList();

      if (childItem.length > 0) {
        return true;
      } else
        return false;
    }).toList();

    // await callDatesList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
        appBar: CustomChildAppbar(
          text: Global.returnTrLable(translats, CustomText.anthropomertry, lng),
          subTitle1: widget.childName,
          subTitle2: widget.childId,
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
                            onTap: () async {},
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
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${Global.returnTrLable(translats, 'Measurement Date', lng).trim()} : ',
                                                  style: Styles.black104,
                                                ),
                                                callGetChildDataFromAnthro(
                                                            childHHData[index]
                                                                .responces!,
                                                            'do_you_have_height_weight') ==
                                                        '1'
                                                    ? Text(
                                                        '${Global.returnTrLable(translats, "Height", lng).trim()} : ',
                                                        style: Styles.black104,
                                                        strutStyle: StrutStyle(
                                                            height: 1.2),
                                                      )
                                                    : SizedBox(),
                                                // callGetChildDataFromAnthro(
                                                //             childHHData[index]
                                                //                 .responces!,
                                                //             'do_you_have_height_weight') ==
                                                //         '1'
                                                //     ? Text(
                                                //         '${Global.returnTrLable(translats, "Height", lng).trim()} : ',
                                                //         style: Styles.black104,
                                                //         strutStyle:
                                                //             StrutStyle(height: 1),
                                                //       )
                                                //     : SizedBox(),
                                                callGetChildDataFromAnthro(
                                                            childHHData[index]
                                                                .responces!,
                                                            'do_you_have_height_weight') ==
                                                        '1'
                                                    ? Text(
                                                        '${Global.returnTrLable(translats, 'Weight', lng).trim()} : ',
                                                        style: Styles.black104,
                                                        strutStyle: StrutStyle(
                                                            height: 1.2),
                                                      )
                                                    : SizedBox(),
                                                Text(
                                                  '${Global.returnTrLable(translats, CustomText.childAgeInDaysbrac, lng).trim()} : ',
                                                  style: Styles.black104,
                                                  strutStyle:
                                                      StrutStyle(height: 1.2),
                                                ),
                                                callGetChildDataFromAnthro(
                                                            childHHData[index]
                                                                .responces!,
                                                            'do_you_have_height_weight') ==
                                                        '1'
                                                    ? Text(
                                                        '${Global.returnTrLable(translats, 'Measurement Equipment', lng).trim()} : ',
                                                        style: Styles.black104,
                                                        strutStyle: StrutStyle(
                                                            height: 1.2),
                                                      )
                                                    : Text(
                                                        '${Global.returnTrLable(translats, 'Measurement taken', lng).trim()} : ',
                                                        style: Styles.black104,
                                                        strutStyle: StrutStyle(
                                                            height: 1.2)),
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
                                                        Global.getItemValues(
                                                            childHHData[index]
                                                                .responces!,
                                                            'measurement_date')),
                                                    style: Styles.cardBlue10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  callGetChildDataFromAnthro(
                                                              childHHData[index]
                                                                  .responces!,
                                                              'do_you_have_height_weight') ==
                                                          '1'
                                                      ? Text(
                                                          callGetChildDataFromAnthro(
                                                              childHHData[index]
                                                                  .responces!,
                                                              'height')!,
                                                          style:
                                                              Styles.cardBlue10,
                                                          strutStyle: StrutStyle(
                                                              height: 1.2),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      : SizedBox(),
                                                  callGetChildDataFromAnthro(
                                                              childHHData[index]
                                                                  .responces!,
                                                              'do_you_have_height_weight') ==
                                                          '1'
                                                      ? Text(
                                                          callGetChildDataFromAnthro(
                                                              childHHData[index]
                                                                  .responces!,
                                                              'weight')!,
                                                          style:
                                                              Styles.cardBlue10,
                                                          strutStyle: StrutStyle(
                                                              height: 1.2),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      : SizedBox(),
                                                  Text(
                                                    callGetChildDataFromAnthro(
                                                        childHHData[index]
                                                            .responces!,
                                                        'age_months')!,
                                                    style: Styles.cardBlue10,
                                                    strutStyle:
                                                        StrutStyle(height: 1.2),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  callGetChildDataFromAnthro(
                                                              childHHData[index]
                                                                  .responces!,
                                                              'do_you_have_height_weight') ==
                                                          '1'
                                                      ? Text(
                                                          getMesumentEqupment(
                                                              childHHData[index]
                                                                  .responces!,
                                                              'measurement_equipment'),
                                                          style:
                                                              Styles.cardBlue10,
                                                          strutStyle: StrutStyle(
                                                              height: 1.2),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      : Text(
                                                          '${Global.returnTrLable(translats, CustomText.No, lng).trim()}',
                                                          style:
                                                              Styles.cardBlue10,
                                                          strutStyle: StrutStyle(
                                                              height: 1.2),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                ],
                                              ),
                                            ),
                                            (childHHData[index].is_edited == 0 &&
                                                    childHHData[index]
                                                            .is_uploaded ==
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
                                        SizedBox(height: 5),
                                        // DynamicMultiCheckGrowthGridView(
                                        //   titleText:'Illness',
                                        //   items: inless,
                                        //   readable:true,
                                        //   selectedItem: callGetChildDataFromAnthro(
                                        //       childHHData[index].responces!,
                                        //       'illness_id'),
                                        //   onChanged: (value) {
                                        //   },
                                        // ),
                                        callGetChildDataFromAnthro(
                                                    childHHData[index].responces!,
                                                    'do_you_have_height_weight') ==
                                                '1'
                                            ? Text(
                                                '${Global.returnTrLable(translats, 'Z - Score', lng).trim()}',
                                                style: Styles.black104,
                                              )
                                            : SizedBox(),
                                        callGetChildDataFromAnthro(
                                                    childHHData[index].responces!,
                                                    'do_you_have_height_weight') ==
                                                '1'
                                            ? SizedBox(height: 5)
                                            : SizedBox(),
                                        callGetChildDataFromAnthro(
                                                    childHHData[index].responces!,
                                                    'do_you_have_height_weight') ==
                                                '1'
                                            ? Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xffE0E0E0)),
                                                  borderRadius:
                                                      BorderRadius.circular(10.r),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: callColorId(
                                                                  childHHData[
                                                                          index]
                                                                      .responces!,
                                                                  'weight_for_age'),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.r),
                                                            ),
                                                          ),
                                                          Text(
                                                            Global.returnTrLable(
                                                                translats,
                                                                'Weight for age',
                                                                lng),
                                                            style: Styles.black85,
                                                            strutStyle:
                                                                StrutStyle(
                                                                    height: 1.2),
                                                          ),
                                                          Text(
                                                            callColorName(
                                                                childHHData[index]
                                                                    .responces!,
                                                                'weight_for_age'),
                                                            style: Styles.red85,
                                                          ),
                                                          Text(
                                                            callColorNameAvg(childResponce(childHHData[index].responces!), 'weight_for_age',
                                                                callGetChildDataFromAnthro(childHHData[index].responces!, 'measurement_taken_date')),
                                                            style: Styles.red85,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      children: [
                                                        Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: callColorId(
                                                                childHHData[index]
                                                                    .responces!,
                                                                'weight_for_height'),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r),
                                                          ),
                                                        ),
                                                        Text(
                                                          Global.returnTrLable(
                                                              translats,
                                                              'Weight for Height',
                                                              lng),
                                                          style: Styles.black85,
                                                          strutStyle: StrutStyle(
                                                              height: 1.2),
                                                        ),
                                                        Text(
                                                          callColorName(
                                                              childHHData[index]
                                                                  .responces!,
                                                              'weight_for_height'),
                                                          style: Styles.red85,
                                                        ),
                                                        Text(
                                                          callColorNameAvg(
                                                              childResponce(
                                                                  childHHData[
                                                                          index]
                                                                      .responces!),
                                                              'weight_for_height',callGetChildDataFromAnthro(childHHData[index].responces!, 'measurement_taken_date')),
                                                          style: Styles.red85,
                                                        ),
                                                      ],
                                                    )),
                                                    Expanded(
                                                        child: Column(
                                                      children: [
                                                        Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: callColorId(
                                                                childHHData[index]
                                                                    .responces!,
                                                                'height_for_age'),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r),
                                                          ),
                                                        ),
                                                        Text(
                                                          Global.returnTrLable(
                                                              translats,
                                                              'Height for Age',
                                                              lng),
                                                          style: Styles.black85,
                                                          strutStyle: StrutStyle(
                                                              height: 1.2),
                                                        ),
                                                        Text(
                                                          callColorName(
                                                              childHHData[index]
                                                                  .responces!,
                                                              'height_for_age'),
                                                          style: Styles.red85,
                                                        ),
                                                        Text(
                                                          callColorNameAvg(
                                                              childResponce(
                                                                  childHHData[
                                                                          index]
                                                                      .responces!),
                                                              'height_for_age',callGetChildDataFromAnthro(childHHData[index].responces!, 'measurement_taken_date')),
                                                          style: Styles.red85,
                                                        ),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        SizedBox(height: 10),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: visibleOtherItem(
                                                childHHData[index].responces!))
                                      ]),
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
      ),
    );
  }

  Future<void> callDatesList() async {
    List<String> dateStringData = [];
    childHHData.forEach((element) {
      var date = Global.getItemValues(element.responces!, 'measurement_date');
      if (Global.validString(date)) {
        dateStringData.add(date);
      }
    });
    var dateList = dateStringData.map((dateString) {
      List<int> dateParts = dateString.split('-').map(int.parse).toList();
      return DateTime(dateParts[0], dateParts[1], dateParts[2]);
    }).toList();
    if (dateList.length > 0) {
      lastGrowthDate = dateList
          .reduce((value, element) => value.isAfter(element) ? value : element);
      currentDateGrowth =
          lastGrowthDate == Validate().stringToDate(Validate().currentDate());
    }
    // lastGrowthDate = '${maxDate.year}-${maxDate.month}-${maxDate.day}';
  }

  Future<DateTime?> callDatesAlredDateList(String date) async {
    DateTime? lastGrowthDateNew;
    List<String> dateStringData = [];
    childHHData.forEach((element) {
      var date = Global.getItemValues(element.responces!, 'measurement_date');
      if (Global.validString(date)) {
        dateStringData.add(date);
      }
    });
    var dateList = dateStringData.map((dateString) {
      List<int> dateParts = dateString.split('-').map(int.parse).toList();
      return DateTime(dateParts[0], dateParts[1], dateParts[2]);
    }).toList();

    List<int> dateCuuten = date.split('-').map(int.parse).toList();

    var selecttedItemDate =
        DateTime(dateCuuten[0], dateCuuten[1], dateCuuten[2]);

    if (dateList.length > 0) {
      var maxDateList = dateList
          .where((element) => (selecttedItemDate.isAfter(element)))
          .toList();
      DateTime? greatestDate = maxDateList.isNotEmpty
          ? maxDateList.reduce(
              (value, element) => value.isAfter(element) ? value : element)
          : null;
      print('max $greatestDate');
      lastGrowthDateNew = greatestDate;
    }

    if (dateList.length > 0) {
      var minDateList = dateList
          .where((element) => (selecttedItemDate.isBefore(element)))
          .toList();
      DateTime? lowesttDate = minDateList.isNotEmpty
          ? minDateList.reduce(
              (value, element) => value.isBefore(element) ? value : element)
          : null;
      maxGrowthDate = lowesttDate;
      print('min $lowesttDate');
    } else
      maxGrowthDate = null;

    return lastGrowthDateNew;
  }

  String? callGetChildDataFromAnthro(responce, String key) {
    String value = '';
    var item = jsonDecode(responce)['anthropromatic_details'] as List<dynamic>;
    if (item.isNotEmpty) {
      for (int i = 0; i < item.length; i++) {
        if (item[i]['childenrollguid'] == widget.childEnrollment) {
          value = Global.validToString(item[i][key].toString());
          break;
        }
      }
    }
    return value;
  }

  Map<String, dynamic> childResponce(String responce) {
    Map<String, dynamic> value = {};
    var item = jsonDecode(responce)['anthropromatic_details'] as List<dynamic>;
    if (item.isNotEmpty) {
      for (int i = 0; i < item.length; i++) {
        if (item[i]['childenrollguid'] == widget.childEnrollment) {
          value = item[i];
          break;
        }
      }
    }
    return value;
  }

  Color callColorId(responce, String key) {
    var colorD =
        Global.stringToDouble(callGetChildDataFromAnthro(responce, key));
    Color color = Color(0xffAAAAAA);
    if (colorD == 0) {
      color = Color(0xffAAAAAA);
    } else if (colorD == 1) {
      color = Color(0xffF35858);
    } else if (colorD == 2) {
      color = Color(0xffF4B81D);
    } else if (colorD == 3) {
      color = Color(0xff8BF649);
    }
    return color;
  }

  String callColorName(responce, String key) {
    var colorD =
        Global.stringToDouble(callGetChildDataFromAnthro(responce, key));
    String colorName = '';
    if (colorD == 0) {
      colorName = '';
    } else if (colorD == 1) {
      colorName =
          '(${Global.returnTrLable(translats, CustomText.Severe, lng)})';
    } else if (colorD == 2) {
      colorName =
          '(${Global.returnTrLable(translats, CustomText.Moderate, lng)})';
    } else if (colorD == 3) {
      colorName =
          '(${Global.returnTrLable(translats, CustomText.Normal, lng)})';
    }
    return colorName;
  }

  String callColorNameAvg(Map<String, dynamic> responce, String key, String? measurementDate) {
    String grothValue = DependingLogic.AutoColorCreateByHeightWightStringNew(
        tabHeightforageBoys,
        tHeightforageGirls,
        tabWeightforageBoys,
        tabWeightforageGirls,
        tabWeightToHeightBoys,
        tabWeightToHeightGirls,
        key,
        widget.gender,measurementDate,
        responce);
    if (Global.validString(grothValue)) {
      grothValue = '(${grothValue})';
    }
    return grothValue;
  }

  String getMesumentEqupment(responce, String key) {
    String eqp = '';
    var eqpId = callGetChildDataFromAnthro(responce, key);
    var items = mesureMentEqupmet
        .where((element) => element.name.toString() == eqpId)
        .toList();
    if (items.length > 0) {
      eqp = items[0].values!;
    }
    return eqp;
  }

  List<Widget> visibleOtherItem(String responce) {
    List<Widget> screenItems = [];
    formItem.forEach((element) {
      screenItems.add(widgetTypeWidget(element, responce));
    });

    return screenItems;
  }

  widgetTypeWidget(HouseHoldFielItemdModel quesItem, String responce) {
    switch (quesItem.fieldtype) {
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialValue: Global.stringToIntNull(
              callGetChildDataFromAnthro(responce, quesItem.fieldname!)),
          labelControlls: translats,
          isVisible: Global.validString(
              callGetChildDataFromAnthro(responce, quesItem.fieldname!)),
          lng: lng,
          readable: true,
          onChanged: (value) {},
        );
      case 'Date':
        return CustomDatepickerDynamic(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialvalue: Global.validString(
                  callGetChildDataFromAnthro(responce, quesItem.fieldname!))
              ? callGetChildDataFromAnthro(responce, quesItem.fieldname!)
              : null,
          calenderValidate: [],
          isVisible: Global.validString(
              callGetChildDataFromAnthro(responce, quesItem.fieldname!)),
          readable: true,
          onChanged: (value) {},
        );

      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          hintText: Global.returnTrLable(translats, CustomText.select_here, lng),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          items: items,
          selectedItem:
              callGetChildDataFromAnthro(responce, quesItem.fieldname!),
          isVisible: Global.validString(
              callGetChildDataFromAnthro(responce, quesItem.fieldname!)),
          readable: true,
          onChanged: (value) {},
        );
      default:
        return SizedBox();
    }
  }
}
