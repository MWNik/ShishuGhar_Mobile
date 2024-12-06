// import 'dart:convert';
// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/custom_widget/custom_btn.dart';
// import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
// import 'package:shishughar/database/helper/requisition/requisition_response_helper.dart';
// import 'package:shishughar/database/helper/stock/stock_response_helper.dart';
// import 'package:shishughar/database/helper/translation_language_helper.dart';
// import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
// import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
// import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
// import 'package:shishughar/model/dynamic_screen_model/requisition_response_model.dart';
// import 'package:shishughar/model/dynamic_screen_model/stock_response_model.dart';
// import 'package:shishughar/screens/tabed_screens/stock/requisition/requisition_details_screen.dart';
// import 'package:shishughar/screens/tabed_screens/stock/stock/stock_details_screen.dart';
// import 'package:shishughar/utils/globle_method.dart';

// import '../../../../custom_widget/custom_text.dart';
// import '../../../../database/helper/cashbook/receipt/cashbook_receipt_response_helper.dart';
// import '../../../../database/helper/child_attendence/child_attendance_helper_responce.dart';
// import '../../../../model/apimodel/house_hold_field_item_model_api.dart';
// import '../../../../model/dynamic_screen_model/cashbook_receipt_response_model.dart';
// import '../../../../style/styles.dart';
// import '../../../../utils/validate.dart';

// class RequisitionListingScreen extends StatefulWidget {
//   final String creche_id;
//   final int month;
//   final int year;
//   String? childCounnt;
//   RequisitionListingScreen(
//       {super.key,
//       required this.creche_id,
//       required this.year,
//       required this.month,
//       this.childCounnt});

//   @override
//   State<RequisitionListingScreen> createState() =>
//       _RequisitionListingScreenState();
// }

// class _RequisitionListingScreenState extends State<RequisitionListingScreen> {
//   List<RequisitionResponseModel> requisitionData = [];
//   List<HouseHoldFielItemdModel> allItems = [];
//   List<TabFormsLogic> logics = [];
//   List<OptionsModel> options = [];
//   List<Translation> translats = [];
//   String userName = '';
//   Map<String, dynamic> myMap = {};
//   String? lng = 'en';
//   List<OptionsModel> itemlist = [];
//   List<OptionsModel> yearList = [];
//   List<OptionsModel> monthList = [];
//   List<OptionsModel> forCreateItem = [];

//   void initState() {
//     super.initState();
//     initializeData();
//   }

//   Future<void> initializeData() async {
//     translats.clear();
//     lng = (await Validate().readString(Validate.sLanguage))!;
//     List<String> valueItems = [
//       CustomText.Enrolled,
//       CustomText.ChildName,
//       CustomText.RelationshipChild,
//       CustomText.ageInMonth,
//       CustomText.hhNameS,
//       CustomText.NorecordAvailable,
//       CustomText.Search,
//       CustomText.Village
//     ];

//     await TranslationDataHelper()
//         .callTranslateString(valueItems)
//         .then((value) => translats.addAll(value));
//     await OptionsModelHelper()
//         .getMstCommonOptions('Partner Stock', lng!)
//         .then((value) => itemlist.addAll(value));
//     await OptionsModelHelper()
//         .getMstCommonOptions('Year', lng!)
//         .then((value) => yearList.addAll(value));
//     await OptionsModelHelper()
//         .getMstCommonOptions('Months', lng!)
//         .then((value) => monthList.addAll(value));
//     forCreateItem = await OptionsModelHelper()
//         .getAllMstCommonNotINPartenerStockWithoyExisting(
//             'tabPartner Stock',
//             Global.stringToInt(widget.creche_id),
//             widget.year,
//             widget.month,
//             lng!);

//     await fetchRequisitionData();
//   }

//   Future<void> fetchRequisitionData() async {
//     requisitionData = await RequisitionResponseHelper()
//         .getRequisitionByYearnMonth(
//             Global.stringToInt(widget.creche_id), widget.month, widget.year);

//     setState(() {});
//     // await updateHiddenValue();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context, 'itemRefersh');
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 60,
//           backgroundColor: Color(0xff5979AA),
//           leading: Padding(
//             padding: EdgeInsets.only(left: 10.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pop(context, 'itemRefresh');
//               },
//               child: Icon(
//                 Icons.arrow_back_ios_sharp,
//                 size: 20,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           title: RichText(
//             text: TextSpan(
//               children: [
//                 WidgetSpan(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         Global.returnTrLable(
//                             translats, CustomText.requiList, lng!),
//                         style: Styles.white145,
//                       ),
//                       Text(
//                         yearList.isNotEmpty && monthList.isNotEmpty
//                             ? "${getOptionsFromName(widget.month, 'Months')} - ${getOptionsFromName(widget.year, 'Year')}"
//                             : "",
//                         style: Styles.white126P,
//                       ),
//                       // Add additional TextSpans here if needed
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           centerTitle: true,
//         ),
//         floatingActionButton: forCreateItem.length > 0
//             ? InkWell(
//                 onTap: () async {
//                   String rguid = '';
//                   if (!Global.validString(rguid)) {
//                     rguid = Validate().randomGuid();

