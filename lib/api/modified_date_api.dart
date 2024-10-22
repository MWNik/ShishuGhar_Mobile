import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/model/apimodel/modifiedDate_apiModel.dart';
import 'package:shishughar/utils/validate.dart';

import '../utils/constants.dart';

class ModifiedDateApiService {
  Future<Response> getModifiedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString(Validate.appToken)!;
    String userName = prefs.getString(Validate.userName)!;
    String password = prefs.getString(Validate.Password)!;

    final String apiUrl = '${Constants.baseUrl}method/modified_date';

    final headers = {
      'Authorization': token,
    };
    final body = {"usr": userName, "pwd": password};
    try {
      final response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: body);
      print(response.body);
      return response;
    } catch (e) {
      print("Error: $e");
      return Response("Internal server eroor - $e", 500);
    }
  }
}
