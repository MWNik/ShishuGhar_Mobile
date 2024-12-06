import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/database/helper/child_gravience/child_grievances_response_helper.dart';
import 'package:shishughar/database/helper/child_reffrel/child_refferal_fields_helper.dart';
import 'package:shishughar/database/helper/creche_helper/creche_data_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/child_grievances_response_model.dart';

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
import '../../../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/follow_up/child_followUp_response_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class GraviencesTabItem extends StatefulWidget {
  final String grievance_guid;

  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;
  final bool isNew;

  const GraviencesTabItem(
      {super.key,
      required this.grievance_guid,
      required this.tabBreakItem,
      required this.screenItem,
      required this.changeTab,
      required this.tabIndex,
      required this.totalTab,
      required this.isNew
      });

  @override
  State<GraviencesTabItem> createState() => _ChildFollowUpTabItemSCreenState();
}

class _ChildFollowUpTabItemSCreenState extends State<GraviencesTabItem> {
  List<OptionsModel> options = [];
  List<TabFormsLogic> logics = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translats = [];
  List<CresheDatabaseResponceModel> allCrecheRecords = [];
  String userName = '';
  String lng = 'eng';
  String? role;
  bool _isLoading = true;
  String? saveNext = CustomText.Next;
  List<HouseHoldFielItemdModel> multselectItemTab = [];
  List<OptionsModel> items = [];
  // List<OptionsModel> cItems = [];
  // bool villageHasChanged = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    userName = (await Validate().readString(Validate.userName))!;
    role = await Validate().readString(Validate.role);
    userName = (await Validate().readString(Validate.userName))!;
    List<String> valueNames = [
      CustomText.Creches,
      CustomText.Next,
      CustomText.back,
      CustomText.ok,
      CustomText.childrenCountVallidattion,
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
    allCrecheRecords = await CrecheDataHelper().getCrecheResponce();
    multselectItemTab =
        await ChildReferralFieldsHelper().callMultiSelectTabItem();
    await updateHiddenValue();

    await callScrenControllers('Grievance');
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
                  child: widget.isNew?Row(
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
                    SizedBox(width: 10),
                         widget.tabIndex == (widget.totalTab - 1)
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
                              ),
                         widget.tabIndex == (widget.totalTab - 1)
                            ? SizedBox()
                            : SizedBox(width: 10),
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
                  ]):Row(
                      children: [
                        Expanded(
                          child: CElevatedButton(
                            color: Color(0xffF26BA3),
                            onPressed: () {
                              if (widget.tabIndex == 0) {
                                Navigator.pop(context, 'itemRefresh');
                              } else {
                                widget.changeTab(0);
                              }
                            },
                            text: Global.returnTrLable(
                                translats, CustomText.back, lng)
                                .trim(),
                          ),
                        ),
                        widget.tabIndex == (widget.totalTab - 1)?SizedBox():SizedBox(width: 10),
                        widget.tabIndex == (widget.totalTab - 1)?SizedBox():Expanded(
                          child: CElevatedButton(
                            color: Color(0xff369A8D),
                            onPressed: () {
                              widget.changeTab(1);
                            },
                            text:  Global.returnTrLable(
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
        screenItems.add(SizedBox(height: 5.h));

        if (!DependingLogic().callDependingLogic(logics, myMap, items[i])) {
          myMap.remove(items[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  List<OptionsModel> filterCreche(String villageId) {
    List<CresheDatabaseResponceModel> filteredCrecheRecords = [];
    filteredCrecheRecords = allCrecheRecords
        .where((element) =>
            Global.getItemValues(element.responces!, 'village_id') == villageId)
        .toList();
    List<OptionsModel> crecheOptionsList = [];
    filteredCrecheRecords.forEach((element) {
      var item = OptionsModel(
        name: element.name.toString(),
        flag: 'tabCreche',
        values: Global.getItemValues(element.responces, 'creche_name'),
      );
      crecheOptionsList.add(item);
    });
    return crecheOptionsList;
  }

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
         if (quesItem.fieldname == 'creche_id') {
          var village_id = myMap['village_id'];
          if(village_id!=null) {
            items = filterCreche(village_id);
          }else items=[];
        }else {
           items = options
               .where((element) => element.flag == "tab${quesItem.options}")
               .toList();
         }
         if (items.length == 1) {
           myMap[quesItem.fieldname!] = items.first.name;
         }
        return DynamicCustomDropdownField(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          readable: widget.isNew ?DependingLogic().callReadableLogic(logics, myMap, quesItem) : true,
          items: items,
          selectedItem: myMap[quesItem.fieldname],
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            if (quesItem.fieldname == 'village_id' && value!.name != null) {
              myMap.remove('creche_id');
            }
            if (value != null)
              myMap[quesItem.fieldname!] = value.name!;
            else
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
      case 'Date':
        return CustomDatepickerDynamic(
          initialvalue: myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          readable: quesItem.fieldname=='grievance_date'?true:DependingLogic().callReadableLogic(logics, myMap, quesItem),
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
          readable: widget.isNew ?DependingLogic().callReadableLogic(logics, myMap, quesItem) : true,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          maxline: (quesItem.length != 0) ? quesItem.length! % 35 : 1,
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!, logics),
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
          readable: widget.isNew ?DependingLogic().callReadableLogic(logics, myMap, quesItem) : true,
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
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          readable: widget.isNew ?DependingLogic().callReadableLogic(logics, myMap, quesItem) : true,
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
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
          readable: widget.isNew ?DependingLogic().callReadableLogic(logics, myMap, quesItem) : true,
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
          readable: widget.isNew ?DependingLogic().callReadableLogic(logics, myMap, quesItem) : true,
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
          readable: widget.isNew ?DependingLogic().callReadableLogic(logics, myMap, quesItem) : true,
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
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          fieldName: quesItem.fieldname!,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          readable: widget.isNew ?DependingLogic().callReadableLogic(logics, myMap, quesItem) : true,
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
                CustomText.ok,
                false,
                context);
            validStatus = false;
            break;
          }
        }
        var validationMsg =
            DependingLogic().validationMessge(logics, myMap, element,translats,lng);
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

  saveOnly(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        await saveDataInData(0);
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

  Future<void> saveDataInData(int type) async {
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
      var item = (type == 1)
          ? ChildGrievancesResponceModel(
        grievance_guid: widget.grievance_guid,
        responces: responcesJs,
        creche_id: Global.stringToInt(myMap['creche_id']),
        is_deleted: 0,
        is_edited: 1,
        is_uploaded: 0,
        name: name,
        created_at: myMap['appcreated_on'],
        created_by: myMap['appcreated_by'],
        update_at: DateTime.now().toString(),
        updated_by: userName,
      )
          : ChildGrievancesResponceModel(
        grievance_guid: widget.grievance_guid,
        responces: responcesJs,
        is_deleted: 0,
        is_edited: 1,
        is_uploaded: 0,
        name: name,
        created_at: myMap['appcreated_on'],
        created_by: myMap['appcreated_by'],
        update_at: DateTime.now().toString(),
        updated_by: userName,
      );
      await ChildGrievancesTabResponceHelper().inserts(item);
    }
  }

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        if (widget.tabIndex < (widget.totalTab - 1)) {
          await saveDataInData(0);
        } else if (widget.tabIndex == (widget.totalTab - 1)) {
          await saveDataInData(1);
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

    Map<String, dynamic> responseData = {};

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
                .callCrechInOptionAll(items[i].options!.trim())
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
                .getLocationData(items[i].options!.trim(), responseData,lng)
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
        .getAllMstCommonNotINOptionsWthouASC(defaultCommon,lng)
        .then((data) {
      options.addAll(data);
    });
    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logics.addAll(data);
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
    var alredRecord = await ChildGrievancesTabResponceHelper()
        .getChildEventResponcewithGuid(widget.grievance_guid);
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
      var name = alredRecord[0].name;
      if (name != null) {
        myMap['name'] = name;
      }
    } else {
      myMap['grievance_guid'] = widget.grievance_guid;
      myMap['appcreated_by'] = userName;
      myMap['appcreated_on'] = Validate().currentDateTime();
      myMap['status'] = "1";
      myMap['grievance_date'] = Global.initCurrentDate();
    }
  }
}
