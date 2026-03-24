<?php
// This is the single entry point for the entire website.
// Every request (/, /contact, /admin/users, etc.) is routed through this file.
define('BASE_PATH', dirname(__DIR__));

require BASE_PATH . '/app/Core/Router.php';

// Create the router and let it decide what should run
$router = new Router();
$router->dispatch();
