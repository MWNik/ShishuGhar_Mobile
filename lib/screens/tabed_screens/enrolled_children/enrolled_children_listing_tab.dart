import 'package:flutter/material.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import 'children_enrolled_listed_screen.dart';
import 'children_enrolled_not_listed_screen.dart';

class EnrolledChildrenListingTab extends StatefulWidget {
  final int creCheId;
  final String village_id;
  const EnrolledChildrenListingTab({
    super.key,
    required this.creCheId,
    required this.village_id,
  });

  @override
  _EnrolledChildrenListingTabState createState() =>
      _EnrolledChildrenListingTabState();
}

class _EnrolledChildrenListingTabState extends State<EnrolledChildrenListingTab>
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
              toolbarHeight: 40,
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
                      indicatorColor: Colors.white,
                      unselectedLabelColor: Colors.grey.shade300,
                      unselectedLabelStyle: Styles.white124P,
                      labelColor: Colors.white,
                      controller: _tabController,
                      // isScrollable: true,
                      tabs: tabTitleItem,
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
        tabItem.add(NotEnrolledChildrenListedScreen(
            crecheId: widget.creCheId, village_id: widget.village_id));
      } else
        tabItem.add(EnrolledChildrenListedScreen(crecheId: widget.creCheId));
    }
    return tabItem;
  }

  tabController() {
    tabItems.clear();
    tabItems
        .add(Global.returnTrLable(labelControlls, CustomText.Enrolled, lng));
    tabItems
        .add(Global.returnTrLable(labelControlls, CustomText.NotEnroll, lng));
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
      CustomText.NotEnroll
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls = value);
    tabController();
  }
}
