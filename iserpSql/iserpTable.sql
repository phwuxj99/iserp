

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if(select count(*) from sysobjects where name = 'partno' and xtype='U') > 0
  drop table partno
go
create table dbo.partno
(
id_num           int identity   not null,
part_no          nvarchar(35) not null,
part_name        nvarchar (85),
image_id         int,
part_description nvarchar (500),
unit             nvarchar (15),
category         nvarchar (65),
dimension        nvarchar (35),
weight           decimal(12,3),
notes            ntext,
operator         nchar(35) not null,
op_date          datetime default getdate(),

brand            nvarchar (65),
series           nvarchar (65),
model            nvarchar (65),
outputvalue      nvarchar (165),
compatible       nvarchar (350),

yyear            nvarchar (15),

price1           decimal(12,2),
price2           decimal(12,2),
price3           decimal(12,2),
length           int,
width            int,
height           int,
  Primary key (part_no, operator)
)   
go

create index        part_name_index     on partno(part_name)
create index        part_category_index on partno(category)
go



------------------------------------------------------------
------------------------------------------------------------
----------ERP client-------------begin
------------------------------------------------------------
------------------------------------------------------------
if exists (select * from sysobjects where name='erpclient')
   drop table erpclient
 go

create table dbo.erpclient
(
id_num      			int identity   not null,
contact     			nvarchar (150),
intel_contact     nchar(65),
cname       			nvarchar (100),
cname_code   			nvarchar (10),                 --*****
terms       			nvarchar (20),
currency          nvarchar (35) default 'CAD',   --USA
tel         			char(65),
cell              char(65),
fax         			char(65),
email       			char(85),
website     			char(150),
address     			nvarchar (150),
city        			nvarchar (120),
locationID              int,
state       			nvarchar (100),
countryID               int,
country     			nvarchar (85),
postcode    			nchar(10),
discount    			decimal(12,4) default 1.00,
invoice_tax             int,
																					-- following information is confidental
principals        		nvarchar (250),
founded           		nvarchar (250),
accountting_contact   nvarchar (250),
business_no       		nvarchar (250),
credit_reference  		nvarchar (250),
credit_limit      		nvarchar (250),
company_bank      		nvarchar (250),
credit_card_no        nvarchar (65),
																					-- above information is confidental
tbalan      			decimal(12,2),
tbalan_new  			decimal(12,2),
rating        		int default 4,
fob         			nchar(6),
operator    			nvarchar (35),
op_date     			datetime,
notes       			text,
)
go

create unique index erpclient_cname__op    on erpclient(cname,operator)    with ignore_dup_key
create unique index erpclient_cname_code_op    on erpclient(cname_code,operator)    with ignore_dup_key
go
------------------------------------------------------------
------------------------------------------------------------
----------ERP client-------------end
------------------------------------------------------------
------------------------------------------------------------

------------------------------------------------------------
------------------------------------------------------------
----------ERP Warehouse-------------begin
------------------------------------------------------------
------------------------------------------------------------
if(select count(*) from sysobjects where name = 'warehouse') > 0
  drop table warehouse
go
create table dbo.warehouse
(
id_num      int identity   not null,
part_no    nvarchar (35),
part_name  nvarchar (65),
partno_id int,
locator     nvarchar (15),
UOM         int,
pkno        int,
brand            nvarchar (65),
series           nvarchar (65),
model            nvarchar (65),
yyear       nchar(5),
description nvarchar (500),
unit             nvarchar (15),
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
notes         ntext,
)
go

create unique clustered index warehouse_partno_wh_name on warehouse(part_no,operator) with IGNORE_DUP_KEY 
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
 
create table dbo.wh_receipt        --warehouse;cpo
(
id_num      int identity   not null,
part_no    nvarchar (35),
part_name  nvarchar (65),
partno_id int,
whre_no     nvarchar(35),
supplier_code   nvarchar(50),
podate      datetime,
cduedate    datetime,
ddate       datetime,
ftno        nvarchar(15),
leftdate    datetime,
qty         int,
qty2        int,
itemno      int,
order_no      nvarchar(35),
flag        nvarchar(10),  --Default:0, Inbound:1, Done:2
operator    nvarchar (35),
op_date     datetime,
notes       ntext,
)  
go

create index wh_receipt_billno     on wh_receipt(whre_no)
create index wh_receipt_operator   on wh_receipt(operator)
create index wh_receipt_podate     on wh_receipt(podate)
create index wh_receipt_partno     on wh_receipt(part_no)
go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='hist_receipt')
   drop table hist_receipt
 go
 
