-- bulk insert in the bronze layer

-- make a storge procedure for the daily load to the bronze layer
create or alter procedure bronze.load_bronze as
BEGIN
declare @start_time datetime , @end_time datetime  -- to calc. the duration
	print('====================================') ;
	print('load the bronze layer') ;
	print('====================================');

BEGIN TRY -- TO DEBUGGING
	set @end_time = GETDATE() ;
	print('the crm files')
	print('----------------------------')
	-- to make sure not to dup. the values in the table
	truncate table bronze.crm_customers_info ;
	-- full load
	bulk insert bronze.crm_customers_info
	from 'C:\Users\Mahmoud\OneDrive\Desktop\sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with (
		firstrow = 2 ,
		fieldterminator = ',' ,
		tablock 
	);

	-- to check the quality of our extraction
	-- select * from  [bronze].[crm_customers_info];
	-- select count(*)  from [bronze].[crm_customers_info] ;

	--======================================

	truncate table [bronze].[crm_product_info] ;

	bulk insert [bronze].[crm_product_info]
	from 'C:\Users\Mahmoud\OneDrive\Desktop\sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with (
		firstrow = 2 ,
		fieldterminator = ',' ,
		tablock

	);

	-- to check the quality of our extraction
	-- select * from [bronze].[crm_product_info] ;
	-- select count(*)  from [bronze].[crm_product_info] ;

	-- ================================

	truncate table [bronze].[crm_sales_details] ;

	bulk insert [bronze].[crm_sales_details]
	from 'C:\Users\Mahmoud\OneDrive\Desktop\sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with (
		firstrow = 2 ,
		fieldterminator = ',' ,
		tablock

	);

	-- to check the quality of our extraction
	-- select * from [bronze].[crm_sales_details] ;
	-- select count(*)  from [bronze].[crm_sales_details] ;

	--============================
	print('=============================');
	print('the erp files');
	print('----------------------------');

	truncate table [bronze].[erp_cust_az12] ;

	bulk insert [bronze].[erp_cust_az12]
	from 'C:\Users\Mahmoud\OneDrive\Desktop\sql\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.CSV'
	with (
		firstrow = 2 ,
		fieldterminator = ',' ,
		tablock

	);

	-- to check the quality of our extraction
	-- select * from [bronze].[erp_cust_az12] ;
	-- select count(*)  from [bronze].[erp_cust_az12] ;

	--=================================

	truncate table [bronze].[erp_loc_a101] ;

	bulk insert [bronze].[erp_loc_a101]
	from 'C:\Users\Mahmoud\OneDrive\Desktop\sql\sql-data-warehouse-project\datasets\source_erp\LOC_A101.CSV'
	with (
		firstrow = 2 ,
		fieldterminator = ',' ,
		tablock

	);

	-- to check the quality of our extraction
	-- select * from [bronze].[erp_loc_a101] ;
	-- select count(*)  from [bronze].[erp_loc_a101] ;

	--==================================

	truncate table [bronze].[erp_px_cat_g1v2] ;

	bulk insert [bronze].[erp_px_cat_g1v2]
	from 'C:\Users\Mahmoud\OneDrive\Desktop\sql\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.CSV'
	with (
		firstrow = 2 ,
		fieldterminator = ',' ,
		tablock

	);

	-- to check the quality of our extraction
	-- select * from [bronze].[erp_px_cat_g1v2] ;
	-- select count(*)  from [bronze].[erp_px_cat_g1v2] ;
	set @end_time = GETDATE() ;
	PRINT('duration time:' + cast( datediff(second ,@end_time , @start_time) as nvarchar )) ;
END TRY
	
BEGIN CATCH
	print('*********************************');
	print('ERROR OCCURED DURING LOADING THE BRONZE LAYER');
	print('ERROR MASSAGE :' + cast(error_message() as nvarchar));
	print('ERROR MASSAGE :' + cast(error_state() as nvarchar));
	print('ERROR MASSAGE :' + cast(error_number() as nvarchar))
	print('*********************************');
END CATCH
END

-- EXEC bronze.load_bronze
