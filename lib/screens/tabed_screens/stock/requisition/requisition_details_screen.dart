import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
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
import 'package:shishughar/database/helper/requisition/requisition_fields_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/creche_database_responce_model.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/partner_stock_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/model/dynamic_screen_model/requisition_response_model.dart';
import 'package:shishughar/model/dynamic_screen_model/stock_response_model.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/depending_logic.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

class RequisitionDetails extends StatefulWidget {
  final String rguid;
  final int month;
  final int year;
  final String creche_id;
  final String child_count;
  int? name;
  final bool isEdit;
  StockResponseModel? stockData;
  // final bool isOnlyView;

  RequisitionDetails(
      {super.key,
      required this.rguid,
      required this.child_count,
      required this.year,
      required this.month,
      required this.creche_id,
      required this.isEdit,
      this.name,
      this.stockData
      // required this.isOnlyView
      });

  @override
  State<RequisitionDetails> createState() => _RequisitionDetailsState();
}

class _RequisitionDetailsState extends State<RequisitionDetails> {
  TextEditingController textController = TextEditingController();
  DependingLogic? logic;
  List<OptionsModel> monthsList = [];
  List<OptionsModel> yearList = [];
  List<PartnerStockModel> partnerStockItemList = [];
  List<PartnerStockModel> filteredPartnerStock = [];
  List<PartnerStockModel> removedItemList = [];
  List<PartnerStockModel> addbackList = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String lng = 'en';
  String userName = '';
  bool _isLoading = true;
  List<HouseHoldFielItemdModel> allItems = [];
  HouseHoldFielItemdModel receivedQuantField = HouseHoldFielItemdModel();
  HouseHoldFielItemdModel receivedDateField = HouseHoldFielItemdModel();
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
    'requistion_item',
    'amount'
  ];
  int? expended;
  int? expendedNav;
  List<CresheDatabaseResponceModel> creche_rec = [];
  String? creche_name;
  Map<String, FocusNode> _foocusNode = {};
  ScrollController _scrollController = ScrollController();
  Map<String, Map<String, dynamic>> stockItemsList = {};
  String? role;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    role = (await Validate().readString(Validate.role))!;
    var lngtr = (await Validate().readString(Validate.sLanguage))!;
    lng = lngtr;
      List<String> valueNames = [
      CustomText.noItemsAvail,
      CustomText.ok,
      CustomText.selectItemForAdd,
      CustomText.requiDetails,
      CustomText.Search,
      CustomText.Submit,
      CustomText.received,
      CustomText.supplied,
      CustomText.back,
      CustomText.plsFilManForm,
      CustomText.dataSaveSuc,
      CustomText.removedItem,
      CustomText.noREmovedItem,
      CustomText.add,
      CustomText.required,
      CustomText.Yes,
      CustomText.No,
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

    creche_rec = await CrecheDataHelper()
        .getCrecheResponceItem(Global.stringToInt(widget.creche_id));
    creche_name = Global.getItemValues(creche_rec[0].responces!, 'creche_name');

    monthsList = await OptionsModelHelper().getMstCommonOptions('Months', lng);
    yearList = await OptionsModelHelper().getMstCommonOptions('Year', lng);
    if (widget.stockData != null)
      stockItemsList = fetchItemsList(widget.stockData);
    await fetchItemsbyPartner();
    await updateHiddenValue();
    await callscreenController('Requisition Child table');
  }

  Map<String, Map<String, dynamic>> fetchItemsList(
      StockResponseModel? stockData) {
    Map<String, Map<String, dynamic>> items = {};
    if (stockData!.responces!.isNotEmpty) {
      var map = jsonDecode(stockData.responces!)['stock_list'];
      var items_map_list = List<Map<String, dynamic>>.from(map);
      if (items_map_list.isNotEmpty) {
        for (var elements in items_map_list) {
          items[elements['stock_item']] = elements;
        }
      }
    }
    return items;
  }

  Future<void> fetchItemsbyPartner() async {
    partnerStockItemList = await PartnerStockHelper().getAllRecords();
    filteredPartnerStock = partnerStockItemList;
    print(partnerStockItemList.length);
    setState(() {});
  }

  filterDataQu(String entry) {
    if (entry.length > 0) {
      filteredPartnerStock = partnerStockItemList
          .where((element) => element.items
              .toString()
              .toLowerCase()
              .startsWith(entry.toLowerCase()))
          .toList();
    } else {
      filteredPartnerStock = partnerStockItemList;
    }
    setState(() {});
    print('cLength: ${filteredPartnerStock.length}');
  }

  Future<void> callscreenController(screen_type) async {
    userName = (await Validate().readString(Validate.userName))!;
    lng = (await Validate().readString(Validate.sLanguage))!;

    await RequisitionFieldsHelper()
        .getRequisitionByParent(screen_type)
        .then((value) {
      allItems = value;
    });
    allItems = allItems
        .where((element) => !(hiddens.contains(element.fieldname)))
        .toList();

    List<String> defaultCommon = [];
    for (int i = 0; i < allItems.length; i++) {
      if (Global.validString(allItems[i].options)) {
        //     if (allItems[i].options == 'Partner Stock') {
        // await OptionsModelHelper()
        //     .getAllMstCommonNotINPartenerStock('tab${allItems[i].options}',
        //         Global.stringToInt(widget.creche_id), widget.rguid,widget.year,widget.month, lng!)
        //     .then((value) => {
        //           options.addAll(value),
        //           if (value.length == 1)
        //             {
        //               defaultDisableDailog(
        //                   allItems[i].fieldname!, allItems[i].options!)
        //             }
        //         });

        // } else
        defaultCommon.add('tab${allItems[i].options!.trim()}');
      }
    }
    await OptionsModelHelper()
        .callPartnerStockOptions(
            'Partner Stock',
            lng,
            'Requisition Child table',
            Global.stringToInt(widget.creche_id),
            widget.month,
            widget.year)
        .then((value) => options.addAll(value));
    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng)
        .then((value) => options.addAll(value));

    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logic = DependingLogic(translats, data, lng);
    });
    List<String> labelTranslats = [];
    for (var element in allItems) {
      _foocusNode.addEntries([MapEntry(element.fieldname!, FocusNode())]);
      if(Global.validString(element.label)){labelTranslats.add(element.label!);}
    }

    await TranslationDataHelper().callTranslateString(labelTranslats).then((value) => translats.addAll(value));
    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value) {
        _foocusNode.forEach((_, focusNode) => focusNode.unfocus());
      }
    });
    receivedQuantField = allItems
        .where((element) => element.fieldname == 'quantity_received')
        .toList()
        .first;
    receivedDateField = allItems
        .where((element) => element.fieldname == 'received_date')
        .toList()
        .first;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _foocusNode.forEach((_, focusNode) => focusNode.dispose());
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

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [SizedBox()],
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
                            translats, CustomText.requiDetails, lng),
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
        endDrawer: SafeArea(
            child: Drawer(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            child: Column(
              children: [
                Text(
                  Global.returnTrLable(translats, CustomText.removedItem, lng),
                  style: TextStyle(
                      color: Colors.purple[400],
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                ),
                Flexible(
                    fit: FlexFit.loose,
                    child: removedItemList.isNotEmpty
                        ? itemCard(removedItemList, allItems, 1)
                        : Center(
                            child: Text(Global.returnTrLable(
                                translats, CustomText.noREmovedItem, lng)),
                          )),
                Divider(),
                SizedBox(height: 5),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: CElevatedButton(
                        text:
                            Global.returnTrLable(translats, CustomText.add, lng),
                        color: Colors.red[500],
                        onPressed: () {
                          if (addbackList.isNotEmpty) {
                            filteredPartnerStock.addAll(addbackList);
                            addbackList.forEach((element) {
                              removedItemList.remove(element);
                            });
                            addbackList.clear();
                          } else {
                            Validate().singleButtonPopup(
                                Global.returnTrLable(
                                    translats, CustomText.selectItemForAdd, lng),
                                Global.returnTrLable(
                                    translats, CustomText.ok, lng),
                                false,
                                context);
                          }
                          setState(() {});
                        }))
              ],
            ),
          ),
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _isLoading
            ? SizedBox()
            : removedItemList.isEmpty || !widget.isEdit
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: FloatingActionButton(
                      backgroundColor: Color(0xff5979AA),
                      onPressed: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Image.asset(
                        "assets/add_btn.png",
                        scale: 2.7,
                        color: Colors.white,
                      ),
                    ),
                  ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextFieldRow(
                              controller: textController,
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
                            ),
                          ),
                          // SizedBox(
                          //   width: 10.w,
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //     _scaffoldKey.currentState!.openEndDrawer();
                          //   },
                          //   child: Image.asset(
                          //     "assets/filter_icon.png",
                          //     scale: 2.4,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: (filteredPartnerStock.isNotEmpty)
                          ? itemCard(filteredPartnerStock, allItems, 0)
                          : Center(
                              child: Text(Global.returnTrLable(
                                  translats, CustomText.noItemsAvail, lng))),
                    ),

                    // Spacer(),
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
                                  translats, CustomText.back, lng),
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
                                        translats, CustomText.Submit, lng),
                                  ))
                                : SizedBox()
                          ],
                        ))
                  ],
                ),
              ),
      ),
    );
  }

  bool _checkValidation() {
    var validStatus = true;
    for (var element in allItems) {
      for (var name in itemMap.keys) {
        if (element.reqd == 1) {
          var values = itemMap[name]?[element.fieldname];
          if (!Global.validString(values.toString())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(translats, CustomText.plsFilManForm, lng),
                Global.returnTrLable(translats, CustomText.ok, lng),
                false,
                context);
            validStatus = false;
            break;
          }
        }

        var validationMsg = logic!.validationMessge(itemMap[name]!, element);
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
    }

    return validStatus;
  }

  Future<void> saveDataInData() async {
    if (itemMap.keys.length > 0) {
      List<Map<String, dynamic>> itemsList = [];
      // itemMap.keys.forEach((item) {
      //   if (itemMap[item]!.keys.length > 0) {
      //     itemMap[item]!.addEntries([MapEntry('requistion_item', item.trim())]);
      //     itemsList.add(itemMap[item]!);
      //   }
      // });
      for (var item in itemMap.keys) {
        if (itemMap[item]!.keys.length > 0) {
          itemMap[item]!.addEntries([MapEntry('requistion_item', item.trim())]);
          itemsList.add(itemMap[item]!);
        }
      }
      myMap['requisition_list'] = itemsList;
      String responseJS = jsonEncode(myMap);
      var record = RequisitionResponseModel(
        rguid: widget.rguid,
        responces: responseJS,
        month: widget.month,
        year: widget.year,
        creche_id: Global.stringToInt(widget.creche_id),
        is_deleted: 0,
        is_edited: 1,
        name: myMap['name'],
        is_uploaded: 0,
        created_at: myMap['appcreated_on'],
        created_by: myMap['appcreated_by'],
        update_at: myMap['app_updated_on'],
        updated_by: myMap['app_updated_by'],
      );
      await RequisitionResponseHelper().inserts(record);
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

        setState(() {});
      }
    } else {
      Navigator.pop(context, 'itemRefresh');
    }
  }

  Future<void> updateHiddenValue() async {
    userName = (await Validate().readString(Validate.userName))!;
    var alrecords =
        await RequisitionResponseHelper().getRequisitonsByGuid(widget.rguid);
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
      List<int> itemListName = [];
      responcesData['requisition_list'].forEach((element) {
        itemListName.add(Global.stringToInt(element['requistion_item']));
      });
      print(itemListName.length);
      removedItemList = filteredPartnerStock
          .where((element) => !itemListName.contains(element.name))
          .toList();
      filteredPartnerStock = filteredPartnerStock
          .where((element) => itemListName.contains(element.name))
          .toList();
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
        myMap['rguid'] = widget.rguid;
        myMap['month'] = widget.month.toString();
        myMap['year'] = widget.year.toString();
      }
    }
  }

  List<Widget> cWidget(
      List<HouseHoldFielItemdModel> itemfields,
      double quant_required,
      int itemName,
      Map<String, dynamic> itemFields,
      int type,
      bool isItemReadable) {
    List<Widget> screenItems = [];
    if (itemfields.length > 0) {
      for (int i = 0; i < itemfields.length; i++) {
        screenItems.add(widgetTypeWidget(i, itemfields[i], quant_required,
            itemName, itemFields, type, isItemReadable));
        screenItems.add(SizedBox(height: 5.h));
        if (!logic!.callDependingLogic(myMap, itemfields[i])) {
          // myMap.remove(itemfields[i].fieldname);
          // itemMap[itemName]!.remove(itemfields[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  double generateQuatityRequired(double childCount, double itemreqPerMonth) {
    double result = 0.0;
    var quantity = childCount * itemreqPerMonth;
    var twentyPercent = 0.2 * quantity;
    result = quantity + double.parse(twentyPercent.toStringAsFixed(1));
    return result;
  }

  bool checkisReadable(Map<String, dynamic>? itemData) {
    bool status = false;
    if (itemData!.isNotEmpty) {
      if (Global.validString(itemData['usage'].toString()) &&
          Global.validString(itemData['wastage'].toString())) {
        status = true;
      }
    }
    if (role != CustomText.crecheSupervisor) {
      status = true;
    }
    return status;
  }

  Map<String, dynamic> fetchFielddata(PartnerStockModel requi_iem) {
    Map<String, dynamic> foundItem = {};
    Map<String, dynamic> emptymap = {};
    var mapList = myMap['requisition_list'];
    if (mapList != null) {
      foundItem = mapList.firstWhere(
          (item) =>
              Global.stringToInt(item['requistion_item']) == requi_iem.name,
          orElse: () => emptymap);
    }
    return foundItem;
  }

  Widget itemCard(List<PartnerStockModel> parentStockList,
      List<HouseHoldFielItemdModel> fields, int type) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: parentStockList.length,
        physics: BouncingScrollPhysics(),
        shrinkWrap: false,
        itemBuilder: (BuildContext context, int index) {
          double itemReqPerChild = Global.stringToDouble(
              parentStockList[index].item_required_per_child_per_months);
          double child_count = Global.stringToDouble(widget.child_count);
          double quantity_required =
              generateQuatityRequired(child_count, itemReqPerChild);
          String itemvalue = ((lng == 'en')
              ? parentStockList[index].items
              : ((lng == 'hi')
                  ? parentStockList[index].hindi
                  : parentStockList[index].odia))!;
          var ItemName = parentStockList[index].name;
          var fieldData = fetchFielddata(parentStockList[index]);
          if (type == 0) {
            updateQuatRequired(ItemName, quantity_required, fieldData);
          }
          bool isReadable = false;
          if (stockItemsList.isNotEmpty &&
              stockItemsList.containsKey('$ItemName')) {
            isReadable = checkisReadable(stockItemsList['${ItemName}']);
          }
          bool isDeletable = true;
          if (Global.validString(fieldData['name'].toString())) {
            isDeletable = false;
          }

          // bool isExpended = false;
          return GestureDetector(
            onTap: () {
              if (type == 1 && fieldData.isNotEmpty) {
                setState(() {
                  if (expendedNav == index) {
                    expendedNav = -1;
                  } else {
                    expendedNav = index;
                  }
                  print('Expended for Nav Bar -------> $expendedNav');
                  print('Expended  -------> $expended');
                });
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 15,
                        offset: Offset(-3, -3),
                        spreadRadius: 3,
                        color: Colors.grey[300]!,
                        blurStyle: BlurStyle.outer)
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: (type == 0) ? 10 : 3,
                    vertical: (type == 0) ? 15 : 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (type == 0)
                                ? Text(
                                    '${index + 1}:',
                                    style: Styles.black104,
                                    strutStyle: StrutStyle(height: 1.3),
                                  )
                                : Text(''),
                            Text(' '),
                            Expanded(
                              child: RichText(
                                  strutStyle: StrutStyle(height: 1.7),
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: itemvalue,
                                      style: Styles.blue125,
                                    ),
                                    (type == 1)
                                        ? TextSpan(
                                            text: Global.validString(
                                                    quantity_required
                                                        .toString())
                                                ? '(${quantity_required.toString()})'
                                                : '',
                                            style: Styles.black124)
                                        : TextSpan(text: '')
                                  ])),
                            ),
                            SizedBox(width: 5),
                            (type == 0)
                                ? RichText(
                                    text: TextSpan(children: [
                                    TextSpan(
                                        text:
                                            '${Global.returnTrLable(translats, CustomText.required, lng)} : ',
                                        style: Styles.black105P),
                                    TextSpan(
                                        text: quantity_required.toString(),
                                        style: Styles.cardBlue10)
                                  ]))
                                : Text('')
                          ],
                        )),
                        SizedBox(width: 10),
                        (type == 0)
                            ? Visibility(
                                visible: checkExpandability(fieldData),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (expended == index) {
                                        expended = -1;
                                      } else
                                        expended = index;

                                      print(
                                          'Expended for Nav Bar -------> $expendedNav');
                                      print('Expended  -------> $expended');
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
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
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(left: 5, right: 4),
                                child: Checkbox(
                                    value: addbackList
                                            .contains(parentStockList[index])
                                        ? true
                                        : false,
                                    onChanged: (value) {
                                      if (value == true) {
                                        addbackList.add(parentStockList[index]);
                                        // setState(() {});
                                      } else if (value == false &&
                                          addbackList.contains(
                                              parentStockList[index])) {
                                        addbackList
                                            .remove(parentStockList[index]);
                                      }
                                      setState(() {});
                                    }),
                              ),
                        (type == 0) ? SizedBox(width: 10) : SizedBox(),
                        (type == 0)
                            ? !isDeletable
                                ? SizedBox()
                                : InkWell(
                                    onTap: () {
                                      removedItemList
                                          .add(parentStockList[index]);
                                      filteredPartnerStock
                                          .remove(parentStockList[index]);

                                      itemMap.removeWhere((key, value) =>
                                          Global.stringToInt(key) == ItemName);
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red[200],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.delete_outline_sharp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  )
                            : SizedBox()
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Visibility(
                        visible: type == 0
                            ? expended == index
                            : expendedNav == index,
                        child: Divider(
                          thickness: 2,
                        )),
                    Visibility(
                        visible: type == 0
                            ? expended == index
                            : expendedNav == index,
                        child: Container(
                          child: itemSupplyStatus(
                              fieldData, ItemName!, type, isReadable),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget itemSupplyStatus(Map<String, dynamic> fieldData, int itemName,
      int type, bool isItemReadable) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 6, left: 5),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                '${Global.returnTrLable(translats, CustomText.supplied, lng)} : ',
                            style: Styles.black124,
                          ),
                          TextSpan(
                              text: fieldData['quantity_supplied'].toString(),
                              style: Styles.cardBlue12),
                          TextSpan(
                              text: Global.validString(Validate()
                                      .displeDateFormate(
                                          fieldData['supply_date']))
                                  ? ' (${Validate().displeDateFormate(fieldData['supply_date'])})'
                                  : '',
                              style: Styles.black123)
                        ])),
                  ),
                  // (fieldData['quantity_received'] != null &&
                  //         fieldData['received_date'] != null)
                  (isItemReadable)
                      ? Expanded(
                          child: RichText(
                              text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "${Global.returnTrLable(translats, CustomText.received, lng)} : ",
                              style: Styles.black124),
                          TextSpan(
                              text: fieldData['quantity_received'].toString(),
                              style: Styles.cardBlue12),
                          TextSpan(
                              text: Global.validString(Validate()
                                      .displeDateFormate(
                                          fieldData['received_date']))
                                  ? ' (${Validate().displeDateFormate(fieldData['received_date'])})'
                                  : '',
                              style: Styles.black123)
                        ])))
                      : Text('')
                ],
              )),
          // (fieldData['quantity_received'] != null &&
          //         fieldData['received_date'] != null)
          (isItemReadable)
              ? Text('')
              : type == 1
                  ? SizedBox()
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: DynamicCustomTextFieldFloat(
                              hintText: Global.returnTrLable(
                                  translats, CustomText.typehere, lng),
                              height: 35.h,
                              maxlength: 4,
                              titleText: Global.returnTrLable(
                                  translats, CustomText.received, lng),
                              initialvalue: fieldData['quantity_received'],
                              isRequred: receivedQuantField.reqd == 1
                                  ? receivedQuantField.reqd
                                  : logic!.dependeOnMendotory(
                                      fieldData, receivedQuantField),
                              isVisible: logic!.callDependingLogic(
                                  fieldData, receivedQuantField),
                              onChanged: (value) async {
                                if (value != null) {
                                  fieldData['quantity_received'] = value;
                                  String? validateMessage = await logic!
                                      .validationMessge(
                                          fieldData, receivedQuantField);
                                  if (Global.validString(validateMessage)) {
                                    Validate().singleButtonPopup(
                                        validateMessage!,
                                        Global.returnTrLable(
                                            translats, CustomText.ok, lng),
                                        false,
                                        context);
                                  } else {
                                    if (itemMap
                                        .containsKey(itemName.toString())) {
                                      itemMap[itemName.toString()]![
                                          'quantity_received'] = value;
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: CustomDatepickerDynamic(
                                // width: 180,
                                initialvalue:
                                    fieldData[receivedDateField.fieldname],
                                fieldName: receivedDateField.fieldname,
                                readable: type == 1
                                    ? true
                                    : isItemReadable
                                        ? true
                                        : logic!.callReadableLogic(
                                            fieldData, receivedDateField),
                                isRequred: (receivedDateField.reqd == 1
                                    ? receivedDateField.reqd
                                    : logic!.dependeOnMendotory(
                                        fieldData, receivedDateField)),
                                isVisible: logic!.callDependingLogic(
                                    fieldData, receivedDateField),
                                calenderValidate: logic!.calenderValidation(
                                    fieldData, receivedDateField),
                                onChanged: (value) {
                                  if (itemMap
                                      .containsKey(itemName.toString())) {
                                    setState(() {
                                      itemMap[itemName.toString()]![
                                              receivedDateField.fieldname!] =
                                          value;
                                    });
                                  }
                                                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
        ],
      ),
    );
  }

  bool checkExpandability(Map<String, dynamic> fieldsData) {
    if (fieldsData.containsKey('supply_date') &&
        fieldsData.containsKey('quantity_supplied')) {
      return true;
    } else {
      return false;
    }
  }

  updateQuatRequired(
      int? iteName, double quatityRequired, Map<String, dynamic> fieldData) {
    if (fieldData.isEmpty) {
      if (itemMap.containsKey(iteName.toString()) == false) {
        itemMap.addEntries([
          MapEntry('$iteName', {
            'quantity_required': '$quatityRequired',
            'year': '${widget.year}',
            'month': '${widget.month}'
          })
        ]);
      }
    } else {
      if (itemMap.containsKey(iteName.toString()) == false) {
        itemMap.addEntries([MapEntry('$iteName', fieldData)]);
      }
    }
  }

  widgetTypeWidget(
      int index,
      HouseHoldFielItemdModel quesItem,
      double quatRequired,
      int itemName,
      Map<String, dynamic> itemFields,
      int type,
      bool isItemReadable) {
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
          isRequred: logic!.dependeOnMendotory(itemFields, quesItem),
          items: items,
          selectedItem: itemFields[quesItem.fieldname!],
          isVisible: logic!.callDependingLogic(itemFields, quesItem),
          readable: type == 1 ? true : isItemReadable,
          onChanged: (value) {
            if (value != null) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!['quantity_required'] =
                    value.toString();
              }
            } else {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!.remove(quesItem.fieldname);
              }
            }

            // updateItemsForChildren(itemsAnswred, ChildEnrollGUID);

            setState(() {});
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          focusNode: _foocusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: logic!.dependeOnMendotory(itemFields, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemFields[quesItem.fieldname!],
          readable: type == 1
              ? true
              : isItemReadable
                  ? true
                  : logic!.callReadableLogic(itemFields, quesItem),
          isVisible: logic!.callDependingLogic(itemFields, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!['quantity_required'] =
                    value.toString();
              }
              var logData = logic!.callAutoGeneratedValue(itemFields, quesItem);
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
          isRequred: logic!.dependeOnMendotory(itemFields, quesItem),
          labelControlls: translats,
          lng: lng,
          readable: type == 1
              ? true
              : isItemReadable
                  ? true
                  : logic!.callReadableLogic(itemFields, quesItem),
          isVisible: logic!.callDependingLogic(itemFields, quesItem),
          onChanged: (value) {
            // if (value > 0)
            print('yesNo $value');
            if (itemMap.containsKey(itemName.toString())) {
              itemMap[itemName.toString()]!['quantity_required'] =
                  value.toString();
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
          isRequred: logic!.dependeOnMendotory(itemFields, quesItem),
          initialvalue: itemFields[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: type == 1
              ? true
              : isItemReadable
                  ? true
                  : logic!.callReadableLogic(itemFields, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(itemFields, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!['quantity_required'] =
                    value.toString();
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
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          focusNode: _foocusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: logic!.dependeOnMendotory(itemFields, quesItem),
          maxlength: quesItem.length,
          readable: type == 1
              ? true
              : isItemReadable
                  ? true
                  : logic!.callReadableLogic(itemFields, quesItem),
          initialvalue: itemFields[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!['quantity_required'] =
                    value.toString();
              }
            } else {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!.remove(quesItem.fieldname);
              }
            }
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          focusNode: _foocusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: logic!.dependeOnMendotory(itemFields, quesItem),
          maxlength: quesItem.length,
          readable: type == 1
              ? true
              : isItemReadable
                  ? true
                  : logic!.callReadableLogic(itemFields, quesItem),
          initialvalue: itemFields[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value.isNotEmpty) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!['quantity_required'] =
                    value.toString();
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
          isRequred: logic!.dependeOnMendotory(itemFields, quesItem),
          initialvalue: itemFields[quesItem.fieldname!],
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          maxlength: quesItem.length,
          readable: type == 1
              ? true
              : isItemReadable
                  ? true
                  : logic!.callReadableLogic(itemFields, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(itemFields, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (itemMap.containsKey(itemName.toString())) {
                itemMap[itemName.toString()]!['quantity_required'] =
                    value.toString();
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
          readable: type == 1
              ? true
              : isItemReadable
                  ? true
                  : logic!.callReadableLogic(itemFields, quesItem),
          // isRequred: quesItem.reqd == 1
          //     ? quesItem.reqd
          //     : logic!
          //         .dependeOnMendotory( itemFields, quesItem),
          isRequred: (quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(itemFields, quesItem)),
          isVisible: logic!.callDependingLogic(itemFields, quesItem),
          calenderValidate: logic!.calenderValidation(itemFields, quesItem),
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
            if (itemMap.containsKey(itemName.toString())) {
              setState(() {
                itemMap[itemName.toString()]![quesItem.fieldname!] = value;
              });
            }
                    },
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
        );

      case 'Float':
        // if (quesItem.fieldname == "quantity_required") {
        //   itemMap['$itemName'] = {'${quesItem.fieldname}': quatRequired};
        // }
        return DynamicCustomTextFieldFloat(
          focusNode: _foocusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(itemFields, quesItem),
          // maxlength: quesItem.length,
          fieldName: quesItem.fieldname == 'quantity_received'
              ? 'weight'
              : quesItem.fieldname!,
          initialvalue: ((quesItem.fieldname == 'quantity_required')
              ? quatRequired
              : itemFields[quesItem.fieldname]),
          readable: type == 1
              ? true
              : isItemReadable
                  ? true
                  : logic!.callReadableLogic(itemFields, quesItem),
          isVisible: logic!.callDependingLogic(itemFields, quesItem),
          onChanged: (value) async {
            print('Entered text: $value');
            if (value != null) {
              // myMap[quesItem.fieldname!] = value;
              if (itemMap.containsKey(itemName.toString())) {
                // setState(() {
                itemMap[itemName.toString()]![quesItem.fieldname!] = value;
                // });
              }
              if (quesItem.fieldname == 'quantity_received') {
                itemFields[quesItem.fieldname!] = value;
                var validateMessage =
                    await logic!.validationMessge(itemFields, quesItem);
                if (Global.validString(validateMessage)) {
                  Validate().singleButtonPopup(
                      validateMessage!,
                      Global.returnTrLable(translats, CustomText.ok, lng),
                      false,
                      context);
                }
              }

              var logData = logic!.callAutoGeneratedValue(itemFields, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  // myMap.addEntries(
                  //     [MapEntry(logData.keys.first, logData.values.first)]);
                  itemMap.addEntries([
                    MapEntry('$itemName',
                        {'${logData.keys.first}': logData.values.first})
                  ]);

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
      default:
        return SizedBox();
    }
  }
}
