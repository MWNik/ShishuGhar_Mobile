import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/customdatepicker.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/style/styles.dart';

class CustomTextfieldSidebyside extends StatefulWidget {
  final double? width;
  final double? height;
  final String? hintText;
  final String? fieldType;
  final double? initialvalue;
  final String? titleText;
  final String? errorText;
  Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
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
  final FocusNode? focusNode;
  TabFormsLogic? keyboard;

  CustomTextfieldSidebyside(
      {super.key,
      this.fillColor,
      this.width,
      this.height,
      this.hintText,
      this.fieldType,
      this.initialvalue,
      this.titleText,
      this.errorText,
      this.prefixIcon,
      this.suffixIcon,
      this.obscureText,
      this.readable,
      this.onTap,
      this.validator,
      this.maxline,
      this.keyboardtype,
      this.hintStyle,
      this.labelstyle,
      this.maxlength,
      this.isRequred,
      this.isVisible,
      this.onChanged,
      this.focusNode});

  @override
  State<CustomTextfieldSidebyside> createState() =>
      _CustomTextfieldSidebysideState();
}

class _CustomTextfieldSidebysideState extends State<CustomTextfieldSidebyside> {
  TextEditingController? controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialvalue != null) {
      controller?.text = widget.initialvalue.toString();
    } else {
      controller?.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.isVisible ?? true,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1),
          // decoration: BoxDecoration(
          //     border: Border.all(color: Colors.white, width: 1.5),
          //     borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.titleText ?? '',
                maxLines: widget.titleText!.length > 10 ? 2 : 1,
                style: Styles.black105P,
              ),
              SizedBox(
                width: 9.w,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: widget.height ?? 25.h,
                  width: widget.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffACACAC), width: 1),
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    focusNode: widget.focusNode,
                    readOnly: widget.readable ?? false,
                    onTap: widget.onTap,
                    controller: controller,
                    maxLength: widget.maxlength,
                    validator: widget.validator,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        widget.onChanged?.call(double.parse(value) ?? 0);
                      } else {
                        widget.onChanged?.call(null);
                      }
                    },
                    style: Styles.black104,
                    keyboardType: keyBoardType(),
                    inputFormatters: inputFormatter(),
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
              ),
              widget.titleText != null
                  ? SizedBox(
                      width: 8.h,
                    )
                  : SizedBox(
                      width: 4.h,
                    ),
            ],
          ),
        ));
  }

  @override
  void didUpdateWidget(covariant CustomTextfieldSidebyside oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialvalue != widget.initialvalue) {
      controller?.text =
          (widget.initialvalue != null ? widget.initialvalue.toString() : '');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.initialvalue != null) {
      controller?.text = widget.initialvalue.toString();
    } else {
      controller?.text = '';
    }
    setState(() {});
  }

  List<TextInputFormatter>? inputFormatter() {
    if (widget.fieldType == "Float") {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(
            r'^\d{0,2}(?:\.\d{0,3})?')), // Allow only digits and up to 2 decimal places
      ];
    } else if (widget.fieldType == "Int") {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ];
    } else {
      return <TextInputFormatter>[
        // EmojiInputFormatter()
        CustomInputFormatter(RegExp(widget.keyboard != null
            ? keyLogicFormate(widget.keyboard!)
            : (r'^[a-zA-Z0-9\s]+$')))
        // Allow only digits and up to 2 decimal places
      ];
    }
  }

  TextInputType keyBoardType() {
    if (widget.fieldType == "Float") {
      return TextInputType.numberWithOptions(decimal: true);
    } else if (widget.fieldType == "Int") {
      return TextInputType.number;
    } else {
      return TextInputType.emailAddress;
    }
  }

  String keyLogicFormate(TabFormsLogic keyboard) {
    if (keyboard.algorithmExpression == '1') {
      return r'^[0-9]*$';
    } else if (keyboard.algorithmExpression == '2') {
      return r'^[a-zA-Z\s]+$';
    } else if (keyboard.algorithmExpression == '3') {
      return r'^[a-zA-Z\s,]+$';
    } else
      return r'^[a-zA-Z0-9\s]+$';
  }
}

class CustomInputFormatter extends TextInputFormatter {
  RegExp allowedCharacters = RegExp(r'^[a-zA-Z0-9\s]+$');

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
