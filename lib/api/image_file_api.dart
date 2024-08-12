import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shishughar/model/databasemodel/tab_image_file_model.dart';

import '../utils/constants.dart';

class ImageFileApi {
  Future<http.Response> ImageFileUpload(
      String token, ImageFileTabResponceModel record) async {
    var url = Uri.parse('${Constants.baseUrl}method/upload_file');

    var request = http.MultipartRequest('POST', url);

    // Get the app's directory
    final Directory appDirectory = await getApplicationDocumentsDirectory();

    // Get the "images" directory path
    final Directory imagesDirectory =
        Directory('${appDirectory.path}/shishughar_images/');

    // Add the file to the request
    var multipartFile = await http.MultipartFile.fromPath(
      'file', // This should be the field name expected by the server
      imagesDirectory.path + record.image_name!,
    );

    request.files.add(multipartFile);
    request.fields['doctype'] = record.doctype!;
    request.fields['fieldname'] = record.field_name!;
    request.fields['doctype_guid'] = record.doctype_guid!;
    request.fields['img_guid'] = record.img_guid!;
    request.fields['from_api'] = record.name!.toString();
    request.fields['docname'] = record.name!.toString();

    request.headers['Authorization'] = token;

    // print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      var sresponse = await request.send();
      print(sresponse);
      var response = await parseStreamedResponse(sresponse);
      print(response.body);
      print("try");
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading child profile data', 500);
    }
  }

  Future<http.Response> parseStreamedResponse(
      http.StreamedResponse streamedResponse) async {
    final responseBodyBytes = await streamedResponse.stream.toBytes();
    final responseBodyString = utf8.decode(responseBodyBytes);
    final response = http.Response(
      responseBodyString,
      streamedResponse.statusCode,
      headers: streamedResponse.headers,
    );
    return response;
  }
}
