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
import '../../custom_widget/custom_appbar.dart';
import '../../custom_widget/custom_text.dart';
import '../../database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import '../../model/apimodel/translation_language_api_model.dart';
import '../../utils/globle_method.dart';
import 'line_chart.dart';

class WeightToHeightBoysGirlsScreen extends StatefulWidget {
  final int gender_id;
  final int crechId;
  final String childenrollguid, childId, childName;

  WeightToHeightBoysGirlsScreen(
      {super.key,
      required this.gender_id,
      required this.crechId,
      required this.childId,
      required this.childName,
      required this.childenrollguid});

  @override
  State<WeightToHeightBoysGirlsScreen> createState() =>
      _WeightToHeightBoysGirlsScreenState();
}

class _WeightToHeightBoysGirlsScreenState
    extends State<WeightToHeightBoysGirlsScreen> {
  List<Offset>? green_cor = [];
  List<Offset>? red_cor = [];
  List<Offset>? yellow_max = [];
  List<Offset>? yellow_min = [];
  List<Offset>? child = [];
  List<double>? length = [], height_max = [], height_min = [];
  double? maxX, maxY,minX;
  // minY, minX;
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
    var boys = await HeightWeightBoysGirlsHelper().callWeightToHeightBoys24Or0();
    var girls = await HeightWeightBoysGirlsHelper().callWeightToHeightGirls24Or0();
    List res = widget.gender_id == 1 ? boys : girls;
    // widget.gender_id == '1' ? boys : girls;
    print(widget.gender_id);
    setState(() {
      length?.addAll(res.map((data) {
        double result = (data.length as num).toDouble();
        return result;
      }).toList());

      minX=res.length>0?(res.first.length as num).toDouble():0;

      height_max?.addAll(res.map((data) {
        double result = (data.sd2 as num).toDouble();
        return result;
      }).toList());

      height_min?.addAll(res.map((data) {
        double result = (data.sd3neg as num).toDouble();
        return result;
      }).toList());

      green_cor?.addAll(res.map((data) {
        double x = (data.length as num).toDouble();
        double y = (data.sd2 as num).toDouble();
        return Offset(x, y);
      }).toList());
      red_cor?.addAll(res.map((data) {
        double x = (data.length as num).toDouble();
        double y = (data.sd3neg as num).toDouble();
        return Offset(x, y);
      }).toList());
      yellow_max?.addAll(res.map((data) {
        double x = (data.length as num).toDouble();
        double y = (data.sd2neg as num).toDouble();
        return Offset(x, y);
      }).toList());
      yellow_min?.addAll(res.map((data) {
        double x = (data.length as num).toDouble();
        double y = (data.sd3neg as num).toDouble();
        return Offset(x, y);
      }).toList());
    });

    childAnthro = await ChildGrowthResponseHelper().allAnthormentryOrderBy(widget.crechId);
    if (childAnthro.isNotEmpty) {
      anthroResponsesList.add(childAnthro
          .map((ele) => jsonDecode(ele.responces!)['anthropromatic_details'])
          .toList());

      anthroResponsesList.forEach((ele) {
        for (var element in ele) {
          for (var ele in element) {
            if(ele['do_you_have_height_weight'].toString()=='1'
                && Global.stringToDouble(ele['height'].toString())>0
            ){
            children.add(ele);}
          }
        }
      });

      var childEnroll = await EnrolledExitChilrenResponceHelper()
          .callChildrenResponce(widget.childenrollguid);

      if(childEnroll.length>0){
        var enrollChild=jsonDecode(childEnroll.first.responces!) ;
        var weight=enrollChild['weight'];
        var height=enrollChild['height'];
        if(Global.stringToDouble(height.toString())>0
            && Global.stringToDouble(weight.toString())>0) {
          (height.toDouble() > length!.last) ? maxX = height.toDouble() : maxX = length!.last;
          (Global.stringToDouble(weight.toString()) > height_max!.last) ? maxY = Global.stringToDouble(weight.toString()) : maxY = height_max!.last;
          child!.add(Offset(height, weight));
        }
      }

      children = children.where((element) {
        print(element['childenrollguid']);
        return element['childenrollguid'] == widget.childenrollguid;
      }).toList();

      child!.addAll(children.map((data) {
        var height = Global.validString(data['height'].toString())
            ? data['height']
            : 0.0;
        double x = (height as num).toDouble();
        (x > length!.last) ? maxX = x : maxX = length!.last;
        // (x < length!.first) ? minX = x : minX = length!.first;

        double y = (data['weight'] as num).toDouble();

        return Offset(x, y);
      }).toList());
      // if (child!.length == 1) {
      //   child!.add(Offset(60, 9));
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
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: WillPopScope(
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
          body: (child!.length == 0)
              ? Center(
            child: Text(Global.returnTrLable(
                translats, CustomText.NorecordAvailable, lng)),
          )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: orientation == Orientation.portrait
                      ? MultiLineChart(
                          crechId: widget.crechId,
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
                          heading: CustomText.WeightforHeight,
                          bottomName: "Height",
                          leftName: "Weight",
                    minX: minX!,
                          // minX: minX!,
                          childenrollguid: widget.childenrollguid,
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: MultiLineChart(
                            crechId: widget.crechId,
                            childName: widget.childName,
                            childId: widget.childId,
                            childenrollguid: widget.childenrollguid,
                            coordinatesOne: yellow_max!,
                            coordinatesTwo: green_cor!,
                            coordinatesThree: red_cor!,
                            coordinatesFour: yellow_min!,
                            gender: widget.gender_id,
                            bottomName: "Height",
                            leftName: "Weight",
                            heading: CustomText.WeightforHeight,
                            maxY: maxY!,
                            child: child!,
                            maxX: maxX!,
                            // minX: minX!,
                            minX: minX!,
                          ),
                        )),
        ),
      ),
    );
  }
}



