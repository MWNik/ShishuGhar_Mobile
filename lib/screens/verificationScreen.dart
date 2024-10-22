// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pinput/pinput.dart';
// import 'package:shishughar/custom_widget/custom_appbar.dart';
// import 'package:shishughar/custom_widget/custom_btn.dart';
// import 'package:shishughar/custom_widget/custom_text.dart';

// import 'package:shishughar/custom_widget/customtextfield.dart';

// import 'package:shishughar/screens/login_screen.dart';
// import 'package:shishughar/style/styles.dart';

// // ignore: must_be_immutable
// class VerificationScreen extends StatefulWidget {
//   bool indexScreen = true;
//   VerificationScreen({super.key, required this.indexScreen});

//   @override
//   State<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends State<VerificationScreen> {
//   TextEditingController newpasswordController = TextEditingController();
//   TextEditingController confirmpasswordcontroller = TextEditingController();
//   final pinMobileController = TextEditingController();
//   final focusNode = FocusNode();
//   final defaultPinTheme = PinTheme(
//     width: 64.w,
//     height: 60.h,
//     margin: EdgeInsets.symmetric(horizontal: 5),
//     textStyle: const TextStyle(
//       fontSize: 22,
//       color: Color.fromRGBO(30, 60, 87, 1),
//     ),
//     decoration: BoxDecoration(
//       color: Color(0xffF7F8F9),
//       borderRadius: BorderRadius.circular(5),
//       border: Border.all(color: Color(0xffE8ECF4)),
//     ),
//   );
//   final focusedPinTheme = PinTheme(
//     width: 64.w,
//     height: 60.h,
//     margin: EdgeInsets.symmetric(horizontal: 5),
//     textStyle: const TextStyle(
//       fontSize: 22,
//       color: Color.fromRGBO(30, 60, 87, 1),
//     ),
//     decoration: BoxDecoration(
//       color: Color(0xffF7F8F9),
//       borderRadius: BorderRadius.circular(5),
//       border: Border.all(color: Color(0xff35C2C1)),
//     ),
//   );
//   // var focusedBorderColor = Colors.black;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: CustomAppbar(
//         text: "",
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => LoginScreen()),
//           );
//         },
//       ),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Padding(
//             //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//             //   child: Container(
//             //     height: 35.h,
//             //     width: 41.w,
//             //     decoration: BoxDecoration(
//             //         color: Colors.white,
//             //         border: Border.all(color: Color(0xffE8ECF4)),
//             //         borderRadius: BorderRadius.circular(5.r)),
//             //     child: InkWell(
//             //       onTap: () {
//             //         Navigator.pop(context);
//             //       },
//             //       child: Icon(
//             //         Icons.arrow_back_ios_sharp,
//             //         size: 20.sp,
//             //         color: Colors.black,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             Spacer(),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 20.w,
//               ),
//               child: Text(
//                 widget.indexScreen == true
//                     ? CustomText.OTPVerification
//                     : CustomText.Createnewpassword,
//                 style: Styles.blue247,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
//               child: Text(
//                 widget.indexScreen == true
//                     ? CustomText.verificationcode
//                     : CustomText.Newpasswordmustbeunique,
//                 style: Styles.black126P,
//               ),
//             ),
//             SizedBox(
//               height: 10.h,
//             ),

//             widget.indexScreen == true
//                 ? Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                     child: Pinput(
//                       length: 4,
//                       defaultPinTheme: defaultPinTheme,
//                       controller: pinMobileController,
//                       focusNode: focusNode,
//                       focusedPinTheme: focusedPinTheme,
//                       submittedPinTheme: focusedPinTheme,
//                       keyboardType: TextInputType.number,
//                       textInputAction: TextInputAction.next,
//                       showCursor: true,
//                       validator: (s) {
//                         print('validating code: $s');
//                         return null;
//                       },
//                       onCompleted: null,
//                     ),
//                   )
//                 : Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
//                     child: Column(
//                       children: [
//                         CustomTextField(
//                           controller: newpasswordController,
//                           hintText: CustomText.NewPassword,
//                           fillColor: Color(0xffF2F7FF),
//                           maxlength: 8,
//                         ),
//                         CustomTextField(
//                           maxlength: 8,
//                           controller: confirmpasswordcontroller,
//                           hintText: CustomText.confirmPassword,
//                           fillColor: Color(0xffF2F7FF),
//                         ),
//                       ],
//                     ),
//                   ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 20.h),
//               child: CElevatedButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) => LoginScreen()));
//                 },
//                 text: widget.indexScreen == true
//                     ? CustomText.Verify
//                     : CustomText.resetpassword,
//               ),
//             ),
//             Spacer(),
//             widget.indexScreen == true
//                 ? Align(
//                     alignment: Alignment.center,
//                     child: RichText(
//                         overflow: TextOverflow.ellipsis,
//                         text: TextSpan(
//                             text: CustomText.receivedcode,
//                             style: Styles.urbanblack157,
//                             children: [
//                               TextSpan(
//                                   text: CustomText.Resend,
//                                   style: Styles.urbanblue155),
//                             ])),
//                   )
//                 : SizedBox(),
//             SizedBox(
//               height: 50.h,
//             ),
//             Image.asset("assets/bottomloginImage.png"),
//           ],
//         ),
//       ),
//     );
//   }
// }
