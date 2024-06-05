import 'package:flutter/material.dart';

// const baseUrl = 'http://192.168.88.30:8000/api';
// const baseUrl = 'http://172.20.10.8:8000/api';
const baseUrl = 'http://127.0.0.1:8000';
const loginUrl = '$baseUrl/login';
const registerDoctoUrl = '$baseUrl/registerDocto';
const registerUrl = '$baseUrl/register';
const logoutUrl = '$baseUrl/logout';
const userUrl = '$baseUrl/user';
const UpdateUserUrl = '$baseUrl/updateUsers';
const appointmentUrl = '$baseUrl/appointment';
const listDoctorsUrl = '$baseUrl/listMedecin';
const listAppointmentUrl = '$baseUrl/appointmentList';
const appointmentListModalUrl = '$baseUrl/appointmentListModal';
const updateappointmentListModalUrl = '$baseUrl/updateAppointmentClientDialog';
const listAppointmentClientForDoctorsUrl = '$baseUrl/getAppointmentDoctors';
const getEntAttenteAppointmentDoctorsUrl =
    '$baseUrl/getEntAttenteAppointmentDoctors';
const acceptAppointmentUrl = '$baseUrl/updateAcceptAppointment';
const annulAppointmentUrl = '$baseUrl/updateAnnuleAppointment';

const getAllPatientDoctors = '$baseUrl/listsPatient';

const listSearchDoctorsUrl = '$baseUrl/listSearchMedecin';
const listSearchPatientUrl = '$baseUrl/searchPatientDoctor';
// --- Agenda ----
const storeAgendaUrl = '$baseUrl/agenda';
const getAgendaTimeUrl = '$baseUrl/agendaTime';
const getAllUsersUrl = '$baseUrl/allUsers';
const listeAgendaMedecin = '$baseUrl/listeAgendaMedecin';
const deleteAgendaMedecinUrl = '$baseUrl/deleteAgenda';
const updateAgendaStatusUrl = '$baseUrl/updateStatus';

// --- Appointment
const getAllAppointmentDoctorsUrl = '$baseUrl/allAppointment';
const getAllAppointmentClientsUrl = '$baseUrl/allAppointmentClients';
const deleteUrl = '$baseUrl/delete';
const AllDetailUsersUrl = '$baseUrl/usersdetail';
const getregisterAndAppointmentUrl = '$baseUrl/registerAndAppointment';
// --- Comment ---
const AllCommentsUrl = '$baseUrl/comment';
const StoreCommentUrl = '$baseUrl/storecomment';
const updateCommentUrl = '$baseUrl/updatecomment';
const DeleteCommentUrl = '$baseUrl/deleteComment';

// -- Statistiques ----
const getStatUrl = '$baseUrl/statistique';

// ----- Like ------
const likeOrUnlikeUrl = '$baseUrl/like';
const countlikeUrl = '$baseUrl/numberslike';

// ----- cabinet -----
const getAllCabinetUrl = '$baseUrl/getCabinet';
const storeCabinetUrl = '$baseUrl/storeCabinet';
const deleteCabinetUrl = '$baseUrl/destroyCabinet';

// ----- fiches -----
const urlgetAllfichePatients = '$baseUrl/fetchFichePatient';
const urlgetAllficheforPatients = '$baseUrl/fetchFicheForPatient';
const urlsotrefichePatients = '$baseUrl/sotrefiche';
const urlsearchfichePatients = '$baseUrl/searchFiches';

//  ------ Error -----
const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again !';
const bleu = Color(0xFF36A793);
const grey = Colors.white70;
const Color myColor = Colors.white;
