import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/database/helper/cashbook/expences/cashbook_response_expences_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/cashbook_receipt_response_model.dart';
import 'package:shishughar/model/dynamic_screen_model/cashbook_response_expences_model.dart';
import 'package:shishughar/screens/tabed_screens/cashbook/expences/cashbook_expenses_details_view_screen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../../custom_widget/custom_text.dart';
import '../../../../custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import '../../../../database/helper/cashbook/receipt/cashbook_receipt_response_helper.dart';
import '../../../../database/helper/translation_language_helper.dart';
import '../../../../utils/globle_method.dart';
import 'cashbook_expenses_details_screen.dart';

class CashBookExpensesListingScreen extends StatefulWidget {
  final String creche_id;
  CashBookExpensesListingScreen({super.key, required this.creche_id});

  @override
  State<CashBookExpensesListingScreen> createState() =>
      _CashBookExpensesListingSCreenState();
}

class _CashBookExpensesListingSCreenState
    extends State<CashBookExpensesListingScreen> {
  List<CashbookExpencesResponseModel> expensesData = [];
  List<CashbookReceiptResponseModel> receiptRecords = [];
  List<CashbookExpencesResponseModel> unsynchedList = [];
  List<CashbookExpencesResponseModel> allList = [];
  bool isOnlyUnsynched = false;
  DateTime? minDate;
  List<Translation> translats = [];
  String lng = 'en';
  double walletToal = 0.0;
  String? role;
  DateTime applicableDate = Validate().stringToDate("2024-12-31");
  DateTime now = DateTime.parse(Validate().currentDate());

  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    role = (await Validate().readString(Validate.role))!;
    translats.clear();
    lng = (await Validate().readString(Validate.sLanguage))!;
    var date = await Validate().readString(Validate.date);
    applicableDate = Validate().stringToDate(date ?? "2024-12-31");
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
      CustomText.unsynched,
      CustomText.BalanceAmount,
      CustomText.DateS,
      CustomText.amount
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    await fetchCashbookData();

    setState(() {});
  }

  Future<void> fetchCashbookData() async {
    expensesData = await CashBookResponseExpencesHelper()
        .cashbookExpencesByCreche(widget.creche_id);

    walletToal = await getRecieptTootal();
    unsynchedList =
        expensesData.where((element) => element.is_edited == 1).toList();
    allList = expensesData;
    expensesData = isOnlyUnsynched ? unsynchedList : allList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: role == CustomText.crecheSupervisor.trim()
          ? ((walletToal > 0)
              ? InkWell(
                  onTap: () async {
                    String cashbookGuid = '';
                    if (!Global.validString(cashbookGuid)) {
                      cashbookGuid = Validate().randomGuid();
                      var backDate = now.isBefore(applicableDate)
                          ? DateTime(1992)
                          : DateTime.parse(Validate().currentDate())
                              .subtract(Duration(days: 7));
                      if (minDate != null) {
                        if (minDate!.isBefore(backDate)) {
                          minDate = backDate;
                        }
                      } else if (minDate == null) {
                        minDate = backDate;
                      }

                      var refStatus = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CashbookExpensesDetailsScreen(
                                      creche_id: widget.creche_id,
                                      cashbook_guid: cashbookGuid,
                                      minDate: minDate,
                                      reqAmount: walletToal)));

                      if (refStatus == 'itemRefresh') {
                        fetchCashbookData();
                      }
                    }
                  },
                  child: Image.asset(
                    "assets/add_btn.png",
                    scale: 2.7,
                    color: Color(0xff5979AA),
                  ),
                )
              : null)
          : SizedBox(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Global.validString(role)
            ? Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: role ==
                              CustomText.crecheSupervisor.trim()
                          ? MainAxisAlignment
                              .spaceBetween // Space between left and right widgets
                          : MainAxisAlignment.start,
                      children: [
                        // Left Widget
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff5A5A5A).withOpacity(0.2),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade700),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text:
                                  '${Global.returnTrLable(translats, CustomText.BalanceAmount, lng).trim()}',
                              style: Styles.black124,
                              children: [
                                TextSpan(
                                  text: ' :₹ ${walletToal}',
                                  style: Styles.blue125,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Add space between the widgets (optional)
                        if (role == CustomText.crecheSupervisor.trim())
                          Spacer(),
                        // Right Widget
                        role == CustomText.crecheSupervisor.trim()
                            ? Container(
                                child: AnimatedRollingSwitch(
                                  title1: Global.returnTrLable(
                                      translats, CustomText.all, lng),
                                  title2: Global.returnTrLable(
                                      translats, CustomText.unsynched, lng),
                                  isOnlyUnsynched: isOnlyUnsynched ?? false,
                                  onChange: (value) async {
                                    setState(() {
                                      isOnlyUnsynched = value;
                                    });
                                    await fetchCashbookData();
                                  },
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  (expensesData.length > 0)
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: expensesData.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    var cashbookGuid =
                                        expensesData[index].cashbook_guid;
                                    var backDate = now.isBefore(applicableDate)
                                        ? DateTime(1992)
                                        : DateTime.parse(
                                                Validate().currentDate())
                                            .subtract(Duration(days: 7));
                                    if (minDate != null) {
                                      if (minDate!.isBefore(backDate)) {
                                        minDate = backDate;
                                      }
                                    } else if (minDate == null) {
                                      minDate = backDate;
                                    }
                                    // minDate=backDate;

                                    var created_at = DateTime.parse(
                                        expensesData[index]
                                            .created_at
                                            .toString());
                                    var date = DateTime(created_at.year,
                                        created_at.month, created_at.day);
                                    bool isEditable = date
                                        .add(Duration(days: 8))
                                        .isAfter(DateTime.parse(
                                            Validate().currentDate()));
                                    if (isEditable) {
                                      isEditable = now.isBefore(applicableDate);
                                    }

                                    var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) => (role ==
                                                    CustomText.crecheSupervisor
                                                ? (now.isBefore(applicableDate)
                                                    ? true
                                                    : false)
                                                : false)
                                            ? CashbookExpensesDetailsScreen(
                                                creche_id: widget.creche_id,
                                                cashbook_guid: cashbookGuid!,
                                                minDate: minDate,
                                                reqAmount: walletToal +
                                                    Global.stringToDouble(Global.getItemValues(
                                                        expensesData[index]
                                                            .responces!,
                                                        'expense_amount')))
                                            : CashbookExpensesDetailsViewScreen(
                                                creche_id: widget.creche_id,
                                                cashbook_guid: cashbookGuid!,
                                                reqAmount: walletToal + Global.stringToDouble(Global.getItemValues(expensesData[index].responces!, 'expense_amount')))));
                                    if (refStatus == 'itemRefresh') {
                                      await fetchCashbookData();
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
                                                  '${Global.returnTrLable(translats, CustomText.DateS, lng).trim()} :',
                                                  style: Styles.black104,
                                                ),
                                                Text(
                                                  '${Global.returnTrLable(translats, CustomText.amount, lng).trim()} :',
                                                  style: Styles.black104,
                                                  strutStyle:
                                                      StrutStyle(height: 1.2),
                                                )
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
                                                    Validate().displeDateFormate(
                                                        Global.getItemValues(
                                                            expensesData[index]
                                                                .responces!,
                                                            'date')),
                                                    style: Styles.cardBlue10,
                                                    strutStyle:
                                                        StrutStyle(height: .5),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    "₹ ${Global.getItemValues(expensesData[index].responces!, 'expense_amount')}",
                                                    style: Styles.cardBlue10,
                                                    strutStyle:
                                                        StrutStyle(height: 1.2),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            (expensesData[index].is_edited ==
                                                        0 &&
                                                    expensesData[index]
                                                            .is_uploaded ==
                                                        1)
                                                ? Image.asset(
                                                    "assets/sync.png",
                                                    scale: 1.5,
                                                  )
                                                : Image.asset(
                                                    "assets/sync_gray.png",
                                                    scale: 1.5,
                                                  )
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
                ],
              )
            : SizedBox(),
      ),
    );
  }

  Future<double> getRecieptTootal() async {
    List<CashbookReceiptResponseModel> receiptData =
        await CashBookReceiptResponseHelper()
            .cashbookByCreche(widget.creche_id);
    double total = 0;
    receiptData = receiptData
        .where((element) =>
            Global.getItemValues(element.responces!, 'status') == '1' &&
            element.is_uploaded == 1 &&
            element.is_edited == 0)
        .toList();
    receiptData.forEach((element) {
      total = total +
          Global.stringToDouble(
              Global.getItemValues(element.responces!, 'amount'));
    });

    double receiptTotal = 0;
    expensesData.forEach((element) {
      print(
          "object ${element.responces} >> ${Global.getItemValues(element.responces!, 'amount')}");
      receiptTotal = receiptTotal +
          Global.stringToDouble(
              Global.getItemValues(element.responces!, 'expense_amount'));
    });

    List<DateTime> dates = [];
    receiptData.forEach((element) {
      dates.add(
          DateTime.parse(Global.getItemValues(element.responces!, 'date')));
    });

    if (dates.length > 0) {
      minDate = dates.reduce(
          (value, element) => value.isBefore(element) ? value : element);
    }
    if (minDate != null) {
      setState(() {
        minDate = minDate!.subtract(Duration(days: 1));
      });
    }

    total = total - receiptTotal;
    print("totalValeE $total");

    return total;
  }
}
