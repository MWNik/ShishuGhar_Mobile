import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class LoginApiService {
  var endurl = '${Constants.baseUrl}method/frappe.val.api.login';
  Future<Response> loginUser(
      String username, String pwd) async {

    final body = {
      "usr": username.trim(),
      "pwd": pwd.trim()
    };

    try {
      var response = await http.post(Uri.parse(endurl), body: body);
        print(response.body);
      return response;

    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
}
