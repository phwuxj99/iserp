----------------------------------------------------------------------
---------------User Register-----Oct 04, 2009 -----------------------
------begin-----------------------------------------------------------
if (select count(*) from sysobjects where name='user_register' and type='P') > 0
      drop proc  user_register
   go
   
create proc user_register
               @p_users_code           varchar(15),    -- email address
               @p_users_name           varchar(105),
               @p_email                varchar(65),
               @p_password             varchar(25),
               @p_country              varchar(65),
               @p_region               varchar(100),
               @p_city                 varchar(55),
               @p_company_name         varchar(55),
               @p_company_phone        varchar(35),               
               @isvalid                nvarchar(255) output
          with encryption as
 

 declare @user_password varchar(25)
 
 if exists ( select * from users_info where users_code=@p_users_code )
  begin
  	select @isvalid='User Exists.'
  	return -1100
  end

 if exists ( select * from users_info where email=@p_email )
  begin
  	select @isvalid='Email Exists.'
  	return -1100
  end

 exec nb_txmm_jiami @p_users_code, @p_password, @user_password out

 insert users_info(users_code,users_name,email,users_password,city,region,country,company_name,company_phone,register_date)
    values(@p_users_code,@p_users_name,@p_email,@user_password,@p_city,@p_region,@p_country,@p_company_name,@p_company_phone,getdate())
 if @@rowcount=0
   begin
      select @isvalid='Server can not process your request.'
      return -1200
   end

  select @isvalid='Success!'

 return 0

go 


----------------------------------------------------------------------
----------------------------------------------------------------------
if (select count(*) from sysobjects where name='user_getmenu' and type='P') > 0
      drop proc  user_getmenu
   go

create proc user_getmenu
               @p_users_code           varchar(15)    -- email address

          with encryption as

--  SELECT ID,Title,u.menu_name FROM SiteMap s left join  user_menu u on s.id= u.menu_id where u.users_code=@p_users_code
--SELECT ID,Title,u.menu_name,u.users_code,case  when  s.parent>1 then 'SubMenu' else 'Menu'  end  FROM SiteMap s left join  user_menu u on s.id= u.menu_id 
--     where u.users_code=@p_users_code
SELECT s.ID,s.Title,u.menu_name,u.users_code,case  when  s.parent>1 then 'SubMenu' else 'Menu'  end  FROM SiteMap s 
   left outer join (select menu_id,users_code,menu_name from user_menu where users_code=@p_users_code) u on s.id= u.menu_id 
   where s.Parent = 1

go


----------------------------------------------------------------------
----------------------------------------------------------------------
if (select count(*) from sysobjects where name='user_getsubmenu' and type='P') > 0
      drop proc  user_getsubmenu
   go

create proc user_getsubmenu
               @p_users_code           varchar(15),    -- email address
               @p_menuID               varchar(10)

          with encryption as

--  SELECT ID,Title,u.menu_name FROM SiteMap s left join  user_menu u on s.id= u.menu_id where u.users_code=@p_users_code
--SELECT ID,Title,u.menu_name,u.users_code,case  when  s.parent>1 then 'SubMenu' else 'Menu'  end  FROM SiteMap s left join  user_menu u on s.id= u.menu_id 
--     where u.users_code=@p_users_code
SELECT s.ID,s.Title,s.Parent,s.Description,case when u.users_code is null then 0 else 1 end as 'menu_name',ISNULL( u.users_code,0) as 'users_code',case  when  s.parent>1 then 'SubMenu' else 'Menu'  end  FROM SiteMap s 
   left outer join (select menu_id,users_code,menu_name from user_menu where users_code=@p_users_code) u on s.id= u.menu_id 
   where s.Parent=@p_menuID


go
----------------------------------------------------------------------
----------------------------------------------------------------------
 

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if exists(select * from sysobjects where name='user_setmenu')
 drop proc user_setmenu
go

create proc user_setmenu
		@p_menuID           varchar(10),
		@p_usercode         varchar(35),
		@isvalid            varchar(100)    output
 	with encryption as
  
  declare @parentID varchar(10)
  
  select @parentID=Parent from SiteMap where ID=@p_menuID
  
  if not exists(select * from user_menu where users_code=@p_usercode and menu_id=@p_menuID)
     begin
          insert user_menu(users_code,menu_id) values(@p_usercode,@p_menuID)
				  if @@rowcount=0
				   begin
				     select @isvalid = '"'+@p_usercode+'" set the "'+@p_menuID+' Error"' 
				     return -100
				   end
     end   
          
   select @isvalid = 'Success!' 
   
  return 0
  
 go 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if exists(select * from sysobjects where name='user_delmenu')
 drop proc user_delmenu