create table dbo.hist_receipt
(
id_num      int identity   not null,
old_id_num  int,
part_no    nvarchar (35),
partno_id  int,
receiptno      nvarchar(35),
supplier_code   nvarchar(50),
podate      nvarchar(10),
cduedate    nvarchar(10),
ddate       nvarchar(10),
ftno        nvarchar(15),
leftdate    nvarchar(10),
qty         int,
qty2        int,
itemno      int,
shipno      int,
operator    nvarchar (35),
op_date     datetime,
op_date1    datetime,
notes       ntext,
)   
go

create index hist_receipt_receiptno     on hist_receipt(receiptno)
create index hist_receipt_podate        on hist_receipt(podate)
create index hist_receipt_partno        on hist_receipt(part_no)
go
------------------------------------------------------------
------------------------------------------------------------
----------ERP Warehouse-------------end
------------------------------------------------------------
------------------------------------------------------------


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists(select * from sysobjects where name='cpo')
   drop table cpo
 go
 
create table dbo.cpo
(
id_num      int identity   not null,
itemno      int,
part_no     nvarchar (35),
cname       nvarchar (35),
cname_code  nvarchar (35),
part_name        nvarchar (85),
partno_description nvarchar (250),
unit             nvarchar (15),
pkno        int,
podate      nvarchar (8),
ddate       nvarchar (8),
soprice     decimal(12,3),
mmsop       decimal(8,3),
qty         int default 0,
qty_inv     int default 0,
qtydiff     int default 0,
cpono       nvarchar (20),
apono       nvarchar (20),
shiphand    decimal(12,2),
qtyshipd    int default 0,
qtyout      int default 0,
fob         nvarchar (15),
boxed       char(1),
finished    char(1) default null , -- 0: confirm; 1: invoiced
operator    char(35),
op_date     datetime,
notes       ntext,
)   
go

create index cpo_partno   on cpo(part_no)
create index cpo_apono    on cpo(apono)
create index cpo_operator on cpo(operator)
create index cpo_cname    on cpo(cname)
create index cpo_pkno     on cpo(pkno)
create index cpo_cpono    on cpo(cpono)
go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='invoice')
   drop table invoice
 go
 
create table dbo.invoice
(
id_num      int identity   not null,
invoiceno   int,
invoicedate nvarchar (10),
duedate     nchar(10),     
paydate     nchar(25),     
terms       nchar(15),         --**cod:cash o deliver  ; 15days; 30day; 60day; 120**
cname       nvarchar (100),
cname_code  nvarchar (35),
part_no    nvarchar (35),
part_no_id int,
part_name        nvarchar (85),
partno_description nvarchar (500),    ---year+descrip
unit             nvarchar (15),
cpono       nvarchar (20),
cpono_id_num int,
itemno      int,             --(serial in cpo)apsinvoice item no
qty         int default 0,
qtyp        int default 0,
uprice      decimal(12,2),   --soprice
discount    decimal(8,4),
paidprice   decimal(12,2),   --all amount
tax          decimal(12,2)     default '0.00',
tpaidprice   decimal(12,2)     default '0.00',   --total paid amount
comment     ntext,
flag        nchar(15),        --  1 finished
                             --  2 onfinished: first pay ok,but not finished.
                             --  3 pfinished
                             --  4 batch
                             --  5 single
                             --  6 HL
                             --  7 CRED
                             --  8 Return 
operator    nvarchar (35),
op_date     datetime,
notes       ntext,
)
go

create index invoice_invoiceno on invoice(invoiceno)
create index invoice_operator on invoice(operator)
create index invoice_filename on invoice(part_no)
create index invoice_cname on invoice(cname)
create index invoice_invoicedate on invoice(invoicedate)
go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='hist_invoice')
   drop table hist_invoice
 go
 
create table dbo.hist_invoice
(
id_num      int identity   not null,
old_id_num  int,
invoiceno   int,
invoicedate nvarchar (10),
duedate     nchar(10),     
paydate     nchar(25),     
terms       nchar(15),         --**cod:cash o deliver  ; 15days; 30day; 60day; 120**
cname       nvarchar (100),
cname_code  nvarchar (35),
part_no    nvarchar (35),
part_no_id int,
partno_description nvarchar (500),    ---year+descrip
cpono       nchar(20),
cpono_id_num int,
itemno      int,             --(serial in cpo)apsinvoice item no
qty         int default 0,
qtyp        int default 0,
uprice      decimal(12,2),   --soprice
discount    decimal(8,4),
paidprice   decimal(12,2),   --all amount
tpaidprice   decimal(12,2)     default '0.00',   --total paid amount
comment     ntext,
flag        nchar(15),        --  1 finished
                             --  2 onfinished: first pay ok,but not finished.
                             --  3 pfinished
                             --  4 batch
                             --  5 single
                             --  6 HL
                             --  7 CRED
                             --  8 Return 
operator    nvarchar (35),
op_date     datetime,
notes       ntext,
)
go

