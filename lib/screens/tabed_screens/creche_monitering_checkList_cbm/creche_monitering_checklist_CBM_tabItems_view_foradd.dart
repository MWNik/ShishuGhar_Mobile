import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/database/helper/block_data_helper.dart';
import 'package:shishughar/database/helper/gram_panchayat_data_helper.dart';
import 'package:shishughar/database/helper/village_data_helper.dart';
import 'package:shishughar/model/databasemodel/tabBlock_model.dart';
import 'package:shishughar/model/databasemodel/tabGramPanchayat_model.dart';
import 'package:shishughar/model/databasemodel/tabVillage_model.dart';

import '../../../../custom_widget/custom_btn.dart';
import '../../../../custom_widget/custom_text.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_custom_time_picker.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../../database/helper/cmc_cbm/creche_monitering_checklist_CBM_response_helper.dart';
import '../../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../../database/helper/form_logic_helper.dart';
import '../../../../database/helper/translation_language_helper.dart';
import '../../../../model/apimodel/creche_database_responce_model.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../../model/apimodel/translation_language_api_model.dart';
import '../../../../model/dynamic_screen_model/creche_monitering_checkList_cbm_response_model.dart';
import '../../../../model/dynamic_screen_model/options_model.dart';
import '../../../../utils/globle_method.dart';
import '../../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class CmcCBMTabItemViewSCreenForAdd extends StatefulWidget {
  final String cbmguid;
  // final String creche_id;
  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;
  // String? date_of_visit;
  // final bool isEdit;

  CmcCBMTabItemViewSCreenForAdd({
    required this.cbmguid,
    // required this.creche_id,
    required this.tabBreakItem,
    required this.screenItem,
    required this.changeTab,
    required this.tabIndex,
    required this.totalTab,
    // this.date_of_visit,
    // required this.isEdit
  });

  @override
  State<CmcCBMTabItemViewSCreenForAdd> createState() =>
      _CmcCBMTabItemViewSCreenForAddState();
}

