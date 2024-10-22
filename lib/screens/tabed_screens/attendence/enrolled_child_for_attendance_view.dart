import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../database/helper/child_attendence/child_attendance_helper_responce.dart';
import '../../../database/helper/child_attendence/child_attendence_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../../../model/databasemodel/child_attendance_responce_model.dart';
import '../../../model/databasemodel/child_for_attendence_model.dart';
import '../../../model/dynamic_screen_model/enrolled_children_responce_model.dart';
import '../../../style/styles.dart';
import 'attendance_responce_helper.dart';

class AddAttendanceView extends StatefulWidget {
  final String? ChildAttenGUID;
  final int crecheId;
  final Function(int) changeTab;
  const AddAttendanceView({
    required this.ChildAttenGUID,
    required this.changeTab,
    required this.crecheId,
    super.key,
  });

  @override
  State<AddAttendanceView> createState() => _AddAttendanceViewState();
}

class _AddAttendanceViewState extends State<AddAttendanceView> {
  String? lng;
  List<Translation> translats = [];
  List<EnrolledExitChildResponceModel> childHHData = [];
  List<ChildForAttendenceModel> attendecedRecord = [];
  int cIndex = 0;
  String? attendeceDate;
  Map<String, bool> checkedItem = {};
  Map<String, dynamic> myResponce = {};
  ChildAttendanceResponceModel? attendeceItem;
  bool _selectAll = true;

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
      CustomText.Next,
      CustomText.back,
      CustomText.careGiverName,
      CustomText.markAllPresent,
      CustomText.DateofAttendance,
      CustomText.childCount,
      CustomText.childPresent
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    childHHData = await EnrolledExitChilrenResponceHelper()
        .enrolledChildByCreche(widget.crecheId);
    var attendenceItem = await ChildAttendanceResponceHelper()
        .callAttendanceResponce(widget.ChildAttenGUID!);
    attendecedRecord = await ChildAttendenceHelper()
        .callChildAttendencesByGuid(widget.ChildAttenGUID!);

    if (attendenceItem.length > 0) {
      attendeceItem = attendenceItem[0];
      attendeceDate = Global.getItemValues(
          attendenceItem[0].responces!, 'date_of_attendance');
    }

    attendecedRecord.forEach((element) {
      if (element.attendance == 1) {
        checkedItem[element.childenrolledguid!] = true;
      } else {
        _selectAll = false;
      }
    });

    if (attendecedRecord.length > 0) {
      childHHData = await EnrolledExitChilrenResponceHelper()
          .enrolledChildByCrecheByAttendeGUID(
              widget.ChildAttenGUID!, widget.crecheId);
    } else
      _selectAll = false;

