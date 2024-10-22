import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/customdatepicker.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_dynamic_image.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamin_multi_check_screen.dart';
import 'package:shishughar/custom_widget/single_poup_dailog.dart';
import 'package:shishughar/database/helper/child_reffrel/child_refferal_response_helper.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/enrolled_children/enrolled_children_field_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_children_field_helper.dart';
import 'package:shishughar/database/helper/form_logic_helper.dart';
import 'package:shishughar/database/helper/image_file_tab_responce_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/tab_image_file_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/depending_logic.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

class ExitEnrolledDetailsScreen extends StatefulWidget {
  final String CHHGUID;
  final String HHGUID;
  final String EnrolledChilGUID;
  final int HHname;
  final int crecheId;
  final int isNew;
  // static String? childName;
  final String? childName;
  final bool isImageUpdate;
  final bool isEditable;
  String? minDate;
  final bool isForExit;

  ExitEnrolledDetailsScreen(
      {super.key,
      required this.CHHGUID,
      required this.HHGUID,
      required this.HHname,
      required this.crecheId,
      required this.EnrolledChilGUID,
      required this.isNew,
      required this.isImageUpdate,
      required this.isEditable,
      this.minDate,
      this.childName,
      required this.isForExit});

  @override
  State<ExitEnrolledDetailsScreen> createState() =>
      _ExitEnrolledDetailsScreenState();
}

