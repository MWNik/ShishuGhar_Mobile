import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitor/creche_monitor_tab.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../model/dynamic_screen_model/creche_monitor_response_model.dart';
import '../../../style/styles.dart';

class CrecheMonitorListingScreen extends StatefulWidget {
  final String? crecheId;
  final String crecheName;

   CrecheMonitorListingScreen({super.key, required this.crecheId,
    required this.crecheName,
  });

  @override
  State<CrecheMonitorListingScreen> createState() =>
      _CrecheMonitorListingScreenState();
}

class _CrecheMonitorListingScreenState
    extends State<CrecheMonitorListingScreen> {
  List<CrecheMonitorResponseModel> crecheMonitorData=[];

  @override
  void initState() {
    super.initState();
     initializeData();
  }

  Future<void> initializeData() async {
    print(widget.crecheId);
    crecheMonitorData = await CrecheMonitorResponseHelper()
        .getCrecheResponseWithCrecheId(widget.crecheId);

    setState(() {});

  }

  /// Navigate to Form Screen
  Future<void> _navigateToFormPage(String? cmgUid,String? dateOfVisit,bool isEdit,bool isViewScreen) async {
    // get allowRefresh
    final allowRefresh = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CrecheMonitorTab(
          cmgUid: cmgUid ?? "",
          crecheId: widget.crecheId ?? "0",
          dateOfVisit: dateOfVisit,
          isEdit: isEdit,
          isViewScreen: isViewScreen,
        ),
      ),
    );

    if (allowRefresh == 'itemRefresh') {
      initializeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          String cmgUid = '';
          if (!(Global.validString(cmgUid))) {
            cmgUid = Validate().randomGuid();
            _navigateToFormPage(cmgUid,null,false,false);
          }
        },
        child: Image.asset(
          "assets/add_btn.png",
          scale: 2.7,
          color: Color(0xff5979AA),
        ),
      ),

      // appBar
      appBar: CustomAppbar(
        text: CustomText.VisitNotes,
        subTitle: widget.crecheName,
        onTap: () => Navigator.pop(context),
      ),

      // body
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
        Expanded(
        child:crecheMonitorData.length>0?
        ListView.builder(
        itemCount: crecheMonitorData.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          final responce = crecheMonitorData[index].responces;

          return GestureDetector(
            onTap: () async {
              var created_at = DateTime.parse(crecheMonitorData[index].created_at.toString());
              var date  = DateTime(created_at.year,created_at.month,created_at.day);
              bool isViewScreen = date.add(Duration(days: 7)).isBefore(DateTime.parse(Validate().currentDate()));
              final cmgUid = crecheMonitorData[index].cmguid;
              await _navigateToFormPage(cmgUid,Global.getItemValues(responce!, 'date_of_visit'),true,isViewScreen);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                    Border.all(color: Color(0xffE7F0FF)),
                    borderRadius:
                    BorderRadius.circular(10.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          // Text(
                          //   '${CustomText.Creches} : ',
                          //   style: Styles.black104,
                          //   strutStyle: StrutStyle(height: 1),
                          // ),
                          Text(
                            '${CustomText.datevisit} : ',
                            style: Styles.black104,
                          ),

                         
                        ],
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        height: 20.h,
                        width: 2,
                        child: VerticalDivider(
                          color: Color(0xffE6E6E6),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            // Text(
                            //   widget.crecheName,
                            //   style: Styles.blue125,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            Text(
                              Global.validString(Global.getItemValues(responce!, 'date_of_visit'))?Validate().displeDateFormate(Global.getItemValues(responce!, 'date_of_visit')):'',
                              style: Styles.blue125,
                              strutStyle:
                              StrutStyle(height: .5),
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Text(
                            //   Global.getItemValues(responce, 'exit_time'),
                            //   style: Styles.blue125,
                            //   strutStyle:
                            //   StrutStyle(height: .5),
                            //   overflow: TextOverflow.ellipsis,
                            // ),

                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      (crecheMonitorData[index].is_edited==0 && crecheMonitorData[index].is_uploaded==1)?
                      Image.asset(
                        "assets/sync.png",
                        scale: 1.5,
                      ):
                      Image.asset(
                        "assets/sync_gray.png",
                        scale: 1.5,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )
              : Center(
          child: Text( CustomText.NorecordAvailable)),
        ),
        ]),
      ),
    );
  }
}
