import 'package:flutter/material.dart';
import 'package:shishughar/model/databasemodel/auth_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/apimodel/tabHeight_for_age_Boys_model.dart';
import '../../model/apimodel/tabHeight_for_age_Girls_model.dart';
import '../../model/apimodel/tabWeight_for_age_Boys _model.dart';
import '../../model/apimodel/tabWeight_for_age_Girls _model.dart';
import '../../model/apimodel/tabWeight_to_Height_Boys_model.dart';
import '../../model/apimodel/tabWeight_to_Height_Girls_model.dart';
import '../database_helper.dart';

class HeightWeightBoysGirlsHelper {
  Future<List<TabHeightforageBoysModel>> callHeightForAgeBoys() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query('tabHeightforAgeBoys');

    List<TabHeightforageBoysModel> tabHeightforageBoys = [];

    for (var element in result) {
      TabHeightforageBoysModel item =
          TabHeightforageBoysModel.fromJson(element);
      tabHeightforageBoys.add(item);
    }
    return tabHeightforageBoys;
  }

  Future<List<TabHeightforageBoysModel>> callHeightForAgeBoys35() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery('select * from tabHeightforAgeBoys where age_in_days>34');

    List<TabHeightforageBoysModel> tabHeightforageBoys = [];

    for (var element in result) {
      TabHeightforageBoysModel item =
          TabHeightforageBoysModel.fromJson(element);
      tabHeightforageBoys.add(item);
    }
    return tabHeightforageBoys;
  }

  Future<List<TabHeightforageGirlsModel>> callHeightForAgeGirls() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query('tabHeightforAgeGirls');

    List<TabHeightforageGirlsModel> tabHeightforAgeGirls = [];

    for (var element in result) {
      TabHeightforageGirlsModel item =
          TabHeightforageGirlsModel.fromJson(element);
      tabHeightforAgeGirls.add(item);
    }
    return tabHeightforAgeGirls;
  }
  Future<List<TabHeightforageGirlsModel>> callHeightForAgeGirls35() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery('select * from tabHeightforAgeGirls where age_in_days>34');

    List<TabHeightforageGirlsModel> tabHeightforAgeGirls = [];

    for (var element in result) {
      TabHeightforageGirlsModel item =
          TabHeightforageGirlsModel.fromJson(element);
      tabHeightforAgeGirls.add(item);
    }
    return tabHeightforAgeGirls;
  }

  Future<List<TabWeightforageBoysModel>> callWeightforAgeBoys() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query('tabWeightforAgeBoys');

    List<TabWeightforageBoysModel> tabWeightforAgeBoys = [];

    for (var element in result) {
      TabWeightforageBoysModel item =
          TabWeightforageBoysModel.fromJson(element);
      tabWeightforAgeBoys.add(item);
    }
    return tabWeightforAgeBoys;
  }
  Future<List<TabWeightforageBoysModel>> callWeightforAgeBoys35() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery('select * from tabWeightforAgeBoys where age_in_days>34');

    List<TabWeightforageBoysModel> tabWeightforAgeBoys = [];

    for (var element in result) {
      TabWeightforageBoysModel item =
          TabWeightforageBoysModel.fromJson(element);
      tabWeightforAgeBoys.add(item);
    }
    return tabWeightforAgeBoys;
  }

  Future<List<TabWeightforageBoysModel>> callWeightforAgeBoysIn(
      List<int> items) async {
    String itemDays = List.filled(items.length, '?').join(',');
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
      'SELECT * FROM tabWeightforAgeBoys WHERE  (age_in_days % 30 = 0 or age_in_days in ($itemDays)) and age_in_days > (3*12*30)',
    );

    List<TabWeightforageBoysModel> tabWeightforAgeBoys = [];

    for (var element in result) {
      TabWeightforageBoysModel item =
          TabWeightforageBoysModel.fromJson(element);
      tabWeightforAgeBoys.add(item);
    }
    return tabWeightforAgeBoys;
  }

  Future<List<TabWeightforageGirlsModel>> callWeightforAgeGirls() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query('tabWeightforAgeGirls');

    List<TabWeightforageGirlsModel> tabWeightforAgeGirls = [];

    for (var element in result) {
      TabWeightforageGirlsModel item =
          TabWeightforageGirlsModel.fromJson(element);
      tabWeightforAgeGirls.add(item);
    }
    return tabWeightforAgeGirls;
  }

  Future<List<TabWeightforageGirlsModel>> callWeightforAgeGirls35() async {
    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery('select * from tabWeightforAgeGirls where age_in_days>34');

    List<TabWeightforageGirlsModel> tabWeightforAgeGirls = [];

    for (var element in result) {
      TabWeightforageGirlsModel item =
      TabWeightforageGirlsModel.fromJson(element);
      tabWeightforAgeGirls.add(item);
    }
    return tabWeightforAgeGirls;
  }

  Future<List<TabWeightforageGirlsModel>> callWeightforAgeGirlsIn(
      List<int> items) async {
    String itemDays = List.filled(items.length, '?').join(',');
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
      'SELECT * FROM tabWeightforAgeGirls WHERE  (age_in_days % 30 = 0 or age_in_days in ($itemDays)) and age_in_days > (3*12*30)',
    );

    List<TabWeightforageGirlsModel> tabWeightforAgeGirls = [];

    for (var element in result) {
      TabWeightforageGirlsModel item =
          TabWeightforageGirlsModel.fromJson(element);
      tabWeightforAgeGirls.add(item);
    }
    return tabWeightforAgeGirls;
  }

  Future<List<TabWeightToHeightBoysModel>> callWeightToHeightBoys() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query('tabWeightToHeightBoys');

    List<TabWeightToHeightBoysModel> tabWeightToHeightBoys = [];

    for (var element in result) {
      TabWeightToHeightBoysModel item =
          TabWeightToHeightBoysModel.fromJson(element);
      tabWeightToHeightBoys.add(item);
    }
    return tabWeightToHeightBoys;
  }
  Future<List<TabWeightToHeightBoysModel>> callWeightToHeightBoys24Or0() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery('select * from tabWeightToHeightBoys where (age_type = 0 AND length < 65) OR (age_type = 24 AND length >= 65)');

    List<TabWeightToHeightBoysModel> tabWeightToHeightBoys = [];

    for (var element in result) {
      TabWeightToHeightBoysModel item =
          TabWeightToHeightBoysModel.fromJson(element);
      tabWeightToHeightBoys.add(item);
    }
    return tabWeightToHeightBoys;
  }

  Future<List<TabWeightToHeightBoysModel>> callWeightToHeightBoys24() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query('tabWeightToHeightBoys');

    List<TabWeightToHeightBoysModel> tabWeightToHeightBoys = [];

    for (var element in result) {
      TabWeightToHeightBoysModel item =
          TabWeightToHeightBoysModel.fromJson(element);
      tabWeightToHeightBoys.add(item);
    }
    return tabWeightToHeightBoys;
  }

  Future<List<TabWeightToHeightGirlsModel>> callWeightToHeightGirls() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query('tabWeightToHeightGirls');

    List<TabWeightToHeightGirlsModel> tabWeightToHeightGirls = [];

    for (var element in result) {
      TabWeightToHeightGirlsModel item =
          TabWeightToHeightGirlsModel.fromJson(element);
      tabWeightToHeightGirls.add(item);
    }
    return tabWeightToHeightGirls;
  }


  Future<List<TabWeightToHeightGirlsModel>> callWeightToHeightGirls24Or0() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery('select * from tabWeightToHeightGirls WHERE (age_type = 0 AND length < 65) OR (age_type = 24 AND length >= 65)');

    List<TabWeightToHeightGirlsModel> tabWeightToHeightGirls = [];

    for (var element in result) {
      TabWeightToHeightGirlsModel item =
          TabWeightToHeightGirlsModel.fromJson(element);
      tabWeightToHeightGirls.add(item);
    }
    return tabWeightToHeightGirls;
  }


  Future<void> insertHeightForAgeBoys(
      List<TabHeightforageBoysModel> heightforageBoys) async {
    await DatabaseHelper.database!.delete('tabHeightforAgeBoys');
    if (heightforageBoys.isNotEmpty) {
      try {
        await DatabaseHelper.database!.transaction((txn) async {
          const int batchSize = 500;
          for (int i = 0; i < heightforageBoys.length; i += batchSize) {
            Batch batch = txn.batch();

            List<TabHeightforageBoysModel> batchItems =
                heightforageBoys.sublist(
                    i,
                    (i + batchSize > heightforageBoys.length)
                        ? heightforageBoys.length
                        : (i + batchSize));

            for (TabHeightforageBoysModel items in batchItems) {
              batch.insert('tabHeightforAgeBoys', items.toJson());
            }

            await batch.commit(noResult: true);
          }
          // for (var elements in heightforageBoys) {
          //   await txn.insert('tabHeightforAgeBoys', elements.toJson());
          // }
        });
      } on Exception catch (e) {
        // TODO
        debugPrint("Error inserting Boys height for age records ==> $e");
      }
      // for (var element in heightforageBoys) {
      //   await DatabaseHelper.database!
      //       .insert('tabHeightforAgeBoys', element.toJson());
      // }
    }
  }

  Future<void> insertHeightForAgeGirls(
      List<TabHeightforageGirlsModel> heightforageGirls) async {
    // Clear the table before insertion
    await DatabaseHelper.database!.delete('tabHeightforAgeGirls');

    if (heightforageGirls.isNotEmpty) {
      try {
        await DatabaseHelper.database!.transaction((txn) async {
          const int batchSize = 500;

          for (int i = 0; i < heightforageGirls.length; i += batchSize) {
            // Create a batch for the current chunk
            Batch batch = txn.batch();

            // Get the current batch slice
            List<TabHeightforageGirlsModel> batchItems =
                heightforageGirls.sublist(
              i,
              (i + batchSize > heightforageGirls.length)
                  ? heightforageGirls.length
                  : i + batchSize,
            );

            // Add each item to the batch
            for (var item in batchItems) {
              batch.insert('tabHeightforAgeGirls', item.toJson());
            }

            // Commit the batch
            await batch.commit(noResult: true);
          }
          // for (var elements in heightforageGirls) {
          //   await txn.insert('tabHeightforAgeGirls', elements.toJson());
          // }
        });
      } on Exception catch (e) {
        // TODO
        debugPrint("Error inserting Girls height for age records ==> $e");
      }
    }
  }

  Future<void> insertWeightToHeightBoys(
      List<TabWeightToHeightBoysModel> weightHeightBoys) async {
    await DatabaseHelper.database!.delete('tabWeightToHeightBoys');
    if (weightHeightBoys.isNotEmpty) {
      try {
        await DatabaseHelper.database!.transaction((txn) async {
          int batchSize = 500;
          for (int i = 0; i < weightHeightBoys.length; i += batchSize) {
            Batch batch = txn.batch();
            List<TabWeightToHeightBoysModel> batchItems =
                weightHeightBoys.sublist(
                    i,
                    ((i + batchSize) > weightHeightBoys.length)
                        ? weightHeightBoys.length
                        : (i + batchSize));
            for (TabWeightToHeightBoysModel items in batchItems) {
              batch.insert('tabWeightToHeightBoys', items.toJson());
            }

            await batch.commit(noResult: true);
          }
          // for (var element in weightHeightBoys) {
          //   await txn.insert('tabWeightToHeightBoys', element.toJson());
          // }
        });
      } on Exception catch (e) {
        // TODO
        debugPrint("Error inserting Boys weight for height records ==> $e");
      }
      // for (var element in weightHeightBoys) {
      //   await DatabaseHelper.database!
      //       .insert('tabWeightToHeightBoys', element.toJson());
      // }
    }
  }

  Future<void> insertWeightToHeightGirls(
      List<TabWeightToHeightGirlsModel> weightHeightGirls) async {
    await DatabaseHelper.database!.delete('tabWeightToHeightGirls');
    if (weightHeightGirls.isNotEmpty) {
      try {
        await DatabaseHelper.database!.transaction((txn) async {
          int batchSize = 500;
          for (int i = 0; i < weightHeightGirls.length; i += batchSize) {
            Batch batch = txn.batch();
            List<TabWeightToHeightGirlsModel> batchItems =
                weightHeightGirls.sublist(
                    i,
                    ((i + batchSize) > weightHeightGirls.length)
                        ? weightHeightGirls.length
                        : (i + batchSize));
            for (TabWeightToHeightGirlsModel items in batchItems) {
              batch.insert('tabWeightToHeightGirls', items.toJson());
            }

            await batch.commit(noResult: true);
          }
          // for (var element in weightHeightGirls) {
          //   await txn.insert('tabWeightToHeightGirls', element.toJson());
          // }
        });
      } on Exception catch (e) {
        // TODO
        debugPrint("Error inserting Girls weight to height records ==> $e");
      }
      // for (var element in weightHeightGirls) {
      //   await DatabaseHelper.database!
      //       .insert('tabWeightToHeightGirls', element.toJson());
      // }
    }
  }

  Future<void> insertWeightForAgeBoys(
      List<TabWeightforageBoysModel> weightForAgeBoys) async {
    await DatabaseHelper.database!.delete('tabWeightforAgeBoys');
    if (weightForAgeBoys.isNotEmpty) {
      try {
        await DatabaseHelper.database!.transaction((txn) async {
          int batchSize = 500;
          for (int i = 0; i < weightForAgeBoys.length; i += batchSize) {
            Batch batch = txn.batch();
            List<TabWeightforageBoysModel> batchItems =
                weightForAgeBoys.sublist(
                    i,
                    ((i + batchSize) > weightForAgeBoys.length
                        ? weightForAgeBoys.length
                        : (i + batchSize)));
            for (TabWeightforageBoysModel items in batchItems) {
              batch.insert('tabWeightforAgeBoys', items.toJson());
            }

            await batch.commit(noResult: true);
          }
          // for (var element in weightForAgeBoys) {
          //   await txn.insert('tabWeightforAgeBoys', element.toJson());
          // }
        });
      } on Exception catch (e) {
        // TODO
        debugPrint("Error inserting Boys weight for age records ==> $e");
      }
      // for (var element in weightForAgeBoys) {
      //   await DatabaseHelper.database!
      //       .insert('tabWeightforAgeBoys', element.toJson());
      // }
    }
  }

  Future<void> insertWeightForAgeGirls(
      List<TabWeightforageGirlsModel> weightHeightGirls) async {
    await DatabaseHelper.database!.delete('tabWeightforAgeGirls');
    if (weightHeightGirls.isNotEmpty) {
      try {
        await DatabaseHelper.database!.transaction((txn) async {
          int batchSize = 500;
          for (int i = 0; i < weightHeightGirls.length; i += batchSize) {
            Batch batch = txn.batch();
            List<TabWeightforageGirlsModel> batchItems =
                weightHeightGirls.sublist(
                    i,
                    ((i + batchSize) > weightHeightGirls.length
                        ? weightHeightGirls.length
                        : (i + batchSize)));
            for (TabWeightforageGirlsModel items in batchItems) {
              batch.insert('tabWeightforAgeGirls', items.toJson());
            }

            await batch.commit(noResult: true);
          }
          // for (var element in weightHeightGirls) {
          //   await txn.insert('tabWeightforAgeGirls', element.toJson());
          // }
        });
      } on Exception catch (e) {
        // TODO
        debugPrint("Error inserting Girls Weight for age records ==> $e");
      }
      // for (var element in weightHeightGirls) {
      //   await DatabaseHelper.database!
      //       .insert('tabWeightforAgeGirls', element.toJson());
      // }
    }
  }
}