class _ExitEnrolledDetailsScreenState extends State<ExitEnrolledDetailsScreen> {
  bool _isLoading = true;
  List<HouseHoldFielItemdModel> allItems = [];
  List<OptionsModel> options = [];
  List<TabFormsLogic> logics = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translatsLabel = [];
  void Function()? ontap;
  String lng = "en";
  String? role;
  String? userName;
  List<HouseHoldFielItemdModel> multselectItemTab = [];
  List<String> locationItem = [
    'creche_geography_tab',
    'partner_id',
    'state_id',
    'district_id',
    'block_id',
    'gp_id',
    'village_id'
  ];
  DateTime? minDateforExit;
  bool shouldEditMesure = false;
  List<String> redableItemsData = [
    'child_id',
    'child_name',
  ];
  List<String> redableItemsDate = ['child_dob', 'date_of_enrollment'];
  List<String> redableItemsFloat = [
    'height',
    'weight',
  ];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    role = (await Validate().readString(Validate.role))!;
    userName = (await Validate().readString(Validate.userName))!;
    translatsLabel.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translatsLabel = value);

    await TranslationDataHelper()
        .callTranslateEnrolledChildren()
        .then((value) => translatsLabel.addAll(value));

    multselectItemTab =
        await EnrolledChildrenFieldHelper().callMultiSelectTabItem();
    await updateHiddenValues();
    await callScrenControllers();
  }

  Future<void> callScrenControllers() async {
    // List<HouseHoldFielItemdModel> allItems = [];
    await EnrolledExitChildrenFieldHelper()
        .callExitEnrolled()
        .then((value) async {
      allItems = value
          .where((element) =>
              !(locationItem.contains(element.fieldname)) &&
              element.hidden == 0)
          .toList();
    });
    List<HouseHoldFielItemdModel> items = allItems;
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
    await FormLogicDataHelper()
        .callFormLogic('Child Enrollment and Exit')
        .then((data) {
      logics.addAll(data);
    });
    await FormLogicDataHelper().callFormLogic('Child Profile').then((data) {
      logics.addAll(data);
    });
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

  bool _checkValidation() {
    var validStatus = true;
    var items = allItems;
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        var element = items[i];
        if (element.reqd == 1) {
          var valuees = myMap[element.fieldname];
          if (!Global.validString(valuees.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(
                    translatsLabel, CustomText.plsFilManForm, lng),
                CustomText.ok,
                false,
                context);
            validStatus = false;
            break;
          }
        } else if (element.fieldname == "reason_for_exit") {
          var valuess = myMap[element.fieldname];
          if (!Global.validString(valuess.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(
                    translatsLabel, CustomText.plsFilManForm, lng),
                CustomText.ok,
                false,
                context);
            validStatus = false;
            break;
          }
        }
        var validationMsg =
            DependingLogic().validationMessge(logics, myMap, element);
        if (Global.validString(validationMsg)) {
          if ((Global.validString(myMap['reason_for_exit'].toString()) &&
              element.fieldname == 'age_at_enrollment_in_months')) {
            validStatus = true;
          } else {
            Validate().singleButtonPopup(
                validationMsg!, CustomText.ok, false, context);
            validStatus = false;
            break;
          }
        }
      }
      ;
    } else {
      print("selected items is null");
    }

    return validStatus;
  }

  Future<void> updateHiddenValues() async {
    var alrecords = await EnrolledExitChilrenResponceHelper()
        .callChildrenResponce(widget.EnrolledChilGUID);
    if (alrecords.isNotEmpty) {
      Map<String, dynamic> responseData = jsonDecode(alrecords[0].responces!);
      responseData.forEach((key, value) {
        myMap[key] = value;
      });
      myMap['date_of_exit'] = Validate().currentDate();
      if (responseData['appcreated_on'] != null ||
          responseData['appcreated_by'] != null) {
        myMap['app_updated_on'] = Validate().currentDateTime();
        myMap['app_updated_by'] = userName;
      } else {
        myMap['appcreated_on'] = Validate().currentDateTime();
        myMap['appcreated_by'] = userName;
      }
      if (Global.validString(myMap['date_of_enrollment'])) {
        var parts = myMap['date_of_enrollment']
            .toString()
            .split('-')
            .map(int.parse)
            .toList();
        minDateforExit = DateTime(parts[0], parts[1], parts[2]);
      }
      if (!Global.validString(myMap['date_of_enrollment_awc'])) {
        myMap['date_of_enrollment_awc'] = Global.initCurrentDate();
      }
      var name = alrecords[0].name;
      if (name != null) {
        myMap['name'] = name;
      }
      if (alrecords.first.is_edited == 0) {
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
  }

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          titleText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : (quesItem.fieldname == 'reason_for_exit'
                  ? 1
                  : DependingLogic()
                      .dependeOnMendotory(logics, myMap, quesItem)),
          items: items,
          readable: widget.isEditable == true ? null : true,
          selectedItem: myMap[quesItem.fieldname],
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
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
        if (quesItem.fieldname == 'date_of_enrollment') {
          if (Global.validString(widget.minDate)) {
            minDate =
                DateTime.parse(widget.minDate!).subtract(Duration(days: 1));
          }
        } else if (quesItem.fieldname == 'date_of_exit') {
          minDate = minDateforExit;
        }
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
                      : DependingLogic()
                          .callReadableLogic(logics, myMap, quesItem))
                  : DependingLogic().callReadableLogic(logics, myMap, quesItem))
              : true,
          // minDate: quesItem.fieldname == 'date_of_enrollment'
          //     ? Global.validString(widget.minDate)
          //         ? DateTime.parse(widget.minDate!).subtract(Duration(days: 1))
          //         : null
          //     : null,
          minDate: minDate,
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          calenderValidate:
              DependingLogic().calenderValidation(logics, myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;

            var logData = DependingLogic()
                .callDateDiffrenceLogic(logics, myMap, quesItem);
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
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname],
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
          maxlength: quesItem.length,
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!, logics),
          readable: widget.isEditable == true
              ? (widget.isForExit
                  ? redableItemsData.contains(quesItem.fieldname)
                      ? true
                      : DependingLogic()
                          .callReadableLogic(logics, myMap, quesItem)
                  : DependingLogic().callReadableLogic(logics, myMap, quesItem))
              : true,
          hintText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          readable: widget.isEditable == true
              ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
              : true,
          titleText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              myMap[quesItem.fieldname!] = value;
              var logData = DependingLogic()
                  .callAutoGeneratedValue(logics, myMap, quesItem);
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
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          titleText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
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
      //     label: Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
      //     initialValue: myMap[quesItem.fieldname!],
      //     isVisible: DependingLogic().callDependingLogic(logics,myMap,quesItem),
      //     onChanged: (value) {
      //       if(value>0)
      //         myMap[quesItem.fieldname!] = value;
      //       else myMap.remove(quesItem.fieldname);
      //       setState(() {});
      //     },
      //   );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: translatsLabel,
          lng: lng,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          readable: widget.isEditable == true
              ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
              : true,
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            print('yesNo $value');
            myMap[quesItem.fieldname!] = value;
            if (myMap['child_specially_abled'] == 0) {
              myMap['specially_abled_option'] = [];
            }
            setState(() {});
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          maxline: 3,
          titleText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: widget.isEditable == true
              ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
              : true,
          hintText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
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
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          readable: widget.isEditable == true
              ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
              : true,
          titleText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
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
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          readable: widget.isEditable == true
              ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
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
          titleText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd,
          maxlength: quesItem.length,
          fieldName: quesItem.fieldname!,
          initialvalue: myMap[quesItem.fieldname!],
          readable: widget.isEditable == true
              ? (quesItem.fieldname == 'height' ||
                      quesItem.fieldname == 'weight'
                  ? (widget.isForExit
                      ? (redableItemsFloat.contains(quesItem.fieldname)
                          ? true
                          : false)
                      : shouldEditMesure)
                  : DependingLogic().callReadableLogic(logics, myMap, quesItem))
              : true,
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              myMap[quesItem.fieldname!] = value;
              var logData = DependingLogic()
                  .callAutoGeneratedValue(logics, myMap, quesItem);
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
      case 'Attach':
        return CustomImageDynamic(
          child_guid: widget.EnrolledChilGUID,
          assetPath: myMap[quesItem.fieldname!],
          readable: widget.isEditable == true ? widget.isImageUpdate : true,
          titleText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
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

  List<Widget> cWidget() {
    List<Widget> screenItems = [];
    var items = allItems;
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        screenItems.add(widgetTypeWidget(i, items[i]));
        screenItems.add(SizedBox(height: 5.h));
        if (!DependingLogic().callDependingLogic(logics, myMap, items[i])) {
          myMap.remove(items[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  Future<void> saveDataInData() async {
    var responseJS = jsonEncode(myMap);
    var name = myMap['name'];
    await EnrolledExitChilrenResponceHelper().insertUpdate(
        widget.EnrolledChilGUID,
        widget.CHHGUID,
        widget.HHname,
        Global.stringToIntNull(name.toString()),
        Global.stringToInt(myMap['creche_id']),
        responseJS,
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

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        await saveDataInData();

        String msg =
            Global.returnTrLable(translatsLabel, CustomText.childExited, lng);

        bool shouldProceed = await showDialog(
          context: context,
          builder: (context) {
            return SingleButtonPopupDialog(
                message: msg,
                button:
                    Global.returnTrLable(translatsLabel, CustomText.ok, lng));
          },
        );
        if (shouldProceed) {
          if (shouldProceed == true) {
            Navigator.pop(context, 'itemRefresh');
          }
        }
        // return;

        // widget.changeTab(type);
        setState(() {});
      }
    } else {
      // if (widget.tabIndex == 0) {
      Navigator.pop(context, 'itemRefresh');
      // } else {
      //   widget.changeTab(type);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, 'itemRefresh');
          return false;
        },
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xff5979AA),
                  leading: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, 'itemRefresh');
                      },
                      child: Icon(
                        Icons.arrow_back_ios_sharp,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Global.returnTrLable(
                                translatsLabel, CustomText.ChildExit, lng)
                            .trim(),
                        style: Styles.white145,
                      ),
                      widget.childName != null
                          ? Text(
                              widget.childName!,
                              style: Styles.white145,
                            )
                          : Text('')
                    ],
                  ),
                  actions: [
                    (role == 'Cluster Coordinator')
                        ? GestureDetector(
                            onTap: () async {
                              await updateVerificationStatus(context);
                            },
                            child: Image.asset(
                              "assets/verify_icon.png",
                              scale: 1.5,
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      width: 10,
                    )
                  ],
                  centerTitle: true,
                ),
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
                          children: cWidget(),
                        ),
                      ),
                    )),
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
                                nextTab(0, context);
                              },
                              text: Global.returnTrLable(
                                      translatsLabel, CustomText.back, lng)
                                  .trim(),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: CElevatedButton(
                            color: Color(0xff369A8D),
                            onPressed: () {
                              nextTab(1, context);
                            },
                            text: Global.returnTrLable(
                                translatsLabel, CustomText.Submit, lng),
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ));
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

  Future<void> updateVerificationStatus(BuildContext mContext) async {
    var varyItem = await OptionsModelHelper()
        .getMstCommonOptions('CC Verification status', lng);
    varyItem = varyItem
        .where((element) => (element.name == '2') || (element.name == '3'))
        .toList();
    var verifiable = Global.returnTrLable(
        translatsLabel, CustomText.Verification_status, lng);
    OptionsModel? selectedItem;
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(verifiable),
            content: Container(
              height: 180,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  DynamicCustomDropdownField(
                    titleText: verifiable,
                    isRequred: 0,
                    items: varyItem,
                    onChanged: (value) async {
                      selectedItem = value;
                    },
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CElevatedButton(
                          text: CustomText.Submit,
                          color: Color(0xff369A8D),
                          onPressed: () async {
                            if (selectedItem != null) {
                              await updateVerification(selectedItem);
                              Navigator.of(mContext).pop();
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(translatsLabel,
                                      CustomText.statusUpdateSuccssFully, lng!),
                                  Global.returnTrLable(
                                      translatsLabel, CustomText.ok, lng!),
                                  true,
                                  mContext);
                            } else {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(translatsLabel,
                                      CustomText.selectVerifyStatus, lng!),
                                  Global.returnTrLable(
                                      translatsLabel, CustomText.ok, lng!),
                                  false,
                                  mContext);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: CElevatedButton(
                          text: CustomText.Cancel,
                          color: Color(0xffDB4B73),
                          onPressed: () async {
                            Navigator.of(mContext).pop();
                          },
                        ),
                      )
                    ],
                  )
                ],
              )),
            ),
          );
        });
  }

  Future<void> updateVerification(OptionsModel? value) async {
    var alredRecord = await EnrolledExitChilrenResponceHelper()
        .callChildrenResponce(widget.EnrolledChilGUID);
    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData['status'] = value!.name;
      var name = responseData['name'];
      var userName = (await Validate().readString(Validate.userName))!;
      responseData['app_updated_on'] = Validate().currentDateTime();
      responseData['app_updated_by'] = userName;
      responseData['verified_by'] = userName;
      responseData['verified_on'] = Validate().currentDateTime();
      var responcesJs = jsonEncode(responseData);
      await EnrolledExitChilrenResponceHelper().insertUpdate(
          widget.EnrolledChilGUID,
          widget.CHHGUID,
          widget.HHname,
          name,
          Global.stringToInt(responseData['creche_id'].toString()),
          responcesJs,
          responseData['appcreated_on'],
          responseData['appcreated_by'],
          responseData['app_updated_on'],
          responseData['app_updated_by'],
          responseData['date_of_exit']);
    }
  }
}
