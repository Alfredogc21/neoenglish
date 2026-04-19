<?php
declare(strict_types=1);

/*
|--------------------------------------------------------------------------
| Configuracion general de la aplicacion
|--------------------------------------------------------------------------
*/

const APP_NAME = 'InglesCentral Quest';

$scriptDirectory = str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? ''));
$basePath = trim($scriptDirectory, '/');
$basePath = $basePath === '' || $basePath === '.' ? '' : '/' . $basePath;

$httpHost = $_SERVER['HTTP_HOST'] ?? 'localhost';
$isHttps = !empty($_SERVER['HTTPS']) && strtolower((string) $_SERVER['HTTPS']) !== 'off';
$scheme = $isHttps ? 'https' : 'http';

define('APP_BASE_PATH', $basePath);
define('APP_BASE_URL', $scheme . '://' . $httpHost . $basePath);
