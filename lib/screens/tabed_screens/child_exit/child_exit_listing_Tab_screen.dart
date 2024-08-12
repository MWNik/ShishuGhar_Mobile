import 'package:flutter/material.dart';
import 'package:shishughar/database/helper/creche_helper/creche_data_helper.dart';
import 'package:shishughar/model/apimodel/creche_database_responce_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/screens/tabed_screens/child_exit/exit_enrolld_child/children_exit_enrolled_listed_screen.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import 'exited_child_listing_screen.dart';



class ChildExitListingTabScreen extends StatefulWidget {
  final String creche_id;

  ChildExitListingTabScreen({super.key,
    required this.creche_id,
  });

  @override
  State<ChildExitListingTabScreen> createState() =>
      _ChildExitListingTabScreenState();
}

class _ChildExitListingTabScreenState extends State<ChildExitListingTabScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  String? creche_name;
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
            title: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Global.returnTrLable(
                              translats, CustomText.child_exit, lng!),
                          style: Styles.white145,
                        ),
                        Text(
                          creche_name ?? '',
                          style: Styles.white126P,
                        ),
                        // Add additional TextSpans here if needed
                      ],
                    ),
                  )
                ],
              ),
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
                      Global.returnTrLable(translats, CustomText.enrolled, lng),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff369A8D),
                  width: double.infinity,
                  child: Tab(
                      child: Text(
                    Global.returnTrLable(translats, CustomText.child_exited, lng),
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
        tabItem.add(ExitedChildListingScreen(
          creche_id: widget.creche_id,
        ));
      } else
        tabItem.add(EnrolledExitChildrenListedScreen(
            crecheId: Global.stringToInt(widget.creche_id)));
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
      CustomText.child_exit,
      CustomText.enrolled,
      CustomText.child_exited
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats = value);
    creche_rec = await CrecheDataHelper()
        .getCrecheResponceItem(Global.stringToInt(widget.creche_id));
    creche_name = Global.getItemValues(creche_rec[0].responces!, 'creche_name');
    tabController();
  }
}