//                     var refStatus = await Navigator.of(context).push(
//                         MaterialPageRoute(
//                             builder: (BuildContext context) =>
//                                 RequisitionDetails(
//                                   children_count: widget.childCounnt,
//                                   month: widget.month,
//                                   year: widget.year,
//                                   creche_id: widget.creche_id,
//                                   rguid: rguid,
//                                 )));

//                     if (refStatus == 'itemRefresh') {
//                       fetchRequisitionData();
//                     }
//                   }
//                 },
//                 child: Image.asset(
//                   "assets/add_btn.png",
//                   scale: 2.7,
//                   color: Color(0xff5979AA),
//                 ),
//               )
//             : null,
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//           child: Column(children: [
//             (requisitionData.length > 0)
//                 ? ListView.builder(
//                     itemCount: requisitionData.length,
//                     shrinkWrap: true,
//                     physics: BouncingScrollPhysics(),
//                     scrollDirection: Axis.vertical,
//                     itemBuilder: (BuildContext context, int index) {
//                       return GestureDetector(
//                         onTap: () async {
//                           var rguid = requisitionData[index].rguid;

//                           var refStatus = await Navigator.of(context).push(
//                               MaterialPageRoute(
//                                   builder: (BuildContext context) =>
//                                       RequisitionDetails(
//                                         children_count: widget.childCounnt,
//                                         month: widget.month,
//                                         year: widget.year,
//                                         creche_id: widget.creche_id,
//                                         rguid: rguid!,
//                                       )));

//                           if (refStatus == 'itemRefresh') {
//                             fetchRequisitionData();
//                           }
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 5.h),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Color(0xff5A5A5A).withOpacity(0.2),
//                                     offset: Offset(0, 3),
//                                     blurRadius: 6,
//                                     spreadRadius: 0,
//                                   ),
//                                 ],
//                                 color: Colors.white,
//                                 border: Border.all(color: Color(0xffE7F0FF)),
//                                 borderRadius: BorderRadius.circular(10.r)),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 10.w, vertical: 8.h),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       // Text(
//                                       //   '${Global.returnTrLable(translats, 'Year', lng!).trim()}',
//                                       //   style: Styles.black104,
//                                       // ),
//                                       Text(
//                                         '${(index + 1)}',
//                                         style: Styles.black104,
//                                         strutStyle: StrutStyle(height: 1),
//                                       ),
//                                       // Text(
//                                       //   '${Global.returnTrLable(translats, 'Status', lng!).trim()}',
//                                       //   style: Styles.black104,
//                                       //   strutStyle: StrutStyle(height: 1),
//                                       // ),
//                                     ],
//                                   ),
//                                   SizedBox(width: 10),
//                                   SizedBox(
//                                     height: 10.h,
//                                     width: 2,
//                                     child: VerticalDivider(
//                                       color: Color(0xffE6E6E6),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         // Text(
//                                         //   getOptionsFromName(
//                                         //       Global.stringToInt(
//                                         //           Global.getItemValues(
//                                         //               requisitionData[index].responces,
//                                         //               'year')),
//                                         //       'Year'),
//                                         //   style: Styles.blue125,
//                                         //   strutStyle: StrutStyle(height: .5),
//                                         //   overflow: TextOverflow.ellipsis,
//                                         // ),
//                                         Text(
//                                           getOptionsFromName(
//                                               Global.stringToInt(
//                                                   Global.getItemValues(
//                                                       requisitionData[index]
//                                                           .responces!,
//                                                       'requistion_item')),
//                                               'Partner Stock'),
//                                           style: Styles.blue125,
//                                           strutStyle: StrutStyle(height: .5),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         // Text(
//                                         //   getStatusValue(Global.getItemValues(
//                                         //       requisitionData[index].responces!,
//                                         //       'status')),
//                                         //   style: Styles.blue125,
//                                         //   strutStyle: StrutStyle(height: .5),
//                                         //   overflow: TextOverflow.ellipsis,
//                                         // ),
//                                       ],
//                                     ),
//                                   ),
//                                   Column(children: [
//                                     SizedBox(height: 5),
//                                     (requisitionData[index].is_edited == 0 &&
//                                             requisitionData[index]
//                                                     .is_uploaded ==
//                                                 1)
//                                         ? Image.asset(
//                                             "assets/sync.png",
//                                             scale: 1.5,
//                                           )
//                                         : Image.asset(
//                                             "assets/sync_gray.png",
//                                             scale: 1.5,
//                                           )
//                                   ])
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     })
//                 : Expanded(
//                     child: Center(
//                       child: Text(Global.returnTrLable(
//                           translats, CustomText.NorecordAvailable, lng!)),
//                     ),
//                   ),
//           ]),
//         ),
//       ),
//     );
//   }

//   String getOptionsFromName(int name, String flag) {
//     String option = '';
//     if (flag == "Year") {
//       var list = yearList.where((element) {
//         return Global.stringToInt(element.name) == name;
//       });
//       option = list.first.values!;
//     } else if (flag == 'Partner Stock') {
//       var list = itemlist.where((element) {
//         return Global.stringToInt(element.name) == name;
//       });
//       option = list.first.values!;
//     } else if (flag == 'Months') {
//       var list = monthList.where((element) {
//         return Global.stringToInt(element.name) == name;
//       });
//       option = list.first.values!;
//     }
//     return option;
//   }
// }