class _CmcCBMTabItemViewSCreenForAddState
    extends State<CmcCBMTabItemViewSCreenForAdd> {
  List<String> unpicableDates = [];
  String? _role;
  String username = '';
  String _language = 'en';
  List<CresheDatabaseResponceModel> allCrecheRecords = [];
  List<OptionsModel> _options = [];
  DependingLogic? logic;
  List<Translation> _translation = [];
  bool _isLoading = true;
  List<OptionsModel> items = [];
  List<OptionsModel> cItems = [];
  bool villageHasChanged = false;
  bool districtHasChanged = false;
  bool blockHasChanged = false;
  bool gphasChanges = false;
  List<TabGramPanchayat> allGpRecords = [];
  List<TabBlock> allBlockRecords = [];
  List<TabVillage> allVillageRecords = [];
  Map<String, dynamic> _myMap = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _role = await Validate().readString(Validate.role);
    username = (await Validate().readString(Validate.userName))!;

    List<String> valueNames = [
      CustomText.Creches,
      CustomText.Next,
      CustomText.back,
      CustomText.ok,
      CustomText.exit,
      CustomText.ChildEnrollsuccess,
      CustomText.select_here,
      CustomText.plsFilManForm,
      CustomText.dataSaveSuc,
      CustomText.visitNoteAlrdyExists,
      CustomText.Yes,
      CustomText.No,
      CustomText.typehere,
    ];

    final itemz = widget.screenItem[widget.tabBreakItem.name]!;
    itemz.forEach((element) {
      if (Global.validString(element.label)) {
        valueNames.add(element.label!.trim());
      }
    });

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => _translation.addAll(value));
    allCrecheRecords = await CrecheDataHelper().getCrecheResponce();
    allBlockRecords = await BlockDataHelper().getTabBlockList();
    allGpRecords = await GramPanchayatDataHelper().getTabGramPanchayatList();
    allVillageRecords = await VillageDataHelper().getTabVillageList();
    await updateExistingFields();

    await _callScreenControllers('Creche Monitoring Checklist CBM');
    setState(() {
      _isLoading = false;
    });
  }

  // Future<List<String>> fetchDatesList(String creche_id) async {
  //   List<CmcCBMResponseModel> cmcRespose =
  //   await CmcCBMTabResponseHelper()
  //       .childCBMChild(Global.stringToInt(creche_id));
  //   List<String> visitdatesListString = [];
  //   cmcRespose.forEach((element) {
  //     visitdatesListString
  //         .add(Global.getItemValues(element.responces, 'date_of_visit'));
  //   });
  //   if(Global.validString(widget.date_of_visit)&&visitdatesListString.contains(widget.date_of_visit)){
  //     visitdatesListString.remove(widget.date_of_visit);
  //   }
  //   return visitdatesListString;
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'itemRefresh');
        return false;
      },
      child: _isLoading
          ? Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()))
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
                        Expanded(
                          child: CElevatedButton(
                            color: widget.tabIndex == (widget.totalTab - 1)
                                ? Color(0xff5979AA)
                                : Color(0xff369A8D),
                            onPressed: () {
                              if (widget.tabIndex == (widget.totalTab - 1))
                                Navigator.pop(context, 'itemRefresh');
                              else
                                nextTab(1, context);
                              // widget.changeTab(1);
                            },
                            text: Global.returnTrLable(
                                _translation,
                                widget.tabIndex == (widget.totalTab - 1)
                                    ? CustomText.exit
                                    : CustomText.Next,
                                _language),
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
                .callCrechInOption(items[i].options!.trim(), 0)
                .then((data) {
              _options.addAll(data);
            });
            defaultDisableDialog(items[i].fieldname!, items[i].options!);
          } else if (items[i].options == 'Partner') {
            await OptionsModelHelper()
                .getPartnerMstCommonOptions(
                    items[i].options!.trim(), responseData)
                .then((data) {
              _options.addAll(data);
            });
            defaultDisableDialog(items[i].fieldname!, items[i].options!);
          } else {
            await OptionsModelHelper()
                .getLocationData(items[i].options!.trim(), responseData, lang!)
                .then((data) {
              _options.addAll(data);
            });
          }
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
      logic = DependingLogic(_translation, data, _language);
    });

    // var dateOfVi=items.where((element) =>
    // element.fieldname=='date_of_visit').toList();

    // if(dateOfVi.length>0&&Global.validString(_myMap['creche_id'])){
    //   unpicableDates = await fetchDatesList(_myMap['creche_id']);
    // }
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
        if (!logic!.callDependingLogic(_myMap, items[i])) {
          _myMap.remove(items[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  List<OptionsModel> filterCreche(String? villageId) {
    List<CresheDatabaseResponceModel> filteredRecords = [];
    filteredRecords = allCrecheRecords
        .where((element) =>
            Global.getItemValues(element.responces, 'village_id') == villageId)
        .toList();
    List<OptionsModel> crecheOptionsList = [];
    (filteredRecords.isNotEmpty)
        ? filteredRecords.forEach((element) {
            var item = OptionsModel(
              name: element.name.toString(),
              flag: 'tabCreche',
              values: Global.getItemValues(element.responces, 'creche_name'),
            );
            crecheOptionsList.add(item);
          })
        : allCrecheRecords.forEach((element) {
            var item = OptionsModel(
              name: element.name.toString(),
              flag: 'tabCreche',
              values: Global.getItemValues(element.responces, 'creche_name'),
            );
            crecheOptionsList.add(item);
          });
    return crecheOptionsList;
  }

  List<OptionsModel> filterBlock(String? districtId) {
    List<TabBlock> filteredBlockList = [];
    filteredBlockList = allBlockRecords
        .where((element) => element.districtId == districtId)
        .toList();
    List<OptionsModel> blockOptionsList = [];
    (filteredBlockList.isNotEmpty)
        ? filteredBlockList.forEach((element) {
            var item = OptionsModel(
                name: element.name.toString(),
                flag: 'tabBlock',
                values: element.value);
            blockOptionsList.add(item);
          })
        : allBlockRecords.forEach((element) {
            var item = OptionsModel(
                name: element.name.toString(),
                flag: 'tabBlock',
                values: element.value);
            blockOptionsList.add(item);
          });
    return blockOptionsList;
  }

  List<OptionsModel> filterGp(String? blockId) {
    List<TabGramPanchayat> filteredGp = [];
    filteredGp =
        allGpRecords.where((element) => element.blockId == blockId).toList();
    List<OptionsModel> GpOptionsList = [];
    (filteredGp.isNotEmpty)
        ? filteredGp.forEach((element) {
            var item = OptionsModel(
                name: element.name.toString(),
                flag: 'tabGram Panchayat',
                values: element.value);
            GpOptionsList.add(item);
          })
        : allGpRecords.forEach((element) {
            var item = OptionsModel(
                name: element.name.toString(),
                flag: 'tabGram Panchayat',
                values: element.value);
            GpOptionsList.add(item);
          });
    return GpOptionsList;
  }

  List<OptionsModel> filterVillage(String? GpId) {
    List<TabVillage> filteredVillage = [];
    filteredVillage =
        allVillageRecords.where((element) => element.gpId == GpId).toList();
    List<OptionsModel> VillageOptionList = [];
    (filteredVillage.isNotEmpty)
        ? filteredVillage.forEach((element) {
            var item = OptionsModel(
              name: element.name.toString(),
              flag: 'tabVillage',
              values: element.value,
            );
            VillageOptionList.add(item);
          })
        : allVillageRecords.forEach((element) {
            var item = OptionsModel(
              name: element.name.toString(),
              flag: 'tabVillage',
              values: element.value,
            );
            VillageOptionList.add(item);
          });
    return VillageOptionList;
  }

  List<OptionsModel> fecthOptionsList(HouseHoldFielItemdModel field) {
    List<OptionsModel> CItem = [];
    if (field.fieldname == 'creche_id' && villageHasChanged == true) {
      var village_id = _myMap['village_id'];
      CItem = filterCreche(village_id);
      setState(() {});
    } else if (field.fieldname == 'block_id' && districtHasChanged == true) {
      var districId = _myMap['district_id'];
      CItem = filterBlock(districId);
      setState(() {});
    } else if (field.fieldname == 'gp_id' && blockHasChanged == true) {
      var blockId = _myMap['block_id'];
      CItem = filterGp(blockId);
      setState(() {});
    } else if (field.fieldname == 'village_id' && gphasChanges == true) {
      var gpId = _myMap['gp_id'];
      CItem = filterVillage(gpId);
      setState(() {});
    } else {
      CItem = _options
          .where((element) => element.flag == "tab${field.options}")
          .toList();
      if (CItem.length == 1) {
        _myMap[field.fieldname!] = CItem.first.name;
      }
      setState(() {});
    }
    return CItem;
  }

  Widget _widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        if (quesItem.fieldname == 'creche_id') {
          var village_id = _myMap['village_id'];
          if (village_id != null) {
            items = filterCreche(village_id);
          } else
            items = [];
        } else {
          items = _options
              .where((element) => element.flag == "tab${quesItem.options}")
              .toList();
        }
        if (items.length == 1) {
          _myMap[quesItem.fieldname!] = items.first.name;
        }
        return DynamicCustomDropdownField(
          hintText: Global.returnTrLable(_translation,CustomText.select_here, _language),
          titleText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(_myMap, quesItem),
          items: items,
          selectedItem: _myMap[quesItem.fieldname],
          isVisible: logic!.callDependingLogic(_myMap, quesItem),
          readable: true,
          onChanged: (value) async {
            if (quesItem.fieldname == 'village_id' && value!.name != null) {
              _myMap.remove('creche_id');
            }
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
              ? DateTime.now().subtract(Duration(days: 7))
              : null,
          // readable: quesItem.fieldname == 'date_of_visit'?widget.isEdit:null,
          readable: true,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(_myMap, quesItem),
          calenderValidate: logic!.calenderValidation(_myMap, quesItem),
          onChanged: (value) async {
            if (quesItem.fieldname == 'date_of_visit') {
              // if (Global.validString(_myMap['creche_id'])) {
              //   unpicableDates = await fetchDatesList(_myMap['creche_id']);
              //   setState(() {});
              // }
              if (unpicableDates.contains(value)) {
                _myMap.remove(quesItem.fieldname);
                var message = Global.returnTrLable(_translation, CustomText.visitNoteAlrdyExists,_language);
                message = message.replaceAll(
                  RegExp("@", caseSensitive: false), '$value');
                Validate().singleButtonPopup(
                    message,
                    Global.returnTrLable(
                        _translation, CustomText.ok, _language),
                    false,
                    context);
              } else
                _myMap[quesItem.fieldname!] = value;
            } else {
              _myMap[quesItem.fieldname!] = value;
            }
            var logData = logic!.callDateDiffrenceLogic(_myMap, quesItem);
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
              : logic!.dependeOnMendotory(_myMap, quesItem),
          initialvalue: _myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          // readable:
          //     logic!.callReadableLogic( _myMap, quesItem),
          readable: true,
          hintText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isVisible: logic!.callDependingLogic(_myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              _myMap[quesItem.fieldname!] = value;
            else
              _myMap.remove(quesItem.fieldname);
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          hintText: Global.returnTrLable(_translation, CustomText.typehere, _language),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(_myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: _myMap[quesItem.fieldname!],
          // readable:
          //     logic!.callReadableLogic( _myMap, quesItem),
          readable: true,
          titleText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isVisible: logic!.callDependingLogic(_myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              _myMap[quesItem.fieldname!] = value;
              var logData = logic!.callAutoGeneratedValue(_myMap, quesItem);
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
              : logic!.dependeOnMendotory(_myMap, quesItem),
          isVisible: logic!.callDependingLogic(_myMap, quesItem),
          readable: true,
          onChanged: (value) {
            _myMap[quesItem.fieldname!] = value;
            var logData = logic!.callDateDiffrenceLogic(_myMap, quesItem);
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
              : logic!.dependeOnMendotory(_myMap, quesItem),
          // readable:
          //     logic!.callReadableLogic( _myMap, quesItem),
          readable: true,
          isVisible: logic!.callDependingLogic(_myMap, quesItem),
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
              : logic!.dependeOnMendotory(_myMap, quesItem),
          initialvalue: _myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          // readable:
          //     logic!.callReadableLogic( _myMap, quesItem),
          readable: true,
          hintText: Global.returnTrLable(
              _translation, quesItem.label!.trim(), _language),
          isVisible: logic!.callDependingLogic(_myMap, quesItem),
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
              : logic!.dependeOnMendotory(_myMap, quesItem),
          maxlength: quesItem.length,
          // readable:
          //     logic!.callReadableLogic( _myMap, quesItem),
          readable: true,
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
              : logic!.dependeOnMendotory(_myMap, quesItem),
          maxlength: quesItem.length,
          // readable:
          //     logic!.callReadableLogic( _myMap, quesItem),
          readable: true,
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
      // if (_checkValidation()) {
      //   if (widget.tabIndex < (widget.totalTab - 1)) {
      //     await saveDataInData(0);
      //   } else if (widget.tabIndex == (widget.totalTab - 1)) {
      //     await saveDataInData(1);
      //     bool shouldProceed = await showDialog(
      //       context: context,
      //       builder: (context) {
      //         return SingleButtonPopupDialog(
      //             message: Global.returnTrLable(
      //                 _translation, CustomText.dataSaveSuc, _language),
      //             button: Global.returnTrLable(
      //                 _translation, CustomText.ok, _language));
      //       },
      //     );

      //     if (shouldProceed) {
      //       Navigator.pop(mContext, 'itemRefresh');
      //     }
      //   }
      //   widget.changeTab(type);
      //   setState(() {});
      // }
      widget.changeTab(type);
      setState(() {});
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
                Global.returnTrLable(_translation, CustomText.ok, _language),
                false,
                context);
            validStatus = false;
            break;
          } else if (element.fieldname == 'date_of_visit') {
            if (unpicableDates.contains(values)) {
              _myMap.remove(element.fieldname);
              setState(() {});
              var message = Global.returnTrLable(_translation, CustomText.visitNoteAlrdyExists,_language);
                message = message.replaceAll(
                  RegExp("@", caseSensitive: false), '$values');
              Validate().singleButtonPopup(
                  message,
                  Global.returnTrLable(_translation, CustomText.ok, _language),
                  false,
                  context);
              validStatus = false;
              break;
            }
          }
        }
        var validationMsg = logic!.validationMessge(_myMap, element);
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
        await saveDataInData(0);
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

  Future<void> saveDataInData(int type) async {
    var widgets = widget.screenItem[widget.tabBreakItem.name];
    if (widgets != null) {
      Map<String, dynamic> responces = {};
      widgets.forEach((element) async {
        if (_myMap[element.fieldname] != null) {
          responces[element.fieldname!] = _myMap[element.fieldname];
        }
      });
      var responcesJs = jsonEncode(_myMap);

      print(responcesJs);

      var items = (type == 1)
          ? CmcCBMResponseModel(
              cbmguid: widget.cbmguid,
              name: _myMap['name'],
              is_deleted: 0,
              is_edited: 1,
              is_uploaded: 0,
              responces: responcesJs,
              created_by: _myMap['appcreated_by'],
              created_at: _myMap['appcreated_on'],
              update_at: _myMap['app_updated_by'],
              updated_by: _myMap['app_updated_by'],
              creche_id: Global.stringToInt(_myMap['creche_id']))
          : CmcCBMResponseModel(
              cbmguid: widget.cbmguid,
              name: _myMap['name'],
              is_deleted: 0,
              is_edited: 1,
              is_uploaded: 0,
              created_by: _myMap['appcreated_by'],
              created_at: _myMap['appcreated_on'],
              update_at: _myMap['app_updated_by'],
              updated_by: _myMap['app_updated_by'],
              responces: responcesJs);
      await CmcCBMTabResponseHelper().inserts(items);
    }
  }

  Future<void> updateExistingFields() async {
    final records = await CmcCBMTabResponseHelper()
        .getCrecheCommittieResponcewithGuid(widget.cbmguid);

    if (records.isNotEmpty) {
      final Map<String, dynamic> responseData =
          jsonDecode(records.first.responces!);
      responseData.forEach((key, value) => _myMap[key] = value);

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

      if (!Global.validString(_myMap['date_of_visit'])) {
        final itemsControll = widget.screenItem[widget.tabBreakItem.name!]!;
        var dateOfVi = itemsControll
            .where((element) => element.fieldname == 'date_of_visit')
            .toList();
        if (dateOfVi.length > 0) {
          _myMap['date_of_visit'] = Global.initCurrentDate();
        }
      }
    } else {
      _myMap['appcreated_by'] = username;
      _myMap['appcreated_on'] = Validate().currentDateTime();
      _myMap['cbmguid'] = widget.cbmguid;

      if (!Global.validString(_myMap['date_of_visit'])) {
        final itemsControll = widget.screenItem[widget.tabBreakItem.name!]!;
        var dateOfVi = itemsControll
            .where((element) => element.fieldname == 'date_of_visit')
            .toList();
        if (dateOfVi.length > 0) {
          _myMap['date_of_visit'] = Global.initCurrentDate();
        }
      }
    }
  }
}
