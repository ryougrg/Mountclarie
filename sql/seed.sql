-- =====================================================
-- Sample Data for Himalayan Montclaire E-commerce
-- =====================================================

USE himalayan_montclaire;

-- =====================================================
-- 1. INSERT ADMIN USER (Password: admin123)
-- Password hash is for 'admin123' using BCrypt
-- =====================================================
INSERT INTO users (username, email, password_hash, full_name, role, status) VALUES
                                                                                ('admin', 'admin@himalayan.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrJ5YqCqPqZqXqLqLqLqLqLqLqLqLq', 'System Administrator', 'ADMIN', 'APPROVED'),
                                                                                ('john_doe', 'john@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrJ5YqCqPqZqXqLqLqLqLqLqLqLq', 'John Doe', 'USER', 'APPROVED'),
                                                                                ('jane_smith', 'jane@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrJ5YqCqPqZqXqLqLqLqLqLqLqLq', 'Jane Smith', 'USER', 'APPROVED'),
                                                                                ('pending_user', 'pending@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrJ5YqCqPqZqXqLqLqLqLqLqLqLq', 'Pending User', 'USER', 'PENDING'),
                                                                                ('blocked_user', 'blocked@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrJ5YqCqPqZqXqLqLqLqLqLqLqLq', 'Blocked User', 'USER', 'BLOCKED');

-- =====================================================
-- 2. INSERT CATEGORIES
-- =====================================================
INSERT INTO categories (name, description, parent_category_id, status) VALUES
                                                                           ('Men', 'Men\'s fashion clothing', NULL, 'ACTIVE'),
('Women', 'Women\'s fashion clothing', NULL, 'ACTIVE'),
                                                                           ('Kids', 'Children\'s fashion clothing', NULL, 'ACTIVE'),
('Shirts', 'Casual and formal shirts', 1, 'ACTIVE'),
('Pants', 'Jeans, trousers and shorts', 1, 'ACTIVE'),
('Dresses', 'Women\'s dresses and gowns', 2, 'ACTIVE'),
                                                                           ('Tops', 'Women\'s tops and blouses', 2, 'ACTIVE'),
('Boys', 'Boys clothing', 3, 'ACTIVE'),
('Girls', 'Girls clothing', 3, 'ACTIVE');

-- =====================================================
-- 3. INSERT PRODUCTS
-- =====================================================

-- Men's Products (Category ID: 1)
INSERT INTO products (category_id, name, description, price, size, stock_quantity, image_url, status) VALUES
(1, 'Classic Cotton Shirt', 'Premium cotton shirt for formal occasions', 39.99, 'M', 50, '/static/images/products/shirt1.jpg', 'ACTIVE'),
                                                                            (1, 'Slim Fit Jeans', 'Comfortable stretch denim jeans', 59.99, 'L', 35, '/static/images/products/jeans1.jpg', 'ACTIVE'),
                                                                            (1, 'Casual Polo T-Shirt', 'Breathable cotton polo shirt', 29.99, 'M', 45, '/static/images/products/polo1.jpg', 'ACTIVE'),
                                                                            (1, 'Winter Jacket', 'Warm padded jacket for winter', 89.99, 'XL', 15, '/static/images/products/jacket1.jpg', 'ACTIVE'),
                                                                            (1, 'Sports Shorts', 'Quick-dry athletic shorts', 24.99, 'S', 60, '/static/images/products/shorts1.jpg', 'ACTIVE'),
                                                                            (1, 'Formal Blazer', 'Elegant wool blend blazer', 149.99, 'L', 10, '/static/images/products/blazer1.jpg', 'ACTIVE');

