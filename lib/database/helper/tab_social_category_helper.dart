

import 'package:shishughar/model/databasemodel/tab_social_category_model.dart';

import '../database_helper.dart';

class TabSocialCategoryHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabSocialCategoryModel>> getItems(String lan) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabSocialCategory');

    List<TabSocialCategoryModel> items = [];

    for (var element in result) {
      TabSocialCategoryModel state = TabSocialCategoryModel.fromJson(element);
      items.add(state);
    }
    return items;
  }

  Future<void> inserts(
      List<TabSocialCategoryModel> items) async {
    await DatabaseHelper.database!.delete('tabSocialCategory');
    if (items.isNotEmpty) {
      for (var element in items) {
        await DatabaseHelper.database!.insert('tabSocialCategory', element.toJson());
      }
    }
  }

}
