

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/dynamic_screen_model/options_model.dart';
import '../../style/styles.dart';
import '../../utils/globle_method.dart';
import 'dynamic_custom_checkbox.dart';

class DynamicMultiCheckGrowthGridView extends StatefulWidget {
  final List<OptionsModel> items;
  final String? selectedItem;
  final String? titleText;
  final int? isRequred;
  final bool? readable;
  final Function(String?) onChanged;
  DynamicMultiCheckGrowthGridView({required this.items,required this.onChanged,
    required this.selectedItem,this.titleText,this.isRequred,this.readable
  });

  @override
  _DynamicMultiCheckGridViewState createState() =>
      _DynamicMultiCheckGridViewState();
}
class _DynamicMultiCheckGridViewState extends State<DynamicMultiCheckGrowthGridView> {
  @override
  Widget build(BuildContext context) {
    // Calculate the crossAxisCount dynamically based on the number of items

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 2),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children:[
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
            height: 3,
          ),
          GridView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 5,
          ),
          itemCount: widget.items.length,
          itemBuilder: (BuildContext context, int index) {
            return DynamicCustomCheckboxWithLabel(
              label: widget.items[index].values,
              readable: widget.readable,
              initialValue: (widget.selectedItem!=null)?Global.splitData(widget.selectedItem!, ',').contains(widget.items[index].name)?1:null:null,
              onChanged: (value) {
                var selcValue=widget.selectedItem;
                if(value==1){
                  if(Global.validString(selcValue)){
                    selcValue='$selcValue,${widget.items[index].name}';
                  }else selcValue='${widget.items[index].name}';
                }else{
                  if(Global.validString(selcValue)){
                    var teSel=Global.splitData(selcValue, ',');
                    var finalSeleV='';
                    if(teSel.length>0){
                      if(teSel.contains(widget.items[index].name!)){
                        teSel.remove(widget.items[index].name!);
                        teSel.forEach((element) {
                          if(Global.validString(finalSeleV)){
                            finalSeleV='$finalSeleV,${element}';
                          }else finalSeleV='${element}';
                        });

                      }
                    }
                    selcValue= finalSeleV;
                  }
                }
                setState(() {
                  widget.onChanged(selcValue);
                  // Call the onChanged callback with the new value
                });
              },
            );
          },
          )
        ]
      ),
    );
  }
}
