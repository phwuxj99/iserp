-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
    ALTER PROCEDURE GetSupplySorted
--CREATE PROCEDURE GetSupplySorted as
 ( 
  @sortExpression nvarchar(100),
  @sortDirection  varchar(15),
  @startRowIndex int, 
  @maximumRows int ,
  @p_cname_code varchar(35),
  @p_usercode   varchar(35),
  @rowcount int output
 ) 
 AS 
 -- Make sure a @sortExpression is specified 
 IF LEN(@sortExpression) = 0 or @sortExpression is null
    SET @sortExpression = 'cname_code'
-- select @maximumRows = @maximumRows+1
 if @startRowIndex>1
    select @startRowIndex=(@startRowIndex-1)*@maximumRows+1
 select @rowcount=COUNT(*) from erpsupply where lower(cname_code) like '%'+lower(rtrim(@p_cname_code))+'%'
  -- Issue query 
  declare @sql nvarchar(4000)
   set @sql='select a.id_num,a.contact,a.cname,a.cname_code,a.tel,a.fax,a.email,a.website,a.address,a.city,a.state,a.country,a.postcode
                      from (select id_num,contact,cname,cname_code,tel,fax,email,website,address,city,state,country,postcode,
                      				ROW_NUMBER() OVER(ORDER BY '+@sortExpression+' '+rtrim(@sortDirection)+') as rowrank
                      				from erpsupply
                      				where lower(cname_code) like ''%''+'''+lower(rtrim(@p_cname_code))+'''+''%''  and operator = '''+rtrim(@p_usercode)+'''
                      			) as a
                          where  a.rowrank >='+convert(nvarchar(10),@startRowIndex)+' and
                                 a.rowrank <('+convert(nvarchar(10),@startRowIndex)+' + '+
                               convert(nvarchar(10),@maximumRows)+')'
---   set @sql='select a.id_num,a.bom_no,a.bom_name,a.bom_description,a.bom_level,a.drawing_no,a.client_no,a.category,
--       a.unit,a.dimension,a.package_no  
--                      from (select  id_num,bom_no,bom_name,bom_description,bom_level,drawing_no,client_no,category,
--                                   unit,dimension,package_no,ROW_NUMBER() OVER(ORDER BY '+@sortExpression+' '+rtrim(@sortDirection)+') as rowrank
--                           from bom_title
--                         where lower(bom_no) like ''%''+'''+lower(rtrim(@p_bomno))+'''+''%'' ) as a
--                          where  a.rowrank >='+convert(nvarchar(10),@startRowIndex)+' and
--                                 a.rowrank <('+convert(nvarchar(10),@startRowIndex)+' + '+
--                               convert(nvarchar(10),@maximumRows)+')'
--print @sql
  EXEC sp_executesql @sql
  
go


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='add_erpsupply')
		drop proc add_erpsupply
	go

	create proc add_erpsupply  @p_company_code  char(35),
	                               @p_company_name  char(150),
					                       @p_contact       char(85),
					                       @p_phone_number  char(65),
					                       @p_fax_number    char(65),
					                       @p_address       char(150),
					                       @p_city          char(120),
					                       @p_zipcode       char(10),
					                       @p_country       char(65),
					                       @p_region        char(85),
					                       @p_email         char(85),
					                       @p_website       char(150),
					                       @p_usercode   varchar(35),
					                       @p_notes         varchar(500),
					                       @isvalid         char(253)    output
	               with encryption as

  declare @locationID int,@countryID int
  
  select @locationID = id_num from location_region where region = @p_region and flag = 1
  select @countryID = id_num from location_region where country = @p_country and flag = 0
  
  
  if exists(select * from erpsupply where lower(cname_code)=lower(rtrim(@p_company_code)) and operator = @p_usercode)
			 begin
			 	select @isvalid =  'Error: Double Input. Contact Admin.'
			 	return -102
			 end

  insert erpsupply(cname,cname_code,contact,tel,fax,email,website,address,city,state,country,postcode,notes,operator,locationID,countryID)
            values(@p_company_name,upper(@p_company_code),@p_contact,@p_phone_number,@p_fax_number,@p_email,@p_website,
                             @p_address,@p_city,@p_region,@p_country,@p_zipcode,@p_notes,@p_usercode,@locationID,@countryID)
		 if @@rowcount = 0
			 begin
			 	select @isvalid =  'Insert Error!  Contact Admin.'
			 	return -102
			 end

   select @isvalid =  'Insert successfully!'

 return 0

 go
 
 
--July 19, 2009
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
if exists(select * from sysobjects where name='update_supply_all')
		drop proc update_supply_all
	go
	
	create proc update_supply_all @p_Cname_code varchar(35),
	                              @p_Cname      varchar(100),
	                              @p_Contact    varchar(150),
	                              @p_Tel        varchar(65),
	                              @p_Fax        varchar(65),
	                              @p_Cell       varchar(65),
	                              @p_Address    varchar(150),
	                              @p_City       varchar(120),
	                              @p_State      varchar(100),
	                              @p_Country    varchar(85),
	                              @p_Postcode   varchar(15),
	                              @p_Email      varchar(85),
	                              @p_Website    varchar(150),
	                              @p_usercode   varchar(35),
	                              @p_Notes      text,
	                              @isvalid      varchar(250) output
	                       as
	                       
  declare @locationID int,@countryID int
  
  select @locationID = id_num from location_region where region = @p_State and flag = 1
  select @countryID = id_num from location_region where country = @p_country and flag = 0

  update erpsupply set cname=@p_Cname,		                   
		                   contact = @p_Contact,
		                   tel=@p_Tel,
		                   fax=@p_Fax   ,     
	                     address=@p_Address    ,
	                     city=@p_City       ,
	                     locationID = @locationID,
	                     state=@p_State      ,
	                     countryID = @countryID,
	                     country=@p_Country   , 
	                     postcode=@p_Postcode   ,
	                     email=@p_Email      ,
	                     website=@p_Website    ,
	                     notes=@p_Notes      
		                 where cname_code=@p_Cname_code and operator = @p_usercode
	 if @@rowcount = 0
		 begin
		 	select @isvalid =  'Update Failed. Contact Admin.'
		 	return -102
		 end      
	
	 select @isvalid = 'Success.'	                     
	 
	 return 0
	 
	 go                              

--July 19, 2009
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
if exists(select * from sysobjects where name='update_supply_partial')
		drop proc update_supply_partial
	go
		
		create proc update_supply_partial @p_Cname_code varchar(35),
		                                  @p_Cname      varchar(100),
		                                  @p_Contact    varchar(150),
		                                  @p_Tel        varchar(65),
		                                  @p_usercode   varchar(35),
		                                  @isvalid      varchar(250) output
		                                  as
		update erpsupply set cname=@p_Cname,
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