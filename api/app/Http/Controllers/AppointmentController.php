<?php

namespace App\Http\Controllers;

use  App\Models\User;
use  App\Models\Appointment;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class AppointmentController extends Controller
{
    // Store apointments client if roles is client
    public function appoitmentClientDoctor(Request $request)
    {

        $date = explode("-", $request->date);
        $appointment = Appointment::create([
            'date' => $date[0]."-".$date[1]."-".$date[2],
            'time' => $request->time,
            'motif' => $request->motif,
            // 'patient_record' => $request->patient_record,
            'id_doctor' =>  $request->id_doctor,
            'user_id' => $request->user()->id,
        ]);

        return response()->json([
            'appointment' => $appointment,
            'message' => 'votre rendez vous est enrgistré avec success',
        ],200);

    }

    // function for geting appointments for Client if her roles is Client
    public function getAppointmentClient($id_patient)
    {
        $AppointmentList = User::join('appointments', 'users.id', '=', 'appointments.id_doctor')
                ->select('users.*', 'users.*', 'appointments.*')
                ->where('user_id', $id_patient)
                // ->where('appointments.date', '>=', Carbon::now()->format('dd-mm-YYYY'))
                ->orderBy('appointments.id', 'ASC')
                ->get();
        return response()->json([
            'AppointmentList' => $AppointmentList,
           'message' => 'success',
        ],200);
    }

    // function geting appointments for client if her roles is client in modal
    public function getAppointmentClientDialog($id_patient)
    {
        $AppointmentList = User::join('appointments', 'users.id', '=', 'appointments.id_doctor')
                ->select('users.*', 'users.*', 'appointments.*')
                ->where('user_id', $id_patient)
                ->where('checks', '0')
                ->where('status', 'Annuler')
                ->orderBy('appointments.id', 'ASC')
                ->get();
        return response()->json([
            'AppointmentList' => $AppointmentList,
           'message' => 'success',
        ],200);
    }

    // update appointment for cheks to 1
    public function updateAppointmentClientDialog($id_patient)
    {
        $AppointmentList = User::join('appointments', 'users.id', '=', 'appointments.id_doctor')
                ->select('users.*', 'users.*', 'appointments.*')
                ->where('user_id', $id_patient)
                ->where('checks', '0')
                ->where('status', 'Annuler')
                ->orderBy('appointments.id', 'ASC')
                ->update(['checks' => '1']);
        return response()->json([
            'message' => 'success',
        ],200);
    }
    // function for geting appointments for doctors if her roles is doctors
    public function getAppointmentDoctors($idDoctor)
    {
        $AppointmentList = User::join('appointments', 'users.id', '=', 'appointments.user_id')
                ->select('users.*', 'users.*', 'appointments.*', DB::raw('GROUP_CONCAT(time) as times'), DB::raw('GROUP_CONCAT(name) as names'), DB::raw('GROUP_CONCAT(email) as emails'))
                ->where('id_doctor', $idDoctor)
                // ->where('appointments.date', '>=', Carbon::now()->format('dd-mm-YYYY'))
                ->orderBy('appointments.id', 'ASC')->groupBy('appointments.date')
                ->get();
                // $AppointmentList = User::join('appointments', 'users.id', '=', 'appointments.user_id')
                // ->select('users.*', 'users.*', 'appointments.*')
                // ->where('id_doctor', $idDoctor)
                // // ->where('appointments.date', '>=', Carbon::now()->format('dd-mm-YYYY'))
                // ->orderBy('appointments.id', 'ASC')->groupBy('appointments.date')
                // ->get();

        //          $dates = [];
        // foreach($AppointmentList as $date){
        //     if(!array_key_exists($date->date,$dates)){
        //         $dates[$date->date] = [];
        //     }
        //     if(!array_key_exists($date->time,$dates[$date->date])){
        //         $dates[$date->date][$date->time] = [];
        //     }
        //     $dates[$date->date][$date->time] = $date;
        // }
        // foreach($AppointmentList as $date){
        //     $dates = $date->date;
        //     // if(!array_key_exists($date->date,$dates)){
        //     //     $dates[$date->date] = [];
        //     // }
        //     // if(!array_key_exists($date->time,$dates[$date->date])){
        //     //     $dates[$date->date][$date->time] = [];
        //     // }
        //     // $dates[$date->date][$date->time] = $date;
        // }
        return response()->json([
            // 'dates' => $dates,
            'AppointmentList' => $AppointmentList,
            'message' => 'success',
        ],200);
    }
    public function getEntAttenteAppointmentDoctors($idDoctor)
    {
        $AppointmentList = User::join('appointments', 'users.id', '=', 'appointments.user_id')
                ->select('users.*', 'users.*', 'appointments.*')
                ->where('id_doctor', $idDoctor)->where('appointments.status', '=', 'En attente')
                // ->where('appointments.date', '>=', Carbon::now()->format('dd-mm-YYYY'))
                ->orderBy('appointments.id', 'ASC')
                ->get();
                return response()->json([
                    // 'dates' => $dates,
                    'AppointmentList' => $AppointmentList,
                    'message' => 'success',
                ],200);
    }
    // function for geting appointments for doctors if her roles is Admin
    public function AllApoinmentDocotors()
    {
//         SELECT date, GROUP_CONCAT(time) as time , GROUP_CONCAT(name) as name
// FROM appointments INNER JOIN users ON users.id = appointments.user_id
// GROUP BY date
        $appointmentAllDoctors = User::join('appointments', 'users.id', '=', 'appointments.id_doctor')
        ->join('specializations', 'users.id', '=','specializations.user_id' )
        ->select('users.*', 'appointments.*', 'specializations.*')
        ->where('specializations.specialty', '!=', 'client')
        ->orderBy('appointments.id', 'ASC')
        ->get();
        // $resultats = Appointment::select('date', \DB::raw('GROUP_CONCAT(time) as times'))
        //                 ->groupBy('date')
        //                 ->get();
        // $dates = [];
        // foreach($appointmentAllDoctors as $date){
        //     if(!array_key_exists($date->date,$dates)){
        //         $dates[$date->date] = [];
        //     }
        //     if(!array_key_exists($date->time,$dates[$date->date])){
        //         $dates[$date->date][$date->time] = [];
        //     }
        //     $dates[$date->date][$date->time] = $date;
        // }
        // ->where('appointments.date', '>=', Carbon::now()->format('dd-mm-YYYY'))
        //->groupBy('appointments.date')->pluck('time');
        return response()->json([
            'all_appointments' => $appointmentAllDoctors,
            'message' => 'Appointments',
        ],200);
    }

    // function for geting appointments for Clients if her roles is Admin
    public function AllApoinmenClients()
    {
        $appointmentAllClients = User::join('appointments', 'users.id', '=', 'appointments.user_id')
        ->join('specializations', 'users.id', '=','specializations.user_id' )
        ->select('users.*', 'appointments.*', 'specializations.*')
        ->where('specializations.specialty', '=', 'client')
        // ->where('appointments.date', '>=', Carbon::now()->format('dd-mm-YYYY'))
        ->orderBy('appointments.id', 'ASC')
        ->get();
        return response()->json([
            'all_appointmentsClients' => $appointmentAllClients,
            'message' => 'Appointments',
        ],200);
    }
    public function updateToAccept($idAppointments)
    {
        $appointment = Appointment::find($idAppointments);
        $appointment->update([
            'status' => 'Accepter',
        ]);
        return response()->json([
            'message' => 'le rendez-vous est accpter',
        ]);
    }

    public function updateToAnnuler($idAppointments)
    {
        $appointment = Appointment::find($idAppointments);
        $appointment->update([
            'status' => 'Annuler',
        ]);
        return response()->json([
            'message' => 'le rendez-vous est annuler',
        ]);
    }
}

