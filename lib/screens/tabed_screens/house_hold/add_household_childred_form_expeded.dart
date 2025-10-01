import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/depending_logic.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/double_button_dailog.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/database_helper.dart';
import '../../../database/helper/dynamic_screen_helper/house_hold_children_helper.dart';
import '../../../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/house_field_item_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';

class AddHouseholdScreenChildrenFromExpended extends StatefulWidget {
  final String hhGuid;
  final String cHHGuid;
  final bool dobisReadable;

  const AddHouseholdScreenChildrenFromExpended(
      {super.key,
      required this.hhGuid,
      required this.cHHGuid,
      required this.dobisReadable});

  @override
  State<AddHouseholdScreenChildrenFromExpended> createState() =>
      _HouseholdScreenState();
}

class _HouseholdScreenState
    extends State<AddHouseholdScreenChildrenFromExpended> {
  bool _isLoading = true; // Change this to true initially
  String? saveNext = CustomText.Submit;
  List<HouseHoldFielItemdModel> tabBreakItems = [];
  List<OptionsModel> options = [];
  int expandableList = 0;
  Map<String, dynamic> myMap = {};
  Map<String, List<HouseHoldFielItemdModel>> expendedItems = {};
  String userName = '';
  List<Translation> translats = [];
  DependingLogic? logic;
  String lng = "en";
  String? houseHoldHeadName;
  String? hhNameTitle = CustomText.hhHeadName;
  String? role;
  bool isEdited = true;
  List<String> dobField = [
    'child_dob','is_dob_available','child_age'
  ];

  @override
  void initState() {
    super.initState();
    callScrenControllers('Household Child Form');
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    if (_isLoading) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    } else {
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, 'itemRefresh');
            return false;
          },
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 60,
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
                // title: Text(
                //   CustomText.hh_detail,
                //   style: Styles.white145,
                // ),
                title: RichText(
                  text: TextSpan(
                    // text: CustomText.hh_detail,
                    // style:Styles.white145,
                    children: (Global.validString(houseHoldHeadName))
                        ? [
                            WidgetSpan(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    Global.returnTrLable(
                                        translats, CustomText.ChildDetails, lng),
                                    style: Styles.white145,
                                  ),
                                  Text(
                                    '${Global.returnTrLable(translats, hhNameTitle, lng)} : ${Global.validToString(houseHoldHeadName)}',
                                    style: Styles.white126P,
                                  ),
                                  // Add additional TextSpans here if needed
                                ],
                              ),
                            ),
                          ]
                        : [
                            WidgetSpan(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    Global.returnTrLable(
                                        translats, 'Children Detail', lng),
                                    style: Styles.white145,
                                  ),
                                  // Add additional TextSpans here if needed
                                ],
                              ),
                            ),
                          ],
                  ),
                ),
                centerTitle: true,
              ),
              // appBar: CustomAppbar(text: CustomText.AddHouseholdListingChild,
              //     onTap: () {
              //   Navigator.pop(context,'itemRefresh');
              // }),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Column(
                  children: [
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tabBreakItems.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      Global.returnTrLable(
                                          translats,
                                          Global.validToString(
                                              tabBreakItems[i].label),
                                          lng),
                                      style: expandableList == i
                                          ? Styles.blue148
                                          : Styles.gray124,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // if (expandableList == i) {
                                      //   expandableList = -1;
                                      // } else {
                                      //   expandableList = i;
                                      // }
                                      // setState(() {});
                                    },
                                    child: Icon(
                                      expandableList == i
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Color(0xffB2B2B2),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              expandableList == i
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: cWidget(tabBreakItems[i].name!),
                                    )
                                  : SizedBox.shrink(),
                              if (i != tabBreakItems.length - 1) Divider(),
                              // Add a Divider after each item except the last one
                            ],
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: CElevatedButton(
                            color: Color(0xffF26BA3),
                            onPressed: () {
                              // Navigator.pop(context);
                              nextTab(0);
                            },
                            text: Global.returnTrLable(translats, 'Back', lng),
                          ),
                        ),
                        role == CustomText.crecheSupervisor
                            ? SizedBox(width: 10)
                            : SizedBox(),
                        role == CustomText.crecheSupervisor
                            ? Expanded(
                                child: CElevatedButton(
                                  color: Color(0xff369A8D),
                                  onPressed: () {
                                    print(myMap);
                                    nextTab(1);
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //   builder: (BuildContext context) => AddHouseholdScreenChildFrom(),
                                    // ));
                                  },
                                  text: Global.returnTrLable(
                                      translats, saveNext, lng),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      );
    }
  }

  List<Widget> cWidget(String itemId) {
    List<Widget> screenItems = [];
    var items = expendedItems[itemId];
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
        if(quesItem.fieldname=='child_status'){
          items.insert(0,OptionsModel(name:'-1',values:CustomText.select_here,
              flag: 'tab${quesItem.options}'));
        }
        return DynamicCustomDropdownField(
          hintText:
              Global.returnTrLable(translats, CustomText.select_here, lng),
          titleText: Global.returnTrLable(translats, quesItem.label, lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          items: items,
          readable: role == CustomText.crecheSupervisor
              ? isEdited
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
              : true,
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          selectedItem: myMap[quesItem.fieldname],
          onChanged: (value) {
            if (value != null)
              myMap[quesItem.fieldname!] = value.name!;
            else
              myMap.remove(quesItem.fieldname);
            if(quesItem.fieldname=='child_status'&&Global.validToString(value?.name)=='-1'){
              myMap.remove(quesItem.fieldname);
            }
            setState(() {});
          },
        );
      case 'Date':
        return CustomDatepickerDynamic(
          fieldName: quesItem.fieldname,
          initialvalue: myMap[quesItem.fieldname!],
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          calenderValidate: logic!.calenderValidation(myMap, quesItem),
          readable: role == CustomText.crecheSupervisor
              ? isEdited
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
              : true,
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = '$value';
            var logData = logic!.callDateDiffrenceLogic(myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);
              }
            }
            setState(() {});
            // checkAgeValidate();
          },
          titleText: Global.returnTrLable(translats, quesItem.label, lng),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText: Global.returnTrLable(translats, quesItem.label, lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          readable: role == CustomText.crecheSupervisor
              ? isEdited
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
              : true,
          initialvalue: myMap[quesItem.fieldname!],
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          hintText: Global.returnTrLable(translats, quesItem.label, lng),
          maxlength: quesItem.length,
          onChanged: (value) {
            print('Entered text: $value');
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
          readable: role == CustomText.crecheSupervisor
              ? isEdited
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
              : true,
          initialvalue: myMap[quesItem.fieldname!],
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          titleText: Global.returnTrLable(translats, quesItem.label, lng),
          maxlength: quesItem.length,
          onChanged: (value) {
            if (value != null)
              myMap[quesItem.fieldname!] = value;
            else {
              myMap.remove(quesItem.fieldname);
              // setState(() {});
            }
          },
        );
      // case 'Check':
      //   return DynamicCustomCheckboxWithLabel(
      //     label: Global.returnTrLable(translats,quesItem.label,lng),
      //     initialValue: myMap[quesItem.fieldname!],
      //     readable: role=='Creche Supervisor'?logic!.callReadableLogic( myMap, quesItem):true,
      //     isVisible: logic!.callDependingLogic(myMap,quesItem),
      //     onChanged: (value) {
      //       print("checkVa $value");
      //       // if(value>0)
      //         myMap[quesItem.fieldname!] = value;
      //       // else myMap.remove(quesItem.fieldname);
      //       setState(() {});
      //     },
      //   );

      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: translats,
          lng: lng,
          isRequred: quesItem.fieldname == 'is_dob_available'
              ? 1
              : (quesItem.reqd == 1
                  ? quesItem.reqd
                  : logic!.dependeOnMendotory(myMap, quesItem)),
          readable: role == CustomText.crecheSupervisor
              ? isEdited
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
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
          readable: role == CustomText.crecheSupervisor
              ? isEdited
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
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
          readable: role == CustomText.crecheSupervisor
              ? isEdited
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
              : true,
          titleText: Global.returnTrLable(translats, quesItem.label, lng),
          initialvalue: myMap[quesItem.fieldname!],
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            myMap[quesItem.fieldname!] = value;
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          titleText: Global.returnTrLable(translats, quesItem.label, lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          readable: role == CustomText.crecheSupervisor
              ? isEdited == false
                  ? logic!.callReadableLogic(myMap, quesItem)
                  : true
              : true,
          initialvalue: myMap[quesItem.fieldname!],
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            myMap[quesItem.fieldname!] = value;
          },
        );
      default:
        return SizedBox();
    }
  }

  Future<void> callScrenControllers(screen_type) async {
    userName = (await Validate().readString(Validate.userName))!;
    role = await Validate().readString(Validate.role);
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    await updateHiddenValue(screen_type);
    await TranslationDataHelper()
        .callTranslate()
        .then((value) => translats.addAll(value));
    await callHHHeadName();
    List<HouseHoldFielItemdModel> allItems = [];
    List<HouseHoldFielItemdModel> tempBreakDown = [];
    await HouseHoldFieldHelper()
        .getHouseHoldFieldsForm(screen_type)
        .then((value) async {
      allItems = value;
      tabBreakItems = allItems
          .where((element) => element.fieldtype == 'Section Break')
          .toList();
    });

    for (int i = 0; i < tabBreakItems.length; i++) {
      List<HouseHoldFielItemdModel> temp = [];
      int idxI = tabBreakItems[i].idx!;
      idxI = idxI + 1;
      temp = allItems
          .where((element) =>
              element.fieldtype == 'Datetime' && element.idx == idxI)
          .toList();
      if (temp.length > 0) {
        tempBreakDown.add(tabBreakItems[i]);
      }
    }

    tempBreakDown.forEach((element) {
      tabBreakItems.remove(element);
    });

    for (int i = 0; i < tabBreakItems.length; i++) {
      if (i < (tabBreakItems.length) - 1) {
        var filtredItem = allItems
            .where((element) =>
                element.idx! > tabBreakItems[i].idx! &&
                element.idx! < tabBreakItems[i + 1].idx!)
            .toList();
        expendedItems[tabBreakItems[i].name!] = filtredItem;
      } else {
        var filtredItem = allItems
            .where((element) => element.idx! > tabBreakItems[i].idx!)
            .toList();
        expendedItems[tabBreakItems[i].name!] = filtredItem;
      }
    }

    print("expendedItemsItem ${expendedItems}");
    // await HouseHoldFieldHelper().getHouseHoldFieldsForm(screen_type).then((value) async {

    // screensWidget = value;
    List<String> logicFields = [];
    for (int i = 0; i < allItems.length; i++) {
      if (Global.validString(allItems[i].options)) {
        if (!(allItems[i].options == 'Household Child Form')) {
          if ((allItems[i].options == 'State') ||
              (allItems[i].options == 'District') ||
              (allItems[i].options == 'Block') ||
              (allItems[i].options == 'Gram Panchayat') ||
              (allItems[i].options == 'Village')) {
            await OptionsModelHelper()
                .getOptions(allItems[i].options!.trim())
                .then((data) {
              options.addAll(data);
            });
          }
        }
      }
      logicFields.add(allItems[i].fieldname!);
    }
    var alredRecord =
        await HouseHoldTabResponceHelper().getHouseHoldResponce(widget.hhGuid);
    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      houseHoldHeadName = responseData['hosuehold_head_name'];
    }
    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logic = DependingLogic(translats, data, lng);
    });
    await OptionsModelHelper().getAllMstCommonOptions(lng).then((data) {
      options.addAll(data);
    });
    print("opiotin ${options.length}");
    setState(() {
      _isLoading = false;
    });
  }

  nextTab(int type) async {
    if (role == 'Creche Supervisor') {
      if (type == 1) {
        if (checkValidation()) {
          if (expandableList < (tabBreakItems.length - 1)) {
            await saveDataInData(tabBreakItems[expandableList]);
            expandableList = expandableList + 1;
            // if (expandableList == ((tabBreakItems.length) - 1)) {
            //   saveNext = "Save";
            // }
          } else if (expandableList == (tabBreakItems.length - 1)) {
            await saveDataInData(tabBreakItems[expandableList]);

            if (expandableList == ((tabBreakItems.length) - 1)) {
              await updateHHDetailsName(widget.hhGuid);

              bool shouldProceed = await showDialog(
                context: context,
                builder: (context) {
                  return SingleButtonPopupDialog(
                      message: Global.returnTrLable(
                          translats, CustomText.dataSaveSuc, lng),
                      button:
                          Global.returnTrLable(translats, CustomText.ok, lng));
                },
              );
              if (shouldProceed) {
                if (shouldProceed == true) {
                  Navigator.pop(context, 'itemRefresh');
                }
              }
            }
          }
          // setState(() {});
        }
      } else {
        if (expandableList > 0) {
          expandableList = expandableList - 1;
          // saveNext = "Next";
          setState(() {});
        } else {
          Navigator.pop(context, 'itemRefresh');
        }
      }
    } else {
      if (type == 1) {
        if (expandableList < (tabBreakItems.length - 1)) {
          expandableList = expandableList + 1;
        } else if (expandableList == (tabBreakItems.length - 1)) {
          if (expandableList == ((tabBreakItems.length) - 1)) {
            Navigator.pop(context, 'itemRefresh');
          }
        }
      } else {
        if (expandableList > 0) {
          expandableList = expandableList - 1;
          // saveNext = "Next";
          setState(() {});
        } else {
          Navigator.pop(context, 'itemRefresh');
        }
      }
    }
  }

  bool checkValidation() {
    var validStatus = true;
    var items = expendedItems[tabBreakItems[expandableList].name];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        var element = items[i];
        if (element.reqd == 1) {
          var valuees = myMap[element.fieldname];
          if (!Global.validString(valuees.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(
                    translats, 'Please fill all mandatory fields!', lng),
                Global.returnTrLable(translats, CustomText.ok, lng),
                false,
                context);

            validStatus = false;
            break;
          }
        } else if (element.fieldname == 'is_dob_available') {
          var valuees = myMap[element.fieldname];
          if (!Global.validString(valuees.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(
                    translats, 'Please fill all mandatory fields!', lng),
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
    } else {
      print("selected items is null");
    }

    return validStatus;
  }

  Future<void> saveDataInData(HouseHoldFielItemdModel item) async {
    var widgets = expendedItems[item.name];
    if (widgets != null) {
      Map<String, dynamic> responces = {};
      widgets.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
      });
      var responcesJs = jsonEncode(myMap);
      var name = myMap['name'];
      var parent = myMap['parent'];
      print(responcesJs);
      await HouseHoldChildrenHelperHelper().insertUpdate(
          widget.hhGuid,
          widget.cHHGuid,
          responcesJs,
          userName,
          name,
          parent,
          myMap['appcreated_on'],
          myMap['appupdated_on']);
    }
  }

  Future<void> updateHiddenValue(String scrrenName) async {
    var items =
        await HouseHoldFieldHelper().getHouseHoldFieldsHiddenField(scrrenName);
    var alredRecord = await HouseHoldChildrenHelperHelper()
        .getHouseHoldChildrenItem(widget.hhGuid, widget.cHHGuid);
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
        } else if (element.fieldname == 'hhcguid') {
          myMap[element.fieldname!] = widget.cHHGuid;
        } else if (element.fieldname == 'appupdated_on') {
          myMap[element.fieldname!] = Validate().currentDateTime();
        } else if (element.fieldname == 'appupdated_by') {
          myMap[element.fieldname!] = userName;
        }
        if (alredRecord[0].name != null) {
          myMap['name'] = alredRecord[0].name;
        }
        if (alredRecord[0].parent != null) {
          myMap['parent'] = alredRecord[0].parent;
        }
      });
    } else {
      hiddenIten.forEach((element) {
        if (element.fieldname == 'hhguid') {
          myMap[element.fieldname!] = widget.hhGuid;
        } else if (element.fieldname == 'hhcguid') {
          myMap[element.fieldname!] = widget.cHHGuid;
        } else if (element.fieldname == 'appcreated_on') {
          myMap[element.fieldname!] = Validate().currentDateTime();
        } else if (element.fieldname == 'appcreated_by') {
          myMap[element.fieldname!] = userName;
        }
      });
    }
    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData.forEach((key, value) {
        myMap[key] = value;
      });
      if (myMap['child_dob'] != null) {
        myMap['child_age'] = Validate()
            .calculateAgeInMonths(Validate().stringToDate(myMap['child_dob']));
      }

      var enItems = await EnrolledExitChilrenResponceHelper()
          .enrolledChildByCHHGUID(widget.cHHGuid);
      if (enItems.length > 0) {
        isEdited = false;
      }
    }
  }

  Future<void> saveChildren() async {
    var shouldProceed = await showDialog(
      context: context,
      builder: (context) {
        return DoubleButtonDailog(
          posButton: Global.returnTrLable(translats, 'Yes', lng),
          negButton: Global.returnTrLable(translats, 'No', lng),
          message: Global.returnTrLable(translats, 'Do you want to Save?', lng),
        );
      },
    );

    if (shouldProceed) {
      Navigator.pop(context, 'itemRefresh');
    }
  }

  Future<String> callHHHeadName() async {
    var alredRecord =
        await HouseHoldTabResponceHelper().getHouseHoldResponce(widget.hhGuid);
    if (alredRecord.isNotEmpty) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      var hh = responseData['hosuehold_head_name'];
      houseHoldHeadName = hh;
    }
    // var hhNL=await HouseHoldFieldHelper().callTabItem('hosuehold_head_name');
    // if(hhNL.length>0){
    //   hhNameTitle=hhNL[0].label!;
    // }
    await setLabelTextData();
    if (hhNameTitle != null) {
      // var lngtr = await Validate().readString(Validate.sLanguage);
      // var hhTitle = await TranslationDataHelper().getTranslation(
      //     hhNameTitle!, lngtr!);
      var hhTitle = Global.returnTrLable(translats, CustomText.hhHeadName, lng);
      return hhTitle;
    } else
      return "";
  }

  Future<void> setLabelTextData() async {
    List<String> valueNames = [
      'Please fill all mandatory fields!',
      'Back',
      'Next',
      CustomText.Save,
      CustomText.hhHeadName,
      CustomText.dataSaveSuc,
      CustomText.ChildDetails,
      'Do you want to Save?',
      'Yes',
      'No',
      'Children Detail',
      CustomText.ok,
      'Please fill all mandatory fields!',
      hhNameTitle!,
      CustomText.Yes,
      CustomText.No,
      CustomText.select_here,
      CustomText.typehere,
      CustomText.Submit,
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
    await TranslationDataHelper().callTranslateString(valueNames).then((value) {
      translats.addAll(value);
    });
  }

  Future<void> updateHHDetailsName(String hhGuid) async {
    var alredRecord =
        await HouseHoldTabResponceHelper().getHouseHoldResponce(hhGuid);
    if (alredRecord.length > 0) {
      if (alredRecord[0].name != null) {
        Map<String, dynamic> responseData =
            jsonDecode(alredRecord[0].responces!);
        responseData['name'] = alredRecord[0].name;
        var hhDtaResponce = jsonEncode(responseData);
        await DatabaseHelper.database!.rawQuery(
            'UPDATE house_hold_responce SET  responces = ? , is_uploaded=0 , is_edited=1 where HHGUID=?',
            [hhDtaResponce, hhGuid]);
        // }
      }
    }
  }
}
