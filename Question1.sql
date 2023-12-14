/***
"What is the optimal reorder point for each product in our inventory, considering historical sales data, lead times, and a desired service level of 95%?"
***/
-- Query 1:  Calculate average daily sales using ProductAvailability and Sales tables

-- Indexing

-- ProductAvailability Table
CREATE INDEX idx_ProductAvailability_ID ON ProductAvailability(ID);
CREATE INDEX idx_ProductAvailability_ProductID ON ProductAvailability(ProductID);

-- Sales Table
CREATE INDEX idx_Sales_ID ON Sales(ID);

-- SupplierInfo Table
CREATE INDEX idx_SupplierInfo_ID ON SupplierInfo(ID);

-- ProductInfo Table
CREATE INDEX idx_ProductInfo_ProductID ON ProductInfo(ProductID);

-- Query Optimization

-- Calculate average daily sales using ProductAvailability and Sales tables
WITH AverageDailySales AS (
    SELECT
        pa.ProductId,
        ROUND(AVG(s.QuantitySold), 3) AS AvgDailySales
    FROM
        ProductAvailability pa
    LEFT JOIN
        Sales s ON pa.ID = s.ID
    GROUP BY
        pa.ProductId
),

-- Calculate safety stock based on desired service level (e.g., 95% service level)
SafetyStock AS (
    SELECT
        pa.ProductId,
        ROUND(SQRT(2) * ABS(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY pa.Availability * si.ManufacturingLeadTime) - 1)
            * AVG(pa.Availability * si.ManufacturingLeadTime), 5) AS SafetyStock
    FROM
        ProductAvailability pa
    JOIN
        SupplierInfo si ON pa.ID = si.ID
    GROUP BY
        pa.ProductId
)

-- Calculate reorder point
SELECT
    pa.ProductId,
    pi.ProductType,
    COALESCE(ad.AvgDailySales, 0) AS AvgDailySales,
    COALESCE(ss.SafetyStock, 0) AS SafetyStock,
    ROUND(COALESCE(ad.AvgDailySales, 0) * MAX(ss.SafetyStock), 3) AS ReorderPoint
FROM
    ProductInfo pi
LEFT JOIN
    ProductAvailability pa ON pi.ProductId = pa.ProductId
LEFT JOIN
    AverageDailySales ad ON pa.ProductId = ad.ProductId
LEFT JOIN
    SafetyStock ss ON pa.ProductId = ss.ProductId
GROUP BY
    pa.ProductId, pi.ProductType, ad.AvgDailySales, ss.SafetyStock;

