<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\Specialization;


class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index()
    {
        return view('home');
    }
    public function showListMedecin()
    {
        $doctors = User::join('specializations', 'users.id', '=', 'specializations.user_id')
                ->select('users.*', 'specializations.*')
                ->where('specializations.specialty', '!=', 'admin')->where('specializations.specialty', '!=', 'client')
                ->where('specializations.specialty', '!=', 'secrétaire')
                ->get();
                // $doctors = User::join('specializations', 'users.id', '=', 'specializations.user_id')->join('likes', 'users.id', '=','likes.id_doctor' )
                // ->select('users.*', 'specializations.*', 'likes.id_doctor')
                // ->where('specializations.specialty', '!=', 'admin')->where('specializations.specialty', '!=', 'client')
                // ->get();

        return response()->json([
            'doctors' => $doctors,
            'message' =>'success',
        ]);
    }
    public function getAllUser()
    {
        $users = User::join('specializations', 'users.id', '=', 'specializations.user_id')
        ->select('users.*', 'specializations.*')
        ->where('specializations.specialty', '!=', 'admin')
        ->get();

        return response()->json([
            'users' => $users,
            'message' =>'success',
        ]);
    }

    public function delete($id)
    {
        $user = User::find($id);
        $user->delete();
        return response()->json([
            'message' => 'supprimer avec success',
        ]);
    }
    public function getAllUsersDetail($id){
        $user = User::join('specializations', 'users.id', '=', 'specializations.user_id')
        ->select('users.*', 'users.*', 'specializations.*')
        ->where('specializations.user_id', '=', $id)
        ->get();
        return response()->json([
            'users' => $user,
            'message' =>'success',
        ]);
    }

    public function showListMedecinSearch($nameDoctors)
    {
        $doctors = User::join('specializations', 'users.id', '=', 'specializations.user_id')
                ->select('users.*', 'specializations.*')
                ->where('specializations.specialty', '!=', 'admin')
                ->where('specializations.specialty', '!=', 'client')
                ->where('specializations.specialty', '!=', 'secrétaire')
                ->where('specializations.specialty', '=' , $nameDoctors)
                ->get();
        if(!$doctors){
            return response()->json([
                'message' =>"ce nom n'appartient pas à docteur",
            ],404);
        }
        return response()->json([
            'doctors' => $doctors,
            'message' =>'success',
        ],200);
    }

    public function listesPatients($id)
    {
        $patients = User::join('appointments', 'users.id', '=', 'appointments.user_id')
        ->select('users.*', 'appointments.*')
        ->where('appointments.id_doctor', '=', $id)
        ->groupBy('users.id')
        ->orderBy('appointments.date', 'DESC')
        ->get();


        // $patients = User::with(['appointments' => function($query) use ($id){$query->where('appointments.id_doctor', $id)->groupBy('appointments.user_id');}])->get();

        return response()->json([
            'patients' => $patients,
            'message' =>'success',
        ]);
    }
    public function SearchPatientWithDate($date)
    {
        $patient = User::join('appointments', 'users.id', '=', 'appointments.user_id')
        ->select('users.*', 'appointments.*')
        ->where('appointments.date', '=', $date)
        ->groupBy('users.id')
        ->get();
        if (!$patient) {
            return response()->json([
                'message' => "le patient n'est pas trouvé",
            ]);
        }
        return response()->json([
            'patient' => $patient,
        ]);
    }
}
