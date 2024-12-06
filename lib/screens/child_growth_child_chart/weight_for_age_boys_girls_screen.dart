import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shishughar/custom_widget/custom_appbar_child.dart';
import 'package:shishughar/database/helper/height_weight_boys_girls_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/databasemodel/child_growth_responce_model.dart';
import 'package:flutter/material.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
import '../../custom_widget/custom_text.dart';
import '../../model/apimodel/translation_language_api_model.dart';
import '../../utils/globle_method.dart';
import 'line_chart.dart';

class WeightforAgeBoysGirlsScreen extends StatefulWidget {
  final int gender_id;
  final String childenrollguid, childId, childName;

  WeightforAgeBoysGirlsScreen(
      {super.key,
      required this.gender_id,
      required this.childenrollguid,
      required this.childId,
      required this.childName});

  @override
  State<WeightforAgeBoysGirlsScreen> createState() =>
      _WeightforAgeBoysGirlsScreenState();
}

class _WeightforAgeBoysGirlsScreenState
    extends State<WeightforAgeBoysGirlsScreen> {
  List<Offset>? green_cor = [];
  List<Offset>? red_cor = [];
  List<Offset>? yellow_max = [];
  List<Offset>? yellow_min = [];
  List<Offset> child = [];
  List<double>? age_in_months = [], height_max = [], height_min = [];
  double? maxX, maxY;
  List children = [];
  List<ChildGrowthMetaResponseModel> childAnthro = [];
  List<dynamic> anthroResponsesList = [];

  List<Translation> translats = [];
  String lng = 'en';

  Future getDatas() async {
    String? lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    List<String> valueItems = [
      CustomText.NorecordAvailable,
      CustomText.GrowthChart,
      CustomText.WeightforAge,
      CustomText.WeightforHeight,
      CustomText.HeightforAge
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    var boys = await HeightWeightBoysGirlsHelper().callWeightforAgeBoys();
    var girls = await HeightWeightBoysGirlsHelper().callWeightforAgeGirls();
    List res = widget.gender_id == 1 ? boys : girls;
    // widget.gender_id == 1 ? boys : girls;
    print(widget.gender_id);
    setState(() {
      age_in_months?.addAll(res.map((data) {
        double result = (data.age_in_days as num).toDouble();
        return result;
      }).toList());

      height_max?.addAll(res.map((data) {
        double result = (data.green as num).toDouble();
        return result;
      }).toList());

      height_min?.addAll(res.map((data) {
        double result = (data.red as num).toDouble();
        return result;
      }).toList());

      green_cor?.addAll(res.map((data) {
        double x = (data.age_in_days as num).toDouble();
        double y = (data.green as num).toDouble();
        return Offset(x, y);
      }).toList());
      red_cor?.addAll(res.map((data) {
        double x = (data.age_in_days as num).toDouble();
        double y = (data.red as num).toDouble();
        return Offset(x, y);
      }).toList());
      yellow_max?.addAll(res.map((data) {
        double x = (data.age_in_days as num).toDouble();
        double y = (data.yellow_max as num).toDouble();
        return Offset(x, y);
      }).toList());
      yellow_min?.addAll(res.map((data) {
        double x = (data.age_in_days as num).toDouble();
        double y = (data.yellow_min as num).toDouble();
        return Offset(x, y);
      }).toList());
    });

    childAnthro = await ChildGrowthResponseHelper().allAnthormentry();
    if (childAnthro.isNotEmpty) {
      anthroResponsesList.add(childAnthro
          .map((ele) => jsonDecode(ele.responces!)['anthropromatic_details'])
          .toList());

      anthroResponsesList.forEach((ele) {
        for (var element in ele) {
          for (var ele in element) {
            children.add(ele);
          }
        }
      });

      children = children.where((element) {
        print(element['childenrollguid']);
        return element['childenrollguid'] == widget.childenrollguid;
      }).toList();

      child.addAll(children.map((data) {
        double x = (Global.stringToDouble(data['age_months'].toString())).toDouble();
        (x > age_in_months!.last) ? maxX = x : maxX = age_in_months!.last;
        // (x < age_in_months!.first) ? minX = x : minX = age_in_months!.first;

        double y = (Global.stringToDouble(data['weight'].toString())).toDouble();

        (y > height_max!.last) ? maxY = y : maxY = height_max!.last;
        // (y < height_min!.first) ? minY = y : minY = height_min!.first;

        return Offset(x, y);
      }).toList());
      // if (child.length == 0) {
      //   child.add(Offset(20, 6));
      // }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    getDatas();

    // fetchAllAnthroRecords();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    print(child);
    return WillPopScope(
      onWillPop: () async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
      },
      child: Scaffold(
        appBar: CustomChildAppbar(
          text: Global.returnTrLable(translats, CustomText.GrowthChart, lng),
          subTitle1: widget.childName,
          subTitle2: widget.childId,
          onTap: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitDown,
              DeviceOrientation.portraitUp,
            ]);
            Navigator.pop(context);
          },
        ),
        body: (child.length == 0)
            ? Center(
                child: Text(Global.returnTrLable(
                    translats, CustomText.NorecordAvailable, lng)),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: orientation == Orientation.portrait
                    ? MultiLineChart(
                        childName: widget.childName,
                        childId: widget.childId,
                        coordinatesOne: red_cor!,
                        child: child,
                        coordinatesTwo: green_cor!,
                        coordinatesThree: yellow_max!,
                        coordinatesFour: yellow_min!,
                        gender: widget.gender_id,
                        maxX: maxX!,
                        maxY: maxY!,
                        bottomName: "Age",
                        leftName: "Weight",
                        heading: CustomText.WeightforAge,
                        // minY: minY!,
                        // minX: minX!,
                        childenrollguid: widget.childenrollguid,
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: MultiLineChart(
                          childName: widget.childName,
                          childId: widget.childId,
                          childenrollguid: widget.childenrollguid,
                          coordinatesOne: yellow_max!,
                          coordinatesTwo: green_cor!,
                          coordinatesThree: red_cor!,
                          coordinatesFour: yellow_min!,
                          gender: widget.gender_id,
                          bottomName: "Age",
                          leftName: "Weight",
                          heading: CustomText.WeightforAge,
                          maxY: maxY!,
                          child: child,
                          maxX: maxX!,
                          // minX: minX!,
                          // minY: minY!,
                        ),
                      )),
      ),
    );
  }
}
