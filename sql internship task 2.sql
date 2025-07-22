create database marketing;
use marketing;




CREATE TABLE ProductSales (
  sale_id     INT PRIMARY KEY,
  product_id  INT,
  sale_date   DATE,
  qty         INT,
  sales_amt   DECIMAL(10,2)
);
INSERT INTO ProductSales VALUES
(1, 101, '2024-01-10', 5, 500.00),
(2, 101, '2024-02-15', 3, 300.00),
(3, 102, '2024-02-20', 4, 800.00),
(4, 101, '2024-03-05', 7, 700.00),
(5, 102, '2024-03-10', 6, 1200.00),
(6, 103, '2024-03-12', 2, 200.00),
(7, 101, '2024-04-01', 4, 400.00),
(8, 102, '2024-04-05', 5, 1000.00),
(9, 103, '2024-04-10', 3, 300.00);

-- 1. 📈 Monthly Sales 

WITH monthly AS (
  SELECT
    DATE_FORMAT(sale_date, '%Y-%m-01') AS month,
    SUM(sales_amt) AS total_sales
  FROM ProductSales
  GROUP BY month
),
trends AS (
  SELECT
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS prev_month,
    LAG(total_sales, 12) OVER (ORDER BY month) AS prev_year,
    AVG(total_sales) OVER (
      ORDER BY month
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS ma_3m
  FROM monthly
)
SELECT
  month,
  total_sales,
  ma_3m,
  ROUND(100 * (total_sales - prev_month) / prev_month, 2) AS pct_mom,
  ROUND(100 * (total_sales - prev_year) / prev_year, 2) AS pct_yoy
FROM trends
ORDER BY month;

-- 2 RANKING TABLE BY ANNUAL SALE

WITH yearly_sales AS (
  SELECT
    product_id,
    EXTRACT(YEAR FROM sale_date) AS yr,
    SUM(sales_amt) AS total
  FROM ProductSales
  GROUP BY product_id, yr
)
SELECT
  product_id,
  yr,
  total,
  RANK() OVER (
    PARTITION BY yr
    ORDER BY total DESC
  ) AS yearly_rank
FROM yearly_sales
ORDER BY yr, yearly_rank;

-- 3 sales growth from previous sales

SELECT
  sale_id,
  product_id,
  sale_date,
  sales_amt,
  LAG(sales_amt) OVER (
    PARTITION BY product_id
    ORDER BY sale_date
  ) AS prev_sale,
  sales_amt - LAG(sales_amt) OVER (
    PARTITION BY product_id
    ORDER BY sale_date
  ) AS diff_from_prev
FROM ProductSales
ORDER BY product_id, sale_date;

-- 4 TOP 2 sales per month

WITH ranked AS (
  SELECT
    DATE_FORMAT(sale_date, '%Y-%m-01') AS month,
    sale_id,
    product_id,
    sales_amt,
    ROW_NUMBER() OVER (
      PARTITION BY DATE_FORMAT(sale_date, '%Y-%m-01')
      ORDER BY sales_amt DESC
    ) AS rn
  FROM ProductSales
)
SELECT
  month,
  sale_id,
  product_id,
  sales_amt
FROM ranked
WHERE rn <= 2
ORDER BY month, rn;


-- 5.identify above-avg sales day

WITH daily_totals AS (
  SELECT
    sale_date,
    SUM(sales_amt) AS daily_total
  FROM ProductSales
  GROUP BY sale_date
),
avg_stats AS (
  SELECT
    AVG(daily_total) AS avg_daily,
    MAX(daily_total) AS max_daily
  FROM daily_totals
)
SELECT
  d.sale_date,
  d.daily_total,
  CASE
    WHEN d.daily_total > a.avg_daily THEN 'above avg'
    ELSE 'below avg'
  END AS compare_avg
FROM daily_totals d
CROSS JOIN avg_stats a
ORDER BY d.sale_date;




