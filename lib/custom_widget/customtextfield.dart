import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/style/styles.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final double? width;
  final double? height;
  final String? hintText;
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
  final bool enabled;
  final bool isInvalid;
  final FocusNode? focusNode;

  CustomTextField({
    this.errorText,
    this.readable,
    this.titleText,
    this.validator,
    this.fillColor,
    this.onTap,
    this.height,
    this.width,
    this.suffixIcon,
    this.onChanged,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.hintStyle,
    this.keyboardtype,
    this.labelstyle,
    this.maxline,
    this.maxlength,
    this.enabled = true,
    this.isInvalid = false,
    this.focusNode
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.titleText ?? "",
            style: Styles.black124,
          ),
          SizedBox(
            height: 3.h,
          ),
          Container(
            
            padding: EdgeInsets.only(left: 10.w),
            height: widget.height ?? 35.h,
            width: widget.width,
            decoration: BoxDecoration(
                border: Border.all(
                    color: widget.isInvalid ? Colors.red : Color(0xffACACAC)),
                color: Color(0xffF2F7FF),
                borderRadius: BorderRadius.circular(10.r)),
            child: SizedBox(
              height: 35.h,
              width: widget.width,
              child: TextFormField(
                focusNode: widget.focusNode != null?widget.focusNode:null,
                enabled: widget.enabled,
                readOnly: widget.readable ?? false,
                onTap: widget.onTap,
                maxLength: widget.maxlength,
                controller: widget.controller,
                validator: widget.validator,
                onChanged: widget.onChanged,
                keyboardType: widget.keyboardtype,
                style: Styles.black124,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: widget.suffixIcon,
                  hintText: widget.hintText ?? CustomText.typehere,
                  prefixIcon: widget.prefixIcon,
                  border: InputBorder.none,
                  fillColor: widget.fillColor ?? Colors.white,
                  errorText: widget.errorText,
                  filled: true,
                  counterText: "",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffF4F8FB),
                      ),
                      borderRadius: BorderRadius.circular(10.r)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffF4F8FB),
                      ),
                      borderRadius: BorderRadius.circular(10.r)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffF4F8FB),
                      ),
                      borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}