go

create proc user_delmenu
		@p_menuID           varchar(10),
		@p_usercode         varchar(35),
		@isvalid            varchar(100)    output
 	with encryption as
  
  declare @parentID varchar(10)
  
  
  if exists(select * from user_menu where users_code=@p_usercode and menu_id=@p_menuID)
     begin
          delete user_menu where users_code=@p_usercode and menu_id=@p_menuID
				  if @@rowcount=0
				   begin
				     select @isvalid = '"'+@p_usercode+'" set the "'+@p_menuID+' Error"' 
				     return -100
				   end
     end   
          
   select @isvalid = 'Success!' 
   
  return 0
  
 go 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

 
----------------------------------------------------------------------
---------------Check operator password-----Oct 07, 2009 ------------
-----------------------------------------------------------------
if (select count(*) from sysobjects where name='user_login' and type='P') > 0
      drop proc  user_login
   go

create proc user_login
               @p_users_code        char(65),
               @p_users_password    char(25),
               @p_ipaddress         char(25),
               @isvalid                nvarchar(255)    output
          with encryption as
          
 declare   @password_a          nvarchar(25),
           @password_aa         nvarchar(25),
           @lasted_login_date   datetime

 if not exists ( select * from users_info where users_code = @p_users_code )
  begin
  	select @isvalid = 'You are not a member! Please register!'
  	 insert users_loginHist(users_code,login_date,ipaddress,results)
        values(@p_users_code,getdate(),@p_ipaddress,'UnRegister')
  	return -1000
  end

 if exists ( select * from users_info where users_code = @p_users_code and active_flag=0 )
  begin
  	select @isvalid = 'Please wait for Administrator to Active!'
  	 insert users_loginHist(users_code,login_date,ipaddress,results)
        values(@p_users_code,getdate(),@p_ipaddress,'UnActive')
  	return -1000
  end

 update users_info set last_login_date = getdate() where users_code=@p_users_code 

 exec nb_txmm_jiami @p_users_code, @p_users_password, @password_a out
 select @password_aa = users_password from users_info where users_code=@p_users_code 
 if @password_a != @password_aa
  begin
  	select @isvalid = 'Access Denied. User Name or Password is Incorrect.'
  	 insert users_loginHist(users_code,login_date,ipaddress,results)
        values(@p_users_code,getdate(),@p_ipaddress,'Wrong PWD')
  	return -1010
  end
  
  if (@p_users_code!='phwuxj')
 insert users_loginHist(users_code,login_date,ipaddress,results)
        values(@p_users_code,getdate(),@p_ipaddress,'OK')

  select @isvalid='Success.'
 
 return 0
    
go    


-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
--Nov 1,2009 begin
--create  PROCEDURE GetUsersSorted as
-- drop proc GetUsersSorted
    ALTER PROCEDURE GetUsersSorted
--CREATE PROCEDURE GetUsersSorted 
 ( 
  @sortExpression nvarchar(100),
  @sortDirection  varchar(15),
  @startRowIndex int, 
  @maximumRows int ,
  -- @p_usercode   varchar(35),
  @rowcount int output
 ) 
 AS
 
 -- Make sure a @sortExpression is specified 
 IF LEN(@sortExpression) = 0 or @sortExpression is null
    SET @sortExpression = 'users_code'
    
