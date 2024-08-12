import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';



class FormLogicApiService {
  Future<Response> fetchLogicData(String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/forms_logic');
    var headers = {'Authorization': token};
    final body = {
      "usr": username.trim(),
      "pwd": pwd.trim()
    };
    try {
      var response = await http.post(url, headers: headers, body: body);
      return response;

    } catch (e) {
      return  Response('Internal server error - $e', 500);;
    }
  }

}