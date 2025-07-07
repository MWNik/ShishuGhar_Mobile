import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/stock/stock_response_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/screens/tabed_screens/stock/stock/stock_details_screen.dart';
import 'package:shishughar/screens/tabed_screens/stock/stock/stock_details_screen_replica.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../../database/helper/translation_language_helper.dart';

class StockListingScreen extends StatefulWidget {
  final String creche_id;

  const StockListingScreen({super.key, required this.creche_id});

  @override
  State<StockListingScreen> createState() => _StockListingScreenState();
}

class _StockListingScreenState extends State<StockListingScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> stockList = [];
  List<Translation> translats = [];
  String lng = 'en';
  List<OptionsModel> yearList = [];
  List<OptionsModel> monthList = [];
  List<Map<String, dynamic>> unsynchedList = [];
  List<Map<String, dynamic>> allList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool isOnlyUnsynched = false;
  String? role;
  @override
  void initState() {
    super.initState();
    intitializeData();
  }

  Future<void> intitializeData() async {
    translats.clear();
    role = (await Validate().readString(Validate.role))!;
    lng = (await Validate().readString(Validate.sLanguage))!;
    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.all,
      CustomText.usynchedAndDraft,
      'Month',
      'Year'
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    await OptionsModelHelper()
        .getMstCommonOptions('Year', lng)
        .then((value) => yearList.addAll(value));
    await OptionsModelHelper()
        .getMstCommonOptions('Months', lng)
        .then((value) => monthList.addAll(value));

    await fetchStockData();
  }

  Future<void> fetchStockData() async {
    stockList = await StockResponseHelper()
        .getStockresponseByYearMonth(Global.stringToInt(widget.creche_id));
    allList = stockList;

    unsynchedList = stockList
        .where((element) =>
            element['is_edited'] == 1 ||
            (element['is_edited'] == null && element['is_uploaded'] == null))
        .toList();
    filteredList = isOnlyUnsynched ? unsynchedList : allList;
    print(stockList.length);
    setState(() {
      isLoading = false;
    });
  }

  List<dynamic> _returnNewItems(
      List<dynamic> currentMonth, List<dynamic> requiList) {
    List<int> stockItems = [];
    List<int> requisitionsItems = [];
    currentMonth.forEach(
        (item) => stockItems.add(Global.stringToInt(item['stock_item'])));
    requiList.forEach((item) =>
        requisitionsItems.add(Global.stringToInt(item['requistion_item'])));
    Set<int> stockSet = Set.from(stockItems);
    Set<int> requiSet = Set.from(requisitionsItems);

    List<int> newItemsList = requiSet.difference(stockSet).toList();
    List<dynamic> resultList = requiList
        .where((requi) =>
            newItemsList
                .contains(Global.stringToInt(requi['requistion_item'])) &&
            Global.validString(requi['supply_date']))
        .toList();
    return resultList;
  }

  List<Map<String, dynamic>> generateStockItemList(
      List<dynamic> currentMonth, List<dynamic> requiList) {
    List<Map<String, dynamic>> resultList = [];
    List<dynamic> newItem = _returnNewItems(currentMonth, requiList);
    if (currentMonth.isNotEmpty) {
      for (var element in currentMonth) {
        var stockItemId = Global.stringToInt(element['stock_item']);
        var requiItem = requiList
            .where((requi) =>
                Global.stringToInt(requi['requistion_item']) == stockItemId)
            .toList()
            .firstOrNull;

        if (requiItem != null) {
          Map<String, dynamic> item = Map<String, dynamic>.from(element);
          item['quantity_received'] = requiItem['quantity_received'];
          resultList.add(item);
        }
        print(resultList.length);
      }
      if (newItem != null) {
        for (var elem in newItem) {
          if (Global.stringToDouble(elem['quantity_received'].toString()) >
              0.0) {
            Map<String, dynamic> item = {
              "month": elem['month'],
              "year": elem['year'],
              "stock_item": elem['requistion_item'],
              "quantity_received": elem['quantity_received']
            };
            resultList.add(item);
          }
        }
      }
    } else {
      for (var element in requiList) {
        if (Global.stringToDouble(element['quantity_received'].toString()) >
            0.0) {
          Map<String, dynamic> item = {
            "month": element['month'],
            "year": element['year'],
            "stock_item": element['requistion_item'],
            "quantity_received": element['quantity_received'],
          };
          resultList.add(item);
        }
      }
    }

    return resultList;
  }

  String getOptionsFromName(int name, String flag) {
    String option = '';
    if (flag == "Year") {
      var list = yearList.where((element) {
        return Global.stringToInt(element.name) == name;
      });
      if(list.length>0)
      option = list.first.values!;

    } else if (flag == 'Months') {
      var list = monthList.where((element) {
        return Global.stringToInt(element.name) == name;
      });
      if(list.length>0)
      option = list.first.values!;

    }
    return option;
  }

  int getNameFromOptionValue(int value) {
    int name = 0;
    var list = yearList.where((element) {
      return Global.stringToInt(element.values) == value;
    });
    name = Global.stringToInt(list.first.name);
    return name;
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
          child: Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: AnimatedRollingSwitch(
                        isOnlyUnsynched: isOnlyUnsynched,
                        title1:
                            Global.returnTrLable(translats, CustomText.all, lng),
                        title2: Global.returnTrLable(
                            translats, CustomText.usynchedAndDraft, lng),
                        onChange: (value) async {
                          setState(() {
                            isOnlyUnsynched = value;
                          });
                          await fetchStockData();
                        },
                      ),
                    ),
                    (filteredList.isNotEmpty)
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: filteredList.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  var selectedItem = filteredList[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      String guid = Global.getItemValues(
                                          selectedItem['responces'], 'sguid');
                                      if (!Global.validString(guid)) {
                                        guid = await Validate().randomGuid();
                                      }

                                      dynamic currentMonthList = Iterable.empty();
                                      if (Global.validString(
                                          selectedItem['responces'])) {
                                        currentMonthList =
                                            jsonDecode(selectedItem['responces'])[
                                                'stock_list'];
                                      }

                                      dynamic requisitionList =
                                          jsonDecode(selectedItem['RResponce'])[
                                              'requisition_list'];
                                      var itemList = generateStockItemList(
                                          List<Map<String, dynamic>>.from(
                                              currentMonthList),
                                          List<Map<String, dynamic>>.from(
                                              requisitionList));
                                      var refStatus = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  StockDetails(
                                                    sguid: guid,
                                                    month: Global.stringToInt(
                                                        Global.getItemValues(
                                                            selectedItem[
                                                                'RResponce'],
                                                            'month')),
                                                    year: Global.stringToInt(
                                                        Global.getItemValues(
                                                            selectedItem[
                                                                'RResponce'],
                                                            'year')),
                                                    creche_id: widget.creche_id,
                                                    itemList: itemList,
                                                      isEdit:role==CustomText.crecheSupervisor
                                                  )));
                                      if (refStatus == CustomText.itemRefresh) {
                                        fetchStockData();
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.h),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xff5A5A5A)
                                                    .withOpacity(0.2),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Color(0xffE7F0FF)),
                                            borderRadius:
                                                BorderRadius.circular(10.r)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 8.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${Global.returnTrLable(translats, 'Month', lng!).trim()} :',
                                                    style: Styles.black104,
                                                  ),
                                                  Text(
                                                    '${Global.returnTrLable(translats, 'Year', lng!).trim()} :',
                                                    style: Styles.black104,
                                                    strutStyle:
                                                        StrutStyle(height: 1.2),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 10),
                                              SizedBox(
                                                height: 10.h,
                                                width: 2,
                                                child: VerticalDivider(
                                                  color: Color(0xffE6E6E6),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getOptionsFromName(
                                                        Global.stringToInt(
                                                            Global.getItemValues(
                                                                selectedItem[
                                                                    'RResponce'],
                                                                'month')),
                                                        'Months'),
                                                    style: Styles.cardBlue10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    getOptionsFromName(
                                                        Global.stringToInt(
                                                            Global.getItemValues(
                                                                selectedItem[
                                                                    'RResponce'],
                                                                'year')),
                                                        'Year'),
                                                    style: Styles.cardBlue10,
                                                    strutStyle:
                                                        StrutStyle(height: 1.2),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              )),
                                              SizedBox(width: 5),
                                              selectedItem['is_edited'] == 0 &&
                                                      selectedItem[
                                                              'is_uploaded'] ==
                                                          1
                                                  ? Image.asset(
                                                      "assets/sync.png",
                                                      scale: 1.5,
                                                    )
                                                  : selectedItem['is_edited'] ==
                                                              1 &&
                                                          selectedItem[
                                                                  'is_uploaded'] ==
                                                              0
                                                      ? Image.asset(
                                                          "assets/sync_gray.png",
                                                          scale: 1.5,
                                                        )
                                                      : Icon(
                                                          Icons.error_outline,
                                                          color:
                                                              Colors.red,
                                                          shadows: [
                                                            BoxShadow(
                                                                spreadRadius: 2,
                                                                blurRadius: 4,
                                                                color: Colors
                                                                    .red.shade200)
                                                          ],
                                                        )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }))
                        : Expanded(
                            child: Center(
                              child: Text(Global.returnTrLable(
                                  translats, CustomText.NorecordAvailable, lng)),
                            ),
                          )
                  ],
                ),
              ),
            ),
        );
  }
}
