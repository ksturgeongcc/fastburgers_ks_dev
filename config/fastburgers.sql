-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Mar 30, 2026 at 11:24 PM
-- Server version: 8.0.40
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fastburgers`
--

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` bigint NOT NULL,
  `first_name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `first_name`, `last_name`, `phone`, `email`, `created_at`, `password`) VALUES
(1, 'Olivia', 'Taylor', '07123456789', 'olivia.taylor@example.test', '2026-02-17 22:11:05', ''),
(2, 'George', 'Smith', '07987654321', 'george.smith@example.test', '2026-02-17 22:11:05', ''),
(3, 'Amelia', 'Wilson', NULL, NULL, '2026-02-17 22:11:05', ''),
(4, 'Kareb', 'Sturgeon', '09876 566545', 'ksturgeongcc@gmail.com', '2026-02-24 23:26:59', '$2y$10$j6yodKBEeKZHUSKpCCTVteLprhBZw8aXrkA97sz9/DB.QmljN/7ri'),
(5, 'karen', 'sturgeon', '87653 535555', 'maccasturgeon@gmail.com', '2026-02-24 23:49:23', '$2y$10$/f9zYzosyWthy4pcfyYKwOEl1zRl3hPLCCz81fnf49FaohoBbhkXa'),
(6, 'karen', 'sturgeon', '4545454555', 'ksturgeon@glasgow.ac.uk', '2026-02-25 09:23:42', '$2y$10$IkBFcNglA582edBBGYihxOw1qJBextp6JkYfmoXIULG.j1OyI75M6'),
(7, 'karen', 'sturgeon', NULL, 'karen@email.com', '2026-03-16 23:41:50', '$2y$10$3D.5frAG64XLAm91NkI.rOotRoKNiPNUnC3jYZZ8d0A0x/.hGKFy.');

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

CREATE TABLE `menus` (
  `menu_id` int NOT NULL,
  `menu_type` enum('regular','savers') COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`menu_id`, `menu_type`, `name`, `start_date`, `end_date`, `is_active`, `created_at`) VALUES
(1, 'regular', 'Regular Menu', NULL, NULL, 1, '2026-02-17 22:11:05'),
(2, 'savers', 'Festive Savers Menu', '2025-12-01', '2025-12-31', 0, '2026-02-17 22:11:05'),
(3, 'savers', 'January Savers Menu', '2026-01-01', '2026-01-31', 1, '2026-02-17 22:11:05');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `menu_item_id` bigint NOT NULL,
  `menu_id` int NOT NULL,
  `product_id` int NOT NULL,
  `section` enum('breakfast','mains','sides','drinks','desserts','other') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'mains',
  `available_from` time DEFAULT NULL,
  `available_to` time DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`menu_item_id`, `menu_id`, `product_id`, `section`, `available_from`, `available_to`, `created_at`) VALUES
(1, 1, 1, 'mains', NULL, NULL, '2026-02-17 22:11:05'),
(2, 1, 2, 'mains', NULL, NULL, '2026-02-17 22:11:05'),
(3, 1, 3, 'sides', NULL, NULL, '2026-02-17 22:11:05'),
(4, 1, 4, 'drinks', NULL, NULL, '2026-02-17 22:11:05'),
(5, 1, 5, 'breakfast', '06:00:00', '11:00:00', '2026-02-17 22:11:05'),
(6, 3, 6, 'mains', NULL, NULL, '2026-02-17 22:11:05'),
(7, 3, 7, 'sides', NULL, NULL, '2026-02-17 22:11:05');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` bigint NOT NULL,
  `outlet_id` int NOT NULL,
  `customer_id` bigint NOT NULL,
  `taken_by_staff_id` int NOT NULL,
  `ordered_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_method` enum('cash','card') COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_gbp` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` enum('placed','paid','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'paid',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `outlet_id`, `customer_id`, `taken_by_staff_id`, `ordered_at`, `payment_method`, `total_gbp`, `status`, `created_at`) VALUES
(1, 1, 1, 3, '2026-01-20 09:15:00', 'card', 5.48, 'paid', '2026-02-17 22:11:05'),
(2, 1, 2, 3, '2026-01-20 09:45:00', 'cash', 7.48, 'paid', '2026-02-17 22:11:05'),
(3, 1, 3, 3, '2026-01-20 10:05:00', 'card', 5.48, 'paid', '2026-02-17 22:11:05'),
(4, 1, 2, 1, '2026-01-20 11:20:00', 'cash', 7.98, 'paid', '2026-02-17 22:11:05'),
(5, 2, 1, 8, '2026-01-20 12:10:00', 'card', 14.96, 'paid', '2026-02-17 22:11:05'),
(6, 2, 3, 8, '2026-01-20 12:40:00', 'card', 5.98, 'paid', '2026-02-17 22:11:05');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `trg_orders_no_cook` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
  DECLARE staffRole VARCHAR(20);

  SELECT role INTO staffRole
  FROM staff
  WHERE staff_id = NEW.taken_by_staff_id;

  IF staffRole = 'cook' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cooks cannot take orders directly from customers.';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` bigint NOT NULL,
  `order_id` bigint NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `unit_price_gbp` decimal(8,2) NOT NULL,
  `line_total_gbp` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `quantity`, `unit_price_gbp`, `line_total_gbp`) VALUES
