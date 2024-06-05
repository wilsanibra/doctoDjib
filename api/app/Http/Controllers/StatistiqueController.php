<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use  App\Models\Appointment;
class StatistiqueController extends Controller
{
    public function index(Request $request){
        $responses = [];
        $query = Appointment::where("id_doctor", $request->id_doctor);
        switch($request->filter) {
            case('day'):
                $query->where("created_at",'LIKE',"%{$request->date}%");
                break;
            case('month'):
                $query->whereMonth('created_at', '=', $request->date);
                break;
            case('year'):
                $query->whereYear('created_at', '=', $request->date);
                break;
            default:
                break;

        }
        $responses = $this->filterQuery($query->get(), $request->filter);
        return response()->json([
            'appointments' => $responses,
        ]);
    }

    public function filterQuery($appointments, $filter){
        $responses = [];
        $allDates = [];
        $responses["lists"] = [];
        $responses["mr"] = 0;
        $responses["mde"] = 0;
        $responses["count"] = count($appointments);

        foreach($appointments as $appointment){

            array_push($responses["lists"],ucfirst($appointment->patient->civility)." ".$appointment->patient->name." ".explode(" ",$appointment->created_at)[0]." ".explode(" ",$appointment->created_at)[1]);
            $appointment->patient->civility == "mr" ? $responses["mr"]++ : $responses["mde"]++;
            if($filter == "month"){
                array_push($allDates, explode(" ",$appointment->created_at)[0]);
            }
        }
        if($filter == "month"){
            // Compter le nombre d'occurrences de chaque date
            $dateCounts = array_count_values($allDates);
            // Trouver la date la plus fréquente et son nombre d'occurrences
            $maxOccurrences = 0;
            $mostFrequentDate = null;
            foreach ($dateCounts as $date => $count) {
                if ($count > $maxOccurrences) {
                    $maxOccurrences = $count;
                    $mostFrequentDate = $date;
                }
            }
            // Afficher la date la plus fréquente
            $responses["mostFrequentDate"] = $mostFrequentDate;
        }
        return $responses;
    }

}
