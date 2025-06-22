SELECT * FROM data.blinkit;

-- CLEANING DATA
SELECT DISTINCT(item_fat_content) FROM data.blinkit;

UPDATE data.blinkit 
SET item_fat_content = CASE
	WHEN item_fat_content IN ('LF', 'low fat') THEN 'Low Fat'
	WHEN item_fat_content = 'reg' THEN 'Regular'
	ELSE item_fat_content
END;

-- ANALYSIS RESULT KPI
-- 1. Total Sales Milion
SELECT CAST(SUM(sales)/1000000 AS DECIMAL(20,2)) AS total_sales_milion
FROM data.blinkit;

-- 2. AVG Sales
SELECT ROUND(CAST(AVG(sales) AS NUMERIC), 0) AS avg_sales
FROM data.blinkit;

-- 3. No of Item
SELECT COUNT(*) AS no_of_item FROM data.blinkit;

-- 4. AVG Rating
SELECT ROUND(CAST(AVG(rating) AS NUMERIC), 2) AS avg_rating
FROM data.blinkit;

-- 1-4 In Table
SELECT  CAST(SUM(sales)/1000000 AS DECIMAL(20,2)) AS total_sales_milion,
		ROUND(CAST(AVG(sales) AS NUMERIC), 0) AS avg_sales,
		COUNT(*) AS no_of_item,
		ROUND(CAST(AVG(rating) AS NUMERIC), 2) AS avg_rating
FROM data.blinkit;

-- ANALYSIS RESULT GRANULAR
-- 1. Total Sales (thousand) by Fat Content
SELECT  item_fat_content, 
		CAST(SUM(sales)/1000 AS DECIMAL(20,2)) AS Total_Sales,
		ROUND(CAST(AVG(sales) AS NUMERIC), 2) AS avg_sales,
		COUNT(*) AS no_of_item,
		ROUND(CAST(AVG(rating) AS NUMERIC), 2) AS avg_rating
FROM data.blinkit GROUP BY 1;

-- 2.  Total Sales (milion) by Item Type
SELECT  item_type, 
		CAST(SUM(sales)/1000000 AS DECIMAL(20,2)) AS Total_Sales,
		ROUND(CAST(AVG(sales) AS NUMERIC), 2) AS avg_sales,
	    COUNT(*) AS no_of_item,
	    ROUND(CAST(AVG(rating) AS NUMERIC), 2) AS avg_rating
FROM data.blinkit GROUP BY 1 ORDER BY 1;

-- 3. Fat Content by Outlet for Total Sales (milion)
SELECT outlet_location_type,item_fat_content, 
	   CAST(SUM(sales)/1000000 AS DECIMAL(20,2)) AS Total_Sales,
	   ROUND(CAST(AVG(sales) AS NUMERIC), 2) AS avg_sales,
	   COUNT(*) AS no_of_item,
	   ROUND(CAST(AVG(rating) AS NUMERIC), 2) AS avg_rating
FROM data.blinkit GROUP BY 1,2 ORDER BY 1;

-- 4. Total Sales (thousand) by Outlet Establishment
SELECT  outlet_establishment_year, 
		CAST(SUM(sales)/1000 AS DECIMAL(20,0)) AS Total_Sales,
		ROUND(CAST(AVG(sales) AS NUMERIC), 0) AS avg_sales,
	    COUNT(*) AS no_of_item,
	    ROUND(CAST(AVG(rating) AS NUMERIC), 2) AS avg_rating
FROM data.blinkit GROUP BY 1 ORDER BY 1;

-- 5. Percentage of Sales by Outlet Size
SELECT  
    outlet_size, 
    CAST(SUM(sales)/1000 AS DECIMAL(20,2)) AS total_sales,
    -- Persentase dari total_sales
    ROUND(
        (CAST(SUM(sales)/1000 AS NUMERIC) * 100.0) / 
        SUM(CAST(SUM(sales)/1000 AS NUMERIC)) OVER (), 2
    ) AS pct_total_sales
FROM data.blinkit
GROUP BY 1
ORDER BY 3 DESC;

-- 6. Total Sales by Outlet Location
SELECT  outlet_location_type, 
		CAST(SUM(sales)/1000 AS DECIMAL(20,2)) AS Total_Sales
FROM data.blinkit GROUP BY 1 ORDER BY 2 DESC;

-- 7. All Metrics by Outlet Type
SELECT  outlet_type, 
		CAST(SUM(sales)/1000 AS DECIMAL(20,0)) AS Total_Sales,
		COUNT(*) AS no_of_item,
		ROUND(CAST(AVG(sales) AS NUMERIC), 0) AS avg_sales,
	        ROUND(CAST(AVG(rating) AS NUMERIC), 2) AS avg_rating,
		ROUND(CAST(AVG(item_visibility) AS NUMERIC), 2) AS avg_item_visibility
FROM data.blinkit GROUP BY 1 ORDER BY 1;
