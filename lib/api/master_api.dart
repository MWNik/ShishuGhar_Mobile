import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/constants.dart';





class MasterApiService {
  Future<Response> fetchmasterData(String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/master_data');
    var headers = {'Authorization': token.trim()};
    final body = {
      "usr": username.trim(),
      "pwd": pwd.trim()
    };
    try {
      var response = await http.post(url, headers: headers, body: body);
      print('master data : ${response.body}.');
      return response;

    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> fetchmasterOtherData(String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/master_data_other');
    var headers = {'Authorization': token.trim()};
    final body = {
      "usr": username.trim(),
      "pwd": pwd.trim()
    };
    try {
      var response = await http.post(url, headers: headers, body: body);
      print('master data other : ${response.body}.');
      return response;

    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }


  Future<Response> backdatedConfigiration(String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/backdated_configiration');
    var headers = {'Authorization': token.trim()};
    final body = {
      "usr": username.trim(),
      "pwd": pwd.trim()
    };
    try {
      var response = await http.post(url, headers: headers, body: body);
      print('master data other : ${response.body}.');
      return response;

    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
}