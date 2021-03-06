--use erp
--go

-------------------------------------------------------------
-------------------------------------------------------------
if exists(select * from sysobjects where name='whreceipt_input')
		drop proc whreceipt_input
	go
	
	create proc whreceipt_input @p_whreceipt_no 	varchar(35),
	                       @p_part_no				varchar(35),
	                       @p_quantity       int,
	                       @p_supplier_code  varchar(35),
	                       @p_order_no       varchar(35),
	                       @p_podate         varchar(15),
	                       @p_usercode   varchar(35),
	                       @isvalid             char(253)    output
	                with encryption as
	
	insert wh_receipt(whre_no,part_no,qty,supplier_code,order_no,podate,op_date,operator)	
				values(@p_whreceipt_no,@p_part_no,@p_quantity,@p_supplier_code,@p_order_no,@p_podate,getdate(),@p_usercode)
	 if @@rowcount = 0
	 begin
	 	select @isvalid =  'Parts '+@p_part_no+' insert error. Contact Admin.'
	 	return -102
	 end      

	 	select @isvalid =  'Parts '+@p_part_no+' inserted sucessfully .'

 return 0

 go

-------------------------------------------------------------
-------------------------------------------------------------
if exists(select * from sysobjects where name='whreceipt_delSingle')
		drop proc whreceipt_delSingle
	go
	
	create proc whreceipt_delSingle @p_id_num	 int,
	                                @p_usercode   varchar(35),
	                                @isvalid             char(253)    output
	                with encryption as
	delete wh_receipt where id_num=@p_id_num	 and operator = @p_usercode                
	if @@rowcount = 0
	 begin
	 	select @isvalid =  'Delete error. Contact Admin.'
	 	return -102
	 end

	 	select @isvalid =  'Delete sucessfully .'

 return 0

 go

---------------------------------------------------------------------
---------------------------------------------------------------------
if exists(select * from sysobjects where name='whreceipt_ChangeFlag')
		drop proc whreceipt_ChangeFlag
	go
	
	create proc whreceipt_ChangeFlag @p_whre_no	 VARCHAR(35),
	                                 @p_usercode   varchar(35),
	                                 @isvalid    VARCHAR(253)    OUTPUT
	                WITH ENCRYPTION AS
	UPDATE wh_receipt SET flag='Confirmed' WHERE whre_no = @p_whre_no and operator = @p_usercode
	if @@rowcount = 0
	 begin
	 	SELECT @isvalid =  'UPDATE ERROR. Contact Admin.'
	 	return -102
	 end

	SELECT @isvalid =  'UPDATE SUCCESSFULLY .'

 return 0

 go


----SQL 2005
-------------------------------------------------------------
-------------------------------------------------------------
if exists(select * from sysobjects where name='AddInventory') 
		drop proc AddInventory
	go
	
	create proc AddInventory @p_whre_no varchar(35),
	                         @p_wh_flag char(5),
	                         @p_usercode   varchar(35),
	                         @isvalid   varchar(255)
	                 with encryption as
	
	--DECLARE @TransactionName varchar(20) = 'Transaction1'
	DECLARE @col_count int

  BEGIN TRAN Transaction1

	if @p_wh_flag = 'YES'
		begin
		   select @col_count=count(*)
	   		   from wh_receipt where whre_no = @p_whre_no
		   insert into warehouse(part_no,qty,operator)
	   		select part_no,qty,@p_usercode
	   		   from wh_receipt where whre_no = @p_whre_no and operator=@p_usercode
	   		 if @@rowcount<@col_count
	   		 begin
	   		 		rollback TRAN Transaction1
						select @isvalid='Insert warehouse failed.'
						return -100
	   		 end
	   		 
		   update wh_receipt set flag='afinished' where   whre_no = @p_whre_no and operator=@p_usercode
	   		 if @@rowcount<0
	   		 begin
	   		 		rollback TRAN Transaction1
						select @isvalid='Update FLAG failed.'
						return -100
	   		 end	
	   		 
	  -- 	 update warehouse set brand=b.brand,series = b.series, model = b.model 
		--      from warehouse a, partno b where a.part_no = b.part_no
		--       and a.part_no in (select part_no
	  -- 		   from wh_receipt where whre_no = @p_whre_no and operator=@p_usercode)
	 	   
		end	   	   
	else if @p_wh_flag = 'NO'
		begin
			select part_no,sum(qty) as qty into #tmp_whreno
			   from wh_receipt where whre_no=@p_whre_no and operator=@p_usercode
			   group by part_no
			
			update warehouse set a.qty = a.qty + b.qty
				from warehouse a , #tmp_whreno b where a.part_no=b.part_no and a.flag='NO' and a.operator=@p_usercode
	   		 if @@rowcount<0
	   		 begin
	   		 		rollback TRAN Transaction1
						select @isvalid='Update warehouse failed.'
						return -100
	   		 end		   
		   
		   update wh_receipt set flag='afinished' where   whre_no = @p_whre_no and operator=@p_usercode
	   		 if @@rowcount<0
	   		 begin
	   		 		rollback TRAN Transaction1
						select @isvalid='Update FLAG failed.'
						return -100
	   		 end	
	   		 	   
	   --	 update warehouse set brand=b.brand,series = b.series, model = b.model 
		 --     from warehouse a, partno b where a.part_no = b.part_no
		 --      and a.part_no in (select part_no
	   --		   from wh_receipt where whre_no = @p_whre_no and operator=@p_usercode)

		end
	
	 	select @isvalid =  'Delete sucessfully .'
	 	
	 	COMMIT TRANSACTION  Transaction1

	go
	
