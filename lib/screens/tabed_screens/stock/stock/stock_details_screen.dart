import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
import 'package:shishughar/database/helper/stock/stock_fields_helper.dart';
import 'package:shishughar/database/helper/stock/stock_response_helper.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/cashbook_response_expences_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/model/dynamic_screen_model/stock_response_model.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../../custom_widget/custom_appbar.dart';
import '../../../../custom_widget/custom_btn.dart';
import '../../../../custom_widget/custom_text.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../../custom_widget/single_poup_dailog.dart';
import '../../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../../database/helper/form_logic_helper.dart';
import '../../../../database/helper/translation_language_helper.dart';
import '../../../../utils/globle_method.dart';
import '../../house_hold/depending_logic.dart';

class StockDetailsScreen extends StatefulWidget {
  final int month;
  final int year;
  final String item;
  final String creche_id;
  final String sguid;
  String? openingStock;

  StockDetailsScreen({
    super.key,
    required this.creche_id,
    required this.item,
    required this.month,
    required this.year,
    required this.sguid,
    this.openingStock,
  });

  @override
  State<StockDetailsScreen> createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends State<StockDetailsScreen> {
  List<TabFormsLogic> logics = [];
  List<HouseHoldFielItemdModel> allItems = [];
  Map<String, dynamic> myMap = {};
  List<OptionsModel> options = [];
  bool _isLoading = true;
  String userName = '';
  String? role;
  String? lng = 'en';
  List<Translation> translats = [];
  List<OptionsModel> yearList = [];
  List<String> hiddens = [
    'partner_id',
    'state_id',
    'district_id',
    'block_id',
    'gp_id',
    'village_id',
    'creche_id',
  ];

  void initState() {
    super.initState();
    initializedData();
  }

  Future<void> initializedData() async {
     userName = (await Validate().readString(Validate.userName))!;
    lng = (await Validate().readString(Validate.sLanguage))!;
    translats.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back,
      CustomText.Submit,
      CustomText.Selecthere,
      CustomText.stockDetails
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats = value);
    await OptionsModelHelper()
        .getMstCommonOptions('Year', lng!)
        .then((value) => yearList.addAll(value));

    await updateHiddenValue();
    await callScrenControllers('Creche Stock');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          text: Global.returnTrLable(translats, CustomText.stockDetails, lng!),
          onTap: () => Navigator.pop(context, 'itemRefresh'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Divider(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: cWidget(),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
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
                            translats, CustomText.back, lng!),
                      )),
                      SizedBox(width: 10),
                      Expanded(
                          child: CElevatedButton(
                        color: Color(0xff369A8D),
                        onPressed: () {
                          nextTab(1, context);
                        },
                        text: Global.returnTrLable(
                            translats, CustomText.Submit, lng!),
                      ))
                    ]),
                  ),
                ],
              ));
  }

  List<Widget> cWidget() {
    List<Widget> screenItems = [];
    if (allItems.length > 0) {
      for (int i = 0; i < allItems.length; i++) {
        screenItems.add(widgetTypeWidget(i, allItems[i]));
        screenItems.add(SizedBox(height: 5.h));
        if (!DependingLogic().callDependingLogic(logics, myMap, allItems[i])) {
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
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
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
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
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
                setState(() {});
                // }
              }
            }
          },
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!, logics),
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
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
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
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
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: translats,
          lng: lng!,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
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
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
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
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
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
      case 'Float':
        // bool shouldCalc = true;
        // List<String> calList = [
        //   'opening_stock',
        //   'quantity_received',
        //   'usage',
        //   'wastage',
        // ];
        // Map<String, double> calcMap = {};
        // for (var element in calList) {
        //   if (myMap[element] == null) {
        //     shouldCalc = false;
        //     break;
        //   } else {
        //     calcMap[element] = myMap[element];
        //   }
        // }
        // myMap['closing_stock'] = shouldCalculate()
        //     ? ((calcMap['opening_stock']! + calcMap['quantity_received']!) -
        //         (calcMap['usage']! + calcMap['wastage']!))
        //     : null;
        return DynamicCustomTextFieldFloat(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          fieldName: quesItem.fieldname!,
          initialvalue: myMap[quesItem.fieldname!],
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
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

  bool shouldCalculate() {
    bool shouldCalc = true;
    List<String> calList = [
      'opening_stock',
      'quantity_received',
      'usage',
      'wastage',
    ];
    Map<String, double> calcMap = {};
    for (var element in calList) {
      if (myMap[element] == null) {
        shouldCalc = false;
        break;
      } else {
        calcMap[element] = myMap[element];
      }
    }
    return shouldCalc;
  }

  Future<void> callScrenControllers(screen_type) async {
   
    lng = (await Validate().readString(Validate.sLanguage))!;
    await StockFieldHelper().getStockByParent(screen_type).then((value) {
      allItems = value;
    });
    allItems = allItems
        .where((element) => !(hiddens.contains(element.fieldname)))
        .toList();

    List<String> defaultCommon = [];
    for (int i = 0; i < allItems.length; i++) {
      if (Global.validString(allItems[i].options)) {
        if (allItems[i].options == "Partner Stock") {
          await OptionsModelHelper()
              .callPartnerStockOptions(
                  allItems[i].options!,
                  lng!,
                  allItems[i].parent!,
                  Global.stringToInt(widget.creche_id),
                  widget.month,
                  widget.year)
              .then((value) => options.addAll(value));
        }
        defaultCommon.add('tab${allItems[i].options!.trim()}');
      }
    }
    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng!)
        .then((value) => options.addAll(value));

    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logics.addAll(data);
    });

    setState(() {
      _isLoading = false;
    });
  }

  bool _checkValidation() {
    var validStatus = true;
    if (allItems.length > 0) {
      for (int i = 0; i < allItems.length; i++) {
        var element = allItems[i];
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
        var validationMsg =
            DependingLogic().validationMessge(logics, myMap, element);
        if (Global.validString(validationMsg)) {
          Validate().singleButtonPopup(
              Global.returnTrLable(translats, validationMsg, lng!),
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

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        await saveDataInData();
        bool shouldProceed = await showDialog(
          context: context,
          builder: (context) {
            return SingleButtonPopupDialog(
                message: Global.returnTrLable(
                    translats, CustomText.dataSaveSuc, lng!),
                button: Global.returnTrLable(translats, CustomText.ok, lng!));
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

      var eventItem = StockResponseModel(
          sguid: widget.sguid,
          name: myMap['name'],
          creche_id: Global.stringToInt(widget.creche_id),
          responces: responcesJs,
          is_uploaded: 0,
          is_edited: 1,
          is_deleted: 0,
          created_at: myMap['appcreated_on'],
          created_by: myMap['appcreated_by'],
          update_at: myMap['app_updated_on'],
          updated_by: myMap['app_updated_by'],
          item_id: Global.stringToInt(myMap['stock_item']),
          year: Global.stringToInt(myMap['year']),
          month: Global.stringToInt(myMap['month']));

      await StockResponseHelper().inserts(eventItem);
    }
  }

  Future<void> updateHiddenValue() async {
    userName = (await Validate().readString(Validate.userName))!;
    var alrecords = await StockResponseHelper().gteStockByGuid(widget.sguid!);
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

        myMap['opening_stock'] = (widget.openingStock != null)
            ? Global.stringToDouble(widget.openingStock)
            : 0.0;

        myMap['sguid'] = widget.sguid;
        myMap['month'] = widget.month.toString();
        myMap['year'] = widget.year.toString();
        myMap['stock_item'] = widget.item;
        var requisitionData = await RequisitionResponseHelper()
            .getRequisitionByYearnMonth(Global.stringToInt(widget.creche_id),
                widget.month, widget.year);
        // print(${requisitionData.length});
        if (requisitionData.length > 0) {
          for (var element in requisitionData) {
            var item =
                Global.getItemValues(element.responces, 'requistion_item');
            var rItem = Global.stringToInt(item);
            if (rItem == Global.stringToInt(widget.item)) {
              myMap['quantity_received'] = Global.stringToDouble(
                  Global.getItemValues(element.responces, 'quantity_received'));
            }
          }
        }
      }
    }
  }

  int getNameFromOptionValue(int value) {
    int name = 0;
    var list = yearList.where((element) {
      return Global.stringToInt(element.values) == value;
    });
    name = Global.stringToInt(list.first.name);
    return name;
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 10),
                const Text("Please wait..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
