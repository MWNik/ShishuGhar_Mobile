import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import 'package:shishughar/database/helper/village_profile/village_profiile_fileds_helper.dart';
import 'package:shishughar/database/helper/village_profile/village_profile_response_helper.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/model/dynamic_screen_model/village_profile_response_model.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamin_multi_check_screen.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/enrolled_children/enrolled_children_field_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../utils/globle_method.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../house_hold/depending_logic.dart';

class VillageProfileTbaItem extends StatefulWidget {
  final int vName;
  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;

  const VillageProfileTbaItem({
    super.key,
    required this.vName,
    required this.tabBreakItem,
    required this.screenItem,
    required this.changeTab,
    required this.tabIndex,
    required this.totalTab,
  });

  @override
  _VillageProfileTbaItemState createState() => _VillageProfileTbaItemState();
}

class _VillageProfileTbaItemState extends State<VillageProfileTbaItem> {
  bool _isLoading = true;
  List<HouseHoldTabResponceHelper> retrivedList = [];
  List<OptionsModel> options = [];
  List<TabFormsLogic> logics = [];
  List<HouseHoldFielItemdModel> multselectItemTab = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translats = [];
  String userName = '';
  String? saveNext = CustomText.Next;
  String? responce;
  String? role;
  String lng = 'eng';
  bool isRecordNew = true;
  String childDOB = '';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    role = await Validate().readString(Validate.role);
    List<String> valueNames = [
      CustomText.Creches,
      CustomText.Next,
      CustomText.back,
      CustomText.ok,
      CustomText.Save,
      CustomText.Submit,
      CustomText.ChildEnrollsuccess,
      CustomText.enrolled,
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
        .then((value) => translats = value);

    multselectItemTab =
        await VillageProfileFieldsHelper().callMultiSelectTabItem();
    await updateHiddenValue();
    await callScrenControllers('Village');
    // calinitialScreen();
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
          ? Center(child: CircularProgressIndicator())
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
                                ? SizedBox()
                                : Expanded(
                                    child: CElevatedButton(
                                      color: Color(0xff5979AA),
                                      onPressed: () {
                                        saveOnly(1, context);
                                        // widget.changeTab(1);
                                      },
                                      text: Global.returnTrLable(
                                              translats, CustomText.Save, lng)
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
                      ],
                    ),
                  ),
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
        if (!DependingLogic().callDependingLogic(logics, myMap, items[i])) {
          myMap.remove(items[i].fieldname);
        }
        screenItems.add(widgetTypeWidget(i, items[i]));
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
        if(options.length==1){
          defaultDisableDailog(quesItem.fieldname!,'tab${quesItem.options}');
        }
        return DynamicCustomDropdownField(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
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
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!, logics),
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
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
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
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
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          selectedItem: myMap[quesItem.fieldname],
          responceFieldName: itemResopnceField,
          onChanged: (value) {
            if (value != null) myMap[quesItem.fieldname!] = value;
            // else
            //   myMap.remove(quesItem.fieldname);

            setState(() {});
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
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          isVisible: DependingLogic().callDependingLogic(logics, myMap, quesItem),
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
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
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
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
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
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
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
    Map<String, dynamic> responsedata = {};
    var alrecords = await VillageProfileResponseHelper()
        .getVillageProfilebyName(widget.vName);
    if (alrecords[0].responces != null) {
      responsedata = jsonDecode(alrecords[0].responces!);
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
            (items[i].options == 'Village') ||
            (items[i].options == 'Gram Panchayat')) {
          await OptionsModelHelper()
              .getLocationData(items[i].options!.trim(), responsedata,lng)
              .then((data) {
            options.addAll(data);
          });
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
        .getAllMstCommonNotINOptionsWthouASC(defaultCommon,lng)
        .then((data) {
      options.addAll(data);
    });
    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logics.addAll(data);
    });
  }

  Future<void> calinitialScreen() async {
    await callScrenControllers('Village');
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
    if (type == 1) {
      if (_checkValidation()) {
        if (widget.tabIndex < (widget.totalTab - 1)) {
          await saveDataInData();
        } else if (widget.tabIndex == (widget.totalTab - 1)) {
          await saveDataInData();

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
      var villageResponse = await VillageProfileResponseHelper()
          .getVillageProfilebyName(widget.vName);
      var responcesJs = jsonEncode(myMap);
      var name = widget.vName;
      print(responcesJs);
      var item = VillageProfileResponseModel(
          village_code: myMap['village_code'],
          village_name: myMap['village_name'],
          name: name,
          is_deleted: 0,
          update_at: DateTime.now().toString(),
          updated_by: userName,
          is_edited: 1,
          is_uploaded: 0,
          created_at: villageResponse[0].created_at,
          created_by: villageResponse[0].created_by,
          responces: responcesJs);

      await VillageProfileResponseHelper().inserts(item);
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
          Validate()
              .singleButtonPopup(validationMsg!, CustomText.ok, false, context);
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
    var alredRecord = await VillageProfileResponseHelper()
        .getVillageProfilebyName(widget.vName);

    if (alredRecord.length > 0) {
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
      childDOB = Global.getItemValues(alredRecord[0].responces, 'child_dob');
      var name = alredRecord[0].name;
      if (name != null) {
        myMap['name'] = name;
      }
    }
  }
}
