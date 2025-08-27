import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import 'package:shishughar/custom_widget/single_poup_dailog.dart';
import 'package:shishughar/database/helper/creche_helper/creche_data_helper.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/form_logic_helper.dart';
import 'package:shishughar/database/helper/partner_stock_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/creche_database_responce_model.dart';
import 'package:shishughar/model/apimodel/partner_stock_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/model/dynamic_screen_model/requisition_response_model.dart';
import 'package:shishughar/model/dynamic_screen_model/stock_response_model.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/depending_logic.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../../database/helper/backdated_configiration_helper.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../../model/databasemodel/backdated_configiration_model.dart';



class RequisitionDetailsNew extends StatefulWidget {
  final String rguid;
  final int month;
  final int year;
  final String creche_id;
  final String child_count;
  int? name;
  final bool isEdit;
  StockResponseModel? stockData;

  RequisitionDetailsNew(
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
  State<RequisitionDetailsNew> createState() => _RequisitionDetailsState();
}

class _RequisitionDetailsState extends State<RequisitionDetailsNew> {
  TextEditingController textController = TextEditingController();
  DependingLogic? logic;
  List<PartnerStockModel> partnerStockItemList = [];
  List<PartnerStockModel> filteredPartnerStock = [];
  List<PartnerStockModel> removedItemList = [];
  List<PartnerStockModel> addbackList = [];
  List<OptionsModel> monthsList = [];
  List<OptionsModel> yearList = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<int, dynamic> selectedItem = {};
  int? expended;
  String lng = 'en';
  String userName = '';
  bool _isLoading = true;
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
  List<CresheDatabaseResponceModel> creche_rec = [];
  String? creche_name;
  Map<String, FocusNode> _foocusNode = {};
  ScrollController _scrollController = ScrollController();
  Map<String, Map<String, dynamic>> stockItemsList = {};
  String? role;
  BackdatedConfigirationModel? backdatedConfigirationModel;
  DateTime? applicableDate;
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    role = (await Validate().readString(Validate.role))!;
    var lngtr = (await Validate().readString(Validate.sLanguage))!;
    backdatedConfigirationModel = await BackdatedConfigirationHelper().excuteBackdatedConfigirationModel(CustomText.crecheStock);
  var date = await Validate().readString(Validate.date);
   applicableDate = Validate().stringToDate(date ?? "2025-03-31");

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
      CustomText.leavingLesThanjoining,
      CustomText.requiredQuantity
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



    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logic = DependingLogic(translats, data, lng);
    });


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
                SizedBox(height: 20),
                Flexible(
                    fit: FlexFit.loose,
                    child: removedItemList.isNotEmpty
                        ? itemCard(removedItemList)
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
                                var stockId=element.name;
                                double itemReqPerChild = Global.stringToDouble(
                                    element.item_required_per_child_per_months);
                                double child_count = Global.stringToDouble(widget.child_count);
                                double quantity_required = generateQuatityRequired(child_count, itemReqPerChild);
                                updateQuatRequired(stockId,quantity_required);
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: (filteredPartnerStock.isNotEmpty)
                          ? addedItemCard(filteredPartnerStock)
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

    for (var element in filteredPartnerStock) {
      var requreQuentity=getQuatRequired(element.name,'quantity_required');
      if (!Global.validString(requreQuentity.toString())) {
        Validate().singleButtonPopup(
            Global.returnTrLable(translats, CustomText.plsFilManForm, lng),
            Global.returnTrLable(translats, CustomText.ok, lng),
            false,
            context);
        validStatus = false;
        break;
      }
      if(check_supplied(element)){
        var valItem=fetchFielddata(element);
        var received_date=valItem['received_date'];
        String? validateMessage =  logic!
            .validationMessge(
            valItem, HouseHoldFielItemdModel(fieldname:'quantity_received'));
        if(Global.validString(validateMessage)){
          Validate().singleButtonPopup(
              Global.returnTrLable(translats, validateMessage, lng),
              Global.returnTrLable(translats, CustomText.ok, lng),
              false,
              context);
          validStatus = false;
        }
        if(!Global.validString(received_date)){
          Validate().singleButtonPopup(
              Global.returnTrLable(translats, CustomText.plsFilManForm, lng),
              Global.returnTrLable(translats, CustomText.ok, lng),
              false,
              context);
          validStatus = false;
        }
      }

    }

    return validStatus;
  }

  Future<void> saveDataInData() async {
    List<Map<String, dynamic>> requistion_item=[];
    if (selectedItem.isNotEmpty) {
      for (var item in selectedItem.keys) {
        requistion_item.add(selectedItem[item]);
      }
      myMap['requisition_list'] = requistion_item;
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
        var itemId=Global.stringToInt(element['requistion_item']);
        itemListName.add(itemId);
        selectedItem[itemId]=element;
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
      filteredPartnerStock.forEach((item) {
        var stockId=item.name;
        double itemReqPerChild = Global.stringToDouble(
            item.item_required_per_child_per_months);
        double child_count = Global.stringToDouble(widget.child_count);
        double quantity_required = generateQuatityRequired(child_count, itemReqPerChild);
        updateQuatRequired(stockId,quantity_required);
      });
    }
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
    if (itemData!=null) {
      if(itemData.isNotEmpty){
      if (Global.validString(itemData['usage'].toString()) &&
          Global.validString(itemData['wastage'].toString())) {
        status = true;
      }
    }}
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

  Widget itemCard(List<PartnerStockModel> parentStockList) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: parentStockList.length,
        physics: BouncingScrollPhysics(),
        shrinkWrap: false,
        itemBuilder: (BuildContext context, int index) {
          String itemvalue = ((lng == 'en')
              ? parentStockList[index].items
              : ((lng == 'hi')
                  ? parentStockList[index].hindi
                  : parentStockList[index].odia))!;
          var ItemName = parentStockList[index].name;
          if (stockItemsList.isNotEmpty &&
              stockItemsList.containsKey('$ItemName')) {
          }

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                  horizontal:3,
                  vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      itemvalue,
                      style: Styles.blue125,
                      strutStyle: StrutStyle(height: 1.3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 4),
                    child: Checkbox(
                        value: addbackList
                            .contains(parentStockList[index])
                            ? true
                            : false,
                        onChanged: (value) {
                          if (value == true) {
                            addbackList.add(parentStockList[index]);
                          } else if (value == false &&
                              addbackList.contains(
                                  parentStockList[index])) {
                            addbackList
                                .remove(parentStockList[index]);
                          }
                          setState(() {});
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget addedItemCard(List<PartnerStockModel> parentStockList,
    ) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: parentStockList.length,
        physics: BouncingScrollPhysics(),
        shrinkWrap: false,
        itemBuilder: (BuildContext context, int index) {
          String itemvalue = ((lng == 'en')
              ? parentStockList[index].items
              : ((lng == 'hi')
              ? parentStockList[index].hindi
              : parentStockList[index].odia))!;
          var ItemName = parentStockList[index].name;
          var fieldItem=fetchFielddata(parentStockList[index]);
          if (stockItemsList.isNotEmpty &&
              stockItemsList.containsKey('$ItemName')) {
          }

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
                      color: Colors.grey[300]!,
                      blurStyle: BlurStyle.outer)
                ]),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10 ,
                  vertical: 10),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child:Text(
                        ' ${index + 1}:   $itemvalue',
                        style: Styles.blue125,
                        strutStyle: StrutStyle(height: 1.3),
                      )),
                      DynamicCustomTextFieldFloat(
                        width: 100,
                        height: 35,
                        titleText:
                        Global.returnTrLable(translats, CustomText.required, lng),
                        keyboardtype: TextInputType.number,
                        readable: check_uploaded(parentStockList[index].name),
                        isRequred: 1,
                        fieldName: 'weight',
                        initialvalue: Global.stringToDoubleNullable(getQuatRequired(parentStockList[index].name,'quantity_required')),
                        onChanged: (value) async {
                          updateQuatRequired(parentStockList[index].name, value);
                        },
                      ),
                      check_uploaded(parentStockList[index].name)? InkWell(
                        onTap: () {
                          setState(() {
                            if (expended == index) {
                              expended = -1;
                            } else
                              expended = index;

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
                      ):
                      InkWell(
                        onTap: () {
                          updateQuatRequired(parentStockList[index].name,null);
                          removedItemList
                              .add(parentStockList[index]);
                          filteredPartnerStock
                              .remove(parentStockList[index]);
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.delete_outline_sharp,
                              color: Colors.red,size: 20,
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  Visibility(
                    visible: expended==index,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        check_supplied(parentStockList[index])?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DynamicCustomTextFieldFloat(
                              width: 100,
                              height: 35,
                              titleText:
                              Global.returnTrLable(translats, CustomText.supplied, lng),
                              keyboardtype: TextInputType.number,
                              readable: true,
                              isRequred: 1,
                              fieldName: 'weight',
                              initialvalue: Global.stringToDoubleNullable(getQuatRequired(parentStockList[index].name,'quantity_supplied')),
                              onChanged: (value) async {
                              },
                            ),
                            CustomDatepickerDynamic(
                              width: 150,
                              height: 35,
                                titleText:"",
                              initialvalue: getQuatRequired(parentStockList[index].name,'supply_date'),
                              fieldName: 'supply_date',
                              readable:true,
                              isRequred: 0,
                              calenderValidate: [],
                              onChanged: (value) {
                              },
                            )
                          ],
                        )
                        :SizedBox(),
                        check_supplied(parentStockList[index])?Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DynamicCustomTextFieldFloat(
                              width: 100,
                              height: 35,
                              titleText:
                              Global.returnTrLable(translats, CustomText.received, lng),
                              keyboardtype: TextInputType.number,
                              readable: callReceviedReadable(getQuatRequired(parentStockList[index].name,'received_date'),parentStockList[index].name!),
                              isRequred: 1,
                              fieldName: 'weight',
                              initialvalue: Global.stringToDoubleNullable(getQuatRequired(parentStockList[index].name,'quantity_received')),
                              onChanged: (value) async {
                                var item=fetchFielddata(parentStockList[index]);
                                item['quantity_received']=value;
                                String? validateMessage = await logic!
                                    .validationMessge(
                                    item, HouseHoldFielItemdModel(fieldname:'quantity_received'));
                                if (Global.validString(validateMessage)) {
                                  Validate().singleButtonPopup(
                                      validateMessage!,
                                      Global.returnTrLable(
                                          translats, CustomText.ok, lng),
                                      false,
                                      context);
                                }else{
                                  selectedItem[parentStockList[index].name!]=item;
                                }

                              },
                            ),
                            CustomDatepickerDynamic(
                              width: 150,
                              height: 35,
                              titleText:"",
                              initialvalue: getQuatRequired(parentStockList[index].name,'received_date'),
                              fieldName: 'received_date',
                              readable: callReceviedReadable(getQuatRequired(parentStockList[index].name,'received_date'),parentStockList[index].name!),
                              isRequred: 0,
                              calenderValidate:  logic!.calenderValidation(
                                  fetchFielddata(parentStockList[index]), HouseHoldFielItemdModel(fieldname:'received_date')),
                              onChanged: (value) {
                                var item=fetchFielddata(parentStockList[index]);
                                item['received_date']=value;
                                selectedItem[parentStockList[index].name!]=item;
                              },
                            )
                          ],
                        ):SizedBox()
                      ],
                    )

                  ),
                ],
              )
            ),
          );
        });
  }



  updateQuatRequired(
      int? iteName, double? quatityRequired) {
    if(quatityRequired!=null){
      selectedItem[iteName!]={
        'quantity_required':'$quatityRequired',
        'requistion_item':'$iteName',
        'year':'${widget.year}',
        'month':'${widget.month}',
      };
    }else if(selectedItem.containsKey(iteName)){
      selectedItem.remove(iteName);
    }

  }

  String? getQuatRequired(
      int? iteName,String key) {
    if(selectedItem.containsKey(iteName)){
      var item=selectedItem[iteName];

      return Global.validToStringNullable(item[key].toString());
    }

  }

  bool check_uploaded(
      int? iteName) {
    bool isRead=false;
    if(selectedItem.containsKey(iteName)){
      var item=selectedItem[iteName] as Map;
      if(item.containsKey('name')){
        isRead=true;
      }
    }
return isRead;
  }

  bool check_supplied(
      PartnerStockModel requi_iem) {
    bool isRead=false;
    var uploadItem=fetchFielddata(requi_iem);
    if(uploadItem.isNotEmpty){
      if(Global.stringToDouble(uploadItem['quantity_supplied'].toString())>0
      &&Global.validString(uploadItem['supply_date'])){
        isRead=true;
      }
    }
    return isRead;
  }

  bool check_received(
      PartnerStockModel requi_iem) {
    bool isRead=false;
    var uploadItem=fetchFielddata(requi_iem);
    if(uploadItem.isNotEmpty){
        isRead=(Global.validString(uploadItem['received_date']));
    }
    return isRead;
  }


  bool callReceviedReadable(String?  receviedData,int ItemName)  {
    bool isReadable=false;
    isReadable =checkisReadable(stockItemsList['${ItemName}']);
   if(!isReadable){
     if(Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0) {
       if (backdatedConfigirationModel?.back_dated_data_entry_allowed != null&& Global.validString(receviedData)) {
         if (Global.validString(receviedData)) {
           var creation = DateTime.parse(receviedData.toString());
           var datePart = DateTime(creation.year, creation.month, creation.day);
           var now = DateTime.now();
           var nowDatePart = DateTime(now.year, now.month, now.day);
           isReadable =
               datePart.add(Duration(days: backdatedConfigirationModel?.back_dated_data_entry_allowed??0)).isBefore(nowDatePart);
         }
       }

     }
   }

    return isReadable;
  }


}