    // if(_selectAll==null){
    //   _selectAll=false;
    // }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          CustomDatepickerDynamic(
            initialvalue: attendeceDate,
            calenderValidate: [],
            isRequred: 0,
            readable: true,
            onChanged: (value) {},
            titleText: lng != null
                ? Global.returnTrLable(
                    translats, CustomText.DateofAttendance, lng!)
                : '',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  value: _selectAll == true,
                  onChanged: (value) {
                    // childHHData.forEach((element) =>
                    // checkedItem[element.ChildEnrollGUID!] = value!);
                    // setState(() {
                    //   _selectAll = !_selectAll;
                    // });
                  }),
              SizedBox(width: 5.w),
              Text(lng != null
                  ? Global.returnTrLable(
                      translats, CustomText.markAllPresent, lng!)
                  : CustomText.markAllPresent)
            ],
          ),
          Expanded(
            child: (childHHData.length > 0)
                ? ListView.builder(
                    itemCount: childHHData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          // String refStatus = '';
                          //   var selectedItem = childHHData[index];
                          //   refStatus = await Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //           builder: (BuildContext context) =>
                          //               EnrolledChilrenTab(
                          //                   CHHGUID: selectedItem['CHHGUID'],
                          //                   HHname: Global.stringToInt(
                          //                       selectedItem['HHname']
                          //                           .toString()),
                          //                   EnrolledChilGUID: selectedItem[
                          //                   'ChildEnrollGUID'])));
                          // if (refStatus == 'itemRefresh') {
                          //   await fetchChildHHDataList();
                          // }
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
                                        '${Global.returnTrLable(translats, CustomText.ChildName, lng!).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.careGiverName, lng!).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1.2),
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.ageInMonth, lng!).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1.2),
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
                                          Global.getItemValues(
                                              childHHData[index].responces!,
                                              'child_name'),
                                          style: Styles.cardBlue10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.getItemValues(
                                              childHHData[index].responces!,
                                              'name_of_primary_caregiver'),
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: 1.2),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          // Global.getItemValues(
                                          //     childHHData[index].responces!,
                                          //     'age_at_enrollment_in_months'),
                                          Global.validString(
                                                  Global.getItemValues(
                                                      childHHData[index]
                                                          .responces,
                                                      'child_dob'))
                                              ? Validate()
                                                  .calculateAgeInMonths(
                                                      Validate().stringToDate(
                                                          Global.getItemValues(
                                                              childHHData[index]
                                                                  .responces,
                                                              'child_dob')))
                                                  .toString()
                                              : Global.getItemValues(
                                                  childHHData[index].responces,
                                                  'age_at_enrollment_in_months'),
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: 1.2),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                      value: checkedItem[childHHData[index]
                                                  .ChildEnrollGUID] !=
                                              null
                                          ? checkedItem[childHHData[index]
                                              .ChildEnrollGUID]
                                          : false,
                                      onChanged: (newValue) {
                                        // setState(() {
                                        //   _selectAll=false;
                                        //   checkedItem[childHHData[index].ChildEnrollGUID!] = newValue!;
                                        // });
                                      })
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(lng != null
                        ? Global.returnTrLable(
                            translats, CustomText.NorecordAvailable, lng!)
                        : ''),
                  ),
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: CElevatedButton(
                  color: Color(0xffF26BA3),
                  onPressed: () {
                    nextTab(0, context);
                  },
                  text: lng != null
                      ? Global.returnTrLable(translats, CustomText.back, lng!)
                      : ''.trim(),
                ),
              ),
              // Row(children: [
              // SizedBox(width: 10),
              // Expanded(
              //   child: CElevatedButton(
              //     color: Color(0xff5979AA),
              //     onPressed: () {
              //       saveOnly(1, context);
              //       // widget.changeTab(1);
              //     },
              //     text: lng != null
              //         ? Global.returnTrLable(translats, 'Save', lng!).trim()
              //         : '',
              //   ),
              // ),
              // ]
              // ),
              SizedBox(width: 10),
              Expanded(
                child: CElevatedButton(
                  color: Color(0xff369A8D),
                  onPressed: () {
                    nextTab(1, context);
                    // widget.changeTab(1);
                  },
                  text: lng != null
                      ? Global.returnTrLable(translats, CustomText.Next, lng!)
                      : '',
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      // if (_checkValidation()) {
      await saveDataInData();
      widget.changeTab(type);
      // } else {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(translats, CustomText.pleaseSelectChildrenForAttendence, lng!),
      //       Global.returnTrLable(translats, CustomText.ok, lng!),
      //       false,
      //       mContext);
      // }
    } else {
      widget.changeTab(type);
    }
  }

  saveOnly(int type, BuildContext mContext) async {
    if (type == 1) {
      // if (_checkValidation()) {
      await saveDataInData();
      Validate().singleButtonPopup(
          Global.returnTrLable(translats, CustomText.dataSaveSuc, lng!),
          Global.returnTrLable(translats, CustomText.ok, lng!),
          false,
          mContext);
      // } else {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(translats, CustomText.pleaseSelectChildrenForAttendence, lng!),
      //       Global.returnTrLable(translats, CustomText.ok, lng!),
      //       false,
      //       mContext);
      // }
    }
  }

  bool _checkValidation() {
    var validStatus = false;
    if (checkedItem.isNotEmpty) {
      checkedItem.forEach((key, value) {
        if (value) {
          validStatus = true;
        }
      });
    }
    return validStatus;
  }

  Future<void> saveDataInData() async {
    List<ChildForAttendenceModel> selectedItem = [];
    // if (checkedItem.isNotEmpty) {

    childHHData.forEach((element) {
      var status = checkedItem[element.ChildEnrollGUID];
      if (status != null) {
        if (status) {
          var item = ChildForAttendenceModel(
              childattenguid: widget.ChildAttenGUID,
              date_of_attendance: attendeceDate,
              childenrolledguid: element.ChildEnrollGUID,
              child_profile_id: element.name,
              name_of_child:
                  Global.getItemValues(element.responces!, 'child_name'),
              attendance: 1);
          selectedItem.add(item);
        } else {
          var item = ChildForAttendenceModel(
              childattenguid: widget.ChildAttenGUID,
              date_of_attendance: attendeceDate,
              childenrolledguid: element.ChildEnrollGUID,
              child_profile_id: element.name,
              name_of_child:
                  Global.getItemValues(element.responces!, 'child_name'),
              attendance: 0);
          selectedItem.add(item);
        }
      } else {
        var item = ChildForAttendenceModel(
            childattenguid: widget.ChildAttenGUID,
            date_of_attendance: attendeceDate,
            childenrolledguid: element.ChildEnrollGUID,
            child_profile_id: element.name,
            name_of_child:
                Global.getItemValues(element.responces!, 'child_name'),
            attendance: 0);
        selectedItem.add(item);
      }
    });

    // }

    if (selectedItem.length > 0) {
      await ChildAttendenceHelper().insertAll(selectedItem);
      await updateNoOfServedForm(selectedItem);
    }
  }

  Future<void> updateNoOfServedForm(
      List<ChildForAttendenceModel> selectedItems) async {
    var attendecedRecordUpdate =
        selectedItems.where((element) => element.attendance == 1).toList();
    if (attendeceItem != null) {
      var brkfast = Global.stringToInt(
          Global.getItemValues(attendeceItem!.responces!, 'breakfast'));
      var lunch = Global.stringToInt(
          Global.getItemValues(attendeceItem!.responces!, 'lunch'));
      var egg = Global.stringToInt(
          Global.getItemValues(attendeceItem!.responces!, 'egg'));
      var eveningSnack = Global.stringToInt(
          Global.getItemValues(attendeceItem!.responces!, 'evening_snacks'));
      Map<String, dynamic> myMap = {};
      Map<String, dynamic> responseData = jsonDecode(attendeceItem!.responces!);
      responseData.forEach((key, value) {
        myMap[key] = value;
      });

      if ((attendecedRecordUpdate.length < brkfast)) {
        myMap.remove('breakfast');
      }
      if ((attendecedRecordUpdate.length < lunch)) {
        myMap.remove('lunch');
      }
      if ((attendecedRecordUpdate.length < egg)) {
        myMap.remove('egg');
      }
      if ((attendecedRecordUpdate.length < eveningSnack)) {
        myMap.remove('evening_snacks');
      }
      var responcesJs = jsonEncode(myMap);
      await AttendanceResponnceHelper()
          .callUpdaeAttendesResponce(widget.ChildAttenGUID!, responcesJs);
    }
  }
}
