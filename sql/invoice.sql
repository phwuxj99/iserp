-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='inv_GetSuspendCpoClient')
		drop proc inv_GetSuspendCpoClient
	go

create proc inv_GetSuspendCpoClient   
                  @p_country        varchar(65),
                  @p_region         varchar(65),
                  @p_usercode       varchar(35)
             with encryption as

  if @p_region is not null
  select cname,cname_code from erpclient where cname_code in ( select distinct cname_code from cpo where finished = '0'   and operator = @p_usercode)
  			and locationID = @p_region and countryID = @p_country   and operator = @p_usercode
 else
  select cname,cname_code from erpclient where cname_code in ( select distinct cname_code from cpo where finished = '0'   and operator = @p_usercode)   and operator = @p_usercode

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='inv_GetInvClient')
		drop proc inv_GetInvClient
	go
	
create proc inv_GetInvClient   
                 @p_country        varchar(65),
                 @p_region         varchar(65),
                 @p_usercode   varchar(35)
                             with encryption as

  if @p_region is not null
  select cname,cname_code from erpclient where cname_code in ( select distinct cname_code from invoice where    operator = @p_usercode)
  			and  locationID = @p_region and countryID = @p_country     and operator = @p_usercode
 else
  select cname,cname_code from erpclient where cname_code in ( select distinct cname_code from invoice where   operator = @p_usercode)   and operator = @p_usercode

 go


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='inv_GetSuspendCpo')
		drop proc inv_GetSuspendCpo
	go
	
create proc inv_GetSuspendCpo   @p_cname_code     varchar(35),
                                @p_usercode   varchar(35)
                          with encryption as

  select *,qty-qty_inv as 'qty_avail' from cpo where cname_code in 
   (select cname_code from erpclient  where cname_code = @p_cname_code   and operator = @p_usercode)
    and qty>qty_inv   and operator = @p_usercode

 go 


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='inv_add')
		drop proc inv_add
	go
	
create proc inv_add             @p_invoiceno varchar(35),
	                              @p_cpo_id_num    int,
	                              @p_qty       int,
	                              @p_usercode   varchar(35),
                                @isvalid     varchar(250)  output
                          with encryption as

	declare @partno      varchar(35),
	        @price       decimal(12,2), 
	        @cpono       varchar(35),
	        @itemno      int,
	        @partno_id   int,
	        @soprice     decimal(12,2), 
	        @description varchar(153),
	        @qty_avail   int,
	        @qty_invoice int,
	        @cname       varchar(200),
	        @cname_code  varchar(65)
	
	select @cname_code=cname_code,@partno=part_no,@qty_invoice=qty_inv,
	       @qty_avail = qty,@soprice=soprice,@cpono=cpono from cpo
	         where id_num=@p_cpo_id_num   and operator = @p_usercode

 	if (@cname_code='' or @partno='' or @p_qty<1 or  @qty_avail<1 or @soprice<1 or @cpono='' or @p_invoiceno='')
	begin
		select @isvalid = 'Empty Error.'
		return -900
	end

  select @cname = cname from erpclient where cname_code = @cname_code   and operator = @p_usercode
  
  if exists (select * from invoice where cpono_id_num = @p_cpo_id_num   and operator = @p_usercode)
     begin
	     select @qty_invoice=sum(qty) from invoice where cpono_id_num = @p_cpo_id_num   and operator = @p_usercode
	     if exists (select * from cpo where id_num = @p_cpo_id_num  and qty<@qty_invoice+@p_qty   and operator = @p_usercode)
			  begin
							select @isvalid = 'Error, Double Add or Over QTY.!!'
							return -200
			  end
     end
  else
  	 select @qty_invoice=0


	if( @p_qty>1 )
		select @qty_avail = @qty_avail - @qty_invoice
	else
		select 	@qty_avail = @p_qty

	select @description=part_description,@partno_id=id_num from partno where part_no=@partno   and operator = @p_usercode

  if (select count(*) from invoice where invoiceno=@p_invoiceno   and operator = @p_usercode)<1
    select @itemno = '1'
  else 
  	select @itemno = count(*)+1 from invoice where invoiceno=@p_invoiceno   and operator = @p_usercode

	begin tran
		save tran tran_add_apsinvoice

  update cpo set qty_inv=isnull(qty_inv,0) + @qty_avail where id_num = @p_cpo_id_num   and operator = @p_usercode
  
	if @@rowcount=0
  begin
		rollback tran tran_add_invoice
		commit tran
  	select @isvalid='Update CPO '+rtrim(@partno)+' invoice qty failed.Contact admin'
  	return -100
  end

	insert invoice(invoiceno,invoicedate,cname,cname_code,part_no,part_no_id,
	                    partno_description,cpono,cpono_id_num,itemno,qty,qtyp,paidprice,uprice,flag,op_date,operator)
	       values(@p_invoiceno,convert(char,getdate(),101),@cname,@cname_code,@partno,@partno_id,
	                    @description,@cpono,@p_cpo_id_num,@itemno,@qty_avail,@qty_avail,@qty_avail*@soprice,@soprice,'single',getdate(),@p_usercode)
	if @@rowcount=0
	begin
		rollback tran tran_add_invoice
		commit tran
		select @isvalid = 'Invoice '+rtrim(@partno)+ 'add failed, contact admin.'
		return -100
	end

	commit tran
	
	select @isvalid = 'Invoice '+rtrim(@partno)+ ' add successful.'

	return 0

	go



