// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/style/styles.dart';

class CustomChildAppbar extends StatelessWidget implements PreferredSizeWidget {
  String text;
  String subTitle1;
  String subTitle2;
  final List<Widget>? actions;
  void Function()? onTap;

  CustomChildAppbar({super.key, required this.text, this.actions,
    this.onTap,
    required this.subTitle1,
    required this.subTitle2
  });
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
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: Styles.white145,
                ),
                RichText(
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: Text(
                        '${subTitle1} ',
                        style: Styles.white126P,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    WidgetSpan(
                      child: Text(
                        '-${subTitle2}',
                        style: Styles.white126P,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ]),
                )
              ],

          ),
          actions: actions),
    );
  }
}
