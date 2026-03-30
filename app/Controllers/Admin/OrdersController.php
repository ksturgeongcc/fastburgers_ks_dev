<?php

class OrdersController
{
    public function index(): void
    {
        $title = 'Fast Burgers - Orders';

        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        // Optional protection
        if (empty($_SESSION['auth']['logged_in'])) {
            header('Location: /admin-login');
            exit;
        }

        /** @var mysqli $conn */
        $conn = require BASE_PATH . '/config/database.php';

        if (!$conn || !($conn instanceof mysqli)) {
            die('Database connection not available.');
        }

        // Default values
        $recentOrders = [];

      

        // Recent orders with customer and staff names
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
            LIMIT 5
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
}