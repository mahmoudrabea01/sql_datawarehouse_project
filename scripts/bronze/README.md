# the bronze layer

- create the schema and the database

- a layer to extract the data from the source files

- the load processing done with the bulk load way

## load_files file

### contain the processing of creating 
- the database named 'DataWarehouse'
- the schemas ('gold' , 'silver' , 'bronze')
- create 6 tables for the file in the source database

## bulk_load file
### contain
- storage precedure for the bronze layer
- extracting tables from the source database
- test for error (if happend)
- the exec command for the SP
- variable to measure the duration time
- tests for each table
