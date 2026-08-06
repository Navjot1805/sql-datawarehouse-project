/*
======================================================================================================
DDL SCRIPT: Create Gold Views
======================================================================================================
Scripts Purpose: 
This script creates views for the gold layer in the data warehouse.
The Gold layer represents the final dimension and fact tables (Star Schema)

Each view performs transformations and combines data from silver layer to produce a clean and business ready layer

Usage:
-- These views can be queried directly for analytics reporting
===================================================================================================
*/

-- =============================================================================================
-- CREATE DIMENSION :  Gold.dim_customers
-- =============================================================================================

CREATE VIEW Gold.dim_customers AS
SELECT 
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
ci.cst_id AS customer_id,
ci.cst_key AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
ci.cst_marital_status AS marital_status,
CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr -- CRM IS THE MASTER FOR GENDER INFO
	ELSE COALESCE(ca.gen,'N/A')
END AS gender,
ci.cst_create_date AS create_date,
ca.bdate AS birthdate,
la.cntry AS country
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
ON        ci.cst_key = ca.cid
LEFT JOIN Silver.erp_loc_a101 la
ON        ci.cst_key = la.cid

-- =============================================================================================
-- CREATE DIMENSION :  Gold.dim_products
-- =============================================================================================
  
CREATE OR ALTER VIEW Gold.dim_products AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM Silver.crm_prd_info pn
LEFT JOIN Silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;

-- =============================================================================================
-- CREATE Fact :  Gold.fact_sales
-- =============================================================================================

CREATE VIEW Gold.fact_sales AS 
SELECT 
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM Silver.crm_sales_details sd

LEFT JOIN Gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number

LEFT JOIN Gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id

-- FOREIGN KEY INTEGRITY (DIMENSION)
SELECT *
FROM
Gold.fact_sales f
LEFT JOIN Gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN Gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL
