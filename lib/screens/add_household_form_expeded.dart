// import 'dart:convert';
// import 'dart:ffi';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/custom_widget/custom_btn.dart';
// import 'package:shishughar/custom_widget/custom_text.dart';
// import 'package:shishughar/database/helper/translation_language_helper.dart';
// import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
//
// import 'package:shishughar/style/styles.dart';
// import 'package:shishughar/utils/validate.dart';
// import '../custom_widget/dynamic_screen_widget/dynamic_custom_checkbox.dart';
// import '../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
// import '../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
// import '../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
// import '../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
// import '../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
// import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
// import '../database/helper/house_field_item_helper.dart';
// import '../model/apimodel/house_hold_field_item_model_api.dart';
// import '../model/databasemodel/hh_data_view_model.dart';
// import '../model/dynamic_screen_model/options_model.dart';
// import '../utils/constants.dart';
// import '../utils/globle_method.dart';
//
// class AddHouseholdScreenFromExpended extends StatefulWidget {
//   final String hhGuid;
//
//   const AddHouseholdScreenFromExpended({super.key, required this.hhGuid});
//
//   @override
//   State<AddHouseholdScreenFromExpended> createState() =>
//       _HouseholdScreenState();
// }
//
// class _HouseholdScreenState extends State<AddHouseholdScreenFromExpended> {
//   bool _isLoading = true; // Change this to true initially
//   String? saveNext = "Next";
//   List<HouseHoldFielItemdModel> tabBreakItems = [];
//   List<OptionsModel> options = [];
//   int expandableList = 0;
//   Map<String, dynamic> myMap = {};
//   Map<String, List<HouseHoldFielItemdModel>> expendedItems = {};
//   String userName = '';
//   String? lang ;
//   List<Translation> lableControlls = [];
//
//   @override
//   void initState() {
//     super.initState();
//     setLabelText();
//     callScrenControllers('Household Form');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Center(child: CircularProgressIndicator());
//     } else {
//       return WillPopScope(
//         onWillPop: () async {
//           Navigator.pop(context, 'itemRefresh');
//           return false;
//         },
//         child: Scaffold(
//             body: Column(
//           children: [
//             Divider(),
//             Expanded(
//               child: ListView.builder(
//                 // physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: tabBreakItems.length,
//                 itemBuilder: (BuildContext context, int i) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               Global.validToString(tabBreakItems[i].label),
//                               style: expandableList == i
//                                   ? Styles.blue148
//                                   : Styles.gray124,
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               // if (expandableList == i) {
//                               //   expandableList = -1;
//                               // } else {
//                               //   expandableList = i;
//                               // }
//                               // setState(() {});
//                             },
//                             child: Icon(
//                               expandableList == i
//                                   ? Icons.expand_less
//                                   : Icons.expand_more,
//                               color: Color(0xffB2B2B2),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 5.h),
//                       expandableList == i
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: cWidget(tabBreakItems[i].name!),
//                             )
//                           : SizedBox.shrink(),
//                       if (i != tabBreakItems.length - 1) Divider(),
//                       // Add a Divider after each item except the last one
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Divider(),
//             Row(
//               children: [
//                 Expanded(
//                   child: CElevatedButton(
//                     color: Color(0xffF26BA3),
//                     onPressed: () {
//                       // Navigator.pop(context);
//                       nextTab(0);
//                     },
//                     text: CustomText.back,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: CElevatedButton(
//                     color: Color(0xff5979AA),
//                     onPressed: () {
//                       print(myMap);
//                       nextTab(1);
//                       // Navigator.of(context).push(MaterialPageRoute(
//                       //   builder: (BuildContext context) => AddHouseholdScreenChildFrom(),
//                       // ));
//                     },
//                     text: saveNext,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 5.h,
//             )
//           ],
//         )),
//       );
//     }
//   }
//
//   List<Widget> cWidget(String itemId) {
//     List<Widget> screenItems = [];
//     var items = expendedItems[itemId];
//     if (items != null) {
//       for (int i = 0; i < items.length; i++) {
//         screenItems.add(widgetTypeWidget(i, items[i]));
//         screenItems.add(SizedBox(height: 5.h));
//       }
//     }
//     return screenItems;
//   }
//
//   widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
//     switch (quesItem.fieldtype) {
//       case 'Link':
//         List<OptionsModel> items = options
//             .where((element) => element.flag == 'tab${quesItem.options}')
//             .toList();
//         return DynamicCustomDropdownField(
//           titleText: quesItem.label,
//           isRequred: quesItem.reqd,
//           items: items,
//           selectedItem: myMap[quesItem.fieldname],
//           onChanged: (value) {
//             myMap[quesItem.fieldname!] = value!.name!;
//           },
//         );
//       // case 'Date':
//       //   return CustomDatepickerDynamic(
//       //     initialvalue: myMap[quesItem.fieldname!],
//       //     fieldName: quesItem.fieldname,
//       //     isRequred: quesItem.reqd,
//       //     onChanged: (value) {
//       //       print('Entered text: $value');
//       //       myMap[quesItem.fieldname!] = '$value';
//       //     },
//       //     titleText: quesItem.label,
//       //   );
//       case 'Data':
//         return DynamicCustomTextFieldNew(
//           titleText: quesItem.label,
//           isRequred: quesItem.reqd,
//           initialvalue: myMap[quesItem.fieldname!],
//           hintText: quesItem.label,
//           onChanged: (value) {
//             print('Entered text: $value');
//             myMap[quesItem.fieldname!] = value;
//           },
//         );
//       case 'Int':
//         return DynamicCustomTextFieldInt(
//           keyboardtype: TextInputType.number,
//           isRequred: quesItem.reqd,
//           initialvalue: myMap[quesItem.fieldname!],
//           titleText: quesItem.label,
//           onChanged: (value) {
//             print('Entered text: $value');
//             myMap[quesItem.fieldname!] = value;
//           },
//         );
//       case 'Check':
//         return DynamicCustomCheckboxWithLabel(
//           label: quesItem.label!,
//           initialValue: myMap[quesItem.fieldname!],
//           onChanged: (value) {
//             print("checkVa $value");
//             myMap[quesItem.fieldname!] = value;
//           },
//         );
//       case 'Select':
//         return DynamicCustomTextFieldInt(
//           keyboardtype: TextInputType.number,
//           isRequred: quesItem.reqd,
//           titleText: quesItem.label,
//           initialvalue: myMap[quesItem.fieldname!],
//           onChanged: (value) {
//             print('Entered text: $value');
//             myMap[quesItem.fieldname!] = value;
//           },
//         );
//       case 'Small Text':
//         return DynamicCustomTextFieldNew(
//           titleText: quesItem.label,
//           isRequred: quesItem.reqd,
//           initialvalue: myMap[quesItem.fieldname!],
//           onChanged: (value) {
//             print('Entered text: $value');
//             myMap[quesItem.fieldname!] = value;
//           },
//         );
//       default:
//         return SizedBox();
//     }
//   }
//
//   Future<void> callScrenControllers(screen_type) async {
//     // await HouseHoldFieldHelper().getHouseHoldFieldsFormTab(screen_type, 'Tab Break').then((value) => tabBreakItems=value);
//     userName = (await Validate().readString(Validate.userName))!;
//     var alredRecord = await HouseHoldTabResponceHelper().getHouseHoldResponce(widget.hhGuid);
//     Map<String, dynamic> responseData = {};
//     if(alredRecord.isNotEmpty) {
//       responseData=jsonDecode(alredRecord[0].responces!);
//     }
//     await updateHiddenValue();
//     List<HouseHoldFielItemdModel> allItems = [];
//     List<HouseHoldFielItemdModel> tempBreakDown = [];
//     await HouseHoldFieldHelper()
//         .getHouseHoldFieldsForm(screen_type)
//         .then((value) async {
//       allItems = value;
//       tabBreakItems = allItems
//           .where((element) => element.fieldtype == 'Tab Break')
//           .toList();
//     });
//
//     for (int i = 0; i < tabBreakItems.length; i++) {
//       List<HouseHoldFielItemdModel> temp = [];
//       int idxI = tabBreakItems[i].idx!;
//       idxI = idxI + 1;
//       temp = allItems
//           .where(
//               (element) => element.fieldtype == 'Table' && element.idx == idxI)
//           .toList();
//       if (temp.length > 0) {
//         tempBreakDown.add(tabBreakItems[i]);
//       }
//     }
//
//     tempBreakDown.forEach((element) {
//       tabBreakItems.remove(element);
//     });
//
//     for (int i = 0; i < tabBreakItems.length; i++) {
//       if (i < (tabBreakItems.length) - 1) {
//         var filtredItem = allItems
//             .where((element) =>
//                 element.idx! > tabBreakItems[i].idx! &&
//                 element.idx! < tabBreakItems[i + 1].idx!)
//             .toList();
//         expendedItems[tabBreakItems[i].name!] = filtredItem;
//       } else {
//         var filtredItem = allItems
//             .where((element) => element.idx! > tabBreakItems[i].idx!)
//             .toList();
//         expendedItems[tabBreakItems[i].name!] = filtredItem;
//       }
//     }
//
//     print("expendedItemsItem ${expendedItems}");
//     // await HouseHoldFieldHelper().getHouseHoldFieldsForm(screen_type).then((value) async {
//
//     // screensWidget = value;
//     for (int i = 0; i < allItems.length; i++) {
//       if (Global.validString(allItems[i].options)) {
//         if (!(allItems[i].options == 'Household Child Form')) {
//           if ((allItems[i].options == 'State') ||
//               (allItems[i].options == 'District') ||
//               (allItems[i].options == 'Block') ||
//               (allItems[i].options == 'Gram Panchayat') ||
//               (allItems[i].options == 'Village') ||
//               (allItems[i].options == 'Partner')) {
//             if(allItems[i].options == 'Partner'){
//               await OptionsModelHelper()
//                   .getPartnerMstCommonOptions(allItems[i].options!.trim(),responseData)
//                   .then((data) {
//                 options.addAll(data);
//               });
//             }
//             else {
//               await OptionsModelHelper()
//                   .getLocationData(allItems[i].options!.trim(),responseData)
//                   .then((data) {
//                 options.addAll(data);
//               });
//             }
//             defaultDisableDailog(allItems[i].fieldname!,allItems[i].options!);
//           }
//         }
//         else {
//           await OptionsModelHelper().getAllMstCommonOptions().then((data) {
//             options.addAll(data);
//           });
//         }
//         // else if(allItems[i].options=='Partner'){
//         //   await OptionsModelHelper().getPartnerMstCommonOptions(allItems[i].options!).then((data) {
//         //     options.addAll(data);
//         //   });
//         // }
//       }
//     }
//     // });
//
//
//     print("opiotin ${options.length}");
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   nextTab(int type) async {
//     if (type == 1) {
//       if (checkValidation()) {
//         if (expandableList < (tabBreakItems.length - 1)) {
//           myMap['verification_status'] = "1";
//           await saveDataInData(tabBreakItems[expandableList]);
//           expandableList = expandableList + 1;
//           if (expandableList == ((tabBreakItems.length) - 1)) {
//             myMap['verification_status'] = "2";
//             saveNext = "Save";
//           }
//         } else if (expandableList == (tabBreakItems.length - 1)) {
//           await saveDataInData(tabBreakItems[expandableList]);
//           Validate().singleButtonPopup(Global.returnTrLable(lableControlls, 'Data Saved Successfully', lang!),
//               Global.returnTrLable(lableControlls, CustomText.ok, lang!),false,context);
//
//         }
//         setState(() {});
//       } else {
//         Validate().singleButtonPopup(Global.returnTrLable(lableControlls,
//             'Please fill all mandatory fields!', lang!),
//             Global.returnTrLable(lableControlls, CustomText.ok, lang!), false, context);
//       }
//     } else {
//       if (expandableList > 0) {
//         expandableList = expandableList - 1;
//         saveNext = "Next";
//       }
//       setState(() {});
//     }
//   }
//
//   bool checkValidation() {
//     var validStatus = true;
//     var items = expendedItems[tabBreakItems[expandableList].name];
//     if (items != null) {
//       items.forEach((element) {
//         if (element.reqd == 1) {
//           if (myMap[element.fieldname] == null) {
//             validStatus = false;
//             return;
//           }
//         }
//       });
//     } else {
//       print("selected items is null");
//     }
//
//     return validStatus;
//   }
//
//   Future<void> saveDataInData(HouseHoldFielItemdModel item) async {
//     var widgets = expendedItems[item.name];
//     if (widgets != null) {
//       Map<String, dynamic> responces = {};
//       widgets.forEach((element) async {
//         if (myMap[element.fieldname] != null) {
//           responces[element.fieldname!] = myMap[element.fieldname];
//         }
//       });
//       var responcesJs = jsonEncode(myMap);
//       var name=myMap['name'];
//       var dateOfVisit=myMap['date_of_visit'];
//       print(responcesJs);
//       await HouseHoldTabResponceHelper()
//           .insertUpdate(widget.hhGuid, dateOfVisit, name,responcesJs, userName);
//     }
//   }
//
//   Future<void> updateHiddenValue() async {
//     var allFields = await HouseHoldFieldHelper()
//         .getHouseHoldFieldsForm('Household Form');
//     var items = await HouseHoldFieldHelper()
//         .getHouseHoldFieldsHiddenField('Household Form');
//     var alredRecord =
//         await HouseHoldTabResponceHelper().getHouseHoldResponce(widget.hhGuid);
//     var hiddenIten = items
//         .where((element) =>
//             !(element.fieldtype == 'Tab Break') &&
//             !(element.fieldtype == 'Section Break') &&
//             !(element.fieldtype == 'Column Break'))
//         .toList();
//
//     if (alredRecord.length > 0) {
//       hiddenIten.forEach((element) {
//         if (element.fieldname == 'hhguid') {
//           myMap[element.fieldname!] = widget.hhGuid;
//         }
//         else if (element.fieldname == 'app_updated_on') {
//           myMap[element.fieldname!] = Validate().currentDateTime();
//         }
//         else if (element.fieldname == 'app_updated_by') {
//           myMap[element.fieldname!] = userName;
//         }
//         if(alredRecord[0].name!=null){
//           myMap['name'] = alredRecord[0].name;
//         }
//       });
//     } else {
//       hiddenIten.forEach((element) {
//         if (element.fieldname == 'hhguid') {
//           myMap[element.fieldname!] = widget.hhGuid;
//         } else if (element.fieldname == 'app_created_on') {
//           myMap[element.fieldname!] = Validate().currentDateTime();
//         } else if (element.fieldname == 'app_created_by') {
//           myMap[element.fieldname!] = userName;
//         // } else if (element.fieldname == 'verfication_status') {
//         //   myMap[element.fieldname!] = "3";
//         }
//       });
//     }
//
//     if (alredRecord.length > 0) {
//         Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
//       responseData.forEach((key, value) {
//         myMap[key] = value;
//       });
//     }
//   }
//
//   defaultDisableDailog(String fieldName,String flag) async {
//     var tabName = 'tab$flag';
//       var item=options.where((element) => element.flag==tabName).toList();
//       if(item.length>0){
//         myMap[fieldName]=item.first.name;
//       }
//     }
//
//     Future<void> setLabelText()async{
//       lang = await Validate().readString(Validate.sLanguage);
//       List<String> valueNames = ['Save','Select here','Data Saved Successfully',CustomText.ok];
//       await TranslationDataHelper()
//           .callTranslateString(valueNames)
//           .then((value) => lableControlls = value);
//
//       setState(() {});
//     }
// }
