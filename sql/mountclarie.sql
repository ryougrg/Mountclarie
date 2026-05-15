-- =====================================================
-- Database Schema for Himalayan Montclaire E-commerce
-- Module: CS5054NP Advanced Programming & Technologies
-- Author: Himalayan Montclaire Team
-- Date: April 2026
-- =====================================================

-- Create Database
CREATE DATABASE IF NOT EXISTS himalayan_montclaire;
USE himalayan_montclaire;

-- =====================================================
-- 1. USERS TABLE (with approval workflow)
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
                                     id INT PRIMARY KEY AUTO_INCREMENT,
                                     username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('ADMIN', 'USER') DEFAULT 'USER',
    status ENUM('PENDING', 'APPROVED', 'BLOCKED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_status (status),
    INDEX idx_role (role)
    );

-- =====================================================
-- 2. CATEGORIES / TOPICS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS categories (
                                          id INT PRIMARY KEY AUTO_INCREMENT,
                                          name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    parent_category_id INT NULL,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_name (name),
    INDEX idx_status (status)
    );

-- =====================================================
-- 3. PRODUCTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS products (
                                        id INT PRIMARY KEY AUTO_INCREMENT,
                                        category_id INT NOT NULL,
                                        name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    size ENUM('XS', 'S', 'M', 'L', 'XL', 'XXL') DEFAULT 'M',
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    image_url VARCHAR(500),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
    INDEX idx_category (category_id),
    INDEX idx_status (status),
    INDEX idx_price (price),
    FULLTEXT INDEX idx_search (name, description)
    );

-- =====================================================
-- 4. CART ITEMS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS cart_items (
                                          id INT PRIMARY KEY AUTO_INCREMENT,
                                          user_id INT NOT NULL,
                                          product_id INT NOT NULL,
                                          quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_cart_item (user_id, product_id),
    INDEX idx_user (user_id)
    );

-- =====================================================
-- 5. WISHLIST ITEMS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS wishlist_items (
                                              id INT PRIMARY KEY AUTO_INCREMENT,
                                              user_id INT NOT NULL,
                                              product_id INT NOT NULL,
                                              added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                              FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_wishlist_item (user_id, product_id),
    INDEX idx_user (user_id)
    );

