import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/depending_logic.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_time_picker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/child_attendence/attendance_responce_helper.dart';
import '../../../database/helper/child_attendence/child_attendence_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_attendance_responce_model.dart';
import '../../../model/databasemodel/child_for_attendence_model.dart';
import '../../../model/databasemodel/tabBlock_model.dart';
import '../../../model/databasemodel/tabDistrict_model.dart';
import '../../../model/databasemodel/tabGramPanchayat_model.dart';
import '../../../model/databasemodel/tabVillage_model.dart';
import '../../../model/databasemodel/tabstate_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import 'attendance_form_screen_tab.dart';

class AttendanceTabItemsView extends StatefulWidget {
  final int? creche_nameId;
  final String? creche_name;
  final String ChildAttenGUID;
  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;

  const AttendanceTabItemsView(
      {super.key,
      required this.creche_nameId,
      required this.creche_name,
      required this.ChildAttenGUID,
      required this.tabBreakItem,
      required this.screenItem,
      required this.changeTab,
      required this.tabIndex,
      required this.totalTab});

  @override
  State<AttendanceTabItemsView> createState() => _AttendanceTabItemsViewState();
}

class _AttendanceTabItemsViewState extends State<AttendanceTabItemsView> {
  bool _isLoading = true;

  DependingLogic? logic;
  List<OptionsModel> options = [];
  List<TabFormsLogic> logics = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translats = [];
  String userName = '';
  bool recrdedUpload = false;
  String? saveNext = CustomText.Next;
  String? responce;
  String lng = 'eng';
  List<TabVillage> villages = [];
  List<TabState> states = [];
  List<TabDistrict> districts = [];
  List<TabBlock> blocks = [];
  List<TabGramPanchayat> gramPanchayats = [];
  List<ChildForAttendenceModel> attendecedRecord = [];
  DateTime? defaultMinDate;
  List<DateTime> dateList = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    userName = (await Validate().readString(Validate.userName))!;
    List<String> valueNames = [
      CustomText.Creches,
      CustomText.Next,
      CustomText.back,
      CustomText.ok,
      CustomText.exit,
      CustomText.childrenCountVallidattion,
      CustomText.select_here,
      CustomText.Yes,
      CustomText.No,
      CustomText.typehere,
      CustomText.dataSaveSuc,
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
      CustomText.leavingLesThanjoining
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

    attendecedRecord = await ChildAttendenceHelper()
        .callChildAttendencesByGuid(widget.ChildAttenGUID);

    await callScrenControllers();
    if (widget.tabIndex == (widget.totalTab - 1)) {
      saveNext = CustomText.saveEnrolled;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: WillPopScope(
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
                                  // if(widget.tabIndex == (widget.totalTab -1)){
                                  //   Navigator.pop(context, 'itemRefresh');
                                  // }else
                                  nextTab(0, context);
                                },
                                text: Global.returnTrLable(
                                        translats, CustomText.back, lng)
                                    .trim(),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Row(children: [
                            // SizedBox(width: 10),
                            // widget.tabIndex == (widget.totalTab - 1)
                            //     ? SizedBox()
                            //     : Expanded(
                            //         child: CElevatedButton(
                            //           color: Color(0xff5979AA),
                            //           onPressed: () {
                            //             saveOnly(1, context);
                            //             // widget.changeTab(1);
                            //           },
                            //           text: Global.returnTrLable(
                            //                   translats, 'Save', lng)
                            //               .trim(),
                            //         ),
                            //       ),
                            // ]
                            // ),
                            // widget.tabIndex == (widget.totalTab - 1)
                            //     ? SizedBox()
                            //     : SizedBox(width: 10),
                            // widget.tabIndex == (widget.totalTab - 1)
                            //     ? SizedBox()
                            //     :
                            Expanded(
                              child: CElevatedButton(
                                color: widget.tabIndex == (widget.totalTab - 1)
                                    ? Color(0xff5979AA)
                                    : Color(0xff369A8D),
                                onPressed: () {
                                  if (widget.tabIndex == (widget.totalTab - 1)) {
                                    Navigator.pop(
                                        context, CustomText.itemRefresh);
                                  }
                                  nextTab(1, context);
                                  // widget.changeTab(1);
                                },
                                text: Global.returnTrLable(
                                    translats,
                                    widget.tabIndex == (widget.totalTab - 1)
                                        ? CustomText.exit
                                        : CustomText.Next,
                                    lng),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
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
              : logic!.dependeOnMendotory(myMap, quesItem),
          items: items,
          selectedItem: myMap[quesItem.fieldname],
          readable: true,
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
        return CustomDatepickerDynamic(
          calenderValidate: [],
          initialvalue: myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          readable:
              quesItem.fieldname == 'date_of_attendance' ? true : recrdedUpload,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          minDate: AddAttendanceScreenFormTab.maxDate != null
              ? ((quesItem.fieldname == 'date_of_attendance')
                  ? AddAttendanceScreenFormTab.maxDate
                  : defaultMinDate)
              : defaultMinDate,
          maxDate: AddAttendanceScreenFormTab.minDate != null
              ? ((quesItem.fieldname == 'date_of_attendance')
                  ? AddAttendanceScreenFormTab.minDate
                  : defaultMinDate)
              : defaultMinDate,
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            var logData = logic!.callDateDiffrenceLogic(myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);
              }
            }
            setState(() {});
          },
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          // readable: logic!.callReadableLogic( myMap, quesItem),
          readable: true,
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
      case 'Int':
        return DynamicCustomTextFieldInt(
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          // readable: logic!.callReadableLogic( myMap, quesItem),
          readable: true,
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
      // case 'Check':
      //   return DynamicCustomCheckboxWithLabel(
      //     label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
      //     initialValue: myMap[quesItem.fieldname!],
      //     isVisible:
      //         logic!.callDependingLogic( myMap, quesItem),
      //     onChanged: (value) {
      //       myMap[quesItem.fieldname!] = value;
      //       setState(() {});
      //     },
      //   );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: translats,
          lng: lng,
          isRequred:
              (quesItem.fieldname == 'is_shishu_ghar_is_closed_for_the_day')
                  ? 1
                  : quesItem.reqd == 1
                      ? quesItem.reqd
                      : logic!.dependeOnMendotory(myMap, quesItem),
          // readable: logic!.callReadableLogic( myMap, quesItem),
          readable: true,
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            print('yesNo $value');
            myMap[quesItem.fieldname!] = value;
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
          // readable: logic!.callReadableLogic( myMap, quesItem),
          readable: true,
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
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          // readable: logic!.callReadableLogic( myMap, quesItem),
          readable: true,
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
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          // readable: logic!.callReadableLogic( myMap, quesItem),
          readable: true,
          initialvalue: myMap[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Time':
        return CustomTimepickerDynamic(
          initialvalue: myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          readable: true,
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            var logData = logic!.callDateDiffrenceLogic(myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);
                setState(() {});
              }
            }
          },
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
        );
      // case 'Long Text':
      //   return CustomImageDynamic(
      //     assetPath:myMap[quesItem.fieldname!],
      //     titleText:
      //     Global.returnTrLable(translats, quesItem.label!.trim(), lng),
      //     isRequred: quesItem.reqd,
      //     onChanged: (value) {
      //       print('Entered text: $value');
      //       myMap[quesItem.fieldname!] = value;
      //       setState(() {});
      //     },
      //   );
      default:
        return SizedBox();
    }
  }

  Future<void> callScrenControllers() async {
    var alredRecord =
        await CrecheDataHelper().getCrecheResponceItem(widget.creche_nameId!);
    Map<String, dynamic> responseData = {};
    if (alredRecord.isNotEmpty) {
      responseData = jsonDecode(alredRecord[0].responces!);
    }
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
        if (!(items[i].options == 'Child Attendance List')) {
          if ((items[i].options == 'State') ||
              (items[i].options == 'District') ||
              (items[i].options == 'Block') ||
              // (items[i].options == 'Creche') ||
              (items[i].options == 'Gram Panchayat') ||
              (items[i].options == 'Village') ||
              (items[i].options == 'Partner')) {
            if (items[i].options == 'Partner') {
              await OptionsModelHelper()
                  .getPartnerMstCommonOptions(
                      items[i].options!.trim(), responseData)
                  .then((data) {
                options.addAll(data);
              });
              defaultDisableDailog(items[i].fieldname!, items[i].options!);
              print(items[i].name);
            } //else updateLocationDropDown(items[i]);
            else {
              await OptionsModelHelper()
                  .getLocationData(items[i].options!.trim(), responseData, lng)
                  .then((data) {
                options.addAll(data);
              });
              defaultDisableDailog(items[i].fieldname!, items[i].options!);
            }
            // options.add(OptionsModel(
            // name: 'Creche', flag: 'tabCreche', values: widget.creche_name));
          } else {
            defaultCommon.add('tab${items[i].options!.trim()}');
          }
        } else {
          // defaultCommon.add('tab${items[i].options!.trim()}');
        }
      }
      logicFields.add(items[i].fieldname!);
    }

