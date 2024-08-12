// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/custom_widget/custom_appbar.dart';
//
// import '../../../custom_widget/custom_text.dart';
// import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
// import '../../../database/helper/translation_language_helper.dart';
// import '../../../database/helper/village_data_helper.dart';
// import '../../../model/apimodel/translation_language_api_model.dart';
// import '../../../model/databasemodel/child_growth_responce_model.dart';
// import '../../../model/databasemodel/tabVillage_model.dart';
// import '../../../style/styles.dart';
// import '../../../utils/globle_method.dart';
// import '../../../utils/validate.dart';
// import 'child_growth_form_screen.dart';
//
// class ChildGrowthMetaListinh extends StatefulWidget {
//   final String chhguid;
//   final String childenrollguid;
//   final String creche_id;
//   final String child_id;
//
//   const ChildGrowthMetaListinh({
//     super.key,
//     required this.chhguid,
//     required this.childenrollguid,
//     required this.child_id,
//     required this.creche_id,
//   });
//
//   @override
//   State<ChildGrowthMetaListinh> createState() => _ChildGrowthListingState();
// }
//
// class _ChildGrowthListingState extends State<ChildGrowthMetaListinh> {
//   List<ChildGrowthMetaResponseModel> childHHData = [];
//   List<Translation> translats = [];
//   List<TabVillage> villages = [];
//   String lng = 'en';
//
//
//   void initState() {
//     super.initState();
//     initializeData();
//   }
//
//   Future<void> initializeData() async {
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
//     villageValue();
//     fetchEnrolleChild();
//     setState(() {});
//   }
//
//   Future<void> fetchEnrolleChild() async {
//     childHHData = await ChildGrowthResponseHelper().anthormentryByCreche();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: InkWell(
//         onTap: () async {
//           String cgmguid = '';
//           if (!Global.validString(cgmguid)) {
//             cgmguid = Validate().randomGuid();
//             var refStatus = await Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (BuildContext context) => ChildGrowthFormScreen(
//                   childenrollguid: widget.childenrollguid,
//                   chhguid: widget.chhguid,
//                   child_id: widget.child_id,
//                   creche_id: widget.creche_id,
//                   cgmguid: cgmguid,
//                 ),
//               ),
//             );
//             if (refStatus == 'itemRefresh') {
//               fetchEnrolleChild();
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
//         text: Global.returnTrLable(translats, CustomText.anthropomertry, lng),
//         onTap: () => Navigator.pop(context),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//         child: Column(
//           children: [
//             Expanded(
//               child: (childHHData.length > 0)
//                   ? ListView.builder(
//                       itemCount: childHHData.length,
//                       shrinkWrap: true,
//                       physics: BouncingScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       itemBuilder: (BuildContext context, int index) {
//                         return GestureDetector(
//                           onTap: () async {
//                             String refStatus = '';
//
//                             String hhGuid = '';
//                             if (!Global.validString(hhGuid)) {
//                               refStatus = await Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                       builder: (BuildContext context) =>
//                                           ChildGrowthFormScreen(
//                                             childenrollguid:
//                                                 widget.childenrollguid,
//                                             chhguid: widget.chhguid,
//                                             child_id: widget.child_id,
//                                             creche_id: widget.creche_id,
//                                             cgmguid:
//                                                 childHHData[index].cgmguid!,
//                                           )));
//                             }
//
//                             if (refStatus == 'itemRefresh') {
//                               await fetchEnrolleChild();
//                             }
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(vertical: 5.h),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(color: Color(0xffE7F0FF)),
//                                   borderRadius: BorderRadius.circular(10.r)),
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10.w, vertical: 8.h),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '${Global.returnTrLable(translats, 'Measurement Date', lng).trim()} : ',
//                                           style: Styles.black104,
//                                         ),
//                                         Text(
//                                           '${Global.returnTrLable(translats, "Height", lng).trim()} : ',
//                                           style: Styles.black104,
//                                           strutStyle: StrutStyle(height: 1),
//                                         ),
//                                         Text(
//                                           '${Global.returnTrLable(translats, 'Weight', lng).trim()} : ',
//                                           style: Styles.black104,
//                                           strutStyle: StrutStyle(height: 1),
//                                         ),
//                                         Text(
//                                           '${Global.returnTrLable(translats, 'Child Age (In Months)', lng).trim()} : ',
//                                           style: Styles.black104,
//                                           strutStyle: StrutStyle(height: 1),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(width: 10),
//                                     SizedBox(
//                                       height: 40.h,
//                                       width: 2,
//                                       child: VerticalDivider(
//                                         color: Color(0xffE6E6E6),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             Validate().displeDateFormate(Global.getItemValues(
//                                                 childHHData[index].responces!,
//                                                 'measurement_date')),
//                                             style: Styles.blue125,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           Text(
//                                             Global.getItemValues(
//                                                 childHHData[index].responces!,
//                                                 'height'),
//                                             style: Styles.blue125,
//                                             strutStyle: StrutStyle(height: .5),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           Text(
//                                             Global.getItemValues(
//                                                 childHHData[index].responces!,
//                                                 'weight'),
//                                             style: Styles.blue125,
//                                             strutStyle: StrutStyle(height: .5),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           Text(
//                                             Global.getItemValues(
//                                                 childHHData[index].responces!,
//                                                 'age_months'),
//                                             style: Styles.blue125,
//                                             strutStyle: StrutStyle(height: .5),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 5),
//                                     Column(
//                                       children: [
//                                         SizedBox(
//                                           height: 30.h,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                   : Center(
//                       child: Text(Global.returnTrLable(
//                           translats, CustomText.NorecordAvailable, lng)),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String callVillageName(String crecheItem) {
//     String returnValue = '';
//     var items = villages
//         .where((element) =>
//             element.name ==
//             int.parse(Global.getItemValues(crecheItem, 'village_id')))
//         .toList();
//     if (items.length > 0) {
//       returnValue = items[0].value!;
//     }
//     return returnValue;
//   }
//
//   Future<String?> villageValue() async {
//     villages = await VillageDataHelper().getTabVillageList();
//     // villageList = villages
//     //     .map((model) => OptionsModel(
//     //     name: model.name.toString(),
//     //     values: model.value,
//     //     flag: 'tabBlock'))
//     //     .toList();
//     setState(() {});
//   }
// }
