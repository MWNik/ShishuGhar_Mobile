import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar_child.dart';

import '../../../custom_widget/custom_appbar.dart';
import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/database_helper.dart';
import '../../../database/helper/child_exit/child_exit_meta_fields_helper.dart';
import '../../../database/helper/child_exit/child_exit_response_Helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_exit_response_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class ChildExitDetailsScreen extends StatefulWidget {
  final int enName;
  final String? childExitGuid;
  final String? chilenrolledGUID;
  final String? creche_id;
  final String? childDob;
  final String dateOfEnrolled;
  final String childId;
  final String childName;
  final int ageAtAnrollement;

  ChildExitDetailsScreen({
    super.key,
    required this.enName,
    required this.childExitGuid,
    required this.chilenrolledGUID,
    required this.creche_id,
    required this.dateOfEnrolled,
    required this.childDob,
    required this.childId,
    required this.childName,
    required this.ageAtAnrollement,
  });

  @override
  _ChildExitDetailsScreenState createState() => _ChildExitDetailsScreenState();
}

class _ChildExitDetailsScreenState extends State<ChildExitDetailsScreen> {
  List<TabFormsLogic> logics = [];
  List<HouseHoldFielItemdModel> allItems = [];
  Map<String, dynamic> myMap = {};
  List<OptionsModel> options = [];
  DateTime? minDate;
  bool _isLoading = true;
  String userName = '';
  String? role;
  String lng = 'en';
  List<Translation> labelControlls = [];
  List<String> hiddens = [
    'partner_id',
    'state_id',
    'district_id',
    'block_id',
    'gp_id',
    'village_id',
    // 'creche_id',
    'child_id'
  ];

