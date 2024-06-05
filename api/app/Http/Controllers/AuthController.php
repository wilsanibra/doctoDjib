<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Models\Specialization;
use App\Models\Appointment;
use App\Models\Cabinet;
class AuthController extends Controller
{
    // Register a new user.

    public function register(Request $request)
    {
        $attrs = $request->validate([
            'name' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'number' => 'required|string|max:20',
            'civility' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' =>'required|string|min:6|confirmed',
        ]);

        $user = new User;
        $user->name = $attrs['name'];
        $user->address = $attrs['address'];
        $user->number = $attrs['number'];
        $user->email = $attrs['email'];
        $user->civility = $attrs['civility'];

        // $user->cabinets()->attach($temp);
        $user->password = bcrypt($attrs['password']);
        $user->save();
        $speciality = new Specialization;
        $speciality->user_id = $user->id;
        $speciality->specialty = $request->specialty;
        $speciality->save();



        // retrun user & token in response
        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken,
            'message' => 'inscription avec succes',
        ]);
    }

    // Register a registerAndAppointment.

    public function registerAndAppointment(Request $request)
    {
        $attrs = $request->validate([
            'name' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'number' => 'required|string|max:20',
            'email' => 'required|email|unique:users,email',
            'password' =>'required|string|min:6|confirmed',
        ]);

        $user = new User;
        $user->name = $attrs['name'];
        $user->address = $attrs['address'];
        $user->number = $attrs['number'];
        $user->email = $attrs['email'];

        // $user->cabinets()->attach($temp);
        $user->password = bcrypt($attrs['password']);
        $user->save();
        $speciality = new Specialization;
        $speciality->user_id = $user->id;
        $speciality->specialty = $request->specialty;
        $speciality->save();

        $date = explode("-", $request->date);
        $appointment = new Appointment;
        $appointment->date = $date[0]."-".$date[1]."-".$date[2];
        $appointment->time = $request->time;
        $appointment->motif = $request->motif;
        $appointment->id_doctor = $request->id_doctor;
        $appointment->user_id = $user->id;
        $appointment->save();


        // retrun user & token in response
        return response([
            'user' => $user,
            'appointment' => $appointment,
            'token' => $user->createToken('secret')->plainTextToken,
            'message' => 'inscription avec succes',
        ]);
    }
    // add docto
    public function registerDocto(Request $request)
    {
        $attrs = $request->validate([
            'name' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'cabinet' => 'required|string|max:255',
            'number' => 'required|string|max:20',
            'email' => 'required|email|unique:users,email',
            'password' =>'required|string|min:6|confirmed',
        ]);

        // create a new user
        // $user =  User::create([
        //     'name' => $attrs['name'],
        //     'address' => $attrs['address'],
        //     'number' => $attrs['number'],
        //     'email' => $attrs['email'],
        //     'password' => bcrypt($attrs['password']),
        // ]);

        $user = new User;
        $user->name = $attrs['name'];
        $user->address = $attrs['address'];
        $user->number = $attrs['number'];
        $user->email = $attrs['email'];
        $temp1 = str_replace("[","",$attrs['cabinet']);
        $temp2 = str_replace("]","", $temp1);
        $temp = explode(',',$temp2);

        // $user->cabinets()->attach($temp);
        $user->password = bcrypt($attrs['password']);
        $user->save();
        $speciality = new Specialization;
        $speciality->user_id = $user->id;
        $speciality->specialty = $request->specialty;
        $speciality->save();
        $user->cabinets()->attach($temp, ['user_id' => $user->id]);
        // $cabinet = Cabinet::find($temp);
        // $cabinet->users()->attach($user->id);



        // retrun user & token in response
        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken,
            'message' => 'inscription avec succes',
        ]);
    }
    // login.

    public function login(Request $request)
    {
        $attrs = $request->validate([
            'email' => 'required|email',
            'password' =>'required|string|min:6',
        ]);

        // attemp login
        if (!Auth::attempt($attrs)) {
            return response([
                'message' => 'connexion invalide',
            ], 403);

        }
        auth()->user()->specialityType = auth()->user()->speciality->specialty;
        // retrun user & token in response
        return response([
            'user' => auth()->user(),
            'token' => auth()->user()->createToken('secret')->plainTextToken,
        ], 200);
    }

    // Logout
    public function logout()
    {
        auth()->user()->tokens()->delete();
        return response([
           'message' => 'Successfully logged out',
        ], 200);
    }

    // User details
    public function user()
    {
        return response([
            'user' => auth()->user(),
        ], 200);
    }
    // update user
    public function update(Request $request)
    {
        $attrs = $request->validate([
            'name' => 'required|string',
            'address' => 'required|string|max:255',
            'number' => 'required|string|max:20',
            'email' => 'required|email',
            'password' =>'required|string|min:6|confirmed',
        ]);

        $image = $this->saveImage($request->image, 'profiles');

        auth()->user()->update([
            'name' => $attrs['name'],
            'address' => $attrs['address'],
            'number' => $attrs['number'],
            'email' => $attrs['email'],
            'password' => bcrypt($attrs['password']),
            'image' => $image
        ]);

        return response([
            'message' => 'Votre profile est à jour',
            'user' => auth()->user()
        ], 200);
    }
    public function saveImage($image)
    {
        if(!$image)
        {
            return null;
        }

        $filename = time().'.png';
        // save image
        \Storage::disk('public')->put($filename, base64_decode($image));

        // $path = 'http://192.168.88.23:8000/storage/'.$filename;
        $path = url('/storage/'.$filename);
        //return the path
        // Url is the base url exp: localhost:8000
        return $path;
    }
}

