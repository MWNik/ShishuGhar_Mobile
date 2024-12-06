import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/model/dynamic_screen_model/creche_monitering_checkList_cbm_response_model.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_time_picker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/cmc_cbm/creche_monitering_checklist_CBM_response_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class CmcCBMTabItemSCreen extends StatefulWidget {
  final String cbmguid;
  final String creche_id;
  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;
  String? date_of_visit;
  final bool isEdit;

  CmcCBMTabItemSCreen({
    required this.cbmguid,
    required this.creche_id,
    required this.tabBreakItem,
    required this.screenItem,
    required this.changeTab,
    required this.tabIndex,
    required this.totalTab,
    this.date_of_visit,
    required this.isEdit,
  });

  @override
  State<CmcCBMTabItemSCreen> createState() => _CmcCBMTabItemSCreenState();
}

class _CmcCBMTabItemSCreenState extends State<CmcCBMTabItemSCreen> {
  List<String> unpicableDates = [];
  String? _role;
  String username = '';
  String _language = 'en';

  List<OptionsModel> _options = [];
  List<TabFormsLogic> _logics = [];
  List<Translation> _translation = [];
  bool _isLoading = true;
  int? isEditExisting;
  Map<String, dynamic> _myMap = {};
  var applicableDate = Validate().stringToDate("2024-12-31");
  var now = DateTime.parse(Validate().currentDate());

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    var date = await Validate().readString(Validate.date);
    applicableDate = Validate().stringToDate(date ?? "2024-12-31");
    _role = await Validate().readString(Validate.role);
    username = (await Validate().readString(Validate.userName))!;

