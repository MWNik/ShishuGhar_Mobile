import 'package:flutter/material.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../style/styles.dart';

enum SingingCharacter { Yes, No, value }

class DynamicCustomYesNoCheckboxWithLabel extends StatefulWidget {
  String? label;
  String lng;
  List<Translation> labelControlls;
  int? initialValue;
  int? isRequred;
  bool? isVisible;
  bool? readable;
  final Function(int) onChanged;

  DynamicCustomYesNoCheckboxWithLabel({
    this.label,
    this.initialValue,
    required this.lng,
    required this.onChanged,
    required this.labelControlls,
    this.isRequred,
    this.isVisible,
    this.readable,
  });

  @override
  _CustomCheckboxWithLabelState createState() =>
      _CustomCheckboxWithLabelState();
}

class _CustomCheckboxWithLabelState
    extends State<DynamicCustomYesNoCheckboxWithLabel> {
  late int? _value;
  SingingCharacter? _character;
  // SingingCharacter _initialvalue = SingingCharacter.Yes;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _character = _value == 1
        ? SingingCharacter.Yes
        : (_value == 0 ? SingingCharacter.No : null);
  }


  void _updateValue(SingingCharacter? newValue) {
    setState(() {
      _character = newValue;
      _value = (newValue == SingingCharacter.Yes) ? 1 : 0;
      widget.onChanged(_value!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible != null ? widget.isVisible! : true,
      child: Container(
        // height: 55.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
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
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(Global.returnTrLable(
                        widget.labelControlls, CustomText.Yes, widget.lng), style: Styles.black124,),
                    horizontalTitleGap: 0,
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.Yes,
                      groupValue: _character,
                      onChanged: (widget.readable == true)
                          ? null
                          : (newValue) {
                              _updateValue(newValue);
                            },
                      activeColor: Colors.blue,
                    ),
                  ),
                ),
                // SizedBox(width: 3),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(Global.returnTrLable(
                        widget.labelControlls, CustomText.No, widget.lng),style: Styles.black124),
                    horizontalTitleGap: 0,
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.No,
                      groupValue: _character,
                      onChanged: (widget.readable == true)
                          ? null
                          : (newValue) {
                              _updateValue(newValue);
                            },
                      activeColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(
      covariant DynamicCustomYesNoCheckboxWithLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue != null ? widget.initialValue : null;
      _character = _value == 1
          ? SingingCharacter.Yes
          : (_value == 0 ? SingingCharacter.No : null);
    }
  }


  @override
  void dispose() {
    _value = null;
    super.dispose();
  }
}
