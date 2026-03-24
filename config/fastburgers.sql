-- FastBurgers Prototype RDBMS (MySQL 8+)
-- Ready to import into phpMyAdmin.
-- Focus: orders taken by staff, popular items, payment method, menus (regular + savers),
-- shifts for managers/sales, and stock with automatic restock requests.

SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- ---------------------------------------------------------------------
-- 1) Database
-- ---------------------------------------------------------------------
DROP DATABASE IF EXISTS fastburgers;
CREATE DATABASE fastburgers
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE fastburgers;

-- ---------------------------------------------------------------------
-- 2) Core reference tables
-- ---------------------------------------------------------------------

-- Outlets (100+ in the UK)
CREATE TABLE outlets (
  outlet_id        INT AUTO_INCREMENT PRIMARY KEY,
  outlet_code      VARCHAR(20) NOT NULL UNIQUE,   -- e.g., FB-GLA-001
  name             VARCHAR(100) NOT NULL,
  address_line1    VARCHAR(120) NOT NULL,
  city             VARCHAR(80)  NOT NULL,
  postcode         VARCHAR(12)  NOT NULL,
  region           VARCHAR(60)  NOT NULL,         -- e.g., Scotland, London, etc.
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Staff: managers + sales staff take orders; cooks do not take orders from customers
CREATE TABLE staff (
  staff_id     INT AUTO_INCREMENT PRIMARY KEY,
  outlet_id    INT NOT NULL,
  first_name   VARCHAR(60) NOT NULL,
  last_name    VARCHAR(60) NOT NULL,
  role         ENUM('manager','sales','cook') NOT NULL,
  email        VARCHAR(120) NULL,
  is_active    TINYINT(1) NOT NULL DEFAULT 1,
  hired_on     DATE NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_staff_outlet
    FOREIGN KEY (outlet_id) REFERENCES outlets(outlet_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_staff_outlet_role (outlet_id, role)
) ENGINE=InnoDB;

-- Shifts for managers and sales staff (cooks can be scheduled too, but only managers/sales take orders)
CREATE TABLE shifts (
  shift_id      BIGINT AUTO_INCREMENT PRIMARY KEY,
  staff_id      INT NOT NULL,
  outlet_id     INT NOT NULL,
  shift_start   DATETIME NOT NULL,
  shift_end     DATETIME NOT NULL,
  role_on_shift ENUM('manager','sales','cook') NOT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_shifts_staff
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_shifts_outlet
    FOREIGN KEY (outlet_id) REFERENCES outlets(outlet_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_shifts_outlet_time (outlet_id, shift_start, shift_end),
  INDEX idx_shifts_staff_time  (staff_id, shift_start, shift_end)
) ENGINE=InnoDB;

-- Customers placing orders
CREATE TABLE customers (
  customer_id   BIGINT AUTO_INCREMENT PRIMARY KEY,
  first_name    VARCHAR(60) NOT NULL,
  last_name     VARCHAR(60) NOT NULL,
  phone         VARCHAR(25) NULL,
  email         VARCHAR(120) NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_customers_name (last_name, first_name)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3) Menu + Product model
-- ---------------------------------------------------------------------
-- Requirement:
-- - Two menus: regular and savers
-- - All products sold must be on either regular or savers (we model this via products.default_menu)
-- - Regular menu has a breakfast section that finishes at 11am each day
-- - Savers menu has start/end dates and changes monthly

CREATE TABLE menus (
  menu_id      INT AUTO_INCREMENT PRIMARY KEY,
  menu_type    ENUM('regular','savers') NOT NULL,
  name         VARCHAR(100) NOT NULL,
  start_date   DATE NULL, -- used for savers
  end_date     DATE NULL, -- used for savers
  is_active    TINYINT(1) NOT NULL DEFAULT 1,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (
    (menu_type='regular' AND start_date IS NULL AND end_date IS NULL)
    OR
    (menu_type='savers' AND start_date IS NOT NULL AND end_date IS NOT NULL)
  ),
  INDEX idx_menus_type_active (menu_type, is_active),
  INDEX idx_menus_savers_dates (start_date, end_date)
) ENGINE=InnoDB;

-- Products: every product belongs to either the regular menu or savers menu by default.
CREATE TABLE products (
  product_id      INT AUTO_INCREMENT PRIMARY KEY,
  sku             VARCHAR(30) NOT NULL UNIQUE,
  name            VARCHAR(120) NOT NULL,
  category        ENUM('burger','chips','drink','breakfast','dessert','other') NOT NULL,
  price_gbp       DECIMAL(8,2) NOT NULL,
  default_menu    ENUM('regular','savers') NOT NULL,
  is_active       TINYINT(1) NOT NULL DEFAULT 1,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_products_menu_category (default_menu, category),
  INDEX idx_products_name (name)
) ENGINE=InnoDB;

-- Menu items: which products appear on which menu + optional time window for breakfast.
CREATE TABLE menu_items (
  menu_item_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
  menu_id          INT NOT NULL,
  product_id       INT NOT NULL,
  section          ENUM('breakfast','mains','sides','drinks','desserts','other') NOT NULL DEFAULT 'mains',
  available_from   TIME NULL, -- e.g., breakfast starts at 06:00
  available_to     TIME NULL, -- breakfast ends at 11:00
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_menu_items_menu
    FOREIGN KEY (menu_id) REFERENCES menus(menu_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_menu_items_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  UNIQUE KEY uq_menu_product (menu_id, product_id),
  INDEX idx_menu_items_menu_section (menu_id, section)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4) Orders
-- ---------------------------------------------------------------------
-- Track:
-- - which customer places which order
-- - all items on that order
-- - paid by cash or card
-- - which member of staff took that order
-- - outlet-level reporting across all outlets

CREATE TABLE orders (
  order_id       BIGINT AUTO_INCREMENT PRIMARY KEY,
  outlet_id      INT NOT NULL,
  customer_id    BIGINT NOT NULL,
  taken_by_staff_id INT NOT NULL,
  ordered_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  payment_method ENUM('cash','card') NOT NULL,
  total_gbp      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  status         ENUM('placed','paid','cancelled') NOT NULL DEFAULT 'paid',
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders_outlet
    FOREIGN KEY (outlet_id) REFERENCES outlets(outlet_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_orders_staff
    FOREIGN KEY (taken_by_staff_id) REFERENCES staff(staff_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_orders_outlet_date (outlet_id, ordered_at),
  INDEX idx_orders_staff_date (taken_by_staff_id, ordered_at),
  INDEX idx_orders_payment (payment_method)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  order_item_id  BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id       BIGINT NOT NULL,
  product_id     INT NOT NULL,
  quantity       INT NOT NULL DEFAULT 1,
  unit_price_gbp DECIMAL(8,2) NOT NULL,
  line_total_gbp DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_order_items_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_order_items_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_order_items_order (order_id),
  INDEX idx_order_items_product (product_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5) Stock + automatic restock requests
-- ---------------------------------------------------------------------
-- Track stock per outlet per product.
-- Auto-create a restock request when stock drops below a reorder level.
-- Manager is responsible for keeping stock up to date, so we record manager_id on updates/requests.

CREATE TABLE stock (
  stock_id        BIGINT AUTO_INCREMENT PRIMARY KEY,
  outlet_id       INT NOT NULL,
  product_id      INT NOT NULL,
  quantity        INT NOT NULL DEFAULT 0,
  unit            ENUM('items','bags_1kg','litres','other') NOT NULL DEFAULT 'items',
  last_updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_updated_by_manager_id INT NULL,
  CONSTRAINT fk_stock_outlet
    FOREIGN KEY (outlet_id) REFERENCES outlets(outlet_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_stock_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_stock_manager
    FOREIGN KEY (last_updated_by_manager_id) REFERENCES staff(staff_id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  UNIQUE KEY uq_stock_outlet_product (outlet_id, product_id),
  INDEX idx_stock_outlet (outlet_id),
  INDEX idx_stock_product (product_id)
) ENGINE=InnoDB;

-- Reorder rules: per product thresholds (e.g., burgers < 500, chips bags < 200, etc.)
CREATE TABLE stock_rules (
  stock_rule_id  INT AUTO_INCREMENT PRIMARY KEY,
  product_id     INT NOT NULL UNIQUE,
  reorder_level  INT NOT NULL,       -- when quantity goes below this, request restock
  reorder_amount INT NOT NULL,       -- suggested quantity to order
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_stock_rules_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- Restock requests
CREATE TABLE restock_requests (
  restock_request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  outlet_id          INT NOT NULL,
  product_id         INT NOT NULL,
  requested_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  requested_by_manager_id INT NULL,
  current_quantity   INT NOT NULL,
  reorder_level      INT NOT NULL,
  suggested_amount   INT NOT NULL,
  status             ENUM('open','ordered','received','cancelled') NOT NULL DEFAULT 'open',
  CONSTRAINT fk_restock_outlet
    FOREIGN KEY (outlet_id) REFERENCES outlets(outlet_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_restock_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_restock_manager
    FOREIGN KEY (requested_by_manager_id) REFERENCES staff(staff_id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  INDEX idx_restock_outlet_status (outlet_id, status),
  INDEX idx_restock_product_status (product_id, status)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6) Triggers (business rules enforcement)
-- ---------------------------------------------------------------------

DELIMITER $$

-- (A) Prevent cooks from taking orders
CREATE TRIGGER trg_orders_no_cook
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
  DECLARE staffRole VARCHAR(20);

  SELECT role INTO staffRole
  FROM staff
  WHERE staff_id = NEW.taken_by_staff_id;

  IF staffRole = 'cook' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cooks cannot take orders directly from customers.';
  END IF;
END$$

-- (B) Auto-calculate line totals in order_items (safety net)
CREATE TRIGGER trg_order_items_calc
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
  SET NEW.line_total_gbp = NEW.unit_price_gbp * NEW.quantity;
END$$

-- (C) Update order total whenever a new order item is inserted
CREATE TRIGGER trg_orders_update_total_after_item
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
  UPDATE orders
  SET total_gbp = (
    SELECT IFNULL(SUM(line_total_gbp), 0)
    FROM order_items
    WHERE order_id = NEW.order_id
  )
  WHERE order_id = NEW.order_id;
END$$

-- (D) Create a restock request automatically when stock drops below threshold
--     This trigger fires on INSERT and UPDATE of stock.
CREATE TRIGGER trg_stock_restock_after_update
AFTER UPDATE ON stock
FOR EACH ROW
BEGIN
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
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- 7) Sample data (small but useful for testing queries)
-- ---------------------------------------------------------------------

INSERT INTO outlets (outlet_code, name, address_line1, city, postcode, region) VALUES
('FB-LON-001', 'FastBurgers London Central', '1 High Street', 'London', 'SW1A 1AA', 'London'),
('FB-MAN-001', 'FastBurgers Manchester Piccadilly', '10 Market Road', 'Manchester', 'M1 1AE', 'North West');

-- Staff: each outlet has 2 managers + sales staff + cooks
INSERT INTO staff (outlet_id, first_name, last_name, role, email, hired_on) VALUES
(1, 'Aisha', 'Khan', 'manager', 'aisha.khan@fastburgers.test', '2024-01-10'),
(1, 'Tom', 'Bennett', 'manager', 'tom.bennett@fastburgers.test', '2024-02-12'),
(1, 'Leah', 'Jones', 'sales',   'leah.jones@fastburgers.test', '2024-04-01'),
(1, 'Sam',  'Patel', 'sales',   'sam.patel@fastburgers.test', '2024-05-15'),
(1, 'Ivy',  'Wong',  'cook',    'ivy.wong@fastburgers.test', '2024-03-20'),

(2, 'Noah', 'Evans', 'manager', 'noah.evans@fastburgers.test', '2023-11-05'),
(2, 'Priya','Singh', 'manager', 'priya.singh@fastburgers.test', '2024-01-22'),
(2, 'Mia',  'Brown', 'sales',   'mia.brown@fastburgers.test', '2024-02-14'),
(2, 'Jack', 'White', 'sales',   'jack.white@fastburgers.test', '2024-06-02'),
(2, 'Ben',  'Green', 'cook',    'ben.green@fastburgers.test', '2024-03-01');

-- Shifts (example)
INSERT INTO shifts (staff_id, outlet_id, shift_start, shift_end, role_on_shift) VALUES
(1, 1, '2026-01-20 08:00:00', '2026-01-20 16:00:00', 'manager'),
(3, 1, '2026-01-20 09:00:00', '2026-01-20 17:00:00', 'sales'),
(6, 2, '2026-01-20 08:00:00', '2026-01-20 16:00:00', 'manager'),
(8, 2, '2026-01-20 10:00:00', '2026-01-20 18:00:00', 'sales');

-- Menus
INSERT INTO menus (menu_type, name, start_date, end_date, is_active) VALUES
('regular', 'Regular Menu', NULL, NULL, 1),
('savers',  'Festive Savers Menu', '2025-12-01', '2025-12-31', 0),
('savers',  'January Savers Menu', '2026-01-01', '2026-01-31', 1);

-- Products (all belong to either regular or savers by default)
INSERT INTO products (sku, name, category, price_gbp, default_menu) VALUES
('BRG-001', 'Classic Burger', 'burger', 4.99, 'regular'),
('BRG-002', 'Cheese Burger',  'burger', 5.49, 'regular'),
('CHP-001', 'Chips (Regular)', 'chips',  2.49, 'regular'),
('DRK-001', 'Cola (500ml)',    'drink',  1.99, 'regular'),
('BRF-001', 'Breakfast Muffin','breakfast', 3.49, 'regular'),
('SAV-001', 'Saver Burger Deal', 'burger', 3.99, 'savers'),
('SAV-002', 'Saver Chips Deal',  'chips',  1.49, 'savers');

-- Menu items (Regular + Savers)
-- Breakfast items end at 11:00 every day
INSERT INTO menu_items (menu_id, product_id, section, available_from, available_to) VALUES
(1, 1, 'mains',     NULL, NULL),
(1, 2, 'mains',     NULL, NULL),
(1, 3, 'sides',     NULL, NULL),
(1, 4, 'drinks',    NULL, NULL),
(1, 5, 'breakfast', '06:00:00', '11:00:00'),

(3, 6, 'mains',     NULL, NULL),
(3, 7, 'sides',     NULL, NULL);

-- Customers
INSERT INTO customers (first_name, last_name, phone, email) VALUES
('Olivia', 'Taylor', '07123456789', 'olivia.taylor@example.test'),
('George', 'Smith',  '07987654321', 'george.smith@example.test'),
('Amelia', 'Wilson', NULL, NULL);

-- Orders + order items (sample so you can query “top staff” and “popular products”)
-- Outlet 1: Leah (sales) takes 3 orders
INSERT INTO orders (outlet_id, customer_id, taken_by_staff_id, ordered_at, payment_method, status)
VALUES
(1, 1, 3, '2026-01-20 09:15:00', 'card', 'paid'),
(1, 2, 3, '2026-01-20 09:45:00', 'cash', 'paid'),
(1, 3, 3, '2026-01-20 10:05:00', 'card', 'paid');

INSERT INTO order_items (order_id, product_id, quantity, unit_price_gbp, line_total_gbp) VALUES
(1, 5, 1, 3.49, 0), -- breakfast muffin
(1, 4, 1, 1.99, 0),
(2, 1, 1, 4.99, 0),
(2, 3, 1, 2.49, 0),
(3, 6, 1, 3.99, 0), -- saver deal
(3, 7, 1, 1.49, 0);

-- Outlet 1: manager Aisha also takes 1 order
INSERT INTO orders (outlet_id, customer_id, taken_by_staff_id, ordered_at, payment_method, status)
VALUES (1, 2, 1, '2026-01-20 11:20:00', 'cash', 'paid');

INSERT INTO order_items (order_id, product_id, quantity, unit_price_gbp, line_total_gbp) VALUES
(4, 2, 1, 5.49, 0),
(4, 3, 1, 2.49, 0);

-- Outlet 2: Mia takes 2 orders
INSERT INTO orders (outlet_id, customer_id, taken_by_staff_id, ordered_at, payment_method, status)
VALUES
(2, 1, 8, '2026-01-20 12:10:00', 'card', 'paid'),
(2, 3, 8, '2026-01-20 12:40:00', 'card', 'paid');

INSERT INTO order_items (order_id, product_id, quantity, unit_price_gbp, line_total_gbp) VALUES
(5, 1, 2, 4.99, 0),
(5, 3, 2, 2.49, 0),
(6, 6, 1, 3.99, 0),
(6, 4, 1, 1.99, 0);

-- Stock setup (per outlet)
INSERT INTO stock (outlet_id, product_id, quantity, unit, last_updated_by_manager_id) VALUES
(1, 1, 650, 'items', 1),   -- burgers
(1, 3, 250, 'bags_1kg', 1), -- chips bags
(2, 1, 520, 'items', 6),
(2, 3, 190, 'bags_1kg', 6); -- below threshold example

-- Stock reorder rules (example thresholds from the brief)
-- burgers: request restock below 500
-- chips (1kg bags): request restock below 200
INSERT INTO stock_rules (product_id, reorder_level, reorder_amount) VALUES
(1, 500, 1000),
(3, 200, 500);

-- To see the restock trigger in action, try updating stock quantity lower than threshold:
-- UPDATE stock SET quantity = 480, last_updated_by_manager_id = 1 WHERE outlet_id=1 AND product_id=1;

-- ---------------------------------------------------------------------
-- 8) Useful example queries (optional)
-- ---------------------------------------------------------------------
-- 8.1 Staff taking the most orders (across all outlets)
-- SELECT taken_by_staff_id, COUNT(*) AS orders_taken
-- FROM orders
-- GROUP BY taken_by_staff_id
-- ORDER BY orders_taken DESC;
--
-- 8.2 Most popular products (by quantity sold)
-- SELECT p.name, SUM(oi.quantity) AS qty_sold
-- FROM order_items oi
-- JOIN products p ON p.product_id = oi.product_id
-- GROUP BY p.product_id
-- ORDER BY qty_sold DESC;
