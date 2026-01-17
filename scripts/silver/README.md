# silver layer
-integrate the entity to have a better understand about raletions
-create a digram explan the raletions
- create the exploring file to take a quick look at the entities
  ## integration model
  <img width="630" height="672" alt="image" src="https://github.com/user-attachments/assets/aa40e390-1445-4a37-8455-f06e6919851c" />
## the process of silver layer
### create table for the layer
- in file ddl_create we create the entities which will contain the processing data
### check the data from the bronze layer
- in this file we check the cleanness of the fields in the bronze entity
- try to understand the data and the concepts behind it
###### note : the same file in the tests repo
### inserting file
#### we have done data transformtion
##### data cleaning
- remove duplicates
- filter the data
- handling missing values and invalid vlues and unwanted spaces
- cast the data type
- detect and hunt the outliers
##### normaliztion & standardiztion
##### data enrichment
##### derived columns



