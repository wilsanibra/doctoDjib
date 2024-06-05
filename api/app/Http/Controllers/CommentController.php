<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Comment;


class CommentController extends Controller
{
    //get a comment
    public function getAllComments($idDoctor)
    {
        $comment = Comment::join('users', 'comments.user_id', '=' , 'users.id')
                            ->select('users.name', 'users.image','comments.comment', 'comments.id','comments.user_id', 'comments.date')
                            ->where('comments.id_doctor', '=', $idDoctor)
                            ->orderBy('comments.id', 'DESC')
                            ->get();
        return response()->json([
            'comment' => $comment,
            'message' => 'successfully',
        ]);
    }

    // add a comment
    public function storeComment(Request $request)
    {
        $comment = Comment::create([
            'comment' => $request->comment,
            'date' => $request->date,
            'id_doctor' => $request->id_doctor,
            'user_id' => $request->user()->id,
        ]);
        return response()->json([
            'comment' => $comment,
            'message' => 'commentaire est crée',
        ]);
    }

    // delete a comment
    public function deleteCommentsUser($id)
    {
        $comment = Comment::find($id);

        if(!$comment)
        {
            return response([
                'message' => "Commentaire n'est pas trouvé"
            ], 403);
        }

        if($comment->user_id != auth()->user()->id)
        {
            return response([
                'message' => "vous n'êtes pas authorisés"
            ], 401);
        }

        $comment->delete();

        return response([
            'message' => 'votre Commentaire est supprimé avec succès'
        ], 200);
    }

    // update commentaire
    public function updateComment(Request $request, $id)
    {
        $comment = Comment::find($id);
        if(!$comment){
            return response()->json([
                'message' => "Il n'y a pas de recommandation",
            ]);
        }

        if ($comment->user_id != auth()->user()->id) {
            return response()->json([
                'message' => "votre n'êtes pas authorisés",
            ]);
        }
        $comment->update([
            'comment' => $request->comment,
        ]);

        return response([
            'message' => 'votre Commentaire a été bien modifier'
        ], 200);
    }
}
