
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='cpo_add')
		drop proc cpo_add
	go
	
create proc cpo_add             @p_cpono     nvarchar(35),
                                @p_cnamecode nvarchar(35),
                                @p_partno    nvarchar(150),
                                @p_qty       int,
                                @p_soprice   decimal(12,2),
                                @p_usercode   nvarchar(35),
                                @isvalid     nvarchar(253)  output
                          with encryption as

	declare @filename nvarchar(35),     @pkno nvarchar(15),@cname_id int,@cname nvarchar(120),
	        @apono nvarchar(35),@weight decimal(12,2),@unit nvarchar(15),
            @part_name nvarchar (85),
	        @price    decimal(12,2),@itemno int,   
	        @soprice decimal(12,2),@qty_avail int 
			
	if exists(select * from cpo where cpono=@p_cpono and part_no = @p_partno and operator = @p_usercode)
	begin
			select @isvalid = 'Added Duplicate'
			return -200
		end
		
	select @cname = cname from erpclient where cname_code = @p_cnamecode and operator = @p_usercode

	 select @unit = unit,@part_name=part_name from partno where part_no = @p_partno   and operator = @p_usercode
	 
 if (select count(*) from cpo where cpono=@p_cpono   and operator = @p_usercode)<1
    select @itemno = '1'
 else select @itemno = count(*)+1 from cpo where cpono = @p_cpono   and operator = @p_usercode

 insert cpo(cpono,itemno,part_no,part_name,qty,soprice,op_date,operator,cname,cname_code,finished,unit)
	  values(@p_cpono,@itemno,@p_partno,@part_name,@p_qty,@p_soprice,getdate(),@p_usercode,@cname,@p_cnamecode,'0',@unit)
	if @@rowcount = 0
		begin
			select @isvalid = 'Add failed'
			return -200
		end

   -- update warehouse set qty=qty-@p_qty where part_no = @p_partno   and operator = @p_usercode

select @isvalid = 'Success'

  return 0

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='cpo_Singledelete')
		drop proc cpo_Singledelete
	go
	
