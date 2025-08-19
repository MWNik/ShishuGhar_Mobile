import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../model/apimodel/form_logic_api_model.dart';

// ignore: must_be_immutable
class DynamicCustomTextFieldNew extends StatefulWidget {
  final double? width;
  final double? height;
  final String? hintText;
  final String? initialvalue;
  final String? titleText;
  final String? errorText;
  Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? readable;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  void Function(String)? onChanged;
  final int? maxline;
  final TextInputType? keyboardtype;
  final TextStyle? hintStyle;
  final TextStyle? labelstyle;
  final int? maxlength;
  final int? isRequred;
  bool? isVisible;
  TabFormsLogic? keyboard;
  final FocusNode? focusNode;

  DynamicCustomTextFieldNew({
    this.focusNode,
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
    this.keyboard,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<DynamicCustomTextFieldNew> {
  String? _enteredText;
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialvalue);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible != null ? widget.isVisible! : true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.titleText != null
                ? RichText(
                    text: TextSpan(
                      text:
                          widget.titleText == null ? "" : '${widget.titleText}',
                      style: Styles.black124,
                      children: (widget.isRequred == 1)
                          ? [
                              TextSpan(
                                text: '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ]
                          : [],
                    ),
                  )
                : SizedBox(),
            widget.titleText != null
                ? SizedBox(
                    height: 3.h,
                  )
                : SizedBox(),
            Container(
              alignment: Alignment.center,
              height: (Global.validToInt(widget.maxline) > 1)
                  ? 55.h
                  : (widget.height ?? 35.h),
              width: widget.width,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffACACAC)),
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: TextFormField(
                focusNode: widget.focusNode,
                readOnly: widget.readable ?? false,
                onTap: widget.onTap,
                maxLength: widget.maxlength != null && widget.maxlength! > 0
                    ? widget.maxlength
                    : null,
                controller: controller,
                validator: widget.validator,
                onChanged: (value) {
                  setState(() {
                    _enteredText = value;
                  });
                  widget.onChanged?.call(value);
                },
                keyboardType: widget.keyboard != null
                    ? keyLogic(widget.keyboard!)
                    : widget.keyboardtype,
                inputFormatters: <TextInputFormatter>[
                  CustomInputFormatter(RegExp(widget.keyboard != null
                      ? keyLogicFormate(widget.keyboard!)
                      : (r'^[a-zA-Z0-9\u0400-\u04FF\u0900-\u097F\u4e00-\u9fff\u0B00-\u0B7F\s]+$')))
                ],
                style: Styles.black124,
                decoration: InputDecoration(
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
                  contentPadding: EdgeInsets.all(10),
                  filled: true,
                  counterText: "",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ),
            widget.titleText != null
                ? SizedBox(
                    height: 10.h,
                  )
                : SizedBox(
                    height: 5.h,
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant DynamicCustomTextFieldNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialvalue != widget.initialvalue) {
      controller?.text =
          (widget.initialvalue != null ? widget.initialvalue.toString() : '');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  TextInputType keyLogic(TabFormsLogic keyboard) {
    if (keyboard.algorithmExpression == '1') {
      /////only number like mobile number
      return TextInputType.number;
    } else
      return TextInputType.text;
  }

  String keyLogicFormate(TabFormsLogic keyboard) {
    if (keyboard.algorithmExpression == '1') {
      return r'^[0-9]*$';
    } else if (keyboard.algorithmExpression == '2') {
      return r'^[^\d]*$';
    } else if (keyboard.algorithmExpression == '3') {
      return r'^[^\d]*$';
    } else
      return r'^[a-zA-Z0-9\u0400-\u04FF\u0900-\u097F\u4e00-\u9fff\u0B00-\u0B7F\s]+$';
  }
}

class CustomInputFormatter extends TextInputFormatter {
  RegExp allowedCharacters;

  CustomInputFormatter(this.allowedCharacters);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only return the new value if it matches the allowed characters
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }
    if (allowedCharacters.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue; // Keep the old value if the new one has invalid characters
    }
  }
}
