if(select count(*) from sysobjects where name = 'tmp_partno') > 0
  drop table tmp_partno
go
create table tmp_partno
(
id_num           int identity   not null,
part_no          char(35),
part_name        char(85),
image_id         int,
part_description varchar(500),
unit             char(15),
category         char(65),
dimension        char(35),
weight           decimal(12,3),
notes            text,
operatorA         char(85),
op_date          datetime default getdate(),

brand            char(65),
series           char(65),
model            char(65),
outputvalue      varchar(165),
compatible       varchar(350),

yyear            char(15),

price1           decimal(12,2),
price2           decimal(12,2),
price3           decimal(12,2),
length           int,
width            int,
height           int,
)
go

create  index tmppart_no_index       on tmp_partno(part_no) 
go