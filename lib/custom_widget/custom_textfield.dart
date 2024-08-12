import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/style/styles.dart';

// ignore: must_be_immutable
class CustomTextFieldRow extends StatefulWidget {
  final TextEditingController controller;
  final double? width;
  final double? height;
  final String? hintText;
  final String? asteriskSign;
  final String? titleText;
  final String? errorText;
  Color? fillColor;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? enabled;
  final String? Function(String?)? validator;
  void Function(String)? onChanged;
  void Function()? onTap;
  final int? maxline;
  final TextInputType? keyboardtype;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final TextStyle? labelstyle;
  final int? maxlength;

  CustomTextFieldRow(
      {this.errorText,
      this.titleText,
      this.validator,
      this.fillColor,
      this.enabled = true,
      this.asteriskSign,
      this.height,
      this.width,
      this.suffixIcon,
      this.onChanged,
      this.onTap,
      required this.controller,
      this.hintText,
      this.prefixIcon,
      this.obscureText = false,
      this.hintStyle,
      this.keyboardtype,
      this.labelstyle,
      this.focusNode,
      this.maxlength,
      this.maxline});

  @override
  State<CustomTextFieldRow> createState() => _CustomTextFieldRowState();
}

class _CustomTextFieldRowState extends State<CustomTextFieldRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      // padding: EdgeInsets.only(left: 5),
      height: widget.height ?? 35.h,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffB8D6BF)),
          color: Color(0xffF2F7FF),
          borderRadius: BorderRadius.circular(5.r)),
      child: SizedBox(
        child: TextFormField(
          maxLength: widget.maxlength,
          enabled: widget.enabled ?? true,
          controller: widget.controller,
          textAlign: TextAlign.start,
          obscureText: widget.obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          maxLines: widget.maxline ?? 1,
          keyboardType: widget.keyboardtype,
          style: Styles.black124P,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffF4F8FB),
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffF4F8FB),
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffF4F8FB),
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              isDense: true,
              suffixIcon: widget.suffixIcon,
              hintText: widget.hintText,
              hintStyle: Styles.black124P,
              prefixIcon: widget.prefixIcon,
              border: InputBorder.none,
              fillColor: widget.enabled == true
                  ? widget.fillColor ?? Color(0xffF4F8FB)
                  : Colors.grey.shade200,
              errorText: widget.errorText,
              filled: true,
              counterText: ""),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextFieldRowButton extends StatefulWidget {
  final TextEditingController controller;
  final double? width;
  final double? height;
  final String? hintText;
  final String? asteriskSign;
  final String? titleText;
  final String? errorText;
  Color? fillColor;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? enabled;
  final String? Function(String?)? validator;
  void Function(String)? onChanged;
  void Function()? onTap;
  final int? maxline;
  final TextInputType? keyboardtype;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final TextStyle? labelstyle;
  final int? maxlength;

  CustomTextFieldRowButton(
      {this.errorText,
      this.titleText,
      this.validator,
      this.fillColor,
      this.enabled = true,
      this.asteriskSign,
      this.height,
      this.width,
      this.suffixIcon,
      this.onChanged,
      this.onTap,
      required this.controller,
      this.hintText,
      this.prefixIcon,
      this.obscureText = false,
      this.hintStyle,
      this.keyboardtype,
      this.labelstyle,
      this.focusNode,
      this.maxlength,
      this.maxline});

  @override
  State<CustomTextFieldRowButton> createState() =>
      _CustomTextFieldRowButtonState();
}

class _CustomTextFieldRowButtonState extends State<CustomTextFieldRowButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: widget.width ?? 90.w,
        alignment: Alignment.center,
        height: widget.height ?? 36.h,
        decoration: BoxDecoration(
            color: Color(0xffF4F8FB),
            borderRadius: BorderRadius.circular(10.r)),
        child: TextFormField(
          maxLength: widget.maxlength ?? 3,
          enabled: widget.enabled ?? true,
          controller: widget.controller,
          textAlign: TextAlign.start,
          obscureText: widget.obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          maxLines: widget.maxline ?? 1,
          keyboardType: widget.keyboardtype,
          style: Styles.black124P,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffACACAC),
              ),
              borderRadius: BorderRadius.circular(5.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffACACAC),
              ),
              borderRadius: BorderRadius.circular(5.r),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffACACAC),
              ),
              borderRadius: BorderRadius.circular(5.r),
            ),
            isDense: true,
            suffixIcon: widget.suffixIcon,
            hintText: widget.hintText,
            hintStyle: Styles.black124P,
            prefixIcon: widget.prefixIcon,
            border: InputBorder.none,
            fillColor: widget.enabled == true
                ? widget.fillColor ?? Colors.white
                : Colors.grey.shade200,
            errorText: widget.errorText,
            counterText: "",
            filled: true,
          ),
        ),
      ),
    );
  }
}
