import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/constants.dart';





class HouseHoldFieldsApiService {

  Future<Response> houseHoldFieldsData(String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/hh_meta');
    var headers = {'Authorization': token.trim()};
    Map<String, String> parameters = {
      'usr': username.trim().trim(),
      'pwd': pwd.trim().trim(),
    };
    try {
      var response = await http.post(url, headers: headers, body: parameters);
      return response;

    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }


  Future<Response> syncCrecheData(String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/creche_meta');
    var headers = {'Authorization': token.trim()};
    Map<String, String> parameters = {
      'usr': username.trim(),
      'pwd': pwd.trim(),
    };
    try {
      var response = await http.post(url, headers: headers, body: parameters);
      return response;

    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
}