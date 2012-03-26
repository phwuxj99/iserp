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
	                       @p_supplier_code  nvarchar(35),
	                       @p_order_no       nvarchar(35),
	                       @p_podate         nvarchar(15),
	                       @p_usercode   nvarchar(35),
	                       @isvalid             nvarchar(253)    output
	                with encryption as
	
	declare @PartName nvarchar(65)
	
	if (select count(*) from partno where part_no=@p_part_no and operator = @p_usercode)<1
	begin
	 	select @isvalid =  'No Such Parts: '+@p_part_no
	 	return -102
	 end 
	 
	 select @PartName=part_name from partno where part_no=@p_part_no and operator = @p_usercode
	 
	insert wh_receipt(whre_no,part_no,part_name,qty,supplier_code,order_no,podate,op_date,operator,flag)	
				values(@p_whreceipt_no,@p_part_no,@PartName,@p_quantity,@p_supplier_code,@p_order_no,@p_podate,getdate(),@p_usercode,0)
	 if @@rowcount = 0
	 begin
	 	select @isvalid =  @p_part_no+' insert error. Contact Admin.'
	 	return -102
	 end      

	 	select @isvalid =  @p_part_no+' inserted sucessfully .'

 return 0

 go

-------------------------------------------------------------
-------------------------------------------------------------
if exists(select * from sysobjects where name='whreceipt_delSingle')
		drop proc whreceipt_delSingle
	go
	
	create proc whreceipt_delSingle @p_id_num	 int,
	                                @p_usercode   nvarchar(35),
	                                @isvalid             nvarchar(253)    output
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
	                                 @p_usercode   nvarchar(35),
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
	
	create proc AddInventory @p_whre_no nvarchar(35),
	                         @p_wh_flag nvarchar(5),
	                         @p_usercode   nvarchar(35),
	                         @isvalid   nvarchar(255)
	                 with encryption as
	
	--DECLARE @TransactionName nvarchar(20) = 'Transaction1'
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
	   		 
		   update wh_receipt set flag='1' where   whre_no = @p_whre_no and operator=@p_usercode
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
		   
		   update wh_receipt set flag='1' where   whre_no = @p_whre_no and operator=@p_usercode
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
	
-------------------------------------------------------------
-------------------------------------------------------------
if exists (select * from sysobjects where name='Update_wh_recept_name')
		drop proc Update_wh_recept_name
	go
	
	create proc Update_wh_recept_name @p_OldName nvarchar(35),
	                                  @p_NewName nvarchar(35),
	                                  @p_InputDate nvarchar(10),
	                                  @p_usercode   nvarchar(35),
	                                  @isvalid nvarchar(250) output
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
	
	create proc Inbound_confirm @p_whre_no nvarchar(35),
	                            @p_usercode   nvarchar(35),
	                            @isvalid nvarchar(250) output
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

	create proc batch_inventory @p_whre_no   nvarchar(35),
	                            @p_usercode   nvarchar(35),
	                            @isvalid  nvarchar(253) output
	                      with encryption as

	declare @filename nvarchar(35),@qty int,@id_num int,@qty_corder int,@PartName nvarchar(65)

	begin tran
		save tran tran_batch_inv

	declare batch_cursor cursor for select part_no,part_name,qty,id_num from wh_receipt where flag=0 and  whre_no = @p_whre_no  and operator = @p_usercode
	open batch_cursor
	fetch batch_cursor into @filename,@PartName,@qty,@id_num
	while @@fetch_status = 0
		begin
		  if exists(select * from warehouse where part_no=@filename  and operator = @p_usercode)
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
					insert warehouse(part_no,part_name,qty,qty_avail,qty_hardware,qty_in,operator)
						values(@filename,@PartName,@qty,@qty,@qty,@qty, @p_usercode)
							if @@rowcount = 0
								begin
									rollback tran tran_batch_inv
									commit tran
									select @isvalid = 'Insert PartNO: '+@filename+' to warehouse failed. Contact Admin.'
									return -102
								end
				end	
				
			--delete shipment where id_num=@id_num
			update wh_receipt set flag=1,podate=getdate() where id_num=@id_num  and operator = @p_usercode
				if @@rowcount = 0
				begin
					rollback tran tran_batch_inv
					commit tran
					select @isvalid = 'update shipment '+@filename+' flag failed. Contact Admin.'
					return -102
				end
            
			update warehouse 
			 set part_name = p.part_name,
				 description = p.part_description
				 from warehouse w, partno p
				  where w.part_no = p.part_no
						and p.part_no = @filename   and p.operator = @p_usercode
				
			fetch batch_cursor into @filename,@PartName,@qty,@id_num
		end

	close batch_cursor
	deallocate batch_cursor
	commit tran

 
	--  	 update warehouse set brand=b.brand,series = b.series, model = b.model 
	--	      from warehouse a, partno b where a.part_no = b.part_no
	--	       and a.part_no in (select part_no
	--   		   from wh_receipt where whre_no = @p_whre_no and operator=@p_usercode)
	 	   
	 	   
   select @isvalid = 'Success.'

	return 0

go
   