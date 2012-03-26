----------------------------------------------------------------------
----------------------------------------------------------------------
if exists (select * from sysobjects where name='users_info' and type ='U')
    drop table users_info
  go
create table users_info
(  
user_id            int identity   not null,
Entity_id          int,
users_code         varchar(15)    not null ,
users_name	       varchar(105),
distributor        int,
dealer             int,
location           int,
users_password     varchar(25),
email              varchar(65)    not null ,
country            varchar(25),
region             varchar(30),
city               varchar(30),
company_name       varchar(150),
company_phone		   varchar(15),
cell               varchar(15),
fax                varchar(15),
web_address        varchar(30),
postal_code        varchar(10),		
employees_number   int,
address		     		 varchar(253),
note		           varchar(253),
last_login_date    datetime,
register_date      datetime,
active_date        datetime,
active_flag        int default 0,
deptname           varchar(1),
operator	         varchar(1),
op_date            datetime default getdate(),
b1                 varchar(1),           -- spare data field, same as below
b2                 varchar(1),
b3                 varchar(1),
b4                 varchar(1),
b5                 varchar(1),
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
create table user_menu
(
users_code      varchar(35)     not null ,
distributor     int,
dealer          int,
location        int,
email           varchar(65), 
menu_id         int             not null , 
menu_name       varchar(65),
cdwz0           tinyint         default 0 ,
cdwz1           tinyint         default 0 ,
cdwz2           tinyint         default 0 ,
cdwz3           tinyint         default 0 ,
grant_gydm      char(4)         default '9999' ,
create_time     datetime        default getdate(),
)
go

create unique clustered index user_menu_operator_code_index on user_menu(users_code,menu_id)
go

insert user_menu(users_code,menu_id) values('phwuxj',900)
insert user_menu(users_code,menu_id) values('phwuxj',901)
insert user_menu(users_code,menu_id) values('phwuxj',905)
insert user_menu(users_code,menu_id) values('phwuxj',910)

----------------------------------------------------------------------
----------------------------------------------------------------------
if exists (select * from sysobjects where name='users_loginHist' and type ='U')
    drop table users_loginHist
  go
create table users_loginHist
(  
id_num             int identity   not null,
users_code         varchar(15)    not null ,
login_date         datetime default getdate(),
ipaddress          varchar(25),
results            char(25),
)
go

create  index users_loginHist_users_code on users_loginHist(users_code)
create  index users_loginHist_login_date on users_loginHist(login_date)
go


/*
CREATE FUNCTION dbo.customersbycountry ( @Country varchar(15) )
RETURNS 
	@CustomersbyCountryTab table (
		[CustomerID] [nchar] (5), [CompanyName] [nvarchar] (40), 
		[ContactName] [nvarchar] (30), [ContactTitle] [nvarchar] (30), 
		[Address] [nvarchar] (60), [City] [nvarchar] (15),
		[PostalCode] [nvarchar] (10), [Country] [nvarchar] (15), 
		[Phone] [nvarchar] (24), [Fax] [nvarchar] (24)
	)
AS
BEGIN
	INSERT INTO @CustomersByCountryTab 
	SELECT 	[CustomerID], 
			[CompanyName], 
			[ContactName], 
			[ContactTitle], 
			[Address], 
			[City], 
			[PostalCode], 
			[Country], 
			[Phone], 
			[Fax] 
	FROM [Northwind].[dbo].[Customers]
	WHERE country = @Country
	
	DECLARE @cnt INT
	SELECT @cnt = COUNT(*) FROM @customersbyCountryTab
	
	IF @cnt = 0
		INSERT INTO @CustomersByCountryTab (
			[CustomerID],
			[CompanyName],
			[ContactName],
			[ContactTitle],
			[Address],
			[City],
			[PostalCode],
			[Country], 
			[Phone],
			[Fax]  )
		VALUES ('','No Companies Found','','','','','','','','')
	
	RETURN
END
GO
select * from Customers where CustomerID in 
(SELECT CustomerID FROM dbo.customersbycountry('USA'))

SELECT * FROM dbo.customersbycountry('USA')
SELECT * FROM dbo.customersbycountry('CANADA')
SELECT * FROM dbo.customersbycountry('ADF')
*/