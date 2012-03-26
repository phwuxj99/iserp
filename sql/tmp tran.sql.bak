
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='add_tmp_partno')
		drop proc add_tmp_partno
	go

	create proc add_tmp_partno  @p_part_no           char(35)	,
			                        @p_part_name         char(85),
			                        @p_part_description  varchar(500),
			                        @p_brand             char(65),
															@p_series            char(65),
															@p_model             char(65),
															@p_outputvalue       varchar(165),
															@p_compatible        varchar(350),
			                        @p_unit              char(15),
			                        @p_category          char(65),
			                        @p_dimension         char(35),
															@p_weight            decimal(12,3),
			                        @p_operator          char(85),
			                        @isvalid             char(253)    output
	               as

-- declare @dimens char(15),@dimens1 char(15),@length int,@width int,@heigth int

	if exists(select * from tmp_partno where operatorA!=@p_operator)
		begin
			delete tmp_partno where operatorA!=@p_operator
		end

 insert tmp_partno(part_no,part_name,part_description,brand,series,model,outputvalue,compatible,unit,category,dimension,weight,operatorA)
       values(upper(@p_part_no),@p_part_name,@p_part_description,@p_brand,@p_series,@p_model,@p_outputvalue,@p_compatible,@p_unit,@p_category,@p_dimension,@p_weight,@p_operator)
 if @@rowcount = 0
	 begin
	 	select @isvalid =  'Parts '+@p_part_no+' insert error. Contact Admin.'
	 	return -102
	 end      

	 	select @isvalid =  'inserted sucessfully .'

 return 0

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='tmp_partno_update')
		drop proc tmp_partno_update
	go

	create proc tmp_partno_update  
	                        @p_id_num            int,
	                        @p_part_no           char(35)	,
	                        @p_part_name         char(85),
	                        @p_part_description  varchar(500),
	                        @isvalid             char(253)    output
	               as

	update tmp_partno set part_no=@p_part_no,part_name=@p_part_name,part_description=@p_part_description where id_num=@p_id_num
	 if @@rowcount = 0
		 begin
		 	select @isvalid =  'Parts '+@p_part_no+' update error. Contact Admin.'
		 	return -102
		 end      
	
	 	select @isvalid =  'inserted sucessfully .'

 return 0

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='tmp_partno_tran')
		drop proc tmp_partno_tran
	go

	create proc tmp_partno_tran  
					@p_guid     varchar(65),
					@p_operator varchar(35),
	        @isvalid    varchar(253)    output
	      as

	declare @id_num int,@partno varchar(35),@part_name varchar(85),@part_description varchar(500),@operatorA varchar(65),
	@brand varchar(65),@series varchar(65),@model varchar(65),@outputvalue varchar(165), @compatible varchar(350) , @unit varchar(15),
	@category varchar(65), @dimension char(35),@weight decimal(12,3)
	
	
	begin tran
		save tran tran_batch_corder

	declare cur_batch_corder cursor for select id_num,part_no,part_name,part_description,operatorA,brand,series,model,outputvalue,compatible,unit,category,dimension,weight from tmp_partno where operatorA=@p_guid
	open cur_batch_corder
	fetch cur_batch_corder into @id_num,@partno,@part_name,@part_description,@operatorA,@brand,@series,@model,@outputvalue,@compatible,@unit,@category,@dimension,@weight
	while @@fetch_status = 0
	begin
		
			if @partno is not null or LEN(@partno)>0
			begin
			if not exists(select * from partno where part_no=@partno)
			begin
	
					insert into partno(part_no,part_name,part_description,notes,brand,series,model,outputvalue,compatible,unit,category,dimension,weight,operator)
											values(@partno,@part_name,@part_description,@operatorA,@brand,@series,@model,@outputvalue,@compatible,@unit,@category,@dimension,@weight,@p_operator)
					if @@rowcount = 0
					begin
						rollback tran tran_batch_corder
						commit tran
						select @isvalid='Insert '+rtrim(@partno)+' failed.'
						return -100
					end
			
					delete tmp_partno where id_num=@id_num
					if @@rowcount = 0
					begin
						rollback tran tran_batch_corder
						commit tran
						select @isvalid='Delete Corder '+rtrim(@partno)+' failed.'
						return -100
					end
		  end
		  end
		  
		 fetch cur_batch_corder into @id_num,@partno,@part_name,@part_description,@operatorA,@brand,@series,@model,@outputvalue,@compatible,@unit,@category,@dimension,@weight
		 
	end
	close cur_batch_corder
	deallocate cur_batch_corder

	commit tran
	
	 	select @isvalid =  'inserted sucessfully .'

 return 0

 go
