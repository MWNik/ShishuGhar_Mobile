import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/screens/tabed_screens/creshe/creshe_tab_screen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';

class CrecheListedScreen extends StatefulWidget {
  const CrecheListedScreen({super.key});

  @override
  State<CrecheListedScreen> createState() => _CrecheListedScreen();
}

class _CrecheListedScreen extends State<CrecheListedScreen> {
  TextEditingController Searchcontroller = TextEditingController();
  List<CresheDatabaseResponceModel> crecheData = [];
  List<Translation> translats = [];
  List<Translation> translatsLabel = [];
  String lng = 'en';

  @override
  void initState() {
    super.initState();
    fetchCrecheDataList();
    initializeData();
  }

  Future<void> initializeData() async {
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    List<String> valueItems = [CustomText.Search,CustomText.Creches_];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translatsLabel = value);
    await TranslationDataHelper()
        .callTranslateCreche()
        .then((value) => translats = value);
    setState(() {});
  }

  Future<void> fetchCrecheDataList() async {
    crecheData = await CrecheDataHelper().getCrecheResponce();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        actions: [
          InkWell(
              onTap: () {
                // callVerificationStatusData();
              },
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(
                  "assets/reset.png",
                  scale: 3,
                ),
              )),
        ],
        text: Global.returnTrLable(
            translatsLabel, CustomText.Creches_, lng),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: CustomTextFieldRow(
                  controller: Searchcontroller,
                  hintText: Global.returnTrLable(
                      translatsLabel, CustomText.Search, lng),
                  prefixIcon: Image.asset(
                    "assets/search.png",
                    scale: 2.4,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Image.asset(
                "assets/filter_icon.png",
                scale: 2.4,
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: crecheData.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      // Handle item tap here
                      print('Item $index tapped');
                      var refStatus = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => CresheTabScreen(
                                  name: crecheData[index].name!,
                                  crechedCode: Global.getItemValues(crecheData[index].responces!, 'creche_id')
                                  ,isUpdate: Global.validString(Global.getItemValues(crecheData[index].responces!, 'image'))
                              )));
                      if (refStatus == 'itemRefresh') {
                        await fetchCrecheDataList();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff5A5A5A).withOpacity(
                                    0.2), // Shadow color with opacity
                                offset: Offset(0,
                                    3), // Horizontal and vertical offset
                                blurRadius: 6, // Blur radius
                                spreadRadius: 0, // Spread radius
                              ),
                            ],
                            color: Colors.white,
                            border: Border.all(color: Color(0xffE7F0FF)),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                            text: '${Global.returnTrLable(translats, CustomText.CrecheId, lng).trim()} : ',
                                            style: Styles.black104,
                                            children: [
                                              TextSpan(
                                                  text: getItemValues(
                                                      crecheData[index]
                                                          .responces!,
                                                      'creche_id'),
                                                  style: Styles.blue125),
                                            ])),
                                    RichText(
                                        strutStyle: StrutStyle(height: 1.h),
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                            text:
                                                '${Global.returnTrLable(translats, CustomText.Creche_Name, lng).trim()} : ',
                                            style: Styles.black104,
                                            children: [
                                              TextSpan(
                                                  text: getItemValues(
                                                      crecheData[index]
                                                          .responces!,
                                                      'creche_name'),
                                                  style: Styles.blue125),
                                            ])),
                                    RichText(
                                        strutStyle: StrutStyle(height: 1.h),
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                            text:
                                                '${Global.returnTrLable(translats, CustomText.Is_Active, lng).trim()} : ',
                                            style: Styles.black104,
                                            children: [
                                              TextSpan(
                                                  text: getItemValues(
                                                      crecheData[index]
                                                          .responces!,
                                                      'is_active'),
                                                  style: Styles.blue125),
                                            ])),
                                  ],
                                ),
                              ),
                              SizedBox(width:10.w),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 10.h,
          ),
        ]),
      ),
    );
  }

  String getItemValues(String response, String key) {
    String returnValue = "";
    Map<String, dynamic> itemresponse = jsonDecode(response);
    var value = itemresponse[key];
    if (value != null) {
      returnValue = value.toString();
    }
    return returnValue;
  }
}
