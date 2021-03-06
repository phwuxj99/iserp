
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='insert_bom_title')
		drop proc insert_bom_title
	go

	create proc insert_bom_title  @p_bom_no     varchar(35)	,
	                        @p_bom_level        varchar(35),
	                        @p_bom_name         varchar(85),
	                        @p_bom_description  varchar(500),
	                        @p_drawing_no       varchar(65),
	                        @p_client_no        varchar(85),
	                        @p_client_drawing_no varchar(150),
	                        @p_category          varchar(65),
	                        @p_unit              varchar(15),
	                        @p_dimension         varchar(35),
	                        @p_package_no        varchar(35),
	                        @p_gross_weight      decimal(12,2),
	                        @p_usercode          varchar(35),
	                        @p_notes             text,
	                        @isvalid             varchar(253)    output
	               with encryption as

-- declare @dimens char(15),@dimens1 char(15),@length int,@width int,@heigth int

 declare @category_id int,@bom_categoryID int
 
 select @category_id = id_num from category where category = @p_category and operator = @p_usercode
 select @bom_categoryID = id_num from bom_category where category = @p_bom_level and operator = @p_usercode
 
 if exists (select * from bom_title where bom_no=rtrim(@p_bom_no))
	 begin
	 	select @isvalid = 'BOM# '+@p_bom_no+' is already exist.'
	 	return -101
	 end
 
 insert bom_title(bom_no,bom_name,bom_levelID, bom_level,bom_description,drawing_no,client_no,
             client_drawing_no,categoryID,category,unit,dimension,package_no,gross_weight,notes,operator)
       values(@p_bom_no,@p_bom_name,@bom_categoryID,@p_bom_level,@p_bom_description,@p_drawing_no,@p_client_no,
             @p_client_drawing_no,@category_id,@p_category,@p_unit,@p_dimension,@p_package_no,@p_gross_weight,@p_notes,@p_usercode)
 if @@rowcount = 0
	 begin
	 	select @isvalid =  'BOM '+@p_bom_no+' insert error. Contact Admin.'
	 	return -102
	 end      

	 	select @isvalid =  'BOM '+@p_bom_no+' inserted sucessfully .'

 return 0

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='update_bom_title')
		drop proc update_bom_title
	go

	create proc update_bom_title  @p_bom_no     varchar(35)	,
	                        @p_bom_level        varchar(35),
	                        @p_bom_name         varchar(85),
	                        @p_bom_description  varchar(500),
	                        @p_drawing_no       varchar(65),
	                        @p_client_no        varchar(85),
	                        @p_client_drawing_no varchar(150),
	                        @p_category          varchar(65),
	                        @p_unit              varchar(15),
	                        @p_dimension         varchar(35),
	                        @p_package_no        varchar(35),
	                        @p_gross_weight      decimal(12,2),
	                        @p_usercode          varchar(35),
	                        @p_notes             text,
	                        @isvalid             varchar(253)    output
	               with encryption as

-- declare @dimens char(15),@dimens1 char(15),@length int,@width int,@heigth int
 declare @category_id int,@bom_categoryID int
 
 select @category_id = id_num from category where category = @p_category and operator = @p_usercode
 select @bom_categoryID = id_num from bom_category where category = @p_bom_level and operator = @p_usercode

 if not exists (select * from bom_title where bom_no=rtrim(@p_bom_no))
	 begin
	 	select @isvalid = 'BOM# '+@p_bom_no+' is not exist.'
	 	return -101
	 end
	 
 update bom_title set bom_name=@p_bom_name,bom_level=@p_bom_level, bom_levelID = @bom_categoryID,
                      bom_description=@p_bom_description,drawing_no=@p_drawing_no,
                      client_no=@p_client_no,
                      client_drawing_no=@p_client_drawing_no,
                      categoryID=@category_id,
                      category=@p_category,unit=@p_unit,
                      dimension=@p_dimension,package_no=@p_package_no,
                      gross_weight=@p_gross_weight,
                      notes=@p_notes
             where bom_no=@p_bom_no and operator = @p_usercode
 if @@rowcount = 0
	 begin
	 	select @isvalid =  'BOM '+@p_bom_no+' Updated error. Contact Admin.'
	 	return -102
	 end      

	 	select @isvalid =  'BOM '+@p_bom_no+' Updated sucessfully .'

 return 0

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists (select * from sysobjects where name='update_bom_title_s')
		drop proc update_bom_title_s
	go

	create proc update_bom_title_s  @p_id_num int,
	                        @p_bom_no     varchar(35)	,
	                        @p_bom_name         varchar(85),
	                        @p_category          varchar(65),
	                        @p_usercode          varchar(35),
	                        @isvalid             varchar(253)    output
	               with encryption as

