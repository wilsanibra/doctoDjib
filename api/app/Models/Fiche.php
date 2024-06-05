<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\User;

class Fiche extends Model
{
    use HasFactory;
    protected $fillable = [
        'antecedent',
        'prescription',
        'user_id',
        'date'
    ];
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
