
SELECT COUNT(*) AS total_rows
FROM dbo.mercedes_benz_sales_2020_2025;

SELECT TOP 10 *
FROM dbo.mercedes_benz_sales_2020_2025;

--Total cars sold by model

SELECT Model,
       SUM([Sales Volume]) AS total_sales
FROM dbo.mercedes_benz_sales_2020_2025
GROUP BY Model
ORDER BY total_sales DESC;


-- Average price per model

SELECT Model,
       AVG([Base Price (USD)]) AS avg_price
FROM dbo.mercedes_benz_sales_2020_2025
GROUP BY Model
ORDER BY avg_price DESC;

--Sales trend by year

SELECT Year,
       SUM([Sales Volume]) AS yearly_sales
FROM dbo.mercedes_benz_sales_2020_2025
GROUP BY Year
ORDER BY Year;

-- Top 5 powerful cars

SELECT TOP 5 Model,
       MAX(Horsepower) AS max_hp
FROM dbo.mercedes_benz_sales_2020_2025
GROUP BY Model
ORDER BY max_hp DESC;

-- Window function  

SELECT Model,
       Year,
       SUM([Sales Volume]) AS total_sales,
       RANK() OVER(ORDER BY SUM([Sales Volume]) DESC) AS sales_rank
FROM dbo.mercedes_benz_sales_2020_2025
GROUP BY Model, Year;

-- Find models whose total sales are greater than the average sales of all models.

SELECT Model,
       SUM([Sales Volume]) AS total_sales
FROM dbo.mercedes_benz_sales_2020_2025
GROUP BY Model
HAVING SUM([Sales Volume]) >
(
    SELECT AVG(total_sales)
    FROM
    (
        SELECT SUM([Sales Volume]) AS total_sales
        FROM dbo.mercedes_benz_sales_2020_2025
        GROUP BY Model
    ) t
);


-- Find the best selling car model for each year

SELECT *
FROM
(
    SELECT Model,
           Year,
           SUM([Sales Volume]) AS total_sales,
           RANK() OVER(PARTITION BY Year ORDER BY SUM([Sales Volume]) DESC) AS rnk
    FROM dbo.mercedes_benz_sales_2020_2025
    GROUP BY Model, Year
) t
WHERE rnk = 1;SELECT *
FROM
(
    SELECT Model,
           Year,
           SUM([Sales Volume]) AS total_sales,
           RANK() OVER(PARTITION BY Year ORDER BY SUM([Sales Volume]) DESC) AS rnk
    FROM dbo.mercedes_benz_sales_2020_2025
    GROUP BY Model, Year
) t
WHERE rnk = 1;


-- Show cumulative sales growth

SELECT Year,
       SUM([Sales Volume]) AS yearly_sales,
       SUM(SUM([Sales Volume])) OVER(ORDER BY Year) AS running_total
FROM dbo.mercedes_benz_sales_2020_2025
GROUP BY Year
ORDER BY Year;

-- Find vehicles whose price is above overall average price

SELECT *
FROM dbo.mercedes_benz_sales_2020_2025
WHERE [Base Price (USD)] >
(
    SELECT AVG([Base Price (USD)])
    FROM dbo.mercedes_benz_sales_2020_2025
);

-- Find ranking of cars by horsepower

SELECT Model,
       Horsepower,
       DENSE_RANK() OVER(ORDER BY Horsepower DESC) AS hp_rank
FROM dbo.mercedes_benz_sales_2020_2025;

-- Top 3 selling models per year

SELECT *
FROM
(
    SELECT Year,
           Model,
           SUM([Sales Volume]) AS total_sales,
           DENSE_RANK() OVER(PARTITION BY Year ORDER BY SUM([Sales Volume]) DESC) AS rnk
    FROM dbo.mercedes_benz_sales_2020_2025
    GROUP BY Year, Model
) t
WHERE rnk <= 3;