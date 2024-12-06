import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/validate.dart';

class ChildGrievanceUploadApi {
  Future<http.Response> childGrievanceUpload(
      String token, String responce) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Grievance');
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

  Future<http.Response> childGrievanceUploadUpdate(
      String token, String responce, int? name) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Grievance/$name');
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
