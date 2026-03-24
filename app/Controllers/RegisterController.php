<?php

class RegisterController
{
    public function index(): void
    {
        $title = 'Fast Burgers - Register';
        $errors = [];

        // Load DB connection: must define $conn = new mysqli(...)
        require BASE_PATH . '/config/database.php';

        // Basic safety check
        if (!isset($conn) || !($conn instanceof mysqli)) {
            die("Database connection not available.");
        }

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {

            $first_name = trim($_POST['first_name'] ?? '');
            $last_name  = trim($_POST['last_name'] ?? '');
            $phone      = trim($_POST['phone'] ?? '');
            $email      = trim($_POST['email'] ?? '');
            $password   = $_POST['password'] ?? '';

            // ---- Validation ----
            if ($first_name === '') $errors[] = "First name is required.";
            if ($last_name === '')  $errors[] = "Last name is required.";

            if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
                $errors[] = "A valid email is required.";
            }

            if ($password === '' || strlen($password) < 8) {
                $errors[] = "Password must be at least 8 characters.";
            }

            // Optional phone -> null if empty (if your DB allows NULL)
            $phone = ($phone === '') ? null : $phone;

            // ---- Check duplicate email ----
            if (empty($errors)) {
                $sql = "SELECT customer_id FROM customers WHERE email = ? LIMIT 1";
                $stmt = $conn->prepare($sql);

                if (!$stmt) {
                    $errors[] = "Database error (prepare failed).";
                } else {
                    $stmt->bind_param("s", $email);
                    $stmt->execute();
                    $stmt->store_result();

                    if ($stmt->num_rows > 0) {
                        $errors[] = "An account with this email already exists.";
                    }

                    $stmt->close();
                }
            }

            // ---- Insert customer ----
            if (empty($errors)) {
                $hashed_password = password_hash($password, PASSWORD_DEFAULT);

                // NOTE: column is assumed to be `hashed_password`
                $sql = "INSERT INTO customers (first_name, last_name, phone, email, password)
                        VALUES (?, ?, ?, ?, ?)";

                $stmt = $conn->prepare($sql);

                if (!$stmt) {
                    $errors[] = "Database error (prepare failed).";
                } else {
                    // bind_param types: s = string. phone can be null; mysqli handles it if you pass null.
                    $stmt->bind_param("sssss", $first_name, $last_name, $phone, $email, $hashed_password);

                    if ($stmt->execute()) {
                        $stmt->close();

                        // Redirect on success
                        header("Location: /login");
                        exit;
                    } else {
                        $errors[] = "Registration failed. Please try again.";
                        $stmt->close();
                    }
                }
            }
        }

        // Render view
        $view = BASE_PATH . '/app/Views/register.php';
        require BASE_PATH . '/app/Views/layout.php';
    }
}