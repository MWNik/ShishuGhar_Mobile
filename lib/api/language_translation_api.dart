
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/constants.dart';

class TranslationService {
  Future<Response> translateApi(String userName, String password,
      String token) async {
    final String apiUrl =
        '${Constants.baseUrl}method/language_translation';

    final Map<String, String> data = {
      'usr': userName.trim(),
      'pwd': password.trim(),
    };

    final headers = {
      'Authorization': token.trim(),
    };

    try {
      var response = await http.post(
          Uri.parse(apiUrl), headers: headers, body: data);
      print('translation_: ${response.body}.');
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
}
