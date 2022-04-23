<?php

namespace Todo\Models;

class Task extends Model
{
	static $arFields = ['id', 'name', 'email', 'content', 'status', 'edited'];

	static function getList($page = 1, $pageSize = 20, $orderField = 'name', $order = 'asc'): static
	{
		$model = new static('tasks');
		if (!in_array($orderField, static::$arFields))
			$orderField = static::$arFields[0];
		if ($order !== 'asc' && $order !== 'desc')
			$order = 'asc';
		$fields = "`" . implode('`,`', static::$arFields) . "`";
		$numRows = static::numRows();
		$numPages = ceil($numRows / $pageSize);
		$page = intval($page);
		if ($page < 1)
			$page = 1;
		if ($page > $numPages)
			$page = $numPages;
		$limitStart = ($page - 1) * $pageSize;
		if ($rs = db()->query("select $fields from tasks order by $orderField $order limit $limitStart, $pageSize")) {
			$currentUser = \Todo\Controllers\Auth::user()->username();
			while ($r = $rs->fetch_assoc()) {
				$row = new Model('row');
				if ($currentUser === 'admin'){
					$arParams = [
						'id' => $r['id'],
						'page' => $page,
						'order-field' => $orderField,
						'order' => $order,
					];
					$row->de()->setAttribute('edit-url', 'task/edit/?' . http_build_query($arParams));
				}
				foreach (static::$arFields as $field)
					$row->append($field)->textContent = $r[$field];
				$model->append($row);
			}
		}
		$model->de()->setAttribute('page', $page);
		$model->de()->setAttribute('page-size', $pageSize);
		$model->de()->setAttribute('num-rows', $numRows);
		$model->de()->setAttribute('num-pages', $numPages);
		$model->de()->setAttribute('order-field', $orderField);
		$model->de()->setAttribute('order', $order);
		return $model;
	}

	static function getItem($id = null)
	{
		$model = new static('task-item');
		$arValues = null;
		if ($id = intval($id)) {
			$fields = "`" . implode('`,`', static::$arFields) . "`";
			if ($rs = db()->query("select $fields from tasks where id={$id}"))
				$arValues = $rs->fetch_assoc();
		}
		foreach (static::$arFields as $field) {
			$e = $model->append($field);
			if ($arValues)
				$e->textContent = $arValues[$field];
		}
		return $model;
	}

	function save()
	{
		$stmt = db()->prepare("INSERT INTO tasks(`id`, `name`, `email`, `content`, `status`, `edited`) VALUES (?, ?, ?, ?, ?, ?)"
			. " ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `email`=VALUES(`email`), `content`=VALUES(`content`), `status`=VALUES(`status`), `edited`=VALUES(`edited`)");
		if ($stmt && $stmt->bind_param("issssi", $id, $name, $email, $content, $status, $edited)) {
			$id = $this->xp()->evaluate('string(/task-item/id)') ?: 'NULL';
			$name = $this->xp()->evaluate('string(/task-item/name)');
			$email = $this->xp()->evaluate('string(/task-item/email)');
			$content = $this->xp()->evaluate('string(/task-item/content)');
			$status = $this->xp()->evaluate('string(/task-item/status)') ?: '';
			$edited = $id === 'NULL' ? 0 : 1;			
			if (!$stmt->execute())
				throw new \Exception('Ошибка сохранения данных');
		} else
			throw new \Exception('Ошибка формирования запроса');
	}

	protected static function numRows()
	{
		return db()->query("select count(id) `numRows` from tasks")->fetch_assoc()['numRows'] ?? 0;
	}
}
