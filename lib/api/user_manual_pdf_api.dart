import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shishughar/utils/constants.dart';

class UserManualApi {
   Future<Response> callUserManualMeta(
      String username, String pwd, String token) async {
    var endurl = '${Constants.baseUrl}method/user_manual_meta';
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
  Future<Response> userManualDownloadApi(
      String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/user_manual_data');
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
}
