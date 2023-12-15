/***
What are the slow-moving or potentially obsolete items in our inventory, considering products with total sales quantities below 3000 units? 
Additionally, provide information on the product type, total quantity sold, and the associated supplier names for these items.
***/


-- Sales is partitioned on ID
CREATE TABLE P_Sales (
    ID INT,
    SKU VARCHAR(255) UNIQUE,
    QuantitySold INT,
    Revenue DECIMAL(10, 2),
    PRIMARY KEY (ID)
)
PARTITION BY RANGE (ID) (
    PARTITION sales_part1 VALUES LESS THAN (50),
    PARTITION sales_part2 VALUES LESS THAN (100),
    PARTITION sales_partn VALUES LESS THAN (MAXVALUE)
);

INSERT INTO P_Sales (ID, SKU, QuantitySold, Revenue)
SELECT ID, SKU, QuantitySold, Revenue
FROM Sales;

-- ProductAvailability is partitioned on ID
CREATE TABLE P_ProductAvailability (
    ID INT,
    SKU VARCHAR(255) UNIQUE,
    Price DECIMAL(10, 2),
    Availability INT,
    ProductId INT,
    PRIMARY KEY (ID, ProductID),
    FOREIGN KEY (ProductID) REFERENCES ProductInfo(ProductID)
)
PARTITION BY RANGE (ID) (
    PARTITION pa_part1 VALUES LESS THAN (50),
    PARTITION pa_part2 VALUES LESS THAN (100),
    PARTITION pa_partn VALUES LESS THAN (MAXVALUE)
);

INSERT INTO P_ProductAvailability (ID, SKU, Price, Availability, ProductId)
SELECT ID, SKU, Price, Availability, ProductId
FROM ProductAvailability;

--SupplierInfo is partitioned on ID
CREATE TABLE P_SupplierInfo (
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
)
PARTITION BY RANGE (ID) (
    PARTITION pa_part1 VALUES LESS THAN (50),
    PARTITION pa_part2 VALUES LESS THAN (100),
    PARTITION pa_partn VALUES LESS THAN (MAXVALUE)
);

INSERT INTO P_SupplierInfo (ID, SKU, SupplierName, Location, OrderQuantities, StockMaintained, ProductionVolumes, ManufacturingLeadTime, ManufacturingCosts, InspectionResults, DefectRates)
SELECT ID, SKU, SupplierName, Location, OrderQuantities, StockMaintained, ProductionVolumes, ManufacturingLeadTime, ManufacturingCosts, InspectionResults, DefectRates
FROM SupplierInfo;


--Query for Identify Slow-Moving or Obsolete Items with Supplier Information with partitioned tables
SELECT
    pi.ProductID,
    pi.ProductType,
    COALESCE(SUM(s.QuantitySold), 0) AS TotalQuantitySold,
    si.SupplierName
FROM
    ProductInfo pi
LEFT JOIN
    P_ProductAvailability pa ON pi.ProductID = pa.ProductID
LEFT JOIN
    P_Sales s ON pa.ID = s.ID
LEFT JOIN
    P_SupplierInfo si ON pa.ID = si.ID
WHERE
    s.QuantitySold IS NOT NULL -- Exclude products with no sales
GROUP BY
    pi.ProductID, pi.ProductType, si.SupplierName
HAVING
    SUM(s.QuantitySold) < 3000
ORDER BY
    TotalQuantitySold ASC;
    
    


