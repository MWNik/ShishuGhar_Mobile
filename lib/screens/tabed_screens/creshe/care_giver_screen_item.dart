import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/database/helper/creche_helper/creche_care_giver_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/caregiver_responce_model.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/house_hold_tab_responce_model.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/depending_logic.dart';

import 'package:shishughar/utils/validate.dart';
import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';

class CareGiverScreenItem extends StatefulWidget {
  final String CGGuid;
  final String crechedCode;
  final int parentName;
  final String tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;
  final bool isEditable;

  const CareGiverScreenItem({
    super.key,
    required this.CGGuid,
    required this.crechedCode,
    required this.tabBreakItem,
    required this.screenItem,
    required this.changeTab,
    required this.tabIndex,
    required this.totalTab,
    required this.parentName,
    required this.isEditable,
  });

  @override
  _CareGiverScreenItemState createState() => _CareGiverScreenItemState();
}

class _CareGiverScreenItemState extends State<CareGiverScreenItem> {
  bool _isLoading = true;
  List<HouseHoldTabResponceMosdel> retrivedList = [];
  List<OptionsModel> options = [];
  DependingLogic? logic;
  Map<String, dynamic> myMap = {};
  List<Translation> translats = [];
  String userName = '';
  String? saveNext = CustomText.Submit;
  String? responce;
  String lng = "en";
  // List<Translation> translats = [];
  String? role;
  Map<String, FocusNode> _focusNode = {};
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    calinitialScreen();
    var items = widget.screenItem[widget.tabBreakItem]!;
    for (var elements in items) {
      _focusNode.addEntries([MapEntry(elements.fieldname!, FocusNode())]);
    }
    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value) {
        _focusNode.forEach((_, focusNode) => focusNode.unfocus());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.forEach((_, focusNode) => focusNode.dispose());
    super.dispose();
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
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cWidget(widget.tabBreakItem),
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
                        // ch(2);
                        nextTab(0);
                      },
                      text:
                          Global.returnTrLable(translats, CustomText.back, lng)
                              .trim(),
                    ),
                  ),
                  widget.isEditable ? SizedBox(width: 10) : SizedBox(),
                  widget.isEditable
                      ? Expanded(
                          child: CElevatedButton(
                            color: Color(0xff369A8D),
                            onPressed: () {
                              nextTab(1);
                              // widget.changeTab(1);
                            },
                            text: Global.returnTrLable(translats, saveNext, lng)
                                .trim(),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      );
    }
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

  widgetTypeWidget(
    int index,
    HouseHoldFielItemdModel quesItem,
  ) {
    // if (quesItem.fieldtype == CustomText.columnBreak) {
    //   return Divider(
    //       color: Colors
    //           .grey); // You can customize the color and thickness of the Divider as needed
    // }
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();

        return DynamicCustomDropdownField(
          hintText:
              Global.returnTrLable(translats, CustomText.select_here, lng),
          focusNode: _focusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          items: items,
          selectedItem: myMap[quesItem.fieldname],
          readable: quesItem.fieldname == 'reason_for_caregiver_exit'
              ? null
              : widget.isEditable == true
                  ? null
                  : !widget.isEditable,
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
          focusNode: _focusNode[quesItem.fieldname],
          initialvalue: myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          readable: widget.isEditable == true
              ? null
              : quesItem.fieldname == 'date_of_leaving'
                  ? null
                  : !widget.isEditable,
          calenderValidate: logic!.calenderValidation(myMap, quesItem),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
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
          focusNode: _focusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          maxlength: quesItem.length,
          readable: widget.isEditable
              ? logic!.callReadableLogic(myMap, quesItem)
              : !widget.isEditable,
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
          focusNode: _focusNode[quesItem.fieldname],
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          readable: widget.isEditable
              ? logic!.callReadableLogic(myMap, quesItem)
              : !widget.isEditable,
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
      //       // if (value > 0)
      //         myMap[quesItem.fieldname!] = value;
      //       // else
      //       //   myMap.remove(quesItem.fieldname);
      //       setState(() {});
      //     },
      //   );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          focusNode: _focusNode[quesItem.fieldname],
          maxline: 3,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: widget.isEditable
              ? logic!.callReadableLogic(myMap, quesItem)
              : !widget.isEditable,
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
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
          readable: role == CustomText.crecheSupervisor
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
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          focusNode: _focusNode[quesItem.fieldname],
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          readable: widget.isEditable
              ? logic!.callReadableLogic(myMap, quesItem)
              : !widget.isEditable,
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
          focusNode: _focusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          readable: widget.isEditable
              ? logic!.callReadableLogic(myMap, quesItem)
              : !widget.isEditable,
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
      //       assetPath:myMap[quesItem.fieldname!],
      //     titleText:
      //     Global.returnTrLable(translats, quesItem.label!.trim(), lng),
      //     isRequred: quesItem.reqd==1?quesItem.reqd:logic!.dependeOnMendotory( myMap, quesItem),
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
    lng = (await Validate().readString(Validate.sLanguage))!;
    var alredRecord = await CrecheCareGiverHelper()
        .geCareGiverResponceItem(widget.parentName, widget.CGGuid);
    Map<String, dynamic> responseData = {};
    if (alredRecord.isNotEmpty) {
      responseData = jsonDecode(alredRecord[0].responces!);
    }
    List<HouseHoldFielItemdModel> items =
        widget.screenItem[widget.tabBreakItem]!;
    await updateHiddenValue();
    List<String> defaultCommon = [];
    List<String> logicFields = [];

    for (int i = 0; i < items.length; i++) {
      if (Global.validString(items[i].options)) {
        if (!(items[i].options == 'Creche')) {
          if ((items[i].options == 'State') ||
              (items[i].options == 'District') ||
              (items[i].options == 'Block') ||
              (items[i].options == 'Gram Panchayat') ||
              (items[i].options == 'Village') ||
              (items[i].options == 'User') ||
              (items[i].options == 'Partner')) {
            if (items[i].options == 'Partner') {
              await OptionsModelHelper()
                  .getPartnerMstCommonOptions(
                      items[i].options!.trim(), responseData)
                  .then((data) {
                options.addAll(data);
              });
            } else {
              await OptionsModelHelper()
                  .getLocationData(items[i].options!.trim(), responseData, lng)
                  .then((data) {
                options.addAll(data);
              });
            }
            defaultDisableDailog(items[i].fieldname!, items[i].options!);
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
  }

  Future<void> calinitialScreen() async {
    userName = (await Validate().readString(Validate.userName))!;
    role = (await Validate().readString(Validate.role))!;
    await setLabelTextData();
    await TranslationDataHelper()
        .callCresheTranslate()
        .then((value) => translats.addAll(value));
    await callScrenControllers(CustomText.crecheCaregiver);
    await FormLogicDataHelper()
        .callFormLogic(CustomText.crecheCaregiver)
        .then((data) {
      logic = DependingLogic(translats, data, lng);
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

  nextTab(int type) async {
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

  bool _checkValidation() {
    var validStatus = true;
    var items = widget.screenItem[widget.tabBreakItem];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        var element = items[i];
        if (element.reqd == 1) {
          var valuees = myMap[element.fieldname];
          if (!Global.validString(valuees.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(translats, CustomText.plsFilManForm, lng!),
                Global.returnTrLable(translats, CustomText.ok, lng!),
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
              Global.returnTrLable(translats, CustomText.ok, lng!),
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

  String getItemValues(String response, String key) {
    String returnValue = "";
    Map<String, dynamic> itemresponse = jsonDecode(response);
    var value = itemresponse[key];
    if (value != null) {
      returnValue = value.toString();
    }
    return returnValue;
  }

  Future<void> saveDataInData() async {
    var widgets = widget.screenItem[widget.tabBreakItem];
    if (widgets != null) {
      Map<String, dynamic> responces = {};
      widgets.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
      });
      var responcesJs = jsonEncode(myMap);
      String? name = myMap['name'];
      print(responcesJs);
      var item = CareGiverResponceModel(
        name: name,
        CGGUID: widget.CGGuid,
        parent: widget.parentName,
        responces: responcesJs,
        is_edited: 1,
        created_at: myMap['appcreated_on'],
        created_by: myMap['appcreated_by'],
        update_at: myMap['app_updated_on'],
        updated_by: myMap['app_updated_by'],
      );
      await CrecheCareGiverHelper()
          .insertupdate(item, widget.parentName, widget.CGGuid, name);
      await CrecheDataHelper().callCrecheIsEdited(widget.parentName);
    }
  }

  Future<void> updateHiddenValue() async {
    var alredRecord = await CrecheCareGiverHelper()
        .geCareGiverResponceItem(widget.parentName, widget.CGGuid);

    if (alredRecord.length > 0) {
      // var list =
      //     allFields!.where((element) => element.fieldtype == 'Date').toList();
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData.forEach((key, value) {
        // var newlist =
        //     list.where((element) => element.fieldname == key).toList();
        // if (newlist.length > 0) {
        //   myMap[key] = Validate().convertDate(value);
        // } else {
        myMap[key] = value;
        // }
      });

      if (responseData['appcreated_on'] != null ||
          responseData['appcreated_by'] != null) {
        myMap['app_updated_on'] = Validate().currentDateTime();
        myMap['app_updated_by'] = userName;
      } else {
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
      }
    } else {
      myMap['caregiver_code'] =
          Validate().autoCrecheCareGiverCode(widget.crechedCode);
      myMap['appcreated_by'] = userName;
      myMap['appcreated_on'] = Validate().currentDateTime();
    }

    myMap['cgguid'] = widget.CGGuid;
    if (myMap['is_active'] == null) {
      myMap['is_active'] = 1;
    }
  }

  Future<void> setLabelTextData() async {
    List<String> valueNames = [
      CustomText.ok,
      CustomText.back,
      CustomText.Save,
      CustomText.plsFilManForm,
      CustomText.dataSaveSuc,
      CustomText.Yes,
      CustomText.No,
      CustomText.Submit,
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
  }
}
