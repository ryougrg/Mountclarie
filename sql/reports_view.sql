-- =====================================================
-- Additional Reports and Analytics Views
-- Himalayan Montclaire E-commerce
-- =====================================================

USE himalayan_montclaire;

-- 1. Top Selling Products Report
CREATE OR REPLACE VIEW top_selling_products AS
SELECT
    p.id,
    p.name,
    c.name as category,
    COALESCE(SUM(oi.quantity), 0) as total_sold,
    COALESCE(SUM(oi.subtotal), 0) as total_revenue,
    p.stock_quantity as current_stock,
    RANK() OVER (ORDER BY COALESCE(SUM(oi.quantity), 0) DESC) as sales_rank
FROM products p
         LEFT JOIN categories c ON p.category_id = c.id
         LEFT JOIN order_items oi ON p.id = oi.product_id
         LEFT JOIN orders o ON oi.order_id = o.id AND o.status NOT IN ('CANCELLED')
GROUP BY p.id, p.name, c.name, p.stock_quantity;

-- 2. Customer Order Summary
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT
    u.id,
    u.full_name,
    u.email,
    u.phone,
    u.status as account_status,
    COUNT(DISTINCT o.id) as total_orders,
    COALESCE(SUM(o.total_amount), 0) as total_spent,
    COALESCE(AVG(o.total_amount), 0) as avg_order_value,
    MAX(o.order_date) as last_order_date,
    COUNT(DISTINCT w.product_id) as wishlist_count,
    COUNT(DISTINCT c.product_id) as cart_count
FROM users u
         LEFT JOIN orders o ON u.id = o.user_id AND o.status != 'CANCELLED'
LEFT JOIN wishlist_items w ON u.id = w.user_id
    LEFT JOIN cart_items c ON u.id = c.user_id
WHERE u.role = 'USER'
GROUP BY u.id, u.full_name, u.email, u.phone, u.status;

-- 3. Daily Sales Summary
CREATE OR REPLACE VIEW daily_sales_summary AS
SELECT
    DATE(o.order_date) as sale_date,
    COUNT(DISTINCT o.id) as order_count,
    COUNT(DISTINCT o.user_id) as unique_customers,
    SUM(o.total_amount) as total_sales,
    AVG(o.total_amount) as average_order_value,
    SUM(CASE WHEN o.payment_method = 'COD' THEN o.total_amount ELSE 0 END) as cod_sales,
    SUM(CASE WHEN o.payment_method = 'CARD' THEN o.total_amount ELSE 0 END) as card_sales,
    SUM(CASE WHEN o.payment_method IN ('ESEWA', 'KHALTI') THEN o.total_amount ELSE 0 END) as digital_sales
FROM orders o
WHERE o.status != 'CANCELLED'
GROUP BY DATE(o.order_date)
ORDER BY sale_date DESC;

-- 4. Category Performance Report
CREATE OR REPLACE VIEW category_performance AS
SELECT
    c.id,
    c.name as category_name,
    COUNT(DISTINCT p.id) as total_products,
    COALESCE(SUM(oi.quantity), 0) as total_items_sold,
    COALESCE(SUM(oi.subtotal), 0) as total_revenue,
    COALESCE(SUM(oi.subtotal) / NULLIF(SUM(oi.quantity), 0), 0) as avg_selling_price,
    RANK() OVER (ORDER BY COALESCE(SUM(oi.subtotal), 0) DESC) as revenue_rank
FROM categories c
         LEFT JOIN products p ON c.id = p.category_id AND p.status = 'ACTIVE'
         LEFT JOIN order_items oi ON p.id = oi.product_id
         LEFT JOIN orders o ON oi.order_id = o.id AND o.status NOT IN ('CANCELLED')
GROUP BY c.id, c.name;

