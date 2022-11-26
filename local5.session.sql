select
	tc.CONSTRAINT_NAME as constraint_name,
	case when tc.CONSTRAINT_TYPE='PRIMARY KEY' then 'p'
		when tc.CONSTRAINT_TYPE='FOREIGN KEY' then 'f' end as constrint_type,
	'public' as self_schema,
	tc.TABLE_NAME as self_table, 
	JSON_ARRAYAGG(kcu.COLUMN_NAME) self_columns,
	'public' as foreign_schema,
	kcu.REFERENCED_TABLE_NAME as foreign_table,
	JSON_ARRAYAGG(kcu.REFERENCED_COLUMN_NAME) as foreign_columns,
	CONCAT(tc.CONSTRAINT_TYPE, ' (', GROUP_CONCAT(kcu.COLUMN_NAME), ')', (case when tc.CONSTRAINT_TYPE = 'FOREIGN KEY' then CONCAT(' REFERENCES ',kcu.REFERENCED_TABLE_NAME,'(',GROUP_CONCAT(kcu.REFERENCED_COLUMN_NAME),')') else '' end) ) as definition
from
	information_schema.TABLE_CONSTRAINTS tc 
join information_schema.KEY_COLUMN_USAGE kcu on 
	(kcu.TABLE_SCHEMA = tc.TABLE_SCHEMA 
	or kcu.REFERENCED_TABLE_SCHEMA = tc.TABLE_SCHEMA) 
	and (kcu.TABLE_NAME = tc.TABLE_NAME 
	or kcu.REFERENCED_TABLE_NAME = tc.TABLE_NAME)
	and kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME  
group by 
	tc.CONSTRAINT_NAME,
	tc.CONSTRAINT_TYPE,
	tc.TABLE_NAME,
	kcu.REFERENCED_TABLE_NAME;