-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
--October 13,2009 begin
--create  PROCEDURE GetINVSorted as
-- drop proc GetINVSorted
  ALTER PROCEDURE GetINVSorted
--CREATE PROCEDURE GetINVSorted 
 ( 
  @sortExpression nvarchar(100),
  @sortDirection  varchar(15),
  @startRowIndex int, 
  @maximumRows int ,
  @p_invoiceno varchar(35),
  @p_cname_code varchar(35),
  @p_usercode   varchar(35),
  @rowcount int output
 ) 
 AS 

	 -- Make sure a @sortExpression is specified 
	 declare @StartRecord int,@EndRecord int,@tmpCnameCode varchar(35)
	 	 declare @sql nvarchar(4000)

	 set @tmpCnameCode = rtrim(@p_cname_code)

	 IF LEN(@sortExpression) = 0 or @sortExpression is null
	    SET @sortExpression = 'invoiceno'

	 SET @StartRecord = (@startRowIndex - 1) * @maximumRows + 1

	-- Find last record on selected page
	SET @EndRecord = @startRowIndex * @maximumRows

--   create table #tmpcpono(cpono varchar(35))
  if @tmpCnameCode='%'
  begin
	 select @rowcount=COUNT(distinct invoiceno) from invoice where lower(invoiceno) like '%'+lower(rtrim(@p_invoiceno))+'%' and operator =  rtrim(@p_usercode) and lower(cname_code) = lower(rtrim(@tmpCnameCode))
	  -- Issue query 
	 set @sql=' select aa.invoiceno,min(c.op_date) as op_date from (select a.invoiceno 
	                      from (select  invoiceno,
	                           ROW_NUMBER() OVER(ORDER BY '+@sortExpression +' '+rtrim(@sortDirection)+' ) as rowrank
	                           from invoice  
	                         where operator =  '''+ rtrim(@p_usercode) +''' and 
	                         lower(invoiceno) like '''+lower(rtrim(@p_invoiceno))+'%'+''' group by invoiceno ) as a
	                          where  a.rowrank >='+convert(nvarchar(10),@StartRecord)+' and
	                          
	                              a.rowrank <=('+convert(nvarchar(10),@EndRecord)+' )) as aa 
	                              left join invoice c  on aa.invoiceno=c.invoiceno group by aa.invoiceno  order by op_date desc'

	end
  else if @tmpCnameCode is null or @tmpCnameCode='' or len(@tmpCnameCode)<1
  begin
		 select @rowcount=COUNT(distinct invoiceno) from invoice where lower(invoiceno) like '%'+lower(rtrim(@p_invoiceno))+'%' and operator =  rtrim(@p_usercode) 
	  -- Issue query 
	 set @sql=' select aa.invoiceno,min(c.op_date) as op_date from (select a.invoiceno 
	                      from (select  invoiceno,
	                           ROW_NUMBER() OVER(ORDER BY '+@sortExpression +' '+rtrim(@sortDirection)+' ) as rowrank
	                           from invoice  
	                         where operator =  '''+ rtrim(@p_usercode) +''' and 
	                         lower(invoiceno) like '''+lower(rtrim(@p_invoiceno))+'%'+''' group by invoiceno ) as a
	                          where  a.rowrank >='+convert(nvarchar(10),@StartRecord)+' and
	                          
	                              a.rowrank <=('+convert(nvarchar(10),@EndRecord)+' )) as aa 
	                              left join invoice c  on aa.invoiceno=c.invoiceno group by aa.invoiceno  order by op_date desc'

