-- Create the sliver layer

-- ==============================================
/* in this layer we load the table to the siver layer
to start clean and manupilte the data*/
-- ==============================================

	-- extract 3 tables from crm file

if object_id ('silver.crm_customers_info' , 'U') is not null
	drop table silver.crm_customers_info
CREATE TABLE silver.crm_customers_info (
	cst_id int ,
	cst_key nvarchar(50) ,
	cst_firstname  nvarchar(50) ,
	cst_lastname  nvarchar(50) ,
	cst_marital_status nvarchar(50),
	cst_gender  nvarchar(50) ,
	cst_create_date date ,
	dwh_creat_date datetime2 DEFAULT getdate() 
		);
go

if object_id ('silver.crm_product_info' , 'U') is not null
	drop table silver.crm_product_info
CREATE TABLE silver.crm_product_info (
	prd_id int ,
	prd_key nvarchar(50) ,
	cat_id  nvarchar(50) ,
	prd_id_key nvarchar(50) ,
	prd_nm  nvarchar(50) ,
	prd_cost  int ,
	prd_line  nvarchar(20) ,
	prd_start_date date ,
	prd_end_dt date ,
	dwh_creat_date datetime2 DEFAULT getdate() 
		);

go

if object_id ('silver.crm_sales_details' , 'U') is not null
		drop table silver.crm_sales_details
	CREATE TABLE silver.crm_sales_details (
	sls_order_num nvarchar(50) ,
	sls_prd_key nvarchar(50) ,
	sls_cust_id  int ,
	sls_order_date  date ,
	sls_ship_date  date ,
	sls_due_date date ,
	sls_sales int ,
	sls_quantity int ,
	sls_price int ,
	dwh_creat_date datetime2 DEFAULT getdate() 
		);

go

	-- extract 3 tables from erp file

if object_id ('silver.erp_cust_az12' , 'U') is not null
	drop table silver.erp_cust_az12
create table silver.erp_cust_az12 (
	cid nvarchar(50) ,
	birth_date date ,
	gender nvarchar(10) ,
	dwh_creat_date datetime2 DEFAULT getdate() 
		);

go

if object_id ('silver.erp_loc_a101' , 'U') is not null
	drop table silver.erp_loc_a101
create table silver.erp_loc_a101 (
	cid nvarchar(50) ,
	country nvarchar(50) ,
	dwh_creat_date datetime2 DEFAULT getdate() 
		) ;
go

if object_id ('silver.erp_px_cat_g1v2' , 'U') is not null
	drop table erp_px_cat_g1v2
create table silver.erp_px_cat_g1v2 (
	id nvarchar(50) ,
	cat nvarchar(50) ,
	subcat nvarchar(50) ,
	maintenance nvarchar(8),
	dwh_creat_date datetime2 DEFAULT getdate() 
		);

