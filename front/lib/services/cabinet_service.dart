import 'dart:convert';

import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/models/cabinet.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:http/http.dart' as http;

// function to get All cabinet
Future<ApiResponse> getAllCabinet() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(getAllCabinetUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['cabinet']
            .map((c) => Cabinet.fromJson(c))
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

// function to store a new Cabinet

Future<ApiResponse> storeCabinet(
  String nomCab,
) async {
  ApiResponse apiResponse = ApiResponse();
  print('ato');
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(storeCabinetUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'nomCab': nomCab,
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Cabinet.fromJson(jsonDecode(response.body));
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

// function to delete cabinet
Future<ApiResponse> delete(int idCabinet) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$deleteCabinetUrl/$idCabinet'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