  Future<void> initializeData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    List<int> dateParts = widget.dateOfEnrolled.split('-').map(int.parse).toList();
    minDate=DateTime(dateParts[0], dateParts[1], dateParts[2]).subtract(Duration(days:1));
    labelControlls.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back,
      CustomText.Submit,
      CustomText.ChildExit
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls.addAll(value));

    await TranslationDataHelper()
        .callTranslateEnrolledChildren()
        .then((value) => labelControlls.addAll(value));
    await updateHiddenValue();
    await callScrenControllers('Child Exit');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomChildAppbar(
        text: Global.returnTrLable(labelControlls, CustomText.ChildExit, lng!),
        subTitle1: widget.childName,
        subTitle2: widget.childId,
        onTap: () => Navigator.pop(context, 'itemRefresh'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Divider(),
                Expanded(
                    child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cWidget(),
                  )),
                )),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Row(children: [
                    Expanded(
                        child: CElevatedButton(
                      color: Color(0xffF26BA3),
                      onPressed: () {
                        nextTab(0, context);
                      },
                      text: Global.returnTrLable(
                          labelControlls, CustomText.back, lng!),
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: CElevatedButton(
                      color: Color(0xff369A8D),
                      onPressed: () {
                        nextTab(1, context);
                      },
                      text: Global.returnTrLable(
                          labelControlls, CustomText.Submit, lng!),
                    ))
                  ]),
                )
              ],
            ),
    );
  }

  List<Widget> cWidget() {
    List<Widget> screenItems = [];
    if (allItems.length > 0) {
      for (int i = 0; i < allItems.length; i++) {
        screenItems.add(widgetTypeWidget(i, allItems[i]));
        screenItems.add(SizedBox(height: 5.h));
        callAutoGeneratedOtherTable(myMap, allItems[i]);
        if (!DependingLogic().callDependingLogic(logics, myMap, allItems[i])) {
          myMap.remove(allItems[i].fieldname);
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
          titleText:
              Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          items: items,
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
        return CustomDatepickerDynamic(
          initialvalue: myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          minDate: minDate,
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
          calenderValidate:
              DependingLogic().calenderValidation(logics, myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            callAutoGeneratedOtherTable(myMap, quesItem);
            var logData = DependingLogic()
                .callDateDiffrenceLogic(logics, myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);

              }
            }
            setState(() {});
          },
          titleText:
              Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!, logics),
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          hintText:
              Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng),
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
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          titleText:
              Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          items: items,
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
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label:
              Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: labelControlls,
          lng: lng,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            // if (value > 0)
            print('yesNo $value');
            myMap[quesItem.fieldname!] = value;
            callDiffrentTableLogic(quesItem);
            setState(() {});
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          maxline: 3,
          titleText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          hintText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
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
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          titleText:
              Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng),
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
              // setState(() {});
            }
          },
        );
      default:
        return SizedBox();
    }
  }

  Future<void> callScrenControllers(screen_type) async {
    userName = (await Validate().readString(Validate.userName))!;
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }

    await ChildExitMetaFieldsHelper()
        .getChildExitMetaFieldsbyScreenTypeForView(screen_type)
        .then((value) async {
      allItems = value;
    });
    allItems = allItems
        .where((element) => !(hiddens.contains(element.fieldname)))
        .toList();

    List<String> defaultCommon = [];
    for (int i = 0; i < allItems.length; i++) {
      if (Global.validString(allItems[i].options)) {
        if(allItems[i].options=='Creche'){
          await OptionsModelHelper()
              .callCrechInOption(allItems[i].options!,Global.stringToInt(widget.creche_id))
              .then((value) => options.addAll(value));
        }else defaultCommon.add('tab${allItems[i].options!.trim()}');
      }
    }

    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon,lng)
        .then((value) => options.addAll(value));

    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logics.addAll(data);
    });
    List<String> labelItems = [];
    allItems.forEach((element) {
     if(Global.validString(element.label)){
      labelItems.add(element.label!);
     }
    });
    await TranslationDataHelper().callTranslateString(labelItems).then((value) => labelControlls.addAll(value));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    initializeData();
  }

  bool _checkValidation() {
    var validStatus = true;
    if (allItems.length > 0) {
      for (int i = 0; i < allItems.length; i++) {
        var element = allItems[i];
        if (element.reqd == 1) {
          var valuees = myMap[element.fieldname];
          if (!Global.validString(valuees.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(
                    labelControlls, CustomText.plsFilManForm, lng!),
                Global.returnTrLable(labelControlls, CustomText.ok, lng!),
                false,
                context);
            validStatus = false;
            break;
          }
        }
        var validationMsg =
            DependingLogic().validationMessge(logics, myMap, element);
        if (Global.validString(validationMsg)) {
          Validate().singleButtonPopup(
              Global.returnTrLable(labelControlls, validationMsg, lng!),
              Global.returnTrLable(labelControlls, CustomText.ok, lng!),
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

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        await saveDataInData();
        bool shouldProceed = await showDialog(
          context: context,
          builder: (context) {
            return SingleButtonPopupDialog(
                message: Global.returnTrLable(
                    labelControlls, CustomText.dataSaveSuc, lng!),
                button:
                    Global.returnTrLable(labelControlls, CustomText.ok, lng!));
          },
        );
        if (shouldProceed) {
          Navigator.pop(context, 'itemRefresh');
        }
        // return;

        setState(() {});
      }
    } else {
      Navigator.pop(context, 'itemRefresh');
    }
  }

  Future<void> saveDataInData() async {
    if (allItems.length > 0) {
      Map<String, dynamic> responces = {};
      allItems.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
      });
      var responcesJs = jsonEncode(myMap);
      print(responcesJs);

      var eventItem = ChildExitTabResponceModel(
          child_exit_guid: widget.childExitGuid,
          childenrolledguid: widget.chilenrolledGUID,
          name: myMap['name'],
          creche_id: Global.stringToInt(widget.creche_id),
          responces: responcesJs,
          is_uploaded: 0,
          is_edited: 1,
          is_deleted: 0,
          created_at: myMap['appcreated_on'],
          created_by: myMap['appcreated_by'],
          update_at: myMap['app_updated_on'],
          updated_by: myMap['app_updated_by']);
      await ChildExitResponceHelper().inserts(eventItem);
      // if(Global.validString(myMap['date_of_exit'].toString())){//Not
      //   var childs=await EnrolledChilrenResponceHelper().callChildrenResponce(widget.chilenrolledGUID!);
      //   if(childs.length>0){
      //     var itemMap = jsonDecode(childs.first.responces!);
      //     itemMap['date_of_exit'] = myMap['date_of_exit'];
      //     var itemResp = jsonEncode(itemMap);
      //     await DatabaseHelper.database!.rawQuery(
      //         'UPDATE enrollred_chilren_responce SET date_of_exit = ?  , responces = ?  ,  is_edited=1 where ChildEnrollGUID=?',
      //         [myMap['date_of_exit'],itemResp,widget.chilenrolledGUID]);
      //   }
      //
      // }
    }
  }

  Future<void> updateHiddenValue() async {
    userName = (await Validate().readString(Validate.userName))!;
    var alrecords = await ChildExitResponceHelper()
        .getChildEventResponcewithGuid(widget.childExitGuid!);
    if (alrecords.length > 0) {
      Map<String, dynamic> responcesData = jsonDecode(alrecords[0].responces!);
      responcesData.forEach((key, value) {
        myMap[key] = value;
      });

      if (responcesData['appcreated_on'] != null ||
          responcesData['appcreated_by'] != null) {
        myMap['app_updated_on'] = Validate().currentDateTime();
        myMap['app_updated_by'] = userName;
      } else {
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
      }
      var name = alrecords[0].name;
      if (name != null) {
        myMap['name'] = name;
      }
    } else {
      var creCheDetails = await CrecheDataHelper()
          .getCrecheResponceItem(Global.stringToInt(widget.creche_id));
      if (creCheDetails.length > 0) {
        myMap['childenrolledguid'] = widget.chilenrolledGUID;
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
        myMap['child_id'] = widget.enName;
        myMap['creche_id'] = widget.creche_id.toString();
        // myMap['creche_name'] =  Global.getItemValues(creCheDetails[0].responces!, 'creche_name');
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
        myMap['child_exit_guid'] = widget.childExitGuid;
        myMap['date_of_enrollment'] = widget.dateOfEnrolled;
        myMap['date_of_exit'] = Global.initCurrentDate();
        myMap['age_at_enrollment_in_months'] = widget.ageAtAnrollement;
      }
    }
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 10),
                const Text("Please wait..."),
              ],
            ),
          ),
        );
      },
    );
  }

  callDiffrentTableLogic(HouseHoldFielItemdModel parentItem) {
    var items = logics
        .where((element) =>
            element.dependentControls.contains(parentItem.fieldname!) &&
            (element.type_of_logic_id == '20'))
        .toList();
    if (items.length > 0) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].type_of_logic_id == '20') {
          var dependVAlu = myMap[items[i].dependentControls];
          var algo = Global.splitData(items[i].algorithmExpression, ',');
          if (dependVAlu != null && algo.length == 2) {
            if (dependVAlu.toString() == algo[0]) {
              myMap[items[i].parentControl] = widget.dateOfEnrolled;
            } else
              myMap.remove(items[i].parentControl);
            break;
          }
        }
      }
    }
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
              if (dependValue != null && widget.childDob != null) {
                var dateDob = Validate().stringToDate(widget.childDob!);
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
}
