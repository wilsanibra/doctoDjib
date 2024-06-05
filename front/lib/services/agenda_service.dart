import 'dart:convert';

import 'package:doctolib/models/agenda.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../models/api_response.dart';

Future<ApiResponse> storeAgendaMedecin(
  String date,
  String time,
  String endtime,
  String id_doctor,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(storeAgendaUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'date': date,
        'time': time,
        'end_time': endtime,
        'id_doctor': id_doctor,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = Agenda.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = jsonDecode(response.body)['message'];
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Future<ApiResponse> ListeAgendaMedecin() async {
//   ApiResponse apiResponse = ApiResponse();
//   try {
//     String token = await getToken();
//     final response = await http.post(
//       Uri.parse(storeAgendaUrl),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     switch (response.statusCode) {
//       case 200:
//         apiResponse.data =
//             jsonDecode(response.body).map((d) => Agenda.fromJson(d)).toList();
//         apiResponse.data as List<dynamic>;
//         break;
//       case 401:
//         apiResponse.error = unauthorized;
//         break;
//       default:
//         apiResponse.error = somethingWentWrong;
//     }
//   } catch (e) {
//     apiResponse.error = serverError;
//   }
//   return apiResponse;
// }

Future<ApiResponse> getTimeDate(
  String dates,
  String id_doctor,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$getAgendaTimeUrl/$dates/$id_doctor'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['time']
            .map((d) => Agenda.fromJson(d))
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

Future<ApiResponse> listAgendasDoctors(int idDoctor) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$listeAgendaMedecin/$idDoctor'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        // print('${jsonDecode(response.body)['agendas']}');
        apiResponse.data = jsonDecode(response.body)['agendas']
            .map((a) => Agenda.fromJson(a))
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

Future<ApiResponse> deleteAgendaDoctors(int idAgenda) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$deleteAgendaMedecinUrl/$idAgenda'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['messages'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// update status agenda
// Future<ApiResponse> updateStatus(int idAgenda) async {
//   ApiResponse apiResponse = ApiResponse();
//   try {
//     String token = await getToken();
//     final response = await http.put(
//       Uri.parse('$updateAgendaStatusUrl/$idAgenda'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     switch (response.statusCode) {
//       case 200:
//         apiResponse.data = jsonDecode(response.body)['message'];
//         break;
//       case 401:
//         apiResponse.error = unauthorized;
//         break;
//       default:
//         apiResponse.error = somethingWentWrong;
//     }
//   } catch (e) {
//     apiResponse.error = serverError;
//   }
//   return apiResponse;
// }
