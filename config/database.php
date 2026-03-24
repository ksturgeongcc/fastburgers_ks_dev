<?php

$host = '127.0.0.1';   // IMPORTANT: forces TCP, avoids socket error on macOS/MAMP
$username = 'karen';
$password = 'password';
$database = 'fastburgers';
$port = 8889;

$conn = new mysqli($host, $username, $password, $database, $port);

if ($conn->connect_error) {
    die('Database connection failed: ' . $conn->connect_error);
}

$conn->set_charset('utf8mb4');

return $conn;