import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/styles.dart';

class CElevatedButton extends StatefulWidget {
  final text;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final Color? color;
  CElevatedButton(
      {super.key,
      this.text,
      required this.onPressed,
      this.height,
      this.width,
      this.color});

  @override
  State<CElevatedButton> createState() => _CElevatedButtonState();
}

class _CElevatedButtonState extends State<CElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            height: widget.height != null ?  widget.height : 35.h,
            width: widget.width != null ?  widget.width : 275.w,
            child: ElevatedButton(
              onPressed: widget.onPressed,
              child: Text(
                widget.text,
                style: Styles.white127P,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color!=null ? widget.color:Color(0xff369A8D),
                padding: EdgeInsets.all(0),
                // primary: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
