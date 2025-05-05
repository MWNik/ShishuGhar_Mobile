import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../api/dashboard_report_api.dart';
import '../custom_widget/custom_appbar.dart';
import 'login_screen.dart';

class DashboardReportByApiScreen extends StatefulWidget {
  final int crecheId;

  const DashboardReportByApiScreen({
    super.key,
    required this.crecheId,
  });

  @override
  _DashboardReportByApiState createState() => _DashboardReportByApiState();
}

class _DashboardReportByApiState extends State<DashboardReportByApiScreen> {
  List items = [];
  List<OptionsModel> years = [];
  List<OptionsModel> months = [];
  List<Translation> translats = [];
  String lng = 'en';
  String? selectedMonth;
  String selectedYear = '${DateTime.now().year}';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? role;

  // bool apiIsCall=false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    role = (await Validate().readString(Validate.role))!;
    years = getYearList(2000);
    months = getMonthList(Global.stringToInt(years.first.name));
    var crrentMonth = DateTime.now().month;
    selectedMonth = months[crrentMonth - 1].name;

    translats.clear();
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }

    List<String> valueItems = [
      CustomText.DashBoardReport,
      CustomText.NorecordAvailable,
      CustomText.pleaseSelectMonth,
      CustomText.pleaseWait,
      CustomText.clear,
      CustomText.Cancel,
      CustomText.Month,
      CustomText.Year,
      CustomText.January,
      CustomText.February,
      CustomText.March,
      CustomText.April,
      CustomText.May,
      CustomText.June,
      CustomText.July,
      CustomText.August,
      CustomText.September,
      CustomText.October,
      CustomText.November,
      CustomText.December,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    await callApiForDashboardApi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppbar(
        text: Global.returnTrLable(translats, CustomText.DashBoardReport, lng),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      // endDrawer: SafeArea(
      //   child: Drawer(
      //       backgroundColor: Colors.white,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(),
      //       ),
      //       child: Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 15),
      //         child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.symmetric(
      //                     horizontal: 15, vertical: 30),
      //                 child: Row(
      //                   children: [
      //                     Image.asset(
      //                       "assets/filter_icon.png",
      //                       scale: 2.4,
      //                     ),
      //                     SizedBox(
      //                       width: 10.w,
      //                     ),
      //                     Text(
      //                       Global.returnTrLable(
      //                           translats, CustomText.Filter, lng),
      //                       style: Styles.labelcontrollerfont,
      //                     ),
      //                     Spacer(),
      //                     InkWell(
      //                         onTap: () async {
      //                           _scaffoldKey.currentState!.closeEndDrawer();
      //                           // cleaAllFilter();
      //                         },
      //                         child: Image.asset(
      //                           'assets/cross.png',
      //                           color: Colors.grey,
      //                           scale: 4,
      //                         )),
      //                   ],
      //                 ),
      //               ),
      //               // SizedBox(),
      //
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Expanded(
      //                     child: DynamicCustomDropdownField(
      //                       hintText: Global.returnTrLable(
      //                           translats, CustomText.Year, lng),
      //                       items: getYearList(2020),
      //                       titleText:Global.returnTrLable(
      //                           translats, CustomText.Year, lng),
      //                       selectedItem: selectedYear,
      //                       onChanged: (value) {
      //                         setState(() {
      //                           selectedYear = value!.name!;
      //                           months=getMonthList(Global.stringToInt(selectedYear));
      //                           selectedMonth=null;
      //                         });
      //
      //                       },
      //                     ),
      //                   ),
      //                   Expanded(
      //                     child: DynamicCustomDropdownField(
      //                       hintText: Global.returnTrLable(
      //                           translats, CustomText.Month, lng),
      //                       items: months,
      //                       titleText:Global.returnTrLable(
      //                           translats, CustomText.Month, lng),
      //                       selectedItem: selectedMonth,
      //                       onChanged: (value) {
      //                         selectedMonth = value?.name;
      //                       },
      //                     ),
      //                   )
      //                 ],
      //               ),
      //
      //               SizedBox(
      //                 height: 10.h,
      //               ),
      //               Padding(
      //                 padding: EdgeInsets.all(3.0),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                   children: [
      //                     Expanded(
      //                       child: CElevatedButton(
      //                         text: Global.returnTrLable(
      //                             translats, CustomText.Cancel, lng),
      //                         color: Color(0xffF26BA3),
      //                         onPressed: () {
      //                           Navigator.of(context).pop();
      //                         },
      //                       ),
      //                     ),
      //                     // Spacer(),
      //                     SizedBox(width: 4.w),
      //                     Expanded(
      //                       child: CElevatedButton(
      //                         text: Global.returnTrLable(
      //                             translats, CustomText.Search, lng),
      //                         onPressed: () {
      //                           if(selectedMonth!=null){
      //                             Navigator.of(context).pop();
      //                             callApiForDashboardApi();
      //                           }else{
      //                             Validate().singleButtonPopup(
      //                                 Global.returnTrLable(
      //                                     translats, CustomText.pleaseSelectMonth, lng),
      //                                 Global.returnTrLable(translats, CustomText.ok, lng),
      //                                 false,
      //                                 context);
      //                           }
      //
      //                         },
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ]),
      //       )),
      // ),
      body: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
          child:
              // apiIsCall?
              Column(children: [
            // Row(
            //   children: [
            //     Expanded(
            //         child: SizedBox())
            //     ,
            //     GestureDetector(
            //       onTap: () {
            //         _scaffoldKey.currentState!.openEndDrawer();
            //       },
            //       child: Image.asset(
            //         "assets/filter_icon.png",
            //         scale: 2.4,
            //       ),
            //     )
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DynamicCustomDropdownField(
                    hintText:
                        Global.returnTrLable(translats, CustomText.Year, lng),
                    items: getYearList(2020),
                    // titleText:
                    //     Global.returnTrLable(translats, CustomText.Year, lng),
                    selectedItem: selectedYear,
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value!.name!;
                        months = getMonthList(Global.stringToInt(selectedYear));
                        selectedMonth = null;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: DynamicCustomDropdownField(
                    hintText:
                        Global.returnTrLable(translats, CustomText.Month, lng),
                    items: months,
                    // titleText:
                    //     Global.returnTrLable(translats, CustomText.Month, lng),
                    selectedItem: selectedMonth,
                    onChanged: (value) {
                      selectedMonth = value?.name;
                      callApiForDashboardApi();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: (items.length > 0)
                  ? GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: items.length,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15, // Vertical spacing (Add this line)
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var selectedItem = items[index];
                        return InkWell(
                          onTap: () async {},
                          child: Container(
                            width: double
                                .infinity, // Takes full width of grid cell
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff5A5A5A).withOpacity(0.2),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                ),
                              ],
                              color: Color(0xffF2F7FF),
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(color: Color(0xffE7F0FF)),
                            ),
                            child: AspectRatio(
                              aspectRatio:
                                  1, // Keeps it square, change as needed
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    items[index]['value'].toString(),
                                    style: Styles.blue148,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(items[index]['title'],
                                          textAlign: TextAlign.center,
                                          style: Styles.black124))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(Global.returnTrLable(
                          translats, CustomText.NorecordAvailable, lng)),
                    ),
            ),
          ])
          //   :Center(
          // child: Text(Global.returnTrLable(translats,
          //     CustomText.NorecordAvailable, lng)))
          ),
    );
  }

  Future callApiForDashboardApi() async {
    var token = await Validate().readString(Validate.appToken);
    print('perameter=> $selectedYear, $selectedMonth,${widget.crecheId}');
    var network = await Validate().checkNetworkConnection();
    if (network) {
      showLoaderDialog(context);
      var response = await DashboardReportApi().callDashboardReportApi(
          selectedYear, selectedMonth!, "${widget.crecheId}", token!);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['data'] != null) {
          Navigator.pop(context);
          items = data['data'] as List;
          setState(() {
            // apiIsCall = true;
          });
        }
      } else if (response.statusCode == 401) {
        Navigator.pop(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  translats, CustomText.token_expired, lng))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
        return false;
      } else {
        Navigator.pop(context);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(translats, CustomText.ok, lng),
            false,
            context);
        return false;
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              translats, CustomText.nointernetconnectionavailable, lng),
          Global.returnTrLable(translats, CustomText.ok, lng),
          false,
          context);
    }
  }

  List<OptionsModel> getMonthList(int year) {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int monthLimit = (year == currentYear) ? currentMonth : 12;
    List<String> months = [
      CustomText.January,
      CustomText.February,
      CustomText.March,
      CustomText.April,
      CustomText.May,
      CustomText.June,
      CustomText.July,
      CustomText.August,
      CustomText.September,
      CustomText.October,
      CustomText.November,
      CustomText.December,
    ];
    return List.generate(
      monthLimit,
      (index) => OptionsModel(
        name: (index + 1).toString(), // Month name
        values: months[index], // Month number (1-12)
        flag: null, // Set flag to null
      ),
    );
    // If the input year is the current year, return only past & current months
    // return (year == currentYear) ? months.sublist(0, currentMonth) : months;
  }

  List<OptionsModel> getYearList(int startYear) {
    int currentYear = DateTime.now().year;
    // return List.generate((currentYear - startYear) + 1, (index) => startYear + index);
    var years = List.generate(
      (currentYear - startYear) + 1,
      (index) => OptionsModel(
        name: (startYear + index).toString(), // Convert index to string
        values: (startYear + index).toString(), // Year value
        flag: null, // Set flag to null
      ),
    ).reversed.toList();

    return years;
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
                SizedBox(height: 10.h),
                Text(Global.returnTrLable(
                    translats, CustomText.pleaseWait, lng)),
              ],
            ),
          ),
        );
      },
    );
  }
}
