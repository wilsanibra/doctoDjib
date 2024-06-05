import 'dart:convert';

import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/models/doctors.dart';
import 'package:doctolib/services/user_service.dart';
/* import 'package:flutter/material.dart'; */
import 'package:http/http.dart' as http;

Future<ApiResponse> listeDoctors() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(listDoctorsUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['doctors']
            .map((d) => Doctors.fromJson(d))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// listSearchDoctorsUrl

Future<ApiResponse> listeSearchDoctors(String nomDoctor) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$listSearchDoctorsUrl/$nomDoctor'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        print("eto");
        print(
            '${jsonDecode(response.body).map((p) => Doctors.fromJson(p)).toList()}');
        apiResponse.data = jsonDecode(response.body)
            .map((p) => DoctorsSearch.fromJson(p))
            .toList();
        // apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 404:
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

Future<ApiResponse> getAllPatient(idDoctor) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$getAllPatientDoctors/$idDoctor'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        // print('${jsonDecode(response.body)['doctors']}');
        apiResponse.data = jsonDecode(response.body)['patients']
            .map((p) => Doctors.fromJson(p))
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

Future<ApiResponse> getPationsSearch(String date) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$listSearchPatientUrl/$date'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        // print('${jsonDecode(response.body)['patient']}');
        apiResponse.data = jsonDecode(response.body)['patient']
            .map((p) => Doctors.fromJson(p))
            .toList();
        // apiResponse.data =
        //     jsonDecode(response.body)['patient'].map((p) => print(p));
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 404:
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
