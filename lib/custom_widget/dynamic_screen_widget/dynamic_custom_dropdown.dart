import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';

import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../model/dynamic_screen_model/options_model.dart';

// ignore: must_be_immutable
class DynamicCustomDropdownField extends StatefulWidget {

  final List<OptionsModel> items;
  final void Function(OptionsModel?) onChanged;
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
  final bool? readable;
  final FocusNode? focusNode;
  

  DynamicCustomDropdownField(
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
      this.isVisible,
      this.readable,
      this.focusNode
      });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<DynamicCustomDropdownField> {

  @override
  Widget build(BuildContext context) {
    bool isDropdownEnabled = widget.items.length > 1;
    if(widget.readable==true){
      isDropdownEnabled=false;
    }
    return Visibility(
      visible: widget.isVisible != null ? widget.isVisible! : true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.titleText != null?RichText(
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
            ):SizedBox(),
            widget.titleText != null?SizedBox(
              height: 3.h,
            ):SizedBox(),
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
                child: DropdownButtonFormField<OptionsModel>(
                  isExpanded: true,
                  focusNode: widget.focusNode,
                  value: isDropdownEnabled
                      ? (widget.selectedItem != null
                      // ? widget.items.firstWhere((item) => item.name == widget.selectedItem)
                      ? (widget.items.where((element) => element.name == widget.selectedItem).length>0)?
                        widget.items.firstWhere((item) => item.name == widget.selectedItem):null
                      : null)
                      : (widget.selectedItem != null && widget.items.any((element) => element.name == widget.selectedItem)
                      ? widget.items.firstWhere((item) => item.name == widget.selectedItem)
                      : (widget.items.isNotEmpty ? widget.items.first : null)),
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
                      .map((item) => DropdownMenuItem<OptionsModel>(
                    value: item,
                    child: Text(
                      item.values!,
                      strutStyle:
                      StrutStyle(height: 1.2),
                      overflow: TextOverflow.ellipsis,
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
            widget.titleText != null?SizedBox(
              height: 10.h,
            ):SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }

}