    List<String> valueNames = [
      CustomText.Creches,
      CustomText.Next,
      CustomText.back,
      CustomText.ok,
      CustomText.ChildEnrollsuccess
    ];

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => _translation.addAll(value));

    await updateExistingFields();

    await _callScreenControllers('Creche Monitoring Checklist CBM');
    setState(() {
      _isLoading = false;
    });
  }

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
                          children: _widgetList(widget.tabBreakItem.name!),
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
                                    _translation, CustomText.back, _language)
                                .trim(),
                          ),
                        ),
                        // Row(children: [
                        SizedBox(width: 10),
                        _role == 'Creche Supervisor'
                            ? widget.tabIndex == (widget.totalTab - 1)
                                ? SizedBox()
                                : Expanded(
                                    child: CElevatedButton(
                                      color: Color(0xff5979AA),
                                      onPressed: () => saveOnly(1),
                                      text: Global.returnTrLable(
                                              _translation, 'Save', _language)
                                          .trim(),
                                    ),
                                  )
                            : SizedBox(),
                        // ]
                        // ),
                        _role == 'Creche Supervisor'
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
                                ? Global.returnTrLable(
                                    _translation, CustomText.Submit, _language)
                                : Global.returnTrLable(
                                    _translation, CustomText.Next, _language),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );

    // On Default return nothing
  }

  Future<void> _callScreenControllers(String parentName) async {
    final lang = await Validate().readString(Validate.sLanguage);

    _language = lang ?? _language;

    List<HouseHoldFielItemdModel> items =
        widget.screenItem[widget.tabBreakItem.name!]!;
    List<String> defaultCommon = [];
    List<String> logicFields = [];
    for (int i = 0; i < items.length; i++) {
      if (Global.validString(items[i].options)) {
        if (items[i].options == 'Creche') {
          await OptionsModelHelper()
              .callCrechInOption(items[i].options!.trim(),
                  Global.stringToInt(widget.creche_id))
              .then((data) {
            _options.addAll(data);
          });
          defaultDisableDialog(items[i].fieldname!, items[i].options!);
        } else {
          defaultCommon.add('tab${items[i].options!.trim()}');
        }
      }
      logicFields.add(items[i].fieldname!);
    }
    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lang!)
        .then((data) {
      _options.addAll(data);
    });
    await FormLogicDataHelper().callFormLogic(parentName).then((data) {
      _logics.addAll(data);
    });

    unpicableDates = await fetchDatesList();
  }

  defaultDisableDialog(String fieldName, String flag) async {
    var tabName = 'tab$flag';
    var item = _options.where((element) => element.flag == tabName).toList();
    if (item.length > 0) {
      _myMap[fieldName] = item.first.name!;
    }
  }

  List<Widget> _widgetList(String itemId) {
    List<Widget> screenItems = [];
    var items = widget.screenItem[itemId];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        screenItems.add(_widgetTypeWidget(i, items[i]));
        screenItems.add(SizedBox(height: 5.h));
        if (!DependingLogic().callDependingLogic(_logics, _myMap, items[i])) {
          _myMap.remove(items[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  Future<List<String>> fetchDatesList() async {
    List<CmcCBMResponseModel> cmcRespose = await CmcCBMTabResponseHelper()
        .childCBMChild(Global.stringToInt(widget.creche_id));
    List<String> visitdatesListString = [];
    cmcRespose.forEach((element) {
      visitdatesListString
          .add(Global.getItemValues(element.responces, 'date_of_visit'));
    });
    if (Global.validString(widget.date_of_visit) &&
        visitdatesListString.contains(widget.date_of_visit)) {
      visitdatesListString.remove(widget.date_of_visit);
    }
    return visitdatesListString;
  }

  Widget _widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = _options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          titleText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(_logics, _myMap, quesItem),
          items: items,
          selectedItem: _myMap[quesItem.fieldname],
          isVisible:
              DependingLogic().callDependingLogic(_logics, _myMap, quesItem),
          onChanged: (value) {
            if (value != null)
              _myMap[quesItem.fieldname!] = value.name!;
            else
              _myMap.remove(quesItem.fieldname);
            setState(() {});
          },
        );
      case 'Date':
        return CustomDatepickerDynamic(
          initialvalue: _myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          minDate: quesItem.fieldname == 'date_of_visit'
              ? now.isBefore(applicableDate)
                  ? null
                  : DateTime.now().subtract(Duration(days: 7))
              : null,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(_logics, _myMap, quesItem),
          // readable: quesItem.fieldname == 'date_of_visit'?widget.isEdit:null,
          calenderValidate:
              DependingLogic().calenderValidation(_logics, _myMap, quesItem),
          onChanged: (value) async {
            if (quesItem.fieldname == 'date_of_visit') {
              // if (Global.validString(_myMap['creche_id'])) {
              //   unpicableDates = await fetchDatesList(_myMap['creche_id']);
              //   setState(() {});
              // }
              if (unpicableDates.contains(value)) {
                _myMap.remove(quesItem.fieldname);
                Validate().singleButtonPopup(
                    'A Visit Note already exists for the selected Date "${value}"',
                    Global.returnTrLable(
                        _translation, CustomText.ok, _language),
                    false,
                    context);
              } else
                _myMap[quesItem.fieldname!] = value;
            } else {
              _myMap[quesItem.fieldname!] = value;
            }
            var logData = DependingLogic()
                .callDateDiffrenceLogic(_logics, _myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                _myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);
              }
            }
            setState(() {});
          },
          titleText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(_logics, _myMap, quesItem),
          initialvalue: _myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard:
              DependingLogic().keyBoardLogic(quesItem.fieldname!, _logics),
          readable:
              DependingLogic().callReadableLogic(_logics, _myMap, quesItem),
          hintText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isVisible:
              DependingLogic().callDependingLogic(_logics, _myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              _myMap[quesItem.fieldname!] = value;
            else
              _myMap.remove(quesItem.fieldname);
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(_logics, _myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: _myMap[quesItem.fieldname!],
          readable:
              DependingLogic().callReadableLogic(_logics, _myMap, quesItem),
          titleText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isVisible:
              DependingLogic().callDependingLogic(_logics, _myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              _myMap[quesItem.fieldname!] = value;
              var logData = DependingLogic()
                  .callAutoGeneratedValue(_logics, _myMap, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  _myMap.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  // setState(() {});
                }
              }
            } else {
              _myMap.remove(quesItem.fieldname);
              // setState(() {});
            }
          },
        );
      case 'Time':
        return CustomTimepickerDynamic(
          initialvalue: _myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(_logics, _myMap, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(_logics, _myMap, quesItem),
          onChanged: (value) {
            _myMap[quesItem.fieldname!] = value;
            var logData = DependingLogic()
                .callDateDiffrenceLogic(_logics, _myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                _myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);
                setState(() {});
              }
            }
          },
          titleText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
        );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          initialValue: _myMap[quesItem.fieldname],
          labelControlls: _translation,
          lng: _language,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(_logics, _myMap, quesItem),
          readable:
              DependingLogic().callReadableLogic(_logics, _myMap, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(_logics, _myMap, quesItem),
          onChanged: (value) {
            print('yesNo $value');
            _myMap[quesItem.fieldname!] = value;
            setState(() {});
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          maxline: 3,
          titleText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(_logics, _myMap, quesItem),
          initialvalue: _myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable:
              DependingLogic().callReadableLogic(_logics, _myMap, quesItem),
          hintText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isVisible:
              DependingLogic().callDependingLogic(_logics, _myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              _myMap[quesItem.fieldname!] = value;
            else
              _myMap.remove(quesItem.fieldname);
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(_logics, _myMap, quesItem),
          maxlength: quesItem.length,
          readable:
              DependingLogic().callReadableLogic(_logics, _myMap, quesItem),
          titleText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          initialvalue: _myMap[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null)
              _myMap[quesItem.fieldname!] = value;
            else {
              _myMap.remove(quesItem.fieldname);
              setState(() {});
            }
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          titleText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(_logics, _myMap, quesItem),
          maxlength: quesItem.length,
          readable:
              DependingLogic().callReadableLogic(_logics, _myMap, quesItem),
          initialvalue: _myMap[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value.isNotEmpty)
              _myMap[quesItem.fieldname!] = value;
            else
              _myMap.remove(quesItem.fieldname);
          },
        );
      default:
        return SizedBox();
    }
  }

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        if (widget.tabIndex < (widget.totalTab - 1)) {
          await saveDataInData(false);
        } else if (widget.tabIndex == (widget.totalTab - 1)) {
          await saveDataInData(true);
          bool shouldProceed = await showDialog(
            context: context,
            builder: (context) {
              return SingleButtonPopupDialog(
                  message: Global.returnTrLable(
                      _translation, CustomText.dataSaveSuc, _language),
                  button: Global.returnTrLable(
                      _translation, CustomText.ok, _language));
            },
          );

          if (shouldProceed) {
            Navigator.pop(mContext, 'itemRefresh');
          }
        }
        widget.changeTab(type);
        setState(() {});
      }
    } else {
      if (widget.tabIndex == 0) {
        Navigator.pop(mContext, 'itemRefresh');
      } else {
        widget.changeTab(type);
      }
    }
  }

  bool _checkValidation() {
    var validStatus = true;
    var items = widget.screenItem[widget.tabBreakItem.name];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        var element = items[i];
        if (element.reqd == 1) {
          var values = _myMap[element.fieldname];
          if (!Global.validString(values.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(
                    _translation, CustomText.plsFilManForm, _language),
                CustomText.ok,
                false,
                context);
            validStatus = false;
            break;
          } else if (element.fieldname == 'date_of_visit') {
            if (unpicableDates.contains(values)) {
              _myMap.remove(element.fieldname);
              setState(() {});
              Validate().singleButtonPopup(
                  'A Visit Note already exists for the selected Date "${values}"',
                  Global.returnTrLable(_translation, CustomText.ok, _language),
                  false,
                  context);
              validStatus = false;
              break;
            }
          }
        }
        var validationMsg =
            DependingLogic().validationMessge(_logics, _myMap, element,_translation,_language);
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

  Future<void> saveOnly(int type) async {
    if (type == 1) {
      if (_checkValidation()) {
        await saveDataInData(false);
        Validate().singleButtonPopup(
            Global.returnTrLable(
                _translation, CustomText.dataSaveSuc, _language),
            Global.returnTrLable(_translation, CustomText.ok, _language),
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

  Future<void> saveDataInData(bool isLastIndex) async {
    var widgets = widget.screenItem[widget.tabBreakItem.name];
    if (widgets != null) {
      Map<String, dynamic> responces = {};
      widgets.forEach((element) async {
        if (_myMap[element.fieldname] != null) {
          responces[element.fieldname!] = _myMap[element.fieldname];
        }
      });
      var responcesJs = jsonEncode(_myMap);
      var name = _myMap['name'];
      print(responcesJs);
      var itemCBM = CmcCBMResponseModel(
          cbmguid: widget.cbmguid,
          creche_id: Global.stringToInt(widget.creche_id),
          responces: responcesJs,
          is_uploaded: 0,
          is_edited:
              isLastIndex ? 1 : (widget.isEdit == false ? 2 : isEditExisting),
          is_deleted: 0,
          name: name,
          created_by: username,
          created_at: Validate().currentDateTime());
      await CmcCBMTabResponseHelper().inserts(itemCBM);
      // await CmcCBMTabResponseHelper().insertUpdate(widget.cbmguid, name as int?,
      //     responcesJs, username, Global.stringToInt(widget.creche_id));
    }
  }

  Future<void> updateExistingFields() async {
    final records = await CmcCBMTabResponseHelper()
        .getCrecheCommittieResponcewithGuid(widget.cbmguid);

    if (records.isNotEmpty) {
      final Map<String, dynamic> responseData =
          jsonDecode(records.first.responces!);
      responseData.forEach((key, value) => _myMap[key] = value);
      isEditExisting = records.first.is_edited;
      final createdOnNotNull = responseData['appcreated_on'] != null;
      final createdByNotNull = responseData['appcreated_by'] != null;

      if (createdByNotNull || createdOnNotNull) {
        _myMap['app_updated_on'] = Validate().currentDateTime();
        _myMap['app_updated_by'] = username;
      } else {
        _myMap['appcreated_on'] = Validate().currentDateTime();
        _myMap['appcreated_by'] = username;
      }

      final name = records.first.name;

      if (name != null) {
        _myMap['name'] = name;
      }
    } else {
      final crecheInfo = await CrecheDataHelper()
          .getCrecheResponceItem(Global.stringToInt(widget.creche_id));

      if (crecheInfo.length > 0) {
        _myMap['appcreated_by'] = username;
        _myMap['appcreated_on'] = Validate().currentDateTime();
        _myMap['cbmguid'] = widget.cbmguid;
        _myMap['creche_id'] = widget.creche_id;
        _myMap['partner_id'] =
            Global.getItemValues(crecheInfo[0].responces!, 'partner_id');
        _myMap['state_id'] =
            Global.getItemValues(crecheInfo[0].responces!, 'state_id');
        _myMap['district_id'] =
            Global.getItemValues(crecheInfo[0].responces!, 'district_id');
        _myMap['block_id'] =
            Global.getItemValues(crecheInfo[0].responces!, 'block_id');
        _myMap['gp_id'] =
            Global.getItemValues(crecheInfo[0].responces!, 'gp_id');
        _myMap['village_id'] =
            Global.getItemValues(crecheInfo[0].responces!, 'village_id');
        _myMap['date_of_visit'] = Global.initCurrentDate();
      }
      _myMap['cbmguid'] = widget.cbmguid;
    }
  }
}