// import 'package:shishughar/database/helper/height_weight_boys_girls_helper.dart';

// import 'line_chart.dart';
// import 'package:flutter/material.dart';

// class WeightToHeightBoysGirlsScreen extends StatefulWidget {
//   final String gender_id;
//   WeightToHeightBoysGirlsScreen({super.key, required this.gender_id});

//   @override
//   State<WeightToHeightBoysGirlsScreen> createState() =>
//       _WeightToHeightBoysGirlsScreenState();
// }

// class _WeightToHeightBoysGirlsScreenState
//     extends State<WeightToHeightBoysGirlsScreen> {
//   // List<Offset> coordinatesTwo = [
//   //   Offset(0, 7),
//   //   Offset(23, 49),
//   //   Offset(27, 47),
//   //   Offset(60, 70),
//   //   Offset(80, 73),
//   //   Offset(100, 89),
//   //   Offset(120, 98),
//   // ];

//   // List<Offset> coordinatesOne = [
//   //   Offset(0, 10),
//   //   Offset(23, 55),
//   //   Offset(27, 60),
//   //   Offset(60, 70),
//   //   Offset(80, 76),
//   //   Offset(100, 93),
//   //   Offset(120, 100),
//   // ];

//   // List<Offset> coordinatesThree = [
//   //   Offset(0, 4),
//   //   Offset(20, 40),
//   //   Offset(25, 47),
//   //   Offset(60, 60),
//   //   Offset(80, 70),
//   //   Offset(100, 85),
//   //   Offset(120, 95),
//   // ];

//   List<Offset>? green_cor = [];
//   List<Offset>? red_cor = [];
//   List<Offset>? yellow_max = [];
//   List<Offset>? yellow_min = [];

//   void getDatas() async {
//     // var res = (widget.gender_id==1)? :
//     var boys = await HeightWeightBoysGirlsHelper().callWeightToHeightBoys();
//     var girls = await HeightWeightBoysGirlsHelper().callWeightToHeightGirls();
//     List res = widget.gender_id == '1' ? boys : girls;
//     print(res);
//     setState(() {
//       green_cor?.addAll(res.map((data) {
//         double x = (data.length as num).toDouble();
//         double y = (data.green as num).toDouble();
//         return Offset(x, y);
//       }).toList());
//       red_cor?.addAll(res.map((data) {
//         double x = (data.length as num).toDouble();
//         double y = (data.red as num).toDouble();
//         return Offset(x, y);
//       }).toList());
//       yellow_max?.addAll(res.map((data) {
//         double x = (data.length as num).toDouble();
//         double y = (data.yellow_max as num).toDouble();
//         return Offset(x, y);
//       }).toList());
//       yellow_min?.addAll(res.map((data) {
//         double x = (data.length as num).toDouble();
//         double y = (data.yellow_min as num).toDouble();
//         return Offset(x, y);
//       }).toList());
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getDatas();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var orientation = MediaQuery.of(context).orientation;

//     return Scaffold(
//       body: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: orientation == Orientation.portrait
//               ? SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: MultiLineChart(
//                     coordinatesOne: red_cor!,
//                     coordinatesTwo: green_cor!,
//                     coordinatesThree: yellow_max!,
//                     coordinatesFour: yellow_min!,
//                     gender: widget.gender_id,
//                     maxY: 120,
//                     maxX: 120,
//                     minY: 0,
//                     minX: 0,
//                   ),
//                 )
//               : SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: MultiLineChart(
//                     coordinatesOne: yellow_max!,
//                     coordinatesTwo: green_cor!,
//                     coordinatesThree: red_cor!,
//                     coordinatesFour: yellow_min!,
//                     gender: widget.gender_id,
//                     maxY: 120,
//                     maxX: 120,
//                     minY: 0,
//                     minX: 0,
//                   ),
//                 )),
//     );
//   }
// }
