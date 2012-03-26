
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='add_partno_d')
		drop proc add_partno_d
	go

	create proc add_partno_d  @p_part_no           nvarchar(35)	,
		                        @p_part_name         nvarchar(85),
		                        @p_part_description  nvarchar(500),
		                        @p_unit              nvarchar(15),
		                        @p_category          nvarchar(65),
		                        @p_uprice            decimal(12,2),
								@p_cprice            decimal(12,2),
		                        @p_brand             nvarchar(65),
		                        @p_series            nvarchar(65),
		                        @p_model             nvarchar(65),
		                        @p_outputvalue       nvarchar(165),
		                        @p_compatible        nvarchar(350),
		                        @p_dimension         nvarchar(35),
		                        @p_weight            decimal(12,2),
		                        @p_usercode          nvarchar(35),
		                        @p_notes             ntext,
		                        @isvalid             nvarchar(253)    output
	               with encryption as

-- declare @dimens nvarchar(15),@dimens1 nvarchar(15),@length int,@width int,@heigth int

 if exists (select * from partno where part_no=rtrim(@p_part_no))
	 begin
	 	select @isvalid = 'Parts '+@p_part_no+' is already exist.'
	 	return -101
	 end
 
 insert partno(part_no,part_name,part_description,unit,category,price1,price2,weight,notes,brand,series,model,outputvalue,compatible,operator)
       values(upper(@p_part_no),@p_part_name,@p_part_description,@p_unit,@p_category,@p_uprice,@p_cprice,@p_weight,@p_notes,@p_brand,@p_series,@p_model,@p_outputvalue,@p_compatible,@p_usercode)
 if @@rowcount = 0
	 begin
	 	select @isvalid =  'Parts '+@p_part_no+' insert error. Contact Admin.'
	 	return -102
	 end      

	 	select @isvalid =  'Parts '+@p_part_no+' inserted sucessfully .'

 return 0

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='add_partno')
		drop proc add_partno
	go

	create proc add_partno  @p_part_no           nvarchar(35)	,
	                        @p_part_name         nvarchar(85),
	                        @p_part_description  nvarchar(500),
	                        @p_unit              nvarchar(15),
	                        @p_category          nvarchar(65),
	                        @p_usercode          nvarchar(35),
	                        @isvalid             nvarchar(253)    output
	               as

-- declare @dimens nvarchar(15),@dimens1 nvarchar(15),@length int,@width int,@heigth int

 if exists (select * from partno where part_no=rtrim(@p_part_no))
	 begin
	 	select @isvalid = 'Parts '+@p_part_no+' is already exist.'
	 	return -101
	 end
 
 insert partno(part_no,part_name,part_description,unit,operator)
       values(upper(@p_part_no),@p_part_name,@p_part_description,@p_unit,@p_usercode)
 if @@rowcount = 0
	 begin
	 	select @isvalid =  'Parts '+@p_part_no+' insert error. Contact Admin.'
	 	return -102
	 end      

	 	select @isvalid =  'Parts '+@p_part_no+' inserted sucessfully .'

 return 0

 go


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='update_partno_d')
		drop proc update_partno_d
	go

	create proc update_partno_d  	   -- @p_PartnoOld            nvarchar(35)	,
				                       -- @p_PartnoNew           nvarchar(35)	,
				                        @p_Partno           nvarchar(35),
										@p_part_name         nvarchar(85),
				                        @p_part_description  nvarchar(500),
				                        @p_unit              nvarchar(15),
				                        @p_category          nvarchar(65),
		                                @p_uprice            decimal(12,2),
								        @p_cprice            decimal(12,2),
				                        @p_brand             nvarchar(65),
				                        @p_series            nvarchar(65),
				                        @p_model             nvarchar(65),
				                        @p_outputvalue       nvarchar(165),
				                        @p_compatible        nvarchar(350),
				                        @p_dimension         nvarchar(35),
				                        @p_weight            decimal(12,2),
				                        @p_usercode          nvarchar(35),
				                        @p_notes             ntext,
				                        @isvalid             nvarchar(253)    output
	              -- with encryption
	               as

    UPDATE partno SET part_name = @p_part_name, part_description=@p_part_description,
        weight=@p_weight, price1 = @p_uprice,price2 = @p_cprice,
        brand=@p_brand,series=@p_series,model=@p_model,outputvalue=@p_outputvalue,compatible=@p_compatible,
        dimension=@p_dimension,unit=@p_unit,category=@p_category,notes=@p_notes
         WHERE part_no=@p_Partno and operator=@p_usercode
 if @@rowcount = 0
	 begin
	 	select @isvalid =  @p_Partno+' Updated error. Contact Admin.'
	 	return -102
	 end      

	 	select @isvalid =  @p_Partno+' Updated sucessfully .'

 return 0

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='update_partno')
		drop proc update_partno
	go