-- declare @dimens char(15),@dimens1 char(15),@length int,@width int,@heigth int
 declare @bom_no_old char(35),@category_id int
 select @bom_no_old = bom_no from bom_title where id_num=@p_id_num and operator = @p_usercode
  select @category_id = id_num from category where category = @p_category and operator = @p_usercode

 update bom_title set bom_no=@p_bom_no,bom_name=@p_bom_name,
                      category=@p_category,categoryID=@category_id
             where id_num=@p_id_num and operator = @p_usercode
 if @@rowcount = 0
	 begin
	 	select @isvalid =  'BOM '+@bom_no_old+' Updated error. Contact Admin.'
	 	return -102
	 end      

  if exists(select * from bom_details where bom_no=@bom_no_old)
     begin
     	update bom_details set bom_no=@p_bom_no where bom_no=@bom_no_old and operator = @p_usercode
			 if @@rowcount = 0
				 begin
				 	select @isvalid =  'BOM '+@bom_no_old+' Updated error. Contact Admin.'
				 	return -102
				 end      
     end
     
	 	select @isvalid =  'BOM '+@p_bom_no+' Updated sucessfully .'

 return 0

 go

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
if exists (select * from sysobjects where name='delete_bom_title')
		drop proc delete_bom_title
	go
	
	create proc delete_bom_title
  	                    @p_id_num            int,
  	                    @p_usercode          varchar(35),
                        @isvalid nvarchar(250) output
                     as

    delete bom_title where id_num=@p_id_num and operator = @p_usercode
	    if @@rowcount=0
			   begin
	  		   	select @isvalid='BOM Title Delete Failed, Contact Admin!'
		  	   	return -100
			   end

		select @isvalid='BOM Title Delete successfully!'
		
		return 0
		
	go

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
if exists (select * from sysobjects where name='bom_input_details')
  drop proc bom_input_details
  go
  
  create proc bom_input_details @p_bom_no    char(35),
                        @p_lowlevel_code     int,
                        @p_part_no           varchar(250),
                        @p_usages             decimal(12,2),
                        @p_usercode          varchar(35),
                        @p_comments          nvarchar(300),
                        @isvalid nvarchar(250) output
                     as
  declare @part_name varchar(65),@part_description varchar(250),@unit char(15),@itemno int
  
  select  @part_name=part_name,@part_description=part_description,@unit=unit from partno where lower(part_no)=lower(@p_part_no) and operator = @p_usercode
  if @@rowcount=0
     begin
     	 select @isvalid='Error: Part# do not exist!'
     	 return -100
     end
  
  if (select count(*) from bom_details where bom_no=@p_bom_no and operator = @p_usercode)>0
     select @itemno=max(item_no)+1 from bom_details where bom_no=@p_bom_no and operator = @p_usercode
  else
     select @itemno=1
     
	insert bom_details(bom_no,lowlevel_code,part_no,part_name,part_description,unit,item_no,
	                  usages,comments,operator)  
	   values(@p_bom_no,@p_lowlevel_code,upper(@p_part_no),@part_name,@part_description,@unit,@itemno,
	                  @p_usages,@p_comments,@p_usercode)
     if @@rowcount =0
        begin
			  	 select @isvalid = 'Part# insert failed. contact admin.'
			  	 return -100
        end

    select @isvalid='Part# insert successfully.'
    
    return 0
    
 go   
  

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
if exists (select * from sysobjects where name='update_bom_details')
		drop proc update_bom_details
	go
	
	create proc update_bom_details
  	                    @p_id_num            int,
  	                    @p_lowlevel_code     int,
                        @p_part_no           varchar(250),
                        @p_usages             decimal(12,2),
                        @p_usercode          varchar(35),
                        @p_comments          nvarchar(300),
                        @isvalid nvarchar(250) output
                     as
		update bom_details set lowlevel_code=@p_lowlevel_code,part_no=@p_part_no,usages=@p_usages,
		                       comments=@p_comments
		             where id_num=@p_id_num and operator = @p_usercode
		if @@rowcount=0
		   begin
		   	select @isvalid='BOM Details Update Failed, Contact Admin!'
		   	return -100
		   end             
		
		select @isvalid='BOM Details Update successfully!'
		
		return 0   
	go
		
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
if exists (select * from sysobjects where name='delete_bom_details')
		drop proc delete_bom_details
	go
	
	create proc delete_bom_details
  	                    @p_id_num            int,
  	                    @p_usercode          varchar(35),
                        @isvalid nvarchar(250) output
                     as

    delete bom_details where id_num=@p_id_num and operator = @p_usercode
	    if @@rowcount=0
			   begin
	  		   	select @isvalid='BOM Details Delete Failed, Contact Admin!'
		  	   	return -100
			   end

		select @isvalid='BOM Details Delete successfully!'
		
		return 0
		
	go

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
if exists (select * from sysobjects where name='get_abom_details')
  drop proc get_abom_details
  go
  
  create proc get_abom_details @p_bom_no    char(35),
                               @p_usercode  varchar(35)
      as
  
  select * from bom_details where lower(bom_no)=lower(rtrim(@p_bom_no)) and operator = @p_usercode
  
  return 0
  
  go
  
  
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
/*  ALTER PROCEDURE GetBomdetailsSorted
--CREATE PROCEDURE GetProductsPagedAndSorted 
 ( 
  @sortExpression nvarchar(100),
  @startRowIndex int, 
  @maximumRows int ,
  @p_bomno varchar(35)
 ) 
 AS 
 -- Make sure a @sortExpression is specified 
 IF LEN(@sortExpression) = 0 
    SET @sortExpression = 'item_no'
    
  -- Issue query 
  DECLARE @sql nvarchar(4000)
   set @sql = 'select item_no,lowlevel_code,part_no,part_name,unit,usages,comments
                      from (select  item_no,lowlevel_code,part_no,part_name,unit,usages,comments
                           row_number() over (order by '+@sortExpression+') as rowrank
                           from bom_details  
                               where bom_no='+rtrim(@p_bomno)+' ) as a
                               where and rowrank >'+convert(nvarchar(10),@startRowIndex)+
                               ' and rowrank <=('+convert(nvarchar(10),@startRowIndex)+' + '+
                               convert(nvarchar(10),@maximumRows)+')'
 
 select a.item_no,a.lowlevel_code,a.part_no,a.part_name,a.unit,a.usages,a.comments
                      from (select  item_no,lowlevel_code,part_no,part_name,unit,usages,comments,
                           ROW_NUMBER() OVER(ORDER BY part_no asc) as rowrank
                           --row_number() over (order by 'part_no') as rowrank
                           from bom_details  
                         where bom_no='bb' ) as a
                          where  a.rowrank >1 and a.rowrank <=10
 */
  /* SET @sql = 'SELECT ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit,
                      UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued,
                      CategoryName, SupplierName 
                      FROM (SELECT ProductID, ProductName, p.SupplierID, p.CategoryID, 
                             QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, 
                             ReorderLevel, Discontinued, 
                             c.CategoryName, s.CompanyName AS SupplierName, 
                             ROW_NUMBER() OVER (ORDER BY ' + @sortExpression + ') AS RowRank 
                      FROM Products AS p 
                             INNER JOIN Categories AS c ON 
                                   c.CategoryID = p.CategoryID 
                             INNER JOIN Suppliers AS s 
                                   ON s.SupplierID = p.SupplierID) AS ProductsWithRowNumbers 
                      WHERE RowRank > ' + CONVERT(nvarchar(10), @startRowIndex) + 
                             ' AND RowRank <= (' + CONVERT(nvarchar(10), @startRowIndex) + ' + ' + 
                             CONVERT(nvarchar(10), @maximumRows) + ')' 
  */
  -- Execute the SQL query 
  --EXEC sp_executesql @sql
  
  /*
   declare @partno varchar(35),@sql nvarchar(4000),@sortExpression varchar(35), @maximumRows int,@startRowIndex int
 
 select @partno='bb', @sortExpression='part_no',@startRowIndex=0,@maximumRows=10
 
 set @sql='select a.item_no,a.lowlevel_code,a.part_no,a.part_name,a.unit,a.usages,a.comments
                      from (select  item_no,lowlevel_code,part_no,part_name,unit,usages,comments,
                           ROW_NUMBER() OVER(ORDER BY '+@sortExpression+' asc) as rowrank
                           from bom_details  
                         where bom_no='''+@partno+''' ) as a
                          where  a.rowrank >'+convert(nvarchar(10),@startRowIndex)+' and
                                 a.rowrank <=('+convert(nvarchar(10),@startRowIndex)+' + '+
                               convert(nvarchar(10),@maximumRows)+')'

 EXEC sp_executesql @sql
  */

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
--Dec 13,2008 begin
--create  PROCEDURE GetBomdetailsSorted as
-- drop proc GetBomdetailsSorted
    ALTER PROCEDURE GetBomdetailsSorted
