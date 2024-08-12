import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/style/styles.dart';

// ignore: must_be_immutable
class DynamicCustomTextFieldFloat extends StatefulWidget {
  final double? width;
  final double? height;
  final String? hintText;
  final String? fieldName;
  final double? initialvalue;
  final String? titleText;
  final String? errorText;
  Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? readable;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  void Function(double?)? onChanged;
  final int? maxline;
  final TextInputType? keyboardtype;
  final TextStyle? hintStyle;
  final TextStyle? labelstyle;
  final int? maxlength;
  final int? isRequred;
  final bool? isVisible;

  DynamicCustomTextFieldFloat({
    this.errorText,
    this.readable,
    this.initialvalue,
    this.titleText,
    this.validator,
    this.fillColor,
    this.onTap,
    this.height,
    this.width,
    this.suffixIcon,
    this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.hintStyle,
    this.keyboardtype,
    this.labelstyle,
    this.maxline,
    this.maxlength,
    this.isRequred,
    this.isVisible,
    this.fieldName,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<DynamicCustomTextFieldFloat> {
  TextEditingController? controller=TextEditingController();
  // int decimal=5;

  // @override
  // void initState() {
  //   super.initState();
  //   controller =
  //       TextEditingController(text: widget.initialvalue?.toString() ?? '');
  // }

  @override
  void initState() {
    super.initState();
    if (widget.initialvalue!=null) {
      controller?.text = widget.initialvalue.toString();
    } else {
      controller?.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible ?? true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.titleText != null?RichText(
              text: TextSpan(
                text: widget.titleText ?? '',
                style: Styles.black124,
                children: widget.isRequred == 1
                    ? [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ]
                    : [],
              ),
            ):SizedBox(),
            widget.titleText != null?SizedBox(height: 3):SizedBox(),
            Container(
              alignment: Alignment.center,
              height: widget.height ?? 35.h,
              width: widget.width,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffACACAC)),
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                readOnly: widget.readable ?? false,
                onTap: widget.onTap,
                maxLength: widget.maxlength != null && widget.maxlength! > 0
                    ? widget.maxlength
                    : null,
                controller: controller,
                validator: widget.validator,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    widget.onChanged?.call(double.parse(value) ?? 0);
                  } else {
                    widget.onChanged?.call(null);
                  }
                },
                style: Styles.black124,
                keyboardType:TextInputType.numberWithOptions(decimal: true), // Allow decimal numbers
                inputFormatters: (widget.fieldName=='height' || widget.fieldName=='height_on_referral')?<TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,3}(?:\.\d{0,2})?')
                  ), // Allow only digits and up to 2 decimal places
                ]:<TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,2}(?:\.\d{0,3})?')
                  ), // Allow only digits and up to 2 decimal places
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  suffixIcon: widget.suffixIcon,
                  hintText: widget.hintText ?? CustomText.typehere,
                  prefixIcon: widget.prefixIcon,
                  border: InputBorder.none,
                  fillColor: widget.readable != null
                      ? widget.readable!
                          ? Color(0xFFEEEEEE)
                          : Colors.white
                      : Colors.white,
                  errorText: widget.errorText,
                  filled: true,
                  counterText: "",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            widget.titleText != null?SizedBox(height: 10):SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  // @override
  // void didUpdateWidget(covariant DynamicCustomTextFieldFloat oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.initialvalue != widget.initialvalue) {
  //     controller?.text =
  //         (widget.initialvalue != null ? widget.initialvalue.toString() : '');
  //   }
  // }

  @override
  void didUpdateWidget(covariant DynamicCustomTextFieldFloat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialvalue != widget.initialvalue) {
      controller?.text = (widget.initialvalue != null ? widget.initialvalue.toString() : '');

    }
  }


  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.initialvalue!=null) {
      controller?.text = widget.initialvalue.toString();
    } else {
      controller?.text = '';
    }
    setState(() {});
  }
}
