<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Cabinet;


class CabinetController extends Controller
{
    public function getAllCabinet()
    {
        $cabinet = Cabinet::where('nomCab', '!=', 'Cabinet Client')->get();
        return response()->json([
            'cabinet' => $cabinet,
        ],200);
    }
    public function addCabinet(Request $request)
    {
        $cabinet = $request->validate([
            'nomCab' => 'required|string|max:255',
        ]);
        Cabinet::create([
            'nomCab' => $cabinet['nomCab'],
        ]);
        return response()->json([
            'message' => "ajout d'un cabinet est avec succes",
        ],200);
    }
    public function destroyCabinet($id)
    {
        $cabinet = Cabinet::find($id);
        if (!$cabinet) {
            return response()->json([
                'message' => "il n'y a pas de ce cabinet",
            ],401);
        }
        $cabinet->delete();
        return response()->json([
            'message' => "suppression avec success",
        ], 200);
    }
}
