<?php

class OrdersController
{
    public function index(): void
    {
        $title = 'Fast Burgers - Orders';

        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        if (empty($_SESSION['auth']['logged_in'])) {
            header('Location: /admin-login');
            exit;
        }

        /** @var mysqli $conn */
        $conn = require BASE_PATH . '/config/database.php';

        if (!$conn || !($conn instanceof mysqli)) {
            die('Database connection not available.');
        }

        $recentOrders = [];

        $sqlRecentOrders = "
            SELECT
                o.order_id,
                o.ordered_at,
                o.payment_method,
                o.total_gbp,
                o.status,
                c.first_name AS customer_first_name,
                c.last_name AS customer_last_name,
                s.first_name AS staff_first_name,
                s.last_name AS staff_last_name
            FROM orders o
            INNER JOIN customers c ON o.customer_id = c.customer_id
            INNER JOIN staff s ON o.taken_by_staff_id = s.staff_id
            ORDER BY o.ordered_at DESC
        ";

        $resultRecentOrders = $conn->query($sqlRecentOrders);

        if ($resultRecentOrders) {
            while ($row = $resultRecentOrders->fetch_assoc()) {
                $recentOrders[] = $row;
            }
        }

        $view = BASE_PATH . '/app/Views/admin/orders.php';
        require BASE_PATH . '/app/Views/layout.php';
    }

    public function delete(): void
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        if (empty($_SESSION['auth']['logged_in'])) {
            header('Location: /admin-login');
            exit;
        }

        $orderId = isset($_GET['id']) ? (int) $_GET['id'] : 0;

        if ($orderId <= 0) {
            die('Invalid order ID.');
        }

        /** @var mysqli $conn */
        $conn = require BASE_PATH . '/config/database.php';

        if (!$conn || !($conn instanceof mysqli)) {
            die('Database connection not available.');
        }

        $stmt = $conn->prepare("DELETE FROM orders WHERE order_id = ?");

        if (!$stmt) {
            die('Prepare failed: ' . $conn->error);
        }

        $stmt->bind_param("i", $orderId);

        if (!$stmt->execute()) {
            die('Delete failed: ' . $stmt->error);
        }

        $stmt->close();

        header('Location: /orders');
        exit;
    }

    public function edit(): void
    {
        $title = 'Fast Burgers - Edit Order';
        $errors = [];

        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        if (empty($_SESSION['auth']['logged_in'])) {
            header('Location: /admin-login');
            exit;
        }

        $orderId = isset($_GET['id']) ? (int) $_GET['id'] : 0;

        if ($orderId <= 0) {
            die('Invalid order ID.');
        }

        /** @var mysqli $conn */
        $conn = require BASE_PATH . '/config/database.php';

        if (!$conn || !($conn instanceof mysqli)) {
            die('Database connection not available.');
        }

        // If form submitted, update order
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $paymentMethod = trim($_POST['payment_method'] ?? '');
            $status = trim($_POST['status'] ?? '');
            $totalGbp = isset($_POST['total_gbp']) ? (float) $_POST['total_gbp'] : 0;

            if ($paymentMethod === '') {
                $errors[] = 'Payment method is required.';
            }

            if ($status === '') {
                $errors[] = 'Status is required.';
            }

            if ($totalGbp < 0) {
                $errors[] = 'Total must be 0 or greater.';
            }

            if (empty($errors)) {
                $stmt = $conn->prepare("
                    UPDATE orders
                    SET payment_method = ?, status = ?, total_gbp = ?
                    WHERE order_id = ?
                ");

                if (!$stmt) {
                    die('Prepare failed: ' . $conn->error);
                }

                $stmt->bind_param("ssdi", $paymentMethod, $status, $totalGbp, $orderId);

                if (!$stmt->execute()) {
                    die('Update failed: ' . $stmt->error);
                }

                $stmt->close();

                header('Location: /orders');
                exit;
            }
        }

        // Load current order data
        $stmt = $conn->prepare("
            SELECT order_id, ordered_at, payment_method, status, total_gbp
            FROM orders
            WHERE order_id = ?
            LIMIT 1
        ");

        if (!$stmt) {
            die('Prepare failed: ' . $conn->error);
        }

        $stmt->bind_param("i", $orderId);
        $stmt->execute();
        $result = $stmt->get_result();
        $order = $result ? $result->fetch_assoc() : null;
        $stmt->close();

        if (!$order) {
            die('Order not found.');
        }

        $view = BASE_PATH . '/app/Views/admin/edit-order.php';
        require BASE_PATH . '/app/Views/layout.php';
    }
}