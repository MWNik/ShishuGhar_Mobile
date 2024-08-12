// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/custom_widget/custom_appbar.dart';
// import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
// import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
// import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
//
// import '../../../custom_widget/custom_btn.dart';
// import '../../../custom_widget/custom_text.dart';
// import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_checkbox.dart';
// import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
// import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
// import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
// import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
// import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
// import '../../../custom_widget/single_poup_dailog.dart';
// import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
// import '../../../database/helper/creche_helper/creche_data_helper.dart';
// import '../../../database/helper/form_logic_helper.dart';
// import '../../../database/helper/translation_language_helper.dart';
// import '../../../model/apimodel/form_logic_api_model.dart';
// import '../../../model/dynamic_screen_model/options_model.dart';
// import '../../../utils/globle_method.dart';
// import '../../../utils/validate.dart';
// import '../house_hold/depending_logic.dart';
//
// class ChildGrowthFormScreen extends StatefulWidget {
//   final String chhguid;
//   final String cgmguid;
//   final String childenrollguid;
//   final String creche_id;
//   final String child_id;
//
//   const ChildGrowthFormScreen({
//     super.key,
//     required this.chhguid,
//     required this.cgmguid,
//     required this.childenrollguid,
//     required this.creche_id,
//     required this.child_id,
//   });
//
//   @override
//   State<ChildGrowthFormScreen> createState() => _ChildGrowthFormState();
// }
//
// class _ChildGrowthFormState extends State<ChildGrowthFormScreen> {
//   List<HouseHoldFielItemdModel> formItem = [];
//   bool _isLoading = true;
//   List<Translation> translatsLabel = [];
//   Map<String, dynamic> myMap = {};
//   List<TabFormsLogic> logics = [];
//   List<OptionsModel> options = [];
//   String lng = 'en';
//   String userName = '';
//
//   @override
//   void initState() {
//     super.initState();
//     initializeData();
//   }
//
//   Future<void> initializeData() async {
//     userName = (await Validate().readString(Validate.userName))!;
//     lng = (await Validate().readString(Validate.sLanguage))!;
//     translatsLabel.clear();
//     List<String> valueNames = [
//       CustomText.Save,
//       CustomText.Creches,
//       CustomText.CrecheCaregiver,
//       CustomText.Next,
//       CustomText.back
//     ];
//     await TranslationDataHelper()
//         .callTranslateString(valueNames)
//         .then((value) => translatsLabel = value);
//
//     await updateHiddenValue();
//     callScreenControler();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: CustomAppbar(
//             text: 'Antropomerthy Details', onTap: () => Navigator.pop(context)),
//         body: _isLoading
//             ? Center(child: CircularProgressIndicator())
//             : Column(
//                 children: [
//                   Divider(),
//                   Expanded(
//                       child:
//                       Padding(
//                         padding:
//                         EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: cWidget(),
//                           ),
//                         ),
//                       )),
//                   // Spacer(),
//                   Divider(),
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: CElevatedButton(
//                             color: Color(0xffF26BA3),
//                             onPressed: () {
//                               // ch(2);
//                               Navigator.pop(context);
//                             },
//                             text: Global.returnTrLable(
//                                     translatsLabel, CustomText.back, lng)
//                                 .trim(),
//                           ),
//                         ),
//                         // Row(children: [
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: CElevatedButton(
//                             color: Color(0xff5979AA),
//                             onPressed: () {
//                               saveMeta(1, context);
//                             },
//                             text: Global.returnTrLable(
//                                     translatsLabel, 'Save', lng)
//                                 .trim(),
//                           ),
//                         ),
//                         // ]
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ));
//   }
//
//   List<Widget> fieldController(List<HouseHoldFielItemdModel> items) {
//     List<Widget> fieldItems = [];
//     items.forEach((element) {
//       fieldItems.add(widgetTypeWidget(element));
//     });
//     return fieldItems;
//   }
//
//   List<Widget> cWidget() {
//     List<Widget> screenItems = [];
//     if (formItem.length>0) {
//       for (int i = 0; i < formItem.length; i++) {
//         screenItems.add(widgetTypeWidget(formItem[i]));
//         screenItems.add(SizedBox(height: 5.h));
//         if (!DependingLogic().callDependingLogic(logics, myMap, formItem[i])) {
//           myMap.remove(formItem[i].fieldname);
//         }
//       }
//     }
//     return screenItems;
//   }
//
//   saveMeta(int type, BuildContext mContext) async {
//     if (type == 1) {
//       if (_checkValidation()) {
//         await saveDataInData();
//         bool shouldProceed = await showDialog(
//           context: context,
//           builder: (context) {
//             return SingleButtonPopupDialog(
//                 message: Global.returnTrLable(
//                     translatsLabel, CustomText.dataSaveSuc, lng),
//                 button:
//                     Global.returnTrLable(translatsLabel, CustomText.ok, lng));
//           },
//         );
//         if (shouldProceed) {
//           if (shouldProceed == true) {
//             Navigator.pop(context, 'itemRefresh');
//           }
//         }
//         // return;
//
//         setState(() {});
//       }
//     } else {
//       Navigator.pop(context, 'itemRefresh');
//     }
//   }
//
//   Future<void> saveDataInData() async {
//     var widgets = formItem;
//     if (widgets != null) {
//       Map<String, dynamic> responces = {};
//       widgets.forEach((element) async {
//         if (myMap[element.fieldname] != null) {
//           responces[element.fieldname!] = myMap[element.fieldname];
//         }
//       });
//       var responcesJs = jsonEncode(myMap);
//       var name = myMap['name'];
//       print(responcesJs);
//       // await ChildGrowthResponseHelper().insertUpdate(
//       //     widget.childenrollguid,
//       //     widget.chhguid,
//       //     widget.cgmguid,
//       //     name as int?,
//       //    Global.stringToInt(widget.creche_id),
//       //     responcesJs,
//       //     userName);
//     }
//   }
//
//   bool _checkValidation() {
//     var validStatus = true;
//     var items = formItem;
//     if (items != null) {
//       for (int i = 0; i < items.length; i++) {
//         var element = items[i];
//         if (element.reqd == 1) {
//           var valuees = myMap[element.fieldname];
//           if (!Global.validString(valuees.toString().trim())) {
//             // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             //     content: Text(Global.returnTrLable(
//             //         translatsLabel, CustomText.plsFilManForm, lng))));
//             Validate().singleButtonPopup(Global.returnTrLable(
//                       translatsLabel, CustomText.plsFilManForm, lng), CustomText.ok, false, context);
//             validStatus = false;
//             break;
//           }
//         }
//         var validationMsg =
//             DependingLogic().validationMessge(logics, myMap, element);
//         if (Global.validString(validationMsg)) {
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //   SnackBar(content: Text(validationMsg!)),
//           // );
//           Validate().singleButtonPopup(validationMsg!, CustomText.ok, false, context);
//           validStatus = false;
//           break;
//         }
//       }
//       ;
//     } else {
//       print("selected items is null");
//     }
//
//     return validStatus;
//   }
//
//   callScreenControler() async {
//
//
//
//     List<String> logicFields = [];
//     List<String> defaultCommon = [];
//     List<HouseHoldFielItemdModel> allItem = [];
//     List<HouseHoldFielItemdModel>? title;
//     await ChildGrowthResponseHelper()
//         .getChildHHFieldsForm('Child Growth Monitoring')
//         .then((value) {
//       allItem = value;
//
//       title = allItem
//           .where((element) => element.fieldtype == CustomText.tabBreak)
//           .toList();
//     });
//     formItem = allItem
//         .where((element) =>
//             element.idx! > title![0].idx! && element.idx! < title![1].idx!)
//         .toList();
//     List<HouseHoldFielItemdModel> items = formItem;
//     for (int i = 0; i < items.length; i++) {
//       if (Global.validString(items[i].options)) {
//         // if (items[i].options == 'Illness') {
//         //   await OptionsModelHelper()
//         //       .getMstCommonOptions(items[i].options!.trim())
//         //       .then((value) => options.addAll(value));
//         //   defaultDisableDailog(items[i].fieldname!, items[i].options!);
//         // } else {
//           defaultCommon.add('tab${items[i].options!.trim()}');
//         // }
//       }
//       logicFields.add(items[i].fieldname!);
//     }
//     await OptionsModelHelper()
//         .getAllMstCommonNotINOptions(defaultCommon)
//         .then((data) {
//       options.addAll(data);
//     });
//     await FormLogicDataHelper()
//         .callFormLogic('Child Growth Monitoring')
//         .then((data) {
//       logics.addAll(data);
//     });
//
//     // fieldsList = fieldController(formItem);
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   defaultDisableDailog(String fieldName, String flag) async {
//     var tabName = 'tab$flag';
//     var item = options.where((element) => element.flag == tabName).toList();
//     if (item.length > 0) {
//       myMap[fieldName] = item.first.name!;
//     }
//   }
//
//   widgetTypeWidget(HouseHoldFielItemdModel quesItem) {
//     switch (quesItem.fieldtype) {
//       case 'Link':
//         List<OptionsModel> items = options
//             .where((element) => element.flag == 'tab${quesItem.options}')
//             .toList();
//         return DynamicCustomDropdownField(
//           titleText:
//               Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
//           isRequred: quesItem.reqd,
//           items: items,
//           selectedItem: myMap[quesItem.fieldname],
//           isVisible:
//               DependingLogic().callDependingLogic(logics, myMap, quesItem),
//           onChanged: (value) {
//             if (value != null)
//               myMap[quesItem.fieldname!] = value.name!;
//             else
//               myMap.remove(quesItem.fieldname);
//             setState(() {});
//           },
//         );
//       case 'Date':
//         return CustomDatepickerDynamic(
//           calenderValidate:[],
//           initialvalue: myMap[quesItem.fieldname!],
//           fieldName: quesItem.fieldname,
//           isRequred: quesItem.reqd,
//           onChanged: (value) {
//             myMap[quesItem.fieldname!] = value;
//             var logData = DependingLogic()
//                 .callDateDiffrenceLogic(logics, myMap, quesItem);
//             if (logData.isNotEmpty) {
//               if (logData.keys.length > 0) {
//                 myMap.addEntries(
//                     [MapEntry(logData.keys.first, logData.values.first)]);
//                 setState(() {});
//               }
//             }
//           },
//           titleText:
//               Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
//         );
//       case 'Data':
//         return DynamicCustomTextFieldNew(
//           titleText:
//               Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
//           isRequred: quesItem.reqd,
//           initialvalue: myMap[quesItem.fieldname!],
//           maxlength: quesItem.length,
//           readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
//           hintText:
//               Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
//           isVisible:
//               DependingLogic().callDependingLogic(logics, myMap, quesItem),
//           onChanged: (value) {
//             if (value.isNotEmpty)
//               myMap[quesItem.fieldname!] = value;
//             else
//               myMap.remove(quesItem.fieldname);
//           },
//         );
//       case 'Int':
//         return DynamicCustomTextFieldInt(
//           keyboardtype: TextInputType.number,
//           isRequred: quesItem.reqd,
//           maxlength: quesItem.length,
//           initialvalue: myMap[quesItem.fieldname!],
//           readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
//           titleText:
//               Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
//           isVisible:
//               DependingLogic().callDependingLogic(logics, myMap, quesItem),
//           onChanged: (value) {
//             print('Entered text: $value');
//             if (value != null) {
//               myMap[quesItem.fieldname!] = value;
//               var logData = DependingLogic()
//                   .callAutoGeneratedValue(logics, myMap, quesItem);
//               if (logData.isNotEmpty) {
//                 if (logData.keys.length > 0) {
//                   myMap.addEntries(
//                       [MapEntry(logData.keys.first, logData.values.first)]);
//                   // setState(() {});
//                 }
//               }
//             } else {
//               myMap.remove(quesItem.fieldname);
//               setState(() {});
//             }
//           },
//         );
//       case 'Check':
//         return DynamicCustomCheckboxWithLabel(
//           label:
//               Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
//           initialValue: myMap[quesItem.fieldname!],
//           isVisible:
//               DependingLogic().callDependingLogic(logics, myMap, quesItem),
//           onChanged: (value) {
//             if (value > 0)
//               myMap[quesItem.fieldname!] = value;
//             else
//               myMap.remove(quesItem.fieldname);
//             setState(() {});
//           },
//         );
//       case 'Select':
//         return DynamicCustomTextFieldInt(
//           keyboardtype: TextInputType.number,
//           isRequred: quesItem.reqd,
//           maxlength: quesItem.length,
//           readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
//           titleText:
//               Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
//           initialvalue: myMap[quesItem.fieldname!],
//           onChanged: (value) {
//             print('Entered text: $value');
//             if (value != null)
//               myMap[quesItem.fieldname!] = value;
//             else {
//               myMap.remove(quesItem.fieldname);
//               setState(() {});
//             }
//           },
//         );
//       case 'Small Text':
//         return DynamicCustomTextFieldNew(
//           titleText:
//               Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
//           isRequred: quesItem.reqd,
//           maxlength: quesItem.length,
//           readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
//           initialvalue: myMap[quesItem.fieldname!],
//           onChanged: (value) {
//             print('Entered text: $value');
//             if (value.isNotEmpty)
//               myMap[quesItem.fieldname!] = value;
//             else
//               myMap.remove(quesItem.fieldname);
//           },
//         );
//       case 'Float':
//         return DynamicCustomTextFieldFloat(
//           keyboardtype: TextInputType.number,
//           isRequred: quesItem.reqd,
//           maxlength: quesItem.length,
//           initialvalue: myMap[quesItem.fieldname!],
//           readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
//           titleText:
//               Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
//           isVisible:
//               DependingLogic().callDependingLogic(logics, myMap, quesItem),
//           onChanged: (value) {
//             print('Entered text: $value');
//             if (value != null) {
//               myMap[quesItem.fieldname!] = value;
//               var logData = DependingLogic()
//                   .callAutoGeneratedValue(logics, myMap, quesItem);
//               if (logData.isNotEmpty) {
//                 if (logData.keys.length > 0) {
//                   myMap.addEntries(
//                       [MapEntry(logData.keys.first, logData.values.first)]);
//                   // setState(() {});
//                 }
//               }
//             } else {
//               myMap.remove(quesItem.fieldname);
//               setState(() {});
//             }
//           },
//         );
//       default:
//         return SizedBox();
//     }
//   }
//
//
//   Future<void> updateHiddenValue() async {
//     var alredRecord =
//     await ChildGrowthResponseHelper().callAnthropometryByGuid(widget.cgmguid);
//
//
//     if (alredRecord.length > 0) {
//       Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
//       responseData.forEach((key, value) {
//         myMap[key] = value;
//       });
//       if(responseData['app_created_on']!=null || responseData['app_created_by']!=null){
//         myMap['app_updated_on'] = Validate().currentDateTime();
//         myMap['app_updated_by'] = userName;
//       }else {
//         myMap['app_created_by'] = userName;
//         myMap['app_created_on'] = Validate().currentDateTime();
//       }
//     }else{
//       var creCheDetails =
//       await CrecheDataHelper().getCrecheResponceItem(Global.stringToInt(widget.creche_id));
//       if(creCheDetails.length>0) {
//         myMap['app_created_by'] = userName;
//         myMap['app_created_on'] = Validate().currentDateTime();
//         myMap['cgmguid'] = widget.cgmguid;
//         myMap['childenrollguid'] = widget.childenrollguid;
//         myMap['chhguid'] = widget.chhguid;
//         myMap['child_profile_id'] = widget.child_id;
//         myMap['creche_name'] = widget.creche_id;
//         myMap['partner_id'] = Global.getItemValues(creCheDetails[0].responces!, 'partner_id');
//         myMap['state_id'] = Global.getItemValues(creCheDetails[0].responces!, 'state_id');
//         myMap['district_id'] = Global.getItemValues(creCheDetails[0].responces!, 'district_id');
//         myMap['block_id'] = Global.getItemValues(creCheDetails[0].responces!, 'block_id');
//         myMap['gp_id'] = Global.getItemValues(creCheDetails[0].responces!, 'gp_id');
//         myMap['village_id'] = Global.getItemValues(creCheDetails[0].responces!, 'village_id');
//       }
//     }
//
//
//   }
// }