-- Women's Products (Category ID: 2)
INSERT INTO products (category_id, name, description, price, size, stock_quantity, image_url, status) VALUES
                                                                                                          (2, 'Floral Summer Dress', 'Beautiful floral print dress', 49.99, 'M', 40, '/static/images/products/dress1.jpg', 'ACTIVE'),
                                                                                                          (2, 'Cashmere Sweater', 'Soft luxury cashmere sweater', 79.99, 'S', 25, '/static/images/products/sweater1.jpg', 'ACTIVE'),
                                                                                                          (2, 'High-Waist Jeans', 'Stylish high-waist denim', 54.99, 'L', 30, '/static/images/products/jeans2.jpg', 'ACTIVE'),
                                                                                                          (2, 'Silk Blouse', 'Elegant silk work blouse', 44.99, 'M', 28, '/static/images/products/blouse1.jpg', 'ACTIVE'),
                                                                                                          (2, 'Leather Jacket', 'Genuine leather biker jacket', 129.99, 'M', 12, '/static/images/products/leather1.jpg', 'ACTIVE'),
                                                                                                          (2, 'Maxi Skirt', 'Flowing bohemian maxi skirt', 39.99, 'L', 35, '/static/images/products/skirt1.jpg', 'ACTIVE');

-- Kids Products (Category ID: 3)
INSERT INTO products (category_id, name, description, price, size, stock_quantity, image_url, status) VALUES
                                                                                                          (3, 'Kids T-Shirt Set', 'Pack of 3 colorful t-shirts', 24.99, 'S', 55, '/static/images/products/kidshirt1.jpg', 'ACTIVE'),
                                                                                                          (3, 'Children\'s Jeans', 'Durable denim for active kids', 29.99, 'M', 40, '/static/images/products/kidjeans1.jpg', 'ACTIVE'),
(3, 'Winter Coat', 'Warm hooded winter coat', 54.99, 'L', 20, '/static/images/products/kidcoat1.jpg', 'ACTIVE'),
(3, 'School Uniform', 'Smart school uniform set', 34.99, 'M', 45, '/static/images/products/uniform1.jpg', 'ACTIVE'),
(3, 'Sports Jersey', 'Breathable sports jersey', 19.99, 'S', 50, '/static/images/products/jersey1.jpg', 'ACTIVE'),
(3, 'Party Dress', 'Cute party dress for girls', 35.99, 'XS', 30, '/static/images/products/kiddress1.jpg', 'ACTIVE');

-- Out of Stock Products
INSERT INTO products (category_id, name, description, price, size, stock_quantity, image_url, status) VALUES
(1, 'Limited Edition Hoodie', 'Exclusive designer hoodie', 99.99, 'L', 0, '/static/images/products/hoodie1.jpg', 'ACTIVE'),
(2, 'Designer Handbag', 'Premium leather handbag', 199.99, NULL, 0, '/static/images/products/bag1.jpg', 'ACTIVE');

-- =====================================================
-- 4. INSERT CART ITEMS
-- =====================================================
INSERT INTO cart_items (user_id, product_id, quantity) VALUES
(2, 1, 2),
(2, 3, 1),
(3, 7, 1),
(3, 8, 2);

-- =====================================================
-- 5. INSERT WISHLIST ITEMS
-- =====================================================
INSERT INTO wishlist_items (user_id, product_id) VALUES
(2, 2),
(2, 4),
(3, 9),
(3, 10),
(2, 6);

-- =====================================================
-- 6. INSERT ORDERS
-- =====================================================

-- Order 1: John Doe's order
INSERT INTO orders (order_number, user_id, total_amount, status, shipping_address, payment_method, payment_status) VALUES
('ORD2026041500001', 2, 129.97, 'DELIVERED', '123 Main St, Kathmandu, Nepal', 'COD', 'PAID');

INSERT INTO order_items (order_id, product_id, product_name, product_price, quantity, subtotal) VALUES
                                                                                                    (1, 1, 'Classic Cotton Shirt', 39.99, 1, 39.99),
                                                                                                    (1, 3, 'Casual Polo T-Shirt', 29.99, 2, 59.98),
                                                                                                    (1, 5, 'Sports Shorts', 24.99, 1, 24.99);

