import 'dart:convert';

import 'package:doctolib/constant.dart';
import 'package:doctolib/services/user_service.dart';
/* import 'package:flutter/material.dart'; */
import 'package:http/http.dart' as http;

import '../models/api_response.dart';
import '../models/appointment.dart';

// fonction for Store Appointments
Future<ApiResponse> storeAppointment(
  String date,
  String time,
  String motif,
  // String patient_record,
  String id_doctor,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(appointmentUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'date': date,
        'time': time,
        'motif': motif,
        // 'patient_record': patient_record,
        'id_doctor': id_doctor,
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Appointment.fromJson(jsonDecode(response.body));
        break;
      case 500:
        final error = jsonDecode(response.body)['message'];
        apiResponse.error = error[error.key.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// fontciont for getting appointmens client
Future<ApiResponse> getListAppointmentClient(
  int idclient,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$listAppointmentUrl/$idclient'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['AppointmentList']
            .map((d) => ListAppointment2.fromJson(d))
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

// fontciont for getting appointmens client in modal
Future<ApiResponse> getListAppointmentClientModal(
  int idclient,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$appointmentListModalUrl/$idclient'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['AppointmentList']
            .map((d) => ListAppointment2.fromJson(d))
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

// fontciont for updating appointmens client in modal
Future<ApiResponse> updateListAppointmentClientModal(
  int idclient,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse('$updateappointmentListModalUrl/$idclient'),
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

// fontcion for getting apointment doctors for admin
Future<ApiResponse> getAllApoinmentDocotors() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(getAllAppointmentDoctorsUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['all_appointments']
            .map((ad) => ListAppointment2.fromJson(ad))
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

// fontcion for getting apointment client for admin
Future<ApiResponse> AllAppoinmentClients() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(getAllAppointmentClientsUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['all_appointmentsClients']
            .map((ac) => ListAppointment2.fromJson(ac))
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

// fonction for getting appoitments client for doctors

Future<ApiResponse> getAppoitmentsClientForDoctors(int idDoctors) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse(
          '$listAppointmentClientForDoctorsUrl/$idDoctors',
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    switch (response.statusCode) {
      case 200:
        // print('${jsonDecode(response.body)['AppointmentList']}');
        apiResponse.data = jsonDecode(response.body)['AppointmentList']
            .map((d) => ListAppointment.fromJson(d))
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

// get appointment entattente
Future<ApiResponse> getEntAttenteAppointmentDoctors(int idDoctors) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse(
          '$getEntAttenteAppointmentDoctorsUrl/$idDoctors',
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    switch (response.statusCode) {
      case 200:
        // print('${jsonDecode(response.body)['AppointmentList']}');
        apiResponse.data = jsonDecode(response.body)['AppointmentList']
            .map((d) => ListAppointment2.fromJson(d))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error =
            jsonDecode(response.body)['AppointmentList']['message'];
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Update for attend in accpeter
Future<ApiResponse> acceptAppointment(int idAppointment) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse('$acceptAppointmentUrl/$idAppointment'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      default:
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// update for attend in annulation
Future<ApiResponse> annulAppointment(int idAppointment) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse('$annulAppointmentUrl/$idAppointment'),
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
