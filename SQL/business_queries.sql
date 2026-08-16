USE ShopSales;

SELECT
    COUNT(*) AS TotalOrders,
    SUM(transaction_qty) AS TotalProductsSold,
    SUM(unit_price * transaction_qty) AS TotalRevenue,
    AVG(unit_price * transaction_qty) AS AverageOrderValue
FROM Sales;

SELECT
    store_location,
    SUM(unit_price * transaction_qty) AS Revenue
FROM Sales
GROUP BY store_location
ORDER BY Revenue DESC;

SELECT
    store_location,
    COUNT(*) AS TotalOrders
FROM Sales
GROUP BY store_location
ORDER BY TotalOrders DESC;

SELECT
    store_location,
    ROUND(AVG(unit_price * transaction_qty),2) AS AvgOrderValue
FROM Sales
GROUP BY store_location
ORDER BY AvgOrderValue DESC;

SELECT TOP 10
    product_detail,
    SUM(transaction_qty) AS QuantitySold,
    SUM(unit_price * transaction_qty) AS Revenue
FROM Sales
GROUP BY product_detail
ORDER BY QuantitySold DESC;

SELECT
    DATEPART(HOUR, transaction_time) AS Hour,
    COUNT(*) AS Orders,
    SUM(unit_price * transaction_qty) AS Revenue
FROM Sales
GROUP BY DATEPART(HOUR, transaction_time)
ORDER BY Hour;

SELECT
    DATENAME(WEEKDAY, transaction_date) AS WeekDay,
    COUNT(*) AS Orders,
    SUM(transaction_qty) AS ProductsSold,
    SUM(unit_price * transaction_qty) AS Revenue
FROM Sales
GROUP BY DATENAME(WEEKDAY, transaction_date)
ORDER BY Revenue DESC;

SELECT
    DATENAME(MONTH, transaction_date) AS MonthName,
    MONTH(transaction_date) AS MonthNo,
    COUNT(*) AS Orders,
    SUM(unit_price * transaction_qty) Revenue
FROM Sales
GROUP BY
    DATENAME(MONTH, transaction_date),
    MONTH(transaction_date)
ORDER BY MonthNo;

SELECT
    product_category,
    COUNT(*) Orders,
    SUM(transaction_qty) ProductsSold,
    SUM(unit_price * transaction_qty) Revenue
FROM Sales
GROUP BY product_category
ORDER BY Revenue DESC;

SELECT TOP 15
    product_type,
    SUM(transaction_qty) Quantity,
    SUM(unit_price * transaction_qty) Revenue
FROM Sales
GROUP BY product_type
ORDER BY Revenue DESC;

SELECT
    product_detail,
    SUM(unit_price * transaction_qty) Revenue,

    RANK() OVER(
        ORDER BY SUM(unit_price * transaction_qty) DESC
    ) AS RevenueRank

FROM Sales

GROUP BY product_detail;

WITH ProductRevenue AS
(
SELECT

product_detail,

SUM(unit_price * transaction_qty) Revenue

FROM Sales

GROUP BY product_detail
)

SELECT *

FROM ProductRevenue

WHERE Revenue>30000;

SELECT

store_location,

COUNT(*) Orders,

SUM(unit_price*transaction_qty) Revenue,

ROUND(
SUM(unit_price*transaction_qty)/COUNT(*)
,2) RevenuePerOrder

FROM Sales

GROUP BY store_location;

WITH ProductRevenue AS
(
SELECT
    store_location,
    product_detail,
    SUM(unit_price * transaction_qty) Revenue
FROM Sales
GROUP BY
    store_location,
    product_detail
)

SELECT *

FROM
(
SELECT *,
DENSE_RANK() OVER
(
PARTITION BY store_location
ORDER BY Revenue DESC
) AS Ranking

FROM ProductRevenue

) T

WHERE Ranking<=5

ORDER BY
store_location,
Ranking;

SELECT

transaction_date,

SUM(unit_price*transaction_qty) Revenue,

SUM(SUM(unit_price*transaction_qty))
OVER
(
ORDER BY transaction_date
) RunningRevenue

FROM Sales

GROUP BY transaction_date

ORDER BY transaction_date;

SELECT

transaction_date,

SUM(unit_price*transaction_qty) Revenue,

AVG(SUM(unit_price*transaction_qty))
OVER
(
ORDER BY transaction_date
ROWS BETWEEN 6 PRECEDING
AND CURRENT ROW
)

AS MovingAverage

FROM Sales

GROUP BY transaction_date;

WITH Revenue AS
(
SELECT

product_detail,

SUM(unit_price*transaction_qty) Revenue

FROM Sales

GROUP BY product_detail
)

SELECT *

FROM Revenue

ORDER BY Revenue DESC;

SELECT

store_location,

DATEPART(HOUR,transaction_time) Hour,

COUNT(*) Orders,

SUM(unit_price*transaction_qty) Revenue

FROM Sales

GROUP BY

store_location,

DATEPART(HOUR,transaction_time)

ORDER BY

store_location,

Hour;

SELECT

AVG(CAST(transaction_qty AS FLOAT))

AS AverageBasketSize

FROM Sales;

SELECT

store_location,

SUM(unit_price*transaction_qty) Revenue,

ROUND(

SUM(unit_price*transaction_qty)

/

SUM(SUM(unit_price*transaction_qty))

OVER()

*100

,2)

AS RevenueShare

FROM Sales

GROUP BY store_location;

SELECT

product_category,

SUM(unit_price*transaction_qty) Revenue,

ROUND(

SUM(unit_price*transaction_qty)

/

SUM(SUM(unit_price*transaction_qty))

OVER()

*100

,2)

RevenueShare

FROM Sales

GROUP BY product_category;

SELECT

COUNT(*) Orders,

COUNT(DISTINCT product_detail) Products,

COUNT(DISTINCT store_location) Stores,

SUM(unit_price*transaction_qty) Revenue,

AVG(unit_price*transaction_qty) AvgOrder,

SUM(transaction_qty) TotalItems

FROM Sales;