import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class RequisitionApi {
  Future<Response> requisitionMetaApi(
      String username, String pwd, String token) async {
    var endurl = '${Constants.baseUrl}method/requisition_meta';
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

  Future<Response> requisitionDownloadApi(
      String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/requisition_data_download');
    var headers = {'Authorization': token};
    Map<String, String> parameters = {
      'usr': username,
      'pwd': pwd,
    };
    try {
      var responce = await http.post(url, headers: headers, body: parameters);
      print(responce.body);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> requisitionDownloadApiforCC(
      String villages, String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/requisition_data_download_village');
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    Map<String, String> parameters = {
      'usr': username,
      'pwd': pwd,
    };
    List<int> integerList = villages.split(',').map(int.parse).toList();
    Map<String, dynamic> body = {
      'village_id': integerList,
      "usr": username,
      "pwd": pwd
    };
    try {
      var responce =
          await http.post(url, headers: headers, body: jsonEncode(body));
      print(responce.body);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }

  Future<http.Response> requisitionUploadApi(
      String token, String responce) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Creche Requisition');

    var headers = {'Authorization': token};

    print('PARAMETER FOR STOCK DATA: $responce');

    try {
      var response = await http.post(url, body: responce, headers: headers);
      print(response.body);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading stockdata', 500);
    }
  }

  Future<http.Response> requisitionUpdateApi(
      String token, String responce, int? name) async {
    var url =
        Uri.parse('${Constants.baseUrl}resource/Creche Requisition/$name');
    var headers = {'Authorization': token};

    print('PARAMETER FOR STOCK DATA: $responce');

    try {
      var response = await http.put(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading stockdata', 500);
    }
  }
}
