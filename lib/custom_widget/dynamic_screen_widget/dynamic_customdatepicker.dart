import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../model/apimodel/form_logic_api_model.dart';
import '../../utils/validate.dart';

// ignore: must_be_immutable
class CustomDatepickerDynamic extends StatefulWidget {
  final String? hintText;
  final String? titleText;
  final String? initialvalue;
  final String? fieldName;
  List<String> calenderValidate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final TextStyle? hintStyle;
  final TextStyle? labelstyle;
  final Color? color;
  void Function(String)? onChanged;
  final double? width;
  final int? isRequred;
  final bool? isVisible;
  final bool? readable;

  CustomDatepickerDynamic(
      {this.hintText,
        this.width,
        this.titleText,
        this.hintStyle,
        this.initialvalue,
        required this.calenderValidate,
        this.minDate,
        this.maxDate,
        this.color,
        this.onChanged,
        this.labelstyle,
        this.isRequred,
        this.fieldName,
        this.isVisible,
        this.readable});

  @override
  State<CustomDatepickerDynamic> createState() => _CustomDatepickerState();
}

class _CustomDatepickerState extends State<CustomDatepickerDynamic> {
  DateTime? currentDate;
  String? _currentDate;
  TextEditingController? controller;

  // @override
  // void initState() {
  //   super.initState();
  //   // if(widget.isVisible ==null||!(widget.isVisible!)) {
  //   if (widget.fieldName == 'date_of_visit' ||widget.fieldName == 'date_of_attendance' ||
  //       widget.fieldName == 'date_of_enrollment'|| widget.fieldName == 'measurement_date') {
  //     currentDate = widget.initialvalue != null
  //         ? DateFormat('yyyy-MM-dd').parse(widget.initialvalue!)
  //         : DateTime.now();
  //     _currentDate = DateFormat('yyyy-MM-dd').format(currentDate!);
  //     controller = TextEditingController(
  //         text: Validate().displeDateFormate(_currentDate!));
  //     if(widget.initialvalue == null){
  //       widget.onChanged?.call(_currentDate!);
  //     }
  //   } else {
  //     controller = TextEditingController(
  //         text: widget.initialvalue != null
  //             ? Validate().displeDateFormate(widget.initialvalue!)
  //             : null);
  //   }
  //   // }
  // }

  @override
  void initState() {
    super.initState();
    print('caenders ${widget.calenderValidate}');
    if (widget.fieldName == 'date_of_visit' || widget.fieldName == 'date_of_attendance' ||
        widget.fieldName == 'date_of_enrollment'||
        widget.fieldName == 'date_of_exit'|| widget.fieldName == 'date'||
        widget.fieldName == 'grievance_date' || widget.fieldName == 'meeting_date') {
      currentDate = widget.initialvalue != null
          ? DateFormat('yyyy-MM-dd').parse(widget.initialvalue!)
          : DateTime.now();
      _currentDate = DateFormat('yyyy-MM-dd').format(currentDate!);
      controller = TextEditingController(
          text: Validate().displeDateFormate(_currentDate!));
      // if(widget.initialvalue == null && widget.fieldName != 'date_of_enrollment'){
      //   widget.onChanged?.call(_currentDate!);
      // }
    } else {
      // if(widget.initialvalue!=null){
      //   currentDate = DateFormat('yyyy-MM-dd').parse(widget.initialvalue!);
      // }
      controller = TextEditingController(
          text: widget.initialvalue != null
              ? Validate().displeDateFormate(widget.initialvalue!)
              : null);
    }
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
            widget.titleText != null?RichText(
              text: TextSpan(
                text: widget.titleText == null ? "" : '${widget.titleText}',
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
            ):SizedBox(),
            widget.titleText != null?SizedBox(
              height: 3.h,
            ):SizedBox(),
            Container(
              height: 35.h,
              width: widget.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffACACAC)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextFormField(
                style: Styles.black124,
                readOnly: true,
                controller: controller,
                onTap: () {
                  if (!(widget.readable == true)) {
                    _selectDate(context,widget.minDate,widget.maxDate);
                  }
                },
                onChanged: (value) {
                  // setState(() {
                  //   _currentDate = value;
                  // });
                  widget.onChanged?.call(_currentDate!);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10.w),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  filled: true,
                  fillColor: widget.readable != null
                      ? widget.readable!
                      ? Color(0xFFEEEEEE)
                      : Colors.white
                      : Colors.white,
                  suffixIcon: InkWell(
                      onTap: () {
                        if (!(widget.readable == true)) {
                          _selectDate(context,widget.minDate,widget.maxDate);
                        }
                      },
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.grey,
                      )),
                  hintStyle: widget.hintStyle ?? Styles.black124,
                  hintText: "dd-MMM-yyyy",
                ),
              ),
            ),
            widget.titleText != null?SizedBox(
              height: 10,
            ):SizedBox(height: 5)
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime? minDate,DateTime? maxDate) async {
    DateTime? pickedDate;
    if (minDate != null && currentDate != null && currentDate!.isBefore(minDate)) {
      pickedDate = minDate;
    } else {
      pickedDate = currentDate;
    }
    DateTime initialDate = pickedDate ?? DateTime.now();
    DateTime firstDate = minDate != null
        ? minDate.add(Duration(days: 1))
        : dateinilizataion('<')?.add(Duration(days: 1)) ?? DateTime(1990);
    DateTime lastDate = maxDate != null
        ? maxDate.subtract(Duration(days: 1))
        : dateinilizataion('>')?.subtract(Duration(days: 1)) ?? DateTime.now();

    // Ensure the initialDate is within the valid range
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    } else if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate:lastDate);
 // initialDate: pickedDate ?? DateTime.now(),
 //        firstDate: minDate != null?minDate.add(Duration(days: 1)):dateinilizataion('<')!=null ?dateinilizataion('<')!.add(Duration(days: 1)):DateTime(1990),
 //        lastDate:maxDate != null?maxDate.subtract(Duration(days: 1)):dateinilizataion('>')!=null?dateinilizataion('>')!.subtract(Duration(days: 1)): DateTime.now());

    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        _currentDate = DateFormat('yyyy-MM-dd').format(pickedDate!);
        controller!.text = Validate().displeDateFormate(_currentDate!);
      });
      widget.onChanged?.call(_currentDate!);
    }
  }

  @override
  void didUpdateWidget(covariant CustomDatepickerDynamic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialvalue != widget.initialvalue) {
      controller?.text = (widget.initialvalue != null
          ? Validate().displeDateFormate(widget.initialvalue.toString())
          : '');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  DateTime? dateinilizataion(String dateType){
    DateTime? datetime;
    if(widget.calenderValidate.length==2) {
      if (widget.calenderValidate[0] == dateType) {
        var date = widget.calenderValidate[1];
        datetime = DateFormat('yyyy-MM-dd').parse(date);
      }else datetime=null;
    }else  datetime=null ;
    return datetime;
  }

}
