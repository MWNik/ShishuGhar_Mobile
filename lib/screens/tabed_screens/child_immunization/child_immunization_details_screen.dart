import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_time_picker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/child_immunization/child_immunization_meta_fileds_helper.dart';
import '../../../database/helper/child_immunization/child_immunization_response_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/child_immunization_response_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class ChildImmunizationDetailsScreen extends StatefulWidget {
  final int enName;
  final String? child_immunization_guid;
  final String? chilenrolledGUID;
  final String? creche_id;

  ChildImmunizationDetailsScreen(
      {super.key,
      required this.creche_id,
      required this.child_immunization_guid,
      required this.chilenrolledGUID,
      required this.enName});

  @override
  _ChildImmunizationDetailsScreenSatet createState() =>
      _ChildImmunizationDetailsScreenSatet();
}

class _ChildImmunizationDetailsScreenSatet
    extends State<ChildImmunizationDetailsScreen> {
  List<TabFormsLogic> logics = [];
  List<HouseHoldFielItemdModel> allItems = [];
  Map<String, dynamic> myMap = {};
  List<OptionsModel> options = [];
  bool _isLoading = true;
  String userName = '';
  String? role;
  String? lng = 'en';
  List<Translation> labelControlls = [];
  List<String> hiddens=[ 'partner_id',
    'state_id',
    'district_id',
    'block_id',
    'gp_id',
    'village_id',
    'creche_id',
    'child_id'];


  Future<void> initializeData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    labelControlls.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls = value);

    await TranslationDataHelper()
        .callTranslateEnrolledChildren()
        .then((value) => labelControlls.addAll(value));
    await updateHiddenValue();
    await callScrenControllers('Vaccine Details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          text: Global.returnTrLable(
              labelControlls, CustomText.VaccinationDetails, lng!),
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
                            labelControlls, CustomText.Save, lng!),
                      ))
                    ]),
                  )
                ],
              ));
  }

  List<Widget> cWidget() {
    List<Widget> screenItems = [];
    var items = allItems;
    if (items .length>0) {
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

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
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
          calenderValidate:[],
          initialvalue: myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
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
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!,logics),
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          hintText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
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
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
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
              setState(() {});
            }
          },
        );
      case 'Check':
        return DynamicCustomCheckboxWithLabel(
          label: Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          initialValue: myMap[quesItem.fieldname!],
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          isVisible:
          DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            setState(() {});
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          isVisible:
          DependingLogic().callDependingLogic(logics, myMap, quesItem),
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
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
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          isVisible:
          DependingLogic().callDependingLogic(logics, myMap, quesItem),
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
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
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          isVisible:
          DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            var logData = DependingLogic()
                .callDateDiffrenceLogic(logics, myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);
                setState(() {});
              }
            }
          },
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
        );
    // case 'Long Text':
    //   return CustomImageDynamic(
    //     assetPath:myMap[quesItem.fieldname!],
    //     titleText:
    //     Global.returnTrLable(translats, quesItem.label!.trim(), lng),
    //     isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
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

  Future<void> callScrenControllers(screen_type) async {
    userName = (await Validate().readString(Validate.userName))!;

    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    // await ChildImmunizationMetaFieldsHelper()
    //     .getChildImmunizationMetaFieldsbyS
    // creenType(screen_type)
    //     .then((value) async {
    //   allItems = value;
    // });

    allItems=allItems.where((element) => !(hiddens.contains(element.fieldname))).toList();

    List<String> defaultCommon = [];
    for (int i = 0; i < allItems.length; i++) {
      if (Global.validString(allItems[i].options)) {
        defaultCommon.add('tab${allItems[i].options!.trim()}');
      }
    }

    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon,lng!)
        .then((value) => options.addAll(value));

    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
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

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    initializeData();
  }

  bool _checkValidation() {
    var validStatus = true;
    var items = allItems;
    if (items .length>0) {
      for (int i = 0; i < items.length; i++) {
        var element = items[i];
        if (element.reqd == 1) {
          var valuees = myMap[element.fieldname];
          if (!Global.validString(valuees.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(
                    labelControlls, CustomText.plsFilManForm, lng!),
                Global.returnTrLable(labelControlls, CustomText.ok, lng!),false,context);
            validStatus = false;
            break;
          }
        }
        var validationMsg =
            DependingLogic().validationMessge(logics, myMap, element);
        if (Global.validString(validationMsg)) {
          Validate().singleButtonPopup(
              Global.returnTrLable(
                  labelControlls, validationMsg, lng!),
              Global.returnTrLable(labelControlls, CustomText.ok, lng!),false,context);
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
          if (shouldProceed == true) {
            Navigator.pop(context, 'itemRefresh');
          }
        }
        // return;

        setState(() {});
      }
    } else {
      Navigator.pop(context, 'itemRefresh');
    }
  }

  Future<void> saveDataInData() async {
    if (allItems.length>0) {
      Map<String, dynamic> responces = {};
      allItems.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
      });
      var responcesJs = jsonEncode(myMap);
      var name = myMap['name'];
      print(responcesJs);
      var immulizerItem = ChildImmunizationResponceModel(
          child_immunization_guid: widget.child_immunization_guid,
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
      await ChildImmunizationResponseHelper().inserts(
          immulizerItem);
    }
  }

  Future<void> updateHiddenValue() async {
    userName = (await Validate().readString(Validate.userName))!;
    var alrecords = await ChildImmunizationResponseHelper()
        .getChildEventResponcewithGuid(widget.child_immunization_guid!);
    if (alrecords.length > 0) {
      Map<String, dynamic> responcesData = jsonDecode(alrecords[0].responces!);
      responcesData.forEach((key, value) {
        myMap[key] = value;
      });

      if (responcesData['appcreated_on'] != null ||
          responcesData['app_created_by'] != null) {
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
        myMap['child_immunization_guid'] = widget.child_immunization_guid;
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
        child:AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 10),
              const Text("Please wait..."),
            ],
          ),),
        );
      },
    );
  }
}
