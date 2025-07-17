import 'package:flutter/material.dart';
import 'package:shishughar/database/helper/creche_helper/creche_data_helper.dart';
import 'package:shishughar/model/apimodel/creche_database_responce_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/screens/tabed_screens/stock/requisition/requisition_calender_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/stock/stock/stock_listing_screen.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
// import 'expences/cashbook_expenses_listing_screen.dart';

class StockTabListingScreen extends StatefulWidget {
  final String creche_id;

  StockTabListingScreen({super.key, required this.creche_id});

  @override
  State<StockTabListingScreen> createState() => _StockTabListingScreenState();
}

class _StockTabListingScreenState extends State<StockTabListingScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  String? creche_name;
  List<String> tabItems = [];

  String lng = 'en';
  List<Translation> translats = [];
  List<CresheDatabaseResponceModel> creche_rec = [];
  int tabCount = 2;
  double screenWidth = 0.0;
  double tabWidth = 100.0; // Approximate width of each tab
  bool tabIsScrollable = false;

  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    screenWidth = MediaQuery.of(context).size.width;
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SafeArea(
        child: WillPopScope(
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
                                translats, CustomText.Stock, lng),
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
                indicatorColor: Color(0xffF26BA3),
                unselectedLabelColor: Colors.grey.shade300,
                unselectedLabelStyle: Styles.white124P,
                labelColor: Colors.white,
                controller: _tabController,
                isScrollable: tabIsScrollable,
                labelPadding: EdgeInsets.zero,
                // tabAlignment: TabAlignment.start,
                tabAlignment: tabIsScrollable ? TabAlignment.start : null,
                tabs: [
                  Container(
                    // color: Color(0xff369A8D),
                    width: tabIsScrollable ? null : screenWidth / 2,
                    padding: EdgeInsets.only(
                        left: tabIsScrollable ? 10 : 0,
                        right: tabIsScrollable ? 10 : 0),
                    decoration: BoxDecoration(
                        color: Color(0xff369A8D),
                        border: Border(
                            right: BorderSide(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid))),
                    child: Tab(
                      child: Text(
                        Global.returnTrLable(translats, CustomText.Stock, lng),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    // color: Color(0xff369A8D),
                    width: tabIsScrollable ? null : screenWidth / 2,
                    padding: EdgeInsets.only(
                        left: tabIsScrollable ? 10 : 0,
                        right: tabIsScrollable ? 10 : 0),
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
                            translats, CustomText.requisition, lng),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
        ),
      );
    }
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabCount; i++) {
      if (i == 1) {
        tabItem.add(RequisitionCalenderListingScreen(
          creche_id: widget.creche_id,
        ));
      } else
        tabItem.add(StockListingScreen(creche_id: widget.creche_id));
    }
    return tabItem;
  }

  tabController() {
    _tabController = TabController(length: tabCount, vsync: this);
    tabIsScrollable = tabWidth * 2 > screenWidth;

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
      CustomText.Stock,
      CustomText.requisition
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
