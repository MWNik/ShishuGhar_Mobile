import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/model/databasemodel/tab_image_file_model.dart';
import 'package:sqflite/sqflite.dart';

class ImageFileTabHelper {
  Future<void> inserts(ImageFileTabResponceModel items) async {
    await DatabaseHelper.database!.insert('tab_image_file', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertUpdate(
    String? img_guid,
    String? field_name,
    String? doctype,
    String? doctype_guid,
    String? child_doctype_guid,
    String? image_name,
    int? is_edited,
    String? created_at,
    String? created_by,
    String? update_at,
    String? updated_by,
    int? is_uploaded,
  ) async {
    var item = ImageFileTabResponceModel(
        img_guid: img_guid,
        field_name: field_name,
        doctype: doctype,
        doctype_guid: doctype_guid,
        child_doctype_guid: child_doctype_guid,
        image_name: image_name,
        is_uploaded: 0,
        is_edited: 1,
        created_by: created_by,
        created_at: created_at,
        update_at: update_at,
        updated_by: updated_by);
    await DatabaseHelper.database!.insert('tab_image_file', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ImageFileTabResponceModel>> getImageForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from tab_image_file where is_edited=1 and name NOTNULL');
    List<ImageFileTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ImageFileTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ImageFileTabResponceModel>> getImageByDoctypeId(
      String doctype_guid, String doctype) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_image_file where doctype=? and doctype_guid=?',
        [doctype, doctype_guid]);
    List<ImageFileTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ImageFileTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ImageFileTabResponceModel>> getImageByDoctypeIdAndImbeNotNull(
      String doctype_guid, String doctype) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_image_file where doctype=? and doctype_guid=? and name ISNULL ',
        [doctype, doctype_guid]);
    List<ImageFileTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ImageFileTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateImageOnlyItem(ImageFileTabResponceModel items) async {
    var doctype_guid = items.doctype_guid;
    var doctype = items.doctype;

    // var attachedField = item['attached_to_field'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE tab_image_file SET image_name = ?  , is_edited=1 where  doctype=? and doctype_guid=? ',
        [
          doctype,
          doctype_guid,
        ]);
  }

  Future<void> deleteImageFile(String doctype, String doctype_guid) async {

    await DatabaseHelper.database?.delete(
      'tab_image_file',
      where: "doctype = ? AND doctype_guid = ?",
      whereArgs: [doctype, doctype_guid],
    );
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var message = item['message'];
    var fileName = message['file_name'];
    var fileUrl = message['file_url'];
    var attachedName = message['attached_to_name'];
    var attachedDoctype = message['attached_to_doctype'];
    var attachedDoctypeGuid = message['doctype_guid'];
    var attachedField = message['attached_to_field'];
    // var attachedField = item['attached_to_field'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE tab_image_file SET   is_uploaded=1 , is_edited=0 where  doctype=? and doctype_guid=? ',
        [
          attachedDoctype,
          attachedDoctypeGuid,
        ]);
  }

  Future<void> updateNameForUpload(
      Map<String, dynamic> item, String name) async {
    var nameField = name;
    var doctypeGuidField = item['childenrollguid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE tab_image_file SET name = ?   where name is Null and doctype_guid=?',
        [nameField, doctypeGuidField]);
  }
}
