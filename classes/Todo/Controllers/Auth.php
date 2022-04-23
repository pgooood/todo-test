<?php

namespace Todo\Controllers;

use \Todo\Models\Model;

class Auth extends Controller
{
	function index()
	{
		if (!session_id())
			session_start();
		$modelLogin = new Model('login');
		if ($_SERVER['REQUEST_METHOD'] === 'POST') {
			$username = filter_input(INPUT_POST, 'username', FILTER_SANITIZE_SPECIAL_CHARS);
			$password = filter_input(INPUT_POST, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
			if ($username === 'admin' && $password === '123') {
				$_SESSION['auth_user'] = $username;
				route()->redirect('/');
			} else {
				$modelLogin->append('username')->textContent = $username;
				unset($_SESSION['auth_user']);
				$modelLogin->append('error')->textContent = 'Введены неверные реквизиты доступа';
			}
		}
		template()->include('login.xsl');
		model()->append($modelLogin);
	}

	function logout()
	{
		if (!session_id())
			session_start();
		unset($_SESSION['auth_user']);
		route()->redirect('/');
	}

	/**
	 * Данные об авторизованном пользователе
	 * добавляется на все страницы
	 */
	static function user(): \Todo\Models\User
	{
		if (!session_id())
			session_start();
		return \Todo\Models\User::get($_SESSION['auth_user'] ?? null);
	}
}
