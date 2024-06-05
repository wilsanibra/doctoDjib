<?php

namespace App\Models;
use App\Models\User;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cabinet extends Model
{
    use HasFactory;
    protected $fillable = [
        'nomCab',
    ];

    public function users()
    {
        return $this->belongsToMany(User::class, 'user_cabinets', 'user_id','cabinet_id');
    }
}
