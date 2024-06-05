import 'dart:convert';

import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/models/fiche.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getAllFiche(int idPatient) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse("$urlgetAllfichePatients/$idPatient"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['fiches']
            .map((f) => Fiches.fromJson(f))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 500:
        final error = jsonDecode(response.body)['message'];
        apiResponse.error = error[error.key.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> storeFiche(
  String antecedent,
  String prescription,
  String date,
  String userid,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse(urlsotrefichePatients), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    }, body: {
      'antecedent': antecedent,
      'prescription': prescription,
      'date': date,
      'user_id': userid,
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 500:
        final error = jsonDecode(response.body)['message'];
        apiResponse.error = error[error.key.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> getFichesSearch(date) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse("$urlsearchfichePatients/$date"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['fiches']
            .map((f) => Fiches.fromJson(f))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 500:
        final error = jsonDecode(response.body)['message'];
        apiResponse.error = error[error.key.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {}
  return apiResponse;
}
