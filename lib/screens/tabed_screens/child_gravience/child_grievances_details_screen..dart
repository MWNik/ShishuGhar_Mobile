import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/child_gravience/child_grievances_field_helper.dart';
import '../../../database/helper/child_gravience/child_grievances_response_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/child_grievances_response_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class ChildGrievancesDetailScreen extends StatefulWidget {
  final String? child_grievances_guid;
  final String? creche_id;

  const ChildGrievancesDetailScreen({
    super.key,
    required this.child_grievances_guid,
    required this.creche_id,
  });

  @override
  _ChildGrievancesDetailsState createState() => _ChildGrievancesDetailsState();
}

class _ChildGrievancesDetailsState extends State<ChildGrievancesDetailScreen> {
  DependingLogic? logic;
  List<HouseHoldFielItemdModel> allItems = [];
  Map<String, dynamic> myMap = {};
  List<OptionsModel> options = [];
  bool _isLoading = true;
  bool editingRemoved = true;
  String userName = '';
  String? role;
  String? lng = 'en';
  List<Translation> labelControlls = [];
  Map<String, FocusNode> _focusNode = {};
  ScrollController _scrollController = ScrollController();

  List<String> hiddens = [
    'partner_id',
    'state_id',
    'district_id',
    'block_id',
    'gp_id',
    'village_id',
    'creche_id'
  ];

