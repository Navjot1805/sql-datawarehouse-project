/*
=========================================================
STORED Procedure: Load Bronze Layer (Source -> Bronze)
=========================================================
Script Purpose:
This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions:
-Truncate the bronze tables before loading data.
uses the 'bulk insert' command to load data from csv files to tables.

parameters:
None.
This stored procedure does not accept any parameters or return any values.

Usage Example:
EXEC Bronze.load_bronze;
*/




USE DataWarehouse;
Go

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
	SET @batch_start_time = GETDATE();
		PRINT '==========================================='
		PRINT 'Loading Bronze Layer'
		PRINT '==========================================='

		PRINT '==========================================='
		PRINT 'Loading Bronze CRM Tables'
		PRINT '==========================================='

		PRINT '>> TRUNCATING BRONZ TABLE crm_cust_info'
		SET @start_time = GETDATE();
		TRUNCATE TABLE Bronze.crm_cust_info;
		BULK INSERT Bronze.crm_cust_info
		FROM 'D:\Data Science\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 's'
		PRINT '================================================================'

		PRINT '>> TRUNCATING TABLE: Bronze.crm_cus_info';
		SET @start_time = GETDATE();
		TRUNCATE TABLE Bronze.crm_prd_info;
		BULK INSERT Bronze.crm_prd_info
		FROM 'D:\Data Science\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 's'
		PRINT '================================================================'



		PRINT '>> TRUNCATING TABLE: Bronze.crm_sales_details';
		SET @start_time = GETDATE();
		TRUNCATE TABLE Bronze.crm_sales_details;
		BULK INSERT Bronze.crm_sales_details
		FROM 'D:\Data Science\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 's'
		PRINT '================================================================'


		PRINT '==========================================='
		PRINT 'Loading Bronze ERP Tables'
		PRINT '==========================================='

		PRINT 'LOADING BRONZE TABLE erp_loc_a101'
		SET @start_time = GETDATE();
		TRUNCATE TABLE Bronze.erp_loc_a101;
		BULK INSERT Bronze.erp_loc_a101
		FROM 'D:\Data Science\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 's'
		PRINT '================================================================'

		PRINT 'LOADING BRONZE TABLE erp_cust_az12'
		SET @start_time = GETDATE();
		TRUNCATE TABLE Bronze.erp_cust_az12;
		BULK INSERT Bronze.erp_cust_az12
		FROM 'D:\Data Science\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 's'
		PRINT '================================================================'

		PRINT 'LOADING BRONZE TABLE erp_px_cat_g1v2'
		SET @start_time = GETDATE();
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'D:\Data Science\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 's'
		PRINT '================================================================'
		SET @batch_end_time = GETDATE();
		PRINT '============================================='
		PRINT 'LOADING BRONZE LAYER IS COMPLETED';
		PRINT ' -TOTAL LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT '======================================================'
	END TRY
	BEGIN CATCH
		PRINT '========================================'
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT '========================================'
		PRINT 'ERROR Message' + ERROR_MESSAGE();
		PRINT 'ERROR Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT '========================================='
	END CATCH

END


