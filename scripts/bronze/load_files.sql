-- Create the bronze layer

-- ==============================================
/* in this layer we extract from the source system 
in this project we extract form CSV in file */
-- ==============================================

	-- extract 3 tables from crm file

if object_id ('crm_customers_info' , 'U') is not null
	drop table bronze.crm_customers_info
CREATE TABLE bronze.crm_customers_info (
	cst_id int ,
	cst_key nvarchar(50) ,
	cst_firstname  nvarchar(50) ,
	cst_lastname  nvarchar(50) ,
	cst_marital_status nvarchar(50),
	cst_gender  nvarchar(50) ,
	cst_create_date date
		);
go

if object_id ('crm_product_info' , 'U') is not null
	drop table bronze.crm_product_info
CREATE TABLE bronze.crm_product_info (
	prd_id int ,
	prd_key nvarchar(50) ,
	prd_nm  nvarchar(50) ,
	prd_cost  int ,
	prd_line  nvarchar(10) ,
	prd_start_date datetime ,
	prd_end_dt datetime
		);

go

if object_id ('crm_sales_details' , 'U') is not null
		drop table bronze.crm_sales_details
	CREATE TABLE bronze.crm_sales_details (
	sls_order_num nvarchar(50) ,
	sls_prd_key nvarchar(50) ,
	sls_cust_id  int ,
	sls_order_dt  int ,
	sls_ship_date  int ,
	sls_due_date int ,
	sls_sales int ,
	sls_quantity int ,
	sls_price int
		);

go

	-- extract 3 tables from erp file

if object_id ('erp_cust_az12' , 'U') is not null
	drop table bronze.erp_cust_az12
create table bronze.erp_cust_az12 (
	cid nvarchar(50) ,
	birth_date date ,
	gender nvarchar(10)
		) ;
go

if object_id ('erp_loc_a101' , 'U') is not null
	drop table bronze.erp_loc_a101
create table bronze.erp_loc_a101 (
	cid nvarchar(50) ,
	country nvarchar(50)
		) ;
go

if object_id ('erp_px_cat_g1v2' , 'U') is not null
	drop table erp_px_cat_g1v2
create table bronze.erp_px_cat_g1v2 (
	id nvarchar(50) ,
	cat nvarchar(50) ,
	subcat nvarchar(50) ,
	maintenance nvarchar(8)
		) ;
