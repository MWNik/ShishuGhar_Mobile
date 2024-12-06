import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/utils/globle_method.dart';
import '../../../../custom_widget/custom_text.dart';
import '../../../../custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import '../../../../database/helper/cashbook/receipt/cashbook_receipt_response_helper.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../../model/dynamic_screen_model/cashbook_receipt_response_model.dart';
import '../../../../style/styles.dart';
import '../../../../utils/validate.dart';

class CashBookReceiptListingScreen extends StatefulWidget {
  final String creche_id;
  CashBookReceiptListingScreen({super.key, required this.creche_id});

  @override
  State<CashBookReceiptListingScreen> createState() =>
      _CashBookReceiptListingScreenState();
}

class _CashBookReceiptListingScreenState
    extends State<CashBookReceiptListingScreen> {
  List<CashbookReceiptResponseModel> receiptData = [];
  List<HouseHoldFielItemdModel> allItems = [];
  List<TabFormsLogic> logics = [];
  List<OptionsModel> options = [];
  List<Translation> translats = [];
  String userName = '';
  Map<String, dynamic> myMap = {};
  String? lng = 'en';
  String? role;
  List<OptionsModel> statusValue = [];

  List<CashbookReceiptResponseModel> unsynchedList = [];
  List<CashbookReceiptResponseModel> allList = [];
  bool isOnlyUnsynched = false;

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
    initializeData();
  }

  Future<void> initializeData() async {
    translats.clear();
    lng = (await Validate().readString(Validate.sLanguage))!;
    role = (await Validate().readString(Validate.role))!;
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
      CustomText.received,
      CustomText.mismatched,
      CustomText.moneyRecevied,
      CustomText.DateS,
      CustomText.amount,
      CustomText.Status
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    await fetchCashbookData();
  }

  Future<void> fetchCashbookData() async {
    receiptData = await CashBookReceiptResponseHelper()
        .cashbookByCreche(widget.creche_id);
    statusValue = await OptionsModelHelper()
        .getMstCommonOptions('Money Received by Caregiver', lng!);
    unsynchedList =
        receiptData.where((element) => element.is_edited == 1).toList();
    allList = receiptData;
    receiptData = isOnlyUnsynched ? unsynchedList : allList;
    setState(() {});
    // await updateHiddenValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          role == CustomText.crecheSupervisor
              ? Align(
                  alignment: Alignment.topRight,
                  child: AnimatedRollingSwitch(
                    title1:
                        Global.returnTrLable(translats, CustomText.all, lng!),
                    title2: Global.returnTrLable(
                        translats, CustomText.unsynched, lng!),
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
          (receiptData.length > 0)
              ? ListView.builder(
                  itemCount: receiptData.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        if (role == CustomText.crecheSupervisor) {
                          if (Global.getItemValues(
                                  receiptData[index].responces!, 'status') !=
                              "1") {
                            await callUpdateStatus(
                                receiptData[index].responces!,
                                receiptData[index].name!);
                          }
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${Global.returnTrLable(translats, CustomText.DateS, lng!).trim()} :',
                                      style: Styles.black104,
                                    ),
                                    Text(
                                      '${Global.returnTrLable(translats, CustomText.amount, lng!).trim()} :',
                                      style: Styles.black104,
                                      strutStyle: StrutStyle(height: 1.2),
                                    ),
                                    Text(
                                      '${Global.returnTrLable(translats, CustomText.Status, lng!).trim()} :',
                                      style: Styles.black104,
                                      strutStyle: StrutStyle(height: 1.2),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        Validate().displeDateFormate(
                                            Global.getItemValues(
                                                receiptData[index].responces!,
                                                'date')),
                                        style: Styles.cardBlue10,
                                        
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '₹ ${Global.getItemValues(receiptData[index].responces!, 'amount')}',
                                        style: Styles.cardBlue10,
                                        strutStyle: StrutStyle(height: 1.2),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        getStatusValue(Global.getItemValues(
                                            receiptData[index].responces!,
                                            'status')),
                                        style: Styles.cardBlue10,
                                        strutStyle: StrutStyle(height: 1.2),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(children: [
                                  Image.asset('assets/verifydata.png',
                                      filterQuality: FilterQuality.high,
                                      scale: 4.5,
                                      color: Global.getItemValues(
                                                  receiptData[index].responces!,
                                                  'status') ==
                                              '1'
                                          ? Color(0xff369A8D)
                                          : Global.getItemValues(
                                                      receiptData[index]
                                                          .responces!,
                                                      'status') ==
                                                  '2'
                                              ? Color(0xffF26BA3)
                                              : Colors.grey),
                                  SizedBox(height: 5),
                                  (receiptData[index].is_edited == 0 &&
                                          receiptData[index].is_uploaded == 1)
                                      ? Image.asset(
                                          "assets/sync.png",
                                          scale: 1.5,
                                        )
                                      : Image.asset(
                                          "assets/sync_gray.png",
                                          scale: 1.5,
                                        )
                                ])
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Expanded(
                  child: Center(
                    child: Text(Global.returnTrLable(
                        translats, CustomText.NorecordAvailable, lng!)),
                  ),
                ),
        ]),
      ),
    );
  }

  String getStatusValue(String? name) {
    String status = '';
    if (name!.isNotEmpty) {
      List<OptionsModel> value =
          statusValue.where((element) => element.name == name).toList();
      status = value.first.values!;
    }
    return status;
  }

  Future<void> callUpdateStatus(String responces, int name) async {
    bool shouldRefresh = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.zero,
            content: Container(
                width: MediaQuery.of(context).size.width * 5.00,
                // height: MediaQuery.of(context).size.height * 0.2,
                child: IntrinsicHeight(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 40.h,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xff5979AA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Spacer(),
                              Center(
                                  child: Text(CustomText.SHISHUGHAR,
                                      style: Styles.white126P)),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Image.asset(
                                  "assets/cross.png",
                                  scale: 2.7,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Center(
                            child: Text(Global.returnTrLable(translats,CustomText.moneyRecevied,lng!),
                                style: Styles.black3125,
                                textAlign: TextAlign.center)),
                        SizedBox(height: 15.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: CElevatedButton(
                                  text: Global.returnTrLable(translats, CustomText.mismatched, lng!),
                                  color: Color(0xffDB4B73),
                                  onPressed: () async {
                                    var map2 = jsonDecode(responces);
                                    map2['status'] = '2';
                                    var responseJS1 = jsonEncode(map2);
                                    await CashBookReceiptResponseHelper()
                                        .updateStatus(responseJS1, name);
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: CElevatedButton(
                                  text: Global.returnTrLable(translats, CustomText.received, lng!),
                                  color: Color(0xff369A8D),
                                  onPressed: () async {
                                    var map1 = jsonDecode(responces);
                                    map1['status'] = '1';
                                    var responseJS1 = jsonEncode(map1);
                                    await CashBookReceiptResponseHelper()
                                        .updateStatus(responseJS1, name);
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                )),
          );
        });
    if (shouldRefresh) {
      await fetchCashbookData();
    } else
      await fetchCashbookData();
  }
}
