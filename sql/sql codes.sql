-- Create database
CREATE DATABASE himalayan_montclaire;
USE himalayan_montclaire;

-- Users table (role: 'admin' or 'user')
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address TEXT,
    role ENUM('admin', 'user') DEFAULT 'user',
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table (clothing items)
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL, -- 'Men', 'Women', 'Accessories'
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    rack_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wishlist table
CREATE TABLE wishlist (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_wishlist (user_id, product_id)
);

-- Requests/Orders table (apply feature)
CREATE TABLE requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    request_date DATE NOT NULL,
    return_date DATE,
    status ENUM('pending', 'approved', 'rejected', 'returned') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert default admin (password: admin123)
INSERT INTO users (full_name, email, password, phone, role, is_approved)
VALUES ('Admin', 'admin@himalayan.com', 'admin123', '9800000000', 'admin', TRUE);

-- Insert sample products
INSERT INTO products (product_name, category, price, stock_quantity, description, rack_number) VALUES
('Himalayan Wool Jacket', 'Men', 4999.99, 10, 'Premium wool from Himalayan region', 'A-01'),
('Pashmina Shawl', 'Women', 2999.99, 15, 'Handcrafted pashmina', 'B-02'),
('Adventure Cap', 'Accessories', 999.99, 30, 'Cotton cap with logo', 'C-03'),
('Trekking Pants', 'Men', 2499.99, 8, 'Water-resistant trekking pants', 'A-04'),
('Embroidered Kurta', 'Women', 3599.99, 5, 'Traditional embroidery', 'B-05');