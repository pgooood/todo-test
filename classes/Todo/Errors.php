<?php

/**
 * Обертка для удобного собирания и обработки цепочки исключений
 */

namespace Todo;

class Errors
{
	protected $ex;

	function __construct(\Exception $ex = null)
	{
		$this->ex = $ex;
	}

	function hasErrors()
	{
		return isset($this->ex);
	}

	function count()
	{
		$n = 0;
		if ($ex = $this->ex) {
			do $n++;
			while ($ex = $ex->getPrevious());
		}
		return $n;
	}

	function toArray()
	{
		$arErrors = [];
		if ($ex = $this->ex) {
			do array_unshift($arErrors, $ex->getMessage());
			while ($ex = $ex->getPrevious());
		}
		return array_filter($arErrors);
	}

	/**
	 * Добавляет ошибку
	 * @param string $message
	 * @param integer $code
	 */
	function add($message, $code = 0)
	{
		$this->ex = $this->ex
			? new \Exception($message, $code, $this->ex)
			: new \Exception($message, $code);
	}

	function exception()
	{
		return $this->ex;
	}

	function throwIfExists()
	{
		if ($this->ex)
			throw $this->ex;
	}

}
