import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'dart:async';
import 'package:shishughar/screens/login_screen.dart';
import 'package:shishughar/style/styles.dart';
import '../utils/validate.dart';
import 'dashboardscreen_new.dart';

class SplashScreen extends StatefulWidget {
   SplashScreen({super.key,this.payload});
  String? payload;

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();


    // var network = await Validate().checkNetworkConnection();
    // if (network) {
      Timer(
        const Duration(seconds: 3),
            () =>callScreenCondition(context)

      );
    // } else {
    //   Validate().singleButtonPopup(
    //       CustomText.nointernetconnectionavailable, false, context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return
        // Upgrade Alert(
        // upgrader: Upgrader(
        //   canDismissDialog: false,
        //   shouldPopScope: () => false,
        //   showIgnore: false,
        //   showLater: false,
        // ),
        // child:
        Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 181.h,
                width: 280.w,
                child: Image.asset("assets/loginlogo.png")),
            Text(
              CustomText.SHISHUGHAR,
              style: Styles.blue207P,
            ),
            Divider(
              thickness: 1.5,
              indent: 70.w,
              endIndent: 70.w,
              color: Color(0xffDFDFDF),
            ),
            Text(
              CustomText.hindiSHISHUGHAR,
              style: Styles.blue207P,
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
      // ),
    );
  }

  callScreenCondition(BuildContext context) async {
    var village = await Validate().readString(Validate.village);
    var panchayatId = await Validate().readInt(Validate.panchayatId);
    var userName = await Validate().readString(Validate.userName);
    var userRole = await Validate().readString(Validate.role);
    var password = await Validate().readString(Validate.Password);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
            panchayatId != null
                ? DashboardScreen(
              index: 0,payload:widget.payload
            ) // Redirect to LocationScreen if username is not null
                : (userName != null && password != null)
                ?  DashboardScreen(index: 0,payload:widget.payload)
                : LoginScreen()));

  }
}
