import 'dart:convert';

import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/models/statistique.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getStat(int idDoctor) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();

    final response = await http.post(
      Uri.parse("$getStatUrl?id_doctor=$idDoctor"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      // body: {
      //   "id_doctor": idDoctor,
      // },
    );
    switch (response.statusCode) {
      case 200:
        // print(
        //     "stat : ${apiResponse.data = Statistiques.fromJson(jsonDecode(response.body)['appointments'])}");
        apiResponse.data =
            Statistiques.fromJson(jsonDecode(response.body)['appointments']);
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

Future<ApiResponse> getStatFiltrer(
  int idDoctor,
  String date,
  String filter,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();

    final response = await http.post(
      Uri.parse("$getStatUrl?id_doctor=$idDoctor&filter=$filter&date=$date"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      // body: {
      //   "id_doctor": idDoctor,
      // },
    );
    switch (response.statusCode) {
      case 200:
        // print("stat : ${jsonDecode(response.body)['appointments']}");
        apiResponse.data =
            Statistiques.fromJson(jsonDecode(response.body)['appointments']);
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
