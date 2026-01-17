-- create the star schema

-- create dim customers
select top 3 * from [silver].[crm_customers_info] ;
select top 3 * from [silver].[erp_cust_az12] ;
select top 3 * from [silver].[erp_loc_a101];

-- all gold layer entities will be views

create view gold.dim_customers as
select
	ROW_NUMBER() over (order by ci.[cst_id]) as customer_key ,
	ci.[cst_id] as customer_id ,
	ci.[cst_key] as customer_number ,
	ci.[cst_firstname] as first_name ,
	ci.[cst_lastname] as last_name ,
	cl.country ,
	ci.[cst_marital_status] as marital_status ,
	case when ci.[cst_gender] != 'n/a' then ci.[cst_gender]
	else coalesce(ca.gender , 'n/a') 
	end as gender ,
	ca.birth_date as birthdate ,
	ci.cst_create_date as create_date
from [silver].[crm_customers_info] as ci
left join [silver].[erp_cust_az12] as ca
	on ci.cst_key = ca.cid
left join [silver].[erp_loc_a101] as cl
	on ci.cst_key = cl.cid ;

--===============================

-- dim product

select top 3 * from [silver].[crm_product_info] ;
select top 3 * from [silver].[erp_px_cat_g1v2] ;

create view gold.dim_products as
select
	ROW_NUMBER() over (order by pn.[prd_start_date] , pn.[prd_id_key]) as product_key ,
	pn.[prd_id] as product_id ,
	pn.[prd_id_key] as product_number ,
	pn.[cat_id] as category_id ,
	ct.cat as category ,
	ct.subcat as sub_category ,
	pn.[prd_nm] as product_name ,
	pn.[prd_line] as product_line ,
	pn.[prd_cost] as product_cost ,
	ct.maintenance ,
	pn.[prd_start_date] as start_date 
from [silver].[crm_product_info] as pn
left join [silver].[erp_px_cat_g1v2] ct
on pn.cat_id = ct.id
where pn.[prd_end_dt] is null; -- to filter out hist data

-- =====================================================

-- create the fact sales

select top 3 * from silver.crm_sales_details ;
select top 3 * from gold.dim_customers ;
select top 3 * from gold.dim_products ;
create view gold.fact_sales as 
select 
	sd.sls_order_num as order_number ,
	dc.customer_key as customer_key ,
	dp.product_key as product_key ,
	sd.sls_order_date as order_date ,
	sd.sls_ship_date as ship_date ,
	sd.sls_due_date as delivered_date ,
	sd.sls_price as price ,
	sd.sls_quantity as quantity ,
	sd.sls_sales as sales 
from silver.crm_sales_details as sd
left join gold.dim_customers as dc
	on sd.sls_cust_id = dc.customer_id
left join gold.dim_products as dp
	on sd.sls_prd_key = dp.product_number ;
