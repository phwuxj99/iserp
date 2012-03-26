
insert into category(category_id,category,description,operator)
select min(id_num), category,category,'phwuxj' from partno group by category