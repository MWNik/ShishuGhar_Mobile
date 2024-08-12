import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/style/styles.dart';

class CustomRadioButton extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String?>? onChanged;
  final String label;

  CustomRadioButton({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: Color(0xff5979AA),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          label,
          style: Styles.black104,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 4,
        ),
      ],
    );
  }
}
