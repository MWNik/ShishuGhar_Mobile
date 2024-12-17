import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shishughar/utils/validate.dart';
import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../database/helper/block_data_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/district_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/house_hold_children_helper.dart';
import '../../../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/gram_panchayat_data_helper.dart';
import '../../../database/helper/house_field_item_helper.dart';
import '../../../database/helper/state_data_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../database/helper/village_data_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/tabBlock_model.dart';
import '../../../model/databasemodel/tabDistrict_model.dart';
import '../../../model/databasemodel/tabGramPanchayat_model.dart';
import '../../../model/databasemodel/tabVillage_model.dart';
import '../../../model/databasemodel/tabstate_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';
import 'depending_logic.dart';

class AddHouseholdScreenFromTab extends StatefulWidget {
  final String hhGuid;
  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;
  final int crecheId;

  const AddHouseholdScreenFromTab(
      {super.key,
      required this.hhGuid,
      required this.tabBreakItem,
      required this.screenItem,
      required this.changeTab,
      required this.tabIndex,
      required this.crecheId,
      required this.totalTab});

  @override
  State<AddHouseholdScreenFromTab> createState() =>
      _HouseholdScreenFromTabState();
}

class _HouseholdScreenFromTabState extends State<AddHouseholdScreenFromTab> {
  bool _isLoading = true; // Change this to true initially
  List<CresheDatabaseResponceModel> allCrecheRecords = [];
  List<OptionsModel> options = [];
  // List<TabFormsLogic> logics = [];
  List<Translation> translats = [];
  Map<String, dynamic> myMap = {};
  String userName = '';
  String? saveNext = "Next";
  String lng = "en";
  String? role;
  int? children__3_years;
  int? childCount;
  List<Translation> labelControlls = [];
  List<TabState> states = [];
  List<TabDistrict> districts = [];
  List<TabBlock> blocks = [];
  List<TabGramPanchayat> gramPanchayats = [];
  List<TabVillage> villages = [];
  int? nameId;
  DependingLogic? logic;
  // String autoFocs ='';
  @override
  void initState() {
    super.initState();
    setLabelTextData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        body: Column(
          children: [
            Divider(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: Row(
                children: [
                  Expanded(
                    child: CElevatedButton(
                      color: Color(0xffF26BA3),
                      onPressed: () {
                        nextTab(0);
                      },
                      text:
                          Global.returnTrLable(translats, CustomText.back, lng),
                    ),
                  ),
                  role == 'Creche Supervisor'
                      ? SizedBox(width: 10)
                      : SizedBox(),
                  role == 'Creche Supervisor'
                      ? Expanded(
                          child: CElevatedButton(
                            color: Color(0xff5979AA),
                            onPressed: () {
                              nextTabSave(1);
                              // widget.changeTab(1);
                            },
                            text: Global.returnTrLable(
                                translats, CustomText.Save, lng),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(width: 10),
                  Expanded(
                    child: CElevatedButton(
                      color: Color(0xff369A8D),
                      onPressed: () {
                        nextTab(1);
                        // widget.changeTab(1);
                      },
                      text:
                          Global.returnTrLable(translats, CustomText.Next, lng),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  List<Widget> cWidget(String itemId) {
    List<Widget> screenItems = [];
    var items = widget.screenItem[itemId];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        screenItems.add(widgetTypeWidget(i, items[i]));
        screenItems.add(SizedBox(height: 5.h));
        if (!logic!.callDependingLogic(myMap, items[i])) {
          myMap.remove(items[i].fieldname);
        }
        // updateLocationDropDown(items[i]);
      }
    }
    return screenItems;
  }

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        // List<OptionsModel> items = [];
        // if (quesItem.fieldname == 'creche_id') {
        //   var village_id = myMap['village_id'];
        //   if(village_id!=null) {
        //     items = filterCreche(village_id);
        //   }else items=[];
        // }else {
        //   items = options
        //       .where((element) => element.flag == "tab${quesItem.options}")
        //       .toList();
        // }
        // if (items.length == 1) {
        //   myMap[quesItem.fieldname!] = items.first.name;
        // }
        return DynamicCustomDropdownField(
          hintText:
              Global.returnTrLable(translats, CustomText.select_here, lng),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          readable: role == 'Creche Supervisor'
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          items: updateLocationDropDown(quesItem),
          selectedItem: myMap[quesItem.fieldname],
          isVisible: logic!.callDependingLogic(myMap, quesItem),
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
      case 'Date':
        return CustomDatepickerDynamic(
          initialvalue: myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          calenderValidate: logic!.calenderValidation(myMap, quesItem),
          readable: nameId == null
              ? role == 'Creche Supervisor'
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
              : true,
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
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: role == 'Creche Supervisor'
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
          readable: logic!.callReadableLogic(myMap, quesItem),
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
          readable: role == 'Creche Supervisor'
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            myMap[quesItem.fieldname!] = value;
            if (value != null) {
              myMap[quesItem.fieldname!] = value;
              var logData = logic!.callAutoGeneratedValue(myMap, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  print(logData);
                  myMap.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  // setState(() {});
                }
              }
            } else {
              // setState(() {
              myMap.remove(quesItem.fieldname);
            }
            // });
          },
        );
      // case 'Check':
      //   return DynamicCustomCheckboxWithLabel(
      //     label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
      //     initialValue: myMap[quesItem.fieldname!],
      //     readable: role=='Creche Supervisor'?logic!.callReadableLogic( myMap, quesItem):true,
      //     isVisible:
      //         logic!.callDependingLogic( myMap, quesItem),
      //     onChanged: (value) {
      //       // if(value>0)
      //       myMap[quesItem.fieldname!] = value;
      //       // else
      //       //   myMap.remove(quesItem.fieldname);
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
          readable: role == 'Creche Supervisor'
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            // if (value > 0)
            print('yesNo $value');
            myMap[quesItem.fieldname!] = value;
            // else
            //   myMap.remove(quesItem.fieldname);
            setState(() {});
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          readable: role == 'Creche Supervisor'
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
          readable: role == 'Creche Supervisor'
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
      default:
        return SizedBox();
    }
  }

  Future<void> callScrenControllers(screen_type) async {
    var lngtr = await Validate().readString(Validate.sLanguage);
    await getInitLocation();
    var alredRecord =
        await HouseHoldTabResponceHelper().getHouseHoldResponce(widget.hhGuid);
    Map<String, dynamic> responseData = {};
    if (alredRecord.isNotEmpty) {
      responseData = jsonDecode(alredRecord[0].responces!);
    }
    if (lngtr != null) {
      lng = lngtr;
    }
    List<HouseHoldFielItemdModel> items =
        widget.screenItem[widget.tabBreakItem.name!]!;
    await updateHiddenValue();
    await TranslationDataHelper()
        .callTranslate()
        .then((value) => translats.addAll(value));
    List<String> defaultCommon = [];
    List<String> logicFields = [];
    for (int i = 0; i < items.length; i++) {
      if (Global.validString(items[i].options)) {
        if (!(items[i].options == 'Household Child Form')) {
          if ((items[i].options == 'State') ||
              (items[i].options == 'District') ||
              (items[i].options == 'Block') ||
              (items[i].options == 'Gram Panchayat') ||
              (items[i].options == 'Village') ||
              (items[i].options == 'Creche') ||
              (items[i].options == 'Partner')) {
            if (items[i].options == 'Partner') {
              await OptionsModelHelper()
                  .getPartnerMstCommonOptions(
                      items[i].options!.trim(), responseData)
                  .then((data) {
                options.addAll(data);
              });
              defaultDisableDailog(items[i].fieldname!, items[i].options!);
            } else if (items[i].options == 'Creche') {
              await OptionsModelHelper()
                  .callCrechInOptionAll(items[i].options!.trim())
                  .then((data) {
                options.addAll(data);
                if (data.length == 1) {
                  defaultDisableDailog(items[i].fieldname!, items[i].options!);
                }
              });
            } //else updateLocationDropDown(items[i]);
            // else {
            //   await OptionsModelHelper()
            //       .getLocationData(items[i].options!.trim(),responseData)
            //       .then((data) {
            //     options.addAll(data);
            //   });
            // }
            // defaultDisableDailog(items[i].fieldname!, items[i].options!);
          } else {
            defaultCommon.add('tab${items[i].options!.trim()}');
          }
        } else {
          // defaultCommon.add('tab${items[i].options!.trim()}');
        }
      }
      logicFields.add(items[i].fieldname!);
    }
    print("item v ${defaultCommon.length}");
    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng)
        .then((data) {
      options.addAll(data);
    });
    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      // logics.addAll(data);
      logic = DependingLogic(translats, data, lng);
    });
  }

  Future<void> calinitialScreen() async {
    userName = (await Validate().readString(Validate.userName))!;
    role = await Validate().readString(Validate.role);
    await callScrenControllers('Household Form');
    allCrecheRecords = await CrecheDataHelper().getCrecheResponce();
    setState(() {
      _isLoading = false;
    });
  }

  defaultDisableDailog(String fieldName, String flag) async {
    var tabName = 'tab$flag';
    var item = options.where((element) => element.flag == tabName).toList();
    if (item.length > 0) {
      myMap[fieldName] = item.first.name;
    }
  }

  nextTab(int type) async {
    if (role == 'Creche Supervisor') {
      if (type == 1) {
        if (checkValidation()) {
          if (widget.tabIndex < (widget.totalTab - 1)) {
            // myMap['verification_status'] = children__3_years != null
            //     ? (childCount == children__3_years ? '2' : '1')
            //     : '1';

            if (widget.tabIndex == (widget.totalTab) - 1) {
              // myMap['verification_status'] = "2";
              saveNext = "Save";
            }
            await saveDataInData();
          } else if (widget.tabIndex == (widget.totalTab - 1)) {
            await saveDataInData();
            Validate().singleButtonPopup(
                Global.returnTrLable(translats, CustomText.dataSaveSuc, lng),
                Global.returnTrLable(translats, CustomText.ok, lng),
                false,
                context);
          }
          widget.changeTab(type);
          setState(() {});
        }
        // else {
        //   var dataSaveSuc = await TranslationDataHelper()
        //       .getTranslation("Please fill all mandatory fields!", lng);
        //
        //   if (dataSaveSuc != null && dataSaveSuc.isNotEmpty) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text(dataSaveSuc)),
        //     );
        //   } else {
        //     // Handle case where translation is null or empty
        //     ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(
        //             content: Text("Error: Translation not available")));
        //   }
        // }
      } else {
        if (widget.tabIndex == 0) {
          Navigator.pop(context, 'itemRefresh');
        } else {
          widget.changeTab(type);
        }
      }
    } else {
      if (type == 1) {
        widget.changeTab(type);
        setState(() {});
      } else {
        if (widget.tabIndex == 0) {
          Navigator.pop(context, 'itemRefresh');
        } else {
          widget.changeTab(type);
        }
      }
    }
  }

  nextTabSave(int type) async {
    if (role == 'Creche Supervisor') {
      if (type == 1) {
        if (checkValidation()) {
          if (widget.tabIndex < (widget.totalTab - 1)) {
            // myMap['verification_status'] = myMap['verification_status'] == "1";
            if (widget.tabIndex == (widget.totalTab) - 1) {
              // myMap['verification_status'] = "2";
              saveNext = "Save";
            }
            await saveDataInData();
          } else if (widget.tabIndex == (widget.totalTab - 1)) {
            await saveDataInData();
          }
          setState(() {});
          Validate().singleButtonPopup(
              Global.returnTrLable(translats, CustomText.dataSaveSuc, lng),
              Global.returnTrLable(translats, CustomText.ok, lng),
              false,
              context);
        }
        // else {
        //   var dataSaveSuc = await TranslationDataHelper()
        //       .getTranslation("Please fill all mandatory fields!", lng);
        //
        //   if (dataSaveSuc != null && dataSaveSuc.isNotEmpty) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text(dataSaveSuc)),
        //     );
        //   } else {
        //     // Handle case where translation is null or empty
        //     ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(
        //             content: Text("Error: Translation not available")));
        //   }
        // }
      } else {
        if (widget.tabIndex == 0) {
          // Navigator.pop(context, 'itemRefresh');
        } else {}
      }
    } else {
      if (type == 1) {
        setState(() {});
      } else {
        if (widget.tabIndex == 0) {
          Navigator.pop(context, 'itemRefresh');
        } else {}
      }
    }
  }

  bool checkValidation() {
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

        // children static validation for increase
        // var childrenValidation = checkFamilyMenberTab(element);
        // if (Global.validString(childrenValidation)) {
        //   Validate().singleButtonPopup(
        //       childrenValidation!,
        //       Global.returnTrLable(labelControlls, CustomText.ok, lng),
        //       false,
        //       context);
        //   validStatus = false;
        //   break;
        // }
      }
      ;
    } else {
      print("selected items is null");
    }

    return validStatus;
  }

