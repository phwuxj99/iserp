--use erp
--go


----
if(select count(*) from sysobjects where name = 'partno') > 0
  drop table partno
go
create table partno
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
operator         char(35),
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

create unique index part_no_index       on partno(part_no,operator) with ignore_dup_key
create index        part_name_index     on partno(part_name)
create index        part_category_index on partno(category)
go

drop index part_no_index on partno
ALTER TABLE partno ALTER COLUMN part_no VARCHAR(35) not null
go
ALTER TABLE partno WITH NOCHECK ADD 
CONSTRAINT PK_partno PRIMARY KEY NONCLUSTERED 
(
part_no
) ON [PRIMARY] 
GO




-----
if exists (select * from sysobjects where name='PartnoImage')
	DROP table PartnoImage
	go
	
CREATE TABLE PartnoImage
(
[img_pk] [int] IDENTITY (1, 1) NOT NULL ,
[img_partno] [varchar] (35) NOT NULL ,

img_part_name        varchar(85),
img_part_description varchar(500),
img_brand            varchar(65),
img_series           varchar(65),
img_model            varchar(65),
operator             varchar(35) not null,
[img_data] [image] NULL ,
[img_contenttype] [varchar] (50) NULL ,
--constraint img_pk_image_id foreign key references partno(image_id)

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE PartnoImage WITH NOCHECK ADD 
CONSTRAINT [PK_image] PRIMARY KEY NONCLUSTERED 
(
[img_partno],[operator]
) ON [PRIMARY] 
GO

--ALTER TABLE PartnoImage 
--ADD CONSTRAINT fk_PartnoImage
--FOREIGN KEY (img_partno) 
--REFERENCES partno (part_no) ON DELETE CASCADE 
--GO

create index        PartnoImage_brand_index     on PartnoImage(img_brand)
create index        PartnoImage_series_index    on PartnoImage(img_series)
create index        PartnoImage_model_index     on PartnoImage(img_model)
go



-- insert into partno(brand,series,model,part_no,part_name,outputvalue,compatible,dimension)
-- select brand,series,model,part_no,name,outputvalue,compatible,dimens from rcepart

----
if(select count(*) from sysobjects where name = 'hist_partno') > 0
  drop table hist_partno
go
create table hist_partno
(
id_num           int identity   not null,
part_no          char(35),
part_name        char(85),
part_description varchar(500),
unit             char(15),
category         char(65),
dimension        char(35),
weight           decimal(12,3),
notes            text,
operator         char(35),
op_date          datetime default getdate(),
op_type          char(35),
                 --delete, update
)
go

create unique index hist_part_no_index       on hist_partno(part_no) with ignore_dup_key
create index        hist_part_name_index     on hist_partno(part_name)
create index        hist_part_category_index on hist_partno(category)
go

------------------------------------------------------------
----------bom:bill of material-----begin
------------------------------------------------------------
if(select count(*) from sysobjects where name = 'bom_title') > 0
  drop table bom_title
go
create table bom_title
(
id_num               int identity        not null,
bom_no                char(45)           not null,
bom_name              char(65)                   ,
bom_description       nvarchar(500)              ,
bom_levelID           int                        ,
bom_level             char(35)                   , --product or component
drawing_no            nvarchar(85)               ,
client_no             nvarchar(85)               ,
client_drawing_no     nvarchar(150)              ,
unit                  char(15)                   ,
categoryID            int                        ,
category              char(65)                   ,
dimension             char(35)                   ,
net_weight            decimal(12,2)              ,
gross_weight          decimal(12,2)              ,
version_no            char(10)        Default '1',
package_no            char(35)                   ,
pic_filename          char(35)                   ,
readme_filename       char(35)                   ,
notes                 text                       ,
operator              char(35)                   ,
op_date               datetime  default getdate(),
)
go

create unique clustered index BomTitleBomno on bom_title(bom_no,operator) with IGNORE_DUP_KEY
create index BomTitleDrawingno on bom_title(bom_name)
create index BomTitleClientno  on bom_title(client_no)
go

------------------------------------------------------------
------------------------------------------------------------
if(select count(*) from sysobjects where name = 'bom_details') > 0
  drop table bom_details
go
create table bom_details(
id_num           int identity    not null ,
bom_no           char(45)        not null ,
item_no          int                      ,
lowlevel_lID     int                      ,
lowlevel_code    int                      ,
part_no          char(35)                 ,
part_name        varchar(65)              ,
part_description nvarchar(250)            ,
unit             char(15)                 ,
usages           decimal(12,2)            ,
parent_no        char(35)                 ,
comments         nvarchar(300)            ,
notes            text                     ,
operator         char(35)                 ,
op_date          datetime  default getdate(),
)
go

create index BomDetailsBomno    on bom_details(bom_no)
create index BomDetailsPartno   on bom_details(part_no)
create index BomDetailsUsage    on bom_details(usages)
create index BomDetailsParentno on bom_details(parent_no)
go


------------------------------------------------------------
----------bom:bill of material-------------end
------------------------------------------------------------

------------------------------------------------------------
----------ERP supply-------------begin
------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='erpsupply')
   drop table erpsupply
 go