-- =====================================================
-- 6. ORDERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS orders (
                                      id INT PRIMARY KEY AUTO_INCREMENT,
                                      order_number VARCHAR(50) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    status ENUM('PENDING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    shipping_address TEXT NOT NULL,
    payment_method ENUM('COD', 'CARD', 'ESEWA', 'KHALTI') DEFAULT 'COD',
    payment_status ENUM('PENDING', 'PAID', 'FAILED') DEFAULT 'PENDING',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_order_date (order_date),
    INDEX idx_order_number (order_number)
    );

-- =====================================================
-- 7. ORDER ITEMS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS order_items (
                                           id INT PRIMARY KEY AUTO_INCREMENT,
                                           order_id INT NOT NULL,
                                           product_id INT NOT NULL,
                                           product_name VARCHAR(200) NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    INDEX idx_order (order_id),
    INDEX idx_product (product_id)
    );

-- =====================================================
-- 8. PRODUCT REVIEWS TABLE (Optional)
-- =====================================================
CREATE TABLE IF NOT EXISTS product_reviews (
                                               id INT PRIMARY KEY AUTO_INCREMENT,
                                               product_id INT NOT NULL,
                                               user_id INT NOT NULL,
                                               rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_product (product_id),
    UNIQUE KEY unique_review (product_id, user_id)
    );

-- =====================================================
-- 9. SESSIONS TABLE (For session management)
-- =====================================================
CREATE TABLE IF NOT EXISTS user_sessions (
                                             id INT PRIMARY KEY AUTO_INCREMENT,
                                             session_id VARCHAR(255) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_session (session_id),
    INDEX idx_expires (expires_at)
    );

-- =====================================================
-- 10. ACTIVITY LOGS TABLE (For tracking)
-- =====================================================
CREATE TABLE IF NOT EXISTS activity_logs (
                                             id INT PRIMARY KEY AUTO_INCREMENT,
                                             user_id INT,
                                             action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_action (action),
    INDEX idx_created (created_at)
    );

-- =====================================================
-- VIEWS FOR REPORTS AND ANALYTICS
-- =====================================================

-- 1. Order Summary View
CREATE OR REPLACE VIEW order_summary AS
SELECT
    o.id,
    o.order_number,
    o.user_id,
    u.full_name,
    u.email,
    o.order_date,
    o.total_amount,
    o.status,
    o.payment_method,
    COUNT(oi.id) as item_count
FROM orders o
         JOIN users u ON o.user_id = u.id
         LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id;

-- 2. Product Sales Report View
CREATE OR REPLACE VIEW product_sales_report AS
SELECT
    p.id,
    p.name,
    c.name as category_name,
    SUM(oi.quantity) as total_sold,
    SUM(oi.subtotal) as total_revenue,
    p.stock_quantity as current_stock,
    COUNT(DISTINCT o.id) as number_of_orders
FROM products p
         LEFT JOIN categories c ON p.category_id = c.id
         LEFT JOIN order_items oi ON p.id = oi.product_id
         LEFT JOIN orders o ON oi.order_id = o.id AND o.status != 'CANCELLED'
GROUP BY p.id;

-- 3. User Activity View
CREATE OR REPLACE VIEW user_activity_summary AS
SELECT
    u.id,
    u.username,
    u.email,
    u.full_name,
    u.status,
    COUNT(DISTINCT o.id) as total_orders,
    COALESCE(SUM(o.total_amount), 0) as total_spent,
    COUNT(DISTINCT w.product_id) as wishlist_count,
    COUNT(DISTINCT c.product_id) as cart_count
FROM users u
         LEFT JOIN orders o ON u.id = o.user_id AND o.status != 'CANCELLED'
LEFT JOIN wishlist_items w ON u.id = w.user_id
    LEFT JOIN cart_items c ON u.id = c.user_id
GROUP BY u.id;

-- 4. Low Stock Alert View
CREATE OR REPLACE VIEW low_stock_alert AS
SELECT
    p.id,
    p.name,
    c.name as category,
    p.stock_quantity,
    p.status,
    CASE
        WHEN p.stock_quantity = 0 THEN 'OUT OF STOCK'
        WHEN p.stock_quantity <= 5 THEN 'CRITICAL'
        WHEN p.stock_quantity <= 10 THEN 'LOW'
        ELSE 'OK'
        END as stock_status
FROM products p
         JOIN categories c ON p.category_id = c.id
WHERE p.stock_quantity <= 10 AND p.status = 'ACTIVE'
ORDER BY p.stock_quantity ASC;

-- 5. Monthly Sales Report View
CREATE OR REPLACE VIEW monthly_sales_report AS
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') as month,
    COUNT(DISTINCT o.id) as total_orders,
    SUM(o.total_amount) as total_sales,
    COUNT(DISTINCT o.user_id) as unique_customers,
    AVG(o.total_amount) as average_order_value
FROM orders o
WHERE o.status != 'CANCELLED'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month DESC;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Procedure to place an order (with transaction)
DELIMITER //

CREATE PROCEDURE PlaceOrder(
    IN p_user_id INT,
    IN p_shipping_address TEXT,
    IN p_payment_method VARCHAR(20)
)
BEGIN
    DECLARE v_order_id INT;
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_order_number VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
RESIGNAL;
END;

START TRANSACTION;

-- Calculate total
SELECT SUM(p.price * c.quantity) INTO v_total
FROM cart_items c
         JOIN products p ON c.product_id = p.id
WHERE c.user_id = p_user_id;

-- Generate order number
SET v_order_number = CONCAT('ORD', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(p_user_id, 5, '0'), LPAD(FLOOR(RAND() * 1000), 3, '0'));

    -- Create order
INSERT INTO orders (order_number, user_id, total_amount, shipping_address, payment_method)
VALUES (v_order_number, p_user_id, v_total, p_shipping_address, p_payment_method);

SET v_order_id = LAST_INSERT_ID();

    -- Move cart items to order_items
INSERT INTO order_items (order_id, product_id, product_name, product_price, quantity, subtotal)
SELECT v_order_id, p.id, p.name, p.price, c.quantity, (p.price * c.quantity)
FROM cart_items c
         JOIN products p ON c.product_id = p.id
WHERE c.user_id = p_user_id;

-- Update product stock
UPDATE products p
    JOIN cart_items c ON p.id = c.product_id
    SET p.stock_quantity = p.stock_quantity - c.quantity
WHERE c.user_id = p_user_id;

-- Clear cart
DELETE FROM cart_items WHERE user_id = p_user_id;

COMMIT;

SELECT v_order_id as order_id, v_order_number as order_number;
END//

DELIMITER ;

-- Procedure to approve user registration
DELIMITER //

CREATE PROCEDURE ApproveUser(
    IN p_admin_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE v_admin_role VARCHAR(10);

    -- Check if admin
SELECT role INTO v_admin_role FROM users WHERE id = p_admin_id;

IF v_admin_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unauthorized: Admin access required';
END IF;

    -- Update user status
UPDATE users SET status = 'APPROVED', updated_at = NOW() WHERE id = p_user_id;

-- Log activity
INSERT INTO activity_logs (user_id, action, details)
VALUES (p_admin_id, 'USER_APPROVED', CONCAT('Approved user ID: ', p_user_id));
END//

DELIMITER ;

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger to update product stock after order
DELIMITER //

CREATE TRIGGER update_stock_after_order
    AFTER INSERT ON order_items
    FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity,
        updated_at = NOW()
    WHERE id = NEW.product_id;
END//

DELIMITER ;

-- Trigger to log user registration
DELIMITER //

CREATE TRIGGER log_user_registration
    AFTER INSERT ON users
    FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (user_id, action, details, ip_address)
    VALUES (NEW.id, 'USER_REGISTERED', CONCAT('New user: ', NEW.email), USER());
END//

DELIMITER ;

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Additional indexes for search performance
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_cart_user_product ON cart_items(user_id, product_id);
CREATE INDEX idx_wishlist_user_product ON wishlist_items(user_id, product_id);