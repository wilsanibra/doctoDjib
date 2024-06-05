<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Fiche;

class FicheController extends Controller
{
    // function to create a new Fiche
    public function storeFichePatient(Request $request)
    {
        $fiche = Fiche::create([
            'antecedent' => $request->antecedent,
            'prescription' => $request->prescription,
            'date' => $request->date,
            'user_id' => $request->user_id
        ]);
        return response()->json([
            'fiche' => $fiche,
            'message' => 'cette fiche a été créée avec succès',
        ]);
    }

    // fucntion to fetch all fiches for a patient who already exists
    public function fetchFiche($id)
    {
        $fiches = Fiche::where('user_id', $id)->get();
        return response()->json([
            'fiches' => $fiches,
        ]);

    }



    public function fetchFicheForPatient($id)
    {
        $fiches = Fiche::where('user_id', $id)->get();
        return response()->json([
            'fiches' => $fiches,
        ]);

    }

    // delete a fiche patient from the database
    public function deleteFichet($id)
    {
        $fiche = Fiche::findOrFail($id);
        $fiche->delete();
        return response()->json([
            'message' => 'cette fiche a été supprimée avec succès',
        ]);
    }

    function searchFiche($date) {
        $fiches = Fiche::where('date', $date)->get();
        return response()->json([
            'fiches' => $fiches,
        ]);

    }
}
