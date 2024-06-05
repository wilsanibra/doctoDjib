<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AppointmentController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\AgendaController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\LikeController;
use App\Http\Controllers\CabinetController;
use App\Http\Controllers\StatistiqueController;
use App\Http\Controllers\FicheController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Route public
Route::post('register', [AuthController::class, 'register'])->name('register');
Route::post('registerDocto', [AuthController::class, 'registerDocto'])->name('registerDocto');
Route::post('login', [AuthController::class, 'login'])->name('login');

// protected routes
Route::group(['middleware' => ['auth:sanctum']], function () {
    // Logout route
    Route::post('logout', [AuthController::class, 'logout'])->name('logout');

    // user route
    Route::get('user', [AuthController::class, 'user'])->name('user');
    Route::get('allUsers', [HomeController::class, 'getAllUser'])->name('allUsers');
    Route::put('updateUsers', [AuthController::class, 'update'])->name('updateUsers');
    Route::get('delete/{id}', [HomeController::class, 'delete'])->name('delete');
    Route::get('usersdetail/{id}', [HomeController::class, 'getAllUsersDetail'])->name('usersdetail');
    Route::get('listMedecin', [HomeController::class, 'showListMedecin'])->name('listMedecin');
    Route::get('listSearchMedecin/{nameDoctor}', [HomeController::class, 'showListMedecinSearch'])->name('listSearchMedecin'); // listesPatients
    Route::get('listsPatient/{id}', [HomeController::class, 'listesPatients'])->name('listsPatient'); // SearchPatientWithDate
    Route::get('searchPatientDoctor/{date}', [HomeController::class, 'SearchPatientWithDate'])->name('listsPatient'); //

    // agenda Doctor route
    Route::post('agenda', [AgendaController::class, 'storeAgenda'])->name('agenda');
    Route::get('agendaTime/{date}/{id}', [AgendaController::class, 'getTime'])->name('agendaTime');
    Route::get('listeAgendaMedecin/{id}', [AgendaController::class, 'listeDesagendaMedecin'])->name('listeAgendaMedecin');
    Route::put('updateStatus/{id}', [AgendaController::class, 'updateStatAgenda'])->name('updateStatus');
    Route::get('deleteAgenda/{id}', [AgendaController::class, 'deleteAgendaMedecin'])->name('deleteAgenda');
 //
    // appointment route
    Route::get('appointmentList/{id}', [AppointmentController::class, 'getAppointmentClient'])->name('appointmentList'); //updateAppointmentClientDialog
    Route::post('registerAndAppointment', [AuthController::class, 'registerAndAppointment'])->name('registerAndAppointment'); //updateAppointmentClientDialog
    Route::get('appointmentListModal/{id}', [AppointmentController::class, 'getAppointmentClientDialog'])->name('appointmentListModal');
    Route::post('updateAppointmentClientDialog/{id}', [AppointmentController::class, 'updateAppointmentClientDialog'])->name('updateAppointmentClientDialog');
    Route::post('appointment', [AppointmentController::class, 'appoitmentClientDoctor'])->name('appointment');
    Route::get('allAppointment', [AppointmentController::class, 'AllApoinmentDocotors'])->name('allAppointment');
    Route::get('allAppointmentClients', [AppointmentController::class, 'AllApoinmenClients'])->name('allAppointmentClients');
    Route::get('getAppointmentDoctors/{idDoctors}', [AppointmentController::class, 'getAppointmentDoctors'])->name('allAppointmentClients'); // getEntAttenteAppointmentDoctors
    Route::get('getEntAttenteAppointmentDoctors/{idDoctors}', [AppointmentController::class, 'getEntAttenteAppointmentDoctors'])->name('getEntAttenteAppointmentDoctors'); //
    Route::put('updateAcceptAppointment/{idAppointment}', [AppointmentController::class, 'updateToAccept'])->name('updateAcceptAppointment');
    Route::put('updateAnnuleAppointment/{idAppointment}', [AppointmentController::class, 'updateToAnnuler'])->name('updateAnnuleAppointment');

    //route for comment
    Route::get('comment/{idDoctor}', [CommentController::class, 'getAllComments'])->name('comment');
    Route::post('storecomment', [CommentController::class, 'storeComment'])->name('storecomment');
    Route::put('updatecomment/{idComment}', [CommentController::class, 'updateComment'])->name('updatecomment');
    Route::get('deleteComment/{idComment}', [CommentController::class, 'deleteCommentsUser'])->name('deleteComment');

    //Like likeOrUnlike
    Route::get('like/{id}', [LikeController::class, 'likeOrUnlike'])->name('like');
    Route::get('numberslike/{id}', [LikeController::class, 'CountLikesDoctors'])->name('numberslike');

    // Cabinet
    Route::get('getCabinet', [CabinetController::class, 'getAllCabinet'])->name('getCabinet');
    Route::post('storeCabinet', [CabinetController::class, 'addCabinet'])->name('storeCabinet');
    Route::get('destroyCabinet/{id}', [CabinetController::class, 'destroyCabinet'])->name('destroyCabinet');


    // fiche patient searchFiche
    Route::post('sotrefiche', [FicheController::class, 'storeFichePatient'])->name('sotrefiche');
    Route::get('fetchFichePatient/{id}', [FicheController::class, 'fetchFiche'])->name('fetchFichePatient');
    // Route::get('fetchFicheForPatient/{id}', [FicheController::class, 'fetchFicheForPatient'])->name('fetchFicheForPatient');
    Route::get('deleteFichePatient/{id}', [FicheController::class, 'deleteFichet'])->name('deleteFichePatient');
    Route::get('searchFiches/{date}', [FicheController::class, 'searchFiche'])->name('searchFiches');

    // statistique
    Route::post('statistique', [StatistiqueController::class, 'index'])->name("statistique");
});