create proc cpo_Singledelete    @p_idnum int,
                                @p_usercode   nvarchar(35),
                                @isvalid     nvarchar(253)  output
                          with encryption as

	 declare @partno nvarchar(35), @qty int

	 select @partno = part_no,@qty = qty from cpo where id_num = @p_idnum   and operator = @p_usercode

	--  update warehouse set qty=qty+@qty where part_no = @partno   and operator = @p_usercode

	 delete cpo where  id_num = @p_idnum   and operator = @p_usercode
	 
	 select @isvalid='Success.'

  return 0

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists( select * from sysobjects where name='add_b_invoice')
			drop proc add_b_invoice
	go
	
	create proc add_b_invoice	@p_invoiceno   nvarchar(35)		,
	                              @p_terms       nvarchar(35),
	                              @p_cpono   nvarchar(35)		,
								  @p_operator nvarchar(35),
	                              @isvalid   nvarchar(253)   output
	                        with encryption as 
	declare @cname nvarchar(150),@cname_id nvarchar(35),@filename nvarchar(35),@filename_id int,@itemno int,@part_name nvarchar (85),
	        @qty int,@soprice decimal(12,2),@cpono nvarchar(35),@description nvarchar(500),@unit nvarchar(15),
	        @cpono_id_num int,@discount decimal(12,4),@days int,@duedate nvarchar(10),@operator nvarchar(35),@returnvalue int
	
  if (@p_terms='C.O.D.')
     select @duedate=convert(char,getdate(),101)
  else
  	begin
  		select @days=convert(int,left(@p_terms,2))
  		select @duedate=convert(char,dateadd(day,@days,getdate()),101)
  	end
  	   
  begin tran 
  	save tran batch_invoice_tran

	declare invoice_cursor cursor for select cname,cname_code,part_no,operator,unit,
	               qty,soprice,id_num  from cpo where cpono = @p_cpono and operator = @p_operator
	open invoice_cursor
	fetch invoice_cursor into @cname,@cname_id,@filename,@operator,@unit,@qty,@soprice,@cpono_id_num
  while @@fetch_status = 0
  begin

		  if (select count(*) from invoice where invoiceno=@p_invoiceno and operator = @p_operator)<1
		    select @itemno = '1'
		  else 
		  	select @itemno = count(*)+1 from invoice where invoiceno=@p_invoiceno

			select @description = part_description,@part_name=part_name from partno where part_no=@filename and operator = @p_operator

			if exists(select * from invoice where cpono_id_num=@cpono_id_num)
			begin
				rollback tran batch_invoice_tran
				commit tran
				select @isvalid = 'Error,Double Add!'
				return -200
			end

			insert invoice(invoiceno,invoicedate,terms,cname,cname_code,part_no,duedate,part_name,partno_description,
			                    cpono,cpono_id_num,itemno,qty,qtyp,paidprice,uprice,flag,operator,unit)
			       values(@p_invoiceno,convert(char,getdate(),101),@p_terms,@cname,@cname_id,@filename,@duedate,@part_name,@description,
			                    @p_cpono,@cpono_id_num,@itemno,@qty,@qty,@qty*@soprice,@soprice,'batch',@operator,@unit)             
			if @@rowcount=0
			begin
				rollback tran batch_invoice_tran
				commit tran
				select @isvalid = 'Invoice '+@filename+ 'add failed, contact admin.'
				return -100
			end

		  update cpo set qty_inv=@qty where id_num = @cpono_id_num
	    if @@rowcount=0
		  begin
				rollback tran batch_invoice_tran
				commit tran
		  	select @isvalid='Update CPO '+rtrim(@filename)+'invoice qty failed.Contact admin'
		  	return -100
		  end

			fetch invoice_cursor into @cname,@cname_id,@filename,@operator,@unit,@qty,@soprice,@cpono_id_num
	  end	                          

  close invoice_cursor
  deallocate invoice_cursor
  
  update invoice set tax = i.paidprice *  e.invoice_tax /100
            from invoice i, erpclient e 
       where i.cname_code = e.cname_code and i.invoiceno = @p_invoiceno and i.operator = @p_operator
  
   exec @returnvalue=batch_invoice @p_invoiceno,@p_operator,@isvalid output
   if @returnvalue<0
   begin 
      rollback tran batch_invoice_tran
	  commit tran   
      return -100
   end
  commit tran
  select @isvalid = 'CPO# '+@p_cpono+' add successful.'

	return 0

	go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='add_shippingfee')
			drop proc add_shippingfee
	go

	create proc add_shippingfee @p_invoiceno		char(35),
	                            @p_shippingfee  decimal(12,3),
	                            @isvalid        nvarchar(253)  output
	                    with encryption as

  declare @itemno int,@notes nvarchar(253),@id_num int,@cname nvarchar(150),@cname_id int

  select @notes='add shipping fee to '+rtrim(@p_invoiceno)+': $'+convert(char,@p_shippingfee)+','+convert(char,getdate())

  if @p_shippingfee<1
  begin
		select @isvalid = 'Shipping fee is less than $1.'
		return -100
  end
  
  if (select count(*) from invoice where invoiceno=@p_invoiceno)<1
    select @itemno = '1'
  else 
  	select @itemno = count(*)+1 from invoice where invoiceno=@p_invoiceno

  select @cname=cname,@cname_id=cname_code from invoice where invoiceno=@p_invoiceno

  insert invoice(invoiceno,invoicedate,itemno,part_no,partno_description,qty,uprice,paidprice,flag,notes,cname,cname_code)
         values(@p_invoiceno,convert(char,getdate(),101),@itemno,' H & L','SHIPPING & HANDLING CHARGE',1,@p_shippingfee,@p_shippingfee,'HL',@notes,@cname,@cname_id)
	if @@rowcount=0
	begin
		select @isvalid = 'Shipping fee add failed, contact admin.'
		return -100
	end

   select @id_num=id_num from invoice where invoiceno= @p_invoiceno and invoicedate=convert(char,getdate(),101)and flag='HL'

 -- insert hist_invoice(old_id_num,invoiceno,invoicedate,itemno,filename,description,qty,uprice,paidprice,flag,notes,cname,cname_id)
 --        values(@id_num,@p_invoiceno,convert(char,getdate(),101),@itemno,' H & L','SHIPPING & HANDLING CHARGE',1,@p_shippingfee,@p_shippingfee,'HL',@notes,@cname,@cname_id)
	--if @@rowcount=0
	--begin
	--	select @isvalid = 'insert hist_invoice failed, contact admin.'
	--	return -100
	--end

	select @isvalid = 'Shipping fee add successful.'
	return 0

	go

	
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='batch_invoice')
		drop proc batch_invoice
	go

	create proc batch_invoice   @p_invoiceno   nvarchar(35),
	                            @p_operator    nvarchar(35),
	                            @isvalid  nvarchar(253) output
	                      with encryption as

	declare @filename nvarchar(35),@cpo_id_num int,@qty int,@paidprice decimal(12,2),@id_num int,
	          @qty_cpo int,@qty_invoice int,@cname nvarchar(150),@flag nvarchar(15),@itemno int


	begin tran
		save tran tran_batch_invoice

	declare cur_batch_invoice cursor for select id_num,cpono_id_num,part_no,qtyp,paidprice,cname,flag
	    			from invoice where invoiceno=@p_invoiceno   and operator = @p_operator order by part_no
  open cur_batch_invoice
  fetch cur_batch_invoice into @id_num,@cpo_id_num,@filename,@qty,@paidprice,@cname,@flag
  while @@fetch_status = 0
  begin
		--if exists(select * from warehouse where part_no=@filename and qty<@qty)
		--  begin
		--  	rollback tran tran_batch_invoice
		--		commit tran
		--		select @isvalid='Part#'+rtrim(@filename)+' QTY is not enough.'
		--		return -900
		--  end

			insert into hist_invoice(old_id_num,invoiceno,invoicedate,terms,cname,cname_code,discount,flag,
							part_no,part_no_id,partno_description,cpono,cpono_id_num,itemno,qty,qtyp,uprice,paidprice,operator)
			select id_num,invoiceno,invoicedate,terms,cname,cname_code,discount,flag,
							part_no,part_no_id,partno_description,cpono,cpono_id_num,itemno,qty,qtyp,uprice,paidprice,operator
			    from invoice where id_num=@id_num
		  if @@rowcount=0
		  begin
		  	rollback tran tran_batch_invoice
				commit tran
				select @isvalid='Copy'+rtrim(@filename)+' to History Invoice fail.'
				return -900
		  end

		if (@flag!='HL' )
		begin
		if (@flag!='CRED')

		begin

			update warehouse set qty=qty-@qty,qty_hardware=qty_hardware-@qty,
			                    qty_out=qty_out+@qty where part_no=@filename  and operator = @p_operator
			if @@rowcount = 0
			begin
				rollback tran tran_batch_invoice
				commit tran
				select @isvalid =  ' modify '+rtrim(@filename)+ ' Inventory failed, contact admin.'
				return -100
			end

	    select @qty_invoice=sum(qtyp) from invoice where cpono_id_num = @cpo_id_num
	    select @qty_cpo =qty         from cpo        where id_num     = @cpo_id_num
	    if (@qty_invoice = @qty_cpo)
	    begin
	    	--delete cpo where id_num=@cpo_id_num
	    	update cpo set finished='1' where id_num=@cpo_id_num
	    	if @@rowcount = 0
	    	begin
	    		rollback tran tran_batch_invoice
				  commit tran
	    		select @isvalid = 'Del '+rtrim(@filename)+' CPO data failed, contact admin!'
	    		return -100
	    	end
	    end  

   end end 


    update invoice set flag='1',itemno=@itemno where id_num=@id_num
    	if @@rowcount = 0
    	begin
    		rollback tran tran_batch_invoice
			  commit tran
    		select @isvalid = 'Update '+rtrim(@filename)+' Apsinvoice data failed, contact admin!'
    		return -100
    	end

    select @itemno=@itemno+1

    fetch cur_batch_invoice into @id_num,@cpo_id_num,@filename,@qty,@paidprice,@cname,@flag
  end
  close cur_batch_invoice
  deallocate cur_batch_invoice

	commit tran

	return 0

go



-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='inv_Print')
		drop proc inv_Print
	go
	
create proc inv_Print   @p_Invoiceno     nvarchar(35),
                        @p_usercode   nvarchar(35)
                          with encryption as

	select invoiceno,invoicedate,cpono,part_no,qty,uprice,paidprice,cname from invoice
		where invoiceno = @p_Invoiceno and operator = @p_usercode
	
	return 0

 go 
 
 
