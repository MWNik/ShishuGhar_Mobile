import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/child_attendence/child_attendance_helper_responce.dart';
import 'package:shishughar/database/helper/creche_helper/creche_data_helper.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/child_attendance_responce_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/depending_logic.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../../custom_widget/dynamic_screen_widget/custom_dynamic_image.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamin_multi_check_screen.dart';
import '../../../../custom_widget/single_poup_dailog.dart';
import '../../../../database/helper/anthromentory/child_growth_response_helper.dart';
import '../../../../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../../../../database/helper/dynamic_screen_helper/house_hold_children_helper.dart';
import '../../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../../database/helper/enrolled_children/enrolled_children_field_helper.dart';
import '../../../../database/helper/form_logic_helper.dart';
import '../../../../database/helper/height_weight_boys_girls_helper.dart';
import '../../../../database/helper/image_file_tab_responce_helper.dart';
import '../../../../database/helper/translation_language_helper.dart';
import '../../../../model/apimodel/tabHeight_for_age_Boys_model.dart';
import '../../../../model/apimodel/tabHeight_for_age_Girls_model.dart';
import '../../../../model/apimodel/tabWeight_for_age_Boys _model.dart';
import '../../../../model/apimodel/tabWeight_for_age_Girls _model.dart';
import '../../../../model/apimodel/tabWeight_to_Height_Boys_model.dart';
import '../../../../model/apimodel/tabWeight_to_Height_Girls_model.dart';
import '../../../../model/databasemodel/child_growth_responce_model.dart';
import '../../../../model/databasemodel/tab_image_file_model.dart';
import '../../../../style/styles.dart';
import '../../../../utils/globle_method.dart';

class ExitEnrolledChildTabItem extends StatefulWidget {
  final String EnrolledChilGUID;
  final String cHHGuid;
  final int HHname;
  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;
  final int isNew;
  final int crecheId;
  final bool isImageUpdate;
  final bool isEditable;
  String? minDate;
  final bool isForExit;
  final String screenType;
  final bool isForExitList;
  final bool isForCrecheEnrollment;


  ExitEnrolledChildTabItem(
      {super.key,
      required this.EnrolledChilGUID,
      required this.cHHGuid,
      required this.HHname,
      required this.tabBreakItem,
      required this.screenItem,
      required this.changeTab,
      required this.tabIndex,
      required this.totalTab,
      required this.isNew,
      required this.crecheId,
      required this.isImageUpdate,
      required this.isEditable,
      required this.screenType,
      this.minDate,
      required this.isForExit,
      required this.isForExitList,
      required this.isForCrecheEnrollment});

  @override
  _EnrolledChilrenTabItemState createState() => _EnrolledChilrenTabItemState();
}

class _EnrolledChilrenTabItemState extends State<ExitEnrolledChildTabItem> {
  bool _isLoading = true;
  bool shouldEditMesure = false;
  List<HouseHoldTabResponceHelper> retrivedList = [];
  List<OptionsModel> options = [];
  DependingLogic? logic;
  List<HouseHoldFielItemdModel> multselectItemTab = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translats = [];
  String userName = '';
  String? saveNext = CustomText.Next;
  String? responce;
  String? role;
  String lng = 'eng';
  bool isRecordNew = true;
  DateTime? minDateforExit;
  String childDOB = '';
  List<TabHeightforageBoysModel> tabHeightforageBoys = [];
  List<TabHeightforageGirlsModel> tHeightforageGirls = [];
  List<TabWeightforageBoysModel> tabWeightforageBoys = [];
  List<TabWeightforageGirlsModel> tabWeightforageGirls = [];
  List<TabWeightToHeightBoysModel> tabWeightToHeightBoys = [];
  List<TabWeightToHeightGirlsModel> tabWeightToHeightGirls = [];

  // List<String> redableItemsData = [
  //
  // ];
  List<String> redableItemsDate = [
    'child_dob',
    'date_of_enrollment',
    'gender_id',
    'child_id',
    'child_name',
    'height',
    'weight',
    'measurement_taken',
    'measurement_equipment',
    'measurement_date'
  ];

  List<String> colorIndicatorForMeasure = [
    'weight_for_age',
    'weight_for_height',
    'height_for_age',
  ];

