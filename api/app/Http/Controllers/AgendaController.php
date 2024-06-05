<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use  App\Models\Agenda;
use Illuminate\Http\Request;


class AgendaController extends Controller
{
    public function storeAgenda(Request $request)
    {
        // $datas = [
        //     'date'  => $request->date,
        //     'time' => $request->time,
        //     'id_doctor' => $request->id_doctor,
        // ];

        // $date = str_replace("[","",$datas['date']);
        // $date = str_replace("]","",$date);

        // $time = str_replace("[","",$datas['time']);
        // $time = str_replace("]","",$time);

        // $dateTab = explode(',',$date);
        // $timeTab = explode(',',$time);

        // $dataInsert = [];
        // for ($i=0; $i < count($dateTab) ; $i++) {
        //    array_push($dataInsert,['date'=> trim($dateTab[$i]) , 'time'=>trim($timeTab[$i]), 'id_doctor'=>$datas['id_doctor']]);
        // }

        $date = explode("-", $request->date);
        $agendas = Agenda::create([
            'date' => $date[2]."-".$date[1]."-".$date[0],
            'time' => $request->time,
            'end_time' => $request->end_time,
            'id_doctor' =>  $request->id_doctor,
        ]);
        // $agendas = Agenda::insert($dataInsert);
        return response()->json([
            'agendas' => $agendas,
            'message' => 'votre agenda est enrgistré avec success',
        ],200);
    }


    // get time agenda
    public function getTime($dates, $doctoId)
    {
        $time = Agenda::where('date', $dates)->where('id_doctor', $doctoId)->select('time','status', 'id', 'end_time')->get();
        if(!$time){
            return response()->json([
                'message'=> 'medecin ne travail pas',
            ],200);
        }
        return response()->json([
            'time'=> $time,
        ],200);
    }


    // public function updateStatAgenda($id)
    // {
    //     $stat = Agenda::find($id);
    //     $stat->update([
    //         'status'=> 'Prise',
    //     ]);
    //     return response()->json([
    //         'message' => 'success',
    //     ]);
    // }
    // get all agenda doctors
    public function listeDesagendaMedecin($id)
    {
        $agendas = Agenda::where('id_doctor',$id)
                            // ->where('date', '>=', Carbon::now()->format('dd-mm-YYYY'))
                            ->orderBy('date', 'ASC')
                            ->get();
        return  response()->json([
            'agendas' => $agendas,
        ], 200);
    }

    // delete agenda doctor
    public function deleteAgendaMedecin($id)
    {
        $agenda = Agenda::find($id);
        $agenda->delete();
        return response()->json([
            'messages' => 'votre agenda est supprimé avec succès',
        ],200);
    }
}

