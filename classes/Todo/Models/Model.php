<?php

namespace Todo\Models;

class Model
{

	protected \DOMDocument $dd;
	protected \DOMXPath $xp;

	function __construct($name = null)
	{
		$this->dd = new \DOMDocument;
		$this->append($name ?: 'main');
	}

	function dd(): \DOMDocument
	{
		return $this->dd;
	}

	function de(): ?\DOMElement
	{
		return $this->dd->documentElement;
	}

	function xp()
	{
		if (!isset($this->xp))
			$this->xp = new \DOMXPath($this->dd());
		return $this->xp;
	}

	function append($v, $to = null): \DOMElement
	{
		$e = null;
		if (is_string($v))
			$e = $this->dd()->createElement($v);
		elseif ($v instanceof \Todo\Models\Model)
			$e = $this->dd->importNode($v->de(), true);
		elseif ($v instanceof \DOMElement)
			$e = $v;
		else
			throw new \Exception('invalid value');
		if ($parent = $to
			? $this->xp()->query($to)->item(0)
			: ($this->de() ?: $this->dd())
		) {
			return $parent->appendChild($e);
		}
	}
}