create table erpsupply
(
id_num      			int identity   not null,
contact     			char(150),
intel_contact     char(65),
cname       			char(100),
cname_code   			char(10),                 --*****
terms       			char(20),
currency          char(35) default 'CAD',   --USA
tel         			char(65),
cell              char(65),
fax         			char(65),
email       			char(85),
website     			char(150),
address     			char(150),
city        			char(120),
locationID        int,
state       			char(100),
countryID        int,
country     			char(85),
postcode    			char(15),
discount    			decimal(12,4) default 1.00,
																					-- following information is confidental
principals        		char(250),
founded           		char(250),
accountting_contact   char(250),
business_no       		char(250),
credit_reference  		char(250),
credit_limit      		char(250),
company_bank      		char(250),
credit_card_no        char(65),
																					-- above information is confidental
tbalan      			decimal(12,2),
tbalan_new  			decimal(12,2),
rating        		int default 4,
fob         			char(6),
operator    			char(35),
op_date     			datetime,
notes       			text,
)
go

create unique index erpsupply_cname_cname_code    on erpsupply(cname,cname_code,operator)    with ignore_dup_key
go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists(select * from sysobjects where name='contact_supply' )
		drop table contact_supply
	go

create table contact_supply
(
id_num            int identity   not null,
company_code      char(158),
company_name      char(158),
contact_name      char(100),
last_name         char(65),
gender            char(15),
profession_title  char(150),
title             char(150),
tel               char(25),
fax               char(25),
email             char(125),
cellphone         char(25),
department        char(100),
operator          char(35),
flag              char(15)  default 'Y',   --default contact person: Y or N
op_date           char(15)  default convert(char,getdate(),101),
)
go

create unique index contact_supply_company_code_first_last_name  
  on contact_supply(company_code,contact_name,operator)    with ignore_dup_key
create index contact_supply_company_name on contact_supply(company_name)
go
------------------------------------------------------------
----------ERP supply-------------end
------------------------------------------------------------

------------------------------------------------------------
----------ERP client-------------begin
------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='erpclient')
   drop table erpclient
 go

create table erpclient
(
id_num      			int identity   not null,
contact     			char(150),
intel_contact     char(65),
cname       			char(100),
cname_code   			char(10),                 --*****
terms       			char(20),
currency          char(35) default 'CAD',   --USA
tel         			char(65),
cell              char(65),
fax         			char(65),
email       			char(85),
website     			char(150),
address     			char(150),
city        			char(120),
locationID              int,
state       			char(100),
countryID               int,
country     			char(85),
postcode    			char(10),
discount    			decimal(12,4) default 1.00,
																					-- following information is confidental
principals        		char(250),
founded           		char(250),
accountting_contact   char(250),
business_no       		char(250),
credit_reference  		char(250),
credit_limit      		char(250),
company_bank      		char(250),
credit_card_no        char(65),
																					-- above information is confidental
tbalan      			decimal(12,2),
tbalan_new  			decimal(12,2),
rating        		int default 4,
fob         			char(6),
operator    			char(35),
op_date     			datetime,
notes       			text,
)
go

