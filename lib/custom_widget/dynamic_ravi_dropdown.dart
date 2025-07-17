import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/model/databasemodel/mst_cammon_model.dart';

import 'package:shishughar/style/styles.dart';


// ignore: must_be_immutable
class DynamicRaviCustomDropdownField extends StatefulWidget {

  final List<MstCommonOtherModel> items;
  final void Function(MstCommonOtherModel?) onChanged;
  String? hintText;
  String? selectedItem;
  String? titleText;
  String? starText;
  final double? width;
  final double? height;
  final Widget? icon;
  final Color? color;
  final int? isRequred;
  final bool? isVisible;

  DynamicRaviCustomDropdownField(
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
        this.isRequred,
        this.isVisible
      });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<DynamicRaviCustomDropdownField> {

  @override
  Widget build(BuildContext context) {
    bool isDropdownEnabled = widget.items.length > 1;
    return Visibility(
      visible: widget.isVisible != null ? widget.isVisible! : true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
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
              width: widget.width,
              decoration: BoxDecoration(
                color: isDropdownEnabled?Colors.white:widget.color ?? Color(0xFFEEEEEE),
                border: Border.all(color: Color(0xffACACAC)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: DropdownButtonFormField<MstCommonOtherModel>(
                  value: isDropdownEnabled
                      ? (widget.selectedItem != null
                      ? widget.items.firstWhere(
                          (item) => item.name == widget.selectedItem)
                      : null)
                      : widget.items.length>0?widget.items.first:null,
                  onChanged: isDropdownEnabled ? widget.onChanged : null,
                  // enabled: isDropdownEnabled,
                  borderRadius: BorderRadius.circular(10.r),
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
                  // value: widget.selectedItem != null
                  //     ? widget.items.firstWhere(
                  //         (item) => item.name == widget.selectedItem)
                  //     : null,
                  icon: widget.icon ?? Icon(Icons.arrow_drop_down),
                  // onChanged: widget.onChanged,
                  style: Styles.black124,
                  isDense: true,
                  items: widget.items
                      .map((item) => DropdownMenuItem<MstCommonOtherModel>(
                    value: item,
                    child: Text(
                      item.value!,
                      style: Styles.black124,
                    ),
                  ))
                      .toList(),
                  hint: Text(
                    widget.hintText ?? CustomText.Selecthere,
                    style: Styles.black124,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}

