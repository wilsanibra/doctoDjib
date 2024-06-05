<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Like;


class LikeController extends Controller
{
    public function likeOrUnlike($id)
    {
        $doctors = User::find($id);
        if(!$doctors){
            return response()->json([
                'message' => "il n'y a pas de ce docteur",
            ],403);
        }
        $like = Like::where('user_id', auth()->user()->id)->where('id_doctor', $doctors->id)->first();


        // if not liked then like
        if(!$like){
            Like::create([
                'id_doctor' => $id,
                'user_id' => auth()->user()->id
            ]);
            return response()->json([
                'message' => "j'aime",
            ], 200);
        }
        // else dislike it
        $like->delete();
        return response()->json([
            'message' => "je n'aime plus",
        ],200);
    }
    public function CountLikesDoctors($id)
    {
        $doctors = User::find($id);
        $countLike = Like::where('id_doctor', $doctors->id)->count();
        return response()->json([
            'likes' => $countLike,
        ],200);
    }
}
