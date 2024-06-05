<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\User;


class Agenda extends Model
{
    use HasFactory;
    protected $fillable = [
        'date',
        'time',
        'end_time',
        'status',
        'id_doctor'
    ];
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
