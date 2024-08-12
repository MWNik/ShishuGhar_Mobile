import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:shishughar/utils/constants.dart';
import 'package:shishughar/utils/validate.dart';

class ChangePaswordApiService {
  Future<Response> getChangePaswordApi(String newPass,String oldPass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString(Validate.appToken)!;
    String userName = prefs.getString(Validate.userName)!;
    final String apiUrl = '${Constants.baseUrl}method/change_password';

    final headers = {
      'Authorization': token,
    };
    final body = {"usr": userName, "pwd": oldPass, "npwd": newPass};
    try {
      final response =
          await http.post(Uri.parse(apiUrl), body: body, headers: headers);
      print('Error: ${response.body}');
      return response;
    } catch (error) {
      print('Error: $error');
      return Response('Internal server error - $error', 500);
    }
  }
}