-- select @maximumRows = @maximumRows+1
 if @startRowIndex>1
    select @startRowIndex=(@startRowIndex-1)*@maximumRows+1
    
 select @rowcount=COUNT(*) from users_info
 
  -- Issue query 
  declare @sql nvarchar(4000)
   set @sql='select a.users_code,a.users_name,a.email,a.country,a.region,a.city,a.company_name,a.company_phone,a.cell,a.fax,a.web_address,a.postal_code,a.last_login_date,a.register_date,a.active_date,a.active_flag
                      from (select users_code,users_name,email,country,region,city,company_name,company_phone,cell,fax,web_address,postal_code,last_login_date,register_date,active_date,active_flag,
                      				ROW_NUMBER() OVER(ORDER BY '+@sortExpression+' '+rtrim(@sortDirection)+') as rowrank
                      				from users_info                      				
                      			) as a
                          where  a.rowrank >='+convert(nvarchar(10),@startRowIndex)+' and
                                 a.rowrank <('+convert(nvarchar(10),@startRowIndex)+' + '+
                               convert(nvarchar(10),@maximumRows)+') ORDER by a.register_date desc' 

  --print @sql
  EXEC sp_executesql @sql

go

--user_id,users_code,users_name,distributor,dealer,location,users_password,email,country,region,city,company_name,company_phone,cell,
--fax,web_address,postal_code,employees_number,address,note,last_login_date,register_date,active_date,active_flag,deptname,operator,op_date
 
 
 
 
----------------------------------------------------------------------
--------------- users change password-----Nov 26, 2009 ------------
----------------------------------------------------------------------
if (select count(*) from sysobjects where name='users_change_password' and type='P') > 0
      drop proc  users_change_password
   go
   
create proc users_change_password
               @p_users_code           char(65),
               @p_old_password         char(25),
               @p_new_password         char(25),
               @isvalid                nvarchar(255)    output
          with encryption as
          
 declare   @password_a          nvarchar(25),
           @password_aa         nvarchar(25),
           @lasted_login_date   datetime
           
 if not exists ( select * from users_info where users_code = @p_users_code )
  begin
  	select @isvalid = 'You are not a member! Please register!'
  	return -1000
  end
  
 -- update users_info set last_login_date = getdate() where operator_code=@p_operator_code 
 
 exec nb_txmm_jiami @p_users_code, @p_old_password, @password_a out
 select @password_aa = users_password from users_info where users_code = @p_users_code
 if @password_a != @password_aa
  begin
  	select @isvalid = 'Wrong old password.'
  	return -1010
  end

 exec nb_txmm_jiami @p_users_code, @p_new_password, @password_a out
 update users_info set users_password=@password_a where users_code = @p_users_code
 if @@rowcount = 0
  begin
  	select @isvalid = 'update failure, contact admin.'
  	return -1010
  end
 
 select @isvalid = 'Password change successful.'
 
 return 0
    
go    
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
----------------------------------------------------------------------
---------------modify company operator-----06.5.5 --------------------
------begin-----------------------------------------------------------
if (select count(*) from sysobjects where name='modify_company_operator') > 0
      drop proc modify_company_operator
   go
 create proc modify_company_operator
               @p_operator_code           char(65),    -- email address
               --@p_operator_password     char(25),
               @p_company_name            char(150),
               @p_company_description     char(253),
               @p_contact_person          char(100),
               @p_phone                   char(35),
               --@p_email_address         char(30),
               @p_region                  char(200),
               @p_address                 char(255),
               @p_postal_code             char(10),
               @p_cphone                  char(35),
               @p_city                    char(105),
               @p_fax                     char(35),
               @p_web_address             char(130),
               @p_business_classification char(150),
               @p_sub_classification      char(160),
               @p_sic_code                char(120),
               @p_employees_number        char(120),
               @p_annual_sales_volume     char(150),
               @p_location_type           char(150),
               --@p_password                char(25),
               @p_category_code           char(50),
               @isvalid                 nvarchar(255) output
          with encryption as

  declare @company_shortname char(65),
         @bc_code            char(20),
         @sbc_code           char(20),
         @en_code            char(20),
         @as_code            char(20),
         @lt_code            char(20),
         @ca_code            char(20)

	 select @bc_code=code  from industry_group      where type = @p_business_classification
	 select @sbc_code=code from industry_group      where sub_type = @p_sub_classification
	 select @en_code=code  from number_of_employees where type = @p_employees_number
	 select @as_code=code  from annual_sales_volume where type = @p_annual_sales_volume
	 select @lt_code=code  from location_type       where type = @p_location_type
	 select @ca_code=category_code from category_info       where category_name = @p_category_code

 if not exists ( select * from company_info where operator_code=@p_operator_code )
  begin
  	select @isvalid='email is not exist in our database.'
  	return -1100
  end

 SELECT @company_shortname = SubString(@p_company_name, 1, charindex(' ',@p_company_name)) --AS Word 

 update company_info
               set company_name=@p_company_name,
                   company_description=@p_company_description,
                   company_shortname=@company_shortname,
                   address=@p_address,
                   contact_person=@p_contact_person,
                   postal_code=@p_postal_code,
                   phone=@p_phone,
                   cphone=@p_cphone,
                   region=@p_region,
                   fax=@p_fax,
                   employees_number =@en_code,
                   city=@p_city,
                   business_classification = @bc_code,
                   sub_classification = @sbc_code,
                   sic_code = @p_sic_code,
                   annual_sales_volume = @as_code,
                   location_type = @lt_code ,
                   category_code = @ca_code ,
                   web_address=@p_web_address where operator_code=@p_operator_code
 if @@rowcount=0
   begin
      select @isvalid='Server can not process your request.'
      return -1200
   end
 
    
  return 0
 go       
------end-------------------------------------------------------------

----------------------------------------------------------------------
---------------select company info-----06.5.5 --------------------
------begin-----------------------------------------------------------
if (select count(*) from sysobjects where name='get_company_info') > 0
      drop proc get_company_info
   go

 create proc get_company_info
                @p_operator_code     char(65)
             with encryption as

  declare      @business_classification          char(60),
               @sub_classification               char(60),
               @employees_number                 char(50),
               @annual_sales_volume              char(50),
               @location_type                    char(60),
               @category_name                    char(50),
               @name                             char(65),
               @a                                int,
               @first_name char(50),
               @last_name char(50)
               --@region                char(100),
               --@address               char(255),
               --@postal_code           char(10),
               --@fax                   char(15),
               --@web_address           char(30)
 
	 select @business_classification = type from industry_group  where code in
	     (select business_classification from company_info where operator_code = @p_operator_code)
	 select @sub_classification = sub_type from industry_group  where code in
	     (select sub_classification from company_info where operator_code = @p_operator_code)
	 select @employees_number = type from number_of_employees  where code in
	     (select employees_number from company_info where operator_code = @p_operator_code)
	 select @annual_sales_volume = type from annual_sales_volume  where code in
	     (select annual_sales_volume from company_info where operator_code = @p_operator_code)
	 select @location_type = type from location_type   where code in
	     (select location_type from company_info where operator_code = @p_operator_code)
	 select @category_name = category_name from category_info   where category_code in
	     (select category_code from company_info where operator_code = @p_operator_code)
	     
  select @name=contact_person from company_info where operator_code=@p_operator_code
  select @a=0
  
		Declare @Position Integer
		Declare @End varchar(50)
		Declare @Substr nchar(50)
		
		Set @Position=1
		Set @Substr = employeeofferssa.Piece(@name, ',', @Position) 
		Set @End= ISNULL(@Substr,'')
		--truncate table ttbc
		 create table #offered_company
		  (
		   code  char(20)    not null,
		  )

		while @End <> ''
		BEGIN
			Set @Substr = employeeofferssa.Piece(@name, ',', @Position) 
			Set @End= ISNULL(@Substr,'')
			if @End<>''
				BEGIN
				   if @a=0 select @first_name = @Substr
				   if @a=1 select @last_name  = @Substr
				   select @a = @a + 1   
				   Set @Position =@Position+1
				END
		END
       select @business_classification as 'business_classification',
              @sub_classification as 'sub_classification',
              @employees_number as 'employees_number' ,
              @annual_sales_volume as 'annual_sales_volume',
              @location_type as 'location_type',
              @category_name as 'category_name',
              @first_name as 'first_name',
              @last_name as 'last_name',
                *  from company_info where operator_code=@p_operator_code
  
  return 0
 go       
------end-------------------------------------------------------------


----------------------------------------------------------------------
---------------Check company operator password-----06.5.5 ------------
------begin-----------------------------------------------------------
if (select count(*) from sysobjects where name='check_company_pwd' and type='P') > 0
      drop proc  check_company_pwd
   go

create proc check_company_pwd
               @p_operator_code        char(65),
               @p_operator_password    char(25),
               @isvalid                nvarchar(255)    output
          with encryption as
          
 declare   @password_a          nvarchar(25),
           @password_aa         nvarchar(25),
           @lasted_login_date   datetime

 if not exists ( select * from company_info where operator_code = @p_operator_code )
  begin
  	select @isvalid = 'You are not a member! Please register!'
  	return -1000
  end

 if exists ( select * from company_info where operator_code = @p_operator_code and status='In-Active' )
  begin
  	select @isvalid = 'Please wait for Administrator to confirm!'
  	return -1000
  end

 update company_info set last_login_date = getdate() where operator_code=@p_operator_code 

 exec nb_txmm_jiami @p_operator_code, @p_operator_password, @password_a out
 select @password_aa = operator_password from company_info where operator_code=@p_operator_code 
 if @password_a != @password_aa
  begin
  	select @isvalid = 'Access Denied. Your User Name or Password is Incorrect.'
  	return -1010
  end

 return 0
    
go    
-----end--------------------------------------------------------------

----------------------------------------------------------------------
--------------- company operator change password-----06.5.5 ------------
------begin-----------------------------------------------------------
if (select count(*) from sysobjects where name='change_password' and type='P') > 0
      drop proc  change_password
   go
   
create proc change_password
               @p_operator_code        char(65),
               @p_old_password         char(25),
               @p_new_password         char(25),
               @isvalid                nvarchar(255)    output
          with encryption as
          
 declare   @password_a          nvarchar(25),
           @password_aa         nvarchar(25),
           @lasted_login_date   datetime
           
 if not exists ( select * from company_info where operator_code = @p_operator_code )
  begin
  	select @isvalid = 'You are not a member! Please register!'
  	return -1000
  end
  
 if exists ( select * from company_info where status = 'In-Active' and operator_code = @p_operator_code )
  begin
  	select @isvalid = 'Please wait for Administrator to confirm!'
  	return -1000
  end
 
 update company_info set last_login_date = getdate() where operator_code=@p_operator_code 
 
 exec nb_txmm_jiami @p_operator_code, @p_old_password, @password_a out
 select @password_aa = operator_password from company_info where operator_code=@p_operator_code 
 if @password_a != @password_aa
  begin
  	select @isvalid = 'Wrong old password.'
  	return -1010
  end

 exec nb_txmm_jiami @p_operator_code, @p_new_password, @password_a out
 update company_info set operator_password=@password_a where operator_code=@p_operator_code 
 if @@rowcount = 0
  begin
  	select @isvalid = 'Password update error, contact admin.'
  	return -1010
  end
 
 select @isvalid = 'Password change successful.'
 
 return 0
    
go    
-----end--------------------------------------------------------------


----------------------------------------------------------------------
-----------encryption user password-----06.5.5 -----------------------
------begin-----------------------------------------------------------    
if exists (select * from sysobjects where name = 'nb_txmm_jiami')
   drop proc nb_txmm_jiami
go

create proc nb_txmm_jiami
--	 @p_bmjy varchar(20),
	 @p_gydm char(34),                  
	 @p_source varchar(25),            
	 @p_result varchar(25) out         
     with encryption as
  set nocount on
declare @bit1 varchar(80), @bit2 varchar(80), @bit3 varchar(20),
	 @key varchar(10),
	 @i int, @j int, @d tinyint,
	 @h1 tinyint, @h2 tinyint,
	 @c char(1)
--if (convert(int, @p_bmjy) % 3260777) != 3260776
--	return
select @p_source = ltrim(rtrim(@p_source))
select @p_source = right(char(61) + char(91) + char(62) + char(92) + char(63)
	+ char(93) + char(64) + char(94) + char(60) + char(95)
	+ @p_source, 10)
select @key = @p_gydm + @p_gydm + '99'
select @i = 1, @bit1 = null
while @i <= 10
   begin
      select @d = ascii(substring(@p_source, @i, 1)) ^ ascii(substring(@key, @i, 1))
      if @i = 1
      begin
         select @h1 = 237
         select @h2 = 222
      end
      else if @i = 2
      begin
         select @h1 = 88
         select @h2 = 125
      end
      else
      begin
         select @h1 = ascii(substring(@p_source, @i - 1, 1))
         select @h2 = ascii(substring(@p_source, @i - 2, 1))
      end
   select @d = (@d ^ @h1) ^ @h2
   select @j = 7
   while @j >= 0
   begin
      if (@d & power(2, @j)) > 0
         select @c = '1'
      else
         select @c = '0'
         if @bit1 is null
            select @bit1 = @c
         else
            select @bit1 = @bit1 + @c
            select @j = @j - 1
   end
   select @i = @i + 1
end
--  print @bit1
select @i = 1, @bit2 = null
while @i <= 16
begin
   select @j = 0
   while @j < 5
   begin
      select @c = substring(@bit1, @j * 16 + @i, 1)
      if @bit2 is null
         select @bit2 = @c
      else
         select @bit2 = @bit2 + @c
         select @j = @j + 1
   end
select @i = @i + 1
end
--  print @bit2
select @i = 0, @bit3 = null
while @i < 20
begin
   select @j = 0, @d = ascii('A')
   while @j < 4
   begin
      if substring(@bit2, @i * 4 + @j + 1, 1) = '1'
      select @d = @d + power(2, 3 - @j)
      select @j = @j + 1
   end
if @bit3 is null
   select @bit3 = char(@d)
else
   select @bit3 = @bit3 + char(@d)
   select @i = @i + 1
end
select @p_result = @bit3
--print @p_result
return 0

go
--------end-----------------------------------------------------------



---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if exists(select * from sysobjects where name='users_active')
 drop proc users_active
go

create proc users_active
		@p_usercode        varchar(35),
		@p_operator        varchar(35),
		@isvalid            varchar(100)    output
 	with encryption as

  update users_info set active_flag=1 where users_code = @p_usercode
  if @@rowcount=0
   begin
     select @isvalid = 'Error' 
     return -100
   end
      
   select @isvalid = 'Success.' 
      
  return 0
  
 go 
 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if exists(select * from sysobjects where name='users_deactive')
 drop proc users_deactive
go

create proc users_deactive
		@p_usercode        varchar(35),
		@p_operator        varchar(35),
		@isvalid            varchar(100)    output
 	with encryption as

  update users_info set active_flag=0 where users_code = @p_usercode
  if @@rowcount=0
   begin
     select @isvalid = 'Error' 
     return -100
   end
      
   select @isvalid = 'Success.' 
      
  return 0
  
 go 
 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if exists(select * from sysobjects where name='cancel_right')
 drop proc cancel_right
go

create proc cancel_right
		@p_cdid                  int,
		@p_czydm                 char(15),
		@isvalid            varchar(100)    output
 	with encryption as
  declare @cdmc varchar(50),@czyxm char(15)
  
  select @cdmc=cdmc from xt_cdk where cdid=@p_cdid
  select @czyxm=bmdm from users where name=@p_czydm
  
  if (select count(*) from czy_cdqxk where cdid=@p_cdid and czydm=@czyxm)<1
     begin
        select @isvalid = '"'+@p_czydm+'" "'+@cdmc+'"' 
        return -100
     end

  delete czy_cdqxk where cdid=@p_cdid and czydm=@czyxm
  if @@rowcount=0
   begin
     select @isvalid = '"'+@p_czydm+'"ɾ��"'+@cdmc+'"Ȩ��ʧ��!' 
     return -100
   end
   
  select @isvalid = '"'+@p_czydm+'"ɾ��"'+@cdmc+'"Ȩ��ʧ��!' 
  
  return 0
  
 go 
 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if exists(select * from sysobjects where name='select_right')
 drop proc select_right
go

create proc select_right
		@p_czydm            char(9)
 	with encryption as
  declare @cdmc varchar(50),@czyxm char(15),@cdid int,@czydm char(6),@czydma char(9)
  
  create table #czy_cdk
  (
     cdid            int             not null , 
     cdmc            varchar(50)     not null , 
     qxid            int             not null , 
     czydm           char(4)         default 'no' ,
     czyxm           char(15)        default 'no czy' ,
  )

  insert into #czy_cdk(cdid,cdmc,qxid) 
           select cdid,cdmc,qxid from xt_cdk
  
  select @czydma=bmdm from users where name=@p_czydm
--  select @czydma,@p_czydm
  if (@czydma <> '')
  begin
    declare cdk_cursor cursor for select cdid,czydm,czyxm from czy_cdqxk where czydm=@czydma
    open cdk_cursor
    fetch cdk_cursor into @cdid,@czydm,@czyxm
    while @@fetch_status=0
     begin
       update #czy_cdk 
                set czydm=@czydm,czyxm=@czyxm where cdid=@cdid 
       fetch cdk_cursor into @cdid,@czydm,@czyxm
     end
    close cdk_cursor
    deallocate cdk_cursor
  end

  select * from #czy_cdk

  return 0
 go 
 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

--Nov 02, 2009
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
if exists(select * from sysobjects where name='update_client_partial')
		drop proc update_client_partial
	go

		create proc update_client_partial @p_Cname_code varchar(35),
		                                  @p_Cname      varchar(100),
		                                  @p_Contact    varchar(150),
		                                  @p_Tel        varchar(65),
		                                  @p_usercode   varchar(35),
		                                  @isvalid      varchar(250) output
		                                  as
		update erpclient set cname=@p_Cname,
		                     contact = @p_Contact,
		                     tel=@p_Tel
		                 where cname_code=@p_Cname_code and operator = @p_usercode
	 if @@rowcount = 0
		 begin
		 	select @isvalid =  'Update Failed. Contact Admin.'
		 	return -102
		 end

	 select @isvalid = 'Success.'

	 return 0

	 go