(1, 1, 5, 1, 3.49, 3.49),
(2, 1, 4, 1, 1.99, 1.99),
(3, 2, 1, 1, 4.99, 4.99),
(4, 2, 3, 1, 2.49, 2.49),
(5, 3, 6, 1, 3.99, 3.99),
(6, 3, 7, 1, 1.49, 1.49),
(7, 4, 2, 1, 5.49, 5.49),
(8, 4, 3, 1, 2.49, 2.49),
(9, 5, 1, 2, 4.99, 9.98),
(10, 5, 3, 2, 2.49, 4.98),
(11, 6, 6, 1, 3.99, 3.99),
(12, 6, 4, 1, 1.99, 1.99);

--
-- Triggers `order_items`
--
DELIMITER $$
CREATE TRIGGER `trg_order_items_calc` BEFORE INSERT ON `order_items` FOR EACH ROW BEGIN
  SET NEW.line_total_gbp = NEW.unit_price_gbp * NEW.quantity;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_orders_update_total_after_item` AFTER INSERT ON `order_items` FOR EACH ROW BEGIN
  UPDATE orders
  SET total_gbp = (
    SELECT IFNULL(SUM(line_total_gbp), 0)
    FROM order_items
    WHERE order_id = NEW.order_id
  )
  WHERE order_id = NEW.order_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `outlets`
--

CREATE TABLE `outlets` (
  `outlet_id` int NOT NULL,
  `outlet_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_line1` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `postcode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `region` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `outlets`
--

