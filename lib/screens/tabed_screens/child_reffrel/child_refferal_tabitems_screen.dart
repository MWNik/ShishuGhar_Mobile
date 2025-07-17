import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shishughar/database/helper/child_reffrel/child_refferal_fields_helper.dart';
import 'package:shishughar/database/helper/creche_helper/creche_data_helper.dart';
import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamin_multi_check_screen.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
import '../../../database/helper/backdated_configiration_helper.dart';
import '../../../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/follow_up/child_followUp_response_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/backdated_configiration_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class ChildReferralTabItemsScreen extends StatefulWidget {
  final String child_referral_guid;
  final String GrowthMonitoringGUID;
  final String enrollDate;
  final String ChildDOB;
  final int creche_id;
  final int? child_id;
  final String enrolChildGuid;
  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;
  final bool isDischarge;
  final String scheduleDate;
  final DateTime? minDate;
  final bool isEditable;
  final bool isEditableForDischage;



  const ChildReferralTabItemsScreen(
      {super.key,
      required this.child_referral_guid,
      required this.GrowthMonitoringGUID,
      required this.enrollDate,
      required this.ChildDOB,
      required this.creche_id,
      required this.child_id,
      required this.enrolChildGuid,
      required this.tabBreakItem,
      required this.screenItem,
      required this.changeTab,
      required this.tabIndex,
      required this.totalTab,
      required this.isDischarge,
      required this.scheduleDate,
      required this.isEditable,
      required this.isEditableForDischage,
      required this.minDate});

  @override
  State<ChildReferralTabItemsScreen> createState() =>
      _ChildFollowUpTabItemSCreenState();
}

