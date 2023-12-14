--DDL - Data Definition Language
CREATE TABLE ProductInfo (
    ProductID INT PRIMARY KEY,
    ProductType VARCHAR(255)
);

CREATE TABLE ProductAvailability (
    ID INT PRIMARY KEY,
    SKU VARCHAR(255) UNIQUE,
    Price DECIMAL(10, 2),
    Availability INT,
    ProductId INT,
    FOREIGN KEY (ProductID) REFERENCES ProductInfo(ProductID)
);

CREATE TABLE Sales (
    ID INT PRIMARY KEY,
    SKU VARCHAR(255) UNIQUE,
    QuantitySold INT,
    Revenue DECIMAL(10, 2)
);

CREATE TABLE SupplierInfo (
    ID INT PRIMARY KEY,
    SKU VARCHAR(255),
    SupplierName VARCHAR(255),
    Location VARCHAR(255),
    OrderQuantities INT,
    StockMaintained INT,
    ProductionVolumes INT,
    ManufacturingLeadTime INT,
    ManufacturingCosts DECIMAL(10, 2),
    InspectionResults VARCHAR(255),
    DefectRates DECIMAL(5, 2)
);



