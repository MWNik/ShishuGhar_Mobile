import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_children_responce_model.dart';
import 'package:shishughar/screens/tabed_screens/child_exit/child_exit_details_screen.dart';
import 'package:shishughar/screens/tabed_screens/child_exit/exit_enrolld_child/exit_enrolled_child_tab.dart';
import 'package:shishughar/screens/tabed_screens/child_exit/exit_enrolld_child/exit_enrolled_details_screen.dart';

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
  List<Map<String, dynamic>> filterExitData = [];
  List<Map<String, dynamic>> unsynchedList = [];
  List<Map<String, dynamic>> allList = [];
  bool isOnlyUnsynched = false;
  TextEditingController Searchcontroller = TextEditingController();
  List<Translation> translats = [];
  String lng = 'en';
  List<OptionsModel> reasonOfExit = [];
  bool currentDate = false;
  DateTime? lastDate;
  DateTime? maxDate;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OptionsModel> genderList = [];
  int? maxAgeLimit;
  int? minAgeLimit;
  String? selectedItemDrop;
  String? selectedReason;
  String? role;

  Future<void> initializeData() async {
    role = (await Validate().readString(Validate.role))!;
    translats.clear();
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    genderList = await OptionsModelHelper().getMstCommonOptions('Gender', lng);

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
      CustomText.ReasForExit,
      CustomText.childPresent,
      CustomText.childCount,
      CustomText.all,
      CustomText.unsynched,
      CustomText.minAgeInMonthEn,
      CustomText.maxAgeInMonthEn,
      CustomText.Gender,
      CustomText.clear,
      CustomText.Filter
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    reasonOfExit = await OptionsModelHelper()
        .getMstCommonOptions('Reason for child exit', lng);

    await fetchChildevents();
  }

  Future<void> fetchChildevents() async {
    childExitData = await ChildExitResponceHelper()
        .childExtedlistingByCrechenew(Global.stringToInt(widget.creche_id));
    unsynchedList =
        childExitData.where((element) => element['is_edited'] == 1).toList();
    allList = childExitData;
    filterExitData = isOnlyUnsynched ? unsynchedList : allList;
    Searchcontroller.text = '';
    await fetchChildDetail();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  filterDataQu(String entry) {
    var filterList = isOnlyUnsynched ? unsynchedList : allList;
    if (entry.length > 0) {
      filterExitData = filterList
          .where((element) =>
              (Global.getItemValues(
                      element['responces'], 'name_of_primary_caregiver'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()) ||
              (Global.getItemValues(element['responces'], 'child_name'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()))
          .toList();
    } else
      filterExitData = filterList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SafeArea(
          child: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/filter_icon.png',
                      scale: 2.4,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      Global.returnTrLable(translats, CustomText.Filter, lng),
                      style: Styles.labelcontrollerfont,
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        _scaffoldKey.currentState!.closeEndDrawer();
                      },
                      child: Image.asset(
                        'assets/cross.png',
                        color: Colors.grey,
                        scale: 4,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: DynamicCustomTextFieldInt(
                      initialvalue: minAgeLimit,
                      hintText: Global.returnTrLable(
                          translats, CustomText.minAgeInMonthEn, lng),
                      onChanged: (value) {
                        minAgeLimit = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: DynamicCustomTextFieldInt(
                      initialvalue: maxAgeLimit,
                      hintText: Global.returnTrLable(
                          translats, CustomText.maxAgeInMonthEn, lng),
                      onChanged: (value) {
                        maxAgeLimit = value;
                      },
                    ),
                  )
                ],
              ),
              DynamicCustomDropdownField(
                hintText:
                    Global.returnTrLable(translats, CustomText.Gender, lng),
                items: genderList,
                selectedItem: selectedItemDrop,
                onChanged: (value) {
                  selectedItemDrop = value?.name;
                },
              ),
              DynamicCustomDropdownField(
                hintText: Global.returnTrLable(
                    translats, CustomText.ReasForExit, lng),
                items: reasonOfExit,
                selectedItem: selectedReason,
                onChanged: (value) {
                  selectedReason = value?.name;
                },
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: CElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        cleaAllFilter();
                      },
                      text: Global.returnTrLable(
                          translats, CustomText.clear, lng),
                      color: Color(0xffF26BA3),
                    )),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: CElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          filteredGetData(context);
                        },
                        text: Global.returnTrLable(
                            translats, CustomText.Search, lng),
                      ),
                    )
                  ],
                ),
              ),
              role == CustomText.crecheSupervisor
                  ? Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: AnimatedRollingSwitch(
                        title1: Global.returnTrLable(
                            translats, CustomText.all, lng),
                        title2: Global.returnTrLable(
                            translats, CustomText.unsynched, lng),
                        isOnlyUnsynched: isOnlyUnsynched,
                        onChange: (value) async {
                          setState(() {
                            isOnlyUnsynched = value;
                          });
                          await fetchChildevents();
                        },
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: CustomTextFieldRow(
                controller: Searchcontroller,
                onChanged: (value) {
                  print(value);
                  filterDataQu(value);
                },
                hintText:
                    Global.returnTrLable(translats, CustomText.Search, lng),
                prefixIcon: Image.asset(
                  "assets/search.png",
                  scale: 2.4,
                ),
              )),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                child: Image.asset(
                  'assets/filter_icon.png',
                  scale: 2.4,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${Global.returnTrLable(translats, CustomText.childCount, lng)}: ${filterExitData.length}',
                  style: Styles.black12700,
                )
              ],
            ),
          ),
          Expanded(
            child: (filterExitData.length > 0)
                ? ListView.builder(
                    itemCount: filterExitData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      var selectedItem = filterExitData[index];
                      return GestureDetector(
                        onTap: () async {
                          /*  var detailMap = await fetchChildtDetailbyGuid(
                              childExitData[index]['ChildEnrollGUID']!);*/
                          //  var childId = detailMap.keys.first;
                          var date_of_enrollment = Global.getItemValues(
                              selectedItem['responces'], 'date_of_enrollment');

                          var created_at = DateTime.parse(
                              selectedItem['created_at'].toString());
                          var date = DateTime(created_at.year, created_at.month,
                              created_at.day);
                          var childName = Global.getItemValues(
                              selectedItem['responces'], 'child_name');
                          bool isEditable = date
                              .add(Duration(days: 16))
                              .isAfter(
                                  DateTime.parse(Validate().currentDate()));
                          var applicableDate =
                              Validate().stringToDate(Validate.date);
                          var now = DateTime.parse(Validate().currentDate());

                          // var childName = detailMap.values.first;
                          var refStatus = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ExitEnrolledChilrenTab(
                                          isForExitList: false,
                                          // isForExit: true,
                                          CHHGUID: selectedItem['CHHGUID'],
                                          isForCrecheEnrollment: false,
                                          EnrolledChilGUID:
                                              selectedItem['ChildEnrollGUID'],
                                          HHname: selectedItem['HHname'],
                                          crecheId: Global.stringToInt(
                                              widget.creche_id),
                                          HHGUID: Global.getItemValues(
                                              selectedItem['responces'],
                                              'hhguid'),
                                          isNew: 0,
                                          childName: childName,
                                          isImageUpdate: false,
                                          isEditable: role ==
                                                  CustomText.crecheSupervisor
                                                      .trim()
                                              ? now.isBefore(applicableDate)
                                                  ? true
                                                  : isEditable
                                              : false,
                                          minDate: date_of_enrollment)));
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
                                        strutStyle: StrutStyle(height: 1.2),
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.DateOfExit, lng).trim()} : ',
                                        strutStyle: StrutStyle(height: 1.2),
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.AgeOnDayOfExit, lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1.2),
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.ReasForExit, lng).trim()} : ',
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
                                              selectedItem['responces'],
                                              'child_name'),
                                          style: Styles.cardBlue10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.getItemValues(
                                              selectedItem['responces'],
                                              'child_id'),
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: 1.2),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Validate().displeDateFormate(
                                              Global.getItemValues(
                                                  selectedItem['responces'],
                                                  'date_of_exit')),
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: 1.2),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.getItemValues(
                                              selectedItem['responces'],
                                              'age_of_exit'),
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: 1.2),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          getReasonOfExit(Global.getItemValues(
                                              selectedItem['responces'],
                                              'reason_for_exit')),
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: 1.2),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  (selectedItem['is_edited'] == 0 &&
                                          selectedItem['is_uploaded'] == 1)
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

  filteredGetData(BuildContext mContext) async {
    var filterList = isOnlyUnsynched ? unsynchedList : allList;
    var filteredWithReason = filterList.where((element) {
      var reason =
          Global.getItemValues(element['responces'], 'reason_for_exit');
      return reason == (selectedReason ?? '');
    }).toList();
    filterList =
        Global.validString(selectedReason) ? filteredWithReason : filterList;
    if (selectedItemDrop != null &&
        maxAgeLimit != null &&
        minAgeLimit != null) {
      filterExitData = filterList.where((element) {
        var ViItem = Global.getItemValues(element['responces'], 'gender_id');
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ViItem == selectedItemDrop &&
            ageItem <= maxAgeLimit! &&
            ageItem >= minAgeLimit!;
      }).toList();
    } else if (selectedItemDrop != null &&
        maxAgeLimit == null &&
        minAgeLimit == null) {
      filterExitData = filterList.where((element) {
        var ViItem = Global.getItemValues(element['responces'], 'gender_id');
        return ViItem == selectedItemDrop;
      }).toList();
    } else if (selectedItemDrop == null &&
        maxAgeLimit != null &&
        minAgeLimit != null) {
      filterExitData = filterList.where((element) {
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem <= maxAgeLimit! && ageItem >= minAgeLimit!;
      }).toList();
    } else if (selectedItemDrop == null &&
        minAgeLimit != null &&
        maxAgeLimit == null) {
      filterExitData = filterList.where((element) {
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem >= minAgeLimit!;
      }).toList();
    } else if (selectedItemDrop == null &&
        maxAgeLimit != null &&
        minAgeLimit == null) {
      filterExitData = filterList.where((element) {
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem <= maxAgeLimit!;
      }).toList();
    } else {
      filterExitData = filterList;
    }
    setState(() {});
  }

  void cleaAllFilter() {
    filterExitData = isOnlyUnsynched ? unsynchedList : allList;
    selectedItemDrop = null;
    selectedReason = null;
    Searchcontroller.text = '';
    maxAgeLimit = null;
    minAgeLimit = null;
    setState(() {});
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
