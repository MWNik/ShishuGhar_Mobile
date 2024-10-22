import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../utils/validate.dart';

// ignore: must_be_immutable
class CustomTimepickerDynamic extends StatefulWidget {
  final String? hintText;
  final String? titleText;
  final String? initialvalue;
  final String? fieldName;
  final String? calenderValidate;
  final TextStyle? hintStyle;
  final TextStyle? labelstyle;
  final Color? color;
  void Function(String)? onChanged;
  final double? width;
  final int? isRequred;
  final bool? isVisible;
  final bool? readable;

  CustomTimepickerDynamic(
      {this.hintText,
      this.width,
      this.titleText,
      this.hintStyle,
      this.initialvalue,
      this.calenderValidate,
      this.color,
      this.onChanged,
      this.labelstyle,
      this.isRequred,
      this.fieldName,
      this.isVisible,
      this.readable});

  @override
  State<CustomTimepickerDynamic> createState() => _CustomTimepickerState();
}

class _CustomTimepickerState extends State<CustomTimepickerDynamic> {
  TimeOfDay? currentTime;
  String? _currentTime;
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    if (widget.fieldName == 'open') {
      currentTime = widget.initialvalue != null
          ? Validate().stringToTimeOfDay(widget.initialvalue)
          : TimeOfDay.now();
      _currentTime = TimeOfDay.now().format(context);
      controller = TextEditingController(text: _currentTime);
      widget.onChanged?.call(_currentTime!);
    } else {
      controller = TextEditingController(
          text: widget.initialvalue != null ? widget.initialvalue : null);
    }
    // }
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
            RichText(
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
            ),
            SizedBox(
              height: 3.h,
            ),
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
                    _selectTimePicker(context);
                  }
                },
                onChanged: (value) {
                  // setState(() {
                  //   _currentDate = value;
                  // });
                  widget.onChanged?.call(_currentTime!);
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
                          _selectTimePicker(context);
                        }
                      },
                      child: Icon(
                        Icons.timer,
                        color: Colors.grey,
                      )),
                  hintStyle: widget.hintStyle ?? Styles.black124,
                  hintText: "HH:mm",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  // Future<void> _selectTimePicker(BuildContext context) async {
  //     final pickedTime = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //       builder: (BuildContext context, Widget? child) {
  //         return MediaQuery(
  //           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
  //           child: child!,
  //         );
  //       },
  //     );
  //
  //     if (pickedTime != null) {
  //       setState(() {
  //         currentTime = pickedTime;
  //         controller!.text = "${pickedTime.hour}:${pickedTime.minute}";
  //       });
  //       _currentTime='${currentTime!.hour}:${currentTime!.minute}';
  //       widget.onChanged?.call('${currentTime!.hour}:${currentTime!.minute}');
  //   }
  // }

  Future<void> _selectTimePicker(BuildContext context) async {
    final pickedTime = await showTimePicker(
      // initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        currentTime = pickedTime;
        controller!.text =
            "${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}";
      });
      _currentTime =
          '${currentTime!.hour}:${currentTime!.minute.toString().padLeft(2, '0')}';
      widget.onChanged?.call(
          '${currentTime!.hour}:${currentTime!.minute.toString().padLeft(2, '0')}');
    }
  }

  @override
  void didUpdateWidget(covariant CustomTimepickerDynamic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialvalue != widget.initialvalue) {
      controller?.text =
          (widget.initialvalue != null ? widget.initialvalue! : '');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  DateTime? dateinilizataion(String dateType) {
    DateTime? datetime;
    if (widget.calenderValidate != null) {
      var item = Global.splitData(widget.calenderValidate, ',');
      if (item[0] == dateType) {
        if (item.length == 3) {
          if (item[2].toLowerCase() == 'd') {
            datetime = DateTime.now()
                .subtract(Duration(days: Global.stringToInt(item[1])));
          } else if (item[2].toLowerCase() == 'm') {
            int daysToSubtract = Global.stringToInt(item[1]) * 30;
            datetime = DateTime.now().subtract(Duration(days: daysToSubtract));
          } else if (item[2].toLowerCase() == 'y') {
            int daysToSubtract = Global.stringToInt(item[1]) * 365;
            datetime = DateTime.now().subtract(Duration(days: daysToSubtract));
          } else
            datetime = DateTime(1990);
        } else
          datetime = DateTime(1990);
      } else if (item[0] == dateType) {
        if (item.length == 3) {
          if (item[2].toLowerCase() == 'd') {
            datetime = DateTime.now()
                .subtract(Duration(days: Global.stringToInt(item[1])));
          } else if (item[2].toLowerCase() == 'm') {
            int daysToSubtract = Global.stringToInt(item[1]) * 30;
            datetime = DateTime.now().subtract(Duration(days: daysToSubtract));
          } else if (item[2].toLowerCase() == 'y') {
            int daysToSubtract = Global.stringToInt(item[1]) * 365;
            datetime = DateTime.now().subtract(Duration(days: daysToSubtract));
          } else
            datetime = DateTime.now();
        } else
          datetime = DateTime.now();
      }
    }
    return datetime;
  }
}
