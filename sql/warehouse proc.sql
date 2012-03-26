------------------------------------------------------------
------------------------------------------------------------
if exists (select * from sysobjects where name='Update_warehouse_MaxMin')
	drop proc Update_warehouse_MaxMin
go

create proc Update_warehouse_MaxMin @p_partno varchar(35)	,
                                    @p_idnum  int,
                                    @p_min    int,
                                    @p_max    int,
                                    @p_usercode   varchar(35),
                                    @isvalid varchar(255) output
        as
  update warehouse set qty_min = @p_min,
                       qty_max = @p_max
                   where part_no = @p_partno and id_num=@p_idnum and operator =@p_usercode 
	 if @@rowcount = 0
		 begin
		 	select @isvalid =  'Update error. Contact Admin.'
		 	return -102
		 end

	 	select @isvalid =  'SUCCESS'

 return 0

 go


-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
    ALTER PROCEDURE GetWarehouseSorted
--CREATE PROCEDURE GetWarehouseSorted as
 (
  @sortExpression nvarchar(100),
  @sortDirection  varchar(15),
  @startRowIndex int, 
  @maximumRows int ,
  @p_partno varchar(35),
  @p_brand  varchar(65),
  @p_series varchar(65),
  @p_model  varchar(65),
  @p_usercode   varchar(35),
  @rowcount int output
 )
 AS 
 -- Make sure a @sortExpression is specified 
 IF LEN(@sortExpression) = 0 or @sortExpression is null
    SET @sortExpression = 'part_no'
-- select @maximumRows = @maximumRows+1
 if @startRowIndex>1
    select @startRowIndex=(@startRowIndex-1)*@maximumRows+1
 select @rowcount=COUNT(*) from warehouse where lower(part_no) like '%'+lower(rtrim(@p_partno))+'%'
  -- Issue query 
  declare @sql nvarchar(4000)
   set @sql='select a.id_num,a.part_no,a.qty,a.part_name,a.qty_min,a.qty_max,a.brand,a.series,a.model
                      from (select  id_num,part_no,qty,part_name,qty_min,qty_max,brand,series,model,
                             ROW_NUMBER() OVER(ORDER BY '+@sortExpression+' '+rtrim(@sortDirection)+') as rowrank
                         			  from warehouse
                         					where lower(part_no) like ''%''+'''+lower(rtrim(@p_partno))+'''+''%''  and
                         					      LOWER(brand)  like ''%''+'''+LOWER(rtrim(@p_brand))+'''+''%'' and
                         					      LOWER(series) like ''%''+'''+LOWER(rtrim(@p_series))+'''+''%'' and
                         					      LOWER(model)  like ''%''+'''+LOWER(rtrim(@p_model))+'''+''%'' and
                         					      operator =  '''+ rtrim(@p_usercode) +'''
                         		) as a
                          where  a.rowrank >='+convert(nvarchar(10),@startRowIndex)+' and
                                 a.rowrank <('+convert(nvarchar(10),@startRowIndex)+' + '+
                               convert(nvarchar(10),@maximumRows)+')'
  -- print @sql
  EXEC sp_executesql @sql

  go


/*
declare @p12 int
set @p12=NULL
declare @p13 int
set @p13=NULL
exec sp_executesql N'EXEC @RETURN_VALUE = [GetWarehouseSorted] @sortExpression = @p0, @sortDirection = @p1, @startRowIndex = @p2, @maximumRows = @p3, @p_partno = @p4, @p_brand = @p5, @p_series = @p6, @p_model = @p7, @p_usercode = @p8, @rowcount = @p9 OUTPUT',N'@p0 nvarchar(4000),@p1 varchar(4),@p2 int,@p3 int,@p4 varchar(8000),@p5 varchar(1),@p6 varchar(1),@p7 varchar(1),@p8 varchar(12),@p9 int output,@RETURN_VALUE int output',@p0=NULL,@p1='desc',@p2=1,@p3=15,@p4='',@p5='%',@p6='%',@p7='%',@p8='infocccadmin',@p9=@p12 output,@RETURN_VALUE=@p13 output
select @p12, @p13
*/
