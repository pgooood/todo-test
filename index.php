<?php
// путь к папке сайта относительно корня сайта
define('BASE_PATH','/todo/');

spl_autoload_register(function ($class) {
	$filename = __DIR__ . '/classes/' . ('\\' != DIRECTORY_SEPARATOR
		? str_replace('\\', DIRECTORY_SEPARATOR, $class)
		: $class
	) . '.php';
	if (is_file($filename))
		require_once $filename;
});

use \Todo\Route,
	\Todo\Template,
	\Todo\Errors,
	\Todo\Models\Model;

function db(): mysqli
{
	static $mysqli;
	if (!isset($mysqli))
		$mysqli = new mysqli('localhost', 'root', '', 'todo');
	return $mysqli;
}

function template(): Template
{
	static $tpl;
	if (!isset($tpl))
		$tpl = new Template('templates/default.xsl');
	return $tpl;
}

function model(): Model
{
	static $model;
	if (!isset($model)){
		$model = new Model;
		// добавление всплывающего сообщения из сессии
		if(!session_id())
			session_start();
		if(!empty($_SESSION['message'])){
			$model->de()->setAttribute('message',$_SESSION['message']);
			unset($_SESSION['message']);
		}
	}
	return $model;
}

function errors(): Errors
{
	static $errors;
	if (!isset($errors))
		$errors = new Errors;
	return $errors;
}

function route(){
	static $route;
	if (!isset($route))
		$route = new Route(BASE_PATH);
	return $route;
}

// маршруты
Route::add('/', [new \Todo\Controllers\Task, 'index']);
Route::add('/login/', [new \Todo\Controllers\Auth, 'index']);
Route::add('/login/', [new \Todo\Controllers\Auth, 'index'],'post');
Route::add('/logout/', [new \Todo\Controllers\Auth, 'logout']);
Route::add('/task/create/', [new \Todo\Controllers\Task, 'edit']);
Route::add('/task/', [new \Todo\Controllers\Task, 'store'],'post');
Route::add('/task/edit/', [new \Todo\Controllers\Task, 'edit']);
Route::pathNotFound(function(){
	header("{$_SERVER['SERVER_PROTOCOL']} 404 Not Found");
	throw new \Exception('404 Страница не найдена');
});
Route::methodNotAllowed(function(){
	header("{$_SERVER['SERVER_PROTOCOL']} 403 Forbidden");
	throw new \Exception('403 Доступ запрещен');
});

try {
	// базовый путь
	model()->de()->setAttribute('basepath',BASE_PATH);
	// путь относительно базового
	model()->de()->setAttribute('path',route()->path());
	// информация о пользователе
	model()->append(\Todo\Controllers\Auth::user());
	route()->run();
	errors()->throwIfExists();
	echo template()->transform(model());
} catch (\Exception $ex) {
	$tpl = new Template('templates/default.xsl');
	// переинициализируем модель
	$model = new Model;
	$model->de()->setAttribute('basepath',BASE_PATH);
	$model->de()->setAttribute('path',route()->path());
	$model->append(\Todo\Controllers\Auth::user());
	$arErrors = (new Errors($ex))->toArray();
	foreach ($arErrors as $error)
		$model->append('error')->textContent = $error;
	echo $tpl->transform($model);
}
