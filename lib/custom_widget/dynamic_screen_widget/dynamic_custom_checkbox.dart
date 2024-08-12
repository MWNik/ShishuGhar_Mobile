import 'package:flutter/material.dart';

import '../../style/styles.dart';

class DynamicCustomCheckboxWithLabel extends StatefulWidget {
   String? label;
   int? initialValue;
   int? isRequred;
   bool? isVisible;
   bool? readable;
  final Function(int) onChanged;

   DynamicCustomCheckboxWithLabel({
     this.label,
     this.initialValue,
     required this.onChanged,
     this.isRequred,
     this.isVisible,
     this.readable,
  });

  @override
  _CustomCheckboxWithLabelState createState() =>
      _CustomCheckboxWithLabelState();
}

class _CustomCheckboxWithLabelState extends State<DynamicCustomCheckboxWithLabel> {
  late int? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return
      Visibility(
        visible: widget.isVisible != null ? widget.isVisible! : true,
        child: Row(
        children: [
           Checkbox(
        value: _value == 1, // If _value is 1, checkbox is checked; otherwise, it's unchecked
        onChanged: (widget.readable==true)?null:(newValue)
        {
          setState(() {
            _value = newValue! ? 1 : 0; // Update _value based on the new checkbox state
            widget.onChanged(_value!); // Call the onChanged callback with the new value
          });
        },
    ),
           Expanded(
            child: RichText(
              text: TextSpan(
                text: widget.label == null ? "" : '${widget.label}',
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
          ),
        ],
    ),
      );
  }
  @override
  void didUpdateWidget(covariant DynamicCustomCheckboxWithLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value=widget.initialValue!=null?widget.initialValue:null;
    }
  }

  @override
  void dispose() {
    _value=null;
    super.dispose();
  }
}
