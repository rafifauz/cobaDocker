echo "----------------MySQL Database---------------"

# sudo mysql -u root << EOF
# CREATE DATABASE IF NOT EXISTS laravel_db;
# CREATE USER IF NOT EXISTS 'laravel_user'@'localhost' IDENTIFIED BY 'password';
# GRANT ALL PRIVILEGES ON * . * TO 'laravel_user'@'localhost';
# FLUSH PRIVILEGES;
# EOF

sudo sed -i 's/DB_PORT=3306/DB_PORT=3306/g' .env
sudo sed -i 's/DB_HOST=127.0.0.1/DB_HOST=127.0.0.1/g' .env
sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=laravel_db/g' .env
sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=laravel_user/g' .env
sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/g' .env

php artisan config:clear

echo "----------------Config Laravel---------------"

php artisan make:model Student -m

sudo tee database/migrations/*_create_students_table.php <<EOL
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateStudentsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('students', function (Blueprint \$table) {
            \$table->bigIncrements('id');
            \$table->string('name');
            \$table->string('email');
            \$table->string('phone');
            \$table->string('password');            
            \$table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('students');
    }
}
EOL

sudo tee app/Models/Student.php <<EOL
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    use HasFactory;
    protected \$fillable = ['name', 'email', 'phone', 'password'];
}
EOL

php artisan migrate

echo "----------------Creating the Controller and Routes---------------"
php artisan make:controller StudentController --resource

sudo tee app/Http/Controllers/StudentController.php <<EOL
<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Student;


class StudentController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        \$student = Student::all();
        return view('index', compact('student'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  \$request
     * @return \Illuminate\Http\Response
     */
    public function store(Request \$request)
    {
        \$storeData = \$request->validate([
            'name' => 'required|max:255',
            'email' => 'required|max:255',
            'phone' => 'required|numeric',
            'password' => 'required|max:255',
        ]);
        \$student = Student::create(\$storeData);

        return redirect('/students')->with('completed', 'Student has been saved!');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  \$id
     * @return \Illuminate\Http\Response
     */
    public function show(\$id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  \$id
     * @return \Illuminate\Http\Response
     */
    public function edit(\$id)
    {
        \$student = Student::findOrFail(\$id);
        return view('edit', compact('student'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  \$request
     * @param  int  \$id
     * @return \Illuminate\Http\Response
     */
    public function update(Request \$request, \$id)
    {
        \$updateData = \$request->validate([
            'name' => 'required|max:255',
            'email' => 'required|max:255',
            'phone' => 'required|numeric',
            'password' => 'required|max:255',
        ]);
        Student::whereId(\$id)->update(\$updateData);
        return redirect('/students')->with('completed', 'Student has been updated');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  \$id
     * @return \Illuminate\Http\Response
     */
    public function destroy(\$id)
    {
        \$student = Student::findOrFail(\$id);
        \$student->delete();

        return redirect('/students')->with('completed', 'Student has been deleted');
    }
}
EOL

sudo tee  routes/web.php <<EOL
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\StudentController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::resource('students', StudentController::class);
EOL

php artisan route:list

sudo tee resources/views/layout.blade.php <<EOL
<!DOCTYPE html>
<html>
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <title>Laravel 8|7|6 CRUD App Example</title>
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
   </head>
   <body>
      <div class="container">
         @yield('content')
      </div>

      <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
      <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" type="text/js"></script>
   </body>
</html>
EOL

sudo tee resources/views/create.blade.php <<EOL
@extends('layout')

@section('content')

<style>
    .container {
      max-width: 450px;
    }
    .push-top {
      margin-top: 50px;
    }
</style>

<div class="card push-top">
  <div class="card-header">
    Add User
  </div>

  <div class="card-body">
    @if (\$errors->any())
      <div class="alert alert-danger">
        <ul>
            @foreach (\$errors->all() as \$error)
              <li>{{ \$error }}</li>
            @endforeach
        </ul>
      </div><br />
    @endif
      <form method="post" action="{{ route('students.store') }}">
          <div class="form-group">
              @csrf
              <label for="name">Name</label>
              <input type="text" class="form-control" name="name"/>
          </div>
          <div class="form-group">
              <label for="email">Email</label>
              <input type="email" class="form-control" name="email"/>
          </div>
          <div class="form-group">
              <label for="phone">Phone</label>
              <input type="tel" class="form-control" name="phone"/>
          </div>
          <div class="form-group">
              <label for="password">Password</label>
              <input type="text" class="form-control" name="password"/>
          </div>
          <button type="submit" class="btn btn-block btn-danger">Create User</button>
      </form>
  </div>
</div>
@endsection
EOL

sudo tee ShowController.php <<EOL
// StudentController.php

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request \$request)
    {
        \$storeData = \$request->validate([
            'name' => 'required|max:255',
            'email' => 'required|max:255',
            'phone' => 'required|numeric',
            'password' => 'required|max:255',
        ]);
        \$student = Student::create(\$storeData);

        return redirect('/students')->with('completed', 'Student has been saved!');
    }
EOL

sudo tee resources/views/index.blade.php <<EOL
@extends('layout')

@section('content')

<style>
  .push-top {
    margin-top: 50px;
  }
</style>

<div class="push-top">
  @if(session()->get('success'))
    <div class="alert alert-success">
      {{ session()->get('success') }}  
    </div><br />
  @endif
  <table class="table">
    <thead>
        <tr class="table-warning">
          <td>ID</td>
          <td>Name</td>
          <td>Email</td>
          <td>Phone</td>
          <td>Password</td>
          <td class="text-center">Action</td>
        </tr>
    </thead>
    <tbody>
        @foreach(\$student as \$students)
        <tr>
            <td>{{\$students->id}}</td>
            <td>{{\$students->name}}</td>
            <td>{{\$students->email}}</td>
            <td>{{\$students->phone}}</td>
            <td>{{\$students->password}}</td>
            <td class="text-center">
                <a href="{{ route('students.edit', \$students->id)}}" class="btn btn-primary btn-sm"">Edit</a>
                <form action="{{ route('students.destroy', \$students->id)}}" method="post" style="display: inline-block">
                    @csrf
                    @method('DELETE')
                    <button class="btn btn-danger btn-sm"" type="submit">Delete</button>
                  </form>
            </td>
        </tr>
        @endforeach
    </tbody>
  </table>
<div>
@endsection
EOL

sudo tee app/Models/edit.blade.php <<EOL
@extends('layout')

@section('content')

<style>
    .container {
      max-width: 450px;
    }
    .push-top {
      margin-top: 50px;
    }
</style>

<div class="card push-top">
  <div class="card-header">
    Edit & Update
  </div>

  <div class="card-body">
    @if (\$errors->any())
      <div class="alert alert-danger">
        <ul>
            @foreach (\$errors->all() as \$error)
              <li>{{ \$error }}</li>
            @endforeach
        </ul>
      </div><br />
    @endif
      <form method="post" action="{{ route('students.update', \$student->id) }}">
          <div class="form-group">
              @csrf
              @method('PATCH')
              <label for="name">Name</label>
              <input type="text" class="form-control" name="name" value="{{ \$student->name }}"/>
          </div>
          <div class="form-group">
              <label for="email">Email</label>
              <input type="email" class="form-control" name="email" value="{{ \$student->email }}"/>
          </div>
          <div class="form-group">
              <label for="phone">Phone</label>
              <input type="tel" class="form-control" name="phone" value="{{ \$student->phone }}"/>
          </div>
          <div class="form-group">
              <label for="password">Password</label>
              <input type="text" class="form-control" name="password" value="{{ \$student->password }}"/>
          </div>
          <button type="submit" class="btn btn-block btn-danger">Update User</button>
      </form>
  </div>
</div>
@endsection
EOL

ipserver=$(hostname -i)
php artisan serve --host=$ipserver --port=8000