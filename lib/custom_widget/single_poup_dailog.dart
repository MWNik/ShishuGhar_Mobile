import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/style/styles.dart';

class SingleButtonPopupDialog extends StatelessWidget {
  final String message;
  final String button;

  SingleButtonPopupDialog({required this.message,required this.button});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
    child:AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
          width: MediaQuery.of(context).size.width * 5.00,
          // height: MediaQuery.of(context).size.height * 0.20,
          child: IntrinsicHeight(
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
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width *  0.05
                    ),
                      child: Text(message, style: Styles.black3125,textAlign: TextAlign.center)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    child: CElevatedButton(
                      text: button,
                      color: Color(0xff369A8D),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  )
                ]),
          )),)
    );
  }
}
