// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/style/styles.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  String text;
  String? subTitle;
  final List<Widget>? actions;
  void Function()? onTap;

  CustomAppbar(
      {super.key, required this.text, this.actions, this.onTap, this.subTitle});
  @override
  Size get preferredSize => Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xff5979AA),
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.arrow_back_ios_sharp,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
          centerTitle: true,
          title: subTitle != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text,
                      style: Styles.white145,
                    ),
                    Text(
                      subTitle!,
                      style: Styles.white145,
                    ),
                  ],
                )
              : Text(
                  text,
                  style: Styles.white145,
                ),
          actions: actions),
    );
  }
}