create unique index erpclient_cname_cname_code    on erpclient(cname,cname_code,operator)    with ignore_dup_key
go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists(select * from sysobjects where name='contact_client' )
		drop table contact_client
	go

create table contact_client
(
id_num            int identity   not null,
company_code      char(158),
company_name      char(158),
contact_name      char(100),
last_name         char(65),
gender            char(15),
profession_title  char(150),
title             char(150),
tel               char(25),
fax               char(25),
email             char(125),
cellphone         char(25),
department        char(100),
flag              char(15)  default 'Y',   --default contact person: Y or N
op_date           char(15)  default convert(char,getdate(),101),
operator          char(35),
)
go

create unique index contact_client_company_code_first_last_name  
  on contact_client(company_code,contact_name)    with ignore_dup_key
create index contact_client_company_name on contact_client(company_name)
go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists(select * from sysobjects where name='shipping_client')
		drop table shipping_client
go

create table shipping_client
(
id_num       int identity   not null,
cname        char(150) ,
sname        char(150) default '',
saddress     char(250) default '',
scity        char(150) default '',
sstate       char(150) default '',
scountry     char(150) default '',
spostcode    char(25)  default '',
spodate      char(15)  default '',
semail       char(95)  default '',
stel         char(35)  default '',
sfax         char(35)  default '',
flag         char(15)  default '',    ----on; finished;
ups_account  char(15)  default '',    ----aps;others;
operator          char(35),
notes        text      default '',
)
go
create index shipping_client_cname   on shipping_client(cname)
create index shipping_client_sname   on shipping_client(sname)
create index shipping_client_spodate on shipping_client(spodate)
go
------------------------------------------------------------
----------ERP client-------------end
------------------------------------------------------------


------------------------------------------------------------
----------ERP Warehouse-------------begin
------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if(select count(*) from sysobjects where name = 'warehouse') > 0
  drop table warehouse
go
create table warehouse
(
id_num      int identity   not null,
part_no    varchar(35),
part_name  varchar(65),
partno_id int,
locator     varchar(15),
UOM         int,
pkno        int,
brand            varchar(65),
series           varchar(65),
model            varchar(65),
yyear       char(5),
description varchar(500),
weight      decimal(12,2),
price       decimal(12,3)        default 0 , 	
qty           int                default 0 , 	
qty_onhand    int                default 0 , 	
qty_order     int                default 0,       --
qty_shipping  int                default 0,       --
qty_avail     int                default 0 , 	
qty_reserved  int                default 0 , 	
qty_hardware  int                default 0,
qty_hardware_avail  int          default 0,
qty_damage    int                default 0 ,  
qty_Cpo       int,
qty_backorder  int               default 0,
qty_min	      int           	   default 0 ,
qty_max	      int           	   default 0 ,
qty_count     int,                                  --**warehouse;cpo;shipment;month used(3)**
total_amount  decimal(12,3)	    default 0 ,
qty_in        int               default 0,
qty_sold      int               default 0,
qty_out       int               default 0,
wh_name       varchar(65)    ,
operator          char(35),
notes         text,
)
go

create unique clustered index warehouse_partno_wh_name on warehouse(part_no,wh_name) with IGNORE_DUP_KEY 
go

create index warehouse_price     on warehouse(price)
create index warehouse_qty_avail on warehouse(qty_avail)
create index warehouse_qty_onhand on warehouse(qty_onhand)
create index warehouse_qty_min   on warehouse(qty_min)
create index warehouse_qty_max   on warehouse(qty_max)
go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='wh_receipt')
   drop table wh_receipt
 go
 