-- Order 2: Jane Smith's order
INSERT INTO orders (order_number, user_id, total_amount, status, shipping_address, payment_method, payment_status) VALUES
    ('ORD2026041500002', 3, 149.97, 'SHIPPED', '456 Oak Ave, Pokhara, Nepal', 'CARD', 'PAID');

INSERT INTO order_items (order_id, product_id, product_name, product_price, quantity, subtotal) VALUES
                                                                                                    (2, 7, 'Floral Summer Dress', 49.99, 1, 49.99),
                                                                                                    (2, 8, 'Cashmere Sweater', 79.99, 1, 79.99),
                                                                                                    (2, 10, 'Silk Blouse', 44.99, 0, 0);  -- Note: quantity 0 for testing

-- Fix the quantity for order 2 item 3
UPDATE order_items SET quantity = 1, subtotal = 44.99 WHERE id = 3;

-- Order 3: Pending order
INSERT INTO orders (order_number, user_id, total_amount, status, shipping_address, payment_method, payment_status) VALUES
    ('ORD2026041600003', 2, 89.99, 'PENDING', '123 Main St, Kathmandu, Nepal', 'ESEWA', 'PENDING');

INSERT INTO order_items (order_id, product_id, product_name, product_price, quantity, subtotal) VALUES
    (3, 4, 'Winter Jacket', 89.99, 1, 89.99);

-- =====================================================
-- 7. INSERT PRODUCT REVIEWS
-- =====================================================
INSERT INTO product_reviews (product_id, user_id, rating, review) VALUES
                                                                      (1, 2, 5, 'Excellent quality! Very comfortable shirt.'),
                                                                      (1, 3, 4, 'Good product, fits well.'),
                                                                      (3, 2, 5, 'Best polo shirt I have ever bought.'),
                                                                      (7, 3, 5, 'Beautiful dress, perfect for summer!'),
                                                                      (8, 3, 4, 'Very soft sweater, runs slightly small.');

-- =====================================================
-- 8. INSERT ACTIVITY LOGS
-- =====================================================
INSERT INTO activity_logs (user_id, action, details, ip_address) VALUES
                                                                     (1, 'LOGIN', 'Admin logged in', '192.168.1.1'),
                                                                     (1, 'USER_APPROVED', 'Approved user John Doe', '192.168.1.1'),
                                                                     (2, 'REGISTER', 'User registered', '192.168.1.2'),
                                                                     (2, 'ORDER_PLACED', 'Placed order #ORD2026041500001', '192.168.1.2'),
                                                                     (3, 'LOGIN', 'User logged in', '192.168.1.3'),
                                                                     (1, 'PRODUCT_ADDED', 'Added new product: Winter Jacket', '192.168.1.1'),
                                                                     (1, 'STOCK_UPDATED', 'Updated stock for product ID 1', '192.168.1.1');

-- =====================================================
-- 9. VERIFY DATA
-- =====================================================
SELECT 'Users:' as 'Table', COUNT(*) as 'Count' FROM users
UNION ALL
SELECT 'Categories:', COUNT(*) FROM categories
UNION ALL
SELECT 'Products:', COUNT(*) FROM products
UNION ALL
SELECT 'Orders:', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items:', COUNT(*) FROM order_items
UNION ALL
SELECT 'Cart Items:', COUNT(*) FROM cart_items
UNION ALL
SELECT 'Wishlist Items:', COUNT(*) FROM wishlist_items
UNION ALL
SELECT 'Reviews:', COUNT(*) FROM product_reviews;

-- =====================================================
-- 10. DISPLAY SAMPLE QUERIES FOR TESTING
-- =====================================================

-- Show low stock products
SELECT * FROM low_stock_alert;

-- Show monthly sales
SELECT * FROM monthly_sales_report;

-- Show product sales report
SELECT * FROM product_sales_report LIMIT 5;

-- =====================================================
-- END OF SEED DATA
-- =====================================================