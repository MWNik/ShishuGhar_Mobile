// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/custom_widget/custom_appbar.dart';
// import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
// import 'package:shishughar/screens/tabed_screens/child_exit/child_exit_details_screen.dart';
//
// import '../../../custom_widget/custom_text.dart';
// import '../../../database/helper/child_exit/child_exit_response_Helper.dart';
// import '../../../database/helper/translation_language_helper.dart';
// import '../../../model/apimodel/translation_language_api_model.dart';
// import '../../../model/databasemodel/child_exit_response_model.dart';
// import '../../../model/dynamic_screen_model/options_model.dart';
// import '../../../style/styles.dart';
// import '../../../utils/globle_method.dart';
// import '../../../utils/validate.dart';
//
// class ChildExitListingScreen extends StatefulWidget {
//   final int? enName;
//   final String? creche_id;
//   final String? chilenrolledGUID;
//   final String? childDob;
//   final String dateOfEnrollment;
//   final String childNameId;
//
//   const ChildExitListingScreen(
//       {super.key,
//       required this.enName,
//       required this.chilenrolledGUID,
//       required this.creche_id,
//       required this.childDob,
//       required this.dateOfEnrollment,
//       required this.childNameId
//       });
//
//   @override
//   State<ChildExitListingScreen> createState() => _ChildExitListingScreenState();
// }
//
// class _ChildExitListingScreenState extends State<ChildExitListingScreen> {
//   List<ChildExitTabResponceModel> childExitData = [];
//   List<Translation> translats = [];
//   String lng = 'en';
//   List<OptionsModel> reasonOfExit = [];
//   bool currentDate=false;
//   DateTime? lastDate;
//   DateTime? maxDate;
//
//
//   Future<void> initializeData() async {
//     List<int> dateParts = widget.dateOfEnrollment.split('-').map(int.parse).toList();
//     lastDate=DateTime(dateParts[0], dateParts[1], dateParts[2]).subtract(Duration(days:1));
//
//     translats.clear();
//     var lngtr = await Validate().readString(Validate.sLanguage);
//     if (lngtr != null) {
//       lng = lngtr;
//     }
//
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
//     reasonOfExit=await OptionsModelHelper().getMstCommonOptions('Reason for child exit');
//
//     await fetchChildevents();
//   }
//
//   Future<void> fetchChildevents() async {
//     childExitData = await ChildExitResponceHelper()
//         .childEventsByChild(widget.creche_id, widget.chilenrolledGUID);
//
//     await fetchChildDetail();
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initializeData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: childExitData.length>0?null:InkWell(
//         onTap: () async {
//           String chilevenGuid = '';
//           if (!(Global.validString(chilevenGuid))) {
//             chilevenGuid = Validate().randomGuid();
//             var refStatus = await Navigator.of(context).push(MaterialPageRoute(
//                 builder: (BuildContext context) => ChildExitDetailsScreen(
//                       childExitGuid: chilevenGuid,
//                       enName: widget.enName!,
//                     dateOfEnrolled: widget.dateOfEnrollment,
//                       chilenrolledGUID: widget.chilenrolledGUID!,
//                       creche_id: widget.creche_id,childDob:widget.childDob,lastDate:lastDate,
//                     childId: widget.childNameId,
//                     childName: widget.childNameId
//                     )));
//             if (refStatus == 'itemRefresh') {
//               fetchChildevents();
//             }
//           }
//         },
//         child: Image.asset(
//           "assets/add_btn.png",
//           scale: 2.7,
//           color: Color(0xff5979AA),
//         ),
//       ),
//       appBar: CustomAppbar(
//         text: Global.returnTrLable(translats, CustomText.ChildExit, lng),
//         subTitle:widget.childNameId,
//         onTap: () => Navigator.pop(context, 'itemRefresh'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//         child: Column(children: [
//           Expanded(
//             child: (childExitData.length > 0)
//                 ? ListView.builder(
//                     itemCount: childExitData.length,
//                     shrinkWrap: true,
//                     physics: BouncingScrollPhysics(),
//                     scrollDirection: Axis.vertical,
//                     itemBuilder: (BuildContext context, int index) {
//                       return GestureDetector(
//                         onTap: () async {
//                           var lstDate=await callDatesAlredDateList(Global.getItemValues(childExitData[index].responces!, 'date_of_exit'));
//                           var refStatus = await Navigator.of(context).push(
//                               MaterialPageRoute(
//                                   builder: (BuildContext context) =>
//                                       ChildExitDetailsScreen(
//                                         childExitGuid: childExitData[index]
//                                             .child_exit_guid,
//                                         enName: widget.enName!,
//                                         chilenrolledGUID: childExitData[index]
//                                             .childenrolledguid,
//                                         creche_id: widget.creche_id,
//                                           dateOfEnrolled: widget.dateOfEnrollment,
//                                           childDob:widget.childDob,
//                                           lastDate:lstDate,
//                                           maxDate:maxDate,
//                                           childId: widget.childNameId,
//                                           childName: widget.childNameId
//                                       )));
//                           if (refStatus == 'itemRefresh') {
//                             await fetchChildevents();
//                           }
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 5.h),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Color(0xff5A5A5A).withOpacity(
//                                         0.2), // Shadow color with opacity
//                                     offset: Offset(0,
//                                         3), // Horizontal and vertical offset
//                                     blurRadius: 6, // Blur radius
//                                     spreadRadius: 0, // Spread radius
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
//                                       Text(
//                                         '${Global.returnTrLable(translats, 'Date of Exit', lng).trim()} : ',
//                                         style: Styles.black104,
//                                       ),
//                                       Text(
//                                         '${Global.returnTrLable(translats, "Age on the day of exit", lng).trim()} : ',
//                                         style: Styles.black104,
//                                         strutStyle: StrutStyle(height: 1),
//                                       ),
//                                       Text(
//                                         '${Global.returnTrLable(translats, 'Reason for Exit', lng).trim()} : ',
//                                         style: Styles.black104,
//                                         strutStyle: StrutStyle(height: 1),
//                                       ),
//                                       // Text(
//                                       //   '${Global.returnTrLable(translats, 'Child Age (In Months)', lng).trim()} : ',
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
//                                         Text(
//                                           Validate().displeDateFormate(
//                                               Global.getItemValues(
//                                                   childExitData[index]
//                                                       .responces!,
//                                                   'date_of_exit')),
//                                           style: Styles.blue125,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         Text(
//                                           Global.getItemValues(
//                                               childExitData[index].responces!,
//                                               'age_of_exit'),
//                                           style: Styles.blue125,
//                                           strutStyle: StrutStyle(height: .5),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         Text(
//                                           getReasonOfExit(Global.getItemValues(
//                                               childExitData[index].responces!,
//                                               'reason_for_exit')),
//                                           style: Styles.blue125,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(width: 5),
//                                   Column(
//                                     children: [
//                                       SizedBox(
//                                         height: 30.h,
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     })
//                 : Center(
//                     child: Text(Global.returnTrLable(
//                         translats, CustomText.NorecordAvailable, lng)),
//                   ),
//           )
//         ]),
//       ),
//     );
//   }
//
//
//  String getReasonOfExit(String reasonId){
//     String reason='';
//     var items = reasonOfExit.where((element) => element.name.toString()==reasonId).toList();
//     if (items.length > 0) {
//       reason = items[0].values!;
//     }
//     return reason;
//
//   }
//
//   Future<void> fetchChildDetail() async {
//     //added
//     List<String> datesListString = [];
//     if (childExitData.isNotEmpty) {
//       childExitData.forEach((element) {
//         var date=Global.getItemValues(element.responces!, 'date_of_exit');
//         if(Global.validString(date)) {
//           datesListString.add(date);
//         }
//       });
//       var dateList = datesListString.map((dateString) {
//         List<int> dateParts = dateString.split('-').map(int.parse).toList();
//         return DateTime(dateParts[0], dateParts[1], dateParts[2]);
//       }).toList();
//       if(dateList.length>0) {
//         lastDate = dateList
//             .reduce((value, element) => value.isAfter(element) ? value : element);
//         currentDate =
//             lastDate == Validate().stringToDate(Validate().currentDate());
//       }
//
//     }
//
//   }
//
//   Future<DateTime?> callDatesAlredDateList(String date) async {
//     DateTime?  lastGrowthDateNew;
//     List<String> dateStringData = [];
//     childExitData.forEach((element) {
//       var date=Global.getItemValues(element.responces!, 'date_of_exit');
//       if(Global.validString(date)) {
//         dateStringData.add(date);
//       }
//     });
//     var dateList = dateStringData.map((dateString) {
//       List<int> dateParts = dateString.split('-').map(int.parse).toList();
//       return DateTime(dateParts[0], dateParts[1], dateParts[2]);
//     }).toList();
//
//     List<int> dateCuuten = date.split('-').map(int.parse).toList();
//
//     var selecttedItemDate=DateTime(dateCuuten[0], dateCuuten[1], dateCuuten[2]);
//
//     if(dateList.length>0) {
//       var maxDateList=dateList.where((element) => (selecttedItemDate.isAfter(element))).toList();
//       DateTime? greatestDate = maxDateList.isNotEmpty
//           ? maxDateList.reduce((value, element) => value.isAfter(element) ? value : element)
//           : null;
//       print('max $greatestDate');
//       lastGrowthDateNew = greatestDate;
//     }
//
//     if(dateList.length>0) {
//       var minDateList=dateList.where((element) => (selecttedItemDate.isBefore(element))).toList();
//       DateTime? lowesttDate = minDateList.isNotEmpty
//           ? minDateList.reduce((value, element) => value.isBefore(element) ? value : element)
//           : null;
//       maxDate=lowesttDate;
//       print('min $lowesttDate');
//     }else maxDate=null;
//     if(lastGrowthDateNew==null){
//       List<int> dateParts = widget.dateOfEnrollment.split('-').map(int.parse).toList();
//       lastGrowthDateNew=DateTime(dateParts[0], dateParts[1], dateParts[2]).subtract(Duration(days:1));
//     }
//
//     return lastGrowthDateNew;
//   }
//
// }
