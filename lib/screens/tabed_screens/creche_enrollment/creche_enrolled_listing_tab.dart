// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/screens/tabed_screens/creche_enrollment/creche_enroll_child_enroll.dart';
import 'package:shishughar/screens/tabed_screens/creche_enrollment/creche_enroll_child_exit.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';

class CrecheEnrolledListingTab extends StatefulWidget {
  String creche_id;
  String EnrolledChilGUID;
  String Childname;
  String childID;

  CrecheEnrolledListingTab({
    super.key,
    required this.creche_id,
    required this.EnrolledChilGUID,
    required this.Childname,
    required this.childID,
  });

  @override
  _CrecheEnrolledListingTabState createState() =>
      _CrecheEnrolledListingTabState();
}

class _CrecheEnrolledListingTabState extends State<CrecheEnrolledListingTab>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  String lng = "en";
  List<String> tabItems = [];
  List<Widget> tabTitleItem = [];
  List<Translation> labelControlls = [];
  @override
  void initState() {
    super.initState();
    setLabelTextData();
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    if (_isLoading) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    } else {
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, 'itemRefresh');
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              backgroundColor: Color(0xff5979AA),
              leading: Padding(
                padding: EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, 'itemRefresh');
                  },
                  child: Icon(
                    Icons.arrow_back_ios_sharp,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Global.returnTrLable(
                        labelControlls, CustomText.creche_enrollement, lng),
                    style: Styles.white145,
                  ),
                  RichText(
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      WidgetSpan(
                        child: Text(
                          '${widget.Childname} ',
                          style: Styles.white126P,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      WidgetSpan(
                        child: Text(
                          '-${widget.childID}',
                          style: Styles.white126P,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
                  )
                ],
              ),
              centerTitle: true,
              bottom: _isLoading
                  ? null
                  : TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: EdgeInsets.zero,
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xffF26BA3),
                            width: 3.0,
                          ),
                        ),
                      ),
                      controller: _tabController,
                      unselectedLabelColor: Color(0xff369A8D),
                      tabs: [
                        Container(
                          color: Color(0xff369A8D),
                          width: double.infinity,
                          child: Tab(
                            child: Text(
                              CustomText.Enrolled,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          color: Color(0xff369A8D),
                          width: double.infinity,
                          child: Tab(
                              child: Text(
                            CustomText.child_exited,
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ],
                    ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: tabControllerScreen(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabItems.length; i++) {
      if (i == 1) {
        tabItem.add(CrecheEnrollChildExit(
          chilenrolledGUID: widget.EnrolledChilGUID,
          creche_id: widget.creche_id,
        ));
      } else {
        tabItem.add(CrecheEnrollChildEnrollScreen(
          chilenrolledGUID: widget.EnrolledChilGUID,
          creche_id: widget.creche_id,
        ));
      }
    }
    return tabItem;
  }

  tabController() {
    tabItems.clear();
    tabItems
        .add(Global.returnTrLable(labelControlls, CustomText.Enrolled, lng));
    tabItems.add(
        Global.returnTrLable(labelControlls, CustomText.child_exited, lng));
    tabItems.forEach((element) {
      tabTitleItem.add(Tab(icon: Container(child: Text(element))));
    });
    _tabController = TabController(length: tabItems.length, vsync: this);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> setLabelTextData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    List<String> valueNames = [
      CustomText.Enrolledchildren,
      CustomText.Enrolled,
      CustomText.child_exit
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls = value);
    tabController();
  }
}
