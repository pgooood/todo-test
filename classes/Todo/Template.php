<?php

namespace Todo;

class Template
{
	protected \DOMDocument $dd;
	protected \DOMXPath $xp;

	function __construct($path)
	{
		$this->dd = new \DOMDocument;
		$this->dd->load($path);
		$this->xp = new \DOMXPath($this->dd);
		$this->xp->registerNamespace('xsl', 'http://www.w3.org/1999/XSL/Transform');
	}

	function dd(): \DOMDocument
	{
		return $this->dd;
	}

	function de(): \DOMElement
	{
		return $this->dd->documentElement;
	}

	function include($path)
	{
		if ($this->de() && !$this->xp->evaluate('count(/xsl:stylesheet/xsl:include[@href="' . htmlspecialchars($path) . '"])')) {
			$e = $this->de()->insertBefore(
				$this->dd()->createElementNS('http://www.w3.org/1999/XSL/Transform', 'xsl:include'),
				$this->de()->firstChild
			);
			$e->setAttribute('href', $path);
		}
	}

	function transform(\Todo\Models\Model $model)
	{
		$proc = new \XSLTProcessor;
		if ($proc->importStyleSheet($this->dd()))
			return $proc->transformToXML($model->dd());
		throw new \Exception('Ошибка в шаблоне');
	}
}
