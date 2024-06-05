import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/models/like.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'user_service.dart';

Future<ApiResponse> likeUnlikeDoctors(int idDoctors) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$likeOrUnlikeUrl/$idDoctors'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        // print('${response.body}');
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = serverError;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> getCountLikes(int idDoctors) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$countlikeUrl/$idDoctors'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        // print("${Likes.fromJson(jsonDecode(response.body))}");
        // print("ato");
        apiResponse.data = Likes.fromJson(jsonDecode(response.body));
        break;
      default:
    }
  } catch (e) {}
  return apiResponse;
}