create index histinvoice_invoiceno on hist_invoice(invoiceno)
create index histinvoice_filename on hist_invoice(part_no)
create index histinvoice_cname on hist_invoice(cname)
create index histinvoice_invoicedate on hist_invoice(invoicedate)
go

------------------------------------------------------------
------------------------------------------------------------
if(select count(*) from sysobjects where name = 'category') > 0
  drop table category
go
create table dbo.category
(
id_num            int identity    not null ,
category_name          nvarchar (65)                 ,
description       nvarchar(250)            ,
operator          nvarchar (35),
     CONSTRAINT pk_id_num PRIMARY KEY CLUSTERED (id_num)  ON [PRIMARY]
) ON [PRIMARY]
go


----------------------------------------------------------------------
----------------------------------------------------------------------
if exists (select * from sysobjects where name='users_info' and type ='U')
    drop table users_info
  go
create table dbo.users_info
(  
user_id            int identity   not null,
Entity_id          int,
users_code         nvarchar (15)    not null ,
users_name	       nvarchar (105),
distributor        int,
dealer             int,
location           int,
users_password     nvarchar (25),
email              nvarchar (65)    not null ,
country            nvarchar (25),
region             nvarchar (30),
city               nvarchar (30),
company_name       nvarchar (150),
company_phone		   nvarchar (15),
cell               nvarchar(15),
fax                nvarchar(15),
web_address        nvarchar(30),
postal_code        nvarchar(10),		
employees_number   int,
address		     		 nvarchar(253),
note		           nvarchar(253),
invoice_name       nvarchar(253),
invoice_address    nvarchar(253),
invoice_phone      nvarchar(253),
invoice_tax        int,
last_login_date    datetime,
register_date      datetime,
active_date        datetime,
active_flag        int default 0,
deptname           nvarchar(1),
operator	       nvarchar(1),
op_date            datetime default getdate(),
b1                 nvarchar(1),           -- spare data field, same as below
b2                 nvarchar(1),
b3                 nvarchar(1),
b4                 nvarchar(1),
b5                 nvarchar(1),
)
go

create unique index users_info_users_code on users_info(users_code) with ignore_dup_key
create index users_info_email on users_info(email)
go


----------------------------------------------------------------------
----------------------------------------------------------------------
if(select count(*) from sysobjects where name = 'user_menu') > 0
  drop table user_menu
go
create table dbo.user_menu
(
users_code      nvarchar (35)     not null ,
users_entity    int,
distributor     int,
dealer          int,
location        int,
email           nvarchar (65), 
menu_id         int             not null , 
menu_name       nvarchar (65),
menu_description nvarchar (255),
url              nvarchar (55),
partent_id       int,
cdwz0           tinyint         default 0 ,
cdwz1           tinyint         default 0 ,
cdwz2           tinyint         default 0 ,
cdwz3           tinyint         default 0 ,
grant_gydm      nchar(4)         default '9999' ,
create_time     datetime        default getdate(),
)
go

create unique clustered index user_menu_operator_code_index on user_menu(users_code,menu_id)
go

-- insert user_menu(users_code,menu_id) values('phwuxj',900)
-- insert user_menu(users_code,menu_id) values('phwuxj',901)
-- insert user_menu(users_code,menu_id) values('phwuxj',905)
-- insert user_menu(users_code,menu_id) values('phwuxj',910)

----------------------------------------------------------------------
----------------------------------------------------------------------
if exists (select * from sysobjects where name='users_loginHist' and type ='U')
    drop table users_loginHist
  go
create table dbo.users_loginHist
(  
id_num             int identity   not null,
users_code         nvarchar (15)    not null ,
login_date         datetime default getdate(),
ipaddress          nvarchar (25),
results            nvarchar (25),
)
go

create  index users_loginHist_users_code on users_loginHist(users_code)
create  index users_loginHist_login_date on users_loginHist(login_date)
go
