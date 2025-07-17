import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar_child.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_children_field_helper.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamin_multi_check_screen.dart';
import '../../../database/helper/dynamic_screen_helper/house_hold_children_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_field_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../utils/globle_method.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../house_hold/depending_logic.dart';

class EnrolledChilrenTabItemView extends StatefulWidget {
  final String EnrolledChilGUID;
  final String cHHGuid;
  final int HHname;
  final int crecheId;
  final String? childName;
  final String? childId;

  const EnrolledChilrenTabItemView(
      {super.key,
      required this.EnrolledChilGUID,
      required this.cHHGuid,
      required this.HHname,
      required this.crecheId,
      this.childId,
      this.childName});

  @override
  _EnrolledChilrenTabItemViewState createState() =>
      _EnrolledChilrenTabItemViewState();
}

class _EnrolledChilrenTabItemViewState
    extends State<EnrolledChilrenTabItemView> {
  bool _isLoading = true;
  bool shouldEditMesure = true;
  List<HouseHoldTabResponceHelper> retrivedList = [];
  List<OptionsModel> options = [];
  DependingLogic? logic;
  List<HouseHoldFielItemdModel> multselectItemTab = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translats = [];
  String userName = '';
  String? saveNext = CustomText.Next;
  String? responce;
  String? role;
  String lng = 'eng';
  Map<String, List<HouseHoldFielItemdModel>>? screenItem = {};

  Map<String, List<HouseHoldFielItemdModel>> expendedItems = {};

  List<HouseHoldFielItemdModel>? itemsList;
  HouseHoldFielItemdModel? tabBreakItem;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    userName = (await Validate().readString(Validate.userName))!;
    role = await Validate().readString(Validate.role);
    List<String> valueNames = [
      CustomText.Creches,
      CustomText.Next,
      CustomText.back,
      CustomText.ok,
      CustomText.ChildEnrollsuccess,
      CustomText.enrolled,
      CustomText.ChildProfile,
      CustomText.Yes,
      CustomText.No,
      CustomText.select_here,
      CustomText.typehere,
    ];

    // await EnrolledChildrenFieldHelper()
    //     .getChildDetailFieldsForm()
    //     .then((value) async {
    //   itemsList = value;
    // });
    await EnrolledExitChildrenFieldHelper()
        .callEnrolledExitMeta()
        .then((value) {
      itemsList = value;
    });

    itemsList!.forEach((element) {
      if (Global.validString(element.label)) {
        valueNames.add(element.label!);
      }
    });

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats.addAll(value));

    multselectItemTab =
        await EnrolledChildrenFieldHelper().callMultiSelectTabItem();
    await updateHiddenValue();
    await callScrenControllers('Child Enrollment and Exit');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
        appBar: CustomChildAppbar(
          subTitle1: widget.childName ?? '',
          subTitle2: widget.childId ?? '',
          text: Global.returnTrLable(translats, CustomText.ChildProfile, lng),
          onTap: () => Navigator.pop(context, 'itemRefresh'),
        ),
        body: WillPopScope(
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
                              // children: [Text("hello")],
                              children: cWidget(itemsList!),
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  List<Widget> cWidget(List item) {
    List<Widget> screenItems = [];
    var items = item;
    for (int i = 0; i < items.length; i++) {
      screenItems.add(widgetTypeWidget(i, items[i]));
      screenItems.add(SizedBox(height: 5.h));
      if (!logic!.callDependingLogic(myMap, items[i])) {
        myMap.remove(items[i].fieldname);
      }
    }
      return screenItems;
  }

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> itemsOption = options
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
          items: itemsOption,
          selectedItem: myMap[quesItem.fieldname],
          readable: true,
          isVisible: quesItem.fieldname == 'gender_id'
              ? true
              : logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            if (value != null) {
              myMap[quesItem.fieldname!] = value.name!;
            } else {
              myMap.remove(quesItem.fieldname);
            }
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
          readable: true,
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            var logData = logic!.callDateDiffrenceLogic(myMap, quesItem);
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
              : logic!.dependeOnMendotory(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          readable: true,
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: quesItem.fieldname == 'child_name'
              ? true
              : logic!.callDependingLogic(myMap, quesItem),
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
          responceFieldName: itemResopnceField,
          onChanged: (value) {
            if (value != null) myMap[quesItem.fieldname!] = value;
            // else
            //   myMap.remove(quesItem.fieldname);

            setState(() {});
          },
        );
      // case 'Check':
      //   return DynamicCustomCheckboxWithLabel(
      //     label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
      //     initialValue: myMap[quesItem.fieldname!],
      //     isVisible: logic!.callDependingLogic(myMap,quesItem),
      //     onChanged: (value) {
      //       if(value>0)
      //         myMap[quesItem.fieldname!] = value;
      //       else myMap.remove(quesItem.fieldname);
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
          // readable: true,
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
      case 'Float':
        return DynamicCustomTextFieldFloat(
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          fieldName: quesItem.fieldname!,
          isRequred: quesItem.reqd,
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          readable:
              quesItem.fieldname == 'height' || quesItem.fieldname == 'weight'
                  ? shouldEditMesure
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

  defaultDisableDailogBox(String fieldName, String flag) async {
    var tabName = 'tab$flag';
    var item = options.where((element) => element.flag == tabName).toList();
    if (item.length > 0) {
      myMap[fieldName] = item.first.name!;
    }
  }

  Future<void> callScrenControllers(screen_type) async {
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }

    itemsList = itemsList!.where((element) => (element.hidden == 0)).toList();

    List<String> defaultCommon = [];
    for (int i = 0; i < itemsList!.length; i++) {
      if (Global.validString(itemsList![i].options)) {
        defaultCommon.add('tab${itemsList![i].options!.trim()}');
      }
      if (Global.validString(itemsList![i].options)) {
        if (itemsList![i].options == 'Creche') {
          await OptionsModelHelper()
              .callCrechInOption(itemsList![i].options!.trim(), widget.crecheId)
              .then((data) {
            options.addAll(data);
          });
          defaultDisableDailogBox(
              itemsList![i].fieldname!, itemsList![i].options!);
        }
      }
    }

    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng)
        .then((value) => options.addAll(value));

    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logic = DependingLogic(translats, data, lng);
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> updateHiddenValue() async {
    var alredRecord = await EnrolledExitChilrenResponceHelper()
        .callChildrenResponce(widget.EnrolledChilGUID);

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
      var name = alredRecord[0].name;
      if (name != null) {
        myMap['name'] = name;
      }
      if (Global.validString(responseData['date_of_enrollment'])) {
        DateTime date_of_enrollment =
            DateTime.parse(responseData['date_of_enrollment']);
        if (date_of_enrollment
            .add(Duration(days: 30))
            .isBefore(DateTime.parse(Validate().currentDate()))) {
          shouldEditMesure = true;
        }
      }
    } else {
      var fromHHInfo = await HouseHoldChildrenHelperHelper()
          .callHouseHoldChildrenItem(widget.cHHGuid);
      Map<String, dynamic> responseData = jsonDecode(fromHHInfo[0].responces!);

      responseData.forEach((key, value) {
        if ((key == 'name')) {
          myMap['hh_child_id'] = value;
        } else if (key == 'hhcguid') {
          myMap['chhguid'] = value;
        } else if (key != 'appcreated_on' && key != 'appcreated_by')
          myMap[key] = value;
      });

      myMap['date_of_enrollment'] = Global.initCurrentDate();
      myMap['appcreated_on'] = responseData['appcreated_on'];
      myMap['appcreated_by'] = responseData['appcreated_by'];
    }
    myMap['childenrollguid'] = widget.EnrolledChilGUID;
  }
}