/*
--------SQL 2008
-------------------------------------------------------------
-------------------------------------------------------------
if exists(select * from sysobjects where name='AddInventory') 
		drop proc AddInventory
	go
	
	create proc AddInventory @p_whre_no varchar(35),
	                         @p_wh_flag char(5),
	                         @isvalid   varchar(255)
	                 with encryption as
	
	DECLARE @TransactionName varchar(20) = 'Transaction1'
	DECLARE @col_count int

  BEGIN TRAN @TransactionName

	if @p_wh_flag = 'YES'
		begin
		   select @col_count=count(*)
	   		   from wh_receipt where whre_no = @p_whre_no
		   insert into warehouse(part_no,receipt_no,receipt_id,supplier,podate,qty,flag)
	   		select part_no,whre_no,id_num,supplier_code,podate,qty,@p_wh_flag
	   		   from wh_receipt where whre_no = @p_whre_no
	   		 if @@rowcount<@col_count
	   		 begin
	   		 		rollback TRAN @TransactionName
						select @isvalid='Insert warehouse failed.'
						return -100
	   		 end
	   		 
		   update wh_receipt set flag='afinished' where   whre_no = @p_whre_no
	   		 if @@rowcount<0
	   		 begin
	   		 		rollback TRAN @TransactionName
						select @isvalid='Update FLAG failed.'
						return -100
	   		 end		   
		end	   	   
	else if @p_wh_flag = 'NO'
		begin
			select part_no,sum(qty) as qty into #tmp_whreno
			   from wh_receipt where whre_no=@p_whre_no
			   group by part_no
			
			update warehouse set a.qty = a.qty + b.qty
				from warehouse a , #tmp_whreno b where a.part_no=b.part_no and a.flag='NO'
	   		 if @@rowcount<0
	   		 begin
	   		 		rollback TRAN @TransactionName
						select @isvalid='Update warehouse failed.'
						return -100
	   		 end		   
		   
		   update wh_receipt set flag='afinished' where   whre_no = @p_whre_no
	   		 if @@rowcount<0
	   		 begin
	   		 		rollback TRAN @TransactionName
						select @isvalid='Update FLAG failed.'
						return -100
	   		 end		   
		end
	
	 	select @isvalid =  'Delete sucessfully .'
	 	
	 	COMMIT TRANSACTION  @TransactionName

	go
	*/

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
    ALTER PROCEDURE GetWhReceiptSorted
--CREATE PROCEDURE GetWhReceiptSorted as
 ( 
  @sortExpression nvarchar(100),
  @sortDirection  varchar(15),
  @startRowIndex int, 
  @maximumRows int ,
  @p_whre_no varchar(35),
  @p_BeginDate varchar(15),
  @p_EndDate   varchar(15),
  @p_usercode   varchar(35),
  @rowcount int output
 ) 
 AS 
 -- Make sure a @sortExpression is specified 
 IF LEN(@sortExpression) = 0 or @sortExpression is null
    SET @sortExpression = 'whre_no'
