
import 'package:http/http.dart' as http;

import '../utils/constants.dart';


import '../utils/validate.dart';

class ChildHealthUploadApi {
  Future<http.Response> childHealthUpload(String token, String responce) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Child Health');
    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      await Validate().createUploadedJson("Token $token\n\n$responce");
      var response = await http.post(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading child profile data', 500);
    }
  }

  Future<http.Response> childHealthUploadUpdate(
      String token, String responce, int? name) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Child Health/$name');
    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      await Validate().createUploadedJson("Token $token\n\n$responce");
      var response = await http.put(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading child profile data', 500);
    }
  }
}
