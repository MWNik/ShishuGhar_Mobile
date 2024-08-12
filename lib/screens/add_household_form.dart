import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';

import 'package:shishughar/style/styles.dart';
import '../custom_widget/custom_radio_btn.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../database/helper/house_field_item_helper.dart';
import '../model/apimodel/house_hold_field_item_model_api.dart';
import '../model/dynamic_screen_model/options_model.dart';
import '../utils/globle_method.dart';
import 'add_household_child_form.dart';

class AddHouseholdScreenFrom extends StatefulWidget {
  const AddHouseholdScreenFrom({super.key});

  @override
  State<AddHouseholdScreenFrom> createState() => _HouseholdScreenState();

}

class _HouseholdScreenState extends State<AddHouseholdScreenFrom> {
  bool _isLoading = true; // Change this to true initially
  int currentPage = 0;
  String? selectedOdour;
  List<HouseHoldFielItemdModel> screensWidget = [];
  List<OptionsModel> options = [];
  // Map<String, List<OptionsModel>> options = {};
  // Map<String, List<OptionsModel>> options = {};
  List<TextEditingController> etControllers = [];
  Map<String, String> myMap = {};
  @override
  void initState() {
    super.initState();
    callScrenControllers('Household Form');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: CustomAppbar(text: CustomText.AddHouseholdListing),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cWidget(),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CElevatedButton(
                      color: Color(0xffF26BA3),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: CustomText.back,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CElevatedButton(
                      color: Color(0xff5979AA),
                      onPressed: () {
                        print(myMap);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (BuildContext context) => AddHouseholdScreenChildFrom(),
                        // ));
                      },
                      text: CustomText.Save,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  List<Widget> cWidget() {
    List<Widget> screenItems = [];
    for (int i = 0; i < screensWidget.length; i++) {
      screenItems.add(widgetTypeWidget(i));
      screenItems.add(SizedBox(height: 5.h));
    }
    return screenItems;
  }

  widgetTypeWidget(int index) {
    switch (screensWidget[index].fieldtype) {
      case 'Tab Break':
        return Text(
          screensWidget[index].label!,
          style: Styles.red145,
        );
      // case 'Link':
      //   List<OptionsModel> items=options.where((element) => element.flag=='tab${screensWidget[index].options}').toList();
      //   return DynamicCustomDropdownField(
      //     translats: ,
      //     titleText: screensWidget[index].label,
      //     items: items,
      //     selectedItem: myMap[screensWidget[index].name],
      //     onChanged: (value) {
      //       myMap[screensWidget[index].name!]=value!.name!;
      //     },
      //   );
      // case 'Date':
      //   return CustomDatepickerDynamic(
      //     onChanged: (value) {
      //       print('Entered text: $value');
      //       myMap[screensWidget[index].name!]='$value';
      //     },
      //     titleText: screensWidget[index].label,
      //   );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText: screensWidget[index].label,
          onChanged: (value) {
            print('Entered text: $value');
            myMap[screensWidget[index].name!]=value;
          },
        );
      case 'Int':
        return DynamicCustomTextFieldNew(
          keyboardtype: TextInputType.number,
          titleText: screensWidget[index].label,
          onChanged: (value) {
            print('Entered text: $value');
            myMap[screensWidget[index].name!]=value;
          },
        );
      case 'Check':
        return CustomRadioButton(
          value: screensWidget[index].label!,
          groupValue: "1",
          onChanged: (value) {
            setState(() {
              // "Gendertype" = value!;
            });
          },
          label: screensWidget[index].label!,
        );
      case 'Select':
        return DynamicCustomTextFieldNew(
          keyboardtype: TextInputType.number,
          titleText: screensWidget[index].label,
          onChanged: (value) {
            print('Entered text: $value');
            myMap[screensWidget[index].name!]=value;
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          titleText: screensWidget[index].label,
          onChanged: (value) {
            print('Entered text: $value');
            myMap[screensWidget[index].name!]=value;
          },
        );
      default:
        return SizedBox(height: 1.h);
    }
  }

  Future<void> callScrenControllers(screen_type) async {
    await HouseHoldFieldHelper().getHouseHoldFieldsForm(screen_type).then((value) async {

        screensWidget = value;
        for (int i = 0; i < screensWidget.length; i++) {
          etControllers.add(TextEditingController());
          if (Global.validString(screensWidget[i].options)) {
            if (!(screensWidget[i].options == 'Household Child Form')) {
              if ((screensWidget[i].options == 'State') ||
                  (screensWidget[i].options == 'District') ||
                  (screensWidget[i].options == 'Block') ||
                  (screensWidget[i].options == 'Gram Panchayat') ||
                  (screensWidget[i].options == 'Village')) {
                await OptionsModelHelper().getOptions(screensWidget[i].options!.trim()).then((data) {
                  options.addAll(data);
                });
              }
            }
          }
        }
      });
    await OptionsModelHelper().getAllMstCommonOptions('').then((data) {
      options.addAll(data);
    });
    print("opiotin ${options.length}");
    setState(() {
      _isLoading = false;
    });
  }
}