create table wh_receipt        --warehouse;cpo
(
id_num      int identity   not null,
part_no    varchar(35),
partno_id int,
whre_no     varchar(35),
supplier_code   varchar(50),
podate      datetime,
cduedate    datetime,
ddate       datetime,
ftno        varchar(15),
leftdate    datetime,
qty         int,
qty2        int,
itemno      int,
order_no      varchar(35),
flag        varchar(10),  --Default:0, Inbound:1, Done:2
operator    char(35),
op_date     datetime,
notes       text,
)  
go

create index wh_receipt_billno     on wh_receipt(whre_no)
create index wh_receipt_podate     on wh_receipt(podate)
create index wh_receipt_partno   on wh_receipt(part_no)
go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='hist_receipt')
   drop table hist_receipt
 go
 
create table hist_receipt
(
id_num      int identity   not null,
old_id_num  int,
part_no    varchar(35),
partno_id  int,
receiptno      varchar(35),
supplier_code   varchar(50),
podate      varchar(10),
cduedate    varchar(10),
ddate       varchar(10),
ftno        varchar(15),
leftdate    varchar(10),
qty         int,
qty2        int,
itemno      int,
shipno      int,
operator    char(35),
op_date     datetime,
op_date1    datetime,
notes       text,
)   
go

create index hist_receipt_receiptno     on hist_receipt(receiptno)
create index hist_receipt_podate        on hist_receipt(podate)
create index hist_receipt_partno        on hist_receipt(part_no)
go



------------------------------------------------------------
----------ERP Warehouse-------------end
------------------------------------------------------------


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists(select * from sysobjects where name='cpo')
   drop table cpo
 go
 
create table cpo
(
id_num      int identity   not null,
itemno      int,
part_no     varchar(35),
cname       varchar(35),
cname_code  varchar(35),
partno_description varchar(250),
pkno        int,
podate      varchar(8),
ddate       varchar(8),
soprice     decimal(12,3),
mmsop       decimal(8,3),
qty         int default 0,
qty_inv     int default 0,
qtydiff     int default 0,
cpono       varchar(20),
apono       varchar(20),
shiphand    decimal(12,2),
qtyshipd    int default 0,
qtyout      int default 0,
fob         varchar(15),
boxed       char(1),
finished    char(1) default null , -- 0: confirm; 1: invoiced
operator    char(35),
op_date     datetime,
notes       text,
)   
go

create index cpo_partno   on cpo(part_no)
create index cpo_apono    on cpo(apono)
create index cpo_cname    on cpo(cname)
create index cpo_pkno     on cpo(pkno)
create index cpo_cpono    on cpo(cpono)
go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='invoice')
   drop table invoice
 go
 
create table invoice
(
id_num      int identity   not null,
invoiceno   int,
invoicedate char(10),
duedate     char(10),     
paydate     char(25),     
terms       char(15),         --**cod:cash o deliver  ; 15days; 30day; 60day; 120**
cname       char(100),
cname_code  varchar(35),
part_no    char(35),
part_no_id int,
partno_description varchar(500),    ---year+descrip
cpono       char(20),
cpono_id_num int,
itemno      int,             --(serial in cpo)apsinvoice item no
qty         int default 0,
qtyp        int default 0,
uprice      decimal(12,2),   --soprice
discount    decimal(8,4),
paidprice   decimal(12,2),   --all amount
tpaidprice   decimal(12,2)     default '0.00',   --total paid amount
comment     text,
flag        char(15),        --  1 finished
                             --  2 onfinished: first pay ok,but not finished.
                             --  3 pfinished
                             --  4 batch
                             --  5 single
                             --  6 HL
                             --  7 CRED
                             --  8 Return 
operator    char(35),
op_date     datetime,
notes       text,
)
go

create index invoice_invoiceno on invoice(invoiceno)
create index invoice_filename on invoice(part_no)
create index invoice_cname on invoice(cname)
create index invoice_invoicedate on invoice(invoicedate)
go

------------------------------------------------------------
----------system---bill of material-------------begin
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
if(select count(*) from sysobjects where name = 'category') > 0
  drop table category