class _ChildFollowUpTabItemSCreenState
    extends State<ChildReferralTabItemsScreen> {
  List<OptionsModel> options = [];
  DependingLogic? logic;
  List<TabFormsLogic> logics = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translats = [];
  String userName = '';
  DateTime? enrolldDate;
  String lng = 'eng';
  String? role;
  bool _isLoading = true;
  String? saveNext = CustomText.Next;
  String? childStatus;
  List<HouseHoldFielItemdModel> multselectItemTab = [];
  BackdatedConfigirationModel? backdatedConfigirationModel;


  // bool reffrralDateRedable = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    enrolldDate = DateTime.parse(widget.enrollDate).subtract(Duration(days: 1));
    role = await Validate().readString(Validate.role);
    userName = (await Validate().readString(Validate.userName))!;

    backdatedConfigirationModel = await BackdatedConfigirationHelper()
        .excuteBackdatedConfigirationModel(CustomText.childReferral);

    List<String> valueNames = [
      CustomText.Creches,
      CustomText.Next,
      CustomText.back,
      CustomText.ok,
      CustomText.childrenCountVallidattion,
      CustomText.Submit,
      CustomText.Save,
      CustomText.dataSaveSuc,
      CustomText.plsFilManForm,
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
      CustomText.leavingLesThanjoining
    ];
    List<HouseHoldFielItemdModel> items =
        widget.screenItem[widget.tabBreakItem.name!]!;
    items.forEach((element) {
      if (Global.validString(element.label)) {
        valueNames.add(element.label!.trim());
      }
    });

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats.addAll(value));

    multselectItemTab =
        await ChildReferralFieldsHelper().callMultiSelectTabItem();
    await updateHiddenValue();
    // await callReffralDateReadable();
    await callScrenControllers('Child Referral');
    if (widget.tabIndex == (widget.totalTab - 1)) {
      saveNext = CustomText.saveEnrolled;
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
              body: Column(children: [
                Divider(),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                  child: Row(children: [
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
                    SizedBox(width: 10),
                    role == 'Creche Supervisor'
                        ? widget.tabIndex == (widget.totalTab - 1)
                            ? SizedBox()
                            : Expanded(
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
                        : SizedBox(),
                    // ]
                    // ),
                    role == 'Creche Supervisor'
                        ? widget.tabIndex == (widget.totalTab - 1)
                            ? SizedBox()
                            : SizedBox(width: 10)
                        : SizedBox(),
                    Expanded(
                      child: CElevatedButton(
                        color: Color(0xff369A8D),
                        onPressed: () {
                          nextTab(1, context);
                          // widget.changeTab(1);
                        },
                        text: widget.tabIndex == (widget.totalTab - 1)
                            ? (Global.returnTrLable(
                                translats, CustomText.Submit, lng))
                            : Global.returnTrLable(
                                translats, CustomText.Next, lng),
                      ),
                    ),
                  ]),
                )
              ]),
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
        callAutoGeneratedOtherTable(myMap, items[i]);
        if (!logic!.callDependingLogic(myMap, items[i])) {
          myMap.remove(items[i].fieldname);
        } else
          screenItems.add(SizedBox(height: 5.h));
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
        if (quesItem.fieldname == 'child_status' &&
            childStatus == '1' &&
            !widget.isEditable &&
            widget.isEditableForDischage) {

       items = items
              .where((element) => (element.name=='2' || element.name=='1'))
              .toList();
        }
        if (items.length == 1) {
          myMap[quesItem.fieldname!] = items.first.name;
        }

        return DynamicCustomDropdownField(
          hintText:
              Global.returnTrLable(translats, CustomText.select_here, lng),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          readable: (quesItem.fieldname == 'child_status')
              ? widget.isEditableForDischage
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
              : widget.isEditable
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true,
          items: items,
          selectedItem: myMap[quesItem.fieldname],
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            if (value != null) {
                myMap[quesItem.fieldname!] = value.name!;
            } else
              myMap.remove(quesItem.fieldname);
            setState(() {});
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
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          selectedItem: myMap[quesItem.fieldname],
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          readable: widget.isEditable
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          responceFieldName: itemResopnceField,
          onChanged: (value) {
            if (value != null)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);

            setState(() {});
          },
        );
      case 'Date':
        return CustomDatepickerDynamic(
          initialvalue: myMap[quesItem.fieldname!],
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          fieldName: quesItem.fieldname,
          minDate: callRequredMinimumDate(quesItem.fieldname!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          // readable: (quesItem.fieldname == 'date_of_referral' ||
          readable: (quesItem.fieldname == 'discharge_date')
              ? widget.isEditableForDischage
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
              : widget.isEditable
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true,
          calenderValidate: logic!.calenderValidation(myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            callAutoGeneratedOtherTable(myMap, quesItem);
            var logData = logic!.callDateDiffrenceLogic(myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
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
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          maxline: (quesItem.length != 0) ? quesItem.length! % 35 : 1,
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          readable: widget.isEditable
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
      case 'Int':
        return DynamicCustomTextFieldInt(
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          readable: widget.isEditable
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
            }
          },
        );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: translats,
          lng: lng,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          readable: widget.isEditable
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
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
          readable: widget.isEditable
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
          readable: widget.isEditable
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
          readable: widget.isEditable
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
        return DynamicCustomTextFieldFloat(
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          fieldName: quesItem.fieldname!,
          initialvalue: myMap[quesItem.fieldname!],
          readable: (quesItem.fieldname == 'weight_on_discharge')
              ? widget.isEditableForDischage
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
              : widget.isEditable
                  ? logic!.callReadableLogic(myMap, quesItem)
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

                  // setState(() {});
                }
              }
            } else {
              myMap.remove(quesItem.fieldname);
            }
          },
        );
      default:
        return SizedBox();
    }
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
        }
        var validationMsg = logic!.validationMessge(myMap, element);
        if (Global.validString(validationMsg)) {
          Validate().singleButtonPopup(
              validationMsg!,
              Global.returnTrLable(translats, CustomText.ok, lng),
              false,
              context);
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

  saveOnly(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        await callFolloupData();
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

  Future<void> saveDataInData(int visitCount) async {
    var widgets = widget.screenItem[widget.tabBreakItem.name];
    if (widgets != null) {
      Map<String, dynamic> responces = {};
      widgets.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
      });
      var responcesJs = jsonEncode(myMap);
      var name = myMap['name'];
      print(responcesJs);
      await ChildReferralTabResponseHelper().insertUpdate(
          widget.child_referral_guid,
          widget.enrolChildGuid,
          myMap['date_of_referral'],
          name as int?,
          widget.creche_id,
          visitCount,
          myMap['schedule_date'],
          responcesJs,
          userName,
          myMap['app_updated_by'],
          widget.GrowthMonitoringGUID,
          myMap['appcreated_on'],
          myMap['app_updated_on']);

      // if(!reffrralDateRedable){
      //   await ChildFollowUpTabResponseHelper()
      //       .deleteFollowUpBYReffreral(widget.child_referral_guid,widget.enrolChildGuid);
      // }
    }
  }

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        if (widget.tabIndex < (widget.totalTab - 1)) {
          await callFolloupData();
        } else if (widget.tabIndex == (widget.totalTab - 1)) {
          await callFolloupData();
          bool shouldProceed = await showDialog(
            context: context,
            builder: (context) {
              return SingleButtonPopupDialog(
                  message: Global.returnTrLable(
                      translats, CustomText.dataSaveSuc, lng),
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

  Future<void> callScrenControllers(screen_type) async {
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    var alredRecord =
        await CrecheDataHelper().getCrecheResponceItem(widget.creche_id);
    Map<String, dynamic> responseData = {};
    if (alredRecord.isNotEmpty) {
      responseData = jsonDecode(alredRecord[0].responces!);
    }
    List<HouseHoldFielItemdModel> items =
        widget.screenItem[widget.tabBreakItem.name!]!;
    List<String> defaultCommon = [];
    List<String> logicFields = [];
    for (int i = 0; i < items.length; i++) {
      if (Global.validString(items[i].options)) {
        if ((items[i].options == 'State') ||
            (items[i].options == 'District') ||
            (items[i].options == 'Block') ||
            (items[i].options == 'Creche') ||
            (items[i].options == 'Gram Panchayat') ||
            (items[i].options == 'Village') ||
            (items[i].options == 'Partner')) {
          if (items[i].options == 'Creche') {
            await OptionsModelHelper()
                .callCrechInOptionID(items[i].options!.trim(), widget.creche_id)
                .then((data) {
              options.addAll(data);
            });
            defaultDisableDailog(items[i].fieldname!, items[i].options!);
          } else if (items[i].options == 'Partner') {
            await OptionsModelHelper()
                .getPartnerMstCommonOptions(
                    items[i].options!.trim(), responseData)
                .then((data) {
              options.addAll(data);
            });
            defaultDisableDailog(items[i].fieldname!, items[i].options!);
          } else {
            await OptionsModelHelper()
                .getLocationData(items[i].options!.trim(), responseData, lng)
                .then((data) {
              options.addAll(data);
            });
          }
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
      logics = data;
      logic = DependingLogic(translats, data, lng);
    });
  }

  defaultDisableDailog(String fieldName, String flag) async {
    var tabName = 'tab$flag';
    var item = options.where((element) => element.flag == tabName).toList();
    if (item.length > 0) {
      myMap[fieldName] = item.first.name!;
    }
  }

  Future<void> updateHiddenValue() async {
    var alredRecord = await ChildReferralTabResponseHelper()
        .getChildReferralResponcewithGuid(widget.child_referral_guid);
    if (alredRecord.isNotEmpty) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData.forEach((key, value) {
        myMap[key] = value;
      });
      if (responseData['appcreated_on'] != null ||
          responseData['appcreated_by'] != null) {
        myMap['app_updated_on'] = Validate().currentDateTime();
        myMap['app_updated_by'] = userName;
      } else {
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
      }
      childStatus=myMap['child_status'].toString();
      var name = alredRecord[0].name;
      if (name != null) {
        myMap['name'] = name;
      }
    } else {
      var crecheDetails =
          await CrecheDataHelper().getCrecheResponceItem(widget.creche_id);
      if (crecheDetails.length > 0) {
        myMap['childenrolledguid'] = widget.enrolChildGuid;
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
        myMap['child_id'] = widget.child_id.toString();
        myMap['creche_id'] = widget.creche_id.toString();
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
        myMap['partner_id'] =
            Global.getItemValues(crecheDetails[0].responces!, 'partner_id');
        myMap['state_id'] =
            Global.getItemValues(crecheDetails[0].responces!, 'state_id');
        myMap['district_id'] =
            Global.getItemValues(crecheDetails[0].responces!, 'district_id');
        myMap['block_id'] =
            Global.getItemValues(crecheDetails[0].responces!, 'block_id');
        myMap['gp_id'] =
            Global.getItemValues(crecheDetails[0].responces!, 'gp_id');
        myMap['village_id'] =
            Global.getItemValues(crecheDetails[0].responces!, 'village_id');
        myMap['child_status'] = '4';
        myMap['date_of_referral'] = widget.scheduleDate;
        myMap['schedule_date'] = widget.scheduleDate;
      }
    }
    myMap['cgmguid'] = widget.GrowthMonitoringGUID;
    myMap['child_referral_guid'] = widget.child_referral_guid;
  }

  callAutoGeneratedOtherTable(
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    var parentQlogic = logics
        .where((element) =>
            element.dependentControls == parentItem.fieldname &&
            (element.type_of_logic_id == '21'))
        .toList();
    if (parentQlogic.length > 0) {
      for (int i = 0; i < parentQlogic.length; i++) {
        var element = parentQlogic[i];
        if (element.type_of_logic_id == '21') {
          var algoData = Global.splitData(element.algorithmExpression, ",");
          if (algoData.length == 3) {
            if (algoData[2] == 'child_dob') {
              var dependValue = answred[element.dependentControls];
              if (dependValue != null) {
                var dateDob = Validate().stringToDate(widget.ChildDOB);
                var dependDate = Validate().stringToDate(dependValue!);
                int? calucalteDate;
                if (algoData[1].toLowerCase() == 'm')
                  calucalteDate = Validate()
                      .calculateAgeInMonthsDepenExp(dateDob, dependDate);
                else if (algoData[1].toLowerCase() == 'y')
                  calucalteDate = Validate()
                      .calculateAgeInYearDepenExp(dateDob, dependDate);
                else if (algoData[1].toLowerCase() == 'd')
                  calucalteDate =
                      Validate().calculateAgeInDaysEx(dateDob, dependDate);
                myMap[element.parentControl] = calucalteDate;
                break;
              }
            }
          }
        }
      }
    }
  }

  // Future callReffralDateReadable() async {
  //   var items=await ChildFollowUpTabResponseHelper()
  //       .getFollowUpesponsebyReffreral(widget.child_referral_guid,widget.enrolChildGuid);
  //   if(items.length>0){
  //     reffrralDateRedable=true;
  //   }
  // }

  DateTime callRequredMinimumDate(String fieldname) {
    DateTime minimumDate = widget.minDate ?? DateTime(1992);
    if (fieldname == 'visit_date') {
      if (Global.validString(myMap['date_of_referral'])) {
        List<int> parts = myMap['date_of_referral']
            .toString()
            .split('-')
            .map(int.parse)
            .toList();
        minimumDate =
            DateTime(parts[0], parts[1], parts[2]).subtract(Duration(days: 1));
      }
    } else if (fieldname == 'admission_date') {
      if (myMap['visit_date'] != null) {
        List<int> parts =
            myMap['visit_date'].toString().split('-').map(int.parse).toList();
        minimumDate =
            DateTime(parts[0], parts[1], parts[2]).subtract(Duration(days: 1));
      }
    } else if (fieldname == 'discharge_date') {
      if (myMap['admission_date'] != null) {
        List<int> parts = myMap['admission_date']
            .toString()
            .split('-')
            .map(int.parse)
            .toList();
        minimumDate =
            DateTime(parts[0], parts[1], parts[2]).subtract(Duration(days: 1));
      }
    } else if (fieldname == 'date_of_referral') {
      // var cDate = Global.validString(myMap['date_of_referral'])?DateTime.parse(myMap['date_of_referral']):DateTime.parse(Validate().currentDate());
      var cDate = DateTime.parse(Validate().currentDate());
      var minDate = Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0?cDate.subtract(Duration(days: backdatedConfigirationModel!.back_dated_data_entry_allowed!)):cDate;
      List<int> parts =
          widget.scheduleDate.toString().split('-').map(int.parse).toList();
      var setDate = DateTime(parts[0], parts[1], parts[2]);
      if (setDate.isBefore(minDate)) {
        minimumDate = minDate;
      } else {
        minimumDate = setDate.subtract(Duration(days: 1));
      }
    }
    return minimumDate;
  }

  Future callFolloupData() async {
    int visitCount = 0;
    var reffreItems = await ChildFollowUpTabResponseHelper()
        .checkReffralCounts(widget.enrolChildGuid, widget.child_referral_guid);
    if (reffreItems.length == 0) {
      visitCount = await fetchFollowUpListByAnthro();
      myMap['visit_count'] = visitCount;
    }
    saveDataInData(visitCount);
  }

  Future<int> fetchFollowUpListByAnthro() async {
    int visitCount = 0;
    DateTime? followUpGenratedDate;
    var childAnthroDDetails = await ChildGrowthResponseHelper()
        .callAnthropometryByGuid(widget.GrowthMonitoringGUID);
    if (childAnthroDDetails.length > 0) {
      var lastAntroRecord = await ChildGrowthResponseHelper().lastAnthroRecord(
          widget.enrolChildGuid, childAnthroDDetails.first.measurement_date!);
      Map<String, dynamic> lastGrowhthDetails = {};
      if (lastAntroRecord.length > 0) {
        Map<String, dynamic> lastGrowthRec =
            jsonDecode(lastAntroRecord.first.responces!);
        var lastdChild = lastGrowthRec['anthropromatic_details'];
        if (lastdChild != null) {
          var child = lastdChild
              .where((element) =>
                  element['childenrollguid'] == widget.enrolChildGuid)
              .toList();
          if (child.length > 0) {
            lastGrowhthDetails = child.first;
          }
        }
      }

      Map<String, dynamic> growhthDetails = {};
      Map<String, dynamic> responseData =
          jsonDecode(childAnthroDDetails.first.responces!);
      var childs = responseData['anthropromatic_details'];
      if (childs != null) {
        var child = childs
            .where((element) =>
                element['childenrollguid'] == widget.enrolChildGuid)
            .toList();
        if (child.length > 0) {
          growhthDetails = child.first;
        }
      }

      if (!(myMap['child_status'] == '1' || myMap['child_status'] == '2') &&
          !Global.validString(myMap['discharge_date'])) {
        followUpGenratedDate = Validate().stringToDate(myMap['visit_date']);
      } else if (Global.validString(myMap['discharge_date'])) {
        followUpGenratedDate = Validate().stringToDate(myMap['discharge_date']);
      }

      if (followUpGenratedDate != null) {
        if (growhthDetails.isNotEmpty &&
            Global.stringToIntNull(
                    growhthDetails['do_you_have_height_weight'].toString()) ==
                1) {
          if (Global.stringToInt(
                  growhthDetails['any_medical_major_illness'].toString()) ==
              1) {
            //medical  is yes
            DateTime folloupDate = followUpGenratedDate.add(Duration(days: 7));
            await ChildFollowUpTabResponseHelper().autoCreateFollowRecord(
                '${DateFormat('yyyy-MM-dd').format(folloupDate)}',
                widget.child_referral_guid,
                widget.enrolChildGuid,
                widget.creche_id,
                userName);
            visitCount = 3;
          } else if (Global.stringToDouble(
                      growhthDetails['weight_for_height'].toString()) ==
                  1
              // || Global.stringToDouble(
              //         growhthDetails['weight_for_height'].toString()) ==
              //     2
              ) {
            DateTime folloupDate =
                followUpGenratedDate.add(Duration(days: 15));
            await ChildFollowUpTabResponseHelper().autoCreateFollowRecord(
                '${DateFormat('yyyy-MM-dd').format(folloupDate)}',
                widget.child_referral_guid,
                widget.enrolChildGuid,
                widget.creche_id,
                userName);
            visitCount = 2;
          }

          /// SAM/MAM  weight_for_height   red and yellow
          else if (lastGrowhthDetails.isNotEmpty &&
              (Global.stringToDouble(lastGrowhthDetails['weight'].toString()) ==
                  Global.stringToDouble(growhthDetails['weight'].toString()))) {
            DateTime folloupDate =
                followUpGenratedDate.add(Duration(days: 15));
            await ChildFollowUpTabResponseHelper().autoCreateFollowRecord(
                '${DateFormat('yyyy-MM-dd').format(folloupDate)}',
                widget.child_referral_guid,
                widget.enrolChildGuid,
                widget.creche_id,
                userName);
            visitCount = 2;
          } else if (Global.stringToDouble(
                  growhthDetails['weight_for_age'].toString()) ==
              1) {
            //SUW  weight_for_age  red
            DateTime folloupDate =
                followUpGenratedDate.add(Duration(days: 15));
            await ChildFollowUpTabResponseHelper().autoCreateFollowRecord(
                '${DateFormat('yyyy-MM-dd').format(folloupDate)}',
                widget.child_referral_guid,
                widget.enrolChildGuid,
                widget.creche_id,
                userName);
            visitCount = 1;
          }
        }
      }
      print('growth $growhthDetails');
    }
    return visitCount;
  }
}
