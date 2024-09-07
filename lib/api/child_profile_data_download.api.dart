import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class ChilProfileDataDownloadApi {
  Future<Response> childProfileDataDownload(
      String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/child_profile_data');
    var headers = {'Authorization': token};
    Map<String, String> parameters = {
      'usr': username,
      'pwd': pwd,
    };
    try {

      var responce = await http.post(url, headers: headers, body: parameters);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }
}
