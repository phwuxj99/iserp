----------------------------------------------------------------------
---------------User Register-----Oct 04, 2009 -----------------------
------begin-----------------------------------------------------------
if (select count(*) from sysobjects where name='user_register' and type='P') > 0
      drop proc  user_register
   go
   
create proc user_register
               @p_users_code           nvarchar(15),    -- email address
			   @p_users_id             int,
               @p_users_name           nvarchar(105),
               @p_email                nvarchar(65),
               @p_password             nvarchar(25),
               @p_country              nvarchar(65),
               @p_region               nvarchar(100),
               @p_city                 nvarchar(55),
               @p_company_name         nvarchar(55),
               @p_company_phone        nvarchar(35),               
               @isvalid                nvarchar(255) output
          with encryption as
 

 declare @user_password nvarchar(25)
 
 if exists ( select * from users_info where users_code=@p_users_code )
  begin
  	select @isvalid='User Exists.'
  	return -1100
  end

 if exists ( select * from users_info where Entity_id=@p_users_id )
  begin
  	select @isvalid='Entity ID Exists.'
  	return -1100
  end

 if exists ( select * from users_info where email=@p_email )
  begin
  	select @isvalid='Email Exists.'
  	return -1100
  end

-- exec nb_txmm_jiami @p_users_code, @p_password, @user_password out

 insert users_info(users_code,users_name,email,users_password,city,region,country,company_name,company_phone,register_date,distributor,dealer,location,Entity_id)
    values(@p_users_code,@p_users_name,@p_email,@p_password,@p_city,@p_region,@p_country,@p_company_name,@p_company_phone,getdate(),0,0,@p_users_id,@p_users_id)
 if @@rowcount=0
   begin
      select @isvalid='Server can not process your request.'
      return -1200
   end

  select @isvalid='Success!'

 return 0

go 


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if (select count(*) from sysobjects where name='user_update' and type='P') > 0
      drop proc  user_update
   go
   
create proc user_update
               @p_users_code           nvarchar(15),    -- email address
			   @p_users_id             int,
               @p_users_name           nvarchar(105),
               @p_email                nvarchar(65),
               @p_country              nvarchar(65),
               @p_region               nvarchar(100),
               @p_city                 nvarchar(55),
               @p_company_name         nvarchar(55),
               @p_company_phone        nvarchar(35), 
               @p_invoice_name         nvarchar(253),
 			   @p_invoice_address      nvarchar(253),
               @p_invoice_phone		   nvarchar(253),   
			   @p_invoice_tax		   int,   
               @isvalid                nvarchar(255) output
          with encryption as
 

 declare @user_password nvarchar(25)
 
 if not exists ( select * from users_info where users_code=@p_users_code )
  begin
  	select @isvalid='No Such User.'
  	return -1100
  end

  update users_info set  users_name=@p_users_name,email=@p_email,city=@p_city,region=@p_region,country=@p_country,
               company_name=@p_company_name,company_phone=@p_company_phone,
			   -- distributor,dealer,
			   location=@p_users_id,Entity_id=@p_users_id,
			   invoice_name        =   @p_invoice_name      ,
			   invoice_address     =   @p_invoice_address   ,
			   invoice_phone       =   @p_invoice_phone		,
			   invoice_tax         =   @p_invoice_tax
                        where users_code=@p_users_code
 if @@rowcount=0
   begin
      select @isvalid='Server can not process your request.'
      return -1200
   end

  select @isvalid='Success!'

 return 0

go 


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if exists(select * from sysobjects where name='user_setmenu')
 drop proc user_setmenu
go

create proc user_setmenu
		@p_usercode         nvarchar(35),
		@isvalid            nvarchar(100)    output
 	with encryption as
  
  declare @users_entity int
  
  select @users_entity = Entity_id from users_info where users_code=@p_usercode 
  
  delete  user_menu where users_code=@p_usercode 
  
  insert into user_menu(users_code,users_entity,menu_id,menu_name,menu_description,url,partent_id)
  select @p_usercode,@users_entity,[MenuID],[Text],[Description],[Url],[ParentID] from [Menu] where [MenuID]<16
            
   select @isvalid = 'Success!' 
   
  return 0
  
 go 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------



---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if exists(select * from sysobjects where name='user_setmenuAll')
 drop proc user_setmenuAll
go

create proc user_setmenuAll
		@p_usercode         nvarchar(35),
		@isvalid            nvarchar(100)    output
 	with encryption as
  
  declare @users_entity int
  
  select @users_entity = Entity_id from users_info where users_code=@p_usercode 
  
  delete  user_menu where users_code=@p_usercode 
  
  insert into user_menu(users_code,users_entity,menu_id,menu_name,menu_description,url,partent_id)
  select @p_usercode,@users_entity,[MenuID],[Text],[Description],[Url],[ParentID] from [Menu]
  
   select @isvalid = 'Success!' 
   
  return 0
  
 go 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------


----------------------------------------------------------------------
----------------------------------------------------------------------
if (select count(*) from sysobjects where name='user_getmenu' and type='P') > 0
      drop proc  user_getmenu
   go

