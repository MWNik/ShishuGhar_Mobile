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

class Replica extends StatefulWidget {
  final String sguid;
  final String creche_id;
  final int month;
  final int year;
  final bool isEdit;
  final List<Map<String, dynamic>> itemList;

  Replica({
    super.key,
    required this.itemList,
    required this.creche_id,
    required this.month,
    required this.year,
    required this.sguid,
    required this.isEdit,
  });

  @override
  State<Replica> createState() => _ReplicaState();
}

class _ReplicaState extends State<Replica> {
  bool _isLoading = true;
  TextEditingController _textController = TextEditingController();
  List<TabFormsLogic> logics = [];
  List<OptionsModel> monthsList = [];
  List<OptionsModel> yearList = [];
  // List<PartnerStockModel> partnerStockItemList = [];
  List<PartnerStockModel> allItemsList = [];
  List<StockResponseModel> requested_stock_item = [];

  // List<StockResponseModel> previous_month_data = [];
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
  String? role;
  List<CresheDatabaseResponceModel> creche_rec = [];
  String? creche_name;
  List<dynamic> stock_item_list = [];
  List<dynamic> filtered_stock_items_list = [];
  List<Map<String, dynamic>> previous_month_stock = [];
  Map<int, double> closing_stock_Map = {};
  Map<String, FocusNode> _foocusNode = {};
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    intitializeData();
  }

  Future<void> intitializeData() async {
    role = (await Validate().readString(Validate.role))!;
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
      CustomText.back
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

    await updateHiddenValue();
    await callScreenController('Stock Child table');
    await fetchStockItes();
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
    previous_month_stock = await StockResponseHelper()
        .getPrevStockresponseByYearMonth(
            Global.stringToInt(widget.creche_id), widget.year, widget.month);
    if (previous_month_stock.isNotEmpty) {
      var map = jsonDecode(previous_month_stock.first['responces']);
      var previous_month_stock_list = map['stock_list'];
      for (var elements in previous_month_stock_list) {
        closing_stock_Map.addEntries([
          MapEntry(Global.stringToInt(elements['stock_item']),
              elements['closing_stock'])
        ]);
      }
    }

    stock_item_list = widget.itemList;
    filtered_stock_items_list = stock_item_list;
    if (filtered_stock_items_list.isNotEmpty) {
      for (var stockitems in stock_item_list) {
        Map<String, dynamic> itemIndivMap = {};
        stockitems.forEach((key, value) {
          itemIndivMap[key] = value;
        });
        itemIndivMap['opening_stock'] =
            closing_stock_Map[Global.stringToInt(stockitems['stock_item'])];
        itemMap.addEntries(
            [MapEntry('${stockitems['stock_item']}', itemIndivMap)]);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget itemCard(List<Map<String, dynamic>> stockItemList,
      List<HouseHoldFielItemdModel> fields, int type) {
    return ListView.builder(
      controller: _scrollController,
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
        if (!DependingLogic()
            .callDependingLogic(logics, myMap, itemfields[i])) {
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
          focusNode: _foocusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred:
              DependingLogic().dependeOnMendotory(logics, itemFields, quesItem),
          items: items,
          readable: role == CustomText.crecheSupervisor ? null : true,
          selectedItem: itemFields[quesItem.fieldname!],
          isVisible:
              DependingLogic().callDependingLogic(logics, itemFields, quesItem),
          onChanged: (value) {
            if (value != null) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]![quesItem.fieldname!] = value;
              }
            } else {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!.remove(quesItem.fieldname);
              }
            }

            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);

            // setState(() {});
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          focusNode: _foocusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred:
              DependingLogic().dependeOnMendotory(logics, itemFields, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemFields[quesItem.fieldname!],
          readable: role == CustomText.crecheSupervisor
              ? DependingLogic().callReadableLogic(logics, itemFields, quesItem)
              : true,
          isVisible:
              DependingLogic().callDependingLogic(logics, itemFields, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]![quesItem.fieldname!] = value;
              }
              var logData = DependingLogic()
                  .callAutoGeneratedValue(logics, itemFields, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  itemFields.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  // updateItemsForChildren(itemFields, ChildEnrollGUID);
                  // setState(() {});
                }
              }
            } else {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!.remove(quesItem.fieldname);
              }
            }
          },
        );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialValue: itemFields[quesItem.fieldname],
          isRequred:
              DependingLogic().dependeOnMendotory(logics, itemFields, quesItem),
          labelControlls: translats,
          lng: lng,
          readable: role == CustomText.crecheSupervisor
              ? DependingLogic().callReadableLogic(logics, itemFields, quesItem)
              : true,
          isVisible:
              DependingLogic().callDependingLogic(logics, itemFields, quesItem),
          onChanged: (value) {
            // if (value > 0)
            print('yesNo $value');
            if (itemMap.containsKey(itemName.toString())) {
              itemMap[itemName.toString()]![quesItem.fieldname!] = value;
            }
            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
            setState(() {});
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          focusNode: _foocusNode[quesItem.fieldname],
          maxline: 3,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred:
              DependingLogic().dependeOnMendotory(logics, itemFields, quesItem),
          initialvalue: itemFields[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: role == CustomText.crecheSupervisor
              ? DependingLogic().callReadableLogic(logics, itemFields, quesItem)
              : true,
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible:
              DependingLogic().callDependingLogic(logics, itemFields, quesItem),
          onChanged: (value) {
            if (value != null) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]![quesItem.fieldname!] = value;
              }
            } else {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!.remove(quesItem.fieldname);
              }
            }
            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          focusNode: _foocusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred:
              DependingLogic().dependeOnMendotory(logics, itemFields, quesItem),
          maxlength: quesItem.length,
          readable: role == CustomText.crecheSupervisor
              ? DependingLogic().callReadableLogic(logics, itemFields, quesItem)
              : true,
          initialvalue: itemFields[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]![quesItem.fieldname!] = value;
              }
            } else {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!.remove(quesItem.fieldname);
              }
              setState(() {});
            }
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          focusNode: _foocusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred:
              DependingLogic().dependeOnMendotory(logics, itemFields, quesItem),
          maxlength: quesItem.length,
          readable: role == CustomText.crecheSupervisor
              ? DependingLogic().callReadableLogic(logics, itemFields, quesItem)
              : true,
          initialvalue: itemFields[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]![quesItem.fieldname!] = value;
              }
            } else {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!.remove(quesItem.fieldname);
              }
            }

            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
          },
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          focusNode: _foocusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred:
              DependingLogic().dependeOnMendotory(logics, itemFields, quesItem),
          initialvalue: itemFields[quesItem.fieldname!],
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!, logics),
          maxlength: quesItem.length,
          readable: role == CustomText.crecheSupervisor
              ? DependingLogic().callReadableLogic(logics, itemFields, quesItem)
              : true,
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible:
              DependingLogic().callDependingLogic(logics, itemFields, quesItem),
          onChanged: (value) {
            if (value != null) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]![quesItem.fieldname!] = value;
              }
            } else {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!.remove(quesItem.fieldname);
              }
            }

            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
          },
        );
      case 'Date':
        return CustomDatepickerDynamic(
          focusNode: _foocusNode[quesItem.fieldname],
          initialvalue: itemFields[quesItem.fieldname],
          fieldName: quesItem.fieldname,
          readable: role == CustomText.crecheSupervisor
              ? DependingLogic().callReadableLogic(logics, itemFields, quesItem)
              : true,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic()
                  .dependeOnMendotory(logics, itemFields, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(logics, itemFields, quesItem),
          calenderValidate:
              DependingLogic().calenderValidation(logics, itemFields, quesItem),
          onChanged: (value) {
            // myMap[quesItem.fieldname!] = value;
            // var logData = DependingLogic()
            //     .callDateDiffrenceLogic(logics, myMap, quesItem);
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
            } else {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!.remove(quesItem.fieldname);
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
          focusNode: _foocusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : quesItem.fieldname == 'usage' || quesItem.fieldname == 'wastage'
                  ? 1
                  : DependingLogic()
                      .dependeOnMendotory(logics, itemFields, quesItem),
          // maxlength: quesItem.length,

          fieldName:
              (quesItem.fieldname == 'usage' || quesItem.fieldname == 'wastage')
                  ? 'weight'
                  : quesItem.fieldname!,
          initialvalue: itemFields[quesItem.fieldname],
          readable: role == CustomText.crecheSupervisor
              ? DependingLogic().callReadableLogic(logics, itemFields, quesItem)
              : true,
          isVisible:
              DependingLogic().callDependingLogic(logics, itemFields, quesItem),
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
                // var validationMessge = DependingLogic()
                //     .validationMessge(logics, itemFields, quesItem);
                // if (!Global.validString(validationMessge)) {
                // if (quesItem.fieldname == 'wastage') {
                var logData = DependingLogic()
                    .callAutoGeneratedValue(logics, itemFields, quesItem);
                if (logData.isNotEmpty) {
                  if (logData.keys.length > 0) {
                    itemMap[itemName.toString()]![logData.keys.first
                        .toString()
                        .trim()] = logData.values.first;

                    // setState(() {});
                  }
                }
                // }
                // } else {
                // Validate().singleButtonPopup(
                //     Global.returnTrLable(translats, validationMessge, lng),
                //     Global.returnTrLable(translats, CustomText.ok, lng),
                //     false,
                //     context);
                // }
              }
            } else {
              if (itemMap.containsKey(itemName.toString())) {
                // setState(() {
                itemMap[itemName.toString()]!.remove(quesItem.fieldname);
                // });
              }
              if (quesItem.fieldname == 'wastage' ||
                  quesItem.fieldname == 'usage') {
                var logData = DependingLogic()
                    .callAutoGeneratedValue(logics, itemFields, quesItem);
                if (logData.isNotEmpty) {
                  if (logData.keys.length > 0) {
                    itemMap[itemName.toString()]![logData.keys.first
                        .toString()
                        .trim()] = logData.values.first;
                  }
                }
              }
            }
          },
        );
      default:
        return SizedBox();
    }
  }

  Future<void> updateHiddenValue() async {
    userName = (await Validate().readString(Validate.userName))!;
    // var alrecords =
    //     await RequisitionResponseHelper().getRequisitonsByGuid(widget.rguid!);
    var alrecords = await StockResponseHelper().gteStockByGuid(widget.sguid);
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

    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logics.addAll(data);
    });
    await FormLogicDataHelper().callFormLogic('Creche Stock').then((data) {
      logics.addAll(data);
    });
    for (var elements in allItems) {
      _foocusNode.addEntries([MapEntry(elements.fieldname!, FocusNode())]);
    }
    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value) {
        _foocusNode.forEach((_, focusNode) => focusNode.unfocus());
      }
    });

    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _foocusNode.forEach((_, focusnode) => focusnode.dispose());
    super.dispose();
  }

  String getOptionsFromName(int name, String flag) {
    String option = '';
    int limit = 3;
    if (flag == "Year") {
      var list = yearList.where((element) {
        return Global.stringToInt(element.name) == name;
      });
      option = list.first.values!;
    } else if (flag == 'Months') {
      var list = monthsList.where((element) {
        return Global.stringToInt(element.name) == name;
      });
      option = list.first.values!.length > limit
          ? list.first.values!.substring(0, limit)
          : list.first.values!;
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
          var validationMsg = DependingLogic().validationMessge(
              logics, itemMap[name]!, element, translats, lng);
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
                            style: Styles.black12700,
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
                    // Divider(),
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
                            widget.isEdit ? SizedBox(width: 10) : SizedBox(),
                            widget.isEdit
                                ? Expanded(
                                    child: CElevatedButton(
                                    color: Color(0xff369A8D),
                                    onPressed: () {
                                      nextTab(1, context);
                                    },
                                    text: Global.returnTrLable(
                                        translats, CustomText.Submit, lng!),
                                  ))
                                : SizedBox()
                          ],
                        ))
                  ],
                ),
              ));
  }
}