--  print @sql
end
else
begin
	 select @rowcount=COUNT(distinct invoiceno) from invoice where lower(invoiceno) like '%'+lower(rtrim(@p_invoiceno))+'%' and operator =  rtrim(@p_usercode) and lower(cname_code) = lower(rtrim(@tmpCnameCode))
	  -- Issue query 
	 set @sql=' select aa.invoiceno,min(c.op_date) as op_date from (select a.invoiceno 
	                      from (select  invoiceno,
	                           ROW_NUMBER() OVER(ORDER BY '+@sortExpression +' '+rtrim(@sortDirection)+' ) as rowrank
	                           from invoice  
	                         where operator =  '''+ rtrim(@p_usercode) +''' and lower(cname_code) =  '''+ lower(rtrim(@tmpCnameCode)) +''' and
	                         lower(invoiceno) like '''+lower(rtrim(@p_invoiceno))+'%'+''' group by invoiceno ) as a
	                          where  a.rowrank >='+convert(nvarchar(10),@StartRecord)+' and
	                          
	                              a.rowrank <=('+convert(nvarchar(10),@EndRecord)+' )) as aa 
	                              left join invoice c  on aa.invoiceno=c.invoiceno group by aa.invoiceno  order by op_date desc'

	end
  EXEC sp_executesql @sql

  --select a.invoiceno,min(c.op_date) as op_date from #tmpcpono a 
  --		left join invoice c  on a.invoiceno=c.invoiceno  
  --				group by a.invoiceno 
  --						order by op_date desc

  go
  
  
 /*
declare @p9 int
set @p9=NULL
declare @p10 int
set @p10=NULL
exec sp_executesql N'EXEC @RETURN_VALUE = [GetINVSorted] @sortExpression = @p0, @sortDirection = @p1, @startRowIndex = @p2, @maximumRows = @p3, @p_invoiceno = @p4, @p_cname_code = @p5, @rowcount = @p6 OUTPUT',N'@p0 nvarchar(4000),@p1 varchar(4),@p2 int,@p3 int,@p4 varchar(8000),@p5 varchar(2),@p6 int output,@RETURN_VALUE int output',@p0=NULL,@p1='desc',@p2=1,@p3=10,@p4='',@p5='11',@p6=@p9 output,@RETURN_VALUE=@p10 output
select @p9, @p10

*/

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='inv_Print')
		drop proc inv_Print
	go
	
create proc inv_Print   @p_Invoiceno     varchar(35),
                        @p_usercode   varchar(35)
                          with encryption as

	select invoiceno,invoicedate,cpono,part_no,qty,uprice,paidprice,cname from invoice
		where invoiceno = @p_Invoiceno and operator = @p_usercode
	
	return 0

 go 

