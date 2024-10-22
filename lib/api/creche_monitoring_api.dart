import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shishughar/utils/constants.dart';

import '../utils/validate.dart';

class CrecheMonitoringApi {
  /// Get Check List Data
  Future<http.Response> getCheckListData({
    required String username,
    required String password,
    required String appToken,
  }) async {
    try {
      final endUrl =
          "${Constants.baseUrl}method/creche_monitoring_checklist_data";

      final body = <String, String>{"usr": username, "pwd": password};

      final headers = {"Authorization": appToken};

      final response =
          await http.post(Uri.parse(endUrl), headers: headers, body: body);

      print(response.body);
      return response;
    } catch (e) {
      debugPrint("$e");
      return http.Response('Internal server error - $e', 500);
    }
  }

  /// Get Meta Data
  Future<http.Response> getMetaData({
    required String username,
    required String password,
    required String appToken,
  }) async {
    try {
      final endUrl = "${Constants.baseUrl}method/creche_monitoring_meta";

      final body = <String, String>{"usr": username, "pwd": password};

      final headers = {"Authorization": appToken};

      final response =
          await http.post(Uri.parse(endUrl), headers: headers, body: body);

      debugPrint("Getting Creche Monitoring Meta Data from the API:");
      debugPrint(response.body);

      return response;
    } catch (e) {
      debugPrint("$e");
      return http.Response('Internal server error - $e', 500);
    }
  }

  /// Upload Check List
  Future<http.Response> uploadCheckList(
      {required String appToken, required String dataResponse}) async {
    try {
      final endUrl = "${Constants.baseUrl}resource/Creche Monitoring Checklist";

      // final Map<String, dynamic> body = jsonDecode(dataResponse);

      final headers = {"Authorization": appToken ,'Content-Type': 'application/json'};
      await Validate().createUploadedJson("Token $appToken\n\n$dataResponse");
      final response =
          await http.post(Uri.parse(endUrl), headers: headers, body: dataResponse);

      print("Creche Update : ${response.statusCode == 200}");

      return response;
    } catch (e) {
      debugPrint("$e");
      return http.Response('Internal server error - $e', 500);
    }
  }

  /// Upload Check List
  Future<http.Response> updateUploadedCheckList({
    required String appToken,
    required String dataResponse,
    required int name,
  }) async {
    try {
      final endUrl =
          "${Constants.baseUrl}resource/Creche Monitoring Checklist/$name";

      // final Map<String, dynamic> body = jsonDecode(dataResponse);

      final headers = {"Authorization": appToken, 'Content-Type': 'application/json'};
      await Validate().createUploadedJson("Token $appToken\n\n$dataResponse");
      final response =
          await http.put(Uri.parse(endUrl), headers: headers, body: dataResponse);

      print("CrecheUpload Update : ${response.statusCode == 200}");

      return response;
    } catch (e) {
      debugPrint("$e");
      return http.Response('Internal server error - $e', 500);
    }
  }
}