go
create table category
(
id_num            int identity    not null ,
category_id       varchar(15)                 ,
category          varchar(65)                 ,
description       nvarchar(250)            ,
operator          char(35),
     CONSTRAINT pk_id_num PRIMARY KEY CLUSTERED (id_num)  ON [PRIMARY]
) ON [PRIMARY]
go

------------------------------------------------------------
------------------------------------------------------------
if(select count(*) from sysobjects where name = 'bom_category') > 0
  drop table bom_category
go
create table bom_category
(
id_num            int identity    not null ,
category_id       varchar(15)                 ,
category          varchar(65)                 ,
description       nvarchar(250)            ,
operator          char(35),
     CONSTRAINT pk_bom_category_id PRIMARY KEY CLUSTERED (category_id)  ON [PRIMARY]
) ON [PRIMARY]
go


------------------------------------------------------------
------------------------------------------------------------
if(select count(*) from sysobjects where name = 'bom_lower_level') > 0
  drop table bom_lower_level
go

create table bom_lower_level
(
id_num            int identity    not null ,
level_code        varchar(15)                 ,
lower_level       int                      ,
description       nvarchar(250)            ,
operator          char(35),
     CONSTRAINT pk_level_code PRIMARY KEY CLUSTERED (level_code)  ON [PRIMARY]
) ON [PRIMARY]
go


--delete bom_lower_level where operator=''
--delete bom_category where operator=''
--delete category where operator=''
----insert bom_lower_level values('1','1','1 level','')
----insert bom_lower_level values('2','2','2 level','')

----insert bom_category values('B1','Products','Bom of Product','')
----insert bom_category values('B2','components','Bom of component','')

----insert category values('A1','Audio','Audio','')
----insert category values('A2','Adapter','Audio','')


--insert bom_lower_level values('1','1','1 level','phwuxj')
--insert bom_lower_level values('2','2','2 level','phwuxj')

--insert bom_category values('B1','Products','Bom of Product','phwuxj')
--insert bom_category values('B2','components','Bom of component','phwuxj')

--insert category values('A1','Audio','Audio','phwuxj')
--insert category values('A2','Adapter','Audio','phwuxj')

------------------------------------------------------------
----------system---bill of material-------------end
------------------------------------------------------------

if exists(select * from sysobjects where name='rcebrand')
   drop table rcebrand
 go
 
create table rcebrand
(
id_num      int identity   not null,
brand       varchar(35) not null,
series      varchar(65) not null,
model       varchar(65) not null,
operator          varchar(35),
CONSTRAINT pk_rcebrand PRIMARY KEY CLUSTERED (brand,series,model,operator)  ON [PRIMARY]
)
 ON [PRIMARY]
go


insert rcebrand(brand,series,model,operator) values('Acer   '          , 'Acer   ','Acer   ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Apple  '          , 'Apple  ','Apple  ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Asus   '          , 'Asus   ','Asus   ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Clevo  '          , 'Clevo  ','Clevo  ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Compaq '          , 'Compaq ','Compaq ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Dell   '          , 'Dell   ','Dell   ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Fujitsu'          , 'Fujitsu','Fujitsu','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Gateway'          , 'Gateway','Gateway','infocccadmin'   )     
insert rcebrand(brand,series,model,operator) values('Hitachi'          , 'Hitachi','Hitachi','infocccadmin'   )     
insert rcebrand(brand,series,model,operator) values('HP     '          , 'HP     ','HP     ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('IBM    '          , 'IBM    ','IBM    ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Lenovo '          , 'Lenovo ','Lenovo ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('LG     '          , 'LG     ','LG     ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('NEC    '          , 'NEC    ','NEC    ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Samsung'          , 'Samsung','Samsung','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Sharp  '          , 'Sharp  ','Sharp  ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Sony   '          , 'Sony   ','Sony   ','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Toshiba'          , 'Toshiba','Toshiba','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Uniwill'          , 'Uniwill','Uniwill','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('Winbook'          , 'Winbook','Winbook','infocccadmin'   ) 
insert rcebrand(brand,series,model,operator) values('No'               , 'No',     'No'     ,'infocccadmin'   ) 
                     
go     












