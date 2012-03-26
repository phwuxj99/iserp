alter table warehouse add unit nvarchar(15)

insert into warehouse(part_no,part_name,price,unit,operator,description)
              select  part_no,part_name,price1,unit,operator,part_description from partno

			  
alter table cpo add part_name nvarchar(85)


alter table invoice add part_name nvarchar(85)
			  
select 'insert partno(part_no, part_name,unit,price1,operator) values(''',ltrim( part_no), ''',''',ltrim(part_name),''',''',ltrim(unit),''',',ltrim(price1),',''1001'')' from partno			  


-- copy shawn's product no

select * from shawn

insert into partno(part_no,part_name,price1,price2,price3,unit,operator,part_description)
              select  item,description,[gross price],price,cost,'PCS',500,description from shawn


-- delete partno where operator=500 and  part_no in (select item from shawn)

insert into warehouse(part_no,part_name,price,unit,operator,description,qty)
              select  item,description,[gross price],'PCS',1001,description,[quantity on hand] from shawn where [quantity on hand] is not null
			  

alter table users_info
add invoice_name       nvarchar(253),
invoice_address    nvarchar(253),
invoice_phone      nvarchar(253);  

alter table users_info
add invoice_tax       int default 0;

alter table erpclient
add invoice_tax       int default 0;


select * from category where operator=1012
insert into category(category_name,description,operator) select category_name,description,500 from category where id_num>3

select * from partno
insert into partno(part_no,part_name,price1,price2,price3,unit,operator,part_description)
              select  item,description,[gross price],price,cost,'PCS',500,description from shawn
delete partno where operator=1012
insert into partno(part_no,part_name,price1,price2,price3,unit,operator,part_description,category)
select partno,partname,price,price,price,unit,1012,partname,
case f5 when 'yc' then 3 
 when 'pl' then 4
 when 'gl' then 5
 when 'skl' then 6
 when 'cl' then 7
 when 'tl' then 8
 when 'hl' then 9
 when 'zl' then 10
 when 'rl' then 11
 when 'yl' then 12
 when 'cdl' then 13
 when 'xl' then 14
 when 'pianl' then 15
end
from partno20120317