INSERT INTO `outlets` (`outlet_id`, `outlet_code`, `name`, `address_line1`, `city`, `postcode`, `region`, `created_at`) VALUES
(1, 'FB-LON-001', 'FastBurgers London Central', '1 High Street', 'London', 'SW1A 1AA', 'London', '2026-02-17 22:11:05'),
(2, 'FB-MAN-001', 'FastBurgers Manchester Piccadilly', '10 Market Road', 'Manchester', 'M1 1AE', 'North West', '2026-02-17 22:11:05');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int NOT NULL,
  `sku` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` enum('burger','chips','drink','breakfast','dessert','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `price_gbp` decimal(8,2) NOT NULL,
  `default_menu` enum('regular','savers') COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `quantity` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `sku`, `name`, `category`, `price_gbp`, `default_menu`, `is_active`, `created_at`, `quantity`) VALUES
(1, 'BRG-001', 'Classic Burger', 'burger', 4.99, 'regular', 1, '2026-02-17 22:11:05', 0),
(2, 'BRG-002', 'Cheese Burger', 'burger', 5.49, 'regular', 1, '2026-02-17 22:11:05', 0),
(3, 'CHP-001', 'Chips (Regular)', 'chips', 2.49, 'regular', 1, '2026-02-17 22:11:05', 0),
(4, 'DRK-001', 'Cola (500ml)', 'drink', 1.99, 'regular', 1, '2026-02-17 22:11:05', 0),
(5, 'BRF-001', 'Breakfast Muffin', 'breakfast', 3.49, 'regular', 1, '2026-02-17 22:11:05', 0),
(6, 'SAV-001', 'Saver Burger Deal', 'burger', 3.99, 'savers', 1, '2026-02-17 22:11:05', 0),
(7, 'SAV-002', 'Saver Chips Deal', 'chips', 1.49, 'savers', 1, '2026-02-17 22:11:05', 0);

-- --------------------------------------------------------

--
-- Table structure for table `restock_requests`
--

CREATE TABLE `restock_requests` (
  `restock_request_id` bigint NOT NULL,
  `outlet_id` int NOT NULL,
  `product_id` int NOT NULL,
  `requested_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `requested_by_manager_id` int DEFAULT NULL,
  `current_quantity` int NOT NULL,
  `reorder_level` int NOT NULL,
  `suggested_amount` int NOT NULL,
  `status` enum('open','ordered','received','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shifts`
--

CREATE TABLE `shifts` (
  `shift_id` bigint NOT NULL,
  `staff_id` int NOT NULL,
  `outlet_id` int NOT NULL,
  `shift_start` datetime NOT NULL,
  `shift_end` datetime NOT NULL,
  `role_on_shift` enum('manager','sales','cook') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `shifts`
--

INSERT INTO `shifts` (`shift_id`, `staff_id`, `outlet_id`, `shift_start`, `shift_end`, `role_on_shift`, `created_at`) VALUES
(1, 1, 1, '2026-01-20 08:00:00', '2026-01-20 16:00:00', 'manager', '2026-02-17 22:11:05'),
(2, 3, 1, '2026-01-20 09:00:00', '2026-01-20 17:00:00', 'sales', '2026-02-17 22:11:05'),
(3, 6, 2, '2026-01-20 08:00:00', '2026-01-20 16:00:00', 'manager', '2026-02-17 22:11:05'),
(4, 8, 2, '2026-01-20 10:00:00', '2026-01-20 18:00:00', 'sales', '2026-02-17 22:11:05');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staff_id` int NOT NULL,
  `outlet_id` int NOT NULL,
  `first_name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('manager','sales','cook') COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `hired_on` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `password` varchar(132) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staff_id`, `outlet_id`, `first_name`, `last_name`, `role`, `email`, `is_active`, `hired_on`, `created_at`, `password`, `admin`) VALUES
(1, 1, 'Aisha', 'Khan', 'manager', 'aisha.khan@fastburgers.test', 1, '2024-01-10', '2026-02-17 22:11:05', '', 0),
(2, 1, 'Tom', 'Bennett', 'manager', 'tom.bennett@fastburgers.test', 1, '2024-02-12', '2026-02-17 22:11:05', '', 0),
(3, 1, 'Leah', 'Jones', 'sales', 'leah.jones@fastburgers.test', 1, '2024-04-01', '2026-02-17 22:11:05', '', 0),
(4, 1, 'Sam', 'Patel', 'sales', 'sam.patel@fastburgers.test', 1, '2024-05-15', '2026-02-17 22:11:05', '', 0),
(5, 1, 'Ivy', 'Wright', 'cook', 'ivy.wong@fastburgers.test', 1, '2024-03-20', '2026-02-17 22:11:05', '', 0),
(6, 2, 'Noah', 'Evans', 'manager', 'noah.evans@fastburgers.test', 1, '2023-11-05', '2026-02-17 22:11:05', '', 0),
(7, 2, 'Priya', 'Singh', 'manager', 'priya.singh@fastburgers.test', 1, '2024-01-22', '2026-02-17 22:11:05', '', 0),
(8, 2, 'Mia', 'Brown', 'sales', 'mia.brown@fastburgers.test', 1, '2024-02-14', '2026-02-17 22:11:05', '', 0),
(9, 2, 'Jack', 'White', 'sales', 'jack.white@fastburgers.test', 1, '2024-06-02', '2026-02-17 22:11:05', '', 0),
(10, 2, 'Ben', 'Green', 'cook', 'admin@email.com', 1, '2024-03-01', '2026-02-17 22:11:05', '$2y$10$3D.5frAG64XLAm91NkI.rOotRoKNiPNUnC3jYZZ8d0A0x/.hGKFy.', 1);

-- --------------------------------------------------------

--
-- Table structure for table `stock`
--

CREATE TABLE `stock` (
  `stock_id` bigint NOT NULL,
  `outlet_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `unit` enum('items','bags_1kg','litres','other') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'items',
  `last_updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_by_manager_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stock`
--

INSERT INTO `stock` (`stock_id`, `outlet_id`, `product_id`, `quantity`, `unit`, `last_updated_at`, `last_updated_by_manager_id`) VALUES
(1, 1, 1, 650, 'items', '2026-02-17 22:11:05', 1),
(2, 1, 3, 250, 'bags_1kg', '2026-02-17 22:11:05', 1),
(3, 2, 1, 520, 'items', '2026-02-17 22:11:05', 6),
(4, 2, 3, 190, 'bags_1kg', '2026-02-17 22:11:05', 6);

--
-- Triggers `stock`
--
DELIMITER $$
CREATE TRIGGER `trg_stock_restock_after_update` AFTER UPDATE ON `stock` FOR EACH ROW BEGIN
  DECLARE lvl INT;
  DECLARE amt INT;

  -- only react when quantity decreases or crosses threshold
  IF NEW.quantity < OLD.quantity THEN

    SELECT reorder_level, reorder_amount
      INTO lvl, amt
    FROM stock_rules
    WHERE product_id = NEW.product_id;

    -- If a rule exists AND we are below reorder level
    IF lvl IS NOT NULL AND NEW.quantity < lvl THEN

      -- Avoid spamming duplicates: only one OPEN request per outlet+product
      IF NOT EXISTS (
        SELECT 1 FROM restock_requests
        WHERE outlet_id = NEW.outlet_id
          AND product_id = NEW.product_id
          AND status = 'open'
      ) THEN
        INSERT INTO restock_requests (
          outlet_id, product_id, requested_by_manager_id,
          current_quantity, reorder_level, suggested_amount
        ) VALUES (
          NEW.outlet_id, NEW.product_id, NEW.last_updated_by_manager_id,
          NEW.quantity, lvl, amt
        );
      END IF;

    END IF;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `stock_rules`
--

CREATE TABLE `stock_rules` (
  `stock_rule_id` int NOT NULL,
  `product_id` int NOT NULL,
  `reorder_level` int NOT NULL,
  `reorder_amount` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stock_rules`
--

INSERT INTO `stock_rules` (`stock_rule_id`, `product_id`, `reorder_level`, `reorder_amount`, `created_at`) VALUES
(1, 1, 500, 1000, '2026-02-17 22:11:05'),
(2, 3, 200, 500, '2026-02-17 22:11:05');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`),
  ADD KEY `idx_customers_name` (`last_name`,`first_name`);

--
-- Indexes for table `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`menu_id`),
  ADD KEY `idx_menus_type_active` (`menu_type`,`is_active`),
  ADD KEY `idx_menus_savers_dates` (`start_date`,`end_date`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`menu_item_id`),
  ADD UNIQUE KEY `uq_menu_product` (`menu_id`,`product_id`),
  ADD KEY `fk_menu_items_product` (`product_id`),
  ADD KEY `idx_menu_items_menu_section` (`menu_id`,`section`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_orders_customer` (`customer_id`),
  ADD KEY `idx_orders_outlet_date` (`outlet_id`,`ordered_at`),
  ADD KEY `idx_orders_staff_date` (`taken_by_staff_id`,`ordered_at`),
  ADD KEY `idx_orders_payment` (`payment_method`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `idx_order_items_order` (`order_id`),
  ADD KEY `idx_order_items_product` (`product_id`);

--
-- Indexes for table `outlets`
--
ALTER TABLE `outlets`
  ADD PRIMARY KEY (`outlet_id`),
  ADD UNIQUE KEY `outlet_code` (`outlet_code`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `idx_products_menu_category` (`default_menu`,`category`),
  ADD KEY `idx_products_name` (`name`);

--
-- Indexes for table `restock_requests`
--
ALTER TABLE `restock_requests`
  ADD PRIMARY KEY (`restock_request_id`),
  ADD KEY `fk_restock_manager` (`requested_by_manager_id`),
  ADD KEY `idx_restock_outlet_status` (`outlet_id`,`status`),
  ADD KEY `idx_restock_product_status` (`product_id`,`status`);

--
-- Indexes for table `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`shift_id`),
  ADD KEY `idx_shifts_outlet_time` (`outlet_id`,`shift_start`,`shift_end`),
  ADD KEY `idx_shifts_staff_time` (`staff_id`,`shift_start`,`shift_end`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staff_id`),
  ADD KEY `idx_staff_outlet_role` (`outlet_id`,`role`);

--
-- Indexes for table `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`stock_id`),
  ADD UNIQUE KEY `uq_stock_outlet_product` (`outlet_id`,`product_id`),
  ADD KEY `fk_stock_manager` (`last_updated_by_manager_id`),
  ADD KEY `idx_stock_outlet` (`outlet_id`),
  ADD KEY `idx_stock_product` (`product_id`);

--
-- Indexes for table `stock_rules`
--
ALTER TABLE `stock_rules`
  ADD PRIMARY KEY (`stock_rule_id`),
  ADD UNIQUE KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `menus`
--
ALTER TABLE `menus`
  MODIFY `menu_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `menu_item_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `outlets`
--
ALTER TABLE `outlets`
  MODIFY `outlet_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `restock_requests`
--
ALTER TABLE `restock_requests`
  MODIFY `restock_request_id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shifts`
--
ALTER TABLE `shifts`
  MODIFY `shift_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `staff_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `stock`
--
ALTER TABLE `stock`
  MODIFY `stock_id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `stock_rules`
--
ALTER TABLE `stock_rules`
  MODIFY `stock_rule_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD CONSTRAINT `fk_menu_items_menu` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`menu_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_menu_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orders_outlet` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`outlet_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orders_staff` FOREIGN KEY (`taken_by_staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `restock_requests`
--
ALTER TABLE `restock_requests`
  ADD CONSTRAINT `fk_restock_manager` FOREIGN KEY (`requested_by_manager_id`) REFERENCES `staff` (`staff_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_restock_outlet` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`outlet_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_restock_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `shifts`
--
ALTER TABLE `shifts`
  ADD CONSTRAINT `fk_shifts_outlet` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`outlet_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_shifts_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `staff`
--
ALTER TABLE `staff`
  ADD CONSTRAINT `fk_staff_outlet` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`outlet_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `stock`
--
ALTER TABLE `stock`
  ADD CONSTRAINT `fk_stock_manager` FOREIGN KEY (`last_updated_by_manager_id`) REFERENCES `staff` (`staff_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stock_outlet` FOREIGN KEY (`outlet_id`) REFERENCES `outlets` (`outlet_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stock_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `stock_rules`
--
ALTER TABLE `stock_rules`
  ADD CONSTRAINT `fk_stock_rules_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
