-- edit the table in silver layer

create or alter procedure silver.load_silver as
BEGIN
BEGIN TRY 

	truncate table [silver].[crm_customers_info] ;

	with cte_customer as(select * ,
				ROW_NUMBER() over (partition by [cst_id] order by [cst_create_date] desc) as row_num
				from [bronze].[crm_customers_info]
					where  [cst_id] is not null
	)
	insert into [silver].[crm_customers_info] (
		[cst_id],
		[cst_key] ,
		[cst_firstname] ,
		[cst_lastname] ,
		[cst_marital_status] ,
		[cst_gender] ,
		[cst_create_date]
	)
	select 
		[cst_id],
		[cst_key],
		trim([cst_firstname]) as cst_firtname,
		trim([cst_lastname]) as cst_lastname,
			case when
				upper([cst_marital_status]) = 'S' then 'Single'
			when 
				upper([cst_marital_status]) = 'M' then 'Married'
			else 'n/a' 
			end as [cst_marital_status] ,

		case when
				upper([cst_gender]) = 'M' then 'Male'
			when 
				upper([cst_gender]) = 'F' then 'Female'
			else 'n/a' 
			end as cst_gender,
			[cst_create_date]
	from cte_customer
	where row_num = 1 ;


	-- check the result
	select *
	from silver.crm_customers_info ;

	-- ================================================================================

	-- [silver].[crm_product_info]

	truncate table [silver].[crm_product_info] ;

	insert into [silver].[crm_product_info] (
	[prd_id],
	[prd_key],
	[cat_id],
	[prd_id_key],
	[prd_nm],
	[prd_cost],
	[prd_line],
	[prd_start_date],
	[prd_end_dt]
	)
	select [prd_id] , -- no duplicate
		[prd_key] ,
		replace(SUBSTRING([prd_key] , 1 , 5) ,'-' , '_') as cat_id ,
		SUBSTRING([prd_key] , 7 , LEN([prd_key] ) ) as prd_id_key ,
		[prd_nm], -- no need for triming
		isnull([prd_cost] , 0) as [prd_cost] ,
		case 
			when upper(trim([prd_line])) = 'M' then 'Mountain'
			when upper(trim([prd_line])) = 'S' then 'Other_Sales'
			when upper(trim([prd_line])) = 'R' then 'Road'
			when upper(trim([prd_line])) = 'T' then 'Touring'
		else 'n/a' end as [prd_line] ,
		cast([prd_start_date] as date) as prd_start_date ,
		cast(lead([prd_start_date]) over(partition by prd_key order by [prd_start_date]) -1 as date ) as prd_end_dt
	from [bronze].[crm_product_info] ;

	-- check [silver].[crm_product_info]
	select *
	from [silver].[crm_product_info] ;

	-- ============================================================

	-- [silver].[crm_sales_details]

	truncate table [silver].[crm_sales_details] ;

	insert into [silver].[crm_sales_details](
	[sls_order_num] ,
	[sls_prd_key] ,
	[sls_cust_id] ,
	[sls_order_date] ,
	[sls_ship_date] ,
	[sls_due_date] ,
	[sls_sales] ,
	[sls_quantity] ,
	[sls_price]
	)
	select
	[sls_order_num] ,
	[sls_prd_key] ,
	[sls_cust_id] ,
	case
		when [sls_order_dt] <=0 or LEN([sls_order_dt]) != 8 then null
		else cast(cast( [sls_order_dt] as varchar) as date )
		end as sls_order_dt,
	case
		when [sls_ship_date] <=0 or LEN([sls_ship_date]) != 8 then null
		else cast(cast( [sls_ship_date] as varchar) as date )
		end as sls_ship_date,
	case
		when [sls_due_date] <=0 or LEN([sls_due_date]) != 8 then null
		else cast(cast( [sls_due_date] as varchar) as date )
		end as sls_due_date, -- even the ship and due dates are perfect but we consider issues in the future
	case when [sls_sales] is null or [sls_sales] <= 0 or [sls_sales] != [sls_quantity] * ABS([sls_price])
		 then [sls_quantity] * ABS([sls_price]) 
		 else [sls_sales] end as [sls_sales],
	[sls_quantity] , -- no issue
	case when [sls_price] is null or [sls_price] <= 0 or [sls_price] != ABS([sls_sales]) /[sls_quantity] 
		 then ABS([sls_sales]) /[sls_quantity] 
		 else [sls_price] end as [sls_price]
	from [bronze].[crm_sales_details] ;

	-- check the table
	select *
	from [silver].[crm_sales_details] ;

	-- =========================================
	-- [silver].[erp_cust_az12]

	truncate table [silver].[erp_cust_az12] ;

	insert into [silver].[erp_cust_az12] (
		[cid] ,
		[birth_date] ,
		[gender]
	)
	select 
		case when [cid] like 'NAS%' THEN SUBSTRING([cid] , 4 , LEN([cid]))
		else [cid] end as [cid],
		case when [birth_date] > GETDATE() then null
		else [birth_date] end as [birth_date] ,
		case when upper(trim([gender])) = 'F' then 'Female' 
		when upper(trim([gender])) = 'M' then 'Male' 
		when trim([gender]) = '' or [gender] = null then 'n/a'
		else trim([gender]) end as [gender]
	--we can go as 	-- case when upper(trim([gender])) in ('F' , 'FEMALE' ) then 'Female'
					--	when upper(trim([gender])) in ('M' , 'MALE' ) then 'Male'
					-- else 'n/a'
	from [bronze].[erp_cust_az12] ;

	-- ======================================================
	-- [silver].[erp_loc_a101]

	truncate table [silver].[erp_loc_a101] ;

	insert into silver.erp_loc_a101 (
			[cid] ,
			[country] 
	)
	select REPLACE(cid, '-' , '') as cid ,
	case when upper(trim([country])) in ( 'DE' , 'GERMANY') THEN 'germany'
		when upper(trim([country])) in ( 'US' , 'UNITED STATES' , 'USA') THEN 'USA'
		when upper(trim([country])) in ( 'UK' , 'UNITED KINGDOM') THEN 'UK'
		when upper(trim([country])) = '' or [country] is  NULL  THEN 'N/A'
		ELSE trim([country]) end as [country]
	from [bronze].[erp_loc_a101] ;

	-- ==========================================

	truncate table [silver].[erp_px_cat_g1v2] ;
	--[silver].[erp_px_cat_g1v2]
	insert into [silver].[erp_px_cat_g1v2] (
	[id] ,
	[cat] ,
	[subcat] ,
	[maintenance]
	)
	select 
		[id] ,
		[cat] ,
		[subcat] ,
		[maintenance]
	from [bronze].[erp_px_cat_g1v2]
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

-- exec silver.load_silver