  List<String> zscoreIndicatorForMeasure = [
    'height_for_age_zscore',
    'weight_for_height_zscore',
    'weight_for_age_zscore',
  ];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    userName = (await Validate().readString(Validate.userName))!;
    role = await Validate().readString(Validate.role);
    List<String> valueNames = [
      CustomText.Creches,
      CustomText.Next,
      CustomText.back,
      CustomText.ok,
      CustomText.exit,
      CustomText.ChildEnrollsuccess,
      CustomText.enrolled,
      CustomText.dataSaveSuc,
      CustomText.childUpdatedSucces,
      CustomText.ChildEnrollsuccess,
      CustomText.Submit,
      CustomText.Yes,
      CustomText.No,
      CustomText.typehere,
      CustomText.select_here,
      CustomText.valuLesThanOrEqual,
      CustomText.valueLesThan,
      CustomText.valuGreaterThanOrEqual,
      CustomText.valuGreaterThan,
      CustomText.valuEqual,
      CustomText.plsSelectIn,
      CustomText.valuLenLessOrEqual,
      CustomText.valuLenGreaterOrEqual,
      CustomText.valuLenEqual,
      CustomText.PleaseEnterValueIn,
      CustomText.PleaseSelectAfterTimeIn,
      CustomText.PleaseSelectAfterDateIn,
      CustomText.PleaseSelectBeforTimeIn,
      CustomText.PleaseSelectBeforDateIn,
      CustomText.PleaseSelectBeforTimeInIsValidTime,
      CustomText.plsFilManForm,
      CustomText.wesUsageGraterQuatOpen,
      CustomText.leavingLesThanjoining,
      CustomText.ChildIsNotAppilcableForExitToday
    ];
    List<HouseHoldFielItemdModel> items =
        widget.screenItem[widget.tabBreakItem.name!]!;
    items.forEach((element) {
      if (Global.validString(element.label)) {
        valueNames.add(element.label!);
      }
    });

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats.addAll(value));

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

    if (widget.isNew == 1) {
      isRecordNew = false;
    }

    multselectItemTab =
        await EnrolledChildrenFieldHelper().callMultiSelectTabItem();
    await updateHiddenValue();
    await callScrenControllers(widget.screenType);
    // calinitialScreen();
    if (widget.tabIndex == (widget.totalTab - 1)) {
      saveNext = CustomText.Submit;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'itemRefresh');
        return false; // Change this according to your logic
      },
      child: _isLoading
          ? Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()))
          : Scaffold(
              body: Column(
                children: [
                  Divider(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: cWidget(widget.tabBreakItem.name!),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CElevatedButton(
                            color: Color(0xffF26BA3),
                            onPressed: () {
                              // ch(2);
                              nextTab(0, context);
                            },
                            text: Global.returnTrLable(
                                    translats, CustomText.back, lng)
                                .trim(),
                          ),
                        ),
                        // Row(children: [
                        SizedBox(width: 10),
                        role == 'Creche Supervisor'
                            ? widget.tabIndex == (widget.totalTab - 1)
                                ?
                                //  Expanded(
                                //     child: CElevatedButton(
                                //     color: Color(0xff5979AA),
                                //     onPressed: () {
                                //       Navigator.pop(context, 'itemRefresh');
                                //     },
                                //     text: Global.returnTrLable(
                                //         translats, CustomText.exit, lng),
                                //   ))
                                SizedBox()
                                : (widget.isEditable == true
                                    ? Expanded(
                                        child: CElevatedButton(
                                          color: Color(0xff5979AA),
                                          onPressed: () {
                                            saveOnly(1, context);
                                            // widget.changeTab(1);
                                          },
                                          text: Global.returnTrLable(
                                                  translats, 'Save', lng)
                                              .trim(),
                                        ),
                                      )
                                    : SizedBox())
                            : SizedBox(),
                        // ]
                        // ),
                        role == 'Creche Supervisor'
                            ? widget.tabIndex == (widget.totalTab - 1)
                                ? (widget.isEditable == true
                                    ? SizedBox(width: 10)
                                    : SizedBox())
                                : (widget.isEditable == true
                                    ? SizedBox(width: 10)
                                    : SizedBox())
                            : SizedBox(),
                        widget.tabIndex == (widget.totalTab - 1)
                            ? (widget.isEditable == false
                                ? widget.isForCrecheEnrollment
                                    ? SizedBox()
                                    : Expanded(
                                        child: CElevatedButton(
                                        color: Color(0xff5979AA),
                                        onPressed: () {
                                          Navigator.pop(context, 'itemRefresh');
                                        },
                                        text: Global.returnTrLable(
                                            translats, CustomText.exit, lng),
                                      ))
                                : Expanded(
                                    child: CElevatedButton(
                                      color: Color(0xff5979AA),
                                      onPressed: () {
                                        widget.isEditable == true
                                            ? nextTab(1, context)
                                            : widget.changeTab(1);
                                      },
                                      text: widget.tabIndex ==
                                              (widget.totalTab - 1)
                                          ? ((isRecordNew)
                                              ? Global.returnTrLable(translats,
                                                  CustomText.Submit, lng)
                                              : Global.returnTrLable(translats,
                                                  CustomText.Submit, lng))
                                          : Global.returnTrLable(
                                              translats, CustomText.Next, lng),
                                    ),
                                  ))
                            : Expanded(
                                child: CElevatedButton(
                                  color: Color(0xff369A8D),
                                  onPressed: () {
                                    widget.isEditable == true
                                        ? nextTab(1, context)
                                        : widget.changeTab(1);
                                  },
                                  text: widget.tabIndex == (widget.totalTab - 1)
                                      ? ((isRecordNew)
                                          ? Global.returnTrLable(
                                              translats, CustomText.Enroll, lng)
                                          : Global.returnTrLable(translats,
                                              CustomText.Submit, lng))
                                      : Global.returnTrLable(
                                          translats, CustomText.Next, lng),
                                ),
                              ),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: CElevatedButton(
                  //           color: Color(0xffF26BA3),
                  //           onPressed: () {
                  //             // ch(2);
                  //             nextTab(0, context);
                  //           },
                  //           text: Global.returnTrLable(
                  //                   translats, CustomText.back, lng)
                  //               .trim(),
                  //         ),
                  //       ),
                  //       // Row(children: [
                  //       SizedBox(width: 10),
                  //       role == 'Creche Supervisor'
                  //           ? widget.tabIndex == (widget.totalTab - 1)
                  //               ?
                  //               //  Expanded(
                  //               //     child: CElevatedButton(
                  //               //     color: Color(0xff5979AA),
                  //               //     onPressed: () {
                  //               //       Navigator.pop(context, 'itemRefresh');
                  //               //     },
                  //               //     text: Global.returnTrLable(
                  //               //         translats, CustomText.exit, lng),
                  //               //   ))
                  //               SizedBox()
                  //               : (widget.isEditable == true
                  //                   ? Expanded(
                  //                       child: CElevatedButton(
                  //                         color: Color(0xff5979AA),
                  //                         onPressed: () {
                  //                           saveOnly(1, context);
                  //                           // widget.changeTab(1);
                  //                         },
                  //                         text: Global.returnTrLable(
                  //                                 translats, 'Save', lng)
                  //                             .trim(),
                  //                       ),
                  //                     )
                  //                   : SizedBox())
                  //           : SizedBox(),
                  //       // ]
                  //       // ),
                  //       role == 'Creche Supervisor'
                  //           ? widget.tabIndex == (widget.totalTab - 1)
                  //               ? (widget.isEditable == true?SizedBox(width: 10):SizedBox())
                  //               : (widget.isEditable == true
                  //                   ? SizedBox(width: 10)
                  //                   : SizedBox())
                  //           : SizedBox(),
                  //       widget.tabIndex == (widget.totalTab - 1)
                  //           ? (widget.isEditable == false
                  //               ? Expanded(
                  //                   child: CElevatedButton(
                  //                   color: Color(0xff5979AA),
                  //                   onPressed: () {
                  //                     Navigator.pop(context, 'itemRefresh');
                  //                   },
                  //                   text: Global.returnTrLable(
                  //                       translats, CustomText.exit, lng),
                  //                 ))
                  //               : Expanded(
                  //                   child: CElevatedButton(
                  //                     color: Color(0xff5979AA),
                  //                     onPressed: () {
                  //                       widget.isEditable == true
                  //                           ? nextTab(1, context)
                  //                           : widget.changeTab(1);
                  //                     },
                  //                     text: widget.tabIndex ==
                  //                             (widget.totalTab - 1)
                  //                         ? ((isRecordNew)
                  //                             ? Global.returnTrLable(translats,
                  //                                 CustomText.Enroll, lng)
                  //                             : Global.returnTrLable(translats,
                  //                                 CustomText.Submit, lng))
                  //                         : Global.returnTrLable(
                  //                             translats, CustomText.Next, lng),
                  //                   ),
                  //                 ))
                  //           : Expanded(
                  //               child: CElevatedButton(
                  //                 color: Color(0xff369A8D),
                  //                 onPressed: () {
                  //                   widget.isEditable == true
                  //                       ? nextTab(1, context)
                  //                       : widget.changeTab(1);
                  //                 },
                  //                 text: widget.tabIndex == (widget.totalTab - 1)
                  //                     ? ((isRecordNew)
                  //                         ? Global.returnTrLable(
                  //                             translats, CustomText.Enroll, lng)
                  //                         : Global.returnTrLable(translats,
                  //                             CustomText.Submit, lng))
                  //                     : Global.returnTrLable(
                  //                         translats, CustomText.Next, lng),
                  //               ),
                  //             ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }

  List<Widget> cWidget(
    String itemId,
  ) {
    List<Widget> screenItems = [];
    var items = widget.screenItem[itemId];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        screenItems.add(widgetTypeWidget(i, items[i]));
        screenItems.add(SizedBox(height: 5.h));
        if (!logic!.callDependingLogic(myMap, items[i])) {
          myMap.remove(items[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          hintText:
              Global.returnTrLable(translats, CustomText.select_here, lng),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : (quesItem.fieldname == 'reason_for_exit'
                  ? 1
                  : logic!.dependeOnMendotory(myMap, quesItem)),
          items: items,
          readable: widget.isEditable == true
              ? (widget.isForExit
                  ? redableItemsDate.contains(quesItem.fieldname)
                      ? true
                      : logic!.callReadableLogic(myMap, quesItem)
                  : logic!.callReadableLogic(myMap, quesItem))
              : true,
          selectedItem: myMap[quesItem.fieldname],
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            if (value != null)
              myMap[quesItem.fieldname!] = value.name!;
            else
              myMap.remove(quesItem.fieldname);
            setState(() {});
          },
        );
      case 'Date':
        var minDate;
        if (quesItem.fieldname == 'date_of_enrollment'|| quesItem.fieldname == 'date_of_exit') {
          if (Global.validString(widget.minDate)) {
            minDate =
                DateTime.parse(widget.minDate!).subtract(Duration(days: 1));
          }
        }
        // else if (quesItem.fieldname == 'date_of_exit') {
        //   minDate = minDateforExit;
        // }
        return CustomDatepickerDynamic(
          initialvalue: quesItem.fieldname == 'date_of_enrollment_awc'
              ? (Global.validString(myMap['date_of_enrollment_awc'])
                  ? myMap[quesItem.fieldname]
                  : Global.initCurrentDate())
              : myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          readable: widget.isEditable == true
              ? (widget.isForExit
                  ? (redableItemsDate.contains(quesItem.fieldname)
                      ? true
                      : logic!.callReadableLogic(myMap, quesItem))
                  : logic!.callReadableLogic(myMap, quesItem))
              : true,
          minDate: quesItem.fieldname == 'date_of_exit'
              ? minDate
              : Global.stringToDate(myMap['date_of_enrollment']),
          // minDate: minDate,
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          calenderValidate: logic!.calenderValidation(myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;

            var logData = logic!.callDateDiffrenceLogic(myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                // var item =myMap[logData.keys.first];
                // if(item==null||logData.values.first!=item) {
                myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);

                // }
              }
            }
            setState(() {});
          },
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
        );
      case 'Data':
        if (!zscoreIndicatorForMeasure.contains(quesItem.fieldname))
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname],
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          maxlength: quesItem.length,
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          readable: widget.isEditable == true
              ? (widget.isForExit
                  ? redableItemsDate.contains(quesItem.fieldname)
                      ? true
                      : logic!.callReadableLogic(myMap, quesItem)
                  : logic!.callReadableLogic(myMap, quesItem))
              : true,
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
        else return SizedBox();
      case 'Int':
        return DynamicCustomTextFieldInt(
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              myMap[quesItem.fieldname!] = value;
              var logData = logic!.callAutoGeneratedValue(myMap, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  myMap.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  // setState(() {});
                }
              }
            } else {
              myMap.remove(quesItem.fieldname);
              // setState(() {});
            }
          },
        );
      case 'Table MultiSelect': // Multi select Drop Down
        String itemResopnceField = '';
        List<OptionsModel> items = options
            .where(
                (element) => element.flag == 'tab${quesItem.multiselectlink}')
            .toList();
        List<HouseHoldFielItemdModel> msFieldName = multselectItemTab
            .where((element) => element.parent == '${quesItem.options}')
            .toList();
        if (msFieldName.length > 0) {
          itemResopnceField = msFieldName[0].fieldname!;
        }
        return DynamicMultiCheckGridView(
          items: items,
          childRatio: quesItem.fieldname == "specially_abled_option" ? 2.2 : 4,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          selectedItem: myMap[quesItem.fieldname],
          responceFieldName: itemResopnceField,
          readable: widget.isEditable == true ? null : true,
          onChanged: (value) {
            if (value != null)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);

            setState(() {});
          },
        );
      // case 'Check':
      //   return DynamicCustomCheckboxWithLabel(
      //     label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
      //     initialValue: myMap[quesItem.fieldname!],
      //     isVisible: logic!.callDependingLogic(myMap,quesItem),
      //     onChanged: (value) {
      //       if(value>0)
      //         myMap[quesItem.fieldname!] = value;
      //       else myMap.remove(quesItem.fieldname);
      //       setState(() {});
      //     },
      //   );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: translats,
          lng: lng,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          readable: widget.isEditable == true
              ? (widget.isForExit
                  ? redableItemsDate.contains(quesItem.fieldname)
                      ? true
                      : logic!.callReadableLogic(myMap, quesItem)
                  : logic!.callReadableLogic(myMap, quesItem))
              : true,
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            if (myMap['child_specially_abled'] == 0) {
              myMap['specially_abled_option'] = [];
            }
            if (quesItem.fieldname == 'is_child_enrolled_awc' &&
                myMap['is_child_enrolled_awc'] == 1) {
              myMap['date_of_enrollment_awc'] =
                  Global.validString(myMap['date_of_enrollment'])
                      ? myMap['date_of_enrollment']
                      : Global.initCurrentDate();
            }
            setState(() {});
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          maxline: 3,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialvalue: myMap[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null)
              myMap[quesItem.fieldname!] = value;
            else {
              myMap.remove(quesItem.fieldname);
              setState(() {});
            }
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          initialvalue: myMap[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Float':
        if (!colorIndicatorForMeasure.contains(quesItem.fieldname)&&!zscoreIndicatorForMeasure.contains(quesItem.fieldname))
        return DynamicCustomTextFieldFloat(
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd,
          maxlength: quesItem.length,
          fieldName: quesItem.fieldname!,
          initialvalue: myMap[quesItem.fieldname!],
          readable: widget.isEditable == true
              ? (quesItem.fieldname == 'height' ||
                      quesItem.fieldname == 'weight'
                  ? (widget.isForExit
                      ? (redableItemsDate.contains(quesItem.fieldname)
                          ? true
                          : false)
                      : shouldEditMesure)
                  : logic!.callReadableLogic(myMap, quesItem))
              : true,
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              myMap[quesItem.fieldname!] = value;
              var logData = logic!.callAutoGeneratedValue(myMap, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  myMap.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                }
              }
            } else {
              myMap.remove(quesItem.fieldname);
            }
          },
        );
        else if (quesItem.fieldname == 'weight_for_age' &&
            myMap['measurement_taken'].toString() == '1') {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xffE0E0E0)),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: cWidgetRadiomColorPop(),
            ),
          );
        } else
          return SizedBox();
      case 'Attach':
        return CustomImageDynamic(
          child_guid: widget.EnrolledChilGUID,
          assetPath: myMap[quesItem.fieldname!],
          readable: widget.isEditable == true ? widget.isImageUpdate : true,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          onChanged: (value) async {},
          onName: (value) async {
            myMap[quesItem.fieldname!] = value;
            await saveImageInDatabase(
                value, Global.validToString(quesItem.fieldname));
            setState(() {});
          },
        );
      default:
        return SizedBox();
    }
  }

  Future<void> callScrenControllers(screen_type) async {
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    List<HouseHoldFielItemdModel> items =
        widget.screenItem[widget.tabBreakItem.name!]!;
    List<String> defaultCommon = [];
    List<String> logicFields = [];
    for (int i = 0; i < items.length; i++) {
      if (Global.validString(items[i].options)) {
        if (items[i].options == 'Creche') {
          await OptionsModelHelper()
              .callCrechInOption(items[i].options!.trim(), widget.crecheId)
              .then((data) {
            options.addAll(data);
          });
          defaultDisableDailog(items[i].fieldname!, items[i].options!);
        } else {
          if (items[i].ismultiselect == 1) {
            defaultCommon.add('tab${items[i].multiselectlink!.trim()}');
          } else
            defaultCommon.add('tab${items[i].options!.trim()}');
        }
      }
      logicFields.add(items[i].fieldname!);
    }
    await OptionsModelHelper()
        .getAllMstCommonNotINOptionsWthouASC(defaultCommon, lng)
        .then((data) {
      options.addAll(data);
    });
    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logic = DependingLogic(translats, data, lng);
    });
    // await FormLogicDataHelper().callFormLogic('Child Enrollment and Exit').then((data) {
    //   logics.addAll(data);
    // });
  }

  defaultDisableDailog(String fieldName, String flag) async {
    var tabName = 'tab$flag';
    var item = options.where((element) => element.flag == tabName).toList();
    if (item.length >0) {
      myMap[fieldName] = item.first.name!;
    }
  }

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        if (widget.tabIndex < (widget.totalTab - 1)) {
          await saveDataInData();
        } else if (widget.tabIndex == (widget.totalTab - 1)) {
          await saveDataInData();
          String msg = Global.returnTrLable(
              translats, CustomText.ChildEnrollsuccess, lng);
          if (widget.screenType == 'Child Enrollment and Exit') {
            msg = Global.returnTrLable(translats, CustomText.dataSaveSuc, lng);
          } else {
            if (!isRecordNew) {
              msg = Global.returnTrLable(
                  translats, CustomText.childUpdatedSucces, lng);
            }
          }

          bool shouldProceed = await showDialog(
            context: context,
            builder: (context) {
              return SingleButtonPopupDialog(
                  message: msg,
                  button: Global.returnTrLable(translats, CustomText.ok, lng));
            },
          );
          if (shouldProceed) {
            if (shouldProceed == true) {
              Navigator.pop(context, 'itemRefresh');
            }
          }
          // return;
        }
        widget.changeTab(type);
        setState(() {});
      }
    } else {
      if (widget.tabIndex == 0) {
        Navigator.pop(context, 'itemRefresh');
      } else {
        widget.changeTab(type);
      }
    }
  }

  saveOnly(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        await saveDataInData();
        Validate().singleButtonPopup(
            Global.returnTrLable(translats, CustomText.dataSaveSuc, lng),
            Global.returnTrLable(translats, CustomText.ok, lng),
            false,
            context);
      }
    } else {
      if (widget.tabIndex == 0) {
        Navigator.pop(context, 'itemRefresh');
      } else {
        widget.changeTab(type);
      }
    }
  }

  Future<void> saveDataInData() async {
    var widgets = widget.screenItem[widget.tabBreakItem.name];
    if (widgets != null) {
      Map<String, dynamic> responces = {};
      widgets.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
      });
      // myMap['is_exited']=1;
      var responcesJs = jsonEncode(myMap);
      var name = myMap['name'];

      print(responcesJs);
      await EnrolledExitChilrenResponceHelper().insertUpdate(
          widget.EnrolledChilGUID,
          widget.cHHGuid,
          widget.HHname,
          Global.stringToIntNull(name.toString()),
          Global.stringToInt(myMap['creche_id']),
          responcesJs,
          myMap['appcreated_on'],
          myMap['appcreated_by'],
          myMap['app_updated_on'],
          myMap['app_updated_by'],
          myMap['date_of_exit']);

      var reffralItem = await ChildReferralTabResponseHelper()
          .callChildReffralsByEnrolledGUID(widget.EnrolledChilGUID);
      if (reffralItem.length > 0) {
        if (reffralItem.last['visit_count'] > 0) {
          Map<String, dynamic> jsonBody =
              jsonDecode(reffralItem.last['responces']!);
          jsonBody['visit_count'] = 0;
          var itemResponce = jsonEncode(jsonBody);
          await ChildReferralTabResponseHelper().updateVisitFollowUps(
              itemResponce, reffralItem.last['child_referral_guid'], 0);
        }
      }
    }
  }

  String getItemValues(String response, String key) {
    String returnValue = "";
    Map<String, dynamic> itemresponse = jsonDecode(response);
    var value = itemresponse[key];
    if (value != null) {
      returnValue = value.toString();
    }
    return returnValue;
  }

  bool _checkValidation() {
    var validStatus = true;
    var items = widget.screenItem[widget.tabBreakItem.name];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        var element = items[i];
        if (element.reqd == 1) {
          var valuees = myMap[element.fieldname];
          if (!Global.validString(valuees.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(translats, CustomText.plsFilManForm, lng),
                Global.returnTrLable(translats, CustomText.ok, lng),
                false,
                context);
            validStatus = false;
            break;
          }
        } else if (element.fieldname == "reason_for_exit") {
          var valuess = myMap[element.fieldname];
          if (!Global.validString(valuess.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(translats, CustomText.plsFilManForm, lng),
                Global.returnTrLable(translats, CustomText.ok, lng),
                false,
                context);
            validStatus = false;
            break;
          }
        }
        var validationMsg = logic!.validationMessge(myMap, element);
        if (Global.validString(validationMsg)) {
          if ((Global.validString(myMap['reason_for_exit'].toString()) &&
              element.fieldname == 'age_at_enrollment_in_months')) {
            validStatus = true;
          } else {
            Validate().singleButtonPopup(
                validationMsg!,
                Global.returnTrLable(translats, CustomText.ok, lng),
                false,
                context);
            validStatus = false;
            break;
          }
        }
      };
    } else {
      print("selected items is null");
    }

    return validStatus;
  }

  Future<void> updateHiddenValue() async {
    var alredRecord = await EnrolledExitChilrenResponceHelper()
        .callChildrenResponce(widget.EnrolledChilGUID);

    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData.forEach((key, value) {
        myMap[key] = value;
      });
      if (widget.isForExitList) {
        myMap['date_of_exit'] = Validate().currentDate();
        if (Global.validString(myMap['date_of_exit']) &&
            Global.validString(myMap['child_dob'])) {
          var durationInMonths =
              duration(myMap['date_of_exit'], myMap['child_dob']);
          myMap['age_of_exit'] = durationInMonths.toInt();
        }
      }

      if (responseData['appcreated_on'] != null ||
          responseData['appcreated_by'] != null) {
        if (widget.isForExitList == true && widget.isEditable == true) {
          myMap['appcreated_on'] = Validate().currentDateTime();
          myMap['appcreated_by'] = userName;
          myMap['app_updated_on'] = Validate().currentDateTime();
          myMap['app_updated_by'] = userName;
        } else {
          myMap['app_updated_on'] = Validate().currentDateTime();
          myMap['app_updated_by'] = userName;
        }
      }
      if (Global.validString(myMap['date_of_enrollment'])) {
        var parts = myMap['date_of_enrollment']
            .toString()
            .split('-')
            .map(int.parse)
            .toList();
        minDateforExit =
            DateTime(parts[0], parts[1], parts[2]).subtract(Duration(days: 1));
        // await callMaxDateFromAttendenceOrAntro();

      }
      if (widget.isForExit) {
        if (!Global.validString(myMap['date_of_enrollment_awc'])) {
          myMap['date_of_enrollment_awc'] = Global.initCurrentDate();
        }
      }

      childDOB = Global.getItemValues(alredRecord[0].responces, 'child_dob');
      var name = alredRecord[0].name;
      if (name != null) {
        myMap['name'] = name;
      }
      if (alredRecord.first.is_edited == 0) {
        if (Global.stringToDouble(myMap['height'].toString()) == 0) {
          myMap.remove('height');
        }
        if (Global.stringToDouble(myMap['weight'].toString()) == 0) {
          myMap.remove('weight');
        }
      }

      DateTime date_of_enrollment =
          DateTime.parse(responseData['date_of_enrollment']);
      if (date_of_enrollment
          .add(Duration(days: 30))
          .isBefore(DateTime.parse(Validate().currentDate()))) {
        shouldEditMesure = true;
      }
    }
    else {
      var fromHHInfo = await HouseHoldChildrenHelperHelper()
          .callHouseHoldChildrenItem(widget.cHHGuid);
      Map<String, dynamic> responseData = jsonDecode(fromHHInfo[0].responces!);

      childDOB = Global.getItemValues(fromHHInfo[0].responces, 'child_dob');
      // myMap['gender_id'] =
      //     Global.getItemValues(fromHHInfo[0].responces, 'gender_id');
      responseData.forEach((key, value) {
        if (key != 'appcreated_on' && key != 'appcreated_by' && key != 'name')
          myMap[key] = value;
      });

      var crecheInfo =
          await CrecheDataHelper().getCrecheResponceItem(widget.crecheId);
      if (crecheInfo.isNotEmpty) {
        Map<String, dynamic> result = jsonDecode(crecheInfo.first.responces!);
        List<String> locationItem = [
          'state_id',
          'district_id',
          'block_id',
          'gp_id',
          'village_id'
        ];
        result.forEach((key, value) {
          if (locationItem.contains(key)) {
            myMap[key] = value;
          }
        });
      }

      myMap['date_of_enrollment'] = Global.initCurrentDate();
      myMap['appcreated_by'] = userName;
      myMap['appcreated_on'] = Validate().currentDateTime();

      if (Global.validString(myMap['date_of_enrollment']) &&
          Global.validString(myMap['child_dob'])) {
        var durationInMonths =
            duration(myMap['date_of_enrollment'], myMap['child_dob']);
        myMap['age_at_enrollment_in_months'] = durationInMonths.toInt();
      }
    }
    myMap['hhcguid'] = widget.cHHGuid;
    myMap['is_exited'] = 1;
    myMap['childenrollguid'] = widget.EnrolledChilGUID;

  }

  double duration(String date_ofenrollment, String childdob) {
    var date_of_enrollment = DateTime.parse(date_ofenrollment);
    var child_dob = DateTime.parse(childdob);
    Duration duration = date_of_enrollment.difference(child_dob);
    var durationInDays = duration.inDays;
    var durationInMonths = durationInDays / 30;
    return durationInMonths;
  }

  saveImageInDatabase(String imageName, String imageFieldName) async {
    var item = await ImageFileTabHelper()
        .getImageByDoctypeId(widget.EnrolledChilGUID, CustomText.ChildProfile);
    var items = ImageFileTabResponceModel(
      image_name: imageName,
      doctype: CustomText.ChildProfile,
      field_name: imageFieldName,
      doctype_guid: widget.EnrolledChilGUID,
      img_guid: Validate().randomGuid(),
      is_edited: 1,
      update_at: "",
      updated_by: "",
      name: myMap['name'],
      is_uploaded: 0,
      created_at: Validate().currentDateTime(),
      created_by: userName,
    );
    if (item.isEmpty) {
      await ImageFileTabHelper().inserts(items);
    } else {
      await ImageFileTabHelper().updateImageOnlyItem(items);
    }
  }

  // Future callMaxDateFromAttendenceOrAntro()async {
  //
  //   String? atendeceMaxDate=await ChildAttendanceResponceHelper().maxAendenceChildItem(widget.EnrolledChilGUID);
  //   List<ChildGrowthMetaResponseModel>? growthItems=await ChildGrowthResponseHelper().anthormentryByCrecheIdAsc(widget.crecheId);
  //   String? growthMonitoringMaxDate;
  //   if(growthItems.isNotEmpty){
  //     growthItems.forEach((element) {
  //       Map<String, dynamic> responseData = jsonDecode(element.responces!);
  //       if(responseData['anthropromatic_details']!=null){
  //         List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(
  //             responseData['anthropromatic_details']);
  //
  //         var childItem = children
  //             .where((cItems) => cItems['childenrollguid'] == widget.EnrolledChilGUID)
  //             .toList();
  //         if(childItem.isNotEmpty){
  //           var gerothDate=Global.validString(childItem.first['measurement_taken_date'])?childItem.first['measurement_taken_date']:element.measurement_date;
  //         if(growthMonitoringMaxDate!=null){
  //           if(Validate().stringToDate(growthMonitoringMaxDate!).isBefore(Validate().stringToDate(gerothDate))){
  //             growthMonitoringMaxDate=gerothDate;
  //           }
  //         }else growthMonitoringMaxDate=gerothDate;
  //         }
  //       }
  //
  //     });
  //     print(growthMonitoringMaxDate);
  //   }
  //   if(Global.validString(growthMonitoringMaxDate)&&Global.validString(atendeceMaxDate)){
  //     if(Validate().stringToDate(growthMonitoringMaxDate!)
  //         .isAfter(Validate().stringToDate(atendeceMaxDate!))){
  //       minDateforExit=Validate().stringToDate(growthMonitoringMaxDate!);
  //     }else minDateforExit=Validate().stringToDate(atendeceMaxDate);
  //   }else if(Global.validString(growthMonitoringMaxDate)||Global.validString(atendeceMaxDate)){
  //     if(Global.validString(growthMonitoringMaxDate)){
  //       minDateforExit=Validate().stringToDate(growthMonitoringMaxDate!);
  //     }else minDateforExit=Validate().stringToDate(atendeceMaxDate!);
  //   }else minDateforExit;
  //   var currentDate=Validate().stringToDate(Validate().currentDate());
  //
  //   if((currentDate.year==minDateforExit!.year)&&
  //       (currentDate.month==minDateforExit!.month)&&(currentDate.day==minDateforExit!.day)){
  //     Validate().singleButtonPopup(
  //         CustomText.ChildIsNotAppilcableForExitToday,
  //         Global.returnTrLable(translats, CustomText.ok, lng),
  //         true,
  //         context);
  //   }
  //
  //
  // }

  List<Widget> cWidgetRadiomColorPop() {
    List<Widget> screenItems = [];

    var items = widget.screenItem[widget.tabBreakItem.name!];
    if (items != null) {
      if (myMap['measurement_date'] != null &&
          myMap['child_dob'] != null &&
          myMap['gender_id'] != null) {
        var measurementDate =
        Validate().stringToDateNull(myMap['measurement_date']);
        var childDob = Validate().stringToDateNull(myMap['child_dob']);

        if (measurementDate != null && childDob != null) {
          var calucalteDate =
          Validate().calculateAgeInDaysEx(childDob, measurementDate);
          myMap['age_months'] = calucalteDate;
        }
      }

      items = items
          .where(
              (element) => colorIndicatorForMeasure.contains(element.fieldname))
          .toList();
      for (int i = 0; i < items.length; i++) {
        int colorD = DependingLogic.AutoColorCreateByHeightWightNew(
            tabHeightforageBoys,
            tHeightforageGirls,
            tabWeightforageBoys,
            tabWeightforageGirls,
            tabWeightToHeightBoys,
            tabWeightToHeightGirls,
            items[i].fieldname!,
            myMap['gender_id'],myMap['measurement_date'],
            myMap);
        String grothValue =
        DependingLogic.AutoColorCreateByHeightWightStringNew(
            tabHeightforageBoys,
            tHeightforageGirls,
            tabWeightforageBoys,
            tabWeightforageGirls,
            tabWeightToHeightBoys,
            tabWeightToHeightGirls,
            items[i].fieldname!,
            myMap['gender_id'],myMap['measurement_date'],
            myMap);

        Color itemC = Color(0xffAAAAAA);
        String colorName = '';
        if (colorD == 0) {
          itemC = Color(0xffAAAAAA);
          colorName = '';
        } else if (colorD == 1) {
          itemC = Color(0xffF35858);
          colorName =
          '(${Global.returnTrLable(translats, CustomText.Severe, lng)})';
        } else if (colorD == 2) {
          itemC = Color(0xffF4B81D);
          colorName =
          '(${Global.returnTrLable(translats, CustomText.Moderate, lng)})';
        } else if (colorD == 3) {
          itemC = Color(0xff8BF649);
          colorName =
          '(${Global.returnTrLable(translats, CustomText.Normal, lng)})';
        }
        myMap[items[i].fieldname!] = colorD;
        screenItems.add(Column(
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: itemC,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            Text(
              Global.returnTrLable(translats, items[i].label!.trim(), lng),
              style: Styles.black85,
              strutStyle: StrutStyle(height: 1.2),
            ),
            Text(
              colorName,
              style: Styles.black12700,
            ),
            Global.validString(grothValue)
                ? Text(
              '($grothValue)',
              style: Styles.red85,
            )
                : SizedBox(),
          ],
        ));
      }
      // }
    }
    return screenItems;
  }
}
