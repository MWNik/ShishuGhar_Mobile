import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/screens/child_growth_child_chart/weight_for_age_boys_girls_screen.dart';
import 'package:shishughar/screens/child_growth_child_chart/weight_to_height_boys_girls_screen.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../custom_widget/custom_text.dart';
import 'height_for_age_boys_girls_screen.dart';

class MultiLineChart extends StatefulWidget {
  MultiLineChart({
    super.key,
    required this.childId,
    required this.childName,
    required this.gender,
    required this.maxY,
    required this.maxX,
    required this.bottomName,
    required this.leftName,
    // required this.minY,
    // required this.minX,
    required this.childenrollguid,
    required this.coordinatesOne,
    required this.coordinatesTwo,
    required this.coordinatesThree,
    required this.coordinatesFour,
    required this.child,
    required this.heading,
  });
  final List<Offset> coordinatesOne,
      coordinatesTwo,
      coordinatesThree,
      coordinatesFour,
      child;
  final String childenrollguid, bottomName, leftName, heading;
  // final double minY, maxY, minX, maxX;
  final double maxY, maxX;
  String childName;
  String childId;
  final int gender;

  @override
  State<MultiLineChart> createState() => _MultiLineChartState();
}

class _MultiLineChartState extends State<MultiLineChart> {
  List<Translation> translats = [];
  String lng = 'en';

  @override
  void initState() {
    super.initState();

  }

