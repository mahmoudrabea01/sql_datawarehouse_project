-- checking bronze layer quality

-- check [bronze].[crm_customers_info] quality
select [cst_id] ,
count(*)
from [bronze].[crm_customers_info]
group by [cst_id]
having count(*) > 1 or [cst_id] is null;

-- check why the duplicate happend
select *
from [bronze].[crm_customers_info]
where [cst_id] in ('29449' , '29466') ;

-- checking string values >> must return no result
select --cst_firstname -- need trim
		 -- cst_lastname -- need trim
		--cst_marital_status -- no need 
		 cst_gender -- no need
from [bronze].[crm_customers_info]
where --cst_firstname != trim(cst_firstname)
	-- cst_lastname != trim(cst_lastname)
	 -- cst_marital_status != trim(cst_marital_status)
	 cst_gender != trim(cst_gender)  ;

-- check the standriztion and consistency
select -- distinct cst_gender 
		distinct cst_marital_status

from [bronze].[crm_customers_info] ;

-- ==============================================

-- check [bronze].[crm_product_info] quality

select *
from [bronze].[crm_product_info] ;

-- check [bronze].[crm_product_info] quality 
select [prd_id] ,
count(*)
from [bronze].[crm_product_info]
group by [prd_id] 
having count(*) > 1 ;

-- check for unwanted space
select [prd_nm]
from [bronze].[crm_product_info]
where [prd_nm] != trim([prd_nm]) ;

-- check the cost
select [prd_cost]
from [bronze].[crm_product_info]
where [prd_cost] < 0 or [prd_cost] is null ;

-- check the date
select *
from [bronze].[crm_product_info]
where [prd_start_date] > [prd_end_dt] ; -- we have a logical problem here 

select prd_key,
	[prd_start_date] ,
	[prd_end_dt] ,
	lead([prd_start_date]) over(partition by prd_key order by [prd_start_date]) -1 
from [bronze].[crm_product_info]
where [prd_start_date] > [prd_end_dt] ;


--check for appri.
select distinct [prd_line]
from [bronze].[crm_product_info] ;

-- ==================================================

-- check [bronze].[crm_sales_details] quality

select *
from [bronze].[crm_sales_details] 
where 
	sls_order_num != trim(sls_order_num) -- no issue 
	-- sls_prd_key not in (selecy prd_key from silver.crm_prd_info) -- no issue
	-- sls_cust_id not in (selecy cst_id from silver.crm_customers_info) -- no issue ;

-- check the dates columns
select  sls_order_dt 
	-- sls_ship_date 
	-- sls_due_date
from 
	[bronze].[crm_sales_details]
where  sls_order_dt <= 0 or len(sls_order_dt) != 8  -- there are 2 issues in this col
	-- sls_ship_date <= 0 len(sls_ship_date) != 8 -- no issue
	 -- sls_due_date <= 0 len(sls_due_date) != 8 -- no issue
-- note: we don't have any order date igger than ship or due dates

----
-- business rules 
	-- sum of sales = quantity * price 
	-- not negative = not < 0 , not null
-- check the rule
select distinct
[sls_sales] ,
[sls_quantity] ,
[sls_price]
from [bronze].[crm_sales_details]
where [sls_sales] != [sls_quantity] * [sls_price]
or [sls_sales] is null or  [sls_quantity] is null or [sls_price] is null
or [sls_sales] <= 0 or  [sls_quantity] <= 0  or [sls_price]  <= 0 
order by [sls_sales] , [sls_quantity] , [sls_price] ;

-- =======================

-- check [bronze].[erp_cust_az12] quality

select 
	[cid] , -- we will subtract NAS
	[birth_date] , --there are some old values
	[gender]
from [bronze].[erp_cust_az12] ;

select distinct [birth_date]
from [bronze].[erp_cust_az12]
where [birth_date] < '1940' or [birth_date] > GETDATE() ;

select distinct [gender]
from [bronze].[erp_cust_az12] ;

-- ========================================

-- check [bronze].[erp_loc_a101]
select [cid]  -- comper it with cst_key
from [bronze].[erp_loc_a101] ;
select cst_key
from [silver].[crm_customers_info] ;

select
	distinct [country]
from [bronze].[erp_loc_a101] ;

select distinct case when upper(trim([country])) in ( 'DE' , 'GERMANY') THEN 'germany'
	when upper(trim([country])) in ( 'US' , 'UNITED STATES' , 'USA') THEN 'USA'
	when upper(trim([country])) in ( 'UK' , 'UNITED KINGDOM') THEN 'UK'
	when upper(trim([country])) = '' or [country] is  NULL  THEN 'N/A'
	ELSE trim([country]) end as [country]
	from [bronze].[erp_loc_a101] ; 

-- ===========================================================
-- check [bronze].[erp_px_cat_g1v2]

select 
	[id] ,
	[cat] ,
	[subcat]
	[maintenance]
from [bronze].[erp_px_cat_g1v2] ;

-- check the PK
select  [id] from [bronze].[erp_px_cat_g1v2] ;
select  cat_id from [silver].[crm_product_info] ; -- no issue

--check the spaces
select [cat] from [bronze].[erp_px_cat_g1v2] where [cat] != trim([cat]) ; -- no issue
select [subcat] from [bronze].[erp_px_cat_g1v2] where [subcat] != trim([subcat]) ; -- no issue
select [maintenance] from [bronze].[erp_px_cat_g1v2] where [maintenance] != trim([maintenance]) ; -- no issue

select distinct [cat] from [bronze].[erp_px_cat_g1v2]  ; -- no issue
select distinct[subcat] from [bronze].[erp_px_cat_g1v2]  ; -- no issue
select distinct[maintenance] from [bronze].[erp_px_cat_g1v2]  ; -- no issue