-- select @maximumRows = @maximumRows+1
 if @startRowIndex>1
    select @startRowIndex=(@startRowIndex-1)*@maximumRows+1
    
  select whre_no,podate into #warehouse_re from wh_receipt
                      				where lower(whre_no) like '%'+lower(rtrim(@p_whre_no))+'%' and
                      				      DateAdd(day, datediff(day,0, podate), 0) > @p_BeginDate and
                      				      DateAdd(day, datediff(day,0, podate), 0) < @p_EndDate and
                      				       operator=@p_usercode and
                      				      flag is null
                      				      
 select @rowcount=COUNT(*) from wh_receipt where lower(whre_no) like '%'+lower(rtrim(@p_whre_no))+'%' and operator = rtrim(@p_usercode)
  -- Issue query 
  declare @sql nvarchar(4000)
   set @sql='select a.whre_no,a.podate
                      from (select whre_no, podate,
                      				ROW_NUMBER() OVER(ORDER BY '+rtrim(@sortExpression)+' '+rtrim(@sortDirection)+') as rowrank
                      				from (select whre_no,max(podate) as podate from #warehouse_re group by whre_no) abc
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
  /*
  declare @p8 int
set @p8=6
declare @p9 int
set @p9=0
exec sp_executesql N'EXEC @RETURN_VALUE = [GetWhReceiptSorted] @sortExpression = @p0, @sortDirection = @p1, @startRowIndex = @p2, @maximumRows = @p3, @p_whre_no = @p4,@p_BeginDate=@p6,@p_EndDate=@p7, @rowcount = @p5 OUTPUT',
N'@p0 nvarchar(4000),@p1 varchar(4),@p2 int,@p3 int,@p4 varchar(8000),@p6 varchar(15),@p7 varchar(15) ,@p5 int output,@RETURN_VALUE int output',
@p0=NULL,@p1='desc',@p2=1,@p3=10,@p4='',@p6='2009/02/01',@p7='2009/05/01',@p5=@p8 output,@RETURN_VALUE=@p9 output
select @p8, @p9
  */
  
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
      ALTER PROCEDURE GetWhReceiptSortedConfirmed
--CREATE PROCEDURE GetWhReceiptSortedConfirmed as
 ( 
  @sortExpression nvarchar(100),
  @sortDirection  varchar(15),
  @startRowIndex int, 
  @maximumRows int ,
  @p_whre_no varchar(35),
  @p_BeginDate varchar(15),
  @p_EndDate   varchar(15),
  @p_usercode   varchar(35),
  @rowcount int output
 ) 
 AS 
 -- Make sure a @sortExpression is specified 
 IF LEN(@sortExpression) = 0 or @sortExpression is null
    SET @sortExpression = 'whre_no'
-- select @maximumRows = @maximumRows+1
 if @startRowIndex>1
    select @startRowIndex=(@startRowIndex-1)*@maximumRows+1
    
  select whre_no,podate into #warehouse_re from wh_receipt
                      				where lower(whre_no) like '%'+lower(rtrim(@p_whre_no))+'%' and
                      				      DateAdd(day, datediff(day,0, podate), 0) > @p_BeginDate and
                      				      DateAdd(day, datediff(day,0, podate), 0) < @p_EndDate and
                      				       operator = rtrim(@p_usercode) and
                      				      flag=1
                      				      
 select @rowcount=COUNT(*) from wh_receipt where lower(whre_no) like '%'+lower(rtrim(@p_whre_no))+'%' and operator = rtrim(@p_usercode)
  -- Issue query 
  declare @sql nvarchar(4000)
   set @sql='select a.whre_no,a.podate
                      from (select whre_no, podate,
                      				ROW_NUMBER() OVER(ORDER BY '+rtrim(@sortExpression)+' '+rtrim(@sortDirection)+') as rowrank
                      				from (select whre_no,max(podate) as podate from #warehouse_re group by whre_no) abc
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

/*
declare @p11 int
set @p11=NULL
declare @p12 int
set @p12=NULL
exec sp_executesql N'EXEC @RETURN_VALUE = [GetWhReceiptSortedConfirmed] @sortExpression = @p0, @sortDirection = @p1, @startRowIndex = @p2, @maximumRows = @p3, @p_whre_no = @p4, @p_BeginDate = @p5, @p_EndDate = @p6, @p_usercode = @p7, @rowcount = @p8 OUTPUT',N'@p0 nvarchar(4000),@p1 varchar(4),@p2 int,@p3 int,@p4 varchar(1),@p5 varchar(10),@p6 varchar(10),@p7 varchar(12),@p8 int output,@RETURN_VALUE int output',@p0=NULL,@p1='desc',@p2=0,@p3=20,@p4='%',@p5='2009/10/26',@p6='2009/11/25',@p7='infocccadmin',@p8=@p11 output,@RETURN_VALUE=@p12 output
select @p11, @p12

*/
-------------------------------------------------------------
-------------------------------------------------------------

if exists (select * from sysobjects where name='Update_wh_recept_name')
		drop proc Update_wh_recept_name
	go
	
	create proc Update_wh_recept_name @p_OldName varchar(35),
	                                  @p_NewName varchar(35),
	                                  @p_InputDate varchar(10),
	                                  @p_usercode   varchar(35),
	                                  @isvalid varchar(250) output
	           as
	
	update wh_receipt set whre_no= @p_NewName,
	                      podate = @p_InputDate
	                    where whre_no = @p_OldName and operator = @p_usercode
	   		 if @@rowcount<0
	   		 begin
						select @isvalid='Update FLAG failed.'
						return -100
         end
   
   select @isvalid='Success.'
   
   return 0
   
   go
   
-------------------------------------------------------------
-------------------------------------------------------------
if exists (select * from sysobjects where name='Inbound_confirm')
		drop proc Inbound_confirm
	go
	
	create proc Inbound_confirm @p_whre_no varchar(35),
	                            @p_usercode   varchar(35),
	                            @isvalid varchar(250) output
	           as
	
	update wh_receipt set flag=1
	                    where whre_no = @p_whre_no  and operator = @p_usercode
	   		 if @@rowcount<0
	   		 begin
						select @isvalid='Confirm failed.'
						return -100
         end
   
   select @isvalid='Success.'
   
   return 0
   
   go   
   
   

-----------------------------------------------------------------------------
------------------------ADD TO Inventory----------------------------------------------------
if exists (select * from sysobjects where name='batch_inventory')
		drop proc batch_inventory
	go

	create proc batch_inventory @p_whre_no   char(35),
	                            @p_usercode   varchar(35),
	                            @isvalid  char(253) output
	                      with encryption as

	declare @filename char(35),@qty int,@id_num int,@qty_corder int

	begin tran
		save tran tran_batch_inv

	declare batch_cursor cursor for select part_no,qty,id_num from wh_receipt where flag=1 and  whre_no = @p_whre_no  and operator = @p_usercode
	open batch_cursor
	fetch batch_cursor into @filename,@qty,@id_num
	while @@fetch_status = 0
		begin
		  if exists(select * from warehouse where part_no=@filename)
			  begin
					update warehouse set qty=qty+@qty,
					                     qty_avail=qty_avail+@qty,
					                     qty_hardware=qty_hardware+@qty ,
					                     qty_hardware_avail=qty_hardware_avail+@qty,
					                     qty_in=qty_in+@qty
					                     where part_no = @filename   and operator = @p_usercode
						if @@rowcount = 0
						begin
							rollback tran tran_batch_inv
							commit tran
							select @isvalid = 'Update PartNO '+@filename+' to warehouse failed. Contact Admin.'
							return -102
						end
				end
			else
				begin
					insert warehouse(part_no,qty,qty_avail,qty_hardware,qty_in,operator)
						values(@filename,@qty,@qty,@qty,@qty, @p_usercode)
							if @@rowcount = 0
								begin
									rollback tran tran_batch_inv
									commit tran
									select @isvalid = 'Insert PartNO: '+@filename+' to warehouse failed. Contact Admin.'
									return -102
								end
				end	
				
			--delete shipment where id_num=@id_num
			update wh_receipt set flag=2,podate=getdate() where id_num=@id_num  and operator = @p_usercode
				if @@rowcount = 0
				begin
					rollback tran tran_batch_inv
					commit tran
					select @isvalid = 'update shipment '+@filename+' flag failed. Contact Admin.'
					return -102
				end

			fetch batch_cursor into @filename,@qty,@id_num
		end

	close batch_cursor
	deallocate batch_cursor
	commit tran

 
	   	 update warehouse set brand=b.brand,series = b.series, model = b.model 
		      from warehouse a, partno b where a.part_no = b.part_no
		       and a.part_no in (select part_no
	   		   from wh_receipt where whre_no = @p_whre_no and operator=@p_usercode)
	 	   
	 	   
   select @isvalid = 'Success.'

	return 0

go
   