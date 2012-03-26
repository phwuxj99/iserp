
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='add_erpclient')
		drop proc add_erpclient
	go

	create proc add_erpclient  @p_company_code  nvarchar(35),
	                               @p_company_name  nvarchar(150),
					                       @p_contact       nvarchar(85),
					                       @p_phone_number  nvarchar(65),
					                       @p_fax_number    nvarchar(65),
					                       @p_address       nvarchar(150),
					                       @p_city          nvarchar(120),
					                       @p_zipcode       nvarchar(10),
					                       @p_country       nvarchar(65),
					                       @p_region        nvarchar(85),
										   @p_invoice_tax   int,
					                       @p_email         nvarchar(85),
					                       @p_website       nvarchar(150),
					                       @p_usercode   nvarchar(35),
					                       @p_notes         nvarchar(500),
					                       @isvalid         nvarchar(253)    output
	               with encryption as

  declare @locationID int,@countryID int
  
  select @locationID = id_num from location_region where region = @p_region and flag = 1
  select @countryID = id_num from location_region where country = @p_country and flag = 0

  if exists(select * from erpclient where lower(cname_code)=lower(rtrim(@p_company_code)) and operator = @p_usercode)
			 begin
			 	select @isvalid =  'Error: Duplicate Client Code. Contact Admin.'
			 	return -102
			 end

  if exists(select * from erpclient where lower(cname)=lower(rtrim(@p_company_name)) and operator = @p_usercode)
			 begin
			 	select @isvalid =  'Error: Duplicate Client Name. Contact Admin.'
			 	return -102
			 end

  insert erpclient(cname,cname_code,contact,tel,fax,email,website,address,city,state,country,postcode,notes,operator,locationID,countryID,invoice_tax)
            values(@p_company_name,upper(@p_company_code),@p_contact,@p_phone_number,@p_fax_number,@p_email,@p_website,
                             @p_address,@p_city,@p_region,@p_country,@p_zipcode,@p_notes,@p_usercode,@locationID,@countryID,@p_invoice_tax)
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
if exists(select * from sysobjects where name='update_client_all')
		drop proc update_client_all
	go

	create proc update_client_all @p_Cname_code nvarchar(35),
	                              @p_Cname      nvarchar(100),
	                              @p_Contact    nvarchar(150),
	                              @p_Tel        nvarchar(65),
	                              @p_Fax        nvarchar(65),
	                              @p_Cell       nvarchar(65),
	                              @p_Address    nvarchar(150),
	                              @p_City       nvarchar(120),
	                              @p_StateID      nvarchar(100),
	                              @p_CountryID    nvarchar(85),
	                              @p_Postcode   nvarchar(15),
	                              @p_Email      nvarchar(85),
						   	      @p_invoice_tax   int,
	                              @p_Website    nvarchar(150),
	                              @p_usercode   nvarchar(35),
	                              @p_Notes      ntext,
	                              @isvalid      nvarchar(250) output
	                       as

  declare @State nvarchar(100),@country nvarchar(85)
  
   select @State = region from location_region where id_num = @p_StateID 
   select @country = country from location_region where id_num = @p_countryID

  update erpclient set cname=rtrim(@p_Cname),
		                 contact = rtrim(@p_Contact),
		                 tel=rtrim(@p_Tel),
		                 fax=rtrim(@p_Fax),
	                     address=rtrim(@p_Address),
	                     city=rtrim(@p_City),
	                     locationID = @p_StateID ,
	                     state=@State      ,
	                     countryID = @p_countryID,
	                     country=rtrim(@country),
	                     postcode=rtrim(@p_Postcode),
	                     email=rtrim(@p_Email),
						 invoice_tax = @p_invoice_tax,
	                     website=rtrim(@p_Website),
	                     notes=@p_Notes
		                 where cname_code=@p_Cname_code and operator = @p_usercode
	 if @@rowcount = 0
		 begin
		 	select @isvalid =  'Update Failed. Contact Admin.'
		 	return -102
		 end      

	 select @isvalid = 'Success.'	                     

	 return 0

	 