CREATE PROCEDURE update_partno @p_PartnoOld         nvarchar(35)	,
				                       @p_PartnoNew         nvarchar(35)	,
			                         @p_part_name         nvarchar(85),
			                         @p_part_description  nvarchar(500),
			                         @p_unit              nvarchar(15),
			                         @p_category          nvarchar(65),
			                         @p_usercode          nvarchar(35),
			                         @isvalid             nvarchar(253)    output
AS
	/* SET NOCOUNT ON */
	-- declare @dimens nvarchar(15),@dimens1 nvarchar(15),@length int,@width int,@heigth int
 --declare @old_partno nvarchar(35)
 
 if (@p_PartnoOld!=@p_PartnoNew)
	 begin
		 if exists (select * from partno where part_no=rtrim(@p_PartnoNew) and operator=@p_usercode)
			 begin
			 	select @isvalid = 'Parts '+@p_PartnoNew+' is already exist.'
			 	return -101
			 end
	 end
 
    UPDATE partno SET part_no = @p_PartnoNew,
        part_name = @p_part_name, part_description=@p_part_description,
        category=@p_category,
        unit=@p_unit
         WHERE part_no = @p_PartnoOld and operator=@p_usercode
 if @@rowcount = 0
	 begin
	 	select @isvalid =  @p_PartnoOld+' Update error. Contact Admin.'
	 	return -102
	 end

	 	select @isvalid =  @p_PartnoOld+' updated sucessfully .'

 return 0

go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='delete_partno')
		drop proc delete_partno
	go

	create proc delete_partno  @p_partno nvarchar(35),
	                        @p_usercode          nvarchar(35),
	                        @isvalid             nvarchar(253)    output
	               with encryption as

-- declare @dimens nvarchar(15),@dimens1 nvarchar(15),@length int,@width int,@heigth int

 if not exists (select * from partno where part_no=@p_partno and operator=@p_usercode)
	 begin
	 	select @isvalid = 'Parts is not exist.'
	 	return -101
	 end
 
 delete partno where part_no=@p_partno and operator=@p_usercode
 if @@rowcount = 0
	 begin
	 	select @isvalid =  'Parts delete error. Contact Admin.'
	 	return -102
	 end

	 	select @isvalid =  'Parts delete inserted sucessfully .'

 return 0

 go
 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='getpartno')
		drop proc getpartno
	go

create procedure getpartno 
--ALTER PROCEDURE getpartno	
--	(
	@p_partno nvarchar(35) = '%',
	@p_brand  nvarchar(35) = '%',
	@p_series nvarchar(35) = '%',
	@p_model  nvarchar(35) = '%',
	@p_usercode nvarchar(35)='%'
--	)
AS
	/* SET NOCOUNT ON */
	SELECT id_num,part_no,part_name,part_description,unit,brand,model,series,category 
		FROM partno 
		where lower(part_no) like '%'+lower(@p_partno)+'%' and
		      LOWER(ISNULL(brand,''))  like '%'+LOWER(rtrim(@p_brand))+'%' and
		      LOWER(ISNULL(series,'')) like '%'+LOWER(rtrim(@p_series))+'%' and
		      LOWER(ISNULL(model,''))  like '%'+LOWER(rtrim(@p_model))+'%' and 
		      operator=@p_usercode
--	RETURN
go

----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='PartnoUploadImg')
		drop proc PartnoUploadImg
	go
	
	create proc PartnoUploadImg @p_Partno  nvarchar(35),
	                            @p_ImgData image,
	                            @p_usercode          nvarchar(35),
	                            @p_ContentType nvarchar(50)
	AS 
  

	if exists(select * from PartnoImage where img_partno=@p_Partno)
		begin
			update PartnoImage set img_data=@p_ImgData,img_contenttype=@p_ContentType
				where img_partno=@p_Partno and operator=@p_usercode
		end
  else
		begin	  
			INSERT PartnoImage(img_partno,img_data,img_contenttype,operator)
			           values(@p_Partno,@p_ImgData,@p_ContentType,@p_usercode)
	  end
  
	UPDATE partno set image_id             = b.img_pk
			FROM partno a, PartnoImage b 
				WHERE a.part_no=b.img_partno and b.operator=@p_usercode
				
	UPDATE PartnoImage set 
		                img_part_name        = b.part_name,
		                img_part_description = b.part_description,
		                img_brand            = b.brand,
		                img_series           = b.series,
		                img_model            = b.model
			FROM partno b, PartnoImage a 
				WHERE b.part_no=a.img_partno and a.operator=@p_usercode

	RETURN 0

go


	

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists(select * from sysobjects where name='pn_GetPartNoImgID')
	drop proc pn_GetPartNoImgID
	go
	
	create proc pn_GetPartNoImgID @p_ImgPartno nvarchar(35)
	as
	
	SELECT img_data FROM PartnoImage WHERE img_partno=@p_ImgPartno
	
	return 0
	
	go
		