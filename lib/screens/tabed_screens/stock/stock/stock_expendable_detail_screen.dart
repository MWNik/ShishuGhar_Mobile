import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/custom_widget/customtextfield.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import 'package:shishughar/custom_widget/single_poup_dailog.dart';
import 'package:shishughar/database/helper/creche_helper/creche_data_helper.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/form_logic_helper.dart';
import 'package:shishughar/database/helper/partner_stock_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
import 'package:shishughar/database/helper/stock/stock_fields_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/creche_database_responce_model.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/partner_stock_model.dart';
// import 'package:shishughar/model/apimodel/partner_stock_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/model/dynamic_screen_model/requisition_response_model.dart';
import 'package:shishughar/model/dynamic_screen_model/stock_response_model.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/depending_logic.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:shishughar/database/helper/stock/stock_response_helper.dart';

class StockExpendableDetailScreen extends StatefulWidget {
  final String sguid;
  final int month;
  final int year;
  final String creche_id;

  const StockExpendableDetailScreen(
      {super.key,
      required this.creche_id,
      required this.month,
      required this.sguid,
      required this.year});

  @override
  State<StockExpendableDetailScreen> createState() =>
      _StockExpendableDetailScreenState();
}

class _StockExpendableDetailScreenState
    extends State<StockExpendableDetailScreen> {
  bool _isLoading = true;
  TextEditingController _textController = TextEditingController();
  DependingLogic? logic;
  List<OptionsModel> monthsList = [];
  List<OptionsModel> yearList = [];
  // List<PartnerStockModel> partnerStockItemList = [];
  List<PartnerStockModel> allItemsList = [];
  List<StockResponseModel> requested_stock_item = [];

  List<StockResponseModel> previous_month_data = [];
  String lng = 'en';
  String userName = '';
  List<HouseHoldFielItemdModel> allItems = [];
  Map<String, Map<String, dynamic>> itemMap = {};
  List<OptionsModel> options = [];
  List<Translation> translats = [];
  Map<String, dynamic> myMap = {};
  List<String> hiddens = [
    'partner_id',
    'state_id',
    'district_id',
    'block_id',
    'gp_id',
    'village_id',
    'creche_id',
    'year',
    'month',
    'stock_item'
  ];
  int? expended;
  List<CresheDatabaseResponceModel> creche_rec = [];
  String? creche_name;
  List<dynamic> stock_item_list = [];
  List<dynamic> filtered_stock_items_list = [];

  @override
  void initState() {
    super.initState();
    intitializeData();
  }

  Future<void> intitializeData() async {
    translats.clear();
    lng = (await Validate().readString(Validate.sLanguage))!;
    List<String> valueNames = [
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.back,
      CustomText.dataSaveSuc,
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

    creche_rec = await CrecheDataHelper()
        .getCrecheResponceItem(Global.stringToInt(widget.creche_id));
    creche_name = Global.getItemValues(creche_rec[0].responces!, 'creche_name');

    monthsList = await OptionsModelHelper().getMstCommonOptions('Months', lng);
    yearList = await OptionsModelHelper().getMstCommonOptions('Year', lng);
    allItemsList = await PartnerStockHelper().getAllRecords();

    await fetchStockItes();

    await callScreenController('Stock Child table');
  }

  String getItemNameFromid(int name) {
    String itemvalue = '';
    allItemsList.forEach((element) {
      if (element.name == name) {
        if (Global.validString(element.items)) {
          itemvalue = element.items!;
        }
      }
    });
    return itemvalue;
  }

  Future<void> fetchStockItes() async {
    DateTime prevMonth = widget.month == 1
        ? DateTime(widget.year - 1, 12)
        : DateTime(widget.year, widget.month - 1);
    final responses = await Future.wait([
      StockResponseHelper().getStockByYearnMonth(
        Global.stringToInt(widget.creche_id),
        widget.month,
        widget.year,
      ),
      StockResponseHelper().getStockByYearnMonth(
        Global.stringToInt(widget.creche_id),
        prevMonth.month,
        prevMonth.year,
      ),
    ]);
    var requi_record = await RequisitionResponseHelper()
        .getRequisitionByYearnMonth(
            Global.stringToInt(widget.creche_id), widget.month, widget.year);

    var responseData = jsonDecode(requi_record.first.responces!);
    var requisitions_list = responseData['requisition_list'];

    // List<Map<String, dynamic>> requisitions_list =
    //     jsonDecode(requi_record[0].responces!)['requisition_list']
    //         as List<Map<String, dynamic>>;

    requested_stock_item = responses[0];
    previous_month_data = responses[1];

    await updateHiddenValue(requested_stock_item);

    if (requested_stock_item.isNotEmpty) {
      // filtered_stock_item = requested_stock_item;
      var stock_response = jsonDecode(requested_stock_item.first.responces!);
      stock_item_list = stock_response['stock_list'];
    }
    // else if (requested_stock_item.isNotEmpty && requi_record.isNotEmpty) {
    //   var stock_response = jsonDecode(requested_stock_item.first.responces!);
    //   var requested_stock_item_list = stock_response['stock_list'];
    //   requisitions_list.
    // }

    else if (previous_month_data.isNotEmpty &&
        requi_record.isNotEmpty &&
        requested_stock_item.isEmpty) {
      var previous_response = jsonDecode(previous_month_data.first.responces!);
      var previous_months_items = previous_response['stock_list'];

      requisitions_list.forEach((element) {
        var stock_item = element['requistion_item'];
        var opening_stock = previous_months_items
            .where((value) => value['stock_item'] == stock_item)
            .toList()
            .first['closing_stock'];

        Map<String, dynamic> item = {
          'month': element['month'],
          'year': element['year'],
          'stock_item': element['requistion_item'],
          'opening_stock': opening_stock ?? 0.0,
          'quantity_received': element['quantity_received'] ?? 0.0,
        };
        stock_item_list.add(item);
      });
    } else if (requi_record.isNotEmpty &&
        previous_month_data.isEmpty &&
        requested_stock_item.isEmpty) {
      requisitions_list.forEach((element) {
        Map<String, dynamic> item = {
          'month': element['month'],
          'year': element['year'],
          'stock_item': element['requistion_item'],
          'opening_stock': 0.0,
          'quantity_received': element['quantity_received'] ?? 0.0,
        };
        stock_item_list.add(item);
      });
    }
    filtered_stock_items_list = stock_item_list;
    if (filtered_stock_items_list.isNotEmpty) {
      for (var stockitems in stock_item_list) {
        Map<String, dynamic> itemIndivMap = {};
        stockitems.forEach((key, value) {
          itemIndivMap[key] = value;
        });
        itemMap.addEntries(
            [MapEntry('${stockitems['stock_item']}', itemIndivMap)]);
      }
    }
  }

  Widget itemCard(List<Map<String, dynamic>> stockItemList,
      List<HouseHoldFielItemdModel> fields, int type) {
    return ListView.builder(
      itemCount: stockItemList.length,
      physics: BouncingScrollPhysics(),
      shrinkWrap: false,
      itemBuilder: (BuildContext context, int index) {
        String itemValue = stockItemList[index]['stock_item'];
        var itemValueTranslats = options
            .where((value) =>
                value.flag == 'tabPartner Stock' &&
                Global.stringToInt(value.name) == Global.stringToInt(itemValue))
            .toList();
        var nameofItem = Global.stringToInt(itemValueTranslats.first.name);
        // itemMap.addEntries([
        //   MapEntry('${itemValueTranslats.first.name}', stockItemList[index])
        // ]);
        // var fieldData =
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 15,
                    offset: Offset(-3, -3),
                    spreadRadius: 3,
                    color: Colors.grey.shade300,
                    blurStyle: BlurStyle.outer)
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Text(
                          '${index + 1}: ',
                          style: Styles.black104,
                          strutStyle: StrutStyle(height: 1.3),
                        ),
                        Expanded(
                            child: Text(
                          itemValueTranslats.first.values!,
                          maxLines: 1,
                          strutStyle: StrutStyle(height: 1.7),
                          style: Styles.blue125,
                        )),
                      ],
                    )),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (expended == index) {
                            expended = -1;
                          } else
                            expended = index;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: expended == index
                            ? Image.asset(
                                "assets/circle_arrow.png",
                                scale: 2.2,
                              )
                            : Image.asset(
                                "assets/circle_down_arrow.png",
                                scale: 2.2,
                              ),
                      ),
                    )
                  ],
                ),
                Visibility(
                    visible: expended == index,
                    child: Divider(
                      thickness: 2,
                    )),
                Visibility(
                    visible: expended == index,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: cWidget(
                          fields, nameofItem, itemMap[nameofItem.toString()]!),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> cWidget(List<HouseHoldFielItemdModel> itemfields, int itemName,
      Map<String, dynamic> itemFields) {
    List<Widget> screenItems = [];
    if (itemfields.length > 0) {
      for (int i = 0; i < itemfields.length; i++) {
        screenItems
            .add(widgetTypeWidget(i, itemfields[i], itemName, itemFields));
        screenItems.add(SizedBox(height: 5.h));
        if (!logic!
            .callDependingLogic( myMap, itemfields[i])) {
          // myMap.remove(itemfields[i].fieldname);
          // itemMap[itemName]!.remove(itemfields[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem, int itemName,
      Map<String, dynamic> itemFields) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        // if (quesItem.fieldname == 'do_you_have_height_weight' &&
        //     Global.stringToInt(
        //         itemsAnswred['do_you_have_height_weight'].toString()) !=
        //         1) {
        //   itemsAnswred['do_you_have_height_weight'] = '2';
        //   updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
        // }
        return DynamicCustomDropdownField(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred:
              logic!.dependeOnMendotory( itemFields, quesItem),
          items: items,
          selectedItem: itemFields[quesItem.fieldname!],
          isVisible:
              logic!.callDependingLogic( itemFields, quesItem),
          onChanged: (value) {
            if (value != null)
              itemFields[quesItem.fieldname!] = value.name;
            else
              itemFields.remove(quesItem.fieldname);

            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);

            // setState(() {});
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred:
              logic!.dependeOnMendotory( itemFields, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemFields[quesItem.fieldname!],
          readable:
              logic!.callReadableLogic( itemFields, quesItem),
          isVisible:
              logic!.callDependingLogic( itemFields, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              itemFields[quesItem.fieldname!] = value;
              var logData = logic!
                  .callAutoGeneratedValue( itemFields, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  itemFields.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  // updateItemsForChildren(itemFields, ChildEnrollGUID);
                  // setState(() {});
                }
              }
            } else {
              itemFields.remove(quesItem.fieldname);
              // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
              // setState(() {});
            }
          },
        );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialValue: itemFields[quesItem.fieldname],
          isRequred:
              logic!.dependeOnMendotory( itemFields, quesItem),
          labelControlls: translats,
          lng: lng,
          readable:
              logic!.callReadableLogic( itemFields, quesItem),
          isVisible:
              logic!.callDependingLogic( itemFields, quesItem),
          onChanged: (value) {
            // if (value > 0)
            print('yesNo $value');
            itemFields[quesItem.fieldname!] = value;
            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
            setState(() {});
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          maxline: 3,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred:
              logic!.dependeOnMendotory( itemFields, quesItem),
          initialvalue: itemFields[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable:
              logic!.callReadableLogic( itemFields, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible:
              logic!.callDependingLogic( itemFields, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              itemFields[quesItem.fieldname!] = value;
            else
              itemFields.remove(quesItem.fieldname);
            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred:
              logic!.dependeOnMendotory( itemFields, quesItem),
          maxlength: quesItem.length,
          readable:
              logic!.callReadableLogic( itemFields, quesItem),
          initialvalue: itemFields[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null)
              itemFields[quesItem.fieldname!] = value;
            else {
              itemFields.remove(quesItem.fieldname);

              // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
              setState(() {});
            }
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred:
              logic!.dependeOnMendotory( itemFields, quesItem),
          maxlength: quesItem.length,
          readable:
              logic!.callReadableLogic( itemFields, quesItem),
          initialvalue: itemFields[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value.isNotEmpty)
              itemFields[quesItem.fieldname!] = value;
            else
              itemFields.remove(quesItem.fieldname);

            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
          },
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred:
              logic!.dependeOnMendotory( itemFields, quesItem),
          initialvalue: itemFields[quesItem.fieldname!],
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          maxlength: quesItem.length,
          readable:
              logic!.callReadableLogic( itemFields, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible:
              logic!.callDependingLogic( itemFields, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              itemFields[quesItem.fieldname!] = value;
            else
              itemFields.remove(quesItem.fieldname);

            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
          },
        );
      case 'Date':
        return CustomDatepickerDynamic(
          initialvalue: itemFields[quesItem.fieldname],
          fieldName: quesItem.fieldname,
          readable:
              logic!.callReadableLogic( itemFields, quesItem),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!
                  .dependeOnMendotory( itemFields, quesItem),
          isVisible:
              logic!.callDependingLogic( itemFields, quesItem),
          calenderValidate:
              logic!.calenderValidation( itemFields, quesItem),
          onChanged: (value) {
            // myMap[quesItem.fieldname!] = value;
            // var logData = logic!
            //     .callDateDiffrenceLogic( myMap, quesItem);
            // if (logData.isNotEmpty) {
            //   if (logData.keys.length > 0) {
            //     // var item =myMap[logData.keys.first];
            //     // if(item==null||logData.values.first!=item) {
            //     myMap.addEntries(
            //         [MapEntry(logData.keys.first, logData.values.first)]);
            //     setState(() {});
            //     // }
            //   }
            // }
            if (value != null) {
              if (itemMap.containsKey(itemName.toString())) {
                setState(() {
                  itemMap[itemName.toString()]![quesItem.fieldname!] = value;
                });
              }
            }
          },
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
        );

      case 'Float':
        // if (quesItem.fieldname == "quantity_required") {
        //   itemMap['$itemName'] = {'${quesItem.fieldname}': quatRequired};
        // }
        return DynamicCustomTextFieldFloat(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!
                  .dependeOnMendotory( itemFields, quesItem),
          // maxlength: quesItem.length,
          fieldName: quesItem.fieldname!,
          initialvalue: itemFields[quesItem.fieldname],
          readable:
              logic!.callReadableLogic( itemFields, quesItem),
          isVisible:
              logic!.callDependingLogic( itemFields, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              // myMap[quesItem.fieldname!] = value;
              if (itemMap.containsKey(itemName.toString())) {
                // setState(() {
                itemMap[itemName.toString()]![quesItem.fieldname!] = value;
                // });
              }

              if (quesItem.fieldname == 'wastage' ||
                  quesItem.fieldname == 'usage') {
                var validationMessge = logic!
                    .validationMessge( itemFields, quesItem);
                if (!Global.validString(validationMessge)) {
                  if (quesItem.fieldname == 'wastage') {
                    var logData = logic!
                        .callAutoGeneratedValue( itemFields, quesItem);
                    if (logData.isNotEmpty) {
                      if (logData.keys.length > 0) {
                        // myMap.addEntries(
                        //     [MapEntry(logData.keys.first, logData.values.first)]);
                        // itemMap.addEntries([
                        //   MapEntry('$itemName',
                        //       {'${logData.keys.first}': logData.values.first})
                        // ]);
                        itemMap[itemName.toString()]![logData.keys.first
                            .toString()
                            .trim()] = logData.values.first;
                        print(itemMap.length);
                        // setState(() {});
                      }
                    }
                  }
                } else {
                  Validate().singleButtonPopup(
                      Global.returnTrLable(translats, validationMessge, lng),
                      Global.returnTrLable(translats, CustomText.ok, lng),
                      false,
                      context);
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

  Future<void> updateHiddenValue(List<StockResponseModel> alrecords) async {
    userName = (await Validate().readString(Validate.userName))!;
    // var alrecords =
    //     await RequisitionResponseHelper().getRequisitonsByGuid(widget.rguid!);
    if (alrecords.length > 0) {
      Map<String, dynamic> responcesData = jsonDecode(alrecords[0].responces!);
      responcesData.remove('stock_list');
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
        myMap['sguid'] = widget.sguid;
        myMap['month'] = widget.month.toString();
        myMap['year'] = widget.year.toString();
      }
    }
  }

  Future<void> callScreenController(screen_type) async {
    // userName = (await Validate().readString(Validate.userName))!;
    await StockFieldHelper().getStockFields().then((value) {
      allItems = value;
    });
    allItems = allItems
        .where((element) => !hiddens.contains(element.fieldname))
        .toList();
    List<String> defaultCommon = [];
    for (int i = 0; i < allItems.length; i++) {
      if (Global.validString(allItems[i].options)) {
        // if (allItems[i].options == "Partner Stock") {

        // }
        defaultCommon.add('tab${allItems[i].options!.trim()}');
      }
    }
    await OptionsModelHelper()
        .callPartnerStockOptions('Partner Stock', lng!, 'Stock Child table',
            Global.stringToInt(widget.creche_id), widget.month, widget.year)
        .then((value) => options.addAll(value));
    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng!)
        .then((value) => options.addAll(value));
    List<TabFormsLogic> logics=[];
    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logics.addAll(data);
    });
    await FormLogicDataHelper().callFormLogic('Creche Stock').then((data) {
      logics.addAll(data);
      logic=DependingLogic(translats, logics, lng);
    });

    setState(() {
      _isLoading = false;
    });
  }

  String getOptionsFromName(int name, String flag) {
    String option = '';
    if (flag == "Year") {
      var list = yearList.where((element) {
        return Global.stringToInt(element.name) == name;
      });
      option = list.first.values!;
    } else if (flag == 'Months') {
      var list = monthsList.where((element) {
        return Global.stringToInt(element.name) == name;
      });
      option = list.first.values!;
    }
    return option;
  }

  bool _checkValidation() {
    var validStatus = true;
    for (var element in allItems) {
      if (element.reqd == 1) {
        for (var name in itemMap.keys) {
          var values = itemMap[name]?[element.fieldname];
          if (!Global.validString(values.toString())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(translats, CustomText.plsFilManForm, lng!),
                Global.returnTrLable(translats, CustomText.ok, lng!),
                false,
                context);
            validStatus = false;
            break;
          }
          var validationMsg = logic!
              .validationMessge( itemMap[name]!, element);
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
      }
    }

    return validStatus;
  }

  Future<void> saveDataInData() async {
    if (itemMap.keys.length > 0) {
      List<Map<String, dynamic>> itemsList = [];
      // itemMap.keys.forEach((item) {
      //   if (itemMap[item]!.keys.length > 0) {
      //     itemMap[item]!.addEntries([MapEntry('stock_item', item.trim())]);
      //     itemsList.add(itemMap[item]!);
      //   }
      // });
      for (var item in itemMap.keys) {
        if (itemMap[item]!.keys.length > 0) {
          itemMap[item]!.addEntries([MapEntry('stock_item', item.trim())]);
          itemsList.add(itemMap[item]!);
        }
      }

      myMap['stock_list'] = itemsList;
      String responseJS = jsonEncode(myMap);
      var record = StockResponseModel(
        sguid: widget.sguid,
        responces: responseJS,
        month: widget.month,
        year: widget.year,
        creche_id: Global.stringToInt(widget.creche_id),
        is_deleted: 0,
        is_edited: 1,
        name: myMap['name'] ?? null,
        is_uploaded: 0,
        created_at: myMap['appcreated_on'],
        created_by: myMap['appcreated_by'],
        update_at: myMap['app_updated_on'],
        updated_by: myMap['app_updated_by'],
      );
      await StockResponseHelper().inserts(record);
    }
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

  filterDataQu(String entry) {
    if (entry.length > 0) {
      filtered_stock_items_list = stock_item_list.where((element) {
        var itemValue =
            getItemNameFromid(Global.stringToInt(element['stock_item']));
        return itemValue
            .toString()
            .toLowerCase()
            .startsWith(entry.toLowerCase());
      }).toList();
    } else {
      filtered_stock_items_list = stock_item_list;
    }
    setState(() {});
    print('cLength: ${filtered_stock_items_list.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          backgroundColor: Color(0xff5979AA),
          leading: Padding(
            padding: EdgeInsets.only(left: 10.0),
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
          title: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Global.returnTrLable(
                            translats, CustomText.stockDetails, lng),
                        style: Styles.white145,
                      ),
                      Text(
                        creche_name ?? '',
                        style: Styles.white126P,
                      ),
                      // Add additional TextSpans here if needed
                    ],
                  ),
                )
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${getOptionsFromName(widget.month, 'Months')} - ${getOptionsFromName(widget.year, 'Year')}',
                            style: Styles.black145,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      child: Row(
                        children: [
                          Expanded(
                              child: CustomTextFieldRow(
                            controller: _textController,
                            onChanged: (value) {
                              print(value);
                              filterDataQu(value);
                            },
                            hintText: Global.returnTrLable(
                                translats, CustomText.Search, lng),
                            prefixIcon: Image.asset(
                              "assets/search.png",
                              scale: 2.4,
                            ),
                          ))
                        ],
                      ),
                    ),
                    Divider(),
                    Flexible(
                        fit: FlexFit.loose,
                        child: (stock_item_list.isNotEmpty)
                            ? itemCard(
                                List<Map<String, dynamic>>.from(
                                    filtered_stock_items_list),
                                allItems,
                                0)
                            : Center(
                                child: Text(Global.returnTrLable(
                                    translats, CustomText.noItemsAvail, lng)),
                              )),
                    Divider(),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Row(
                          children: [
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
                          ],
                        ))
                  ],
                ),
              ));
  }
}
