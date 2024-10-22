import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';
import 'dart:convert';

import '../utils/validate.dart';

class ChildEnrolledExitApi {

  Future<Response> callChildEnrolledExitMetaApi(
      String username, String pwd, String token) async {
    var endurl = '${Constants.baseUrl}method/child_enrollment_and_exit_meta';
    var headers = {'Authorization': token};
    Map<String, String> body = {"usr": username, "pwd": pwd};
    var response =
        await http.post(Uri.parse(endurl), headers: headers, body: body);
    print(response.body);
    try {
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
    Future<Response> callChildEnrolledExitDownloadApi(
      String username, String pwd, String token) async {
    var endurl = '${Constants.baseUrl}method/child_enrollment_and_exit_data';
    var headers = {'Authorization': token};
    Map<String, String> body = {"usr": username, "pwd": pwd};
    try {
      var response =
          await http.post(Uri.parse(endurl), headers: headers, body: body);
      print(response.body);
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
   Future<Response> callChildEnrolledExitDownloadApiCC(String blockId,
      String username, String pwd, String token) async {
    var endurl = '${Constants.baseUrl}method/child_enrollment_and_exit_data_village';
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    List<int> integerList = blockId.split(',').map(int.parse).toList();
    Map<String, dynamic> body = {'village_id': integerList,"usr": username, "pwd": pwd};
    try {
      var response =
          await http.post(Uri.parse(endurl), headers: headers, body: jsonEncode(body));
      print(response.body);
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
  Future<http.Response> enrollExitChildUpload(
      String token, String responce) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Child Enrollment and Exit');

    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      await Validate().createUploadedJson("Token $token\n\n$json");
      var response = await http.post(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading enrollchildExit data', 500);
    }
  }
  Future<http.Response> enrollExitChildUpdate(
      String token, String responce, int? id) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Child Enrollment and Exit/$id');

    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');
    Map<String, dynamic> responseMap = jsonDecode(responce);
    responseMap.remove('owner');
    responseMap.remove('creation');
    responseMap.remove('modified');
    var responseJs = jsonEncode(responseMap);

    try {
      await Validate().createUploadedJson("Token $token\n\n$json");
      var response = await http.put(url, body: responseJs, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading enrollchildExit data', 500);
    }
  }
}
