import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';

import '../style/styles.dart';
import 'custom_btn.dart';

class DoubleButtonDailog extends StatelessWidget {
  final String message;
  final String posButton;
  final String negButton;

  DoubleButtonDailog(
      {required this.message,
      required this.posButton,
      required this.negButton});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 5.00,
        // height: MediaQuery.of(context).size.height * 0.2,
        child:
        IntrinsicHeight(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 40.h,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xff5979AA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    ),
                  ),
                  child: Center(
                      child:
                      Text(CustomText.SHISHUGHAR, style: Styles.white126P)),
                ),
                Center(child: Text(message, style: Styles.black3125,textAlign: TextAlign.center)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: CElevatedButton(
                          text: negButton,
                          color: Color(0xffDB4B73),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CElevatedButton(
                          text: posButton,
                          color: Color(0xff369A8D),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      )
                    ],
                  ),
                )
              ]),
        )),
    );
  }
}