  Future<void> initializeData() async {
    userName = (await Validate().readString(Validate.userName))!;
    role = await Validate().readString(Validate.role);
    lng = (await Validate().readString(Validate.sLanguage))!;
    labelControlls.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.dataSaveSuc,
      CustomText.back,
      CustomText.plsFilManForm,
      CustomText.ok,
      CustomText.ChildHealth,
      CustomText.Submit,
      CustomText.ChildGrievances,
      CustomText.select_here,
      CustomText.typehere,
      CustomText.Yes,
      CustomText.No,
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
        .then((value) => labelControlls.addAll(value));

    await updateHiddenValue();
    await callScrenControllers('Grievance');
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
          appBar: CustomAppbar(
            text: Global.returnTrLable(
                labelControlls, CustomText.ChildGrievances, lng!),
            onTap: () => Navigator.pop(context, 'itemRefresh'),
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: cWidget(),
                          )),
                    )),
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
                        editingRemoved ? SizedBox(width: 10) : SizedBox(),
                        editingRemoved
                            ? Expanded(
                                child: CElevatedButton(
                                color: Color(0xff369A8D),
                                onPressed: () {
                                  nextTab(1, context);
                                },
                                text: Global.returnTrLable(
                                    labelControlls, CustomText.Submit, lng!),
                              ))
                            : SizedBox()
                      ]),
                    ),
                  ],
                )),
    );
  }

  List<Widget> cWidget() {
    List<Widget> screenItems = [];
    if (allItems.length > 0) {
      for (int i = 0; i < allItems.length; i++) {
        screenItems.add(widgetTypeWidget(i, allItems[i]));
        screenItems.add(SizedBox(height: 5.h));
        if (!logic!.callDependingLogic( myMap, allItems[i])) {
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
          hintText: Global.returnTrLable(
              labelControlls, CustomText.select_here, lng!),
          focusNode: _focusNode[quesItem.fieldname],
          readable: !editingRemoved
              ? true
              : logic!.callReadableLogic( myMap, quesItem),
          titleText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory( myMap, quesItem),
          items: items,
          selectedItem: myMap[quesItem.fieldname],
          isVisible:
              logic!.callDependingLogic( myMap, quesItem),
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
          readable: quesItem.fieldname == 'grievance_date' ? true : false,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory( myMap, quesItem),
          calenderValidate:
              logic!.calenderValidation( myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            var logData = logic!
                .callDateDiffrenceLogic( myMap, quesItem);
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
          titleText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          focusNode: _focusNode[quesItem.fieldname],
          titleText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory( myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          readable: !editingRemoved
              ? true
              : logic!.callReadableLogic( myMap, quesItem),
          hintText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isVisible:
              logic!.callDependingLogic( myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          hintText: Global.returnTrLable(labelControlls, CustomText.typehere, lng!),
          focusNode: _focusNode[quesItem.fieldname],
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory( myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          readable: !editingRemoved
              ? true
              : logic!.callReadableLogic( myMap, quesItem),
          titleText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isVisible:
              logic!.callDependingLogic( myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              myMap[quesItem.fieldname!] = value;
              var logData = logic!
                  .callAutoGeneratedValue( myMap, quesItem);
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
      //     label: Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng),
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
          label: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: labelControlls,
          lng: lng!,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory( myMap, quesItem),
          readable: !editingRemoved
              ? true
              : logic!.callReadableLogic( myMap, quesItem),
          isVisible:
              logic!.callDependingLogic( myMap, quesItem),
          onChanged: (value) {
            print('yesNo $value');
            myMap[quesItem.fieldname!] = value;
            setState(() {});
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          focusNode: _focusNode[quesItem.fieldname],
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory( myMap, quesItem),
          maxlength: quesItem.length,
          readable: !editingRemoved
              ? true
              : logic!.callReadableLogic( myMap, quesItem),
          titleText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
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
          titleText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory( myMap, quesItem),
          maxlength: quesItem.length,
          readable: !editingRemoved
              ? true
              : logic!.callReadableLogic( myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          focusNode: _focusNode[quesItem.fieldname],
          maxline: 3,
          titleText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory( myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: !editingRemoved
              ? true
              : logic!.callReadableLogic( myMap, quesItem),
          hintText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isVisible:
              logic!.callDependingLogic( myMap, quesItem),
          onChanged: (value) {
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
    if (lngtr != null) {
      lng = lngtr;
    }
    await ChildGrievancesMetaFieldsHelper()
        .getChildGrievancesMetaFieldsbyScreenType(screen_type)
        .then((value) async {
      allItems = value;
    });
    allItems = allItems
        .where((element) => !(hiddens.contains(element.fieldname)))
        .toList();

    List<String> defaultCommon = [];
    for (int i = 0; i < allItems.length; i++) {
      if (Global.validString(allItems[i].options)) {
        // if (allItems[i].options == 'Grievance Subject') {
        //   await OptionsModelHelper()
        //       .getMstCommonOptions(allItems[i].options!)
        //       .then((value) => options.addAll(value));
        //   defaultDisableDailog(allItems[i].fieldname!, allItems[i].options!);
        // } else {
        defaultCommon.add('tab${allItems[i].options!.trim()}');
        // }
      }
    }
    List<String> _labelTranslats = [];
    for (var elements in allItems) {
      _focusNode.addEntries([MapEntry(elements.fieldname!, FocusNode())]);
      _labelTranslats.add(elements.label!);
    }
    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value) {
        _focusNode.forEach((_, focusNode) => focusNode.unfocus());
      }
    });
    await TranslationDataHelper()
        .callTranslateString(_labelTranslats)
        .then((value) => labelControlls.addAll(value));

    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng!)
        .then((value) => options.addAll(value));

    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logic=DependingLogic(labelControlls, data, lng!);
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

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   initializeData();
  // }

  bool _checkValidation() {
    var validStatus = true;
    var items = allItems;
    if (items.length > 0) {
      for (int i = 0; i < items.length; i++) {
        var element = items[i];
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
            logic!.validationMessge( myMap, element);
        if (Global.validString(validationMsg)) {
          Validate().singleButtonPopup(
              validationMsg!,
              Global.returnTrLable(labelControlls, CustomText.ok, lng!),
              false,
              context);
          ;
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
    if (allItems.length > 0) {
      Map<String, dynamic> responces = {};
      allItems.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
      });
      var responcesJs = jsonEncode(myMap);
      print(responcesJs);
      var healtItem = ChildGrievancesResponceModel(
          grievance_guid: widget.child_grievances_guid,
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
      await ChildGrievancesTabResponceHelper().inserts(healtItem);
    }
  }

  Future<void> updateHiddenValue() async {
    userName = (await Validate().readString(Validate.userName))!;
    var alrecords = await ChildGrievancesTabResponceHelper()
        .getChildEventResponcewithGuid(widget.child_grievances_guid!);
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
      editingRemoved = false;
    } else {
      var creCheDetails = await CrecheDataHelper()
          .getCrecheResponceItem(Global.stringToInt(widget.creche_id));
      if (creCheDetails.length > 0) {
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
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
        myMap['grievance_guid'] = widget.child_grievances_guid;
        myMap['grievance_date'] = Global.initCurrentDate();
        myMap['priority'] = '3';
        myMap['status'] = "1";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.forEach((_, focusNode) => focusNode.dispose());
    super.dispose();
  }
}
