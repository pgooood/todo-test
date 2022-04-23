<?php

namespace Todo\Controllers;

use \Todo\Models\Task as TaskModel;

class Task extends Controller
{
	function index()
	{
		template()->include('tasks.xsl');
		model()->append(TaskModel::getList(
			filter_input(INPUT_GET, 'page', FILTER_VALIDATE_INT),
			2,
			filter_input(INPUT_GET, 'order-field', FILTER_SANITIZE_SPECIAL_CHARS) ?: 'name',
			filter_input(INPUT_GET, 'order', FILTER_SANITIZE_SPECIAL_CHARS) ?: 'asc'
		));
	}

	function edit()
	{
		if(!\Todo\Controllers\Auth::user()->isAdmin() && filter_input(INPUT_POST,'id'))
			throw new \Exception('Доступ запрещен');
		template()->include('taskForm.xsl');
		$model = TaskModel::getItem(filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT));
		$model->de()->setAttribute('url-params',static::urlParams());
		model()->append($model);
	}

	function store()
	{
		if(!\Todo\Controllers\Auth::user()->isAdmin() && filter_input(INPUT_POST,'id'))
			throw new \Exception('Доступ запрещен');
		template()->include('taskForm.xsl');
		$model = TaskModel::getItem();
		$model->de()->setAttribute('url-params',static::urlParams());
		$ns = $model->xp()->query('/*/*');
		$errors = new \Todo\Errors;
		if(!filter_input(INPUT_POST,'name',FILTER_SANITIZE_SPECIAL_CHARS))
			$errors->add('Имя пользователя не задано');
		if(!filter_input(INPUT_POST,'email',FILTER_VALIDATE_EMAIL))
			$errors->add('Введен некорректный адрес электронной почты');
		if(!filter_input(INPUT_POST,'content',FILTER_SANITIZE_SPECIAL_CHARS))
			$errors->add('Описание задачи не задано');
		foreach($ns as $eField)
			$eField->textContent = filter_input(INPUT_POST, $eField->tagName,FILTER_SANITIZE_SPECIAL_CHARS);
		if($errors->hasErrors()){
			$arErrors = $errors->toArray();
			foreach ($arErrors as $error)
				$model->append('error')->textContent = $error;
			model()->append($model);
		}else{
			$model->save();
			if(!session_id())
				session_start();
			$_SESSION['message'] = 'Заявка успешно сохранена';
			route()->redirect('/'.static::urlParams());
		}
	}

	protected static function urlParams(){
		return '?'.http_build_query([
			'page' => filter_input(INPUT_GET, 'page', FILTER_VALIDATE_INT),
			'order-field' => filter_input(INPUT_GET, 'order-field', FILTER_SANITIZE_SPECIAL_CHARS) ?: 'name',
			'order' => filter_input(INPUT_GET, 'order', FILTER_SANITIZE_SPECIAL_CHARS)
		]);
	}

}