-- 5. Inventory Status Report
CREATE OR REPLACE VIEW inventory_status AS
SELECT
    p.id,
    p.name,
    c.name as category,
    p.stock_quantity,
    p.status,
    COALESCE(SUM(oi.quantity), 0) as total_sold,
    CASE
        WHEN p.stock_quantity = 0 THEN 'OUT OF STOCK'
        WHEN p.stock_quantity <= 5 THEN 'CRITICAL'
        WHEN p.stock_quantity <= 10 THEN 'LOW'
        WHEN p.stock_quantity <= 30 THEN 'MEDIUM'
        ELSE 'HIGH'
        END as stock_level,
    CASE
        WHEN COALESCE(SUM(oi.quantity), 0) > p.stock_quantity * 2 THEN 'TRENDING'
        WHEN COALESCE(SUM(oi.quantity), 0) > p.stock_quantity THEN 'POPULAR'
        ELSE 'NORMAL'
        END as demand_status
FROM products p
         LEFT JOIN categories c ON p.category_id = c.id
         LEFT JOIN order_items oi ON p.id = oi.product_id
         LEFT JOIN orders o ON oi.order_id = o.id AND o.status != 'CANCELLED'
GROUP BY p.id, p.name, c.name, p.stock_quantity, p.status;

-- 6. Pending Approvals Report
CREATE OR REPLACE VIEW pending_approvals AS
SELECT
    id,
    username,
    email,
    full_name,
    phone,
    created_at as registered_date,
    DATEDIFF(NOW(), created_at) as days_pending
FROM users
WHERE status = 'PENDING' AND role = 'USER'
ORDER BY created_at ASC;

-- 7. Revenue by Payment Method
CREATE OR REPLACE VIEW revenue_by_payment AS
SELECT
    payment_method,
    COUNT(*) as transaction_count,
    SUM(total_amount) as total_revenue,
    AVG(total_amount) as avg_transaction_value,
    ROUND(SUM(total_amount) * 100.0 / (SELECT SUM(total_amount) FROM orders WHERE status != 'CANCELLED'), 2) as percentage
FROM orders
WHERE status != 'CANCELLED'
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- 8. User Registration Trend
CREATE OR REPLACE VIEW user_registration_trend AS
SELECT
    DATE(created_at) as registration_date,
    COUNT(*) as new_users,
    SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) as pending_approvals,
    SUM(CASE WHEN status = 'APPROVED' THEN 1 ELSE 0 END) as approved_users,
    SUM(CASE WHEN status = 'BLOCKED' THEN 1 ELSE 0 END) as blocked_users
FROM users
WHERE role = 'USER'
GROUP BY DATE(created_at)
ORDER BY registration_date DESC
    LIMIT 30;

-- 9. Order Status Summary
CREATE OR REPLACE VIEW order_status_summary AS
SELECT
    status,
    COUNT(*) as order_count,
    SUM(total_amount) as total_value,
    AVG(total_amount) as avg_value,
    MIN(order_date) as first_order,
    MAX(order_date) as last_order
FROM orders
GROUP BY status
ORDER BY
    FIELD(status, 'PENDING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED');

-- 10. Product Review Summary
CREATE OR REPLACE VIEW product_review_summary AS
SELECT
    p.id,
    p.name,
    COUNT(r.id) as review_count,
    ROUND(AVG(r.rating), 1) as average_rating,
    SUM(CASE WHEN r.rating = 5 THEN 1 ELSE 0 END) as five_star,
    SUM(CASE WHEN r.rating = 4 THEN 1 ELSE 0 END) as four_star,
    SUM(CASE WHEN r.rating = 3 THEN 1 ELSE 0 END) as three_star,
    SUM(CASE WHEN r.rating = 2 THEN 1 ELSE 0 END) as two_star,
    SUM(CASE WHEN r.rating = 1 THEN 1 ELSE 0 END) as one_star
FROM products p
         LEFT JOIN product_reviews r ON p.id = r.product_id
GROUP BY p.id, p.name
HAVING review_count > 0
ORDER BY average_rating DESC, review_count DESC;