// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/custom_widget/custom_appbar.dart';
// import 'package:shishughar/custom_widget/custom_btn.dart';
// import 'package:shishughar/custom_widget/custom_text.dart';
//
// import 'package:shishughar/screens/linelistedhouseholld.dart';
// import 'package:shishughar/style/styles.dart';
// import '../custom_widget/custom_radio_btn.dart';
// import '../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
// import '../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
// import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
// import '../database/helper/house_field_item_helper.dart';
// import '../model/apimodel/house_hold_field_item_model_api.dart';
// import '../model/dynamic_screen_model/options_model.dart';
// import '../utils/globle_method.dart';
//
// class AddHouseholdScreenChildFrom extends StatefulWidget {
//   const AddHouseholdScreenChildFrom({super.key});
//
//   @override
//   State<AddHouseholdScreenChildFrom> createState() => _HouseholdScreenState();
//
// }
//
// class _HouseholdScreenState extends State<AddHouseholdScreenChildFrom> {
//   bool _isLoading = true; // Change this to true initially
//   int currentPage = 0;
//   String? selectedOdour;
//   List<HouseHoldFielItemdModel> screensWidget = [];
//   Map<String, List<OptionsModel>> options = {};
//   List<TextEditingController> etControllers = [];
//   @override
//   void initState() {
//     super.initState();
//     callScrenControllers('Household Child Form');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Center(child: CircularProgressIndicator());
//     } else {
//       return Scaffold(
//         appBar: CustomAppbar(text: CustomText.AddHouseholdListingChild),
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: cWidget(),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: CElevatedButton(
//                       color: Color(0xffF26BA3),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       text: CustomText.back,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: CElevatedButton(
//                       color: Color(0xff5979AA),
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                           builder: (BuildContext context) => LineholdlistedScreen(),
//                         ));
//                       },
//                       text: CustomText.Save,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }
//
//   List<Widget> cWidget() {
//     List<Widget> screenItems = [];
//     for (int i = 0; i < screensWidget.length; i++) {
//       List<OptionsModel>? optItems = options[screensWidget[i].name];
//       screenItems.add(widgetTypeWidget(i, optItems));
//       screenItems.add(SizedBox(height: 5.h));
//     }
//     return screenItems;
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
//       // case 'Date':
//       //   return CustomDatepicker(
//       //     controller: etControllers[index],
//       //     titleText: screensWidget[index].label,
//       //   );
//       case 'Data':
//        return DynamicCustomTextFieldNew(
//           onChanged: (value) {
//             print('Entered text: $value');
//             // myMap[screensWidget[index].name!]=value;
//           },
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
//       // case 'Select':
//       //   return CustomTextField(
//       //     controller: etControllers[index],
//       //     titleText: screensWidget[index].label,
//       //   );
//       // case 'Small Text':
//       //   return CustomTextField(
//       //     controller: etControllers[index],
//       //     titleText: screensWidget[index].label,
//       //   );
//       default:
//         return SizedBox(height: 1.h);
//     }
//   }
//
//   Future<void> callScrenControllers(screen_type) async {
//     await HouseHoldFieldHelper().getHouseHoldFieldsForm(screen_type).then((value) async {
//
//       screensWidget = value;
//       for (int i = 0; i < screensWidget.length; i++) {
//         etControllers.add(TextEditingController());
//         if (Global.validString(screensWidget[i].options)) {
//           if (!(screensWidget[i].options == 'Household Child Form')) {
//             if ((screensWidget[i].options == 'State') ||
//                 (screensWidget[i].options == 'District') ||
//                 (screensWidget[i].options == 'Block') ||
//                 (screensWidget[i].options == 'Gram Panchayat') ||
//                 (screensWidget[i].options == 'Village')) {
//               await OptionsModelHelper().getOptions(screensWidget[i].options!.trim()).then((data) {
//                 // setState(() {
//                 options[screensWidget[i].name!] = data;
//                 // });
//               });
//             } else {
//               await OptionsModelHelper().getMstCommonOptions(screensWidget[i].options!.trim()).then((data) {
//                 // setState(() {
//                 options[screensWidget[i].name!] = data;
//                 // });
//               });
//             }
//           } else {
//             options[screensWidget[i].name!] = [];
//           }
//         } else {
//           options[screensWidget[i].name!] = [];
//         }
//       }
//     });
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }
//
//
//
//
