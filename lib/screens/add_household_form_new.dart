// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/custom_widget/custom_appbar.dart';
// import 'package:shishughar/custom_widget/custom_btn.dart';
// import 'package:shishughar/custom_widget/custom_text.dart';
//
// import 'package:shishughar/custom_widget/customtextfield.dart';
// import 'package:shishughar/screens/linelistedhouseholld.dart';
// import 'package:shishughar/style/styles.dart';
// import 'package:shishughar/utils/globle_method.dart';
// import '../custom_widget/custom_radio_btn.dart';
// import '../custom_widget/customdatepicker.dart';
// import '../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
// import '../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
// import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
// import '../database/helper/house_field_item_helper.dart';
// import '../model/apimodel/house_hold_field_item_model_api.dart';
// import '../model/dynamic_screen_model/options_model.dart';
//
// class AddHouseholdScreenFromNew extends StatefulWidget {
//   const AddHouseholdScreenFromNew({super.key});
//
//   @override
//   State<AddHouseholdScreenFromNew> createState() => _HouseholdScreenState();
//
// }
//
// class _HouseholdScreenState extends State<AddHouseholdScreenFromNew> {
//   bool _isLoading = false;
//   int currentPage = 0;
//   String? selectedOdour;
//   List<TextEditingController> etControllers = [];
//   List<HouseHoldFielItemdModel> screensWidget = [];
//   Map<String, List<OptionsModel>> options = {};
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppbar(text: CustomText.AddHouseholdListing),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//         child:  Column(children: [
//           Expanded(
//               flex: 1,
//               child: Container(
//                   alignment: Alignment.centerLeft,
//                   child: FutureBuilder(
//                     future: callScrenControllers('Household Form'),
//                     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.none:
//                         case ConnectionState.waiting:
//                           return Center(child: Text('Loading...'));
//                         default:
//                           if (snapshot.hasError) {
//                             return SizedBox(
//                               height: 10,
//                             );
//                           } else {
//                             // paramsAll['questionOption'] = _questionOption;
//                             // paramsAll['questionLogic'] = questionLogic;
//                             // paramsAll['setIsMadatory'] = setIsMadatory;
//                             // paramsAll['question_rendering_id'] = question_rendering_id;
//                             // paramsAll['allTheme'] = allTheme;
//
//                             return  cWidget(snapshot);
//                           }
//                       }
//                     },
//                   )
//                 // Column(
//                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                 //   children: initQuestion(currentPage),
//                 // )
//               )),
//           Row(
//             children: [
//               Expanded(
//                 child: CElevatedButton(
//                   color: Color(0xffF26BA3),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   text: CustomText.back,
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: CElevatedButton(
//                   color: Color(0xff5979AA),
//                   onPressed: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (BuildContext context) =>
//                             LineholdlistedScreen()));
//                   },
//                   text: CustomText.Save,
//                 ),
//               ),
//             ],
//           ),
//         ])
//
//       ),
//     );
//   }
//
//   Widget cWidget(AsyncSnapshot items) {
//     List<Widget> screenItems = [];
//
//     for (int i = 0; i < screensWidget.length; i++) {
//       List<OptionsModel>? optItems=options[screensWidget[i].name];
//       // var mapItep=options[screensWidget[i].name];
//       // mapItep!.forEach((element) {
//       //   optItems.add(OptionsModel.fromJson(element));
//       // });
//       screenItems.add(widgetTypeWidget(i,optItems));
//       screenItems.add(SizedBox(height: 5.h));
//     }
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: screenItems,
//       ),
//     );
//     // return screenItems;
//   }
//
//   widgetTypeWidget(int index, List<OptionsModel>? optItems) {
//     switch (screensWidget[index].fieldtype) {
//       case 'Tab Break':
//         return Text(
//           screensWidget[index].label!,
//           style: Styles.red145,
//         );
//       case 'Link':
//         return DynamicCustomDropdownField(
//           titleText: screensWidget[index].label,
//           items: optItems!,
//           selectedItem: selectedOdour,
//           onChanged: (value) {
//
//           },
//         );
//       case 'Date':
//         return CustomDatepicker(
//           controller: etControllers[index],
//           titleText: screensWidget[index].label,
//         );
//       case 'Data':
//         return CustomTextField(
//           controller: etControllers[index],
//           titleText: screensWidget[index].label,
//         );
//       case 'Int':
//         return DynamicCustomTextFieldNew(
//           onChanged: (value) {
//             print('Entered text: $value');
//             // myMap[screensWidget[index].name!]=value;
//           },
//           keyboardtype: TextInputType.number,
//           titleText: screensWidget[index].label,
//         );
//       case 'Check':
//         return CustomRadioButton(
//           value: screensWidget[index].label!,
//           groupValue: "1",
//           onChanged: (value) {
//             setState(() {
//               // "Gendertype" = value!;
//             });
//           },
//           label: screensWidget[index].label!,
//         );
//       case 'Select':
//         return CustomTextField(
//           controller: etControllers[index],
//           titleText: screensWidget[index].label,
//         );
//       case 'Small Text':
//         return CustomTextField(
//           controller: etControllers[index],
//           titleText: screensWidget[index].label,
//         );
//       default:
//         return CustomTextField(
//           controller: etControllers[index],
//           titleText: screensWidget[index].label,
//         );
//     }
//     }
//
//   Future<List<HouseHoldFielItemdModel>> callScrenControllers(screen_type) async {
//       await HouseHoldFieldHelper().getHouseHoldFieldsForm('Household Form')
//           .then((value) => screensWidget = value);
//
//       for (int i = 0; i < screensWidget.length; i++) {
//         etControllers.add(TextEditingController());
//         if(Global.validString(screensWidget[i].options)) {
//           if(!(screensWidget[i].options=='Household Child Form')) {
//             if((screensWidget[i].options=='State')||(screensWidget[i].options=='District')
//                 ||(screensWidget[i].options=='Block')||(screensWidget[i].options=='Gram Panchayat')
//                 ||(screensWidget[i].options=='Village')) {
//               var data = await OptionsModelHelper().getOptions(
//                   screensWidget[i].options!.trim());
//               options[screensWidget[i].name!] = data;
//             }else {
//               var data = await OptionsModelHelper().getMstCommonOptions(
//                   screensWidget[i].options!.trim());
//               options[screensWidget[i].name!] = data;
//             }
//           }else options[screensWidget[i].name!]=[];
//         }else options[screensWidget[i].name!]=[];
//       }
//       // setState(() {});
//       return screensWidget;
//       // setState(() {
//       //   _isLoading = true;
//       // });
//     }
//
//     // @override
//     // void initState() {
//     //   callScrenControllers('Household Form');
//     //   super.initState();
//     // }
//   }
//
//
//
