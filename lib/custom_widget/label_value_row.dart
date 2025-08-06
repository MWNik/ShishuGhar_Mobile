import 'package:flutter/material.dart';

import '../style/styles.dart';

class LabelValueRow extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10,vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Styles.red145,
            strutStyle:
            StrutStyle(height: 1.2),
          ),
          Text(
            ' : ',
             style: Styles.black104,
              strutStyle:
              StrutStyle(height: 1.2),
          ),
          // const SizedBox(height: 2),
          Text(
              value,
              style: Styles.black15500,
              overflow:
              TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
