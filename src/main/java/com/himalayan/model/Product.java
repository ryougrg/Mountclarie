package com.himalayan.model;

import java.math.BigDecimal;

public class Product {
    private int id;
    private String productName;
    private String category;
    private BigDecimal price;
    private int stockQuantity;
    private String description;
    private String imageUrl;
    private String rackNumber;

    // Constructors
    public Product() {}

    public Product(String productName, String category, BigDecimal price, int stockQuantity,
                   String description, String rackNumber) {
        this.productName = productName;
        this.category = category;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.description = description;
        this.rackNumber = rackNumber;
    }

    // Getters and Setters section
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getRackNumber() { return rackNumber; }
    public void setRackNumber(String rackNumber) { this.rackNumber = rackNumber; }
}