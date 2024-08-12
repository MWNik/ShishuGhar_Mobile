import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shishughar/custom_widget/custom_appbar_child.dart';
import 'package:shishughar/database/helper/height_weight_boys_girls_helper.dart';
import 'package:shishughar/model/databasemodel/child_growth_responce_model.dart';
import 'package:flutter/material.dart';
import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
import '../../custom_widget/custom_appbar.dart';
import '../../custom_widget/custom_text.dart';
import '../../model/apimodel/translation_language_api_model.dart';
import '../../utils/globle_method.dart';
import 'line_chart.dart';

class HeightforAgeBoysGirlsScreen extends StatefulWidget {
  final int gender_id;
  final String childenrollguid, childName, childId;

  HeightforAgeBoysGirlsScreen(
      {super.key,
      required this.gender_id,
      required this.childId,
      required this.childName,
      required this.childenrollguid});

  @override
  State<HeightforAgeBoysGirlsScreen> createState() =>
      _HeightforAgeBoysGirlsScreenState();
}

class _HeightforAgeBoysGirlsScreenState
    extends State<HeightforAgeBoysGirlsScreen> {
  List<Offset>? green_cor = [];
  List<Offset>? red_cor = [];
  List<Offset>? yellow_max = [];
  List<Offset>? yellow_min = [];
  List<Offset> child = [];
  List<double>? age_in_months = [], height_max = [], height_min = [];
  double? maxX, maxY;

  // minY, minX;
  List children = [];
  List<ChildGrowthMetaResponseModel> childAnthro = [];
  List<dynamic> anthroResponsesList = [];

  List<Translation> translats = [];
  String lng = 'en';

  Future getDatas() async {
    var boys = await HeightWeightBoysGirlsHelper().callHeightForAgeBoys();
    var girls = await HeightWeightBoysGirlsHelper().callHeightForAgeGirls();
    List res = widget.gender_id == 1 ? boys : girls;
    // widget.gender_id == '1' ? boys : girls;
    print(widget.gender_id);
    setState(() {
      age_in_months?.addAll(res.map((data) {
        double result = (data.age_in_months as num).toDouble();
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
        double x = (data.age_in_months as num).toDouble();
        double y = (data.green as num).toDouble();
        return Offset(x, y);
      }).toList());
      red_cor?.addAll(res.map((data) {
        double x = (data.age_in_months as num).toDouble();
        double y = (data.red as num).toDouble();
        return Offset(x, y);
      }).toList());
      yellow_max?.addAll(res.map((data) {
        double x = (data.age_in_months as num).toDouble();
        double y = (data.yellow_max as num).toDouble();
        return Offset(x, y);
      }).toList());
      yellow_min?.addAll(res.map((data) {
        double x = (data.age_in_months as num).toDouble();
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

      child?.addAll(children.map((data) {
        double x = (data['age_months'] as num).toDouble();
        (x > age_in_months!.last) ? maxX = x : maxX = age_in_months!.last;
        // (x < age_in_months!.first) ? minX = x : minX = age_in_months!.first;

        double y = (data['height'] as num).toDouble();

        (y > height_max!.last) ? maxY = y : maxY = height_max!.last;
        // (y < height_min!.first) ? minY = y : minY = height_min!.first;

        return Offset(x, y);
      }).toList());
      // if (child.length == 0) {
      //   child.add(Offset(10, 10));
      // }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
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
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: orientation == Orientation.portrait
                    ? MultiLineChart(
                        coordinatesOne: red_cor!,
                        child: child!,
                        childName: widget.childName,
                        childId: widget.childId,
                        coordinatesTwo: green_cor!,
                        coordinatesThree: yellow_max!,
                        coordinatesFour: yellow_min!,
                        gender: widget.gender_id,
                        maxX: maxX!,
                        maxY: maxY!,
                        bottomName: "Age",
                        leftName: "Height",
                        heading: "Height For Age",
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
                          heading: "Height For Age",
                          bottomName: "Age",
                          leftName: "Height",
                          maxY: maxY!,
                          child: child!,
                          maxX: maxX!,
                          // minX: minX!,
                          // minY: minY!,
                        ),
                      )),
      ),
    );
  }
}

// class AnthropromaticData {
//   final List<ChildGrowthMetaResponseModel> children;

//   AnthropromaticData({required this.children});

//   factory AnthropromaticData.fromJson(List<dynamic> json) {
//     List<ChildGrowthMetaResponseModel> childrenList = json
//         .map((childJson) => ChildGrowthMetaResponseModel.fromJson(childJson))
//         .toList();

//     return AnthropromaticData(children: childrenList);
//   }
// }