  Future<void> initializeData() async {
    String? lngtr = await Validate().readString(Validate.sLanguage);
    if(lngtr != null){
      lng = lngtr;
    }
    List<String> valueNames = [
      CustomText.WeightforAge,
      CustomText.WeightforHeight,
      CustomText.HeightforAge,
    
    ];

    await TranslationDataHelper().callTranslateString(valueNames).then((value) => translats.addAll(value));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            WeightforAgeBoysGirlsScreen(
                              childId: widget.childId,
                              gender_id: widget.gender,
                              childenrollguid: widget.childenrollguid,
                              childName: widget.childName,
                            ))),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: widget.heading == CustomText.WeightforAge
                          ? Colors.lightGreen.shade900
                          : Colors.white,
                      border: Border.all(
                          width: 1, color: Colors.lightGreen.shade900)),
                  child: Text(
                    Global.returnTrLable(translats, CustomText.WeightforAge, lng),
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.heading == CustomText.WeightforAge
                          ? Colors.white
                          : Colors.lightGreen.shade900,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HeightforAgeBoysGirlsScreen(
                              childId: widget.childId,
                              gender_id: widget.gender,
                              childenrollguid: widget.childenrollguid,
                              childName: widget.childName,
                            ))),
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: widget.heading == CustomText.HeightforAge
                            ? Colors.lightGreen.shade900
                            : Colors.white,
                        border: Border.all(
                            width: 1, color: Colors.lightGreen.shade900)),
                    child: Text(
                      Global.returnTrLable(translats,CustomText.HeightforAge, lng),
                      style: TextStyle(
                          color: widget.heading == CustomText.HeightforAge
                              ? Colors.white
                              : Colors.lightGreen.shade900,
                          fontSize: 12),
                    )),
              ),
              SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            WeightToHeightBoysGirlsScreen(
                              childId: widget.childId,
                              gender_id: widget.gender,
                              childenrollguid: widget.childenrollguid,
                              childName: widget.childName,
                            ))),
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: widget.heading == CustomText.WeightforHeight
                            ? Colors.lightGreen.shade900
                            : Colors.white,
                        border: Border.all(
                            width: 1, color: Colors.lightGreen.shade900)),
                    child: Text(
                      Global.returnTrLable(translats, CustomText.WeightforHeight, lng),
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.heading == CustomText.WeightforHeight
                            ? Colors.white
                            : Colors.lightGreen.shade900,
                      ),
                    )),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "${widget.heading} - (${Global.returnTrLable(translats,(widget.gender == 1 ? CustomText.boy :widget.gender == 2? CustomText.girl:CustomText.other),lng)})",
            style: TextStyle(fontSize: 19),
          ),
        ),
        buildChart(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Container(
                  //   color: Colors.black,
                  //   width: 10,
                  //   height: 10,
                  // ),
                  // SizedBox(
                  //   width: 5,

                  // ),
                  // Text(CustomText.measurment),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    color: Colors.green,
                    width: 10,
                    height: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Normal"),
                ],
              ),
              Row(
                children: [
                  Container(
                    color: Colors.orange,
                    width: 10,
                    height: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Moderator"),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    color: Colors.red,
                    width: 10,
                    height: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Severe"),
                ],
              )
            ],
          ),
        )
      ],
    ));
  }

  Widget buildChart() {
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    var chartHeight = orientation == Orientation.portrait
        ? size.height * 0.6
        : size.height * 1.5;
    return Container(
        padding: EdgeInsets.all(8.0),
        height: chartHeight,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: widget.maxX,
            minY: 0,
            maxY: Global.roundToNearest(widget.maxY),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d), width: 1),
            ),
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                  axisNameWidget: Text(
                    widget.bottomName,
                    style: TextStyle(fontSize: 10),
                  ),
                  axisNameSize: 15,
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      );
                    },
                    interval: widget.bottomName=='Age'?400:10,
                    reservedSize: 18,
                  )),
              leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    widget.leftName,
                    style: TextStyle(fontSize: 10),
                  ),
                  axisNameSize: 15,
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        // (value + 0.5).toDouble().toString(),
                        (value).toDouble().toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      );
                    },
                    reservedSize: 30,
                  )),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          // (value + 0.5).toDouble().toString(),
                          (value ).toDouble().toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 30)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: widget.coordinatesFour
                    .map((coord) => FlSpot(coord.dx, coord.dy))
                    .toList(),
                barWidth: 1,
                isStrokeCapRound: true,
                isCurved: true,
                curveSmoothness: 0.2,
                color: Colors.yellow.shade800,
                dotData: FlDotData(
                  show: false, // Remove dot points
                ),
                belowBarData: BarAreaData(
                    show: true, color: Colors.yellow.withOpacity(0.5)),
              ),
              LineChartBarData(
                spots: widget.coordinatesTwo
                    .map((coord) => FlSpot(coord.dx, coord.dy))
                    .toList(),
                color: Colors.green,
                barWidth: 2,
                isStrokeCapRound: false,
                isCurved: true,
                curveSmoothness: 0.2,
                dotData: FlDotData(
                  show: false, // Remove dot points
                ),
                belowBarData: BarAreaData(
                    show: true, color: Colors.green.withOpacity(0.8)),
              ),
              LineChartBarData(
                spots: (orientation == Orientation.portrait)
                    ? widget.coordinatesThree
                        .map((coord) => FlSpot(coord.dx, coord.dy))
                        .toList()
                    : widget.coordinatesOne
                        .map((coord) => FlSpot(coord.dx, coord.dy))
                        .toList(),
                barWidth: 1.5,
                isStrokeCapRound: true,
                isCurved: true,
                curveSmoothness: 0.2,
                color: Colors.yellow.shade800,
                dotData: FlDotData(
                  show: false, // Remove dot points
                ),
                belowBarData: BarAreaData(
                    show: true, color: Colors.yellow.withOpacity(0.8)),
              ),
              LineChartBarData(
                spots: (orientation == Orientation.landscape)
                    ? widget.coordinatesThree
                        .map((coord) => FlSpot(coord.dx, coord.dy))
                        .toList()
                    : widget.coordinatesOne
                        .map((coord) => FlSpot(coord.dx, coord.dy))
                        .toList(),
                barWidth: 2,
                color: Colors.red,
                isStrokeCapRound: false,
                isCurved: true,
                curveSmoothness: 0.2,
                dotData: FlDotData(
                  show: false, // Remove dot points
                ),
                belowBarData:
                    BarAreaData(show: true, color: Colors.red.withOpacity(0.8)),
              ),
              LineChartBarData(
                spots: widget.child
                    .map((coord) => FlSpot(coord.dx, coord.dy))
                    .toList(),
                barWidth: 1, //////////////
                color: Colors.black,
                isStrokeCapRound: false,
                isCurved: true,
                curveSmoothness: 0.2,
                dotData: FlDotData(
                  show: true, // Remove dot points
                ),
              ),
            ],
          ),
        ));
  }
}
