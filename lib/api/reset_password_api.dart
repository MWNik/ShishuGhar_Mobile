import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shishughar/utils/constants.dart';

class ResetPaswordScreenApiService {
  Future<Response> getResetPaswordScreenApi(String userName) async {

    final String apiUrl =
        '${Constants.baseUrl}method/frappe.core.doctype.user.user.reset_password';
    final body = {
      "user": userName.trim(),
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),body:body
      );
      print('Error: ${response.body}');
      return response;
    } catch (error) {
      print('Error: $error');
      return Response('Internal server error - $error', 500);
    }
  }
}
