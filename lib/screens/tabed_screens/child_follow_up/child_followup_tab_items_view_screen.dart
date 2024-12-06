import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/database/helper/enrolled_children/enrolled_children_responce_helper.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/follow_up/child_followUp_response_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class ChildFollowupTabItemsViewScreen extends StatefulWidget {
  final String child_followup_guid;
  final String child_referral_guid;
  final String followup_visit_date;
  final String schedule_date;
  final String discharge_date;
  final int creche_id;
  final int? child_id;
  final String enrolChildGuid;
  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;
  ChildFollowupTabItemsViewScreen(
      {super.key,
      required this.child_followup_guid,
      required this.child_referral_guid,
      required this.discharge_date,
      required this.followup_visit_date,
      required this.schedule_date,
      required this.creche_id,
      required this.child_id,
      required this.enrolChildGuid,
      required this.tabBreakItem,
      required this.screenItem,
      required this.changeTab,
      required this.tabIndex,
      required this.totalTab});

  @override
  State<ChildFollowupTabItemsViewScreen> createState() =>
      _ChildFollowupTabItemsViewScreenState();
}

class _ChildFollowupTabItemsViewScreenState
    extends State<ChildFollowupTabItemsViewScreen> {
  List<OptionsModel> options = [];
  List<TabFormsLogic> logics = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translats = [];
  List<DateTime> datesList = [];
   // DateTime? childReffrenDate;
  String userName = '';
  String lng = 'eng';
  String? role;
  bool _isLoading = true;
  String? saveNext = CustomText.Next;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    // List<int> dateCuuten = widget.discharge_date.split('-').map(int.parse).toList();
    // childReffrenDate=DateTime(dateCuuten[0], dateCuuten[1], dateCuuten[2]).subtract(Duration(days:1));
   userName = (await Validate().readString(Validate.userName))!;
    role = await Validate().readString(Validate.role);
    userName = (await Validate().readString(Validate.userName))!;
    List<String> valueNames = [
      CustomText.Creches,
      CustomText.Next,
      CustomText.back,
      CustomText.ok,
      CustomText.childrenCountVallidattion,
      CustomText.Yes,
      CustomText.No
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
        .then((value) => translats = value);

    // attendecedRecord = await ChildAttendenceHelper()
    //     .callChildAttendencesByGuid(widget.ChildAttenGUID);
    // await _fetchUnpicableDates();
    // await fetchFollowUpsDateslist();
    await updateHiddenValue();
    await callScrenControllers('Child Follow up');
    if (widget.tabIndex == (widget.totalTab - 1)) {
      saveNext = CustomText.saveEnrolled;
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> fetchFollowUpsDateslist() async {
  //   var responseList = await ChildFollowUpTabResponseHelper()
  //       .getFollowUpesponsebyEnrollGuid(widget.enrolChildGuid);

  //   if (responseList.isNotEmpty) {
  //     responseList.forEach((element) {
  //       datesList.add(DateTime.parse(
  //           Global.getItemValues(element.responces!, 'followup_visit_date')));
  //     });
  //   }
  // }

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
                    // SizedBox(width: 10),
                    // role == 'Creche Supervisor'
                    //     ? widget.tabIndex == (widget.totalTab - 1)
                    //         ? SizedBox()
                    //         : Expanded(
                    //             child: CElevatedButton(
                    //               color: Color(0xff5979AA),
                    //               onPressed: () {
                    //                 saveOnly(1, context);
                    //                 // widget.changeTab(1);
                    //               },
                    //               text: Global.returnTrLable(
                    //                       translats, 'Save', lng)
                    //                   .trim(),
                    //             ),
                    //           )
                    //     : SizedBox(),
                    // // ]
                    // // ),
                    // role == 'Creche Supervisor'
                    //     ? widget.tabIndex == (widget.totalTab - 1)
                    //         ? SizedBox()
                    //         : SizedBox(width: 10)
                    //     : SizedBox(),
                    // Expanded(
                    //   child: CElevatedButton(
                    //     color: Color(0xff369A8D),
                    //     onPressed: () {
                    //       nextTab(1, context);
                    //       // widget.changeTab(1);
                    //     },
                    //     text: widget.tabIndex == (widget.totalTab - 1)
                    //         ? (Global.returnTrLable(
                    //             translats, CustomText.Submit, lng))
                    //         : Global.returnTrLable(
                    //             translats, CustomText.Next, lng),
                    //   ),
                    // ),
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

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd,
          // readable: role == 'Creche Supervisor' ? false : true,
          readable: true,
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
          // minDate: childReffrenDate,
          isRequred: quesItem.reqd,
          readable: true,
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
          isRequred: quesItem.reqd,
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          maxline: (quesItem.length != 0) ? quesItem.length! % 35 : 1,
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!, logics),
          // readable: role == 'Creche Supervisor'
          //     ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
          //     : true,
          readable: true,
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
          isRequred: quesItem.reqd,
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          // readable: role == 'Creche Supervisor'
          //     ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
          //     : true,
          readable: true,
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
      // case 'Check':
      //   return DynamicCustomCheckboxWithLabel(
      //     label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
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
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: translats,
          lng: lng,
          // readable: role == 'Creche Supervisor'
          //     ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
          //     : true,
          readable: true,
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
          isRequred: quesItem.reqd,
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          // readable: role == 'Creche Supervisor'
          //     ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
          //     : true,
          readable: true,
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
          isRequred: quesItem.reqd,
          maxlength: quesItem.length,
          // readable: role == 'Creche Supervisor'
          //     ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
          //     : true,
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
          isRequred: quesItem.reqd,
          maxlength: quesItem.length,
          // readable: role == 'Creche Supervisor'
          //     ? DependingLogic().callReadableLogic(logics, myMap, quesItem)
          //     : true,
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
      // case 'Long Text':
      //   return CustomImageDynamic(
      //     assetPath:myMap[quesItem.fieldname!],
      //     titleText:
      //     Global.returnTrLable(translats, quesItem.label!.trim(), lng),
      //     isRequred: quesItem.reqd,
      //     onChanged: (value) {
      //       print('Entered text: $value');
      //       myMap[quesItem.fieldname!] = value;
      //       setState(() {});
      //     },
      //   );
      case 'Float':
        return DynamicCustomTextFieldFloat(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd,
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          // readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          readable: true,
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
            // ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content:
            //     Text(
            //         Global.returnTrLable(translats,CustomText.plsFilManForm,lng))));
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
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(validationMsg!)),
          // );
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
      var responcesJs = jsonEncode(myMap);
      var name = myMap['name'];
      print(responcesJs);
      await ChildFollowUpTabResponseHelper().insertUpdate(
          widget.child_followup_guid,
          widget.enrolChildGuid,
          name as int?,
          responcesJs,
          myMap['schedule_date'],
          userName,
          widget.creche_id,widget.child_referral_guid,widget.followup_visit_date);
    }
  }

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        if (widget.tabIndex < (widget.totalTab - 1)) {
          await saveDataInData();
        }
        else if (widget.tabIndex == (widget.totalTab - 1)) {
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
                .callCrechInOptionID(items[i].options!.trim(),widget.creche_id)
                .then((data) {
              options.addAll(data);
            });
            defaultDisableDailog(items[i].fieldname!, items[i].options!);
          }
          else if (items[i].options == 'Partner') {
            await OptionsModelHelper()
                .getPartnerMstCommonOptions(
                items[i].options!.trim(), responseData)
                .then((data) {
              options.addAll(data);
            });
            defaultDisableDailog(items[i].fieldname!, items[i].options!);
          }
          else {
            await OptionsModelHelper()
                .getLocationData(items[i].options!.trim(), responseData,lng)
                .then((data) {
              options.addAll(data);
            });
          }
        }else {
          if(items[i].ismultiselect==1) {
            defaultCommon.add('tab${items[i].multiselectlink!.trim()}');
          }else defaultCommon.add('tab${items[i].options!.trim()}');
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
    var alredRecord = await ChildFollowUpTabResponseHelper()
        .getChildFollowUpResponcewithGuid(widget.child_followup_guid);
    if (alredRecord.isNotEmpty) {
      if(Global.validString(alredRecord[0].responces)) {
        Map<String, dynamic> responseData = jsonDecode(
            alredRecord[0].responces!);
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
      }else{
        var crecheDetails =
        await CrecheDataHelper().getCrecheResponceItem(widget.creche_id);
        if (crecheDetails.length > 0) {
          myMap['childenrolledguid'] = widget.enrolChildGuid;
          myMap['appcreated_by'] = userName;
          myMap['appcreated_on'] = Validate().currentDateTime();
          myMap['child_id'] = widget.child_id.toString();
          myMap['creche_id'] = widget.creche_id.toString();
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
          myMap['followup_visit_date'] = widget.followup_visit_date;
        }
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
        myMap['followup_visit_date'] = widget.followup_visit_date;
      }
    }
    myMap['child_referral_guid'] = widget.child_referral_guid;
    myMap['child_followup_guid'] = widget.child_followup_guid;
    myMap['childenrolledguid'] = widget.enrolChildGuid;
  }
}
