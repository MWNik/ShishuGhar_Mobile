import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class ChildImmunizationMetaApi {
  Future<Response> callChildImmunizationMeta(
      String username, String pwd, String token) async {
    var endurl = '${Constants.baseUrl}method/Child_Immunization_meta';
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
}
