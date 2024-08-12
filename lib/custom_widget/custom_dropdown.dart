import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';

import 'package:shishughar/style/styles.dart';

// ignore: must_be_immutable
class CustomDropdownField extends StatefulWidget {
  final List<dynamic> items;
  final void Function(String?) onChanged;
  String? hintText;
  String? selectedItem;
  String? titleText;
  String? starText;
  final double? width;
  final double? height;
  final Widget? icon;
  final Color? color;

  CustomDropdownField(
      {required this.items,
      required this.onChanged,
      this.hintText,
      this.selectedItem,
      this.height,
      this.width,
      this.icon,
      this.titleText,
      this.color,
      this.starText});

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.titleText ?? '',
            style: Styles.black124,
          ),
          SizedBox(
            height: 3.h,
          ),
          Container(
            height: 35.h,
            // width: widget.width ?? MediaQuery.of(context).size.width,
            width: widget.width,

            decoration: BoxDecoration(
              color: widget.color ?? Colors.white,
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
                icon: widget.icon ?? Icon(Icons.arrow_drop_down),
                isDense: true,
                onChanged: widget.onChanged,

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
