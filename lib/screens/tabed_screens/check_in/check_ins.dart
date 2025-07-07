import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';

import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import '../../../database/helper/check_in/check_in_response_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/dynamic_screen_model/checkIn_response_model.dart';
import '../../../utils/globle_method.dart';
import 'check_in_details_screen.dart';

class CheckIns extends StatefulWidget {
  final int crechId;
  const CheckIns({super.key, required this.crechId});

  @override
  _CheckInsScreenState createState() => _CheckInsScreenState();
}

class _CheckInsScreenState extends State<CheckIns> {
  List<CheckInResponseModel> items = [];
  List<CresheDatabaseResponceModel> crecheData = [];
  List<Translation> translatsLabel = [];
  String? lng;
  String? crecheName;
  bool currentDateAttendece = false;
  DateTime? maxDate;
  DateTime? minDate;
  String? role;
  List<CheckInResponseModel> unsynchedList = [];
  List<CheckInResponseModel> allList = [];
  bool isOnlyUnsynched = false;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));

    if (_isLoading)
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    else {
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, 'itemRefresh');
            return false;
          },
          child: Scaffold(
              appBar: CustomAppbar(
                text: lng != null
                    ? '${Global.returnTrLable(translatsLabel, CustomText.checkInAs, lng!)} $crecheName'
                    : CustomText.checkIN,
                onTap: () {
                  Navigator.pop(context, 'itemRefresh');
                },
              ),
              floatingActionButton: (currentDateAttendece
                  ? SizedBox()
                  : (role == CustomText.crecheSupervisor ||
                          role == CustomText.clusterCoordinator ||
                          role == CustomText.alm ||
                          role == CustomText.cbm)
                      ? InkWell(
                          onTap: () async {
                            String hhGuid = '';
                            if (!Global.validString(hhGuid)) {
                              hhGuid = Validate().randomGuid();
                              var refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CheckInDetailsScreen(
                                    ccinguid: hhGuid,
                                    isEdit: false,
                                    lastGrowthDate: maxDate,
                                    creche_id: widget.crechId,
                                  ),
                                ),
                              );
                              if (refStatus == 'itemRefresh') {
                                initData();
                              }
                            }
                          },
                          child: Image.asset(
                            "assets/add_btn.png",
                            scale: 2.7,
                            color: Color(0xff5979AA),
                          ),
                        )
                      : null),
              body: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
                child: Column(
                  children: [
                    (role == CustomText.crecheSupervisor ||
                            role == CustomText.clusterCoordinator ||
                            role == CustomText.alm ||
                            role == CustomText.cbm)
                        ? Align(
                            alignment: Alignment.topRight,
                            child: AnimatedRollingSwitch(
                              title1: Global.returnTrLable(
                                  translatsLabel, CustomText.all, lng!),
                              title2: Global.returnTrLable(
                                  translatsLabel, CustomText.unsynched, lng!),
                              isOnlyUnsynched: isOnlyUnsynched ?? false,
                              onChange: (value) async {
                                setState(() {
                                  isOnlyUnsynched = value;
                                });
                                await initData();
                              },
                            ),
                          )
                        : SizedBox(),
                    Expanded(
                      child: (items.isNotEmpty)
                          ? ListView.builder(
                              itemCount: items.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    var lstDate = await callDatesAlredDateList(
                                        Global.getItemValues(
                                            items[index].responces,
                                            'date_of_checkin'));
                                    var refStatus =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CheckInDetailsScreen(
                                                ccinguid: items[index].ccinguid!,
                                                lastGrowthDate: lstDate,
                                                minGrowthDate: minDate,
                                                creche_id: widget.crechId,
                                                // isEdit: role ==
                                                //         CustomText
                                                //             .crecheSupervisor
                                                //             .trim()
                                                //     ? true
                                                //     : false
                                                isEdit: true
                                                    ),
                                      ),
                                    );
                                    if (refStatus == 'itemRefresh') {
                                      initData();
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
                                          border: Border.all(
                                              color: Color(0xffE7F0FF)),
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 8.h),
                                        child: Row(
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
                                                  '${Global.returnTrLable(translatsLabel, CustomText.dateCheckin, lng!)} :',
                                                  style: Styles.black104,
                                                ),
                                                Text(
                                                  '${Global.returnTrLable(translatsLabel, CustomText.Location, lng!)} :',
                                                  style: Styles.black104,
                                                  strutStyle:
                                                      StrutStyle(height: 1.2),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
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
                                                      Global.validString(Global
                                                              .getItemValues(
                                                                  items[index]
                                                                      .responces,
                                                                  'date_of_checkin'))
                                                          ? Validate().displeDateFormate(
                                                              Global.getItemValues(
                                                                  items[index]
                                                                      .responces,
                                                                  'date_of_checkin'))
                                                          : '',
                                                      style: Styles.cardBlue10,
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                  Text(
                                                      Global.getItemValues(
                                                          items[index].responces,
                                                          'checkin_location'),
                                                      style: Styles.cardBlue10,
                                                      strutStyle:
                                                          StrutStyle(height: 1.2),
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            (items[index].is_edited == 0 &&
                                                    items[index].is_uploaded == 1)
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
                              child: Text((lng != null)
                                  ? Global.returnTrLable(translatsLabel,
                                      CustomText.NorecordAvailable, lng!)
                                  : '')),
                    )
                  ],
                ),
              )),
        ),
      );
    }
  }

  initData() async {
    role = (await Validate().readString(Validate.role))!;
    lng = await Validate().readString(Validate.sLanguage);
    var crechItemData =
        await CrecheDataHelper().getCrecheResponceItem(widget.crechId);
    if (crechItemData.length > 0) {
      crecheName =
          Global.getItemValues(crechItemData[0].responces!, 'creche_name');
    }
    List<String> valueItems = [
      CustomText.datevisit,
      CustomText.Location,
      CustomText.Creches,
      CustomText.checkInAs,
      CustomText.dateCheckin,
      CustomText.all,
      CustomText.unsynched,
      CustomText.NorecordAvailable
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translatsLabel.addAll(value));
    callCheckIns();
    crecheData = await CrecheDataHelper().getCrecheResponce();
    await callDatesList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  String callCrecheName(int nameId) {
    String returnValue = '';
    var items = crecheData.where((element) => element.name == nameId).toList();
    if (items.length > 0) {
      returnValue = Global.getItemValues(items[0].responces!, 'creche_name');
    }
    return returnValue;
  }

  Future<void> callDatesList() async {
    List<String> dateStringData = [];
    items.forEach((element) {
      var date = Global.getItemValues(element.responces, 'date_of_checkin');
      if (Global.validString(date)) {
        dateStringData.add(date!);
      }
    });
    var dateList = dateStringData.map((dateString) {
      List<int> dateParts = dateString.split('-').map(int.parse).toList();
      return DateTime(dateParts[0], dateParts[1], dateParts[2]);
    }).toList();
    if (dateList.length > 0) {
      maxDate = dateList
          .reduce((value, element) => value.isAfter(element) ? value : element);
      currentDateAttendece =
          maxDate == Validate().stringToDate(Validate().currentDate());
    }
    // lastGrowthDate = '${maxDate.year}-${maxDate.month}-${maxDate.day}';
  }

  Future<DateTime?> callDatesAlredDateList(String date) async {
    DateTime? lastGrowthDateNew;
    List<String> dateStringData = [];
    items.forEach((element) {
      var date = Global.getItemValues(element.responces, 'date_of_checkin');
      if (Global.validString(date)) {
        dateStringData.add(date!);
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
      minDate = lowesttDate;
      print('min $lowesttDate');
    } else
      minDate = null;

    return lastGrowthDateNew;
  }

  Future callCheckIns() async {
    items = await CheckInResponseHelper()
        .getCheckinsItem(widget.crechId.toString());
    unsynchedList = items.where((element) => element.is_edited == 1).toList();
    allList = items;
    items = isOnlyUnsynched ? unsynchedList : allList;
  }
}
