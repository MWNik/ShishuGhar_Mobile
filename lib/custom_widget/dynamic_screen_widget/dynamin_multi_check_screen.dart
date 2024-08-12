import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/dynamic_screen_model/options_model.dart';
import '../../style/styles.dart';
import 'dynamic_custom_checkbox.dart';

class DynamicMultiCheckGridView extends StatefulWidget {

  final List<OptionsModel> items;
  final List<dynamic>? selectedItem;
  final String responceFieldName;
  final String? titleText;
  double? childRatio;
  bool? readable;
  final int? isRequred;
  final bool? isVisible ;
  final Function(List<dynamic>?) onChanged;

  DynamicMultiCheckGridView(
      {required this.items,
      this.childRatio,
      required this.onChanged,
      required this.responceFieldName,
      required this.selectedItem,
       this.isVisible ,
       this.readable ,
      this.titleText,
      this.isRequred});

  @override
  _DynamicMultiCheckGridViewState createState() =>
      _DynamicMultiCheckGridViewState();
}

class _DynamicMultiCheckGridViewState extends State<DynamicMultiCheckGridView> {
  @override
  Widget build(BuildContext context) {
    // Calculate the crossAxisCount dynamically based on the number of items

    return Visibility(
        visible: widget.isVisible != null?widget.isVisible!:true,
        child: (widget.isVisible==null||widget.isVisible==true)?Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              childAspectRatio: widget.childRatio ?? 4,
            ),
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index) {
              return DynamicCustomCheckboxWithLabel(
                label: widget.items[index].values,
                  readable:widget.readable,
                // initialValue: (widget.selectedItem!=null)?Global.splitData(widget.selectedItem!, ',').contains(widget.items[index].name)?1:null:null,
                initialValue:
                    intilizeFun(widget.selectedItem, widget.items[index].name!),
                onChanged: (value) {
                  List<dynamic>? selcValue =
                      widget.selectedItem != null ? widget.selectedItem : [];
                  Map<String, String> hasItem = {
                    widget.responceFieldName: widget.items[index].name.toString()
                  };
                  if (value == 1) {
                    selcValue!.add(hasItem);
                  } else {
                    if (selcValue!.length > 0) {
                      selcValue =
                          removeItem(selcValue, widget.items[index].name!);
                      // var ite=selcValue.indexOf(hasItem);
                      // if(ite>-1){
                      //   selcValue.remove(ite);
                      // }
                    }
                    // if(Global.validString(selcValue)){
                    //   var teSel=Global.splitData(selcValue, ',');
                    //   var finalSeleV='';
                    //   if(teSel.length>0){
                    //     if(teSel.contains(widget.items[index].name!)){
                    //       teSel.remove(widget.items[index].name!);
                    //       teSel.forEach((element) {
                    //         if(Global.validString(finalSeleV)){
                    //           finalSeleV='$finalSeleV,${element}';
                    //         }else finalSeleV='${element}';
                    //       });
                    //
                    //     }
                    //   }
                    //   selcValue= finalSeleV;
                    // }
                  }
                  setState(() {
                    widget.onChanged(selcValue);
                    // Call the onChanged callback with the new value
                  });
                },
              );
            },
          )
        ]),
      ):SizedBox(),
    );
  }

  int intilizeFun(List? selectedItem, String itmName) {
    int returnValue = 0;
    if (selectedItem != null) {
      selectedItem.forEach((element) {
        if (element[widget.responceFieldName].toString() == itmName) {
          returnValue = 1;
        }
      });
    }
    return returnValue;
  }

  List removeItem(List? selectedItem, String itmName) {
    List<dynamic> returnValue = [];
    if (selectedItem != null) {
      selectedItem.forEach((element) {
        if (!(element[widget.responceFieldName].toString() == itmName)) {
          returnValue.add(element);
        }
      });
    }
    return returnValue;
  }
}
