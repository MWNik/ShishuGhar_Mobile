import 'package:flutter/material.dart';
import 'package:shishughar/model/apimodel/creche_database_responce_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/screens/tabed_screens/child_follow_up/schduled_followup_for_child.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../style/styles.dart';
import 'completed_followups_listing_screen_for_child.dart';

class FollowUpTabScreenForChild extends StatefulWidget {
  final String tabTitle;
  final String childenrollguid;
  final int creche_id;
  int? childNameId;
  final String childId;
  final String childName;

  FollowUpTabScreenForChild({
    super.key,
    required this.tabTitle,
    required this.childenrollguid,
    required this.creche_id,
    this.childNameId,
    required this.childId,
    required this.childName,
  });

  @override
  State<FollowUpTabScreenForChild> createState() => _FollowUpTabScreenState();
}

class _FollowUpTabScreenState extends State<FollowUpTabScreenForChild>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  List<String> tabItems = [];

  String lng = 'en';
  List<Translation> translats = [];
  List<CresheDatabaseResponceModel> creche_rec = [];
  int tabCount = 2;

  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, 'itemRefersh');
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Color(0xff5979AA),
            leading: Padding(
              padding: EdgeInsets.only(left: 10.0),
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
                RichText(
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: Text(
                        '${widget.childName}',
                        style: Styles.white145,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    WidgetSpan(
                      child: Text(
                        '-${widget.childId}',
                        style: Styles.white145,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ]),
                ),
                Text(
                  widget.tabTitle,
                  style: Styles.white126P,
                ),
              ],
            ),
            centerTitle: true,
            bottom: TabBar(
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
                      Global.returnTrLable(
                          translats, CustomText.schduleDate, lng),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff369A8D),
                  width: double.infinity,
                  child: Tab(
                      child: Text(
                    Global.returnTrLable(translats, CustomText.complted, lng),
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
              ))
            ],
          ),
        ),
      );
    }
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabCount; i++) {
      if (i == 1) {
        tabItem.add(CompletedChildFollowUpsForChildListingScreen(
          tabTitle: widget.tabTitle,
          childenrollguid: widget.childenrollguid,
          creche_id: widget.creche_id,
          childNameId: widget.childNameId,
          childId: widget.childId,
          childName: widget.childName,
        ));
      } else
        tabItem.add(SchudleFollowUpsForChildListingScreen(
          tabTitle: widget.tabTitle,
          childenrollguid: widget.childenrollguid,
          creche_id: widget.creche_id,
          childNameId: widget.childNameId,
          childId: widget.childId,
          childName: widget.childName,
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

  Future<void> initializeData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    translats.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back,
      CustomText.Submit,
      CustomText.schduleDate,
      CustomText.complted
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats = value);
    tabController();
  }
}
