import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';

import '../style/styles.dart';
import 'custom_btn.dart';

class CustomDoubleButton extends StatelessWidget {
  final String message;
  final String posButton;
  final String negButton;
  final void Function() onPositive;
  void Function()? onNegative;
  

  CustomDoubleButton(
      {required this.message,
      required this.posButton,
      required this.negButton,
      required this.onPositive,
      this.onNegative});

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
                        child: Text(CustomText.SHISHUGHAR,
                            style: Styles.white126P)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Center(
                        child: Text(message,
                            style: Styles.black3125,
                            textAlign: TextAlign.center)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: CElevatedButton(
                              text: negButton,
                              color: Color(0xff369A8D),
                              onPressed: onNegative != null
                                  ? onNegative
                                  : () => Navigator.of(context).pop()),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CElevatedButton(
                              text: posButton,
                              color: Color(0xffDB4B73),
                              onPressed: onPositive),
                        )
                      ],
                    ),
                  )
                ]),
          )),
    );
  }
}