--CREATE PROCEDURE GetProductsPagedAndSorted 
 ( 
  @sortExpression nvarchar(100),
  @startRowIndex int, 
  @maximumRows int ,
  @p_bomno varchar(35),
  @p_usercode   varchar(35),
  @rowcount int output
 ) 
 AS 
 -- Make sure a @sortExpression is specified 
 declare @StartRecord int,@EndRecord int
 
 IF LEN(@sortExpression) = 0 or @sortExpression is null
    SET @sortExpression = 'item_no'
 
 SET @StartRecord = (@startRowIndex - 1) * @maximumRows + 1
 
-- Find last record on selected page
SET @EndRecord = @startRowIndex * @maximumRows

 select @rowcount=COUNT(*) from bom_details where lower(bom_no) like '%'+lower(rtrim(@p_bomno))+'%' and operator = @p_usercode
  -- Issue query 
  declare @sql nvarchar(4000)
   set @sql='select a.id_num,a.item_no,a.lowlevel_code,a.part_no,a.part_name,a.unit,a.usages,a.comments
                      from (select  id_num,item_no,lowlevel_code,part_no,part_name,unit,usages,comments,
                           ROW_NUMBER() OVER(ORDER BY '+@sortExpression+' desc) as rowrank
                           from bom_details  
                         where operator = '''+rtrim(@p_usercode)+''' and lower(bom_no)='''+lower(rtrim(@p_bomno))+''' ) as a
                          where  a.rowrank >='+convert(nvarchar(10),@StartRecord)+' and
                              a.rowrank <=('+convert(nvarchar(10),@EndRecord)+' ) '
                              --   a.rowrank <=('+convert(nvarchar(10),@startRowIndex)+' + '+
                              -- convert(nvarchar(10),@maximumRows)+')'
  EXEC sp_executesql @sql
  
  go


  /*
declare @p7 int
set @p7=0
declare @p8 int
set @p8=0
exec sp_executesql N'EXEC @RETURN_VALUE = [dbo].[GetBomdetailsSorted] @sortExpression = @p0, @startRowIndex = @p1, @maximumRows = @p2, @p_bomno = @p3, @rowcount = @p4 OUTPUT',N'@p0 nvarchar(4000),@p1 int,@p2 int,@p3 varchar(2),@p4 int output,@RETURN_VALUE int output',@p0=null,@p1=1,@p2=3,@p3='bb',@p4=@p7 output,@RETURN_VALUE=@p8 output
select @p7 as row, @p8
  */

--Dec 13,2008 begin  
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------


  /*
  	[Function(Name="GetBomdetailsSorted")]
    public ISingleResult<bom_detail> GetBomdetailsSorted([Parameter(DbType = "NVarChar(100)")] string sortExpression, [Parameter(DbType = "Int")] System.Nullable<int> startRowIndex, [Parameter(DbType = "Int")] System.Nullable<int> maximumRows, [Parameter(DbType = "VarChar(35)")] string p_bomno, [Parameter(DbType = "Int")] ref System.Nullable<int> rowcount)
    {
        IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), sortExpression, startRowIndex, maximumRows, p_bomno, rowcount);
        rowcount = ((System.Nullable<int>)(result.GetParameterValue(4)));
        return ((ISingleResult<bom_detail>)(result.ReturnValue));
    }
  */
  

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
    ALTER PROCEDURE GetBomSorted
--CREATE PROCEDURE GetBomSorted as
 ( 
  @sortExpression nvarchar(100),
  @sortDirection  varchar(15),
  @startRowIndex int, 
  @maximumRows int ,
  @p_bomno varchar(35),
  @p_usercode          varchar(35),
  @rowcount int output
 ) 
 AS 
 -- Make sure a @sortExpression is specified 
 IF LEN(@sortExpression) = 0 or @sortExpression is null
    SET @sortExpression = 'bom_no'
-- select @maximumRows = @maximumRows+1
 if @startRowIndex>1
    select @startRowIndex=(@startRowIndex-1)*@maximumRows+1
 select @rowcount=COUNT(*) from bom_title where lower(bom_no) like '%'+lower(rtrim(@p_bomno))+'%' and operator = @p_usercode
  -- Issue query 
  declare @sql nvarchar(4000)
   set @sql='select a.id_num,a.bom_no,a.bom_name,a.bom_description,a.bom_level,a.drawing_no,a.client_no,a.category,a.categoryID,
       a.unit,a.dimension,a.package_no  
                      from (select  id_num,bom_no,bom_name,bom_description,bom_level,drawing_no,client_no,category,categoryID,
                                   unit,dimension,package_no,ROW_NUMBER() OVER(ORDER BY '+@sortExpression+' '+rtrim(@sortDirection)+') as rowrank
                           from bom_title
                         where operator = '''+rtrim(@p_usercode)+''' and lower(bom_no) like ''%''+'''+lower(rtrim(@p_bomno))+'''+''%'' ) as a
                        -- left join category as c on a.category = c.category
                          where  a.rowrank >='+convert(nvarchar(10),@startRowIndex)+' and
                                 a.rowrank <('+convert(nvarchar(10),@startRowIndex)+' + '+
                               convert(nvarchar(10),@maximumRows)+')'
--print @sql
  EXEC sp_executesql @sql
  
  go
  
--Dec 19,2008 end
-------------------------------------------------------------
-------------------------------------------------------------

/*
    [Function(Name = "GetBomSorted")]
    public ISingleResult<Bom> GetBomSorted([Parameter(DbType = "NVarChar(100)")] string sortExpression, [Parameter(DbType = "VarChar(15)")] string sortDirection, [Parameter(DbType = "Int")] System.Nullable<int> startRowIndex, [Parameter(DbType = "Int")] System.Nullable<int> maximumRows, [Parameter(DbType = "VarChar(35)")] string p_bomno, [Parameter(DbType = "Int")] ref System.Nullable<int> rowcount)
    {
        IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), sortExpression, sortDirection, startRowIndex, maximumRows, p_bomno, rowcount);
        rowcount = ((System.Nullable<int>)(result.GetParameterValue(5)));
        return ((ISingleResult<Bom>)(result.ReturnValue));
    }
*/
/*
declare @p8 int
set @p8=5
declare @p9 int
set @p9=0
exec sp_executesql N'EXEC @RETURN_VALUE = [dbo].[GetBomSorted] @sortExpression = @p0, @sortDirection = @p1, @startRowIndex = @p2, @maximumRows = @p3, @p_bomno = @p4, @rowcount = @p5 OUTPUT',N'@p0 nvarchar(4000),@p1 varchar(4),@p2 int,@p3 int,@p4 varchar(1),@p5 int output,@RETURN_VALUE int output',@p0=NULL,@p1='desc',@p2=1,@p3=10,@p4='%',@p5=@p8 output,@RETURN_VALUE=@p9 output
select @p8, @p9
*/

/*
//http://www.eggheadcafe.com/tutorials/aspnet/e07f0f1a-4243-4050-8278-00d32b2e5121/aspnet--sorting-a-gridv.aspx
//http://www.aspdotnetcodes.com/Custom_Sorting_Paging_GridView.aspx
*/