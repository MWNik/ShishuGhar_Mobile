import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
import 'package:shishughar/database/helper/stock/stock_response_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/month_and_year_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/model/dynamic_screen_model/requisition_response_model.dart';
import 'package:shishughar/model/dynamic_screen_model/stock_response_model.dart';

import 'package:shishughar/screens/tabed_screens/stock/stock/stock_expendable_detail_screen.dart';
// import 'package:shishughar/screens/tabed_screens/stock/stock/stock_listing_screen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

class StockCalenderListingScreen extends StatefulWidget {
  final String creche_id;
  StockCalenderListingScreen({super.key, required this.creche_id});

  @override
  State<StockCalenderListingScreen> createState() =>
      _StockCalenderListingScreenState();
}

class _StockCalenderListingScreenState
    extends State<StockCalenderListingScreen> {
  List<StockResponseModel> stockData = [];
  List<RequisitionResponseModel> requiData = [];
  List<Translation> translats = [];
  String lng = 'en';
  List<OptionsModel> yearList = [];
  List<OptionsModel> monthList = [];
  List<MonthYearModel> calenderList = [];

  @override
  void initState() {
    super.initState();
    intitializeData();
  }

  Future<void> intitializeData() async {
    translats.clear();
    lng = (await Validate().readString(Validate.sLanguage))!;
    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village
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
    stockData = await StockResponseHelper()
        .getStockByCreche(Global.stringToInt(widget.creche_id));
    requiData = await RequisitionResponseHelper()
        .getRequisitonsByMonth(Global.stringToInt(widget.creche_id));

    // DateTime now = DateTime.now();

    calenderList.clear();
    if (requiData.isNotEmpty) {
      for (var element in requiData) {
        calenderList.add(MonthYearModel(
          month: element.month,
          Year: element.year,
        ));
      }
    }

    if (stockData.isNotEmpty) {
      for (var element in stockData) {
        calenderList.add(MonthYearModel(
          month: element.month,
          Year: element.year,
        ));
      }
    }

    if (calenderList.length > 1) {
      calenderList = calenderList.toSet().toList();
      print(calenderList.length);
      calenderList.sort((a, b) {
        if (a.Year != b.Year) {
          return b.Year!.compareTo(a.Year!);
        } else {
          return b.month!.compareTo(a.month!);
        }
      });
    }
    print(calenderList.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(children: [
            (calenderList.length > 0)
                ? Expanded(
                    child: ListView.builder(
                        itemCount: calenderList.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              var record = await StockResponseHelper()
                                  .getStockByYearnMonth(
                                      Global.stringToInt(widget.creche_id),
                                      calenderList[index].month!,
                                      calenderList[index].Year!);
                              String? guid = record.isNotEmpty
                                  ? record.first.sguid
                                  : await Validate().randomGuid();

                              var refStatus = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          StockExpendableDetailScreen(
                                            sguid: guid!,
                                            month: calenderList[index].month!,
                                            year: calenderList[index].Year!,
                                            creche_id: widget.creche_id,
                                          )));

                              if (refStatus == 'itemRefresh') {
                                fetchStockData();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xff5A5A5A).withOpacity(0.2),
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xffE7F0FF)),
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 8.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${Global.returnTrLable(translats, 'Month', lng).trim()}',
                                            style: Styles.black104,
                                          ),
                                          Text(
                                            '${Global.returnTrLable(translats, 'Year', lng).trim()}',
                                            style: Styles.black104,
                                            strutStyle: StrutStyle(height: 1),
                                          ),
                                          // Text(
                                          //   '${Global.returnTrLable(translats, 'Status', lng!).trim()}',
                                          //   style: Styles.black104,
                                          //   strutStyle: StrutStyle(height: 1),
                                          // ),
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
                                                  calenderList[index].month!,
                                                  'Months'),
                                              style: Styles.blue125,
                                              strutStyle: StrutStyle(height: .5),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              getOptionsFromName(
                                                  calenderList[index].Year!,
                                                  'Year'),
                                              style: Styles.blue125,
                                              strutStyle: StrutStyle(height: .5),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            // Text(
                                            //   getStatusValue(Global.getItemValues(
                                            //       requisitionData[index].responces!,
                                            //       'status')),
                                            //   style: Styles.blue125,
                                            //   strutStyle: StrutStyle(height: .5),
                                            //   overflow: TextOverflow.ellipsis,
                                            // ),
                                          ],
                                        ),
                                      ),
                                      // Column(children: [
                                      //   SizedBox(height: 5),
                                      //   (stockData[index].is_edited == 0 &&
                                      //           stockData[index].is_uploaded == 1)
                                      //       ? Image.asset(
                                      //           "assets/sync.png",
                                      //           scale: 1.5,
                                      //         )
                                      //       : Image.asset(
                                      //           "assets/sync_gray.png",
                                      //           scale: 1.5,
                                      //         )
                                      // ])
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : Expanded(
                    child: Center(
                      child: Text(Global.returnTrLable(
                          translats, CustomText.NorecordAvailable, lng)),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }

  String getOptionsFromName(int name, String flag) {
    String option = '';
    if (flag == "Year") {
      var list = yearList.where((element) {
        return Global.stringToInt(element.name) == name;
      });
      option = list.first.values!;
    } else if (flag == 'Months') {
      var list = monthList.where((element) {
        return Global.stringToInt(element.name) == name;
      });
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
}