create proc user_getmenu
               @p_users_code           nvarchar(15)    -- email address

          with encryption as

SELECT s.MenuID,s.Text,'' as menu_name,u.users_code,case  when  s.ParentID is null then 'Menu' else 'SubMenu'  end  FROM [Menu] s 
   left outer join (select menu_id,users_code,menu_name from user_menu where users_code=@p_users_code) u on s.MenuID= u.menu_id 
   where s.ParentID is null
   
go


----------------------------------------------------------------------
----------------------------------------------------------------------
if (select count(*) from sysobjects where name='user_getsubmenu' and type='P') > 0
      drop proc  user_getsubmenu
   go

create proc user_getsubmenu
               @p_users_code           nvarchar(15),    -- email address
               @p_menuID               nvarchar(10)

          with encryption as

   SELECT 
	   s.MenuID,
	   s.Text,
	   s.ParentID,
	   s.Description,
	   case when u.users_code is null then 0 else 1 end as 'menu_name',
	   ISNULL( u.users_code,0) as 'users_code',
	   case  when  s.ParentID>1 then 'SubMenu' else 'Menu'  end     
   FROM [Menu] s 
      left outer join (select menu_id,users_code,menu_name from user_menu where users_code=@p_users_code) u on s.MenuID= u.menu_id 
      where s.ParentID=@p_menuID
   
go
 
 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if exists(select * from sysobjects where name='user_setmenuSingle')
 drop proc user_setmenuSingle
go

create proc user_setmenuSingle
		@p_menuID           nvarchar(10),
		@p_usercode         nvarchar(35),
		@p_Status           int,
		@isvalid            nvarchar(100)    output
 	with encryption as
  
  declare @parentID nvarchar(10)
  
  declare @users_entity int
  
  select @users_entity = Entity_id from users_info where users_code=@p_usercode 
  
	select @parentID=ParentID from [Menu] where MenuID=@p_menuID
  -- select @parentID=Parent from SiteMap where ID=@p_menuID
  if @p_Status=1
	  begin
		  if not exists(select * from user_menu where users_code=@p_usercode and menu_id=@p_menuID)
			 begin
			 
			    if not exists(select * from user_menu where users_code=@p_usercode and menu_id=@parentID)
				begin
				insert into user_menu(users_code,users_entity,menu_id,menu_name,menu_description,url,partent_id)
                  select @p_usercode,@users_entity,[MenuID],[Text],[Description],[Url],[ParentID] from [Menu] where MenuID=@ParentID
				end
				
			    insert into user_menu(users_code,users_entity,menu_id,menu_name,menu_description,url,partent_id)
                  select @p_usercode,@users_entity,[MenuID],[Text],[Description],[Url],[ParentID] from [Menu] where MenuID=@p_menuID

				--  insert user_menu(users_code,menu_id) values(@p_usercode,@p_menuID)
						  if @@rowcount=0
						   begin
							 select @isvalid = '"'+@p_usercode+'" set the "'+@p_menuID+' Error"' 
							 return -100
						   end
			 end   
	   end
   else if @p_Status=0
	  begin		  
		  if exists(select * from user_menu where users_code=@p_usercode and menu_id=@p_menuID)
			 begin
				delete user_menu where users_code=@p_usercode and menu_id=@p_menuID
						  if @@rowcount=0
						   begin
							 select @isvalid = '"'+@p_usercode+'" set the "'+@p_menuID+' Error"' 
							 return -100
						   end
						   
				if not exists(select * from user_menu where users_code=@p_usercode and partent_id=@parentID)
                    delete 	user_menu where users_code=@p_usercode and menu_id=@parentID			
			 end   
		end   
   select @isvalid = 'Success!' 
   
  return 0
  
 go 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------



---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
if exists(select * from sysobjects where name='user_setmenuParent')
 drop proc user_setmenuParent
go

create proc user_setmenuParent
		@p_usercode         nvarchar(35),
		@p_ParentID         int,
		@p_Status           int,
		@isvalid            nvarchar(100)    output
 	with encryption as
  
  declare @users_entity int
  declare @parentID nvarchar(10)
  
  select @users_entity = Entity_id from users_info where users_code=@p_usercode 
  
  delete user_menu where partent_id=@p_ParentID and users_code=@p_usercode 
  delete user_menu where menu_id=@p_ParentID and users_code=@p_usercode 
 
 if @p_Status=1
	 begin
		  insert into user_menu(users_code,users_entity,menu_id,menu_name,menu_description,url,partent_id)
			 select @p_usercode,@users_entity,[MenuID],[Text],[Description],[Url],[ParentID] from [Menu] where MenuID=@p_ParentID		
					
		  insert into user_menu(users_code,users_entity,menu_id,menu_name,menu_description,url,partent_id)
			 select @p_usercode,@users_entity,[MenuID],[Text],[Description],[Url],[ParentID] from [Menu] where ParentID=@p_ParentID
	  end
  
   select @isvalid = 'Success!' 
   
  return 0
  
 go 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

