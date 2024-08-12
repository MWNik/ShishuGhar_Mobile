import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';

import 'package:shishughar/style/styles.dart';

// ignore: must_be_immutable
class CustomDropdownFieldString extends StatefulWidget {
  final List<String> items;
  final void Function(String?) onChanged;
  String? hintText;
  String? selectedItem;
  String? titleText;
  String? starText;
  final double? width;
  final double? height;
  final Widget? icon;
  final Color? color;
   int? isRequred;

  CustomDropdownFieldString(
      {required this.items,
        required this.onChanged,
        this.hintText,
        this.selectedItem,
        this.height,
        this.width,
        this.icon,
        this.titleText,
        this.color,
        this.starText,
        this.isRequred
      });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownFieldString> {
  @override
  Widget build(BuildContext context) {
    bool isDropdownEnabled = widget.items.length > 1;
    if (widget.items.length == 1 && widget.selectedItem == null) {
      // Automatically select the only item and call onChanged
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        widget.onChanged(widget.items.first);
      });
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: widget.titleText == null ? "" : '${widget.titleText}',
              style: Styles.black124,
              children: (widget.isRequred ==1)
                  ? [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red),
                ),
              ]
                  : [],
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Container(
            height: 35.h,
            // width: widget.width ?? MediaQuery.of(context).size.width,
            width: widget.width,

            decoration: BoxDecoration(
              color: isDropdownEnabled?Colors.white:widget.color ?? Color(0xFFEEEEEE),
              border: Border.all(color: Color(0xffACACAC)),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: DropdownButtonFormField(
                alignment: Alignment.centerLeft,
                borderRadius: BorderRadius.circular(10.r),
                padding: EdgeInsets.zero,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
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
                    contentPadding: EdgeInsets.zero),
                value: widget.selectedItem,
                // value: widget.selectedItem ??
                //     (widget.items.length == 1 ? widget.items.first : null),
                icon: widget.icon ?? Icon(Icons.arrow_drop_down),
                isDense: true,
                onChanged: isDropdownEnabled ? widget.onChanged : null,

                // onChanged: (value) {
                //   setState(() {
                //     widget.selectedItem = value;
                //     // widget.onChanged?.call(value!);
                //     // widget.onChanged?.call(value ?? '');
                //   });
                // },
                items: widget.items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: Styles.black124),
                  );
                }).toList(),
                hint: Text(widget.hintText ?? CustomText.Selecthere,
                    style: Styles.black124),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
