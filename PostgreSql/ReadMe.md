# Sergio S.  
#### sergiognrl@hotmail.com  
#### http://RunTechServices.com  

-------------------------

### Postgresql

**PostgreSqlQuery.rb**  
*Query local PostgreSQL database deployment*

- table_rows_types
	- Selects column name and data type.
- table_info
	- Selects all table data from local deployment from controller for displaying in views
- get_table_names (based on shema)
	- fetches tables within specified Postgre schema

**database.rb**  
*Query local postgreSql database deployment*

- tables
	- default schema to look under: public
	- fetches all tables within specified schema (called from Rails controller)

- get_schemas
	- App exposes a UI to user to pick schema to look under

> Link to scripts  
> https://bitbucket.org/wowiamhere/codesamples/src/24be17bf262b84c399c9543f9fdda337521b38db/PostgreSql/?at=master  

------------------------ 