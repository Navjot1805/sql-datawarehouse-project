/*
===================================================================================================
Quality Checks
===================================================================================================
Script Purpose:
This script performs quality checks to validate the integrity, consistency, and accuracy of the gold layer.
These checks ensures:
- Uniqueness of surrogate keys in dimension tables.
- Referential Integrity between fact and dimension tables.
- Validation of relationship in the data model for analytical purposes.

*/

-- ==================================================================================================
-- CHECKING 'Gold.dim_customers'
-- ==================================================================================================
-- CHECK for uniqueness of customer key in Gold.dim_customers
-- Exceptation: No Results
SELECT 
customer_key,
COUNT(*) AS duplicate_count
FROM Gold.dim_customer_key
HAVING COUNT(*) > 1;

-- ==================================================================================================
-- Check for 'Gold.product_key'
=====================================================================================================
-- Check for uniqueness of product key in gold.dim_products
SELECT 
product_key,
COUNT(*) AS duplicate_count
FROM Gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ==================================================================================================
-- Checking 'Gold.fact_sales'
-- ==================================================================================================
-- Check the data model connectivity between fact and dimensions
SELECT *
FROM
Gold.fact_sales f
LEFT JOIN Gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN Gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL
