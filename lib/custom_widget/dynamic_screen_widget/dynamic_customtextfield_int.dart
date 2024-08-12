import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/style/styles.dart';


// ignore: must_be_immutable
// class DynamicCustomTextFieldInt extends StatefulWidget {
//
//   final double? width;
//   final double? height;
//   final String? hintText;
//   final int? initialvalue;
//   final String? titleText;
//   final String? errorText;
//   Color? fillColor;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final bool obscureText;
//   final bool? readable;
//   final void Function()? onTap;
//   final String? Function(String?)? validator;
//   void Function(int?)? onChanged;
//   final int? maxline;
//   final TextInputType? keyboardtype;
//   final TextStyle? hintStyle;
//   final TextStyle? labelstyle;
//   final int? maxlength;
//   final int? isRequred;
//   final bool? isVisible;
//
//   DynamicCustomTextFieldInt({
//     this.errorText,
//     this.readable,
//     this.initialvalue,
//     this.titleText,
//     this.validator,
//     this.fillColor,
//     this.onTap,
//     this.height,
//     this.width,
//     this.suffixIcon,
//     this.onChanged,
//     this.hintText,
//     this.prefixIcon,
//     this.obscureText = false,
//     this.hintStyle,
//     this.keyboardtype,
//     this.labelstyle,
//     this.maxline,
//     this.maxlength,
//     this.isRequred,
//     this.isVisible,
//   });
//
//   @override
//   _CustomTextFieldState createState() => _CustomTextFieldState();
// }
//
// class _CustomTextFieldState extends State<DynamicCustomTextFieldInt> {
//   TextEditingController? controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = TextEditingController(text: widget.initialvalue?.toString() ?? '');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: widget.isVisible ?? true,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 2),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             widget.titleText != null?RichText(
//               text: TextSpan(
//                 text: widget.titleText ?? '',
//                 style: Styles.black124,
//                 children: widget.isRequred == 1
//                     ? [
//                   TextSpan(
//                     text: '*',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ]
//                     : [],
//               ),
//             ):SizedBox(),
//             widget.titleText != null?SizedBox(height: 3):SizedBox(),
//             Container(
//               alignment: Alignment.center,
//               height: widget.height ?? 35.h,
//               width: widget.width,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Color(0xffACACAC)),
//                 color: Color(0xFFEEEEEE),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: TextFormField(
//                 readOnly: widget.readable ?? false,
//                 // focusNode:widget.focusNode,
//                 onTap: widget.onTap,
//                 maxLength: widget.maxlength != null && widget.maxlength! > 0
//                     ? widget.maxlength
//                     : null,
//                 controller: controller,
//                 validator: widget.validator,
//                 onChanged: (value) {
//                   if (value.isNotEmpty) {
//                     widget.onChanged?.call(int.tryParse(value) ?? 0,
//                         // widget.focusNode?.hasFocus
//                     );
//                   } else {
//                     widget.onChanged?.call(null,
//                         // widget.focusNode?.hasFocus
//                     );
//                   }
//                 },
//                 style: Styles.black124,
//                 keyboardType: TextInputType.number, // Allow decimal numbers
//                 inputFormatters: <TextInputFormatter>[
//                   FilteringTextInputFormatter.digitsOnly, // Allow only digits and up to 2 decimal places
//                 ],
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.all(10),
//                   suffixIcon: widget.suffixIcon,
//                   hintText: widget.hintText ?? CustomText.typehere,
//                   prefixIcon: widget.prefixIcon,
//                   border: InputBorder.none,
//                    fillColor: widget.readable!=null?widget.readable!?Color(0xFFEEEEEE): Colors.white:Colors.white,
//                   errorText: widget.errorText,
//                   filled: true,
//                   counterText: "",
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//             widget.titleText != null?SizedBox(height: 10):SizedBox(height: 5),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void didUpdateWidget(covariant DynamicCustomTextFieldInt oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.initialvalue != widget.initialvalue) {
//       controller?.text = (widget.initialvalue != null ? widget.initialvalue.toString() : '');
//     }
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }

class DynamicCustomTextFieldInt extends StatefulWidget {
  final double? width;
  final double? height;
  final String? hintText;
  final int? initialvalue;
  final String? titleText;
  final String? errorText;
  Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? readable;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  void Function(int?)? onChanged;
  final int? maxline;
  final TextInputType? keyboardtype;
  final TextStyle? hintStyle;
  final TextStyle? labelstyle;
  final int? maxlength;
  final int? isRequred;
  final bool? isVisible;
  // final bool? autoFocus;

  DynamicCustomTextFieldInt({
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
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<DynamicCustomTextFieldInt> {
  TextEditingController? controller=TextEditingController();
  // FocusNode focusNode = FocusNode();

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
  void didUpdateWidget(covariant DynamicCustomTextFieldInt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialvalue != widget.initialvalue) {
      controller?.text = (widget.initialvalue != null ? widget.initialvalue.toString() : '');

    }
  }

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   focusNode.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // controller?.text=widget.initialvalue!=null?widget.initialvalue.toString():'';
    print("field+value ${widget.titleText} ${widget.initialvalue}");
    return Visibility(
      visible: widget.isVisible ?? true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.titleText != null
                ? RichText(
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
            )
                : SizedBox(),
            widget.titleText != null ? SizedBox(height: 3) : SizedBox(),
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
                // focusNode: focusNode,
                readOnly: widget.readable ?? false,
                onTap: widget.onTap,
                maxLength: widget.maxlength != null && widget.maxlength! > 0
                    ? widget.maxlength
                    : null,
                // controller: TextEditingController(text: widget.initialvalue!=null?widget.initialvalue.toString():''),
                controller:controller,
                validator: widget.validator,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    widget.onChanged?.call(int.tryParse(value) ?? 0);
                  } else {
                    widget.onChanged?.call(null);
                  }
                },
                style: Styles.black124,
                keyboardType: widget.keyboardtype ?? TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  suffixIcon: widget.suffixIcon,
                  hintText: widget.hintText ?? 'Type here',
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
            widget.titleText != null ? SizedBox(height: 10) : SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

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