  Future<void> saveDataInData() async {
    var widgets = widget.screenItem[widget.tabBreakItem.name];
    if (widgets != null) {
      Map<String, dynamic> responces = {};
      widgets.forEach((element) async {
        var valuees = myMap[element.fieldname];
        if (Global.validString(valuees.toString().trim())) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
      });
      // checkFamilyMenberTab(widget.screenItem[widget.tabBreakItem.name!]!);
      // myMap['verification_status'] = checkVerifyStatus();
      var responcesJs = jsonEncode(myMap);

      var name = myMap['name'];
      var creche_id = Global.stringToIntNull(myMap['creche_id']);
      var dateOfVisit = myMap['date_of_visit'];
      print(responcesJs);
      await HouseHoldTabResponceHelper().insertUpdate(
          widget.hhGuid, dateOfVisit, name, creche_id, responcesJs, userName);
    }
  }

  Future<void> updateHiddenValue() async {
    var items = await HouseHoldFieldHelper()
        .getHouseHoldFieldsHiddenField('Household Form');
    var alredRecord =
        await HouseHoldTabResponceHelper().getHouseHoldResponce(widget.hhGuid);
    var hiddenIten = items
        .where((element) =>
            !(element.fieldtype == 'Tab Break') &&
            !(element.fieldtype == 'Section Break') &&
            !(element.fieldtype == 'Column Break'))
        .toList();

    if (alredRecord.length > 0) {
      hiddenIten.forEach((element) {
        if (element.fieldname == 'hhguid') {
          myMap[element.fieldname!] = widget.hhGuid;
        } else if (element.fieldname == 'app_updated_on') {
          myMap[element.fieldname!] = Validate().currentDateTime();
        } else if (element.fieldname == 'app_updated_by') {
          myMap[element.fieldname!] = userName;
        }
        if (alredRecord[0].name != null) {
          myMap['name'] = alredRecord[0].name;
          nameId = alredRecord[0].name;
        }
      });
      if (myMap['creche_id'] == null) {
        myMap['creche_id'] = widget.crecheId; //change
      }
      if (Global.stringToInt(myMap['verification_status'].toString()) > 1) {
        myMap['verification_status'] = '2';
      }
    } else {
      hiddenIten.forEach((element) {
        if (element.fieldname == 'hhguid') {
          myMap[element.fieldname!] = widget.hhGuid;
        } else if (element.fieldname == 'app_created_on') {
          myMap[element.fieldname!] = Validate().currentDateTime();
        } else if (element.fieldname == 'app_created_by') {
          myMap[element.fieldname!] = userName;
        }
      });
      myMap['creche_id'] = widget.crecheId.toString(); //change
      myMap['date_of_visit'] = Global.initCurrentDate();
      myMap['verification_status'] = '1';
      if (widget.crecheId > 0) {
        var vaCrecheItem =
            await CrecheDataHelper().getCrecheResponceItem(widget.crecheId);
        List<HouseHoldFielItemdModel> fildItem =
            widget.screenItem[widget.tabBreakItem.name!]!;
        if (vaCrecheItem.length > 0) {
          if (fildItem.length > 0) {
            Map<String, dynamic> crechResponce =
                jsonDecode(vaCrecheItem[0].responces!);
            fildItem.forEach((element) {
              if (element.fieldname != 'creche_id') {
                if (crechResponce.containsKey(element.fieldname)) {
                  myMap[element.fieldname!] = crechResponce[element.fieldname!];
                }
              }
            });
          }
        }
      }
    }

    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData.forEach((key, value) {
        myMap[key] = value;
      });
      var chilunder3 = responseData['children__3_years'];
      if (Global.stringToInt(myMap['verification_status'].toString()) > 1) {
        myMap['verification_status'] = '2';
      }
      if (chilunder3 != null) {
        children__3_years = chilunder3;
        var childs = await HouseHoldChildrenHelperHelper()
            .getHouseHoldChildren(widget.hhGuid);
        childCount = childs.length;
      }
    }
  }

  String? checkFamilyMenberTab(HouseHoldFielItemdModel item) {
    if (item.fieldname == 'children__3_years') {
      int? crrentValue = myMap['children__3_years'];
      if (crrentValue != null) {
        if (children__3_years != null) {
          if (children__3_years! > 0) {
            if (childCount! > 0) {
              if (childCount! > crrentValue) {
                return 'You can`t decrease ${item.label}';
              }
            }
          }
        }
      }
    }
  }

  String checkVerifyStatus() {
    int? crrentValue = myMap['children__3_years'];
    if (crrentValue != null) {
      if (Global.validToInt(childCount) >= crrentValue) {
        return '2';
      } else
        return '1';
    } else
      return '1';
  }

  Future<void> setLabelTextData() async {
    List<String> valueNames = [
      CustomText.back,
      CustomText.Next,
      CustomText.plsFilManForm,
      CustomText.dataSaveSuc,
      CustomText.ok,
      CustomText.Save,
      CustomText.Yes,
      CustomText.No,
      CustomText.select_here,
      CustomText.typehere,
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
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats.addAll(value));

    await calinitialScreen();
  }

  Future<void> getInitLocation() async {
    states = await StateDataHelper().getTabStateList();
    districts = await DistrictDataHelper().getTabDistrictList();
    blocks = await BlockDataHelper().getTabBlockList();
    gramPanchayats = await GramPanchayatDataHelper().getTabGramPanchayatList();
    villages = await VillageDataHelper().getTabVillageList();
  }

  List<OptionsModel> updateLocationDropDown(HouseHoldFielItemdModel item) {
    if (item.fieldtype == 'Link' &&
        item.fieldname == 'state_id' &&
        item.options == 'State') {
      options.removeWhere((element) => element.flag == 'tabState');
      List<OptionsModel> updatedItems = Global.callSatates(states, lng);
      options.addAll(Global.callSatates(states, lng));
      if (updatedItems.length == 1) {
        defaultDisableDailog(item.fieldname!, item.options!);
      }
    } else if (item.fieldtype == 'Link' &&
        item.fieldname == 'district_id' &&
        item.options == 'District') {
      options.removeWhere((element) => element.flag == 'tabDistrict');
      var statesId = myMap['state_id'];
      if (statesId != null) {
        var updatedDistrict =
            Global.callDistrict(districts, lng, OptionsModel(name: statesId));
        //     .where((element) => element.stateId.toString() == statesId)
        //     .toList();
        // List<OptionsModel> updatedItems = updatedDistrict
        //     .map((model) => OptionsModel(
        //         name: model.name.toString(),
        //         values: model.value,
        //         flag: 'tabDistrict'))
        //     .toList();
        options.addAll(updatedDistrict);
        if (updatedDistrict.length == 1) {
          defaultDisableDailog(item.fieldname!, item.options!);
        }
      }
    } else if (item.fieldtype == 'Link' &&
        item.fieldname == 'block_id' &&
        item.options == 'Block') {
      options.removeWhere((element) => element.flag == 'tabBlock');
      var district_id = myMap['district_id'];
      if (district_id != null) {
        var updatedDistrict =
            Global.callBlocks(blocks, lng, OptionsModel(name: district_id));
        //     .where((element) => element.districtId.toString() == district_id)
        //     .toList();
        // List<OptionsModel> updatedItems = updatedDistrict
        //     .map((model) => OptionsModel(
        //         name: model.name.toString(),
        //         values: model.value,
        //         flag: 'tabBlock'))
        //     .toList();
        options.addAll(updatedDistrict);
        if (updatedDistrict.length == 1) {
          defaultDisableDailog(item.fieldname!, item.options!);
        }
      }
    } else if (item.fieldtype == 'Link' &&
        item.fieldname == 'gp_id' &&
        item.options == 'Gram Panchayat') {
      options.removeWhere((element) => element.flag == 'tabGram Panchayat');
      var block_id = myMap['block_id'];
      if (block_id != null) {
        var updatedDistrict = Global.callGramPanchyats(
            gramPanchayats, lng, OptionsModel(name: block_id));
        //     .where((element) => element.blockId.toString() == block_id)
        //     .toList();
        // List<OptionsModel> updatedItems = updatedDistrict
        //     .map((model) => OptionsModel(
        //         name: model.name.toString(),
        //         values: model.value,
        //         flag: 'tabGram Panchayat'))
        //     .toList();
        options.addAll(updatedDistrict);
        if (updatedDistrict.length == 1) {
          defaultDisableDailog(item.fieldname!, item.options!);
        }
      }
    } else if (item.fieldtype == 'Link' &&
        item.fieldname == 'village_id' &&
        item.options == 'Village') {
      options.removeWhere((element) => element.flag == 'tabVillage');
      var gp_id = myMap['gp_id'];
      if (gp_id != null) {
        var updatedDistrict = Global.callFiltersVillages(
            villages, lng, OptionsModel(name: gp_id));
        //     .where((element) => element.gpId.toString() == gp_id)
        //     .toList();
        // List<OptionsModel> updatedItems = updatedDistrict
        //     .map((model) => OptionsModel(
        //         name: model.name.toString(),
        //         values: model.value,
        //         flag: 'tabVillage'))
        //     .toList();
        options.addAll(updatedDistrict);
        if (updatedDistrict.length == 1) {
          defaultDisableDailog(item.fieldname!, item.options!);
        }
      }
    } else if (item.fieldtype == 'Link' &&
        item.fieldname == 'creche_id' &&
        item.options == 'Creche') {
      options.removeWhere((element) => element.flag == 'tabCreche');
      var village_id = myMap['village_id'];
      if (village_id != null) {
        var creches = filterCreche(village_id);
        options.addAll(creches);
        if (creches.length == 1) {
          defaultDisableDailog(item.fieldname!, item.options!);
        }
      }
    }
    List<OptionsModel> items = options
        .where((element) => element.flag == 'tab${item.options}')
        .toList();

    var selectedValue = myMap[item.fieldname];
    if (selectedValue != null) {
      if (items.where((element) => element.name == selectedValue).length == 0) {
        myMap.remove(item.fieldname);
      }
    }

    return items;
  }

  List<OptionsModel> filterCreche(String villageId) {
    List<CresheDatabaseResponceModel> filteredRecords = [];
    filteredRecords = allCrecheRecords
        .where((element) =>
            Global.getItemValues(element.responces, 'village_id') == villageId)
        .toList();
    List<OptionsModel> crecheOptionsList = [];
    filteredRecords.forEach((element) {
      var item = OptionsModel(
        name: element.name.toString(),
        flag: 'tabCreche',
        values: Global.getItemValues(element.responces, 'creche_name'),
      );
      crecheOptionsList.add(item);
    });
    return crecheOptionsList;
  }
}
