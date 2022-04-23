<?php

namespace Todo;

class Route
{

	private static $routes = [], $pathNotFound = null, $methodNotAllowed = null;
	private $basepath;

	function __construct($basepath = '/')
	{
		$this->basepath = $basepath;
	}

	static function add($expression, $function, $method = 'get')
	{
		array_push(self::$routes, array(
			'expression' => $expression,
			'function' => $function,
			'method' => $method
		));
	}

	static function pathNotFound($function)
	{
		self::$pathNotFound = $function;
	}

	static function methodNotAllowed($function)
	{
		self::$methodNotAllowed = $function;
	}

	function path(){
		$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
		$basepath = preg_replace('/([^\/])$/','$1/',$this->basepath);
		if(0 === strpos($path,$basepath))
			$path = substr($path,mb_strlen($basepath));
		return $path;
	}

	function redirect($path){
		$basepath = preg_replace('/\/$/','',$this->basepath);
		header("Location: {$basepath}{$path}");
		die;
	}

	function run()
	{
		$basepath = preg_replace('/\/$/','',$this->basepath);
		$parsedUrl = parse_url($_SERVER['REQUEST_URI']);
		$path = $parsedUrl['path'] ?? '/';

		// Get current request method
		$method = $_SERVER['REQUEST_METHOD'];
		$pathMatchFound = false;
		$routeMatchFound = false;
		$isNotRoot = $basepath != '' && $basepath != '/';

		foreach (self::$routes as $route) {
			if ($isNotRoot)
				$route['expression'] = '(' . $basepath . ')' . $route['expression'];
			$route['expression'] = '^' . $route['expression'] . '$';

			// Check path match	
			if (preg_match('#' . $route['expression'] . '#', $path, $matches)) {
				$pathMatchFound = true;
				if (strtolower($method) == strtolower($route['method'])) {
					array_shift($matches);
					if ($isNotRoot)
						array_shift($matches);
					call_user_func_array($route['function'], $matches);
					$routeMatchFound = true;
					break;
				}
			}
		}

		if (!$routeMatchFound) {
			if ($pathMatchFound) {
				header("HTTP/1.0 405 Method Not Allowed");
				if (self::$methodNotAllowed)
					call_user_func_array(self::$methodNotAllowed, array($path, $method));
			} else {
				header("HTTP/1.0 404 Not Found");
				if (self::$pathNotFound)
					call_user_func_array(self::$pathNotFound, array($path));
			}
		}
	}
}
