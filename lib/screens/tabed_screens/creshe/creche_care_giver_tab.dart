
import 'package:flutter/material.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/creche_data_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'care_giver_screen_item.dart';

class CreheCareGiverTab extends StatefulWidget {
  final String CGGuid;
   String? minDate;
  final int parentName;
  final String crechedCode;
  final bool isEditable;

   CreheCareGiverTab({
    super.key,
    required this.CGGuid,
    required this.parentName,
    required this.crechedCode,
    required this.isEditable,
     this.minDate,
  });

  @override
  _CrecheCareGiverTabState createState() => _CrecheCareGiverTabState();
}

class _CrecheCareGiverTabState extends State<CreheCareGiverTab>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  List<Widget> tabTitleItem = [];
  List<String> tabBreakItems = [];
  Map<String, List<HouseHoldFielItemdModel>> itemScreenItems = {};
  bool _isLoading = true;
  String? role;
  String? lng;
  List<Translation> labelControlls = [];

  @override
  void initState() {
    super.initState();
    callScrenControllers(CustomText.crecheCaregiver);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              title: Text(
                lng != null
                    ? Global.returnTrLable(
                        labelControlls, CustomText.Creches, lng!)
                    : "",
                style: Styles.white145,
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

  Future<void> callScrenControllers(screen_type) async {
    List<HouseHoldFielItemdModel> allItems = [];
    role = await Validate().readString(Validate.role);
    await CrecheFieldHelper()
        .getCrecheFieldsForm(screen_type)
        .then((value) async {
      allItems = value;
    });
    tabBreakItems = [CustomText.crecheCaregiver];
    itemScreenItems[CustomText.crecheCaregiver] = allItems;

    await tabController().then((value) => _tabController =
        TabController(length: tabBreakItems.length, vsync: this));

    await setLabelTextData();
    setState(() {
      _isLoading = false;
    });
  }

  Future tabController() async {
    tabBreakItems.forEach((element) async {
      lng = await Validate().readString(Validate.sLanguage);
      var verifiLable = await TranslationDataHelper()
          .getTranslation(CustomText.crecheCaregiver, lng!);
      tabTitleItem.add(Tab(icon: Container(child: Text(verifiLable))));
    });
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    tabItem.add(CareGiverScreenItem(
        parentName: widget.parentName,
        crechedCode: widget.crechedCode,
        CGGuid: widget.CGGuid,
        tabBreakItem: tabBreakItems[0],
        screenItem: itemScreenItems,
        changeTab: changeTab,
        isEditable: widget.isEditable,
        minDate: widget.minDate,
        tabIndex: 0,
        totalTab: 1));
    return tabItem;
  }

  void changeTab(int index) {
    if (index == 0) {
      if (tabIndex > 0) {
        setState(() {
          tabIndex--;
          _tabController.animateTo(tabIndex);
        });
      }
    } else if (tabIndex < tabBreakItems.length - 1) {
      setState(() {
        tabIndex++;
        _tabController.animateTo(tabIndex);
      });
    }
  }

  Future<void> setLabelTextData() async {
    lng = await Validate().readString(Validate.sLanguage);
    List<String> valueNames = [CustomText.Creches];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls = value);
  }
}
