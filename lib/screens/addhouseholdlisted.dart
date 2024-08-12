// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shishughar/custom_widget/custom_appbar.dart';
// import 'package:shishughar/custom_widget/custom_btn.dart';
// import 'package:shishughar/custom_widget/custom_dropdown.dart';
// import 'package:shishughar/custom_widget/custom_radio_btn.dart';
// import 'package:shishughar/custom_widget/custom_text.dart';
//
// import 'package:shishughar/custom_widget/customtextfield.dart';
// import 'package:shishughar/screens/check_ins.dart';
// import 'package:shishughar/screens/linelistedhouseholld.dart';
// import 'package:shishughar/style/styles.dart';
//
// class HouseholdScreen extends StatefulWidget {
//   const HouseholdScreen({super.key});
//
//   @override
//   State<HouseholdScreen> createState() => _HouseholdScreenState();
// }
//
// class _HouseholdScreenState extends State<HouseholdScreen> {
//   String Occupation = 'Farming';
//   String Gendertype = 'Male';
//   String Agree = 'Yes';
//   String? selectedOdour;
//   int tabIndex = 0;
//   TextEditingController Childnamecontroller = TextEditingController();
//   TextEditingController ChildRelationshipcontroller = TextEditingController();
//   TextEditingController Datecontroller = TextEditingController();
//   TextEditingController Landmarkcontroller = TextEditingController();
//   TextEditingController NameOfRespondentcontroller = TextEditingController();
//   TextEditingController AgeRespondentcontroller = TextEditingController();
//   TextEditingController Familymembercontroller = TextEditingController();
//   TextEditingController Hamletcontroller = TextEditingController();
//   TextEditingController controller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppbar(
//         text: CustomText.AddHouseholdListing,
//         onTap: () {
//           Navigator.pop(context);
//         },
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SizedBox(
//               //   height: 10.h,
//               // ),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //   children: [
//               //     Expanded(
//               //       child: TextButton(
//               //           onPressed: () {
//               //             setState(() {
//               //               tabIndex = 0;
//               //             });
//               //           },
//               //           style: TextButton.styleFrom(
//               //               backgroundColor: tabIndex == 0
//               //                   ? Color(0xff2CAFA1)
//               //                   : Colors.white,
//               //               shape: RoundedRectangleBorder(
//               //                   side: BorderSide(
//               //                       color: tabIndex == 0
//               //                           ? Color(0xff2CAFA1)
//               //                           : Color(0xffC6C6C6)),
//               //                   borderRadius: BorderRadius.circular(5))),
//               //           child: Text(CustomText.HHprofile,
//               //               style: tabIndex == 0
//               //                   ? Styles.white125
//               //                   : Styles.black124)),
//               //     ),
//               //     SizedBox(
//               //       width: 5.w,
//               //     ),
//               //     Expanded(
//               //       child: TextButton(
//               //           onPressed: () {
//               //             setState(() {
//               //               tabIndex = 1;
//               //             });
//               //           },
//               //           style: TextButton.styleFrom(
//               //               backgroundColor: tabIndex == 1
//               //                   ? Color(0xff2CAFA1)
//               //                   : Colors.white,
//               //               shape: RoundedRectangleBorder(
//               //                   side: BorderSide(
//               //                       color: tabIndex == 1
//               //                           ? Color(0xff2CAFA1)
//               //                           : Color(0xffC6C6C6)),
//               //                   borderRadius: BorderRadius.circular(5))),
//               //           child: Text(
//               //             CustomText.Childrens,
//               //             style:
//               //                 tabIndex == 1 ? Styles.white125 : Styles.black124,
//               //           )),
//               //     ),
//               //   ],
//               // ),
//               SizedBox(
//                 height: 10.h,
//               ),
//               Text(
//                 // tabIndex == 0
//                 //     ? CustomText.BasicInformation
//                 //     // : CustomText.DetailsChild,
//                 CustomText.BasicInformation,
//                 style: Styles.red145,
//               ),
//               SizedBox(
//                 height: 10.h,
//               ),
//               if (tabIndex == 0) ...[
//                 CustomDropdownField(
//                   titleText: CustomText.District,
//                   items: ["A", "B"],
//                   selectedItem: selectedOdour,
//                   onChanged: (value) {},
//                 ),
//                 CustomDropdownField(
//                   titleText: CustomText.Block,
//                   items: ["A", "B"],
//                   selectedItem: selectedOdour,
//                   onChanged: (value) {},
//                 ),
//                 // CustomTextField(
//                 //   fillColor: Color(0xffEFEFEF),
//                 //   controller: controller,
//                 //   titleText: CustomText.District,
//                 // ),
//                 // CustomTextField(
//                 //   fillColor: Color(0xffEFEFEF),
//                 //   controller: controller,
//                 //   titleText: CustomText.Block,
//                 // ),
//                 CustomDropdownField(
//                   titleText: CustomText.GramPanchayat,
//                   items: ["A", "B"],
//                   selectedItem: selectedOdour,
//                   onChanged: (value) {},
//                 ),
//                 CustomDropdownField(
//                   titleText: CustomText.Village,
//                   items: ["A", "B"],
//                   selectedItem: selectedOdour,
//                   onChanged: (value) {},
//                 ),
//                 CustomTextField(
//                   controller: Hamletcontroller,
//                   titleText: CustomText.HamletPadanearest,
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 CustomTextField(
//                   controller: Landmarkcontroller,
//                   titleText: CustomText.Landmark,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10.h),
//                   child: CustomTextField(
//                     controller: NameOfRespondentcontroller,
//                     titleText: CustomText.NameofRespondent,
//                   ),
//                 ),
//
//                 CustomTextField(
//                   controller: AgeRespondentcontroller,
//                   titleText: CustomText.AgeofRespondent,
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Text(
//                   CustomText.Gender,
//                   style: Styles.black124,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomRadioButton(
//                         value: 'Male',
//                         groupValue: Gendertype,
//                         onChanged: (value) {
//                           setState(() {
//                             Gendertype = value!;
//                           });
//                         },
//                         label: CustomText.Male,
//                       ),
//                     ),
//                     Expanded(
//                       child: CustomRadioButton(
//                         value: 'Female',
//                         groupValue: Gendertype,
//                         onChanged: (value) {
//                           setState(() {
//                             Gendertype = value!;
//                           });
//                         },
//                         label: CustomText.Female,
//                       ),
//                     ),
//                     Expanded(
//                       child: CustomRadioButton(
//                         value: 'Transgender',
//                         groupValue: Gendertype,
//                         onChanged: (value) {
//                           setState(() {
//                             Gendertype = value!;
//                           });
//                         },
//                         label: CustomText.Transgender,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 CustomDropdownField(
//                   titleText: CustomText.SocialCategory,
//                   items: ["A", "B"],
//                   selectedItem: selectedOdour,
//                   onChanged: (value) {},
//                 ),
//
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       CustomText.Pvtg,
//                       style: Styles.black124,
//                     ),
//                     Row(
//                       children: [
//                         CustomRadioButton(
//                           value: 'Yes',
//                           groupValue: Agree,
//                           onChanged: (value) {
//                             setState(() {
//                               Agree = value!;
//                             });
//                           },
//                           label: CustomText.Yes,
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         CustomRadioButton(
//                           value: 'NO',
//                           groupValue: Agree,
//                           onChanged: (value) {
//                             setState(() {
//                               Agree = value!;
//                             });
//                           },
//                           label: CustomText.No,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomDropdownField(
//                         icon: Image.asset(
//                           "assets/arrow.png",
//                           scale: 2.8,
//                         ),
//                         titleText: CustomText.Adultabove18,
//                         items: ["A", "B"],
//                         selectedItem: selectedOdour,
//                         onChanged: (value) {},
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5.w,
//                     ),
//                     Expanded(
//                       child: CustomDropdownField(
//                         icon: Image.asset(
//                           "assets/arrow.png",
//                           scale: 2.8,
//                         ),
//                         titleText: CustomText.Children618,
//                         items: ["A", "B"],
//                         selectedItem: selectedOdour,
//                         onChanged: (value) {},
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomDropdownField(
//                         icon: Image.asset(
//                           "assets/arrow.png",
//                           scale: 2.8,
//                         ),
//                         titleText: CustomText.Children36,
//                         items: ["A", "B"],
//                         selectedItem: selectedOdour,
//                         onChanged: (value) {},
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5.w,
//                     ),
//                     Expanded(
//                       child: CustomDropdownField(
//                         icon: Image.asset(
//                           "assets/arrow.png",
//                           scale: 2.8,
//                         ),
//                         titleText: CustomText.Children3,
//                         items: ["A", "B"],
//                         selectedItem: selectedOdour,
//                         onChanged: (value) {},
//                       ),
//                     ),
//                   ],
//                 ),
//                 CustomDropdownField(
//                   icon: Image.asset(
//                     "assets/arrow.png",
//                     scale: 2.8,
//                   ),
//                   titleText: CustomText.FamilyMember,
//                   items: ["A", "B"],
//                   selectedItem: selectedOdour,
//                   onChanged: (value) {},
//                 ),
//                 Text(
//                   CustomText.PrimaryOccupation,
//                   style: Styles.black124,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomRadioButton(
//                         value: 'Farming',
//                         groupValue: Occupation,
//                         onChanged: (value) {
//                           setState(() {
//                             Occupation = value!;
//                           });
//                         },
//                         label: CustomText.Farming,
//                       ),
//                     ),
//                     Expanded(
//                       child: CustomRadioButton(
//                         value: 'Wage Labour in Agriculture',
//                         groupValue: Occupation,
//                         onChanged: (value) {
//                           setState(() {
//                             Occupation = value!;
//                           });
//                         },
//                         label: CustomText.Agriculture,
//                       ),
//                     ),
//                     Expanded(
//                       child: CustomRadioButton(
//                         value: 'Self Employed',
//                         groupValue: Occupation,
//                         onChanged: (value) {
//                           setState(() {
//                             Occupation = value!;
//                           });
//                         },
//                         label: CustomText.SelfEmployed,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomRadioButton(
//                         value: 'Casual Labour in Non Agriculture',
//                         groupValue: Occupation,
//                         onChanged: (value) {
//                           setState(() {
//                             Occupation = value!;
//                           });
//                         },
//                         label: CustomText.nonAgriculture,
//                       ),
//                     ),
//                     Occupation != 'Other Specified'
//                         ? Expanded(
//                             child: CustomRadioButton(
//                               value: 'Other Specified',
//                               groupValue: Occupation,
//                               onChanged: (value) {
//                                 setState(() {
//                                   Occupation = value!;
//                                 });
//                               },
//                               label: CustomText.OtherSpecified,
//                             ),
//                           )
//                         : Expanded(
//                             child: Row(
//                               children: [
//                                 Text(
//                                   CustomText.OtherSpecified,
//                                   style: Styles.black104,
//                                 ),
//                                 SizedBox(width: 5.0),
//                                 Expanded(
//                                   child: SizedBox(
//                                     height: 30.h,
//                                     child: TextField(
//                                       style: Styles.black104,
//                                       controller: controller,
//                                       decoration: InputDecoration(
//                                         hintStyle: Styles.black104,
//                                         hintText: CustomText.typehere,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                   ],
//                 ),
//               ] else ...[
//                 // Container(
//                 //   padding: EdgeInsets.all(10),
//                 //   decoration: BoxDecoration(
//                 //       border: Border.all(color: Color(0xffC5C5C5)),
//                 //       borderRadius: BorderRadius.circular(5.r)),
//                 //   child: Column(
//                 //     crossAxisAlignment: CrossAxisAlignment.start,
//                 //     children: [
//                 //       CustomTextField(
//                 //         controller: Childnamecontroller,
//                 //         titleText: CustomText.NameofChild,
//                 //       ),
//                 //       Text(
//                 //         CustomText.Gender,
//                 //         style: Styles.black124,
//                 //       ),
//                 //       Row(
//                 //         children: [
//                 //           Expanded(
//                 //             child: CustomRadioButton(
//                 //               value: 'Male',
//                 //               groupValue: Gendertype,
//                 //               onChanged: (value) {
//                 //                 setState(() {
//                 //                   Gendertype = value!;
//                 //                 });
//                 //               },
//                 //               label: CustomText.Male,
//                 //             ),
//                 //           ),
//                 //           Expanded(
//                 //             child: CustomRadioButton(
//                 //               value: 'Female',
//                 //               groupValue: Gendertype,
//                 //               onChanged: (value) {
//                 //                 setState(() {
//                 //                   Gendertype = value!;
//                 //                 });
//                 //               },
//                 //               label: CustomText.Female,
//                 //             ),
//                 //           ),
//                 //           Expanded(
//                 //             child: CustomRadioButton(
//                 //               value: 'Transgender',
//                 //               groupValue: Gendertype,
//                 //               onChanged: (value) {
//                 //                 setState(() {
//                 //                   Gendertype = value!;
//                 //                 });
//                 //               },
//                 //               label: CustomText.Transgender,
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //       CustomDatepicker(
//                 //         controller: Datecontroller,
//                 //         titleText: CustomText.BirthAvailable,
//                 //       ),
//                 //       CustomTextField(
//                 //         controller: ChildRelationshipcontroller,
//                 //         titleText: CustomText.RelationshipChild,
//                 //       ),
//                 //       SizedBox(
//                 //         height: 10.h,
//                 //       ),
//                 //     ],
//                 //   ),
//                 // )
//               ],
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10.h),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: CElevatedButton(
//                         color: Color(0xffF26BA3),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         text: CustomText.back,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: CElevatedButton(
//                         color: Color(0xff5979AA),
//                         onPressed: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (BuildContext context) =>
//                                   LineholdlistedScreen()));
//                         },
//                         text: CustomText.Save,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: CElevatedButton(
//                         color: Color(0xff2CAFA1),
//                         onPressed: () {
//                           // Navigator.of(context).push(MaterialPageRoute(
//                           //     builder: (BuildContext context) =>
//                           //         che()));
//                         },
//                         text: CustomText.Next,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
