-- Products (rename Entry table if you did Step 1)
ALTER TABLE entry RENAME TO product;   -- if you renamed

-- Add stock column if missing
ALTER TABLE product ADD COLUMN stock INT NOT NULL DEFAULT 50;

-- Wishlist (you probably already have)
-- Cart Table (Session-based is also fine, but DB cart is better)
CREATE TABLE cart (
                      id BIGINT AUTO_INCREMENT PRIMARY KEY,
                      user_id BIGINT NOT NULL,
                      product_id BIGINT NOT NULL,
                      quantity INT NOT NULL DEFAULT 1,
                      added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      FOREIGN KEY (user_id) REFERENCES user(id),
                      FOREIGN KEY (product_id) REFERENCES product(id),
                      UNIQUE KEY unique_cart_item (user_id, product_id)
);

-- Orders
CREATE TABLE orders (
                        id BIGINT AUTO_INCREMENT PRIMARY KEY,
                        user_id BIGINT NOT NULL,
                        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        total_amount DECIMAL(10,2) NOT NULL,
                        status ENUM('PENDING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
                        FOREIGN KEY (user_id) REFERENCES user(id)
);

-- Order Items
CREATE TABLE order_item (
                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            order_id BIGINT NOT NULL,
                            product_id BIGINT NOT NULL,
                            quantity INT NOT NULL,
                            price DECIMAL(10,2) NOT NULL,
                            FOREIGN KEY (order_id) REFERENCES orders(id),
                            FOREIGN KEY (product_id) REFERENCES product(id)
);