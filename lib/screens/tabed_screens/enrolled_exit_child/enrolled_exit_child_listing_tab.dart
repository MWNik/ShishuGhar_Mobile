import 'package:flutter/material.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import 'child_enrolled_exit_not_listed_screen.dart';
import 'children_enrolled_exit_listed_screen.dart';

class EnrolledExitChildListingTab extends StatefulWidget {
  final int creCheId;
  final String village_id;


  const EnrolledExitChildListingTab({
    super.key,
    required this.creCheId,
    required this.village_id,

  });

  @override
  _EnrolledChildrenListingTabState createState() =>
      _EnrolledChildrenListingTabState();
}

class _EnrolledChildrenListingTabState
    extends State<EnrolledExitChildListingTab> with TickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  String lng = "en";
  List<Translation> labelControlls = [];
  String? role;
  String? crecheOpeningDate;
  String? crecheClosingDate;
  int tabCount = 2;

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
                        labelControlls, CustomText.Enrolledchildren, lng),
                    style: Styles.white145,
                  ),
                  // Text(
                  //  widget.creCheName,
                  //   style: Styles.white145,
                  // ),
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
                          // color: Color(0xff369A8D),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xff369A8D),
                              border: Border(
                                  right: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                      style: BorderStyle.solid))),
                          child: Tab(
                            child: Text(
                              Global.returnTrLable(
                                  labelControlls, CustomText.Enrolled, lng),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          // color: Color(0xff369A8D),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xff369A8D),
                              border: Border(
                                  right: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                      style: BorderStyle.solid))),
                          child: Tab(
                              child: Text(
                            Global.returnTrLable(
                                labelControlls, CustomText.NotEnroll, lng),
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ],
                    ),
              /* TabBar(
                      indicatorColor: Colors.white,
                      unselectedLabelColor: Colors.grey.shade300,
                      unselectedLabelStyle: Styles.white124P,
                      labelColor: Colors.white,
                      controller: _tabController,
                      // isScrollable: true,
                      tabs: tabTitleItem,
                    ),*/
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
    for (int i = 0; i < tabCount; i++) {
      if (i == 1) {
        tabItem.add(NotEnrolledExitChildrenListedScreen(
            crecheId: widget.creCheId, village_id: widget.village_id,
        ));
      } else
        tabItem
            .add(EnrolledExitChildrenListedScreen(crecheId: widget.creCheId,
        ));
    }
    return tabItem;
  }

  tabController() {
    _tabController = TabController(length: tabCount, vsync: this);
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
    role = (await Validate().readString(Validate.role))!;
    lng = (await Validate().readString(Validate.sLanguage))!;
    List<String> valueNames = [
      CustomText.Enrolledchildren,
      CustomText.Enrolled,
      CustomText.NotEnroll
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls = value);

    tabController();
  }
}
