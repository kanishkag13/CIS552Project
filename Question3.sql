/***
What is the sales performance and availability of products in our inventory, 
including details such as the product type, total quantity sold, average revenue, and availability?
***/


SELECT
    pa.ProductID,
    pi.ProductType,
    SUM(s.QuantitySold) AS TotalQuantitySold,
    pa.Availability,
    Round(AVG(s.Revenue),3) AS AverageRevenue
FROM
    P_ProductAvailability pa
LEFT JOIN
    ProductInfo pi ON pa.ProductID = pi.ProductID
LEFT JOIN
    P_Sales s ON pa.ID = s.ID
GROUP BY
    pa.ProductID, pi.ProductType, pa.Availability;
    
