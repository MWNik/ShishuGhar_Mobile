import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:shishughar/style/styles.dart';

// ignore: must_be_immutable
class CustomDatepicker extends StatefulWidget {
  TextEditingController controller;
  final String? hintText;
  final String? titleText;
  final TextStyle? hintStyle;
  final TextStyle? labelstyle;
  final Color? color;
  void Function(String)? onChanged;
  final double? width;

  CustomDatepicker(
      {required this.controller,
      this.hintText,
      this.width,
      this.titleText,
      this.hintStyle,
      this.color,
      this.onChanged,
      this.labelstyle});

  @override
  State<CustomDatepicker> createState() => _CustomDatepickerState();
}

class _CustomDatepickerState extends State<CustomDatepicker> {
  DateTime currentDate = DateTime.now();

  String? SelectDate;

  datePicker(context) async {
    DateTime? userSelectDate = await showDatePicker(
        context: context,
        builder: (context, child) => SingleChildScrollView(
              child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white),
                    ),
                  ),
                  child: child!),
            ),
        initialDate: currentDate,
        firstDate: DateTime(
          currentDate.year - 50,
        ),
        lastDate: DateTime.now());

    if (userSelectDate == null) {
      currentDate = currentDate;
    } else {
      setState(() {
        currentDate = userSelectDate;
        SelectDate =
            '${currentDate.year}-${currentDate.month}-${currentDate.day}';

        DateTime originalDate =
            DateFormat('yyyy-MM-dd').parse(userSelectDate.toString());

        String formattedDateString =
            DateFormat('dd-MM-yyyy').format(originalDate);

        widget.controller.text = formattedDateString ?? "null";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.titleText == null ? "" : '${widget.titleText}',
            style: Styles.black124P,
          ),
          SizedBox(
            height: 3.h,
          ),
          Container(
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: TextFormField(
              style: Styles.black124,
              readOnly: true,
              controller: widget.controller,
              onTap: () {},
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffF4F8FB),
                  ),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffF4F8FB),
                  ),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                isDense: true,
                enabled: true,
                filled: true,
                fillColor: widget.color ?? Color(0xffF4F8FB),
                suffixIcon: InkWell(
                    onTap: () {
                      datePicker(context);
                    },
                    child: Icon(Icons.calendar_month)),
                hintStyle: widget.hintStyle ?? Styles.black124,
                hintText: 'Select Date',
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
