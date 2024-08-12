//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/database/helper/translation_language_helper.dart';
// import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
// import 'package:shishughar/style/styles.dart';
// import 'package:shishughar/utils/globle_method.dart';
// import 'package:shishughar/utils/validate.dart';
//
// import '../../../custom_widget/custom_appbar.dart';
// import '../../../custom_widget/custom_btn.dart';
// import '../../../custom_widget/custom_text.dart';
// import '../../../custom_widget/custom_textfield.dart';
// import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
// import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
// import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
// import '../../../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
// import '../../../database/helper/village_data_helper.dart';
// import '../../../model/databasemodel/tabVillage_model.dart';
// import '../../../model/dynamic_screen_model/enrolled_children_responce_model.dart';
// import '../../../model/dynamic_screen_model/options_model.dart';
// import 'child_growth_meta_listing_screen.dart';
//
// class EnrolledChildrenForAntrometoryListedScreen extends StatefulWidget {
//
//   const EnrolledChildrenForAntrometoryListedScreen({super.key});
//
//   @override
//   _EnrolledChildrenListedScreenState createState() =>
//       _EnrolledChildrenListedScreenState();
// }
//
// class _EnrolledChildrenListedScreenState
//     extends State<EnrolledChildrenForAntrometoryListedScreen> {
//   TextEditingController Searchcontroller = TextEditingController();
//   List<EnrolledChildrenResponceModel> childHHData = [];
//   List<EnrolledChildrenResponceModel> filterData = [];
//   List<OptionsModel> relationChilddata = [];
//   List<TabVillage> villages = [];
//   List<Translation> translats = [];
//   String lng = 'en';
//   String? selectedItem;
//   int? ageLimit;
//   bool isVisible = false;
//   List<OptionsModel> genderList = [];
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
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
//     genderList = await OptionsModelHelper().getMstCommonOptions('Gender');
//
//     relationChilddata =
//         await OptionsModelHelper().getMstCommonOptions('Relation');
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
//     fetchChildHHDataList();
//     setState(() {});
//   }
//
//   Future<void> fetchChildHHDataList() async {
//         childHHData = await EnrolledChilrenResponceHelper().enrolledChildByCreche();
//     filterData = childHHData;
//     Searchcontroller.text = '';
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: CustomAppbar(
//         text: '${Global.returnTrLable(translats, CustomText.enrolled_children, lng!)}',
//         onTap: () {
//           Navigator.pop(context);
//         },
//       ),
//       endDrawer: SafeArea(
//         child: Drawer(
//             backgroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 30),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             "assets/filter_icon.png",
//                             scale: 2.4,
//                           ),
//                           SizedBox(
//                             width: 10.w,
//                           ),
//                           Text(
//                             CustomText.Filter,
//                             style: Styles.labelcontrollerfont,
//                           ),
//                           Spacer(),
//                           InkWell(
//                               onTap: () async {
//                                 _scaffoldKey.currentState!.closeEndDrawer();
//                                 // cleaAllFilter();
//                               },
//                               child: Image.asset(
//                                 'assets/cross.png',
//                                 color: Colors.grey,
//                                 scale: 4,
//                               )),
//                         ],
//                       ),
//                     ),
//                     SizedBox(),
//                     DynamicCustomTextFieldInt(
//                       hintText:
//                       Global.returnTrLable(translats, CustomText.age, lng),
//                       // isRequred: 1,
//                       onChanged: (value) {
//                         ageLimit = value!;
//                       },
//                     ),
//                     DynamicCustomDropdownField(
//                       // height: MediaQuery.of(context).size.height * 0.2,
//                       // width: MediaQuery.of(context).size.width * 0.4,
//                       hintText: Global.returnTrLable(
//                           translats, CustomText.Gender, lng),
//                       // isRequred: 1,
//                       items: genderList,
//                       selectedItem: selectedItem,
//                       onChanged: (value) {
//                         selectedItem = value?.name;
//                         print('selectedVillage $selectedItem');
//                       },
//                     ),
//                     SizedBox(
//                       height: 10.h,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(3.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Expanded(
//                             child: CElevatedButton(
//                               text: Global.returnTrLable(
//                                   translats, 'Search', lng!),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 filteredGetData(context);
//                               },
//                             ),
//                           ),
//                           // Spacer(),
//                           SizedBox(width: 4.w),
//                           Expanded(
//                             child: CElevatedButton(
//                               text: Global.returnTrLable(
//                                   translats, 'Clear', lng!),
//                               color: Color(0xffF26BA3),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 cleaAllFilter();
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ]),
//             )),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//         child: Column(children: [
//           Row(
//             children: [
//               Expanded(
//                   child: CustomTextFieldRow(
//                     controller: Searchcontroller,
//                     onChanged: (value) {
//                       print(value);
//                       filterDataQu(value);
//                     },
//                     hintText:
//                     Global.returnTrLable(translats, CustomText.Search, lng),
//                     prefixIcon: Image.asset(
//                       "assets/search.png",
//                       scale: 2.4,
//                     ),
//                   )),
//               SizedBox(
//                 width: 10.w,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   _scaffoldKey.currentState!.openEndDrawer();
//                 },
//                 child: Image.asset(
//                   "assets/filter_icon.png",
//                   scale: 2.4,
//                 ),
//               )
//             ],
//           ),
//           Expanded(
//             child: (filterData.length > 0)
//                 ? ListView.builder(
//                     itemCount: filterData.length,
//                     shrinkWrap: true,
//                     physics: BouncingScrollPhysics(),
//                     scrollDirection: Axis.vertical,
//                     itemBuilder: (BuildContext context, int index) {
//                       return GestureDetector(
//                         onTap: () async {
//                           String refStatus = '';
//                           refStatus = await Navigator.of(context).push(
//                               MaterialPageRoute(
//                                   builder: (BuildContext context) =>
//                                       ChildGrowthMetaListinh(
//                                         childenrollguid: childHHData[index]
//                                             .ChildEnrollGUID!,
//                                         child_id:childHHData[index].name.toString(),
//                                         creche_id:Global.getItemValues(childHHData[index].responces!, 'creche_id'),
//                                         chhguid:
//                                         childHHData[index].CHHGUID!,)));
//
//                           if (refStatus == 'itemRefresh') {
//                             await fetchChildHHDataList();
//                           }
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 5.h),
//                           child: Container(
//                             decoration: BoxDecoration(
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
//                                     CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         '${Global.returnTrLable(translats, 'Child Name', lng!).trim()} : ',
//                                         style: Styles.black104,
//                                       ),
//                                       Text(
//                                         '${Global.returnTrLable(translats, CustomText.careGiverName, lng!).trim()} : ',
//                                         style: Styles.black104,
//                                         strutStyle: StrutStyle(height: 1),
//                                       ),
//                                       Text(
//                                         '${Global.returnTrLable(translats, 'Child Age (In Months)', lng!).trim()} : ',
//                                         style: Styles.black104,
//                                         strutStyle: StrutStyle(height: 1),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(width: 10),
//                                   SizedBox(
//                                     height: 40.h,
//                                     width: 2,
//                                     child: VerticalDivider(
//                                       color: Color(0xffE6E6E6),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           Global.getItemValues(
//                                               childHHData[index].responces!,
//                                               'child_name'),
//                                           style: Styles.blue125,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         Text(
//                                           Global.getItemValues(
//                                               childHHData[index].responces!,
//                                               'name_of_primary_caregiver'),
//                                           style: Styles.blue125,
//                                           strutStyle: StrutStyle(height: .5),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         Text(
//                                           Global.getItemValues(
//                                               childHHData[index].responces!,
//                                               'age_at_enrollment_in_months'),
//                                           style: Styles.blue125,
//                                           strutStyle: StrutStyle(height: .5),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   )
//                 : Center(
//                     child: Text(Global.returnTrLable(
//                         translats, CustomText.NorecordAvailable, lng)),
//                   ),
//           ),
//           SizedBox(height: 10.h)
//         ]),
//       ),
//     );
//   }
//
//   String getfindRelationValues(String id) {
//     String returnValue = "";
//
//     if (Global.validString(id)) {
//       var reltionvl =
//           relationChilddata.where((element) => element.name == id).toList();
//       if (reltionvl.length > 0) {
//         returnValue = reltionvl[0].values!;
//       }
//     }
//
//     return returnValue;
//   }
//
//   filterDataQu(String entry) {
//     if (entry.length > 0) {
//       filterData = childHHData
//           .where((element) =>
//               (Global.getItemValues(
//                       element.responces!, 'name_of_primary_caregiver'))
//                   .toLowerCase()
//                   .contains(entry.toLowerCase()) ||
//               (Global.getItemValues(element.responces!, 'child_name'))
//                   .toLowerCase()
//                   .contains(entry.toLowerCase()))
//           .toList();
//     } else
//       filterData = childHHData;
//     setState(() {});
//   }
//   String callVillageName(String crecheItem) {
//     String returnValue = '';
//     var items = villages
//         .where((element) =>
//     element.name ==
//         int.parse(Global.getItemValues(crecheItem, 'village_id')))
//         .toList();
//     if (items.length > 0) {
//       returnValue = items[0].value!;
//     }
//     return returnValue;
//   }
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
//
//   filteredGetData(BuildContext context) async {
//     if (selectedItem != null && ageLimit != null) {
//       filterData = childHHData.where((element) {
//         var ViItem = Global.getItemValues(element.responces!, 'gender_id');
//         var ageItem =
//         int.parse(Global.getItemValues(element.responces!, 'child_age'));
//         return ViItem == selectedItem && ageItem <= ageLimit!;
//       }).toList();
//     } else if (selectedItem != null && ageLimit == null) {
//       filterData = childHHData.where((element) {
//         var ViItem = Global.getItemValues(element.responces!, 'gender_id');
//         return ViItem == selectedItem;
//       }).toList();
//     } else if (ageLimit != null && selectedItem == null) {
//       filterData = childHHData.where((element) {
//         var ageItem =
//         int.parse(Global.getItemValues(element.responces!, 'child_age'));
//         return ageItem <= ageLimit!;
//       }).toList();
//     } else {
//       filterData = childHHData;
//     }
//     setState(() {});
//     // if (selectedItem == null && ageLimit! <= 0) {
//     //   Validate().singleButtonPopup(
//     //       Global.returnTrLable(translats, CustomText.plsFilManForm, lng),
//     //       Global.returnTrLable(translats, CustomText.ok, lng),
//     //       false,
//     //       context);
//     // } else {
//     //   filterData = childHHData.where((item) {
//     //     var viItem = Global.getItemValues(item['responces'], 'gender_id');
//     //     var ageItemm = Global.getItemValues(item['responces'], 'child_age');
//     //     return viItem.toString() == selectedItem.toString() &&
//     //         int.parse(ageItemm) <= ageLimit!;
//     //   }).toList();
//   }
//
//   void cleaAllFilter() {
//     filterData = childHHData;
//     selectedItem = null;
//     Searchcontroller.text = '';
//     ageLimit = null;
//     setState(() {});
//   }
// }