    await updateHiddenValue();
    // await callDatesList();
    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng)
        .then((data) {
      options.addAll(data);
    });

    await FormLogicDataHelper().callFormLogic('Child Attendance').then((data) {
      logics.addAll(data);
      logic = DependingLogic(translats, data, lng);
    });
  }

  Future<void> calinitialScreen() async {
    await callScrenControllers();
    setState(() {
      _isLoading = false;
    });
  }

  defaultDisableDailog(String fieldName, String flag) async {
    var tabName = 'tab$flag';
    var item = options.where((element) => element.flag == tabName).toList();
    if (item.length > 0) {
      myMap[fieldName] = item.first.name!;
    }
  }

  nextTab(int type, BuildContext mContext) async {
    bool status = false;
    var widgets = widget.screenItem[widget.tabBreakItem.name];
    List<TabFormsLogic> exitlogic = [];
    if (type == 1) {
      if (_checkValidation(mContext)) {
        if (widget.tabIndex < (widget.totalTab - 1)) {
          if (widgets != null) {
            Map<String, dynamic> responces = {};
            widgets.forEach((element) async {
              if (myMap[element.fieldname] != null) {
                responces[element.fieldname!] = myMap[element.fieldname];
              }
              exitlogic.addAll(logics
                  .where((logElement) =>
                      logElement.parentControl == element.fieldname &&
                      logElement.type_of_logic_id == '11')
                  .toList());
            });
          }
          bool status = checkExitStatus(exitlogic);
          if (status) {
            Navigator.pop(context, 'itemRefresh');
          }
        } else if (widget.tabIndex == (widget.totalTab - 1)) {
          Navigator.pop(context, 'itemRefresh');
        }
        widget.changeTab(type);
        setState(() {});
      }
      // widget.changeTab(type);
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
      if (_checkValidation(mContext)) {
        bool status = false;
        var widgets = widget.screenItem[widget.tabBreakItem.name];
        List<TabFormsLogic> exitlogic = [];
        if (widgets != null) {
          Map<String, dynamic> responces = {};
          widgets.forEach((element) async {
            if (myMap[element.fieldname] != null) {
              responces[element.fieldname!] = myMap[element.fieldname];
            }
            exitlogic.addAll(logics
                .where((logElement) =>
                    logElement.parentControl == element.fieldname &&
                    logElement.type_of_logic_id == '11')
                .toList());
          });
          var responcesJs = jsonEncode(myMap);
          var name = myMap['name'];
          var creche_id = Global.stringToInt(myMap['creche_id'].toString());
          print(responcesJs);
          var item = ChildAttendanceResponceModel(
            creche_id: creche_id,
            childattenguid: widget.ChildAttenGUID,
            name: name,
            is_uploaded: recrdedUpload ? 1 : 0,
            responces: responcesJs,
            is_edited: 1,
            is_deleted: 0,
            created_at: myMap['app_created_on'],
            created_by: myMap['app_created_by'],
            update_at: myMap['app_updated_on'],
            updated_by: myMap['app_updated_by'],
            date_of_attendance: myMap['date_of_attendance'],
          );
          await AttendanceResponnceHelper().inserts(item);
          await ChildAttendenceHelper().updateAttendenceHelper(
              widget.ChildAttenGUID, myMap['date_of_attendance']);
        }

        if (exitlogic.length > 0) {
          for (int i = 0; i < exitlogic.length; i++) {
            var element = exitlogic[i];
            if (element.type_of_logic_id == '11') {
              if (element.parentControl == element.dependentControls) {
                var validValu = Global.validNum(element.algorithmExpression);
                var parentValue = myMap[element.dependentControls];
                if ((Global.validNum(parentValue.toString()) == validValu)) {
                  status = true;
                  break;
                }
              }
            }
          }
        }
        if (status) {
          await saveDataForExit(
              myMap, widget.screenItem[widget.tabBreakItem.name]!);
        }
        bool shouldProceed = await showDialog(
          context: context,
          builder: (context) {
            return SingleButtonPopupDialog(
                message: Global.returnTrLable(
                    translats, CustomText.dataSaveSuc, lng),
                button: Global.returnTrLable(translats, CustomText.ok, lng));
          },
        );
        if (shouldProceed && status) {
          if (shouldProceed == true) {
            Navigator.pop(context, 'itemRefresh');
          }
        }
      }
    } else {
      if (widget.tabIndex == 0) {
        Navigator.pop(context, 'itemRefresh');
      } else {
        widget.changeTab(type);
      }
    }
  }

  bool checkExitStatus(List<TabFormsLogic> exitlogic) {
    bool status = false;
    if (exitlogic.length > 0) {
      for (int i = 0; i < exitlogic.length; i++) {
        var element = exitlogic[i];
        if (element.type_of_logic_id == '11') {
          if (element.parentControl == element.dependentControls) {
            var validValu = Global.validNum(element.algorithmExpression);
            var parentValue = myMap[element.dependentControls];
            if ((Global.validNum(parentValue.toString()) == validValu)) {
              status = true;
              break;
            }
          }
        }
      }
    }
    return status;
  }

  Future<bool> saveDataInData() async {
    bool status = false;
    var widgets = widget.screenItem[widget.tabBreakItem.name];
    List<TabFormsLogic> exitlogic = [];
    if (widgets != null) {
      Map<String, dynamic> responces = {};
      widgets.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
        exitlogic.addAll(logics
            .where((logElement) =>
                logElement.parentControl == element.fieldname &&
                logElement.type_of_logic_id == '11')
            .toList());
      });
      var responcesJs = jsonEncode(myMap);
      var name = myMap['name'];
      var creche_id = Global.stringToInt(myMap['creche_id'].toString());
      print(responcesJs);
      var item = ChildAttendanceResponceModel(
        creche_id: creche_id,
        childattenguid: widget.ChildAttenGUID,
        name: name,
        is_uploaded: recrdedUpload ? 1 : 0,
        responces: responcesJs,
        is_edited: 1,
        is_deleted: 0,
        created_at: myMap['app_created_on'],
        created_by: myMap['app_created_by'],
        update_at: myMap['app_updated_on'],
        updated_by: myMap['app_updated_by'],
        date_of_attendance: myMap['date_of_attendance'],
      );
      await AttendanceResponnceHelper().inserts(item);
      await ChildAttendenceHelper().updateAttendenceHelper(
          widget.ChildAttenGUID, myMap['date_of_attendance']);
    }

    if (exitlogic.length > 0) {
      for (int i = 0; i < exitlogic.length; i++) {
        var element = exitlogic[i];
        if (element.type_of_logic_id == '11') {
          if (element.parentControl == element.dependentControls) {
            var validValu = Global.validNum(element.algorithmExpression);
            var parentValue = myMap[element.dependentControls];
            if ((Global.validNum(parentValue.toString()) == validValu)) {
              status = true;
              break;
            }
          }
        }
      }
    }

    return status;
  }

  Future<void> saveDataForExit(Map<String, dynamic> currentAnswerd,
      List<HouseHoldFielItemdModel> items) async {
    Map<String, dynamic> attemptAnsForExit = {};
    items.forEach((element) {
      if (currentAnswerd[element.fieldname] != null) {
        attemptAnsForExit[element.fieldname!] =
            currentAnswerd[element.fieldname];
      }
    });
    List<String> remItem = [
      'partner_id',
      'state_id',
      'district_id',
      'gp_id',
      'village_id',
      'creche_id',
      'block_id'
    ];

    remItem.forEach((element) {
      if (currentAnswerd[element] != null) {
        attemptAnsForExit[element] = currentAnswerd[element];
      }
    });

    attemptAnsForExit['childattenguid'] = widget.ChildAttenGUID;
    attemptAnsForExit['creche_id'] = widget.creche_nameId;
    attemptAnsForExit['app_created_on'] = currentAnswerd['app_created_on'];
    attemptAnsForExit['app_created_by'] = currentAnswerd['app_created_by'];
    attemptAnsForExit['app_updated_on'] = currentAnswerd['app_updated_on'];
    attemptAnsForExit['app_updated_by'] = currentAnswerd['app_updated_by'];

    var date_of_attendance = currentAnswerd['date_of_attendance'];
    var name = currentAnswerd['name'];
    var creche_id = currentAnswerd['creche_id'];
    if (name != null) {
      attemptAnsForExit['name'] = name;
    }
    var responcesJs = jsonEncode(attemptAnsForExit);
    print(responcesJs);
    var item = ChildAttendanceResponceModel(
      creche_id: Global.stringToInt(creche_id.toString()),
      childattenguid: widget.ChildAttenGUID,
      name: name,
      is_uploaded: recrdedUpload ? 1 : 0,
      responces: responcesJs,
      is_edited: 1,
      is_deleted: 0,
      created_at: currentAnswerd['app_created_on'],
      created_by: currentAnswerd['app_created_by'],
      update_at: currentAnswerd['app_updated_on'],
      updated_by: currentAnswerd['app_updated_by'],
      date_of_attendance: currentAnswerd['date_of_attendance'],
    );
    await AttendanceResponnceHelper().inserts(item);
    await ChildAttendenceHelper()
        .deleteAttendeceBYGUID(widget.ChildAttenGUID, date_of_attendance);
  }

  bool _checkValidation(BuildContext mContext) {
    var validStatus = true;
    var items = widget.screenItem[widget.tabBreakItem.name];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        var element = items[i];
        if (element.reqd == 1 ||
            element.fieldname == 'is_shishu_ghar_is_closed_for_the_day') {
          var valuees = myMap[element.fieldname];
          if (!Global.validString(valuees.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(translats, CustomText.plsFilManForm, lng),
                Global.returnTrLable(translats, CustomText.ok, lng),
                false,
                mContext);
            validStatus = false;
            break;
          }
        }
        var validationMsgother = otherTableDependCotrol(logics, myMap, element);
        var validationMsg = logic!.validationMessge(myMap, element);
        if (Global.validString(validationMsg) ||
            Global.validString(validationMsgother)) {
          if (Global.validString(validationMsg)) {
            Validate().singleButtonPopup(
                validationMsg!, Global.returnTrLable(translats, CustomText.ok, lng), false, mContext);
          } else {
            Validate().singleButtonPopup(
                validationMsgother!, Global.returnTrLable(translats, CustomText.ok, lng), false, mContext);
          }
          validStatus = false;
          break;
        }
      }
      ;
    } else {
      print("selected items is null");
    }

    return validStatus;
  }

  Future<void> updateHiddenValue() async {
    var alredRecord = await AttendanceResponnceHelper()
        .callChildrenResponce(widget.ChildAttenGUID);

    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData.forEach((key, value) {
        myMap[key] = value;
      });
      myMap['app_updated_on'] = Validate().currentDateTime();
      myMap['app_updated_by'] = userName;

      if (alredRecord[0].name != null) {
        myMap['name'] = alredRecord[0].name;
      }
    } else {
      var creCheDetails =
          await CrecheDataHelper().getCrecheResponceItem(widget.creche_nameId!);
      // List<HouseHoldFielItemdModel> items =
      //     widget.screenItem[widget.tabBreakItem.name!]!;
      // var checkItem =
      //     items.where((element) => element.fieldtype == 'Check').toList();
      // checkItem.forEach((element) {
      //   myMap[element.fieldname!] = 0;
      // });
      myMap['app_created_by'] = userName;
      myMap['app_created_on'] = Validate().currentDateTime();
      if (creCheDetails.length > 0) {
        myMap['childattenguid'] = widget.ChildAttenGUID;
        myMap['creche_id'] = widget.creche_nameId;
        myMap['partner_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'partner_id');
        myMap['state_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'state_id');
        myMap['district_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'district_id');
        myMap['block_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'block_id');
        myMap['gp_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'gp_id');
        myMap['village_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'village_id');
        myMap['date_of_attendance'] = Global.initCurrentDate();
      }
    }
  }

  String? otherTableDependCotrol(List<TabFormsLogic> logics,
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    String? retuenValu;
    var parentQlogic = logics
        .where((element) =>
            element.dependentControls.contains(parentItem.fieldname!) &&
            (element.type_of_logic_id == '10'))
        .toList();

    var attendeceChild =
        attendecedRecord.where((element) => element.attendance == 1).toList();

    if (parentQlogic.length > 0) {
      for (int i = 0; i < parentQlogic.length; i++) {
        var element = parentQlogic[i];
        if (element.type_of_logic_id == '10') {
          if (element.parentControl == element.dependentControls) {
            var validValu = Global.splitData(element.algorithmExpression, ",");
            if (validValu.length == 3) {
              var expression = validValu[1];
              if (expression == '<=') {
                var dependValu = answred[element.dependentControls];
                if (dependValu != null) {
                  if (!(Global.validNum(dependValu.toString()) <=
                      attendeceChild.length)) {
                    retuenValu = Global.returnTrLable(
                        translats, CustomText.childrenCountVallidattion, lng);
                    break;
                  }
                }
              }
            }
          }
        }
      }
    }

    return retuenValu;
  }

  // Future<void> callDatesList() async {
  //   var cItem = myMap['date_of_attendance'];
  //   var data = await ChildAttendanceResponceHelper()
  //       .callMaxChilsAttendanceAllResponces(widget.creche_nameId);
  //   if(data.length!=0){
  //   List<String> dateStringData = [];
  //   data.forEach((element) {
  //     dateStringData
  //         .add(Global.getItemValues(element.responces!, 'date_of_attendance'));
  //   });
  //   dateList = dateStringData.map((dateString) {
  //     List<int> dateParts = dateString.split('-').map(int.parse).toList();
  //     return DateTime(dateParts[0], dateParts[1], dateParts[2]);
  //   }).toList();
  //   maxDate = dateList
  //       .reduce((value, element) => value.isAfter(element) ? value : element);
  //   maDateString =
  //   '${maxDate!.year}-${maxDate!.month.toString().padLeft(2, '0')}-${maxDate!
  //       .day.toString().padLeft(2, '0')}';
  //   print(maDateString);
  //   if (cItem == maDateString) {
  //     dateList.remove(maxDate);
  //     maxDate = dateList
  //         .reduce((value, element) => value.isAfter(element) ? value : element);
  //     maDateString = '${maxDate!.year}-${maxDate!.month}-${maxDate!.day}';
  //   }
  //   }else maxDate=null;
  //   print(maDateString);
  //   setState(() {});
  // }
}
