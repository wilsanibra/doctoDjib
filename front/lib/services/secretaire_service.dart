import 'dart:convert';

import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/models/secretaire.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> storeAppointmentSecretary(
  String name,
  String address,
  String number,
  String email,
  String password,
  String specialty,
  String date,
  String time,
  String motif,
  String id_doctor,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(getregisterAndAppointmentUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'name': name,
        'address': address,
        'number': number,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'specialty': specialty,
        'date': date,
        'time': time,
        'motif': motif,
        'id_doctor': id_doctor,
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Secretaire.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors[errors.keys.elementAt(0)];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
