<?php

namespace Todo\Models;

class User extends Model
{
	static function get($username){
		if (!session_id())
			session_start();
		$model = new static('auth');
		if ($username)
			$model->append('user')->textContent =$username;
		return $model;
	}

	function username(){
		return $this->xp()->evaluate('string(/auth/user)');
	}

	function isAdmin(){
		return $this->username() === 'admin';
	}
}