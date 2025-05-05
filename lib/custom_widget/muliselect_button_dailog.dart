import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/model/apimodel/mater_data_other_model.dart';

import '../model/dynamic_screen_model/options_model.dart';
import '../style/styles.dart';
import '../utils/globle_method.dart';
import 'custom_btn.dart';

class MultiSelectButtonDialog extends StatefulWidget {
  final List<OptionsModel> items;
  final List<OptionsModel> selectedItem;
   String? title;
   String? selectAll;
  final String posButton;
  final String negButton;

   MultiSelectButtonDialog({
    required this.items,
     this.selectAll,
     this.title,
    required this.selectedItem,
    required this.posButton,
    required this.negButton,
  });

  @override
  _MultiSelectButtonDialogState createState() => _MultiSelectButtonDialogState();
}

class _MultiSelectButtonDialogState extends State<MultiSelectButtonDialog> {
  Map<String, bool> checkedItem = {};
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    for (var item in widget.items) {
      checkedItem[item.name!] =widget.selectedItem.any((element) => element.name == item.name);
    }
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      checkedItem.updateAll((key, _) => selectAll);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Container(
              height: 40,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(0xff5979AA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
              ),
              child: Center(
                child: Text(widget.title??CustomText.SHISHUGHAR, style: Styles.white126P),
              ),
            ),

            // Select All Checkbox
            CheckboxListTile(
              title: Text(widget.selectAll??"Select All"),
              value: selectAll,
              onChanged: toggleSelectAll,
            ),

            // List of checkboxes
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = widget.items[index];
                  return CheckboxListTile(
                    title: Text(item.values ?? "-"),
                    value: checkedItem[item.name] ?? false,
                    onChanged: (newValue) {
                      setState(() {
                        checkedItem[item.name!] = newValue!;
                        // update selectAll if all are now true
                        selectAll = !checkedItem.containsValue(false);
                      });
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: CElevatedButton(
                      text: widget.negButton,
                      color: Color(0xffDB4B73),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CElevatedButton(
                      text: widget.posButton,
                      color: Color(0xff369A8D),
                      onPressed: () {
                        // Return only selected items
                        final selected = widget.items
                            .where((e) => checkedItem[e.name] == true)
                            .toList();
                        Navigator.of(context).pop(selected);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

